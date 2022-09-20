Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6225BD8CB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiITAb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiITAb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:31:26 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174B551A2D;
        Mon, 19 Sep 2022 17:31:26 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id y2so735716qtv.5;
        Mon, 19 Sep 2022 17:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zR2Q4QyS+Tbvo76GqnO7ltxu1VimNHBe8fxFKg919ww=;
        b=LKpGlipgDxDA1WUXqy9+tksIPJRTp1SvWisllhpCivdFLoApqRAqFK0f6aw84ymcNr
         2vTkBfKGI5r2RVD+FXF6elJRg6Isz8aKL4EGvWW0822JTYKHh7Nk8m8KbWZjVmJBX195
         9eK5A4QHjBhbhi5cFIUXvU3A1EvkKuAsyIvs6bqwoVmp4NwfTXq6B3lOuCGRLRTnf8Hq
         Qmhy7LLbouKt6aMoQGOH2ZP9R47x7vXrDzIn6rf4IP7dCiySMgMHuOkDr0DTOLEMVhY4
         oZcMD8rnKardQOXzankIryIo8jGY8WdXGlXpNw5fh6QEsWj+9T6704IMmulGlbJ5e/qE
         KrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zR2Q4QyS+Tbvo76GqnO7ltxu1VimNHBe8fxFKg919ww=;
        b=KRHsyEItE9nVRME8iNAA0rtkm3HpgCgks8dCeZnSBMm6D7zIIcoz3Sy7NfEKuZk+3v
         QK7GVa7zobxPjNG+jOGYqHCtyoc7vbFHymMXUaxLzTKywIMcvyFCZOfOsvthaVYPfyKu
         BDZ29eL+X0Mqm6CYPlev8Qyuag4Smu3jDUQsF2y/KSDhTc7Lsztc1UscdjAuJM53OqaO
         ij5dCE7DGE9B5Gd5r4onk1OHtnTiaSxxv1pM0e3pO8NixqPynsknQZ+T1JgG+BXRfsb6
         T3XCIecQ3fk+IJfEAxRGsobTqvYw8M0B+3IG8uRDqlJiTmgNZ2enUeiFwLU3Do9STNuf
         3qBA==
X-Gm-Message-State: ACrzQf3I8ensmEWzrINiJHgMXOAoQ1hRs2lcZksAyCUAyZkQ+pBUr7Eq
        ziMa4ze7mKcOinEaYUqJSA0=
X-Google-Smtp-Source: AMsMyM5cHFbPeIkstTYcLMvF34ln71+chVB5pyQuT174Kvk4jOcjte1o+r/pGB2SHLVbfj3SfVuF6g==
X-Received: by 2002:a05:622a:454:b0:35c:e1a7:5348 with SMTP id o20-20020a05622a045400b0035ce1a75348mr8980919qtx.604.1663633885205;
        Mon, 19 Sep 2022 17:31:25 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id v4-20020a05620a090400b006bbf85cad0fsm13266252qkv.20.2022.09.19.17.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 17:31:24 -0700 (PDT)
Message-ID: <ab2ce38a-313b-7e87-aaf5-cfc2b6e0cb28@gmail.com>
Date:   Mon, 19 Sep 2022 20:31:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>
References: <20220918215534.1529108-1-seanga2@gmail.com>
 <YyjTa1qtt7kPqEaZ@lunn.ch>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <YyjTa1qtt7kPqEaZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 16:39, Andrew Lunn wrote:
> On Sun, Sep 18, 2022 at 05:55:34PM -0400, Sean Anderson wrote:
>> There is a separate receive path for small packets (under 256 bytes).
>> Instead of allocating a new dma-capable skb to be used for the next packet,
>> this path allocates a skb and copies the data into it (reusing the existing
>> sbk for the next packet). There are two bytes of junk data at the beginning
>> of every packet. I believe these are inserted in order to allow aligned
>> DMA and IP headers. We skip over them using skb_reserve. Before copying
>> over the data, we must use a barrier to ensure we see the whole packet. The
>> current code only synchronizes len bytes, starting from the beginning of
>> the packet, including the junk bytes. However, this leaves off the final
>> two bytes in the packet. Synchronize the whole packet.
>>
>> To reproduce this problem, ping a HME with a payload size between 17 and 214
>>
>> 	$ ping -s 17 <hme_address>
>>
>> which will complain rather loudly about the data mismatch. Small packets
>> (below 60 bytes on the wire) do not have this issue. I suspect this is
>> related to the padding added to increase the minimum packet size.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Hi Sean
> 
>> Patch-prefix: net
> 
> This should be in the Subject of the email. Various tools look for the
> netdev tree there. Please try to remember that for future patches.

Sorry, it should have been "Series-postfix".

> Please could you add a Fixes: tag indicating when the problem was
> introduced. Its O.K. if that was when the driver was added. It just
> helps getting the patch back ported to older stable kernels.

Well, the driver was added before git was started...

I suppose I could blame 1da177e4c3f4 ("Linux-2.6.12-rc2"), but maybe I
should just CC the stable list?

> I think patchwork allows you to just reply to your post, and it will
> automagically append the Fixes: tag when the Maintainer actually
> applies the patch.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>      Andrew

--Sean
