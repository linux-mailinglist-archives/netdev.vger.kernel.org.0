Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9962765A7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgIXBIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:08:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D49C0613CE;
        Wed, 23 Sep 2020 18:08:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fa1so729770pjb.0;
        Wed, 23 Sep 2020 18:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cE6kbxJapA/xGImeNyQlibbgWd632XZxtzMW9GQXlIY=;
        b=fF3VAb/JT3ALUUyrP4bI8MzaZqb2Z+buUJlU3mib/rjfyL/CVIBTnISELyGhAGpKea
         eO+ChL5TVX0SFSXjxJqObNVrGe7JT/03hwl/Ussp8QetynpmAKEOXmi9YmsFaJd0DNBi
         KfGQU/UwFwRNsKQiMcRNK1unOY+AX7qYZ7mV5Wfi01UKfZ/AGB3Q2xPqwEHPpcako0Id
         toG3tvjIeA4QBXUXew7mXka7JEclvuso5uFGfu6KN3hzCqAY+ayJjbOqLz691I78ZlNu
         ce2EciBoEg5D8BVl4FmH0O98mjF1JAIfDBQXplzVCpHM21/Jl+GvnYLwuCCaim5m55qa
         hoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cE6kbxJapA/xGImeNyQlibbgWd632XZxtzMW9GQXlIY=;
        b=KmVHX24KYR5Xldpc5VpmPXWTndUqm02cnr6YKYdwS2u7oq0oSecXnXDkvSTLQ9T5G/
         /vlWLrlf7XXstJXop6ykB8ngoQBTt3YKXCU0xbdWB6w1GAj1JOT2bexxTNg89YRchqTO
         LD0kZpcOra+VizGUsZ7kC8t8m73b7DvnhE1OT67gw0ABxT3GIKQ48F4bAiq67pcY0kAz
         qtTtXN+syEfzTtllX1cR4BTdckODC1sQBDHr/lyTcb0PdJwJryXPCTM53WfK7oHMjFyv
         mxD73MsmmPoWIp58NPGWBJsEz4qmngEb1sirdf6dpKkszAQ1HtOaA6SKNUxqPuK6ihju
         j6hg==
X-Gm-Message-State: AOAM531WD7R+cwa9zlr5cPycpc3FfGjFFGONtpS9OtXxXDYCLVxNmSuW
        F4R+sH8sBAabJm7UYynfpfo=
X-Google-Smtp-Source: ABdhPJwO1Pus5wN8eQEOnA18KWebwbb24lAjZoDStYhbInX7vXclLtaM/0rVhUq4ek3l/tbx/BPQlw==
X-Received: by 2002:a17:90b:617:: with SMTP id gb23mr1718238pjb.36.1600909694639;
        Wed, 23 Sep 2020 18:08:14 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id s24sm532315pjp.53.2020.09.23.18.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 18:08:13 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:08:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 11/11] selftests: Remove fmod_ret from
 benchmarks and test_overhead
Message-ID: <20200924010811.kwrkzdzh6za3w3fz@ast-mbp.dhcp.thefacebook.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079992560.8301.11225602391403157558.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160079992560.8301.11225602391403157558.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 08:38:45PM +0200, Toke Høiland-Jørgensen wrote:
> -const struct bench bench_trig_fmodret = {
> -	.name = "trig-fmodret",
> -	.validate = trigger_validate,
> -	.setup = trigger_fmodret_setup,
> -	.producer_thread = trigger_producer,
> -	.consumer_thread = trigger_consumer,
> -	.measure = trigger_measure,
> -	.report_progress = hits_drops_report_progress,
> -	.report_final = hits_drops_report_final,
> -};
> diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/testing/selftests/bpf/progs/trigger_bench.c
> index 9a4d09590b3d..1af23ac0c37c 100644
> --- a/tools/testing/selftests/bpf/progs/trigger_bench.c
> +++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
> @@ -45,10 +45,3 @@ int bench_trigger_fentry_sleep(void *ctx)
>  	__sync_add_and_fetch(&hits, 1);
>  	return 0;
>  }
> -
> -SEC("fmod_ret/__x64_sys_getpgid")
> -int bench_trigger_fmodret(void *ctx)
> -{
> -	__sync_add_and_fetch(&hits, 1);
> -	return -22;
> -}

why are you removing this? There is no problem here.
All syscalls are error-injectable.
I'm surprised Andrii acked this :(
