Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C91527788
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 14:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiEOMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 08:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbiEOMml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 08:42:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B497D17A9C;
        Sun, 15 May 2022 05:42:39 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24F64tN2018967;
        Sun, 15 May 2022 12:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1l2WtRMp20/zQ/ARHctl2Xng4JO8XSuqPYRhaDk3aLw=;
 b=dZMuiPoMk+WxPCjwNoZsekgcEowc7lrwMfmxvnU2IjKVfAJV/io+ABy04qhfwzLhZYrw
 8BchtP3QhnvBBLAxnFLdXUnEA8VRxsZfTcpJiUZaIau+pxO20J2i2iE9IYY/t/0ZX8A7
 lA2H8tbK+DXtzsgMigKOCclwALVh7xStuQAAi3o2nV8Z07jk9QrO2/XvE+St/4/kuhxt
 2uyrWr+RVrdpS+/nSeu4cohuFXCGAMc3kllhzQEppeteR/85wkiZezmO9pLlxGp71LSL
 ixnjBh5E9w2z6QzeYn8p90mDEgwi/X6iNRLxiNp1Glb+xYjBKb7Do8zMadwAHTjLm4Kk VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g2e07x6nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 May 2022 12:42:08 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24FCg7u7016544;
        Sun, 15 May 2022 12:42:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g2e07x6ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 May 2022 12:42:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24FCdeI1022804;
        Sun, 15 May 2022 12:42:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428s208-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 May 2022 12:42:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24FCg3bI22020378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 May 2022 12:42:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E94B811C058;
        Sun, 15 May 2022 12:42:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53EFB11C04A;
        Sun, 15 May 2022 12:42:00 +0000 (GMT)
Received: from sig-9-65-80-60.ibm.com (unknown [9.65.80.60])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 15 May 2022 12:42:00 +0000 (GMT)
Message-ID: <5d5e459069bef1c9c7eddec973987a08c4b16d30.camel@linux.ibm.com>
Subject: Re: [PATCH v7] efi: Do not import certificates from UEFI Secure
 Boot for T2 Macs
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
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Sun, 15 May 2022 08:41:59 -0400
In-Reply-To: <D6CDA21E-CC8F-4DA1-A5A4-8B706CA79182@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
         <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
         <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
         <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
         <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
         <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
         <06062b288d675dc060f33041e9b2009c151698e6.camel@linux.ibm.com>
         <D6CDA21E-CC8F-4DA1-A5A4-8B706CA79182@live.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: saHdDgJSxeCMDniNSm7mqvPsBH743un7
X-Proofpoint-GUID: 2Fr8-VO3Z_jmN7W97rGgdr-O6jwKDpMn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-15_06,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205150065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-13 at 18:31 +0000, Aditya Garg wrote:
> > Are there directions for installing Linux on a Mac with Apple firmware
> > code?  
> 
> Well, directions of installing Linux on an Intel based Mac, which
> includes the T2 Macs is the same as on a normal PC.
> 
> Though, in case of T2 Macs, we for now need to use customised ISOs,
> since some drivers and patches to support T2 Macs are yet to be
> upstreamed.
> 
> An example of installing Ubuntu can be read here on 
> https://wiki.t2linux.org/distributions/ubuntu/installation/
> 
> Talking about the official ISOs, for many distros, since
> CONFIG_LOAD_UEFI_KEYS is not enabled in their kernel config, we can
> install Linux using them, but they still lack many drivers required,
> since they are yet to be upstreamed. So the installation doesn’t work
> efficiently and we have to manually install custom kernels having
> those patches.
> 
> In some distros like Ubuntu, they have CONFIG_LOAD_UEFI_KEYS enabled
> in their kernel config. In this case the crash as mentioned in the
> patch description occurs and EFI Runtime Services get disabled. Since
> installing GRUB requires access to NVRAM, the installation fails with
> official ISOs in this case. Thus, a custom ISO, with this patch
> incorporated in being used for now for users interested in Ubuntu on
> T2 Macs.
> 
> > Are you dual booting Linux and Mac, or just Linux?
> 
> I don’t think it actually matters, though in most of the cases, we
> dual boot macOS and Linux, but I do have seen cases who wipe out
> their macOS completely. But this doesn't affect the Secure Boot
> policy of these machines.
> 
> >  While in
> > secure boot mode, without being able to read the keys to verify the
> > kernel image signature, the signature verification should fail.
> 
> If I enable secure boot in the BIOS settings (macOS Recovery),
> Apple’s firmware won't allow even the boot loader like GRUB, rEFInd
> to boot. It shall only allow Windows and macOS to Boot. You could see
> https://support.apple.com/en-in/HT208198 for more details.
> 
> > 
> > Has anyone else tested this patch?
> 
> I work as a maintainer for Ubuntu for T2 Linux community and I have
> this patch incorporated in the kernels used for Ubuntu ISOs
> customised for T2 Macs, and thus have many users who have used the
> ISO and have a successful installation. Thus, there are many users
> who have tested this patch and are actually using it right now.
> We also need the have the NVRAM writes enabled so as to unlock the
> iGPU in Macs with both Intel and AMD GPU, and with this patch, we
> have been successfully able to unlock it,
> 
> I hope I could answer your questions

Yes, thank you.   Based on the link above and 
https://wiki.t2linux.org/guides/kernel/, I was able boot a kernel
with/without this patch.

The patch is now queued in the next-integrity-testing branch.

thanks,

Mimi

