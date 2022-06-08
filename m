Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AAE5424A4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiFHGBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238717AbiFHFwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:52:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E750AFAED;
        Tue,  7 Jun 2022 20:35:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257NfeKx014363;
        Wed, 8 Jun 2022 02:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=tzFAQqmTFkqGsbHjDHQsRsNbCV384tWaHO9lvOcIrVs=;
 b=Ye+YGeenYcBmScBViqtGQxdm8aYdrLc1wFf4SWxFxyM9LDqk7CgodqnhhtPMD8AGjrBP
 ZOyb10NoJv1+xYfcVuhBBfIuPl18rTGGpRrZNwbOJoeHXK+Lt+R7pOqjie+yXcmmAbjF
 s/JNFhHDkaSqfY446cIx2gs5DrmtM+QRAcprkntZZti3vYGorY+8NQlI/93/Apx0DmJc
 qZczfSQlOacWc7e4w3xarGhw9uFKFxcdKJc2/8eQSogzOWZl/JFUVkVFRCU67qdyz4Oh
 H0ZugGbLmfu1Hd3aTo9JhrhAXrIbxa8OZuND3cDzv3qLvrE6OPgPg68VbtLaUc5TCXoN Kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmwff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2582ATYg037917;
        Wed, 8 Jun 2022 02:28:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu3349h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:27:59 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2582RxlP032073;
        Wed, 8 Jun 2022 02:27:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33499-1;
        Wed, 08 Jun 2022 02:27:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-media@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] fix a common error of while loop condition in error path
Date:   Tue,  7 Jun 2022 22:27:53 -0400
Message-Id: <165465514543.8982.16992682001018007600.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 41BhbBr77pfcU9Yr9dVAy-63i_lQGxSG
X-Proofpoint-ORIG-GUID: 41BhbBr77pfcU9Yr9dVAy-63i_lQGxSG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 May 2022 23:34:50 +0800, Chengguang Xu wrote:

> There is a common error of while loop condition which misses
> the case '(--i) == 0' in error path. This patch series just
> tries to fix it in several driver's code.
> 
> Note: I'm not specialist of specific drivers so just compile tested
> for the fixes.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[3/6] scsi: ipr: fix missing/incorrect resource cleanup in error case
      https://git.kernel.org/mkp/scsi/c/d64c49191132
[5/6] scsi: pmcraid: fix missing resource cleanup in error case
      https://git.kernel.org/mkp/scsi/c/ec1e8adcbdf6

-- 
Martin K. Petersen	Oracle Linux Engineering
