Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C322C502DBB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355839AbiDOQ3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiDOQ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:29:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F13B7C7A0;
        Fri, 15 Apr 2022 09:27:04 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23FFOHaJ020889;
        Fri, 15 Apr 2022 16:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=HeJ2w+n1oEAcUUXnghppzmXxVQYyq3hGhL8kqyl4vbU=;
 b=dR++cuynruEufF0J6OXdSEErjMVQrEFIMH6FwfGvLHzzg7crX2Uc2UUPnfpVbVcgyK9W
 FXWGy8cUXSPJFxe+LDPBgBNk+1aUwwJR8b3YRiu3KTjMwi6HLz35itGyMJGtxosl7nVB
 3Sve+jYV4AgYZLpYmC4dNEI6bjhsJxlXyOgxZJC43rpZfzoGnjALHIC70/J5F3o50ZJi
 1joxmpUwp7e4FZMrmR5h/6O/BJ2oKvJecQxK0P1nTmLXRBYXs4WVc87mAV2qOFyKhehK
 TOezYvqIVL+Qeg8EGOT9J5TsPrtC+QMs3/3DTBeFooDUyQLZU8WACrU7tujwchaflRQU nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh5y2nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 16:26:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23FGFGNN012502;
        Fri, 15 Apr 2022 16:26:37 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh5y2na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 16:26:37 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23FGI8Fg017541;
        Fri, 15 Apr 2022 16:26:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fb1s90nvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 16:26:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23FGQg2m33358180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Apr 2022 16:26:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE9311C04A;
        Fri, 15 Apr 2022 16:26:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B424311C058;
        Fri, 15 Apr 2022 16:26:29 +0000 (GMT)
Received: from sig-9-65-86-1.ibm.com (unknown [9.65.86.1])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Apr 2022 16:26:29 +0000 (GMT)
Message-ID: <faa20ad9a934269e6292ffdb385ebec2a2475454.camel@linux.ibm.com>
Subject: Re: [PATCH v6] efi: Do not import certificates from UEFI Secure
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
Date:   Fri, 15 Apr 2022 12:26:29 -0400
In-Reply-To: <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
         <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
         <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
         <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nN3HLeHLlVR0Eb_A9acKJ5vhGvZhnFHj
X-Proofpoint-ORIG-GUID: P_6vwYLd9u46h_C-sIf9g8RDJ6so5R3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-04-15 at 06:19 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> On Apple T2 Macs, when Linux attempts to read the db and dbx efi variables
> at early boot to load UEFI Secure Boot certificates, a page fault occurs
> in Apple firmware code and EFI runtime services are disabled with the
> following logs:
> 
> [Firmware Bug]: Page fault caused by firmware at PA: 0xffffb1edc0068000
> WARNING: CPU: 3 PID: 104 at arch/x86/platform/efi/quirks.c:735 efi_crash_gracefully_on_page_fault+0x50/0xf0
> (Removed some logs from here)
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
> This patch skips reading these UEFI variables and thus prevents the crash.

Instead of "This patch skips reading" say "Avoid reading".

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>

After making these minor changes, both above and below, 
	Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

> ---
> v2 :- Reduce code size of the table.
> v3 :- Close the brackets which were left open by mistake.
> v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_first_match()
> v4 RESEND :- Add stable to cc
> v5 :- Rewrite the description
> v6 :- Make description more clear
>  .../platform_certs/keyring_handler.h          |  8 +++++
>  security/integrity/platform_certs/load_uefi.c | 33 +++++++++++++++++++
>  2 files changed, 41 insertions(+)
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
> index 5f45c3c07..1a7e7d597 100644
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
> @@ -12,6 +13,31 @@
>  #include "../integrity.h"
>  #include "keyring_handler.h"
>  
> +/*
> + * On T2 Macs reading the reading the db and dbx efi variables to load UEFI
> + * Secure Boot certificates causes occurrence of a page fault in Apple's
> + * firmware and a crash disabling EFI runtime services. The following quirk
> + * skips reading these variables.
> + */
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
> @@ -138,6 +164,13 @@ static int __init load_uefi_certs(void)
>  	unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
>  	efi_status_t status;
>  	int rc = 0;
> +	const struct dmi_system_id *dmi_id;
> +
> +	dmi_id = dmi_first_match(uefi_skip_cert);
> +	if (dmi_id) {
> +		pr_err("Getting UEFI Secure Boot Certs is not supported on T2 Macs.\n");

Replace "Getting" with "Reading".

thanks,

Mimi

> +		return false;
> +	}
>  
>  	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
>  		return false;


