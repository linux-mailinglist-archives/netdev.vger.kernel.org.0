Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513A74B5DB3
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 23:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiBNWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 17:33:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiBNWdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 17:33:47 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F8813C27B;
        Mon, 14 Feb 2022 14:33:38 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ELrUnq012537;
        Mon, 14 Feb 2022 22:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KH7PhZv86pJmZAECyDrEHhT1RhG70HibOpQSq1zBsgg=;
 b=MXjoqzQWJtifsAJ1SkA2CuYAvDG303yilvF0I/x+AY8eH3TA/TjxhAR+lb9BTfKCXiOC
 dYJQDyrdlj/Qv2TKuC++Y0rUEWnRViW+Yvz91cIpBwMnSe93j7Vmm9pKgpoWMp6N2cA6
 DTXOHeUj9DKFqW4Waig4rL+Vd1UHTJGuUTgeY5W+f29ZVsIa/2wHy3mFypxga6jGGGES
 TNuOhDBpSx1uGdWGuo+94aur8LTwOLelkJ3ADryqPQeZWvb1NrIdOq8uKXY9LlHFNADJ
 tKEOcQaMBjVqRjoJZsP8lofKwkE1tWwlbKOD8s0Md8DuJIw7AsngsWg3xq6KELkfBx1f oA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4eb3p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 22:32:56 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EMHLa6021763;
        Mon, 14 Feb 2022 22:32:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3e64h9rhu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 22:32:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EMWpgC48103780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 22:32:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A61C611C054;
        Mon, 14 Feb 2022 22:32:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 220F211C052;
        Mon, 14 Feb 2022 22:32:50 +0000 (GMT)
Received: from sig-9-65-70-53.ibm.com (unknown [9.65.70.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 22:32:50 +0000 (GMT)
Message-ID: <36f85113f181f78eda3576823bd92be3f9cd1802.camel@linux.ibm.com>
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
Date:   Mon, 14 Feb 2022 17:32:49 -0500
In-Reply-To: <cc6bcb7742dc432ba990ee38b5909496@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
         <537635732d9cbcc42bcf7be5ed932d284b03d39f.camel@linux.ibm.com>
         <cc6bcb7742dc432ba990ee38b5909496@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GkRQ1rIxliyunm-29IisWEIsNOJXmUvf
X-Proofpoint-ORIG-GUID: GkRQ1rIxliyunm-29IisWEIsNOJXmUvf
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-14 at 17:05 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Sunday, February 13, 2022 2:06 PM
> > Hi Roberto,
> > 
> > On Fri, 2022-02-11 at 11:48 +0100, Roberto Sassu wrote:
> > > __ima_inode_hash() checks if a digest has been already calculated by
> > > looking for the integrity_iint_cache structure associated to the passed
> > > inode.
> > >
> > > Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
> > > interested in obtaining the information without having to setup an IMA
> > > policy so that the digest is always available at the time they call one of
> > > those functions.
> > >
> > > Open a new file descriptor in __ima_inode_hash(), so that this function
> > > could invoke ima_collect_measurement() to calculate the digest if it is not
> > > available. Still return -EOPNOTSUPP if the calculation failed.
> > >
> > > Instead of opening a new file descriptor, the one from ima_file_hash()
> > > could have been used. However, since ima_inode_hash() was created to
> > obtain
> > > the digest when the file descriptor is not available, it could benefit from
> > > this change too. Also, the opened file descriptor might be not suitable for
> > > use (file descriptor opened not for reading).
> > >
> > > This change does not cause memory usage increase, due to using a temporary
> > > integrity_iint_cache structure for the digest calculation, and due to
> > > freeing the ima_digest_data structure inside integrity_iint_cache before
> > > exiting from __ima_inode_hash().
> > >
> > > Finally, update the test by removing ima_setup.sh (it is not necessary
> > > anymore to set an IMA policy) and by directly executing /bin/true.
> > >
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Although this patch doesn't directly modify either ima_file_hash() or
> > ima_inode_hash(),  this change affects both functions.  ima_file_hash()
> > was introduced to be used with eBPF.  Based on Florent's post, changing
> > the ima_file_hash() behavor seems fine.  Since I have no idea whether
> > anyone is still using ima_inode_hash(), perhaps it would be safer to
> > limit this behavior change to just ima_file_hash().
> 
> Hi Mimi
> 
> ok.
> 
> I found that just checking that iint->ima_hash is not NULL is not enough
> (ima_inode_hash() might still return the old digest after a file write).
> Should I replace that check with !(iint->flags & IMA_COLLECTED)?
> Or should I do only for ima_file_hash() and recalculate the digest
> if necessary?

Updating the file hash after each write would really impact IMA
performance.  If you really want to detect any file change, no matter
how frequently it occurs, your best bet would be to track i_generation
and i_version.  Stefan is already adding "i_generation" for IMA
namespacing.

> 
> > Please update the ima_file_hash() doc.  While touching this area, I'd
> > appreciate your fixing the first doc line in both ima_file_hash() and
> > ima_inode_hash() cases, which wraps spanning two lines.
> 
> Did you mean to make the description shorter or to have everything
> in one line? According to the kernel documentation (kernel-doc.rst),
> having the brief description in multiple lines should be fine.

Thanks for checking kernel-doc.   The "brief description"  not wrapping
across multiple lines did in fact change.

> > Please split the IMA from the eBPF changes.
> 
> Ok.

-- 
thanks,

Mimi

