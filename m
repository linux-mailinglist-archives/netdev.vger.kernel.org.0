Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5570F66D576
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 05:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjAQEyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 23:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbjAQEyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 23:54:33 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E83C2366B;
        Mon, 16 Jan 2023 20:54:32 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id p66so14459754iof.1;
        Mon, 16 Jan 2023 20:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkSg/q1Z7ZmYwbTdwhXsusGtpsp5n/kWlb9K8M32Z80=;
        b=NS6CNkn2N7Ruposkuk5FIQMhZOkRZhrKW2xAoM8cgV8P0+W2Bf42fs7WTrSTV7cyT8
         +SScqCDlIdGQgdxihqfkFE15c9CXyTiIXh6pyP6EXMPWph9d4wFDrlrHNjM2FdUwWpCv
         3A6E1M/Q6Q96Q9VdM9ViWwVWvsIZnS/TIxuQxfi8zJX7kexDS5uXPoeEehGWKa5wOHrR
         3zaKuFOm4wsac6fgXQVFailYK4rrlidxOvQGOMYjw5qtF2juwrIoS2RRqNH5SuoLbCKf
         D3oh6KYUND4c9OUmEIfmmq5r8RLovgACpfKPex4xExPaBGUDKVYLB2sOuJb1OXWQXhU/
         YDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkSg/q1Z7ZmYwbTdwhXsusGtpsp5n/kWlb9K8M32Z80=;
        b=c+0BPRYVX3FZHcebA7D3KsmBkv7Ole7wTRQAawqHS4FDPZqjRKnEcqhWTT+9BoOWwl
         UkNmN/KLOCi5WMmU1hLYC8XATVQdu/MxoFO9jpggi+CeTF83Lbn10/0AAM/OLBUz7wJE
         4snPYKTA08HIqOZVzwdKw89fid7rxa0U+ocG6oikWC4m0LaEUaE65x3C58H9fKBl8NK0
         xgl0yj49QAtHKKDEPptw5dFcZGvBV7c7wh+3dgONTMh2LIf70ZYGMU8lgQD+eBeM3EfS
         Wzw0nNh64t8vgjZF62ulbBH7OrWlsZuM69pFkULOlAEGTLRibNnJcj+7Tx02sIriGw3y
         WsMg==
X-Gm-Message-State: AFqh2kpdKQm0gS6+eLYVDg6p+8NTtfL08PBisLs4rfhlpjYcFYVMsN3/
        UMgbB6edhn8s6x5qEzh+V+cxPDltNPE=
X-Google-Smtp-Source: AMrXdXvbEAZH4poFtVLAzFxzQGp/vXVTL6ajaZJjCsF3vaz+d2zHS2GcmDPWaiWnWdImey5dMyK1bQ==
X-Received: by 2002:a5e:df05:0:b0:6f3:dec1:5474 with SMTP id f5-20020a5edf05000000b006f3dec15474mr1230720ioq.5.1673931272068;
        Mon, 16 Jan 2023 20:54:32 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8? ([2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8])
        by smtp.googlemail.com with ESMTPSA id h7-20020a05660208c700b00704a77b7b28sm2604728ioz.54.2023.01.16.20.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 20:54:31 -0800 (PST)
Message-ID: <becf01ac-e9cb-d2f9-5805-d1839c3f9656@gmail.com>
Date:   Mon, 16 Jan 2023 21:54:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in
 skbuff_setattr
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, Paul Moore <paul@paul-moore.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
 <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
 <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
 <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/23 12:33 PM, Xin Long wrote:
>> We really should have a solution that allows CIPSO for both normal and
>> BIG TCP, if we don't we force distros and admins to choose between the
>> two and that isn't good.  We should do better.  If skb->len > 64k in
>> the case of BIG TCP, how is the packet eventually divided/fragmented
>> in such a way that the total length field in the IPv4 header doesn't
>> overflow?  Or is that simply handled at the driver/device layer and we
>> simply set skb->len to whatever the size is, regardless of the 16-bit
> Yes, for BIG TCP, 16-bit length is set to 0, and it just uses skb->len
> as the IP packet length.
> 
>> length limit?  If that is the case, does the driver/device layer
>> handle copying the IPv4 options and setting the header/total-length
>> fields in each packet?  Or is it something else completely?
> Yes, I think the driver/device layer will handle copying the IPv4 options
> and setting the header/total-length, and that's how it works.

IPv4 options, like TCP options, should be part of the header that gets
replicate across GSO sliced packets by the hardware. ie., both should be
transparent to well designed hardware (and for h/w that made poor
choices standard 64kB GSO is the limit for its users).

