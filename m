Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CB32B8A5C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgKSDM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgKSDM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:12:27 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169C1C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:12:26 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b3so2156798pls.11
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cwZjtSQF/ueqaFKc6gHpZLymg8qyHcbr4KeUhps62Iw=;
        b=nrcDhjN5dU/xuf5G+2gQbrhTlmAgzkMocr7Z8DkEQSt3sTMkbvAuTb/YlqaVQa/1mw
         nFEPrClBV+djqDFiwY/GAUV8NmWLXA4J/bnUEaIdK4arVz4CnjF7PWB9R356C29yAbge
         cvHc4shpKGltbjSFNcqurNFv69Gg81mr6ooLOX5MQmlXDijLReuPtXA25Nz6u1bnDmMw
         xz25uYjf0LQWivvF7mGmXa8ozCWDS2IHNgIOKv72g2gwYLKiL1516aUcI5njiF69t8iz
         /OYresz25qeYfkuSLzw/tGCZ+4tKa2QQI7tBXIFWhrVpf3P5DKNfL3igX4RZAt3P5jPQ
         zr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cwZjtSQF/ueqaFKc6gHpZLymg8qyHcbr4KeUhps62Iw=;
        b=Y3Sstjxvf3bbnXFnxabufh7h51fp/hRyZh91z9L6jvosfXbLEs89+RbOfbSSo7wWgC
         lgeHULproCqVzOfLYppU7S7eGg8OOqwQ9fr816dhk9HW0nBtS9LL2X9nukAEZAomLAWG
         HfhyKP3rLcQwz6UYwOFRuW9jeG4DA83DgeQu8PUdAtoi+lQrsY+l/6ahHpyiRzAN/0wn
         U/BNGZ+qm4IikThTuJ5EqJRV89x6prYnBnzuV+8FqHZ0/6OS6lQN5nixowplFpplbWlK
         FmpSWuV1EXYvCRLKac/O+vMdwhptuCAg3B594c/xXutqLsfYiWqsExamvMtPS2c9nv1C
         socQ==
X-Gm-Message-State: AOAM530j63h0eCqGfKnQF3MYl+dFacZyBKEhYw3KaSoTbyzXXAxreIuJ
        bdign3WSFnTgKXcA4JAwiGI=
X-Google-Smtp-Source: ABdhPJy9W59erDMxz7qSf7QxO/gm5SRKgkxKlrLdSrGAN6ahaaCorcAmEYPpSNjPf2mfydu+NRV99g==
X-Received: by 2002:a17:902:76c5:b029:d6:a399:8231 with SMTP id j5-20020a17090276c5b02900d6a3998231mr7289320plt.3.1605755545657;
        Wed, 18 Nov 2020 19:12:25 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o89sm1371920pjo.47.2020.11.18.19.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:12:24 -0800 (PST)
Subject: Re: [PATCH 10/11] net: dsa: microchip: ksz8795: dynamic allocate
 memory for flush_dyn_mac_table
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-11-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a13ce314-84f1-97b4-0179-c155ceb24629@gmail.com>
Date:   Wed, 18 Nov 2020 19:12:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-11-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> To get the driver working with other chips using different port counts
> the dyn_mac_table should be flushed depending on the amount of physical
> ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
