Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50D1CB002
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEHNXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:23:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42594 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728692AbgEHNWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:22:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048DKbon019269;
        Fri, 8 May 2020 06:22:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=Q/wOedP+j5Yru3PeeMPT2lDLKMN/7TmgHUE/nc97zU8=;
 b=ijDkt0FXTJE6eNhQMBsh8wOanC0co5stf2jAoX/l9/aY9VcS7EIMcf2bc1nigG6TrPqi
 MkrGlWargFhrjnuW/9QnlLBvONFUiuyyu20iTkZqQ2tl7JE3gDovs0bu1MdcvD36C0Wh
 P1n54+M6YpP3j1ARTBkB+uNnhe/JoQZ+cc/26cnPByUFFEYH90V1iNGV54E/2aBwL+vf
 b/+sg1V2opcq1oR15jBICynN8611gr58VfhFSUw3qBHB16lTv+CnRFBynmv0ZI78epy1
 ThcKgcS0HzekL9+ho+VHN3Mvjwhoh8TTGmIyhTeBE6snv7tyAySLoLWTBt2OW4mUz5pn Fg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30vtdkjt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 06:22:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 06:22:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 06:22:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 06:22:43 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id D7EE93F703F;
        Fri,  8 May 2020 06:22:41 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 7/7] net: atlantic: unify
 get_mac_permanent
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
 <20200507081510.2120-8-irusskikh@marvell.com>
 <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
 <20200508131042.GP208718@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <41cbd649-6896-9284-694d-316c10ca17ea@marvell.com>
Date:   Fri, 8 May 2020 16:22:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200508131042.GP208718@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_13:2020-05-08,2020-05-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> Right, but why do you have your own mac generation rather than using
>>> eth_hw_addr_random(). You need to set NET_ADDR_RANDOM for example,
>>> just use standard helpers, please.
>>
>> We want this still be an Aquantia vendor id MAC, not a fully random mac.
>> Thats why the logic below randomizes only low three octets.
> 
> Hi Igor
> 
> How safe is that?  It reduces the available pool space by 22
> bits. It greatly increases the likelihood of a collision.

>>>> +	get_random_bytes(&rnd, sizeof(unsigned int));
>>>> +	l = 0xE300 0000U | (0xFFFFU & rnd) | (0x00 << 16);
>>>> +	h = 0x8001300EU;
> 
> Is this Marvell/Aquantias OUI? Are you setting the locally
> administered bit? You probably should be, since this is local, not
> issued with a guarantee of being unique. 

Yes, thats Aquantia's ID: 300EE3

Honestly, the subject of the discussion are only adapters with zeroed, not
burned MACs. In production there could not exist such adapters. We do have
this code mainly to cover engineering samples some of which comes unflashed.

So overall, I feel its abit overkill to care about collisions.
But we still like to see our engineering samples to have our OUI for ease of
scripting and maintenance.

Regards,
  Igor
