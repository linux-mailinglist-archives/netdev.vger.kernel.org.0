Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60144CC234
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiCCQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiCCQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:06:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF46B197B78;
        Thu,  3 Mar 2022 08:05:47 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223ETY12023455;
        Thu, 3 Mar 2022 16:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=JyGLvJtca4oI/c0VcaMaTHyxDXa4LvL3NsttX8xHR1M=;
 b=f9VS9+7g/t7GgV5y7NYDqFBEmnO7g3bhgzVB0BUj/ArARZZX79oFqCZ5vqo7x3yMDXog
 IsL0KI/WMn2gsrpvmohM9+y3+TzfLUtYgiwW/s89dVBvLhglNr36DolWvFTALYxYrU7w
 MkJOoVLOuJ1YTJ3LEj3GKB/zqO8t/J35AELqlV37HVp+4Vhwy+fqxG8pOZ1x3+0RVhV2
 0WGhpSHRFORhouSv1QqdSV+YbMqtCo+d7WmeHt2jIlderroBA3klLEctCWnFrwBjs8vW
 6iwe0liRvOVoF9v7+MgnSd1KZW6RDAMc7nKPkURLMM/d//ABaC5pGGawnH8M4FHrAgJt aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejvpqp1d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:05:26 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223FSQoG004079;
        Thu, 3 Mar 2022 16:05:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejvpqp1c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:05:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223FwuY2022532;
        Thu, 3 Mar 2022 16:05:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3efbu9gkdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:05:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223G5L3Y17170900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 16:05:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDCB54C050;
        Thu,  3 Mar 2022 16:05:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B78B4C04E;
        Thu,  3 Mar 2022 16:05:18 +0000 (GMT)
Received: from sig-9-65-93-208.ibm.com (unknown [9.65.93.208])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 16:05:18 +0000 (GMT)
Message-ID: <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        revest@chromium.org, gregkh@linuxfoundation.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 03 Mar 2022 11:05:17 -0500
In-Reply-To: <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eIohtXZucs1n3aEyoz5AwK6mq862RsUS
X-Proofpoint-GUID: QbhBxfo4xscyYeR3aAmt90U-TdI6weWf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1011 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc'ing Florent, Kees]

Hi Alexei,

On Wed, 2022-03-02 at 14:20 -0800, Alexei Starovoitov wrote:
> On Wed, Mar 02, 2022 at 12:13:55PM +0100, Roberto Sassu wrote:
> > Extend the interoperability with IMA, to give wider flexibility for the
> > implementation of integrity-focused LSMs based on eBPF.
> > 
> > Patch 1 fixes some style issues.
> > 
> > Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> > measurement capability of IMA without needing to setup a policy in IMA
> > (those LSMs might implement the policy capability themselves).
> > 
> > Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> > 
> > Changelog
> > 
> > v2:
> > - Add better description to patch 1 (suggested by Shuah)
> > - Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
> > - Move declaration of bpf_ima_file_hash() at the end (suggested by
> >   Yonghong)
> > - Add tests to check if the digest has been recalculated
> > - Add deny test for bpf_kernel_read_file()
> > - Add description to tests
> > 
> > v1:
> > - Modify ima_file_hash() only and allow the usage of the function with the
> >   modified behavior by eBPF-based LSMs through the new function
> >   bpf_ima_file_hash() (suggested by Mimi)
> > - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
> >   and bpf_ima_file_hash() can be called inside the implementation of
> >   eBPF-based LSMs for this hook
> > 
> > Roberto Sassu (9):
> >   ima: Fix documentation-related warnings in ima_main.c
> >   ima: Always return a file measurement in ima_file_hash()
> >   bpf-lsm: Introduce new helper bpf_ima_file_hash()
> >   selftests/bpf: Move sample generation code to ima_test_common()
> >   selftests/bpf: Add test for bpf_ima_file_hash()
> >   selftests/bpf: Check if the digest is refreshed after a file write
> >   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
> >   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
> >   selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
> >     policy
> 
> We have to land this set through bpf-next.
> Please get the Acks for patches 1 and 2, so we can proceed.

Each year in the LSS integrity status update talk, I've mentioned the
eBPF integrity gaps.  I finally reached out to KP, Florent Revest, Kees
and others, letting them know that I'm concerned about the eBPF module
integrity gaps.  True there is a difference between signing the eBPF
source modules versus the eBPF generated output, but IMA could at least
verify the integrity of the source eBPF modules making sure they are
measured, the module hash audited, and are properly signed.

Before expanding the ima_file_hash() or ima_inode_hash() usage, I'd
appreciate someone adding the IMA support to measure, appraise, and
audit eBPF modules.  I realize that closing the eBPF integrity gaps is
orthogonal to this patch set, but this patch set is not only extending
the ima_file_hash()/ima_inode_hash() usage, but will be used to
circumvent IMA.  As per usual, IMA is policy based, allowing those
interested in eBPF module integrity to define IMA policy rules.

thanks,

Mimi

