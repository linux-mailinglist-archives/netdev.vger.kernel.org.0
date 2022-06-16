Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5312254E600
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377142AbiFPP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiFPP0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:26:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA493DDCF
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:26:20 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id n10so3453158ejk.5
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=CLrlk3rLwPIryjUKw4pEpgsAc/X+NzTC47fU7Y+cvVo=;
        b=D3HXnOMFA3IEeldjHrP1cGsLX3up9iZ0C4kaV65Y2Oh1nWPAjUdvqOIizaCW/PNkrU
         I/DOc+srhouEaxBWZXxJ8rH55vMhz17+CcyONt7beQ+ObrtGUs8Sg1q1/mpiBspVQ49c
         atWdCYV6uL0wYftcVe0E/Emgk4MpPX70dXLhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=CLrlk3rLwPIryjUKw4pEpgsAc/X+NzTC47fU7Y+cvVo=;
        b=5rEWrYDP822Zg5LQ64+Jh5U11C2/xqDjVFw8gOy4Ll36k+1HV4pf+GM+HDmNam0Zd7
         Mbtb3b/V2RzGU9FDd7sJ4qTsQMpXwqcZpgFWqbWJ40tvA5uiCsyNZT6SY+f8h1uWpsBV
         o+j/7fghn3IekwAdIfk++Ma6URmzurqvYWEoNdTAwa2zHhHn/FmVFCEK5BuFY4tmytyo
         13y/33FOcxTlTSObEbAwA2z00Dk/cdoV60fMiCLkpQ4mNiJMTZHFFNys2s/Qn9utucaQ
         pVx8AZMsFOIgeZ5QeY8yTRgMAdY+MI7JkFy6/PYcBiiObwHboTxQUqkt9NqhYyHyW/mf
         pQrA==
X-Gm-Message-State: AJIora9OuRBlhG5VwYtOKj0V9BfSDhOFQEJGiKkSdN88HQHiboBRsrQU
        clRjbOTcJuyRKF5HFHT5XaLCvA==
X-Google-Smtp-Source: AGRyM1tCW3Vz02Pr0YUsLollC51dQF/h54D1MNirGWD+KFcnPEx8ydBAN+bpj1MuPKuSiAcmJFVR3A==
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id fj2-20020a1709069c8200b006dfc5f0d456mr5062452ejc.287.1655393179302;
        Thu, 16 Jun 2022 08:26:19 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906310400b0071cbc7487e0sm173408ejx.71.2022.06.16.08.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 08:26:18 -0700 (PDT)
References: <20220616110252.418333-1-jakub@cloudflare.com>
 <YqtFgYkUsM8VMWRy@boxer>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [RFC bpf] selftests/bpf: Curious case of a successful tailcall
 that returns to caller
Date:   Thu, 16 Jun 2022 17:24:50 +0200
In-reply-to: <YqtFgYkUsM8VMWRy@boxer>
Message-ID: <877d5gwrxh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 05:00 PM +02, Maciej Fijalkowski wrote:
> On Thu, Jun 16, 2022 at 01:02:52PM +0200, Jakub Sitnicki wrote:
>> While working aarch64 JIT to allow mixing bpf2bpf calls with tailcalls, I
>> noticed unexpected tailcall behavior in x86 JIT.
>> 
>> I don't know if it is by design or a bug. The bpf_tail_call helper
>> documentation says that the user should not expect the control flow to
>> return to the previous program, if the tail call was successful:
>> 
>> > If the call succeeds, the kernel immediately runs the first
>> > instruction of the new program. This is not a function call,
>> > and it never returns to the previous program.
>> 
>> However, when a tailcall happens from a subprogram, that is after a bpf2bpf
>> call, that is not the case. We return to the caller program because the
>> stack destruction is too shallow. BPF stack of just the top-most BPF
>> function gets destroyed.
>> 
>> This in turn allows the return value of the tailcall'ed program to get
>> overwritten, as the test below test demonstrates. It currently fails on
>> x86:
>
> Disclaimer: some time has passed by since I looked into this :P
>
> To me the bug would be if test would have returned 1 in your case. If I
> recall correctly that was the design choice, so tailcalls when mixed with
> bpf2bpf will consume current stack frame. When tailcall happens from
> subprogram then we would return to the caller of this subprog. We added
> logic to verifier that checks if this (tc + bpf2bpf) mix wouldn't cause
> stack overflow. We even limit the stack frame size to 256 in such case.
>
> Cilium docs explain this:
> https://docs.cilium.io/en/latest/bpf/#bpf-to-bpf-calls

Thanks for such a quick response.

This answers my question. I should have looked in Cilium docs.

I will see how to work this bit of info into the helper docs.

[...]
