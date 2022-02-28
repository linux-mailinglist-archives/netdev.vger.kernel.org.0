Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470E4C673D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiB1KpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1Ko7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:44:59 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5763980A;
        Mon, 28 Feb 2022 02:44:19 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id d17so10822688pfl.0;
        Mon, 28 Feb 2022 02:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NvX2uqznvmKdZ/4f2xZP0934AoJu1sONoim8jf1dvRA=;
        b=aF9vgi4tNTCipEUdrKuDsGnZeoKC8hROgeXO0cxHjnwzzfaFuxTc/wG7aoiScBDdKN
         lJhVTjcrzMjLrAyRF2Nlz9k4uCOUaIpjZmOerCqfDZPltrK7YU/yCq/iPVmdDmFwF5Cr
         n9CWLvYB5KCvGmIy2/oqcvAXrfgmykB0NiVsp6xTvlyt3vQbguJrH+ScV8i4nl11oemc
         HntDnN5cuJ0P1VyLvuNYMrkAE8kXDtj2W2MI1IgiINmRQ+be7X/n05o9NHayEQauiISW
         vMj14p1sKsmoE/4prp2bKj1xPqD1qoV5mh4fKoSaf54U0JBCa4MLr/57rUGePS3vV1l3
         1JhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NvX2uqznvmKdZ/4f2xZP0934AoJu1sONoim8jf1dvRA=;
        b=nDq2TAeMO/GcQKBJCcFl/fEM6dwgmkyVt4cl8DNQntKRb3R/NaZqrw40FF4ZQjNXIp
         wuM2tv21RsYkq0Y5S8etbL+Tc4LP7eP2vNXzzgqOXghEt1M3EmtzZxAXDEjJ+E+44bTf
         7/A2WCMHkkSQ88kUY19KeYYDp8Xbk0RmbjVdWY9Q7mL0X7OIKX4DTu6zY5p5WnhenREl
         ipeC3Pb3f1e0tOIrPiksuQD0c+ggqmub5WCUruBbHP2kLjQguR5AvBjgVJ/tEHkalokY
         Vz+acD42yZobqT9QTn6EDEn8r0CkrmyWdW7AjK/X6orMBt1268LDB/3JkeE59CorYdL4
         nCRg==
X-Gm-Message-State: AOAM532SQo/gtheOFHk+LfGbHANbussgI2AEv8oWKc/uss+MaMIxInO2
        5DqHD4QjzkLTWVXojrAAPVkBmwEm3DcgXyNy
X-Google-Smtp-Source: ABdhPJxKRXcVq2xSkSHK4yAO5ohWBGyQl3gXE/ZNA5rTqJtN57KiMrxuyPv5meeUNGwpNhKz5xvoVQ==
X-Received: by 2002:a63:a66:0:b0:373:c36b:e500 with SMTP id z38-20020a630a66000000b00373c36be500mr16729783pgk.419.1646045058977;
        Mon, 28 Feb 2022 02:44:18 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b004f0edf683dfsm13014889pfv.168.2022.02.28.02.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 02:44:18 -0800 (PST)
Message-ID: <75c14302-b928-1e09-7cd1-78b8c2695f06@gmail.com>
Date:   Mon, 28 Feb 2022 18:44:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb: delete a redundant dev_kfree_skb() in
 ems_usb_start_xmit()
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220228083639.38183-1-hbh25y@gmail.com>
 <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

I get it. I'll remake a patch that matches your suggestions.

Thanks.

On 2022/2/28 16:55, Marc Kleine-Budde wrote:
> On 28.02.2022 16:36:39, Hangyu Hua wrote:
>> There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
>> can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
>> skb.
>>
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> Thanks for the patch. Please add a Fixes tag, that points to the commit
> that introduced the problem, here it's:
> 
> Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
> 
> I've adjusted the subject a bit ("can: usb: ems_usb_start_xmit(): fix
> double dev_kfree_skb() in error path") and added stable on Cc.
> 
> Added patch to can/testing.
> 
> regards,
> Marc
> 
