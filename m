Return-Path: <netdev+bounces-6386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 396CB716105
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E3E281006
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE6B1E528;
	Tue, 30 May 2023 13:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A346134C8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:04:44 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C6692
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:04:43 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCsBjq024036;
	Tue, 30 May 2023 13:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=dzPAVqwktTw6TxwqxfPZzO3f7vdGfaliGvSZaKhT6A0=;
 b=LrEAzTDG+gjFpLeuJDCD26HlYfjZJdo93FkLdFDhMAKnrFOIrmtkQWnfH9yhJ15H4vV8
 q/r3m85YEJHcSHFRkpXqvDvJJinH2IW7tvpaAvCZlpnA3oAoE413hJO5gEyGXQDFXL/T
 VM++x5Y/YvxfguZDLZHqZ8acWpukQ4GxWmQbIu+z1JiMFwe1kMNhm1cPA0FYu5NXgStm
 nJObwvxHepIiyYQ3/qr/9m0TrUuFXty1mw9BMGalq8Qs+6Es03iRos8U+BCvpNVenECu
 FtWJgdgQKM9RaTz/erZKmkSfWJJG1Uw54u0RLb/NdOyg7r6WSzhh1bSW8kEXxrY6L5/2 nw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwhjc88rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 13:04:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U3ugEg020202;
	Tue, 30 May 2023 13:04:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g51fup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 13:04:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UD4aPg7406092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:04:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 678F92004D;
	Tue, 30 May 2023 13:04:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FD7F20040;
	Tue, 30 May 2023 13:04:36 +0000 (GMT)
Received: from [9.152.212.237] (unknown [9.152.212.237])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 May 2023 13:04:36 +0000 (GMT)
Message-ID: <d6ada86741a440f99b5d6fedff532c8dbe86254f.camel@linux.ibm.com>
Subject: mlx5 driver is broken when pci_msix_can_alloc_dyn() is false with
 v6.4-rc4
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Eli
	Cohen <elic@nvidia.com>, netdev@vger.kernel.org
Date: Tue, 30 May 2023 15:04:36 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U1eE3PGZ2PAlGjQKzT-x7CgdkAT4hvg3
X-Proofpoint-GUID: U1eE3PGZ2PAlGjQKzT-x7CgdkAT4hvg3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Saeed, Eli, Shay,

With v6.4-rc4 I'm getting a stream of RX and TX timeouts when trying to
use ConnectX-4 and ConnectX-6 VFs on s390. I've bisected this and found
the following commit to be broken:

commit 1da438c0ae02396dc5018b63237492cb5908608d
Author: Shay Drory <shayd@nvidia.com>
Date:   Mon Apr 17 10:57:50 2023 +0300

    net/mlx5: Fix indexing of mlx5_irq

    After the cited patch, mlx5_irq xarray index can be different then
    mlx5_irq MSIX table index.
    Fix it by storing both mlx5_irq xarray index and MSIX table index.

    Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
    Signed-off-by: Shay Drory <shayd@nvidia.com>
    Reviewed-by: Eli Cohen <elic@nvidia.com>
    Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

The problem is that our IRQs currently still use a legacy mode instead
of a full fledged IRQ domain. One consequence of that is that
pci_msix_can_alloc_dyn(dev->pdev) returns false. That lands us in the
non dynamic case in mlx5_irq_alloc() where irq->map.index is set to 0.
Now prior to the above commit irq->map.index would later be set to i
(the irq number) but that was replaced with just setting irq-
>pool_index =3D i. For the dynamic case this is fine because
pci_msix_alloc_irq_at() sets it but for the non-dynamic case this leave
it unset. With the following diff the RX/TX timeouts go away:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index db5687d9fec9..94dce3735204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -237,7 +237,7 @@ struct mlx5_irq *mlx5_irq_alloc(struct
mlx5_irq_pool *pool, int i,
                 * vectors have also been allocated.
                 */
                irq->map.virq =3D pci_irq_vector(dev->pdev, i);
-               irq->map.index =3D 0;
+               irq->map.index =3D i;
        } else {
                irq->map =3D pci_msix_alloc_irq_at(dev->pdev,
MSI_ANY_INDEX, af_desc);
                if (!irq->map.virq) {



I'll sent a patch with the above shortly but wanted to give you a heads
up since I'd really like to get this fixed for -rc5 or at least -rc6.

Thanks,
Niklas

