Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871CF4DE5D3
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 04:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbiCSEAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242119AbiCSD7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 23:59:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6918C12A8F3;
        Fri, 18 Mar 2022 20:57:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J2ro58012531;
        Sat, 19 Mar 2022 03:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=dOCvppNUKgOlcA89bNUdrq8FTQRYfsjfsvR3rEo7hmg=;
 b=rB4F0btdvmuQ8qSVzB0TI/MVdj6L1wLlPT1srOv4birzBP2VsA5D9mxqDnty9FGI031e
 OhuXiDi8PP/hnk9+43pScgnlvc1Msx3IXhpur+XlVll5oz+03KUF4YG2ZJeO5ctAVyuc
 ABInatOkvEpdjQe0XOBM3Vw23gTi3RCDw1NbsqI8/p8gXop58M1CrcTLpLi34DxilkOw
 aIKWvxzBLmxogO1BmHkA0n6pbxmOlCrA4EQcUelFgQP2O0W9a5LqlQOoSqpIeuQaOZbZ
 7pKjNVt7qrQPqi5lf6wtbxwtbMHhpxhomcEA8IcEfMLaUK5a8MKBz0qkUbZ41JgSbvMB dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss016q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3uvsm007045;
        Sat, 19 Mar 2022 03:57:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:14 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qm007126;
        Sat, 19 Mar 2022 03:57:13 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-6;
        Sat, 19 Mar 2022 03:57:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>, linux-can@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-rdma@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        linux-s390@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        Shayne Chen <shayne.chen@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jiri Olsa <jolsa@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        linux-staging@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-power@fi.rohmeurope.com, linux-mtd@lists.infradead.org,
        target-devel@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-mediatek@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 00/30] fix typos in comments
Date:   Fri, 18 Mar 2022 23:56:56 -0400
Message-Id: <164766213032.31329.14855996441316567317.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ryygBDbx4ESlJehbCVsBuy2qL-PPuldd
X-Proofpoint-GUID: ryygBDbx4ESlJehbCVsBuy2qL-PPuldd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 12:53:24 +0100, Julia Lawall wrote:

> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 

Applied to 5.18/scsi-queue, thanks!

[02/30] scsi: lpfc: fix typos in comments
        https://git.kernel.org/mkp/scsi/c/9a866e6aaf4e
[17/30] scsi: elx: libefc_sli: fix typos in comments
        https://git.kernel.org/mkp/scsi/c/8037185d1ad8
[24/30] scsi: qla2xxx: fix typos in comments
        https://git.kernel.org/mkp/scsi/c/5419e0f15622
[25/30] treewide: fix typos in comments
        https://git.kernel.org/mkp/scsi/c/9d05790f5187

-- 
Martin K. Petersen	Oracle Linux Engineering
