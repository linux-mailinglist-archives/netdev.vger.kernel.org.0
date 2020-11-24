Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A912C29A2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389068AbgKXO3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:29:36 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33416 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388014AbgKXO3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:29:36 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOEPCue010051;
        Tue, 24 Nov 2020 06:29:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=bKTEaB+h/bQFHNUOWJf9rkxNLNyTMHb3Pf84oN9IMq0=;
 b=ZPBGBeOhAIgAVhWl9LiST36cRCQ1ITysd8ukQzQOQhH4AKR3OJyoQFl0/rqJq2EvltwY
 c5z2R0Qylesso1rZFWABPM9da259KxP+s6tGQwPOHw7yKvAinWv45gl8ybHaKo2NYgz6
 qahLV7zRgfe0GThl0GsFGuiqzm+1GYHKEXQO2NfSH76BXRFynVusJtIOXNcIQIt0gUAu
 7I8MHyyFGsZ7+7LuP4YCYLvrAcW5jtRluPx5u3IZJrsl84QSiXkcmTaJJsAHaTIC7WEC
 89wfxUdUH+DMvJUPDFVrxr/0gvh1Wis+Ym3Tp5W6mXRrk81Pxyqnt9YLYG+1nx1nM/Zz Pw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r9vpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 06:29:27 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Nov
 2020 06:29:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Nov
 2020 06:29:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Nov 2020 06:29:26 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id 705553F703F;
        Tue, 24 Nov 2020 06:29:24 -0800 (PST)
Subject: Re: [EXT] [PATCH] aquantia: Remove the build_skb path
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <12fbca7a-86c9-ab97-d052-2a5cb0a4f145@marvell.com>
 <CY4PR1001MB23115129ED895150C388E12CE8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <5b6ae6ab-be6d-3a18-341d-c18719ffaaad@marvell.com>
Date:   Tue, 24 Nov 2020 17:29:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <CY4PR1001MB23115129ED895150C388E12CE8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/11/2020 7:20 am, Ramsay, Lincoln wrote:
>> Yep, that could be the only way to fix this for now.
>> Have you tried to estimate any performance drops from this?
> 
> Unfortunately, I am not in a very good position to do this. The 10G
> interfaces on our device don't actually have enough raw PCI bandwidth
> available to hit 10G transfer rates.
> 
> I did use iperf3 and saw bursts over 2Gbit/sec (with average closer to
> 1.3Gbit/sec on a good run). There was no significant difference between
> running with and without the patch. I am told that this is about as good
> as can be expected.
> 
> Make of that what you will :)

Thats not very useful, but since we anyway have to fix that - lets do it.

I'll try to estimate potential perf drop on my setup when possible.

Thanks,
  Igor
