Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E736432F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfGJIAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:00:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43628 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJIAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:00:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so1331653wru.10;
        Wed, 10 Jul 2019 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JRqIl2KAaMQ78hZJopjkx5v558dsW2jWgaNwGOkG2XU=;
        b=P23TBw34QRXOzC2Juom2uCxE044GBwY41H8Cux1QOKPlVlemX35xfsiQvhYhvbksck
         RUoz6d6JgsGUF9q/yjqy9KmgAGItQa/VNqTGAQON76GrHbx2pU3r2TJmyvi6VOYyA8OY
         5G1+arOCEDb5zIaNMPiYTkcN//Npe2ugxm3Z1/tmam++5Q6cTQbwAoE408tdDsFtug2v
         ntVodpblTbR+3FpnaKo3r1Cuodm4D/yKAYxyv/C06+sxYGdTJoPKmbaAbROpxqFjYzRd
         mhClyczrep/M0wQwoMnu44NTFMDFJpoY9bWf66iGVTi5I1MIkr8n3Jw2gsi1SB96nytN
         H62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JRqIl2KAaMQ78hZJopjkx5v558dsW2jWgaNwGOkG2XU=;
        b=EIuYob7rXeg5WIkkKqewQpxEvUWxmS5YMSZNjHxuiogCqo6yZvXzhM0N4bH7aGxpRb
         0rV2tWqcKB9LBvhykIU77MRE1DvOK+yznuEhmTgtitFiI86LSx7trSafhFDek2wLHcyB
         4UKewrZiOTPiIFGCh8eWd4E4ZKLHtW9W3NHI57ndxuOzGuYVM46fTg5RPiTbQp7YqGlI
         /UQLX4PridgH8LTG6dCNNLWKkfzYgomcenP7IJMjjhRsLKuBrKNM5Mv3duXwtayG9AvO
         cG+eCSwk3vTO/JA6ZzgF3rXtPqzRyenYX2X/SE8jlIN1F2SH0CqjE8VLwEinuKA01E+x
         CbXA==
X-Gm-Message-State: APjAAAXZAeVsagGGQ0Lyt2LHSonbjG/jw1x9Ta/qwLCB3i1+MXXWcW90
        3PF87q4owwe4H8oE1ty4yTtCMgXG
X-Google-Smtp-Source: APXvYqwfImAsFglwbCi1uIEv0XitW0H2KpqE+0pcREkS6a8o1AdDwkhG22M0PTUFR5cD2/rnP3n+xQ==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr19970707wrx.236.1562745629922;
        Wed, 10 Jul 2019 01:00:29 -0700 (PDT)
Received: from [192.168.8.147] (31.172.185.81.rev.sfr.net. [81.185.172.31])
        by smtp.gmail.com with ESMTPSA id q16sm2714542wra.36.2019.07.10.01.00.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 01:00:29 -0700 (PDT)
Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
To:     Jon Maloy <jon.maloy@ericsson.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
 <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
 <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
 <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
 <ef9a2ec1-1413-e8f9-1193-d53cf8ee52ba@gmail.com>
 <MN2PR15MB35813EA3ADE7E5E83A657D3F9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e7606e76-8a0a-dab7-4561-f44f98d90164@gmail.com>
Date:   Wed, 10 Jul 2019 10:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <MN2PR15MB35813EA3ADE7E5E83A657D3F9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/19 10:15 PM, Jon Maloy wrote:
> 
> It is not only for lockdep purposes, -it is essential.  But please provide details about where you see that more fixes are needed.
> 

Simple fact that you detect a problem only when skb_queue_purge() is called should talk by itself.

As I stated, there are many places where the list is manipulated _without_ its spinlock being held.

You want consistency, then 

- grab the spinlock all the time.
- Or do not ever use it.

Do not initialize the spinlock just in case a path will use skb_queue_purge() (instead of using __skb_queue_purge())


