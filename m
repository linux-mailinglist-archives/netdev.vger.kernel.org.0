Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0535B456B01
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhKSHm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:42:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65516 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231828AbhKSHm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 02:42:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ5cgfM000925;
        Thu, 18 Nov 2021 23:39:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Jw8Y6vZJBgPE9zMfzf+cIZsOWLDjM8/Zl/0/39xf/a0=;
 b=HX+aU4o30WIwdZT3R3aKhaI8Cuxn5xU5oGYANml5DqVOGCn5ub4fKaaT+tznDMmBB+x5
 MvPxWVMDz3pvlIFFj2+1iXP7barRBRVlAIgnl0yg+Iqu96cwwyOtbhZjFkvm42U6P8w6
 6ItZGkiqfeurOXnIBrQMCKGkUOdnjcZ+3ywj8hKXxktmOqYR8qBMhD/Fj73F+ieT3YL1
 PiWPic1k60vT0rl2sQD31lciiQ2oUSoWUykjpHpAPIUssRXk7qMhPxMShkGhjfJuRzXU
 Gu9BP9IsTZgFHR+aFKsKyKdtcgV4vH3XDxZjl5egcqdlddgrVNnfiW1fd+f8wxtSp6zU 8w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cdvprthnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 23:39:53 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 18 Nov
 2021 23:39:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 18 Nov 2021 23:39:52 -0800
Received: from [10.9.118.29] (EL-LT0043.marvell.com [10.9.118.29])
        by maili.marvell.com (Postfix) with ESMTP id 29D2C3F706A;
        Thu, 18 Nov 2021 23:39:51 -0800 (PST)
Message-ID: <eb7f2b27-4c8d-f935-18c3-3d70caa0c5c8@marvell.com>
Date:   Fri, 19 Nov 2021 08:39:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101
 Thunderbird/94.0
Subject: Re: [EXT] [PATCH] atlantic: fix double-free in aq_ring_tx_clean
Content-Language: en-US
To:     Zekun Shen <bruceshenzk@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <brendandg@nyu.edu>
References: <YZbAsgT17yxu4Otk@a-10-27-17-117.dynapool.vpn.nyu.edu>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <YZbAsgT17yxu4Otk@a-10-27-17-117.dynapool.vpn.nyu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: U13SChMWGcIWWwJMpn37stDsAxbyJ-vS
X-Proofpoint-GUID: U13SChMWGcIWWwJMpn37stDsAxbyJ-vS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_07,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> We found this bug while fuzzing the device driver. Using and freeing
> the dangling pointer buff->skb would cause use-after-free and
> double-free.
> 
> This bug is triggerable with compromised/malfunctioning devices. We
> found the bug with QEMU emulation and tested the patch by emulation.
> We did NOT test on a real device.
> 
> Attached is the bug report.
> 

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

Thank you for submitting this!

Igor
