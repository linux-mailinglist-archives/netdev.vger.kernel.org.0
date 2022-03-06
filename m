Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03D44CED73
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiCFTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiCFTdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:33:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA6D63BF9;
        Sun,  6 Mar 2022 11:32:23 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 226EU9We012481;
        Sun, 6 Mar 2022 19:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=P7Sx8LIVCicwGCYwd3xV2H3Pz4bqw+ZRm8PRE3xM/Mg=;
 b=ftsKdDrPlaGfYECHuxP1qWntRXyRuGDp3TXU4/cvU0t6wiT8y3yDBE3W82aQ2iZewa9S
 GFnaBTteAjCjCXPwWP+ySqDwgQogSVxc9IyylPNGWCP+xTEJ7VeLAUgg4CbciRLdVMx2
 sq9Ajl/kZKbxFfn+zfVPEj69KULvWMDzV6zz3ffHlzvZqPP8ZPr/8+3mGo69kntG6MGJ
 C4igPyHZo5vpaVYwGp8EtqxTMRVgdAnMhLnzbhc+m+qFx2ijCISS4fDHKD9ij6dtf/Ma
 1MJmmZnXovpZI9ZtK43j1wmy+cJo+czMMyyD6O6i2e1sQIkYaH806C2pv2BxAlT21c2P sA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3emrtjy525-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:31:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 226JUISO028583;
        Sun, 6 Mar 2022 19:31:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3emk62h9yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:31:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 226JVopx50266594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Mar 2022 19:31:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 552B4AE051;
        Sun,  6 Mar 2022 19:31:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66C9AAE045;
        Sun,  6 Mar 2022 19:31:48 +0000 (GMT)
Received: from sig-9-65-93-47.ibm.com (unknown [9.65.93.47])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  6 Mar 2022 19:31:48 +0000 (GMT)
Message-ID: <1616eae810986a6570f472b3fa7eb099b3134b4a.camel@linux.ibm.com>
Subject: Re: [PATCH v3 2/9] ima: Always return a file measurement in
 ima_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, revest@chromium.org,
        gregkh@linuxfoundation.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 06 Mar 2022 14:31:47 -0500
In-Reply-To: <20220302111404.193900-3-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302111404.193900-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sVyzJGT0ikza_FYNnIDRzwD_2klAk8SE
X-Proofpoint-ORIG-GUID: sVyzJGT0ikza_FYNnIDRzwD_2klAk8SE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203060134
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-02 at 12:13 +0100, Roberto Sassu wrote:
> __ima_inode_hash() checks if a digest has been already calculated by
> looking for the integrity_iint_cache structure associated to the passed
> inode.
> 
> Users of ima_file_hash() (e.g. eBPF) might be interested in obtaining the
> information without having to setup an IMA policy so that the digest is
> always available at the time they call this function.
> 
> In addition, they likely expect the digest to be fresh, e.g. recalculated
> by IMA after a file write. Although getting the digest from the
> bprm_committed_creds hook (as in the eBPF test) ensures that the digest is
> fresh, as the IMA hook is executed before that hook, this is not always the
> case (e.g. for the mmap_file hook).
> 
> Call ima_collect_measurement() in __ima_inode_hash(), if the file
> descriptor is available (passed by ima_file_hash()) and the digest is not
> available/not fresh, and store the file measurement in a temporary
> integrity_iint_cache structure.
> 
> This change does not cause memory usage increase, due to using the
> temporary integrity_iint_cache structure, and due to freeing the
> ima_digest_data structure inside integrity_iint_cache before exiting from
> __ima_inode_hash().
> 
> For compatibility reasons, the behavior of ima_inode_hash() remains
> unchanged.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

The patch itself is fine, but with great hesitancy due to the existing
eBPF integrity gaps and how these functions are planned to be used,

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

