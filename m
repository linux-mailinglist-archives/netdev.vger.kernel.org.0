Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4D22C2B3D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbgKXP0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:26:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730898AbgKXP0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:26:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOFHnbR004152;
        Tue, 24 Nov 2020 07:26:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=ku9688Ul2XrRv3CoQJqdDttsJWe5rg4v2x7o7Shz+oE=;
 b=WjsY4J377bxrLTSvYLzyHp/QFFv01d5nj2IXZFQhgGdXQDRYMHrtYElNA331qKzq8hjg
 e/UHnzG7pd3jDdd/zzPj+figmX6hbSghofNrFWXxvmAL4kQmJg9oDJl1kfQ7LF5Tk7mQ
 uP+01GZNybxWawG133YJZM7Cxi7+kJRH4rqrcFlWx2IVjNwGEvlSDfieDEKHIcSIoAD7
 mtazL1L5MLqfrXKdMIilyVGEq/H3vELi3qBRGGK46TG17zhq9MonT1NB1yOtBnYj+f6Y
 jp3mIukwugB9KSCbJnv1TKhoeA1NejVq/U7MJS454bAYQJfKbxhozRhgqzJxezH+62dP Cw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39ra2k6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 07:26:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Nov
 2020 07:26:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Nov 2020 07:26:33 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id 0A4193F703F;
        Tue, 24 Nov 2020 07:26:30 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v3] aquantia: Remove the build_skb path
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
References: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119224916.GA24569@ranger.igk.intel.com>
 <2fbb195a-a1b5-cec0-1ba1-bf45efc0ad24@marvell.com>
 <20201123192817.GA11618@ranger.igk.intel.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <ca932605-142f-5264-e75e-3b16c6dc1e3d@marvell.com>
Date:   Tue, 24 Nov 2020 18:26:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20201123192817.GA11618@ranger.igk.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>
>> Since normal layout is 1400 packets - we do use 2K (half page) for each
> packet.
> 
> What is 'normal layout is 1400 packets' ? Didn't you mean the 1500 byte
> standard MTU? So this is what you've been trying to tell me - that for
> 1500 byte mtu and 1k HW granularity you need to provide to HW 2k of
> contiguous space, correct?

Thats right.
Sorry for confusion, of course I meant 1500 standard MTU.

> 
>> This way we reuse each allocated page for at least two packets (and
> putting
>> skb_shared into the remaining 512b).
> 
> I don't think I follow that. I thought that 2k needs to be exclusive for
> HW and now you're saying that for remaining 512 bytes you can do whatever
> you want.

As soon as we've got packet we know its length. IF its less than 2K minus
skb_shared_info - we put that halfpage directly into skb, and placing the tail
for shared_info. This is what fast path is doing now.

> If that's true then I think you can have build_skb support and I don't see
> that 1k granularity as a limitation.

Thats true, but we can't use build_skb exactly because of the reason Ramsay
discovered. We need extra headspace always.

>> I know many customers do consider AQC chips in near embedded
> environments
>> (routers, etc). They really do care about memories. So that could be
> risky.
> 
> We have a knob that is controlled by ethtool's priv flag so you can change
> the memory model and pull the build_skb out of the picture. Just FYI.

Priv flags are considered harmful today...
But I agree in general we lack support of driver fastpath tuning.
Like changing page order for large jumbos or page reuse logic knobs.
May be devlink params could be considered for this?

>>> This issue would pop up again if this driver would like to support XDP
>>> where 256 byte headroom will have to be provided.
>>
>> Actually it already popped. Thats one of the reasons I'm delaying with
> xdp
>> patch series for this driver.
>>
>> I think the best tradeoff here would be allocating order 1 or 2 pages
> (i.e. 8K
>> or 16K), and reuse the page for multiple placements of 2K XDP packets:
>>
>> (256+2048)*3 = 6912 (1K overhead for each 3 packets)
>>
>> (256+2048)*7 = 16128 (200b overhead over 7 packets)
> 
> And for XDP_PASS you would use build_skb? Then tailroom needs to be
> provided.

For efficient PASS - I think both tail and head room should somehow be
reserved. Then yes, build_skb could be used..

Thanks
  Igor

