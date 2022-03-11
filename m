Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D64D5934
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243037AbiCKDoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiCKDoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:44:11 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17417F4052
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:43:09 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so7608403pjd.1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nvFz12fWUFrM93QtcrlrZa1dhTzmTVLMiaO0PMC7jas=;
        b=V4X8BFfFpK1EItl+Vtwv0JmxQxC/uLzLEcvYq+lE358/oz8aaz7UhwIbH8zj4arK/f
         FozJELQNcwcm5AA0+NXfGn443e9XJpvMtHXPQHFcIm5OMR4RW2hwCzN0KVO0hX/OlJRO
         64JKR2Gz00iwYA0sZr3+bqa8b8VW6M6JB9GVYngKrsMVK2sSLbDYdfHlR8tIrs/FN45R
         SI+M3KLH6ZQnfoljGyeWr931bxwqkntBTirCz/VVvEvMCe5IKo+2XPXN6qMeV6SC5QVt
         u7xTOHjc0w4sif1yqoZWxqEFKrZhRRmJ8Cj7xb2KKqNZrfT54hzVU/rHWEUXOAwcy1Qx
         DwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nvFz12fWUFrM93QtcrlrZa1dhTzmTVLMiaO0PMC7jas=;
        b=aFUkzrL+dNwL+aB0MOyUZ1E9eDBKIH9OsABV4Me8PwUpqDLQr82e6sIh8Kkfdm9hg/
         MIQ24pO4O9tB/TotNZ2bnP/ZhbqC13WyACnw/U6wkwfis4Jix8rWxGKEESliFA22qibt
         +IMJy974JbMIihDAAxZlVkA1uSieQBhIm9nSL137R+GcxDmbYq9cAznW3EIWMxmqXOwx
         FH8Ec1c3ZEiSMq6+RWwF7gh35zH37wncE7MR3ZHQtm9slJnYtyjkLmK0lJle5L4xR91Q
         JCY6pU0xlyKrXtOmAC+n+A6/4Bhmq3aR2df6bExN98A3ecozZnwiSTG8AN9IDs+lxGuB
         QM/A==
X-Gm-Message-State: AOAM530AFDQDLNu5kBWuKAI3eGZ6FyDRcVPU+nMOVsZaXnWHyE2C1axz
        MEabLey43YwKZoSuwEIPS5xfdg==
X-Google-Smtp-Source: ABdhPJwATekmVr7rlGCQ1zhFo/v+kgusnt7ofrTGKAihTSCPxedkvwJhX5UXXRwlAceXfdGnHgEHLw==
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id d22-20020a170902729600b0014b4bc60e81mr8481078pll.132.1646970188379;
        Thu, 10 Mar 2022 19:43:08 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id f6-20020a654006000000b00346193b405fsm6755844pgp.44.2022.03.10.19.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 19:43:07 -0800 (PST)
Message-ID: <a5027d2b-ae93-3b6f-efb7-2e899ac86ae0@linaro.org>
Date:   Thu, 10 Mar 2022 19:43:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v3] net: ipv6: fix skb_over_panic in __ip6_append_data
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     kuba@kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
References: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
 <20220310232538.1044947-1-tadeusz.struk@linaro.org>
 <CA+FuTSdFoTTqqL5CxCbL4gEg4-QvUQzQSM+45G9XL0BtLs7fGA@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CA+FuTSdFoTTqqL5CxCbL4gEg4-QvUQzQSM+45G9XL0BtLs7fGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 17:49, Willem de Bruijn wrote:
>> Reported-by:syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
>> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>
> Acked-by: Willem de Bruijn<willemb@google.com>

Thanks!

> 
> small nit: "equal to the fragment" and all these Cc:s aren't really
> needed in the commit message.

I usually Cc all addresses that the scripts/get_maintainer.pl prints out.

> I don't think we'll find a commit for a Fixes tag. This goes ways back.

Agree.

-- 
Thanks,
Tadeusz
