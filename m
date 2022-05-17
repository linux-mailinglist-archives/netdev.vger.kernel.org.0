Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE7C529699
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiEQBO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiEQBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:14:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EB741984;
        Mon, 16 May 2022 18:14:14 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 202so15624060pgc.9;
        Mon, 16 May 2022 18:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yvfLNgzj0LlML7YO1Uk64PllzBEDEnVgEw1ErIJEf1c=;
        b=fNItWEesTtzgODmxS5UzL83e0LdGMRcZUHKoHxfdsqWlRDPMw4VjeO7/83Q6yA+AjJ
         xfogqJxIzSLw/84O91UkEZGLrMFafY6nqi31d+06pn8t367x1pg4yt9jWbutGlUrk8s5
         UvjE/W0kEXSZsKM4KW07CPKGjPu1cZA02MJ12uMppQKHNF7DCAPtXBss2Y+OzaoLVPHE
         uwvr/6+FHE2ttqKrv7PhiirbSCKa8HaVPqbDbWFQzssUbW3juphOV71pChMR4JGxxKQf
         xWvy5SBA3Jvt6LR/tQ2cFvWjS9blMa97lAB5Zs8Z/apyTbzb0s8sVYV7HWN+WYj5ix13
         WdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yvfLNgzj0LlML7YO1Uk64PllzBEDEnVgEw1ErIJEf1c=;
        b=JOd3uMUxKoB8qOWj0Jm/eYx/1nG6egLKZZz0myVNWk4W6wSN+KTmCNvURZj6I8JLg5
         ppozharNJ6xXetks+A19hbV+XPRXM76cQXFK0NGemJNYrVoZBlDhGGeQLGYPJ6YqZDJy
         NtWjskK/WOVp/3/jGojB+JVN9kSxi4Ewetra0XNCjMCUWqrfqAeb0He7pXVZrHnR+23p
         K8u0hp/CG6K+3j+H4yw7OOXlF3AKs8MACjWPpxFKBFaRB2BgUWWaF2bqtNWu1Lkxqdm9
         Dib0Hpi2L21v2ryr5COCXgGLcdP+kwJ/zGw7S5EdI/uSgD/21m1cgaGtjVbVAREgKOBu
         FiYQ==
X-Gm-Message-State: AOAM530cjjg9pQQ35C6yLpSTqCFCcYoEhZQAdSPR5utqBkYI3lHAvsek
        2z9M0Ja4+BCmyVd1Dd1lkiA=
X-Google-Smtp-Source: ABdhPJz4auVTYWheSOfsiZtbJjA5qb3+6f/OJK+ZHip29RXltDL0KkzN5+jbnVcLSWEttXrtzZ1Y6w==
X-Received: by 2002:a63:9553:0:b0:3c6:25b2:9525 with SMTP id t19-20020a639553000000b003c625b29525mr17669892pgn.294.1652750053728;
        Mon, 16 May 2022 18:14:13 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:3651])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709027e8b00b0016144a84c31sm5556207pla.119.2022.05.16.18.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 18:14:13 -0700 (PDT)
Date:   Mon, 16 May 2022 18:14:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
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
Message-ID: <20220517011409.qexxrowf6b2ticid@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220516182708.GA29437@asgard.redhat.com>
 <YoLDdaObEQePcIN+@krava>
 <20220516224934.GA5013@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516224934.GA5013@asgard.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 12:49:34AM +0200, Eugene Syromiatnikov wrote:
> On Mon, May 16, 2022 at 11:34:45PM +0200, Jiri Olsa wrote:
> > On Mon, May 16, 2022 at 08:27:08PM +0200, Eugene Syromiatnikov wrote:
> > > +	if (check_mul_overflow(cnt, sizeof(*syms), &size))
> > > +		return -EOVERFLOW;
> > 
> > there was an update already:
> > 
> >   0236fec57a15 bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
> > 
> > so this won't apply anymore, could you please rebase on top of the latest bpf-next/master?
> 
> The issue that this specific check has to go in 4.18, as it covers
> possible out-of-bounds write, I'm not sure how to handle it, have
> a branch where it is merged manually?

As Jiri said, please use bpf-next.
