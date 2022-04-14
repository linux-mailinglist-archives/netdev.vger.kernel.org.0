Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009F5501539
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245291AbiDNNuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244814AbiDNNgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:36:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE27197291;
        Thu, 14 Apr 2022 06:31:17 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EC40fE010623;
        Thu, 14 Apr 2022 13:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Iao/172elPaRIHqovgKlBtkJqPYTEmQLWAId3gzfBoQ=;
 b=b2v4IJNIm7tYSuaN0SJtV5BmSBKCWMkHz0m1/p+/3IPuXtxZ1U3AnNPV8mJnZ6MmSi9Q
 X33dzMTS/RDG480icm6tsBkIQzec65ueRWSAUZUYPR6Mzc2IGx0lpvybNFjHW8WYPo/H
 joHcZZZTvRnioEXxmh7oe20hP8eduB6cBA5aUZKhdGQ1l0vA/Ordj5qXw7I+s0ZDHGhK
 w7NLhCKv+QWP6P4VewGseeDDZlqDR83gTTb8PkJ2chf/MRSsaobQhDAdAh46BVdkAMWr
 wYUuW/jjtXtYYLzJmzlbyd3VHAneV/5+kth8Zeq1RBa6xP6nFkli9sV2gg7wIKpq0CU9 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febxa2fss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:30:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23ECqMVf021651;
        Thu, 14 Apr 2022 13:30:51 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febxa2frk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:30:51 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23EDBqEm018348;
        Thu, 14 Apr 2022 13:30:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8pxky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:30:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23EDUkJa45875492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 13:30:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C8254C046;
        Thu, 14 Apr 2022 13:30:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 457A94C040;
        Thu, 14 Apr 2022 13:30:43 +0000 (GMT)
Received: from sig-9-65-66-113.ibm.com (unknown [9.65.66.113])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 13:30:43 +0000 (GMT)
Message-ID: <9aca02b10ff179a8297b06df11bde4faa8a39650.camel@linux.ibm.com>
Subject: Re: [PATCH v5] efi: Do not import certificates from UEFI Secure
 Boot for T2 Macs
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Aditya Garg <gargaditya08@live.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 14 Apr 2022 09:30:42 -0400
In-Reply-To: <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
         <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
         <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T7Bv7bXAvtlxgcOKn8pIqM-vHYNi6XGG
X-Proofpoint-ORIG-GUID: EVD0SNNalMJ_kT4tpShuNJXtj3L9HD09
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_04,2022-04-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-04-13 at 14:04 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> On Apple T2 Macs, when Linux reads the db and dbx efi variables to load
> UEFI Secure Boot certificates, a page fault occurs in Apple firmware
> code and EFI services are disabled with the following logs:
> 
> Call Trace:
>  <TASK>
>  page_fault_oops+0x4f/0x2c0
>  ? search_bpf_extables+0x6b/0x80
>  ? search_module_extables+0x50/0x80
>  ? search_exception_tables+0x5b/0x60
>  kernelmode_fixup_or_oops+0x9e/0x110
>  __bad_area_nosemaphore+0x155/0x190
>  bad_area_nosemaphore+0x16/0x20
>  do_kern_addr_fault+0x8c/0xa0
>  exc_page_fault+0xd8/0x180
>  asm_exc_page_fault+0x1e/0x30
> (Removed some logs from here)
>  ? __efi_call+0x28/0x30
>  ? switch_mm+0x20/0x30
>  ? efi_call_rts+0x19a/0x8e0
>  ? process_one_work+0x222/0x3f0
>  ? worker_thread+0x4a/0x3d0
>  ? kthread+0x17a/0x1a0
>  ? process_one_work+0x3f0/0x3f0
>  ? set_kthread_struct+0x40/0x40
>  ? ret_from_fork+0x22/0x30
>  </TASK>
> ---[ end trace 1f82023595a5927f ]---
> efi: Froze efi_rts_wq and disabled EFI Runtime Services
> integrity: Couldn't get size: 0x8000000000000015
> integrity: MODSIGN: Couldn't get UEFI db list
> efi: EFI Runtime Services are disabled!
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get UEFI dbx list
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get mokx list
> integrity: Couldn't get size: 0x80000000
> 
> This also occurs when some other variables are read (see examples below,
> there are many more), but only when these variables are read at an early
> stage like db and dbx are to load UEFI certs.
> 
> BridgeOSBootSessionUUID-4d1ede05-38c7-4a6a-9cc6-4bcca8b38c14
> KEK-8be4df61-93ca-11d2-aa0d-00e098032b8c
> 
> On these Macs, we skip reading the EFI variables for the UEFI certificates.
> As a result without certificates, secure boot signature verification fails.
> As these Macs have a non-standard implementation of secure boot that only
> uses Apple's and Microsoft's keys (users can't add their own), securely
> booting Linux was never supported on this hardware, so skipping it
> shouldn't cause a regression.

Based on your explanation, there seems to be two issues - inability to
read EFI variables, "users can't add their own" keys.  Neither of which
mean "a non-standard implementation of secure boot".  Please fix the
"cause" and "affect" in the patch description and comments.

thanks,

Mimi

