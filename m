Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A4B27E3D3
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgI3Ieb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:34:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbgI3Iea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:34:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U8UmkY013329;
        Wed, 30 Sep 2020 01:34:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=kWT+B8dAfBdWfM9VjZZmb2Ae7WkDZwDzDyb8AXfIeKQ=;
 b=V9SOF6+vEz7XvCZ9ia6etI8xZPtjBJN1FYpoL4i8I2KNXMWlSmfsk5pzyfnII22cLgjt
 0lnP4JgizqzGJoMd0ueHIRYG6usR8B30xCLKI9Py90gTqMFI5cANcelpTSAldAyVewTF
 491NWchRkll+E15IFl2z7AFySpJWOKdARdbE3+YIgtjXh59xC58PBDN3RVeqkDlTUYZB
 IRZ02QJoinx2+DqsDm3PTU5twVRHPVqaJRxXTXZOAGw+aZ6Z/UL8ZMg7lols8ZvhKasT
 /j+rJD4kMChkqwdJnzqJYFC7JAtGeWQOEL74op+nW6pNsQsUzNzCyA3CIf4D+856z3P+ 3w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemfm6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 01:34:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 01:34:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Sep 2020 01:34:24 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id B40013F703F;
        Wed, 30 Sep 2020 01:34:22 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: atlantic: implement phy downshift
 feature
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-3-irusskikh@marvell.com>
 <20200929171030.GC3996795@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <0f71cbca-a8b3-5180-2cf8-391e73e2ee53@marvell.com>
Date:   Wed, 30 Sep 2020 11:34:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101
 Thunderbird/82.0
MIME-Version: 1.0
In-Reply-To: <20200929171030.GC3996795@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_05:2020-09-29,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 
> Hi Igor
> 
> I think all other implementations return -EINVAL or -E2BIG or similar
> when the value is not supported.
> 
> Also, given that a u8 is being passed, is cfg->downshift_counter > 255
> possible? I'm not even sure 255 makes any sense. Autoneg takes around
> 1.5s, maybe longer. Do you really want to wait 255 * 1.5 seconds
> before downshifting? Even 15*1.5 seems a long time.

Hi Andrew, here I'm just blindly follow the value limits of firmware interface
(two device revisions have different counter field width here).

To make behavior consistent you are right, we probably can leave 15 max and
return EINVAL otherwise.

Igor
