Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236A7575716
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 23:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbiGNVj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 17:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbiGNVjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 17:39:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F341573D;
        Thu, 14 Jul 2022 14:39:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s27so2708732pga.13;
        Thu, 14 Jul 2022 14:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgW9kAXC6VaNn9rU3wnHWjSpTrZ8/AEf3hlkouGTzLM=;
        b=c8mWRbXSajF588i3rM9y0yyoGZfg0NbyGk3jlGOuAtgVjzANWV6yySZGTzenPaeJqz
         Lr+Z+hmrpiXr84CYm/40hhnRLEn4MHNCK/RFAquVz5gVQZiZw+yyhlIf/4LnKYhylRfn
         GKYYF+mE08XAFgo709pRl5qxWjI4qzD1LnNHp18EH9lp8bMCpKrdOekGdDKLFJ9Evhn3
         oBc0R6SLnmZPDvldLIlZFx/9T07rIP/mKbzeWj4y/nWJn9kVolBIrTaG8RWDs6hOf46U
         Qd7KMF3lpTGOxcxW3nMB1eBy+aPugcSMQhRm0/gtMQWZeyhd0T1UmjnN6XBZugfMMvrs
         P4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgW9kAXC6VaNn9rU3wnHWjSpTrZ8/AEf3hlkouGTzLM=;
        b=ElNKoEb1FkH6wRwiex5RX5kxQcjy2ymSZJ5ECiTNp8pqkvHO8Gw4MolXQ7NqtG2mN/
         ucH+trAtSFWdTZyMEm5PvZYjDbdgO/nSXIIgE+A9VWnUlBnQV/hUaL+izim2GP0z1+Ou
         faDM9kbbRQJFbtdFsxSZwGmSt1Qn1PDexJqUYzJISHhJ6vXtsmqoopRka2ETElVSwBCU
         ilTSxBJV9srdlFkDoHoLtJSjmYmK5t99wkvqY6KYWRUwznLx/uldtFuXp7tPP3e/Vyb1
         lzhaH5YbspamEapbVaaOT03+tEjVAOeFm1D2Lj/BZSIWlN9hKDijZuJ9qVLKRe06kcWP
         jRGQ==
X-Gm-Message-State: AJIora+6GySdmHr4X/mq7d8tmpl5pN8Va8EBPTfOKGOZZ7/lF9DwTQQ8
        RgGdM2VscMdQLB5Q2KeTiYo=
X-Google-Smtp-Source: AGRyM1sY/NZRxlCCjWjo5j61Gv+szsCKgzp7/Bjo7JYU8bEO3/CBMFYME2TsUz3zfoxhbUOdAfyDbw==
X-Received: by 2002:a62:864f:0:b0:52a:be82:6b60 with SMTP id x76-20020a62864f000000b0052abe826b60mr10342092pfd.48.1657834756198;
        Thu, 14 Jul 2022 14:39:16 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:500::1:697a])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b0052aca106b20sm2165289pfb.202.2022.07.14.14.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:39:15 -0700 (PDT)
Date:   Thu, 14 Jul 2022 14:39:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        memxor@gmail.com
Subject: Re: [PATCH bpf-next v6 00/23] Introduce eBPF support for HID devices
Message-ID: <20220714213912.zrotlequhpgxzdl4@MacBook-Pro-3.local>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 04:58:27PM +0200, Benjamin Tissoires wrote:
> Hi,
> 
> and after a little bit of time, here comes the v6 of the HID-BPF series.
> 
> Again, for a full explanation of HID-BPF, please refer to the last patch
> in this series (23/23).
> 
> This version sees some improvements compared to v5 on top of the
> usual addressing of the previous comments:
> - now I think every eBPF core change has a matching selftest added
> - the kfuncs declared in syscall can now actually access the memory of
>   the context
> - the code to retrieve the BTF ID of the various HID hooks is much
>   simpler (just a plain use of the BTF_ID() API instead of
>   loading/unloading of a tracing program)
> - I also added my HID Surface Dial example that I use locally to provide
>   a fuller example to users

Looking great.
Before another respin to address bits in patch 12 let's land the first ~8 patches,
since they're generic useful improvements.

Kumar, could you please help review the verifier bits?
