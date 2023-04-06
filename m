Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EC06D9457
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbjDFKpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbjDFKpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:45:31 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565CB7692
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:45:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i7so43111wrc.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 03:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1680777927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e/X5yNCoJN03FEX0s6l3ITYbIU68MMXGSTEXF+p6Dq0=;
        b=SIgEfc5jKNaB4oRrbei81KNYV23ULzlmk0FISTdIu/sR851YFNMw6NHHF9UDgBz+Vv
         WwWloRAsLPMy0T+PFKCewRQ+iK1/V4NL/EJvdxqwsoD2VT+aGnLAWTldg1fnSImIspvy
         tgKU/nwMHEQnGzxMprA3lA2NPgdJv6CApzP7Gghpcjzve/X6TLrTalmweL2EYEHIgs6O
         b4SM/MX9UAw17MrIknAKUWfkdTHn327HIFav7Z20QxE4W1+BhwEhpqBbfkJTL1HPGGAK
         P7mMOaNrDpPwHyY3SHqHPQF0uB2mgAiXkZyKLFdodmAPrICLaWJzhKOZ+1918w/rxfMs
         IBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680777927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/X5yNCoJN03FEX0s6l3ITYbIU68MMXGSTEXF+p6Dq0=;
        b=NyBlvfjcEwffMaHWFNZrbLFj0tyEoRZ9uPuDEivRN7bZcSavT7j3CKKWDM6tc9vcdG
         X/iZ5K4s9Ma0MBJV0Bqj9WM4wuemuriYcedYdVmD16/67Z2yqbwnKh828WFQlIoYPiQM
         qj92PKm6kyGZ4fNcp17m1PYTDe7dmIOosHo1iGz77Ct2UOFWwQSfh5KbKCwEYUH2o1ey
         XKupWmSaW3zH3/OiEtoVSv+HC9dzVecfoacrZgIiBpbEviTDcmveUvfTPKOg7KGltemJ
         7nrASIvsrxClbSNOMQ/1sdjoilsLaatlrQDe1AF1zXigO+tnsdYG3xhPEh+3i+FZJyeH
         LGUA==
X-Gm-Message-State: AAQBX9etYawzwgC8ZqbbyeKfwJ3ff6bliJS1+EZfks3fxTBxkuffdYF/
        dKhvhptiCq83Tnwd0qd+yzjPjg==
X-Google-Smtp-Source: AKy350aTJGjsCyrbFrhZ6rG/1VD6V3MRZN/K493i9Qikh/wyFp+nbHNea8eYHgMH9QrioMT4WeYJMQ==
X-Received: by 2002:adf:ce0a:0:b0:2c8:9cfe:9e29 with SMTP id p10-20020adfce0a000000b002c89cfe9e29mr5978111wrn.38.1680777926732;
        Thu, 06 Apr 2023 03:45:26 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:f3b0:f2cb:5057:6981? ([2a02:578:8593:1200:f3b0:f2cb:5057:6981])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b002cf8220cc75sm1435672wrv.24.2023.04.06.03.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 03:45:26 -0700 (PDT)
Message-ID: <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
Date:   Thu, 6 Apr 2023 12:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
References: <20230406092558.459491-1-pablo@netfilter.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230406092558.459491-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

Thank you for sharing the v2 of this patch taking into account MPTCP!

On 06/04/2023 11:25, Pablo Neira Ayuso wrote:
> IPPROTO_MAX used to be 256, but with the introduction of IPPROTO_MPTCP
> definition, IPPROTO_MAX was bumped to 263.
> 
> IPPROTO_MPTCP definition is used for the socket interface from
> userspace (ie. uAPI). It is never used in the layer 4 protocol field of
> IP headers.

(similar to IPPROTO_RAW which is < IPPROTO_MAX)

> IPPROTO_* definitions are used anywhere in the kernel as well as in
> userspace to set the layer 4 protocol field in IP headers as well as
> for uAPI.
> 
> At least in Netfilter, there is code in userspace that relies on
> IPPROTO_MAX (not inclusive) to check for the maximum layer 4 protocol.
> 
> This patch restores IPPROTO_MAX to 256 for the maximum protocol number
> in the IP headers, and it adds a new IPPROTO_UAPI_MAX for the maximum
> protocol number for uAPI.
> 
> Update kernel code to use IPPROTO_UAPI_MAX for inet_diag (mptcp
> registers one for this) and the inet{4,6}_create() IP socket API.

The modification in the kernel looks good to me. But I don't know how to
make sure this will not have any impact on MPTCP on the userspace side,
e.g. somewhere before calling the socket syscall, a check could be done
to restrict the protocol number to IPPROTO_MAX and then breaking MPTCP
support.

Is it not safer to expose something new to userspace, something
dedicated to what can be visible on the wire?

Or recommend userspace programs to limit to lower than IPPROTO_RAW
because this number is marked as "reserved" by the IANA anyway [1]?

Or define something new linked to UINT8_MAX because the layer 4 protocol
field in IP headers is limited to 8 bits?
This limit is not supposed to be directly linked to the one of the enum
you modified. I think we could even say it works "by accident" because
"IPPROTO_RAW" is 255. But OK "IPPROTO_RAW" is there from the "beginning"
[2] :)

WDYT?

Cheers,
Matt

[1] https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
[2]
https://github.com/schwabe/davej-history/blob/9cb9f18b5d26bf176e13edbc0c248d121217c6b3/include/linux/in.h
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
