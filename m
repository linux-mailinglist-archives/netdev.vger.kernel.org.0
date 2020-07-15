Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FEE221132
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgGOPem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:34:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8224 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725835AbgGOPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:34:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFFWO9026423;
        Wed, 15 Jul 2020 08:34:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=JOR9fsRi64kPhWe5EibwX6nTXHXPXpaID/ygz7u91DE=;
 b=xusDJ8fIs2DESSA6Awv/Qt2LzwCc7odyTmsSolcK3hhGN5OTo+j4phEyKWVhxVDCxSQ4
 gA8dofmIDmINYdsahOYHjsXNuvYUPRmrzIHrpq+FwAjkU2d1uTx2pUfm5aQTCuBpSRlE
 +jtRYmkUDsIXw07OIZ0Pqv8eJJ/H6CLcSr33AXbfCtkxDwiSSfvx+XUkoGKd8wlhVZsI
 rjsthL2bv5RiX3v84MCDplBn8nRskrMCBf8uUyAibMlc/DZKiz/oaIGx8K8J0R+Nj0m/
 vmfd/tkCMaG0c8oMNj7rZBd9bWPAFJEbWb3onIYm/0fFYKs/WEGyQp73miQM1iBy2G4g Pg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnj7ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:34:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:34:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:34:37 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 925CE3F703F;
        Wed, 15 Jul 2020 08:34:33 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH] net: atlantic: Add support for firmware v4
To:     David Miller <davem@davemloft.net>,
        Alexander Lobakin <alobakin@marvell.com>
CC:     <kai.heng.feng@canonical.com>, <anthony.wong@canonical.com>,
        <kuba@kernel.org>, Nikita Danilov <ndanilov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200707063830.15645-1-kai.heng.feng@canonical.com>
 <20200707084657.205-1-alobakin@marvell.com>
 <20200707.125624.2030141794702878802.davem@davemloft.net>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <226601b2-562c-ae59-ee0d-51b130255c18@marvell.com>
Date:   Wed, 15 Jul 2020 18:34:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200707.125624.2030141794702878802.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> We have a new ethernet card that is supported by the atlantic driver:
>>> 01:00.0 Ethernet controller [0200]: Aquantia Corp. AQC107 NBase-T/IEEE
> 802.3bz Ethernet Controller [AQtion] [1d6a:07b1] (rev 02)
>>>
>>> But the driver failed to probe the device:
>>> kernel: atlantic: Bad FW version detected: 400001e
>>> kernel: atlantic: probe of 0000:01:00.0 failed with error -95
>>>
>>> As a pure guesswork, simply adding the firmware version to the driver
>>
>> Please don't send "pure guessworks" to net-fixes tree. You should have
>> reported this as a bug to LKML and/or atlantic team, so we could issue
>> it.
> 
> Production hardware is shipping to customers and the driver
> maintainers didn't add support for this ID yet?  What is that
> "atlantic team" waiting for?
> 
> Honestly I don't blame someone for posting a patch like this to get it
> to work.

Me too ;)

We've discussed this with Kai Heng internally, that was really an engineering
sample.

We'll repost this patch soon with some more changes required for that new FW.

Thanks,
  Igor
