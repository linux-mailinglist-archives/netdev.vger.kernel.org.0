Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD31561DC4E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 18:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKEROE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 13:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKEROC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 13:14:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C1FFD0A
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 10:14:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bk15so10834184wrb.13
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 10:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=w6fH5+cI+u64BY/ZI+RHE/4KCrS9TCWHVsvt6i31Iqg=;
        b=JMilsqW1wJFQ+cQPoWWiGMOr6+C0U0HKpCN4JKJt0zi7+y+xvSTH+6pdU4Y0vzBOgM
         Ps3yiHWxlxkeSfs8jyDqZ//ix/kHd7JgfqweglNhtZqkeJ5Y95YC24/GeUlaj4F5cXFb
         mwy8veODJMzd4o4wGGeByTcYTwQcJFNIA3hzHqiJ1iszta/PLJdlUlYGsGc3eCe5C9OE
         twbul0nv2RPEtEHadImRCZ6EHpyQT8a1GymtW0jq59qrkSCSMwmlZflnCfYW1ipIhNiN
         NLeOQbyXd3Vh8wSNod1uo/vhwO6KvU4GYMpPk9bD7VHUSF5g3Y8JsTCqfpiC59yByzb6
         zt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6fH5+cI+u64BY/ZI+RHE/4KCrS9TCWHVsvt6i31Iqg=;
        b=6uKUibPpAAWzdSZIXudJLr7buIMBwdKrsmktFiBOcHWeKKHkaHTD4n3U7IRh9mQqfJ
         ocXz0u78rj+g9jS6IMzqNVrXl6zyNPvXhUjJv/rdo0+28tIrblIPxUnGr9hjAp0OH/+7
         fins8jmdrU6zJwjvjp8FwRxhsxxNTn4fSJZEGrGhUnA5CrKm4pQLzw9pUxLcw/CLVjBB
         1qJ6GUH/qqKRWPH+IA7E/6xH9UxrQAJj8jwVK8T1LVR8XaqnRMBkJD2ELfs/qL32HyOZ
         yoNBupspvv+mOnE10xj9Fj7fePXLuJiERcdBVLzFreTnyFw88xf0OKOw5JpOGkff1G53
         einQ==
X-Gm-Message-State: ACrzQf2NmJN4LOcbvD4Wbk3ji9mv2/gJFhbuVaEq08YGDJZks9CNImVE
        /TXlI5EQzsN+QxeU3P7SKgoyrJJa2mGq8g==
X-Google-Smtp-Source: AMsMyM4uGhTVMvHf/QKbW+gyiK9yjyTbZyxXoSv4hbobWNFARKKnNI9jDUladWPww+gWgYLBslkpgA==
X-Received: by 2002:a5d:47aa:0:b0:236:79cc:6d5f with SMTP id 10-20020a5d47aa000000b0023679cc6d5fmr26369329wrb.391.1667668439011;
        Sat, 05 Nov 2022 10:13:59 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id c14-20020adfef4e000000b002367ad808a9sm2610884wrp.30.2022.11.05.10.13.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 10:13:58 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>
References: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com> <20221105133443.jlschsx6zvkrqbph@skbuf> <024601d8f124$5c797510$156c5f30$@gmail.com> <20221105163751.it2mxwobzhqwtyr4@skbuf>
In-Reply-To: <20221105163751.it2mxwobzhqwtyr4@skbuf>
Subject: RE: Potential issue with PHYs connected to the same MDIO bus and different MACs
Date:   Sat, 5 Nov 2022 18:14:02 +0100
Message-ID: <024e01d8f13a$00b85ff0$02291fd0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGWsFLDOi30rVKqVG4E9amvaBZqWAHQK04OAdXThfUBDXEorK6Pcpug
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, my!
Yes, this is so obvious but I could not see it...!
I really thank you for your time, and I apologize for overlooking this.

Kind Regards,
Piergiorgio

-----Original Message-----
From: Vladimir Oltean <olteanv@gmail.com> 
Sent: 5 November, 2022 17:38
To: piergiorgio.beruto@gmail.com
Cc: netdev@vger.kernel.org
Subject: Re: Potential issue with PHYs connected to the same MDIO bus and
different MACs

On Sat, Nov 05, 2022 at 03:39:07PM +0100, piergiorgio.beruto@gmail.com
wrote:
>    priv->phylink_config.dev = &pdev->dev;
>    priv->phylink_config.type = PHYLINK_NETDEV;

The problem is here. You think that &pdev->dev is the same as &ndev->dev,
but it isn't (and it's SET_NETDEV_DEV that makes the linkage between the 2).
Use &ndev->dev here, and check out how phylink uses the "dev" field:

#define to_net_dev(d) container_of(d, struct net_device, dev)

	if (config->type == PHYLINK_NETDEV) {
		pl->netdev = to_net_dev(config->dev);

