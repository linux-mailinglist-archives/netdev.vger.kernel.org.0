Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4F746494D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347528AbhLAIQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11676 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344139AbhLAIQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B115qVp028997;
        Wed, 1 Dec 2021 00:12:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=WhCLxsMRAXSy53BKrsEq6OYi0hOtJqSnn0cAr40cKXs=;
 b=TthB8jddzXO8GyK5g/BsPqFIt/rX1wt3HZ8tyITi2XEgJgp6Ck1NHhJsVSeNWlz+ZLqC
 cbac19UtXyb3782dfHiUUoox1r/C3ozma9V0Os8Oc6t2rWl2mFSYQ7WtrCDiqmP+R3e8
 YK5NGuA4RKWbGB6160+3IyW07S9eYgq5duL7FIjHj6Cc3h/DKwiwwRKBir3y5gnBe8pf
 JQH7l5wo5SF+YHxdBtvRcitN5P7NUgNNIkGJLe/hiGEr2VM0AeKcAau+e/2fyKpJriKF
 +LsOCjPXu5bjoE2H76yXUf0EJvx/UmMtQtEAl67ssJt3ufCpxmeszwIneVSYrAbZpofc DQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cnqvyua6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 00:12:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Dec
 2021 00:12:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 1 Dec 2021 00:12:42 -0800
Received: from [10.193.32.68] (unknown [10.193.32.68])
        by maili.marvell.com (Postfix) with ESMTP id 1C6C05B6932;
        Wed,  1 Dec 2021 00:12:28 -0800 (PST)
Message-ID: <374a236a-4fd1-b21a-5dc2-c123204eb593@marvell.com>
Date:   Wed, 1 Dec 2021 09:12:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101
 Thunderbird/95.0
Subject: Re: [EXT] [PATCHv3] ethernet: aquantia: Try MAC address from device
 tree
Content-Language: en-US
To:     Tianhao Chai <cth451@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
CC:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
References: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Ewz3MH2fbNbzbib1YDS5gfWbYTcXMEoA
X-Proofpoint-GUID: Ewz3MH2fbNbzbib1YDS5gfWbYTcXMEoA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tianhao,

> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.
> 
> Signed-off-by: Tianhao Chai <cth451@gmail.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

Regards,
  Igor
