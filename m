Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB334FE46C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356876AbiDLPQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356869AbiDLPQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:16:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFCF387B9;
        Tue, 12 Apr 2022 08:14:35 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEndSf013362;
        Tue, 12 Apr 2022 15:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=z9Mc5Z7O6/eJFTtDaBXWB7HJdfgDz8mO40uWSlWFwuM=;
 b=UulRKzuIDkGh3PuHaW7kBrObwfogo6WSMRVrgQIYPwN6FqWUvZ8tc39XUrcUEs6abGdV
 YVj5XUtDu0dAaG1cOJQa7kWJL22FrT9/va1NqYd/CCJUbhoYB/4+f3DgMZ627ULyKvW1
 nkrf10qEs06vPe1Co7l7PsB98xjVxyYSSkLAvj7BTfbbNI2wJZPh/ZZCm86rWaT9T2I0
 JJL96mh5Uy4jGvSLzOxPqqSr3Fr+f7dVbzwbnZQudhHt6nLusijH81IIxuYNs4ysmPHK
 CySGzryX3edjmlN7scc3/lWxjuO7OKWD5hnSG58vcFtGc8N/cuyMGYb4gVxmr6LTlhqP /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b65sh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:14:15 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFBVeh028406;
        Tue, 12 Apr 2022 15:14:14 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b65sg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:14:14 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CEvv5d031030;
        Tue, 12 Apr 2022 15:14:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3fbsj03275-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:14:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFE98V53281108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:14:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54CFF42042;
        Tue, 12 Apr 2022 15:14:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B1B54203F;
        Tue, 12 Apr 2022 15:14:06 +0000 (GMT)
Received: from sig-9-65-64-123.ibm.com (unknown [9.65.64.123])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 15:14:06 +0000 (GMT)
Message-ID: <2913e2998892833d4bc7d866b99dcd9bd234e82e.camel@linux.ibm.com>
Subject: Re: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "jarkko@kernel.org" <jarkko@kernel.org>,
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
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>
Date:   Tue, 12 Apr 2022 11:13:52 -0400
In-Reply-To: <B857EF0F-23D7-4B82-8A1E-7480C19C9AC5@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
         <B857EF0F-23D7-4B82-8A1E-7480C19C9AC5@live.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VL29UvswhcIeofTBN-DnUeLg90zeqr8c
X-Proofpoint-ORIG-GUID: -AP3CmwIOBSGN_aB583esCRjb3Y92MuS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 14:13 +0000, Aditya Garg wrote:
> >> @@ -138,6 +181,11 @@ static int __init load_uefi_certs(void)
> >>      unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
> >>      efi_status_t status;
> >>      int rc = 0;
> >> +    const struct dmi_system_id *dmi_id;
> >> +
> >> +    dmi_id = dmi_first_match(uefi_skip_cert);
> >> +    if (dmi_id)
> >> +            return 0;
> > 
> > uefi_check_ignore_db(), get_cert_list(), uefi_check_ignore_db(), and
> > /load_moklist_certs() are all defined all static and are gated here by
> > this dmi_first_match(). There's probably no need for any of the other
> > calls to dmi_first_match().
> I couldn’t get you here. Could you elaborate?

dmi_first_match() is called here at the beginning of load_uefi_certs().
Only if it succeeds would uefi_check_ignore_db(), get_cert_list(),
uefi_check_ignore_db(), or
load_moklist_certs() be called.  Is there a need for adding a call to
dmi_first_match() in any of these other functions?

thanks,

Mimi

> > 
> > Like in all the other cases, there should be some sort of message. At
> > minimum, there should be a pr_info().
> > 
> >> 
> >>      if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
> >>              return false;
> > 


