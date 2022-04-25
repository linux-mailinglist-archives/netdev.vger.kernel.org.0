Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857F750DA0D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiDYH2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbiDYH2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:28:15 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F9D65AB;
        Mon, 25 Apr 2022 00:25:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d5so4258921wrb.6;
        Mon, 25 Apr 2022 00:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I4GdfGITkr36llpJpIInQxdraUU1II/oE1T0iv3G4VM=;
        b=kt8tPEascplqBcRqMIZPUokleiH73TFyzENUekQT2ZY0hxcfComv2pdVnREMWGy5k7
         oG/kODXbpsClznvKqkQstzSUoHtHij7FCSV0bJ+rupr7lD6EkVKFU4UiGUgkiy07QYe5
         JIVSYJ++1EkEK9O5VFTfPypRYXDPKPokQOISCmgnVKe6AuQ7Cv/Q7dN9tLBd/ZAvj1HE
         EY66+1TrmiPiG0dzYxQNGxR3nI7lCl7f/JA2FY/N1wL5liJs7DRHX7UAwM/K241RQFoY
         /fdQceJMCHNqdubMaAtsgm7H3WgXZYAsEG8bK9os4TEkNLyfLO8AGeRSlkxKuZAic8qC
         RN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I4GdfGITkr36llpJpIInQxdraUU1II/oE1T0iv3G4VM=;
        b=pCJG0p7tOZUb8HUJD+HTzfkrI+IHky+YB71upLf/W10NALVoW3xf23FpIT7GVNVXRq
         f/yjso+Ypp05N4HyW9vfvuUIlamZIvMs7d1U5Je00r76uTYsYuaF2pWTI7e64/P8cx/7
         NOQqrHMXXHSMKb6XtrgO+d0iirfYjvoHXtiJKfgPX6NTmJiNTKp3kUCRyYKq1p+HDdXj
         1wLiFr3ydwA+nUz33wDsGTljBTLAEhPKlDcYSvv4Dsuh3bHqfYilC6QUlA6XOTLJea2q
         GQg+sJ6EUXGfMr90SBO+vuF28JfkVH/SooMR9zv69kSrgvvgrJu4jA4nFx0dfIGGrZsh
         HUCw==
X-Gm-Message-State: AOAM5331Ze+88IVtTn2w/s5S5ThnmWka4bLP42NERGJKsW48T+J8hwYY
        DbbpFCSokrbqDjuDW/ViBqg=
X-Google-Smtp-Source: ABdhPJzwu6NIqK4qIa/Z/Lzk1+YjbYusz1FbJEzKkF2kg31EiJ1+xROtealw6OxzM+timpeGyqiUHA==
X-Received: by 2002:adf:e10a:0:b0:20a:86a3:d06f with SMTP id t10-20020adfe10a000000b0020a86a3d06fmr13416453wrz.249.1650871510393;
        Mon, 25 Apr 2022 00:25:10 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id p2-20020a1c7402000000b0038159076d30sm10751668wmc.22.2022.04.25.00.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 00:25:08 -0700 (PDT)
Date:   Mon, 25 Apr 2022 09:25:06 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCH perf/core 3/5] perf tools: Move libbpf init in
 libbpf_init function
Message-ID: <YmZM0kd7uWqPOu0x@krava>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-4-jolsa@kernel.org>
 <YmLf3PQ9ws2C/Myu@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmLf3PQ9ws2C/Myu@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 02:03:24PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Apr 22, 2022 at 12:00:23PM +0200, Jiri Olsa escreveu:
> > Moving the libbpf init code into single function,
> > so we have single place doing that.
> 
> Cherry picked this one, waiting for Andrii to chime in wrt the libbpf
> changes, if its acceptable, how to proceed, i.e. in what tree to carry
> these?

I think at this point it's ok with either yours perf/core or bpf-next/master,
I waited for them to be in sync for this ;-)

but as you pointed out there's issue with perf linked with dynamic libbpf,
because the current version does not have the libbpf_register_prog_handler
api that perf needs now.. also it needs the fix and api introduced in this
patchset

I'll check and perhaps we can temporirly disable perf/bpf prologue generation
for dynamic linking..? until the libbpf release has all the needed changes

jirka

> 
> - Arnaldo
>  
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/util/bpf-loader.c | 27 ++++++++++++++++++---------
> >  1 file changed, 18 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > index b72cef1ae959..f8ad581ea247 100644
> > --- a/tools/perf/util/bpf-loader.c
> > +++ b/tools/perf/util/bpf-loader.c
> > @@ -99,16 +99,26 @@ static int bpf_perf_object__add(struct bpf_object *obj)
> >  	return perf_obj ? 0 : -ENOMEM;
> >  }
> >  
> > +static int libbpf_init(void)
> > +{
> > +	if (libbpf_initialized)
> > +		return 0;
> > +
> > +	libbpf_set_print(libbpf_perf_print);
> > +	libbpf_initialized = true;
> > +	return 0;
> > +}
> > +
> >  struct bpf_object *
> >  bpf__prepare_load_buffer(void *obj_buf, size_t obj_buf_sz, const char *name)
> >  {
> >  	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = name);
> >  	struct bpf_object *obj;
> > +	int err;
> >  
> > -	if (!libbpf_initialized) {
> > -		libbpf_set_print(libbpf_perf_print);
> > -		libbpf_initialized = true;
> > -	}
> > +	err = libbpf_init();
> > +	if (err)
> > +		return ERR_PTR(err);
> >  
> >  	obj = bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
> >  	if (IS_ERR_OR_NULL(obj)) {
> > @@ -135,14 +145,13 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
> >  {
> >  	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = filename);
> >  	struct bpf_object *obj;
> > +	int err;
> >  
> > -	if (!libbpf_initialized) {
> > -		libbpf_set_print(libbpf_perf_print);
> > -		libbpf_initialized = true;
> > -	}
> > +	err = libbpf_init();
> > +	if (err)
> > +		return ERR_PTR(err);
> >  
> >  	if (source) {
> > -		int err;
> >  		void *obj_buf;
> >  		size_t obj_buf_sz;
> >  
> > -- 
> > 2.35.1
> 
> -- 
> 
> - Arnaldo
