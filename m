Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05974FE6AE
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358018AbiDLRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiDLRTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:19:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540DD517EE;
        Tue, 12 Apr 2022 10:17:00 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEn26n024425;
        Tue, 12 Apr 2022 17:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=VpPiPdJueworOs7vPPFQzle2AMcIoQ96/wEqZJ/Dp6Y=;
 b=gjfgzbUIe0psKkRn2yzGaMfUNKG1BGq/8a6kwi+yO0Zcng8mN4c6IkLjcSGNTdMA9vz5
 CPRiird4eKc4H2l6shgbtpthwDZRBAIUH1Tq3mIfobY5ODRiEpfw9VtGfYF1jb1mkcaV
 pXkh/1RbNR4Wpg4kK8812b3yFs0jp3pb93qcqjD+C4ajTEekGcLXjKtoHNKAIi1JHe+T
 c1rwnNPZzk7Z9eLYOWO0VXov2R0hJ95+Wrz452nAPMMu05phjpcwAf7zOQ6xjO7Bno1c
 N4bMENj7UOezQeW0pYyV4EDNb4ESRiTyKJmitV72G7opp5SQ/k95tYP06uDFNl2JGzrg +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdaqkvngv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 17:16:40 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CGtBZ4032351;
        Tue, 12 Apr 2022 17:16:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdaqkvnga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 17:16:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CHGM9W015738;
        Tue, 12 Apr 2022 17:16:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8m8tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 17:16:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CHGY4426411336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 17:16:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22863A4054;
        Tue, 12 Apr 2022 17:16:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F34A1A4062;
        Tue, 12 Apr 2022 17:16:30 +0000 (GMT)
Received: from sig-9-65-64-123.ibm.com (unknown [9.65.64.123])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 17:16:30 +0000 (GMT)
Message-ID: <6545f8241f3d41dd0f55997bfb85ad0de9f1c3e3.camel@linux.ibm.com>
Subject: Re: [PATCH v4 RESEND] efi: Do not import certificates from UEFI
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
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 12 Apr 2022 13:16:30 -0400
In-Reply-To: <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
         <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YAIrI7YKZQk-OE0GoS9uQU3Mjgf1WVgT
X-Proofpoint-ORIG-GUID: azcNPx-bwu6g0GOenyLWoALybZvGeW3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 16:44 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> macOS and Windows are allowed to boot on these machines. Moreover, loading
> UEFI Secure Boot certificates is not supported on these machines on Linux.
> An attempt to do so causes a crash with the following logs :-
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
> As a result of not being able to read or load certificates, secure boot
> cannot be enabled. This patch prevents querying of these UEFI variables,
> since these Macs seem to use a non-standard EFI hardware.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> v2 :- Reduce code size of the table.
> v3 :- Close the brackets which were left open by mistake.
> v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_first_match()
> v4 RESEND :- Add stable to cc
>  .../platform_certs/keyring_handler.h          |  8 +++++
>  security/integrity/platform_certs/load_uefi.c | 35 +++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/security/integrity/platform_certs/keyring_handler.h b/security/integrity/platform_certs/keyring_handler.h
> index 284558f30..212d894a8 100644
> --- a/security/integrity/platform_certs/keyring_handler.h
> +++ b/security/integrity/platform_certs/keyring_handler.h
> @@ -35,3 +35,11 @@ efi_element_handler_t get_handler_for_mok(const efi_guid_t *sig_type);
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
> index 5f45c3c07..c3393b2b1 100644
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
> @@ -12,6 +13,33 @@
>  #include "../integrity.h"
>  #include "keyring_handler.h"
>  
> +/*
> + * Apple Macs with T2 Security chip seem to be using a non standard
> + * implementation of Secure Boot. For Linux to run on these machines
> + * Secure Boot needs to be turned off, since the T2 Chip manages
> + * Secure Boot and doesn't allow OS other than macOS or Windows to
> + * boot. If turned off, an attempt to get certificates causes a crash,
> + * so we simply prevent doing the same.
> + */

Both the comment here and the patch description above still needs to be
improved.  Perhaps something along these lines.

Secure boot on Apple Macs with a T2 Security chip cannot read either
the EFI variables or the certificates stored in different db's (e.g.
db, dbx, MokListXRT).  Attempting to read them causes ...   

Avoid reading the EFI variables or the certificates stored in different
dbs.  As a result, without certificates secure boot signature
verification fails.

thanks,

Mimi


> +static const struct dmi_system_id uefi_skip_cert[] = {
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
> @@ -138,6 +166,13 @@ static int __init load_uefi_certs(void)
>  	unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
>  	efi_status_t status;
>  	int rc = 0;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id) {
> +		pr_err("Getting UEFI Secure Boot Certs is not supported on T2 Macs.\n");
> +		return false;
> +	}
>  
>  	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
>  		return false;


