Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EFA6393BA
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 04:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiKZD2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 22:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKZD22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 22:28:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E0E1BE98;
        Fri, 25 Nov 2022 19:28:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ2hbup007916;
        Sat, 26 Nov 2022 03:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=AcagkFnJ+fxUlscIN6IjL6P7egIgluL1OZhulAL1UnQ=;
 b=mvu81B1jAjb+iQ6MM92frRDUHEr4JjxmPPoaI8lGgelfK0tY26AeAGpXKYQqxl7PfakE
 zKYR5gspEHq4K8A5lXxuzIhtLNaXvmIKO62/MRCp0/7BL781RtS2v7uCoevnZJ3y5Jpe
 o4k15RYgVjtQOzJ7HMVMABblAwr0dtY49pEsscSVs8hehmj/twewXRy1+1LN1vLlT3G/
 v2xYrPsJW6V6XrJm2hokCQMoNB7mRQcHFN2tzIe9dpmq/LftKP6ZeS9lIhBRARfqXgp+
 Eaf1bj/wXzdFOlU5SlpQfuENIvXv9u+TNm6GxzDP01RMy7w2HAFdX8VSqM3T7Hplrxc0 Qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2g1ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1XTWB007302;
        Sat, 26 Nov 2022 03:27:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3988b812-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:47 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AQ3Rhsb028327;
        Sat, 26 Nov 2022 03:27:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3988b7y9-8;
        Sat, 26 Nov 2022 03:27:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fenghua Yu <fenghua.yu@intel.com>, oss-drivers@corigine.com,
        James Smart <james.smart@broadcom.com>,
        Cornelia Huck <cohuck@redhat.com>, dmaengine@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Will Deacon <will@kernel.org>,
        Lee Jones <lee@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Marc Zyngier <maz@kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        linux-ide@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [patch 00/10] genirq/msi: Treewide cleanup of pointless linux/msi.h includes
Date:   Sat, 26 Nov 2022 03:27:39 +0000
Message-Id: <166943312556.1684293.1625990735787388062.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113201935.776707081@linutronix.de>
References: <20221113201935.776707081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=825 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260024
X-Proofpoint-GUID: oUxjHgTGr4WNozsr_LV_OOFyzCy5QslK
X-Proofpoint-ORIG-GUID: oUxjHgTGr4WNozsr_LV_OOFyzCy5QslK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Nov 2022 21:33:54 +0100 (CET), Thomas Gleixner wrote:

> While working on per device MSI domains I noticed that quite some files
> include linux/msi.h just because.
> 
> The top level comment in the header file clearly says:
> 
>   Regular device drivers have no business with any of these functions....
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[03/10] scsi: lpfc: Remove linux/msi.h include
        https://git.kernel.org/mkp/scsi/c/cdd9344e00b4

-- 
Martin K. Petersen	Oracle Linux Engineering
