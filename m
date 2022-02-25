Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E309B4C4E60
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiBYTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiBYTMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:12:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA0220B16E;
        Fri, 25 Feb 2022 11:11:35 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PIAvE7022087;
        Fri, 25 Feb 2022 19:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CpqI9s94/ZaBQwuEXHNCmNODLi1kbCVr7kYFsCziWCs=;
 b=jvURaCa0RFihWulzf3+hXVcQl/gRARpmLKmYnmnfGbqUwJ4Vg6GNCtmfKRDcNMbuMVmG
 LGwymcHYjxQqUxSFa1D193Pk2hfiHj3PbL4qHsqEH7Xzeb0Y0+FBYYc4R0q76O4KVIAX
 MidpcpZSB/bjBLBFJCOhtRRpTdedOAmRL5lUebDQmFVh5Z1UyvlzS1jERcu0jJsNU+6W
 AcMq+EKSmCFwKQRrOc8uZ1n8a4UOWuid2AmVy2hckzFSTUNSlvhdBRKaHOmJiP+In2sn
 E6eyNvwRi3r39tvJZOdZmnYKcEuuuQuwDiJWHWVRbk4FEldVjCYeXbiLLaL+Jrxpcfut wg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eeyc09nv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 19:11:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PJ8rjl017157;
        Fri, 25 Feb 2022 19:11:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear69r2q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 19:11:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PJB6bI37224894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 19:11:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF8E44C050;
        Fri, 25 Feb 2022 19:11:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2270D4C04E;
        Fri, 25 Feb 2022 19:11:05 +0000 (GMT)
Received: from sig-9-65-82-248.ibm.com (unknown [9.65.82.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 19:11:05 +0000 (GMT)
Message-ID: <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 25 Feb 2022 14:11:04 -0500
In-Reply-To: <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
         <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
         <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m8Gn1OTAgrRrKytse14FiMc1nHsNS195
X-Proofpoint-GUID: m8Gn1OTAgrRrKytse14FiMc1nHsNS195
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-25 at 08:41 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Friday, February 25, 2022 1:22 AM
> > Hi Roberto,
> > 
> > On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > > Extend the interoperability with IMA, to give wider flexibility for the
> > > implementation of integrity-focused LSMs based on eBPF.
> > 
> > I've previously requested adding eBPF module measurements and signature
> > verification support in IMA.  There seemed to be some interest, but
> > nothing has been posted.
> 
> Hi Mimi
> 
> for my use case, DIGLIM eBPF, IMA integrity verification is
> needed until the binary carrying the eBPF program is executed
> as the init process. I've been thinking to use an appended
> signature to overcome the limitation of lack of xattrs in the
> initial ram disk.

I would still like to see xattrs supported in the initial ram disk. 
Assuming you're still interested in pursuing it, someone would need to
review and upstream it.  Greg?

> 
> At that point, the LSM is attached and it can enforce an
> execution policy, allowing or denying execution and mmap
> of files depending on the digest lists (reference values) read
> by the user space side.
> 
> After the LSM is attached, IMA's job would be just to calculate
> the file digests (currently, I'm using an audit policy to ensure
> that the digest is available when the eBPF program calls
> bpf_ima_inode_hash()).
> 
> The main benefit of this patch set is that the audit policy
> would not be required and digests are calculated only when
> requested by the eBPF program.

Roberto, there's an existing eBPF integrity gap that needs to be
closed, perhaps not for your usecase, but in general.  Is that
something you can look into?

thanks,

Mimi

