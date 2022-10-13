Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7B75FE498
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 23:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJMVzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 17:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiJMVzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 17:55:52 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B7E13E34;
        Thu, 13 Oct 2022 14:55:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a26so6786022ejc.4;
        Thu, 13 Oct 2022 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w5fI//fDZje8za4XR0ATUNlP/wVMZ34h4K3JeGc7aGc=;
        b=i/76oYOHTriR7gowE6F3quEHmZNf2YoS2cMHar3JNp3a/EHSIleMNSpfikxeqOuE5c
         /fRaHTmZjBZbB+6I8gxBqvGRKLclivm9akcCZZBfoO/Xr8XSZ+1lds5TtxCoAp3vXoh6
         CHLKYM722YSnZj/YFglmJInQv6Gca1aeRqiTkHGxHw21E/mLpjRV+S/S5GcCV3dje1gp
         iPpAmlMbRhMCb3qSLHNXeioAQI0vLpWSB0Ikdg7A8SfgshjiCmAoZVwZXghUuASpF3WX
         I/ErhGFNdRzei+ElL81vlaiTsEU11j22t+HeSXBmdqJLh9VzlW8iR6ZJxWh540dMEF3v
         MfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5fI//fDZje8za4XR0ATUNlP/wVMZ34h4K3JeGc7aGc=;
        b=N2UTFOqexQe3h7hjm7CDrfzmYsC6M4lQOrLAvcevK6imh7OJF+B90wZrRIAAn95eod
         xkTh/camgDQ+8m2sdUStae1f2P0ZVT5bRzGlIPKH/cKRlR+QGKm/H8zYrQhpXUcE0nNr
         i30Soa8v5EeFmX9ng27nyW+6YMKxiD72fEtY9a1HQXtysFkTG02rUKlfw0aEc3Oz1jqB
         XjNkw5WdtlCIrTFOmrLnDDLKw7oLO+lcSBDu4RQrGhzHbHhZxo4EX1SfrNMDDLri2mKQ
         ZVtfIuDP9vZ5pgIZZgzr7GOqojvYgXaTQRgXRx6P8aRJGmtaLjQrVL8o+xZPCmKOvsIC
         1chA==
X-Gm-Message-State: ACrzQf2fJhtU1dAMohoZun7/TXcQbzgVun1DgFCjAtf148KIp931ApH6
        MzMKcWEiXo8Wh6CBQhiyetU+vk/UCTo=
X-Google-Smtp-Source: AMsMyM4EB6z4zehdub8H+vhm8tDvILcNV2NHaCvw3AC0mA5o5llY7qnxY82eWus6f5HtPnEHA5urJA==
X-Received: by 2002:a17:906:6791:b0:78d:4051:fcf0 with SMTP id q17-20020a170906679100b0078d4051fcf0mr1261064ejp.591.1665698144795;
        Thu, 13 Oct 2022 14:55:44 -0700 (PDT)
Received: from krava ([83.240.62.156])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b0078d21574986sm421816ejh.203.2022.10.13.14.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:55:43 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 13 Oct 2022 23:55:41 +0200
To:     Jakub Kicinski <kuba@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <Y0iJXajhKPlqjOIO@krava>
References: <20221003190545.6b7c7aba@kernel.org>
 <20221003214941.6f6ea10d@kernel.org>
 <YzvV0CFSi9KvXVlG@krava>
 <20221004072522.319cd826@kernel.org>
 <Yz1SSlzZQhVtl1oS@krava>
 <20221005084442.48cb27f1@kernel.org>
 <20221005091801.38cc8732@kernel.org>
 <Yz3kHX4hh8soRjGE@krava>
 <20221013080517.621b8d83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013080517.621b8d83@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 08:05:17AM -0700, Jakub Kicinski wrote:
> On Wed, 5 Oct 2022 22:07:57 +0200 Jiri Olsa wrote:
> > > Yeah, it's there on linux-next, too.
> > > 
> > > Let me grab a fresh VM and try there. Maybe it's my system. Somehow.  
> > 
> > ok, I will look around what's the way to install that centos 8 thing
> 
> Any luck?

yea, sorry for delay, I reproduced that.. first objtool warnings ;-)


[jolsa@centos8 linux-next]$ make
  UPD     include/generated/compile.h
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
  DESCEND bpf/resolve_btfids
  CC      init/version.o
  AR      init/built-in.a
  AR      built-in.a
  AR      vmlinux.a
  LD      vmlinux.o
vmlinux.o: warning: objtool: relocate_restore_code+0x3c: relocation to !ENDBR: next_arg+0x8
vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0x20: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
  ...



Peter,
as for objtool warnings, looks like with gcc we'll get
endbr64 instruction generated after nops

with centos gcc 8.5:

	ffffffff818d2e20 <bpf_dispatcher_xdp_func>:
	ffffffff818d2e20:       90                      nop
	ffffffff818d2e21:       90                      nop
	ffffffff818d2e22:       90                      nop
	ffffffff818d2e23:       90                      nop
	ffffffff818d2e24:       90                      nop
	ffffffff818d2e25:       f3 0f 1e fa             endbr64
	ffffffff818d2e29:       e9 92 eb 52 00          jmpq   ffffffff81e019c0 <__x86_indirect_thunk_rdx>
	ffffffff818d2e2e:       66 90                   xchg   %ax,%ax

while latest gcc 12 will put it after:

	ffffffff82736900 <bpf_dispatcher_xdp_func>:     
	ffffffff82736900:       f3 0f 1e fa             endbr64 
	ffffffff82736904:       90                      nop    
	ffffffff82736905:       90                      nop    
	ffffffff82736906:       90                      nop
	ffffffff82736907:       90                      nop
	ffffffff82736908:       90                      nop    
	ffffffff82736909:       41 54                   push   %r12
	ffffffff8273690b:       49 89 f4                mov    %rsi,%r12
	ffffffff8273690e:       55                      push   %rbp
	ffffffff8273690f:       48 89 fd                mov    %rdi,%rbp
	ffffffff82736912:       53                      push   %rbx
	ffffffff82736913:       48 89 d3                mov    %rdx,%rbx
	ffffffff82736916:       e8 65 f6 cf fe          call   ffffffff81435f80 <__sanitizer_cov_trace_pc>
	ffffffff8273691b:       4c 89 e6                mov    %r12,%rsi
	ffffffff8273691e:       48 89 ef                mov    %rbp,%rdi
	ffffffff82736921:       48 89 d8                mov    %rbx,%rax
	ffffffff82736924:       5b                      pop    %rbx
	ffffffff82736925:       5d                      pop    %rbp
	ffffffff82736926:       41 5c                   pop    %r12
	ffffffff82736928:       e9 b3 b6 8c 00          jmp    ffffffff83001fe0 <__x86_indirect_thunk_array>

any idea where's the problem? bad backport? ;-)

in any case (unrelated), I'll check the bpf dispatcher code,
I'm not sure the nop update code is aware of the endbr64 instruction

jirka
