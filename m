Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C04B3B83
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiBMNGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 08:06:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBMNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 08:06:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61735B88E;
        Sun, 13 Feb 2022 05:06:37 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21DAPOGv007992;
        Sun, 13 Feb 2022 13:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cQPiw2dyD8PgwyjWmIk8sBpF1FR7uPpYLP5WigSzu+0=;
 b=oi/0aktaJZz9GBmenntUm1blxvOZlDwfwkiFmHKZdAGwBSRZiU4J0+iC51ml9JhBJa64
 GTS7HfFh6QjxmhBcyaYKDTLoGg0aJTk/AXN4GsfCwp6mtB7o5n3Svd1MifVsLbegVFng
 f3RIrQ02HBrLlXjvIkKNoSFgnn5xSOeIs4W/jFiZzAiFNV0c47cZDXGHw21j7BvPjKCd
 R7sgx5WSEZxY+xXZtk71XX2s5YK4+B3374zwhBmBb2DD6eLlJ3ZlopabtVncTEwzTlg+
 qoQaEk1fkOgT2vhSuypr4LsqvFkx6AA84dKyZEHoNkSZAIi2+T7R2d3urbI1zMfz4O7e wA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e6ueedjc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Feb 2022 13:06:08 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21DD3Ht9003084;
        Sun, 13 Feb 2022 13:06:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3e645j63u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Feb 2022 13:06:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21DD63VF39715094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Feb 2022 13:06:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32020AE053;
        Sun, 13 Feb 2022 13:06:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACE5CAE051;
        Sun, 13 Feb 2022 13:06:01 +0000 (GMT)
Received: from sig-9-65-82-84.ibm.com (unknown [9.65.82.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 13 Feb 2022 13:06:01 +0000 (GMT)
Message-ID: <537635732d9cbcc42bcf7be5ed932d284b03d39f.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, Florent Revest <revest@chromium.org>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 13 Feb 2022 08:06:01 -0500
In-Reply-To: <20220211104828.4061334-1-roberto.sassu@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9yEoyiBIJvR4y7HasDH_lt1HNEe7aV9K
X-Proofpoint-GUID: 9yEoyiBIJvR4y7HasDH_lt1HNEe7aV9K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-13_04,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202130089
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

On Fri, 2022-02-11 at 11:48 +0100, Roberto Sassu wrote:
> __ima_inode_hash() checks if a digest has been already calculated by
> looking for the integrity_iint_cache structure associated to the passed
> inode.
> 
> Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
> interested in obtaining the information without having to setup an IMA
> policy so that the digest is always available at the time they call one of
> those functions.
> 
> Open a new file descriptor in __ima_inode_hash(), so that this function
> could invoke ima_collect_measurement() to calculate the digest if it is not
> available. Still return -EOPNOTSUPP if the calculation failed.
> 
> Instead of opening a new file descriptor, the one from ima_file_hash()
> could have been used. However, since ima_inode_hash() was created to obtain
> the digest when the file descriptor is not available, it could benefit from
> this change too. Also, the opened file descriptor might be not suitable for
> use (file descriptor opened not for reading).
> 
> This change does not cause memory usage increase, due to using a temporary
> integrity_iint_cache structure for the digest calculation, and due to
> freeing the ima_digest_data structure inside integrity_iint_cache before
> exiting from __ima_inode_hash().
> 
> Finally, update the test by removing ima_setup.sh (it is not necessary
> anymore to set an IMA policy) and by directly executing /bin/true.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Although this patch doesn't directly modify either ima_file_hash() or
ima_inode_hash(),  this change affects both functions.  ima_file_hash()
was introduced to be used with eBPF.  Based on Florent's post, changing
the ima_file_hash() behavor seems fine.  Since I have no idea whether
anyone is still using ima_inode_hash(), perhaps it would be safer to
limit this behavior change to just ima_file_hash().

Please update the ima_file_hash() doc.  While touching this area, I'd
appreciate your fixing the first doc line in both ima_file_hash() and
ima_inode_hash() cases, which wraps spanning two lines.

Please split the IMA from the eBPF changes.

-- 
thanks,

Mimi

