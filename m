Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A308C5135B1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347734AbiD1NyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347868AbiD1NyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:54:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8401A1CFF9;
        Thu, 28 Apr 2022 06:50:58 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id i27so9690194ejd.9;
        Thu, 28 Apr 2022 06:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JzMy2V75+2RkRM3hC16Okfk05xCfzTEH6hCOihCPOw4=;
        b=aqrq7jvWEXIy4wf3skeE+sg2EkRA7jIecbJU8r2w60hulNE1g2BUkeESzpGwHZ67/Q
         3VvEu1BIFt0fGoiHnR4zXOus3hPX4ivHUUI/Hn1s2gg9mohnN4dqVrIg4RRr0qS/hYLC
         rChtzdauN68WYFXKUGWl54nse3ZpIzdx8Vbsl3h8NmpWT7QnN3Lu1TK8tGEIbA/hJSjP
         Ds+yRtTGcFBUuk3TBTnxsygN+UZ0AigKL8QE5wN4cWQ9OjcF3WB4bGCF1UdqSofs+cLi
         bfMCdhC1G9KhlaQVhVB4NtLRurbeRNAQWjCEGQuNBL0AawLxc9U6HuqiMsLSNFRJz2bg
         xHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JzMy2V75+2RkRM3hC16Okfk05xCfzTEH6hCOihCPOw4=;
        b=6dXJSN87DOnm17VGrnJYY1ZOlZ4yCjOFC9e4L4DHUU8lGwwbIeUXzwu75oLZFH6ceU
         kS9EBtaSPWQPqL4kJ/0RGBbotpSvLrnOCmngXgctqm3GXoTBAi0Jkzrdl9cWOeA/GqTv
         BOTOGA8iDPGEp6pbcAL7VNKxhO5ZZjydXadJVodZWAdXYUJLDm3UuE0BqFsMAHzdIq0p
         gDOQvMiOeh6F3PXVyFQMFlPExNMm/dBrh0BTpuUcN7vLwUdlVp3A+d3pXYC7JJaS4vK7
         GldIXI/d4d7Gbx6ZUjhlxhr8DwpQx0DfjXaYM91zNQr1FCAtorh3+kqtPc4aSno2RXI7
         fVqA==
X-Gm-Message-State: AOAM532e3zXa33XF+FBgWSrg6ewNEOyISHMSqQczP6vma8HsMTFFAppw
        zUEw7APMR+sXFFRu46Uxf/sSGiCcog4=
X-Google-Smtp-Source: ABdhPJwIUOQPUWbQB4o3qorPtX80ru10OUnOo1TGsLqZMM6Dras8gJi67n46E4rTXMfx40oWnNQRVQ==
X-Received: by 2002:a17:906:7954:b0:6f3:b2f4:b22b with SMTP id l20-20020a170906795400b006f3b2f4b22bmr13331113ejo.536.1651153856994;
        Thu, 28 Apr 2022 06:50:56 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id z22-20020a1709063ad600b006e8867caa5dsm8325649ejd.72.2022.04.28.06.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 06:50:56 -0700 (PDT)
Message-ID: <82d33f81-a343-b781-47a1-53fd9ba18e16@gmail.com>
Date:   Thu, 28 Apr 2022 14:50:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 08/10] ipv6: refactor opts push in
 __ip6_make_skb()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1651071506.git.asml.silence@gmail.com>
 <3d72bc581954b5a9156661cf6957a72c5940a459.1651071506.git.asml.silence@gmail.com>
 <ff39b718a1eb5a41081beeee24f2c2b57a8a1602.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ff39b718a1eb5a41081beeee24f2c2b57a8a1602.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 14:42, Paolo Abeni wrote:
> On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
>> Don't preload v6_cork->opt before we actually need it, it likely to be
>> saved on the stack and read again for no good reason.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> It looks like most part of this series has been lost ?!? only 8/10,
> 9/10 and 10/10 landed on the ML. Could you please double check?

Seems I somehow sent duplicates of those and with weird numbering,
sorry for that. Let me resend the set, will tag v2 for convenience.

-- 
Pavel Begunkov
