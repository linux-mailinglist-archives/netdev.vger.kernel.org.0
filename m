Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42525292F0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348180AbiEPVex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiEPVew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:34:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3745D403CA;
        Mon, 16 May 2022 14:34:50 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so31040722ejj.10;
        Mon, 16 May 2022 14:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fItWFiuyh1cGZ4h69ovsW87CfNIqc4jgdwOX92BwTVQ=;
        b=D3b+CxabH8UFSwZi+XYhQEFphLXfw5Tj77C7akvzmIMfUGZDkob8OOXQZ2A/kiBAIP
         Nt/l0bEa/EDSwXGyWgLuosH28lT7yv5myJN/tFqpwl8v7XJUUVzB/1B/j6A2Xmk9VUwI
         Qhhu9rkteXgldqsSlg3Wlm/E0jJ1Hv1N52f7p0CnAUK+mk2Alb3dkxn9G5vsi6GCHloq
         K5jBr4mpbiZp3pVC77TgXTBoc7+8INMvWJHz0PLI5rRx/JN6Q3ZnfaSZMWrn9IFHcIzG
         UPzFVbh/OMJGcF2kC4YU33WHsENRmpvowT2JYGoxBu0xWzboZC/XRvCGS207ENU3168o
         0fRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fItWFiuyh1cGZ4h69ovsW87CfNIqc4jgdwOX92BwTVQ=;
        b=J1uCUdsJeTpQ+7E9ERLe56q1nlXk4bANyIz8THvaDuoS9H0eq3BP0cVpI0zaRi+65c
         klVO+cwEBm736KbkU3MVd8A+96Jpkf68sECmVt882QNW5YNGRBpwklt0wwTD3K7sMdg0
         qRbigIdawOZelrqM9qgL8JB1u2gb/J/ie6gpe2pf+iV/R+uH1w5NXj+5PlyzqBp4Tj8f
         0KwDPCF8MbimVulkPLC4Xz4MGG1ajhNctHJ+o6OKRCQBETXXhqsyMURk4l3vNLt9vwE/
         vfX8ChQ+2js2H2YbtMY8XouWGfCQqHXeCKjIIlBGb0hQTvUtwpQZnFYALyxPyvTHydGM
         Vj4w==
X-Gm-Message-State: AOAM533DKyk7xbsb+uIdkQbHQj1Kgyq4qw+/AEp9u9LkWNirOruEquo2
        t+CFQSC0K4AfeCw7EBZ0bx0=
X-Google-Smtp-Source: ABdhPJxefAwZPvKWXDdlJnNJzViw2UqAEK4X1lL4s0Y0h7DiMQqi1TWaaqOg27Q/dGkGh+f7+SdJQA==
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr16881236ejc.217.1652736888805;
        Mon, 16 May 2022 14:34:48 -0700 (PDT)
Received: from krava ([83.240.61.17])
        by smtp.gmail.com with ESMTPSA id ev6-20020a056402540600b0042aa5a74598sm3316476edb.52.2022.05.16.14.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 14:34:48 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 16 May 2022 23:34:45 +0200
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <YoLDdaObEQePcIN+@krava>
References: <20220516182708.GA29437@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516182708.GA29437@asgard.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 08:27:08PM +0200, Eugene Syromiatnikov wrote:
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Add the same check
> to kprobe_multi_resolve_syms in case it will be called from elsewhere
> in the future.
> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d8553f4..e90c4ce7 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2358,6 +2358,8 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
>  	unsigned int i;
>  	char *func;
>  
> +	if (check_mul_overflow(cnt, sizeof(*syms), &size))
> +		return -EOVERFLOW;

there was an update already:

  0236fec57a15 bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link

so this won't apply anymore, could you please rebase on top of the latest bpf-next/master?

thanks,
jirka

>  	size = cnt * sizeof(*syms);
>  	syms = kvzalloc(size, GFP_KERNEL);
>  	if (!syms)
> @@ -2429,6 +2431,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	if (!cnt)
>  		return -EINVAL;
>  
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +		return -EOVERFLOW;
>  	size = cnt * sizeof(*addrs);
>  	addrs = kvmalloc(size, GFP_KERNEL);
>  	if (!addrs)
> -- 
> 2.1.4
> 


