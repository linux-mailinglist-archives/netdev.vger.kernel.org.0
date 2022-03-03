Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D134CC2C7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiCCQbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiCCQbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:31:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9DF10EC66;
        Thu,  3 Mar 2022 08:30:28 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223GF9lk015672;
        Thu, 3 Mar 2022 16:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JvemLlmF4yOQ1FVXXpV2KwKYt5Im31tdEZJtt2mUi8o=;
 b=g8Rx9uFM7islYz13m+XKPrDy+PCXljUnN5tSpU/NWuAIm1O466L4FTFQi8/ZFDOgiMQ6
 ZGSkaukt/1d7SyXaON79DuVyjWmGWwlj9kBRFgMzY4Lq/zHpryq20vc5ah9rQyKnePHl
 kjPijbhv3IexLJt8bquI2vNyLIL34q9Eu2/dLn2xicrsgbwuWzpTBvUYBfAHLm2mXql1
 IJs0Zl35E/DXO8v+p24mQxIjN5PU1ImjDdwPNDnw21BAcCkrvS2Uz8LmRdzh410QEmv1
 GZpVf4LRk040aTBu4wqXueL7/RQUqQ7riYHvSyZgrlbf0DU542t+S8ogFTMUibMchxUW ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejsp22hw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:30:08 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223GIP0f006913;
        Thu, 3 Mar 2022 16:30:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejsp22htb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:30:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223GIuju019234;
        Thu, 3 Mar 2022 16:30:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3efbu9gp1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:30:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223GU1bG53674388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 16:30:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 057B7A4060;
        Thu,  3 Mar 2022 16:30:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82F1BA405C;
        Thu,  3 Mar 2022 16:29:58 +0000 (GMT)
Received: from sig-9-65-93-208.ibm.com (unknown [9.65.93.208])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 16:29:58 +0000 (GMT)
Message-ID: <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, revest@chromium.org, gregkh@linuxfoundation.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 03 Mar 2022 11:29:57 -0500
In-Reply-To: <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
         <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
         <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -sbs3MRY0XbRzfcOjEjbnQdDi2CiUNJJ
X-Proofpoint-GUID: Lp_-sfFtFHyutjhVXm3ioNWwSbY3J-4q
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
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

On Thu, 2022-03-03 at 17:17 +0100, KP Singh wrote:
> On Thu, Mar 3, 2022 at 5:05 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > [Cc'ing Florent, Kees]
> >
> > Hi Alexei,
> >
> > On Wed, 2022-03-02 at 14:20 -0800, Alexei Starovoitov wrote:
> > > On Wed, Mar 02, 2022 at 12:13:55PM +0100, Roberto Sassu wrote:
> > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > implementation of integrity-focused LSMs based on eBPF.
> > > >
> > > > Patch 1 fixes some style issues.
> > > >
> > > > Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> > > > measurement capability of IMA without needing to setup a policy in IMA
> > > > (those LSMs might implement the policy capability themselves).
> > > >
> > > > Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> > > >
> > > > Changelog
> > > >
> > > > v2:
> > > > - Add better description to patch 1 (suggested by Shuah)
> > > > - Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
> > > > - Move declaration of bpf_ima_file_hash() at the end (suggested by
> > > >   Yonghong)
> > > > - Add tests to check if the digest has been recalculated
> > > > - Add deny test for bpf_kernel_read_file()
> > > > - Add description to tests
> > > >
> > > > v1:
> > > > - Modify ima_file_hash() only and allow the usage of the function with the
> > > >   modified behavior by eBPF-based LSMs through the new function
> > > >   bpf_ima_file_hash() (suggested by Mimi)
> > > > - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
> > > >   and bpf_ima_file_hash() can be called inside the implementation of
> > > >   eBPF-based LSMs for this hook
> > > >
> > > > Roberto Sassu (9):
> > > >   ima: Fix documentation-related warnings in ima_main.c
> > > >   ima: Always return a file measurement in ima_file_hash()
> > > >   bpf-lsm: Introduce new helper bpf_ima_file_hash()
> > > >   selftests/bpf: Move sample generation code to ima_test_common()
> > > >   selftests/bpf: Add test for bpf_ima_file_hash()
> > > >   selftests/bpf: Check if the digest is refreshed after a file write
> > > >   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
> > > >   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
> > > >   selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
> > > >     policy
> > >
> > > We have to land this set through bpf-next.
> > > Please get the Acks for patches 1 and 2, so we can proceed.
> >
> 
> Hi Mimi,
> 
> > Each year in the LSS integrity status update talk, I've mentioned the
> > eBPF integrity gaps.  I finally reached out to KP, Florent Revest, Kees
> 
> Thanks for bringing this up and it's very timely because we have been
> having discussion around eBPF program signing and delineating that
> from eBPF program integrity use-cases.
> 
> My plan is to travel to LSS (travel and visa permitting) and we can discuss
> it more there.
> 
> If you prefer we can also discuss it before in one of the BPF office hours:
> 
> https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=0

Sounds good.

> 
> > and others, letting them know that I'm concerned about the eBPF module
> > integrity gaps.  True there is a difference between signing the eBPF
> > source modules versus the eBPF generated output, but IMA could at least
> > verify the integrity of the source eBPF modules making sure they are
> > measured, the module hash audited, and are properly signed.
> >
> > Before expanding the ima_file_hash() or ima_inode_hash() usage, I'd
> > appreciate someone adding the IMA support to measure, appraise, and
> > audit eBPF modules.  I realize that closing the eBPF integrity gaps is
> > orthogonal to this patch set, but this patch set is not only extending
> 
> This really is orthogonal and IMHO it does not seem rational to block this
> patchset on it.
> 
> > the ima_file_hash()/ima_inode_hash() usage, but will be used to
> > circumvent IMA.  As per usual, IMA is policy based, allowing those
> 
> I don't think they are being used to circumvent IMA but for totally
> different use-cases (e.g. as a data point for detecting attacks).
> 
> 
> > interested in eBPF module integrity to define IMA policy rules.

That might be true for your usecase, but not Roberto's.  From the cover
letter above, Roberto was honest in saying:

Patches 2-6 give the ability to eBPF-based LSMs to take advantage of
the measurement capability of IMA without needing to setup a policy in
IMA (those LSMs might implement the policy capability themselves).

-- 
thanks,

Mimi

