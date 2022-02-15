Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB024B6A84
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiBOLRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:17:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiBOLRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:17:31 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F4107D07;
        Tue, 15 Feb 2022 03:17:22 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FAT8TJ002362;
        Tue, 15 Feb 2022 11:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7/+NZcf/3caTHbY6f91RIKORInAbuuiacwvRzcQa77o=;
 b=ryn961nZHZ/3ntt4lHSqczxQc9UIibHxqjWBW/pTXlsHCZM9/Kbck6MZ5t2tumfea9Xv
 NfHpy+NI9Ok42Gqar8cRPEwr0hGbHVtA5sfjBiD5YUqopeoAKLZGURj+6pREj3ulHRxq
 GLPGytK+QWB/Cs7C+5olxpRu2BLJaObC08XUfFBCXPuqYKKrR6d+pfZhZhoolsyc6bQb
 cnqIC1oYW6+4I9fBB0CgojD/zICPg4IPPqcgrurR23f7DzIgJoca8/D4YyTerzL6NNPc
 Lw7yKgtdtSP2ZbdDl1YUpw2dqQ9bErCDcZv5AkQCwCh2QZspGFOQfSNCUePlctnF8DgF 4Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8afcs53w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:16:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBDZjX030692;
        Tue, 15 Feb 2022 11:16:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3e645jn7h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:16:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FB6X0q47317352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:06:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74AC2A4051;
        Tue, 15 Feb 2022 11:16:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAAA3A405D;
        Tue, 15 Feb 2022 11:16:52 +0000 (GMT)
Received: from sig-9-65-71-246.ibm.com (unknown [9.65.71.246])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:16:52 +0000 (GMT)
Message-ID: <a769e5b91b573691ba1c76545b2b62d1b7b48e4c.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Feb 2022 06:16:52 -0500
In-Reply-To: <311b5d0b3b824c548a4032a76a408944@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
         <537635732d9cbcc42bcf7be5ed932d284b03d39f.camel@linux.ibm.com>
         <cc6bcb7742dc432ba990ee38b5909496@huawei.com>
         <36f85113f181f78eda3576823bd92be3f9cd1802.camel@linux.ibm.com>
         <311b5d0b3b824c548a4032a76a408944@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rwMMYNIQidnzCGaL7FZviIusmsaDwFSF
X-Proofpoint-ORIG-GUID: rwMMYNIQidnzCGaL7FZviIusmsaDwFSF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-15 at 08:00 +0000, Roberto Sassu wrote:
> > >
> > > I found that just checking that iint->ima_hash is not NULL is not enough
> > > (ima_inode_hash() might still return the old digest after a file write).
> > > Should I replace that check with !(iint->flags & IMA_COLLECTED)?
> > > Or should I do only for ima_file_hash() and recalculate the digest
> > > if necessary?
> > 
> > Updating the file hash after each write would really impact IMA
> > performance.  If you really want to detect any file change, no matter
> > how frequently it occurs, your best bet would be to track i_generation
> > and i_version.  Stefan is already adding "i_generation" for IMA
> > namespacing.
> 
> I just wanted the ability to get a fresh digest after a file opened
> for writing is closed. Since in my use case I would not use an IMA
> policy, that would not be a problem.

As I recall, the __fput() delay was to prevent locking ordering issues
- inode, iint.

-- 
thanks,

Mimi

