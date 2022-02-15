Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB324B6189
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 04:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiBODT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 22:19:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiBODTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 22:19:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA52252D;
        Mon, 14 Feb 2022 19:19:45 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2TqXs014923;
        Tue, 15 Feb 2022 03:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=FshK+SY46LCCks86OhomWMc97OEykwuZ1jfaUJeYJCo=;
 b=p5aq//voQuFsznU3EwJLBgz7gtLt5AjbETpNRfaIw7zZ2tdhVrs7POydyY9S+R3A0pKH
 DEkFHuEGY4anG+9VMi7gCkjpZQy1l5sQo02lzku/22uZcePrmd8bHu52+jQYLCPtlIrW
 LLw5fMkc7ag4PVnKuyK0wy543JPcclS97j3xQdGajzts6xd/UD3jrnfzs0ccOk06wSFA
 PQA+U1OKfcYnd6Q81Kiyfm6P48tRpxqNfuKzdcGra3e1lqZUcQ/72x3eh+AxBC5b9Vbm
 iXk9hvX9fdbGlHD4u+uYY6n09S+/2NF14j4SUvy/fRLu8unWvDnwV+c3gr+Y9KNllaWa uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt6e8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3HGGH058567;
        Tue, 15 Feb 2022 03:19:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:29 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMPA064243;
        Tue, 15 Feb 2022 03:19:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-5;
        Tue, 15 Feb 2022 03:19:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        MPT-FusionLinux.pdl@broadcom.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/9] use GFP_KERNEL
Date:   Mon, 14 Feb 2022 22:19:17 -0500
Message-Id: <164489513314.15031.15565838256267303879.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210204223.104181-1-Julia.Lawall@inria.fr>
References: <20220210204223.104181-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: nDoBGwfRKH754qY0VCkX57qyJcN4xiU4
X-Proofpoint-ORIG-GUID: nDoBGwfRKH754qY0VCkX57qyJcN4xiU4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 21:42:14 +0100, Julia Lawall wrote:

> Platform_driver and pci_driver probe functions aren't called with
> locks held and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.
> 
> All changes have been compile-tested.
> 

Applied to 5.18/scsi-queue, thanks!

[8/9] mptfusion: use GFP_KERNEL
      https://git.kernel.org/mkp/scsi/c/f69b0791df1d

-- 
Martin K. Petersen	Oracle Linux Engineering
