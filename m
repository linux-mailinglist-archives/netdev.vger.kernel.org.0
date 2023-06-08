Return-Path: <netdev+bounces-9108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6E472748E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72B2328158D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712B8EBF;
	Thu,  8 Jun 2023 01:43:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6227AA52
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:43:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BA826B8;
	Wed,  7 Jun 2023 18:43:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357N6Wgj007974;
	Thu, 8 Jun 2023 01:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=mFKIyYLsNQOscJFsa1wB8vRCWUI5xZUPEr0GCqcpNhE=;
 b=oOjz7dXtcBHJjLfKIzY/H+TLb46agXTkuSGNT0+jVN8b/9/qXf+mGErhazy9DufbGqXG
 bO/Ibm10iohTU1AoIUtt5aLtnN171rleEoZIPnR+EtNqMBNguznKwWRFh2X7+hLPNaxU
 7h0zetwKukKoarUNDopn6H9cfxusuqEIGDyTXTyy4A0eKJnzeDYlc5Fr564gklzqwUUl
 7y+rEdbUMpSRE0/dMsQ3UHhLBVyNo2g6x8+vYzYKA/c/3s2JCRu4t5ioeomTm+Xa6PWD
 WRY+RWuh72/tHszEZ8V43TYj+z3UTLML2UlgQnSHbx3raZpj1rJT0X/XsAv8i/wmIOQ2 eA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6rk4we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jun 2023 01:42:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3580Vp8F037094;
	Thu, 8 Jun 2023 01:42:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hytbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jun 2023 01:42:49 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQVB031871;
	Thu, 8 Jun 2023 01:42:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-17;
	Thu, 08 Jun 2023 01:42:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>, Richard Cochran <richardcochran@gmail.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 00/44] treewide: Remove I/O port accessors for HAS_IOPORT=n
Date: Wed,  7 Jun 2023 21:42:21 -0400
Message-Id: <168618844281.2636448.12578848394814985642.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522105049.1467313-1-schnelle@linux.ibm.com>
References: <20230522105049.1467313-1-schnelle@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=884 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-ORIG-GUID: MzrzAX_nsiU9Fdxy46ABlaqqJPB34hNL
X-Proofpoint-GUID: MzrzAX_nsiU9Fdxy46ABlaqqJPB34hNL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 22 May 2023 12:50:05 +0200, Niklas Schnelle wrote:

> Some platforms such as s390 do not support PCI I/O spaces. On such platforms
> I/O space accessors like inb()/outb() are stubs that can never actually work.
> The way these stubs are implemented in asm-generic/io.h leads to compiler
> warnings because any use will be a NULL pointer access on these platforms. In
> a previous patch we tried handling this with a run-time warning on access. This
> approach however was rejected by Linus[0] with the argument that this really
> should be a compile-time check and, though a much more invasive change, we
> believe that is indeed the right approach.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[21/44] mpt fusion: add HAS_IOPORT dependencies
        https://git.kernel.org/mkp/scsi/c/c3f903472ffa
[31/44] scsi: add HAS_IOPORT dependencies
        https://git.kernel.org/mkp/scsi/c/b58b2ba351b0

-- 
Martin K. Petersen	Oracle Linux Engineering

