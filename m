Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14E21371F
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEDDXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:23:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33696 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDDXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:23:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id k19so3656237pgh.0;
        Fri, 03 May 2019 20:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Dnlfvz2feUoXxK2GPjrd8YKdDGUiEgdiAua8sKIN3WU=;
        b=h5YzcEz8N6W218osr0BvSftgUFBrSyyJ954qiTwruL33C0QDTo56XFVMgpr1b+BpRL
         UEf/w6s+7Ne5X88EUGRj5CLuVNnHSpt0H6wOlAGqfRmR+MAopfWLATZaC0M4uhyQnENo
         3iEcroslzRqUoq8BpZyqVweX9lGp8/NJqeXQwiDQUtrbY8Z/K6GzYI+7wXRfkCaPkZyC
         IQPEzrQtMDTpp8V7M7L+Jfi5wL1M/JZXUNxvODlbeusYDI15khyu60H2eA4bgq0eBcEU
         jYVM0Md6gCklGi2Wt8eY4JeA6WZD8QVggMQ7kFNte1IAjgXkX5BEJCQlCR9CsQu/XMFA
         aVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Dnlfvz2feUoXxK2GPjrd8YKdDGUiEgdiAua8sKIN3WU=;
        b=GAFfuB7Ts01vNFP+mOzq9RMrxPP8wuKpBwDC/1OjuxcIlc4qGzRQ2gGlLH2jAUd7bY
         r5h+/nCMdU1d25WwFSHe2dcJTwHfvF84gjF308wj9cDBMBgsm1315hIuMhJjE5gEWwcR
         t4Hh5llS5n224Tzf3241Yhr12SFGVbX1xtGRB3g0YaCUrxVrsYHOinbPFYzHIAZIGntQ
         yrctPpzj+/Ph9Y6RJueTFhPaO9q4oGPi2tVOC5Lf3WRJmrJwDVc+LHpr3N+pkFb52C2a
         rSN+LgkvjPP1D2S9RLKXDOjFPDwYPxAX3hONEbfpCpZdok+pvNfK2LrhNpr6DFqNoyGU
         AcGA==
X-Gm-Message-State: APjAAAU5k2PxGRONqSSZTMf2DN7iBND97elDOVX8VaWhK/LddDeEJaEB
        iY/A8Y7p6S31Hf0GTd9tBgGE84YZ
X-Google-Smtp-Source: APXvYqwmd4vulWSnjYFDmp+w0EzUnLOCtF3mmpNvqqb2sm7wLQAwXZLc1O8774xVql9izPzamcxG+Q==
X-Received: by 2002:a63:1a42:: with SMTP id a2mr15032888pgm.358.1556940190465;
        Fri, 03 May 2019 20:23:10 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.43? ([2402:f000:1:1501:200:5efe:a66f:472b])
        by smtp.gmail.com with ESMTPSA id k26sm4400902pfi.136.2019.05.03.20.23.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 20:23:09 -0700 (PDT)
Subject: Re: [PATCH] net: via-rhine: net: Fix a resource leak in rhine_init()
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504030813.17684-1-baijiaju1990@gmail.com>
 <20190503.231308.1440125282445011089.davem@davemloft.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <f2e7c284-aa70-2b67-b9dd-461db102cbc5@gmail.com>
Date:   Sat, 4 May 2019 11:23:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190503.231308.1440125282445011089.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/4 11:13, David Miller wrote:
> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> Date: Sat,  4 May 2019 11:08:13 +0800
>
>> When platform_driver_register() fails, pci_unregister_driver() is not
>> called to release the resource allocated by pci_register_driver().
>>
>> To fix this bug, error handling code for platform_driver_register() and
>> pci_register_driver() is separately implemented.
>>
>> This bug is found by a runtime fuzzing tool named FIZZER written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> I think the idea here is that PCI is not enabled in the kernel, it is
> fine for the pci register to fail and only the platform register to
> succeed.
>
> You are breaking that.

Okay, I can understand it.
If so, I think that platform_driver_register() should be called before 
pci_register_driver(), and it is still necessary to separately handle 
their errors.
If you agree, I will send a v2 patch.


Best wishes,
Jia-Ju Bai
