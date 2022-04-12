Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5354FE160
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353993AbiDLM65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355633AbiDLM60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:58:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36A75C86F;
        Tue, 12 Apr 2022 05:33:05 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CBBxYi029884;
        Tue, 12 Apr 2022 12:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=vyaBAvLraJ2tua5EQaq+mkfRTcOYDbXcnxO/FeOjC/k=;
 b=H5SUElumn5gMoOxYd2hW7du6gP4afvBGMDsyxb7nHOweHmItj1WDZJpbB4bH9n8rO8O0
 psNHTuvdd9hUgdPYp0dRQ7ORroZd3Jku+ELf+xKgG3Y9VLuFzMnJKTwCRbNHHnFs6Jz0
 EsFIZZEltkcrieTRMUBBJ+OW/2dsyS10g0SbEvIsAejgewm1l3hTTs+71uyN458dNK3N
 9XnVp4LLT1Ug2yGdS5kuEB30SyiEBDFThP2v0y8VbeB6CgxdGDj8aOLbq2GSJoOdg2rc
 ccO52nlg/dt4FJp31E9EL6kdkXSvdfxh52gYOxNO2T+e1Hiqa2NBs2nr6ZRgbNteGXFi Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5htcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 12:32:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CCUC0O008163;
        Tue, 12 Apr 2022 12:32:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5htbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 12:32:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CCDnoX030588;
        Tue, 12 Apr 2022 12:32:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj4w0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 12:32:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CCWeLQ40501638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 12:32:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 920D75204E;
        Tue, 12 Apr 2022 12:32:40 +0000 (GMT)
Received: from sig-9-65-64-123.ibm.com (unknown [9.65.64.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 57E9852050;
        Tue, 12 Apr 2022 12:32:37 +0000 (GMT)
Message-ID: <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
Subject: Re: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
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
        "admin@kodeit.net" <admin@kodeit.net>
Date:   Tue, 12 Apr 2022 08:32:36 -0400
In-Reply-To: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P0qJhkOPK2C5QZTvOJ6EMKg6-W1Da97M
X-Proofpoint-GUID: CPrrncJGw3lrPoyPHwhMngG2z1YirLDY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_04,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-04-10 at 10:49 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> macOS and Windows are allowed to boot on these machines. Thus we need to
> disable secure boot for Linux.

The end result might be "disable secure boot for Linux", but that isn't
what the code is actually doing.  As a result of not being able to read
or load certificates, secure boot cannot be enabled.  Please be more
precise.

> If we boot into Linux after disabling
> secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
> fail to start, with the following logs in dmesg
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
> This patch prevents querying of these UEFI variables, since these Macs
> seem to use a non-standard EFI hardware
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> v2 :- Reduce code size of the table.
> V3 :- Close the brackets which were left open by mistake.
>  .../platform_certs/keyring_handler.h          |  8 ++++
>  security/integrity/platform_certs/load_uefi.c | 48 +++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/security/integrity/platform_certs/keyring_handler.h b/security/integrity/platform_certs/keyring_handler.h
> index 2462bfa08..cd06bd607 100644
> --- a/security/integrity/platform_certs/keyring_handler.h
> +++ b/security/integrity/platform_certs/keyring_handler.h
> @@ -30,3 +30,11 @@ efi_element_handler_t get_handler_for_db(const efi_guid_t *sig_type);
>  efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type);
>  
>  #endif
> +
> +#ifndef UEFI_QUIRK_SKIP_CERT
> +#define UEFI_QUIRK_SKIP_CERT(vendor, product) \
> +		 .matches = { \
> +			DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
> +			DMI_MATCH(DMI_PRODUCT_NAME, product), \
> +		},
> +#endif
> diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
> index 08b6d12f9..f246c8732 100644
> --- a/security/integrity/platform_certs/load_uefi.c
> +++ b/security/integrity/platform_certs/load_uefi.c
> @@ -3,6 +3,7 @@
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/cred.h>
> +#include <linux/dmi.h>
>  #include <linux/err.h>
>  #include <linux/efi.h>
>  #include <linux/slab.h>
> @@ -12,6 +13,32 @@
>  #include "../integrity.h"
>  #include "keyring_handler.h"
>  
> +/* Apple Macs with T2 Security chip don't support these UEFI variables.

Please refer to Documentation/process/coding-style.rst for the format
of multi-line comments.

> + * The T2 chip manages the Secure Boot and does not allow Linux to boot
> + * if it is turned on. If turned off, an attempt to get certificates
> + * causes a crash, so we simply return 0 for them in each function.
> + */
> +

No need for a blank line here.

> +static const struct dmi_system_id uefi_skip_cert[] = {
> +
No need for a blank here either.

> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
> +	{ }
> +};
> +
>  /*
>   * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
>   * it does.
> @@ -21,12 +48,18 @@
>   * is set, we should ignore the db variable also and the true return indicates
>   * this.
>   */
> +
Or here

>  static __init bool uefi_check_ignore_db(void)
>  {
>  	efi_status_t status;
>  	unsigned int db = 0;
>  	unsigned long size = sizeof(db);
>  	efi_guid_t guid = EFI_SHIM_LOCK_GUID;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id)
> +		return 0;

The function returns a bool.  Return either "true" or "false".

>  
>  	status = efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
>  	return status == EFI_SUCCESS;
> @@ -41,6 +74,11 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
>  	unsigned long lsize = 4;
>  	unsigned long tmpdb[4];
>  	void *db;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id)
> +		return 0;

The return value here should be NULL.

>  
>  	*status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
>  	if (*status == EFI_NOT_FOUND)
> @@ -85,6 +123,11 @@ static int __init load_moklist_certs(void)
>  	unsigned long moksize;
>  	efi_status_t status;
>  	int rc;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id)
> +		return 0;
>  
>  	/* First try to load certs from the EFI MOKvar config table.
>  	 * It's not an error if the MOKvar config table doesn't exist
> @@ -138,6 +181,11 @@ static int __init load_uefi_certs(void)
>  	unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
>  	efi_status_t status;
>  	int rc = 0;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id)
> +		return 0;

uefi_check_ignore_db(), get_cert_list(), uefi_check_ignore_db(), and
/load_moklist_certs() are all defined all static and are gated here by
this dmi_first_match().  There's probably no need for any of the other
calls to dmi_first_match().

Like in all the other cases, there should be some sort of message.  At
minimum, there should be a pr_info().

>  
>  	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
>  		return false;

thanks,

Mimi

