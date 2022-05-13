Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303A3526601
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381957AbiEMPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiEMPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:25:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C46E0CD;
        Fri, 13 May 2022 08:25:18 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DFBouj023613;
        Fri, 13 May 2022 15:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Rs/HrYaFsVOG7pHzpWHMzkvZ8QnbJVdvVi9OpbPAeQ8=;
 b=XquKzgjsrizj4CfhcryNFVGqew5wyyd7HPiDR9cLxA/QDQCBSyzQ3d4A+o5zkXiaJAUX
 uYdgcRXvAXKhfn14LipL3IDS6QPy1nl0ZpHRDmTYSdxaIsp+oDlqKWhgnTlhW0H0VegT
 6f0XP/GtHdx6033jI2pf54HAI+TZSN4C3+345s1KBUw6ygzjiQtQ9G12DROr/KIURWcp
 D8q/7hu9aO6VxzekJS98QeVeeVOaIr4tucAriBBjecxgt93rSWsQKCL+HGFo3ASZMOGY
 TW1XRuw2FsM1iiOi/3UQZqTFaiytFNegAdnmqbnOuPgqG7yextuGnwf6US7V4/aJuhsp DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1srpr8pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:24:54 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DFFQbg008263;
        Fri, 13 May 2022 15:24:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1srpr8nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:24:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DFOp4I014120;
        Fri, 13 May 2022 15:24:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk4r9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:24:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DFOOJ914549438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 15:24:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96179A4053;
        Fri, 13 May 2022 15:24:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D701A404D;
        Fri, 13 May 2022 15:24:46 +0000 (GMT)
Received: from sig-9-65-91-25.ibm.com (unknown [9.65.91.25])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 15:24:46 +0000 (GMT)
Message-ID: <06062b288d675dc060f33041e9b2009c151698e6.camel@linux.ibm.com>
Subject: Re: [PATCH v7] efi: Do not import certificates from UEFI Secure
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
Date:   Fri, 13 May 2022 11:24:45 -0400
In-Reply-To: <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
         <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
         <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
         <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
         <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nSTyBu9TLw378bJvOtb7YdyATbWM_IHn
X-Proofpoint-ORIG-GUID: cEKFVC3VVbEMtznL2Syom3um3gN35hor
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=793 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aditya,

On Fri, 2022-04-15 at 17:02 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> On Apple T2 Macs, when Linux attempts to read the db and dbx efi variables
> at early boot to load UEFI Secure Boot certificates, a page fault occurs
> in Apple firmware code and EFI runtime services are disabled with the
> following logs:

Are there directions for installing Linux on a Mac with Apple firmware
code?  Are you dual booting Linux and Mac, or just Linux?  While in
secure boot mode, without being able to read the keys to verify the
kernel image signature, the signature verification should fail.

Has anyone else tested this patch?

thanks,

Mimi


