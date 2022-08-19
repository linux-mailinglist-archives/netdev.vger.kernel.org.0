Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A159945E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiHSFOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbiHSFO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:14:29 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D756DCD527
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:14:28 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x25so3540069ljm.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=u82R4d244Cj++Lww/hGplgY2Va/WdkLk02wXufqIzzU=;
        b=ZiaGnJbmOtTF3B97Gq5sSPCjIcLD+ncugkWPjZbdNMn6K0Qp2jRSkC8HYvJ91TMPp7
         0FjCmVe5zJGEo69u8rY0wLXLcrnjfFkKFGa9D/G+8Q7jOzeAC3OpWPyhTsUT2wHkFrKZ
         nXujYs7Zn2H1sqbOv+1eDi+FQYTQUhxWzQ3ehKPWZO08JLfIx7mcEMMHIHpNQa3zFAvJ
         Q7SMpQBPIcCHH0l0c+MjpHe6ZxtBcjg7Ikd1II12tJfhCBvN/yVY+/kkmb5eXiPtS1Ff
         cDTquRbPrbQEZ7Mykmt6g+oDCPzoz/vMbn/3XXle05p0fjSl7JPKU4AAB1WUMPtj24P4
         vjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=u82R4d244Cj++Lww/hGplgY2Va/WdkLk02wXufqIzzU=;
        b=A0mopYkPso2zzsAYneV4mwfRO65nIsPnWCYyddbXODbyM4Lh0Qs08d/PtPMiJAp3AQ
         JZnYT1WDw8T/lEz85i/csivnBkOIpE7AL8SshD8kTnUF/wJ8aj60Lq3zMBnH2u9KxKL1
         QvuLZloFzMZRdPX2sotwu1Bc+2bICA5k2f1YhwuwbGzgEEFL7FPXmF9VN+NQFwLot1fh
         SoErrMOWNYGfgJQe8BtfmoWTP67kX6MYC2X89pid3Gn4HwyG+09G8zCjGJZrrtRmcb7u
         jt2ChJYeOqTWdWMDIJHKmfJLxyXrMRQZ0QkeMPTBRTMUTHENpjfIqheVs9iO0u/nQbz8
         6aUQ==
X-Gm-Message-State: ACgBeo1MUwXXhtOZqgyThr05HLi8psoT0N5EKSfpYw2lWF0HAyrfkUnZ
        dPbWe7kI5lm8BQAidRRttD4=
X-Google-Smtp-Source: AA6agR6plorKKlPoXWs2gQtXyM/V+2yiiBct4QXbl4bLgLhfQ1XD+vXg/om37py3K6K45MHrBrWTrA==
X-Received: by 2002:a2e:2281:0:b0:25e:7a20:e257 with SMTP id i123-20020a2e2281000000b0025e7a20e257mr1634139lji.54.1660886066957;
        Thu, 18 Aug 2022 22:14:26 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id t2-20020a19dc02000000b0047f8d7c08e4sm491722lfg.166.2022.08.18.22.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 22:14:26 -0700 (PDT)
Message-ID: <b388479b-9aff-be1c-c9b3-20d5169c925f@gmail.com>
Date:   Fri, 19 Aug 2022 07:14:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next PATCH 0/3] net: dsa: mv88e6xxx: Add RMU support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <Yv4xOK0pS8Xjh/Q8@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yv4xOK0pS8Xjh/Q8@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-18 14:31, Andrew Lunn wrote:
> On Thu, Aug 18, 2022 at 12:29:21PM +0200, Mattias Forsblad wrote:
>> The Marvell SOHO switches have the ability to receive and transmit                                                                                                    
>> Remote Management Frames (Frame2Reg) to the CPU through the                                                                                                           
>> switch attached network interface.                                                                                                                                    
>> These frames is handled by the Remote Management Unit (RMU) in                                                                                                        
>> the switch.
> 
> Please try to avoid all the additional whitespace your editor/mailer
> has added.
> 
>> Next step could be to implement single read and writes but we've
>> found that the gain to transfer this to RMU is neglible.
> 
> I agree that RMON is a good first step. Dumping the ATU and VTU would
> also make a lot of sense.
> 
> For general register access, did you try combining multiple writes and
> one read into an RMU packet? At least during initial setup, i suspect
> there are some code flows which follow that pattern with lots of
> writes. And a collection of read/modify/write might benefit.
> 
>     Andrew

In another stack I've used aggregated writes with great improvements so
it that is something that could be investigated. One large oversight when
implementing RMU in HW there is no operation for masked writes which makes
it a bit trickier. It would be great if there was a transaction-based
API which would easier map for aggregated accesses.
Oltean mentioned something about qck8k that I'll have a look into.
