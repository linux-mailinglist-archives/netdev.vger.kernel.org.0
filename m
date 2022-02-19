Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BBE4BC6CC
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 08:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbiBSHkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 02:40:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiBSHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 02:40:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AF6B1899;
        Fri, 18 Feb 2022 23:40:04 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21J7dDOk016434;
        Sat, 19 Feb 2022 07:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : date : message-id : mime-version :
 content-type; s=pp1; bh=/iW8zt+jRKha7tioxY95nVa/H7Wel079K43uzcEIddc=;
 b=WznHVIOmcpDfrEs3aPrX7IkAfF++FpAYodDYF+rGk9+N0SUcgb6ZQKg7OHl5pEIfCa2L
 PC9AuIZQGmwrs5S1ZTw5rAc/I1Ie5NcpHN3JUNAQOHRVe+A2xrbQ4cToxWdA+AZmmKBn
 GAd9q7CKasdAsXMGNAkvyzIhqLhBgNidsKZmvtZZba+IpuclL3q4QAXYWVOPzWPYam3s
 bsAWe5aU1NSmiV0tGj9vrMx7cjGxOzIN2wdc25SWpEKwj5qhYf/+R9+vL1yC+74uAb1F
 RNw5nN16TvehKJGX1u7lSqgFOpx5bcAjPfrSgEr7+faWDXx2IagML2tjpPRRzUFNjbGT vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaukbrkjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Feb 2022 07:39:23 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21J7dM6q017139;
        Sat, 19 Feb 2022 07:39:22 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaukbrkj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Feb 2022 07:39:22 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21J7WlIv016917;
        Sat, 19 Feb 2022 07:39:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ear68grx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Feb 2022 07:39:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21J7SkQv51642878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 07:28:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC6BD11C04A;
        Sat, 19 Feb 2022 07:39:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC79511C050;
        Sat, 19 Feb 2022 07:39:15 +0000 (GMT)
Received: from localhost (unknown [9.171.78.175])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 19 Feb 2022 07:39:15 +0000 (GMT)
From:   Alexander Egorenkov <egorenar@linux.ibm.com>
To:     memxor@gmail.com
Cc:     Alexander.Egorenkov@ibm.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        fw@strlen.de, iii@linux.ibm.com, john.fastabend@gmail.com,
        kafai@fb.com, maximmi@nvidia.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        songliubraving@fb.com, toke@redhat.com, yhs@fb.com
Cc:     egorenar@linux.ibm.com
Subject: Re: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
In-Reply-To: <20220218222017.czshdolesamkqv4j@apollo.legion>
In-Reply-To: 
Date:   Sat, 19 Feb 2022 08:39:15 +0100
Message-ID: <878ru7qp98.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f15b_PDgD1Us7QSFXGOnsiB-FGmXhVN-
X-Proofpoint-ORIG-GUID: ZsowmijEZwOUfzqbttRtisVoWieRAFjX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-19_02,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=960
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Kartikeya,

sorry if i wasn't clear in my first message but just to be sure
we have no misunderstandings :)

.BTF sections work on s390x with linux-next and nf_conntrack as well if
the corresponding .BTF section is a part of the kernel module itself.
I tested it myself by building a linux-next kernel and testing it with a
KVM guest, i'm able to load nf_conntrack and it works.

In contrast, in the case where the corresponding .BTF section is separate
from the kernel module nf_conntrack, it fails with the message i
provided in the first email.

Therefore, my question is, does BTF for kernel modules work if the
corresponding BTF section is NOT a part of the kernel module but instead
is stored within the corresponding debuginfo file
/usr/lib/debug/lib/modules/*/kernel/net/netfilter/nf_conntrack.ko.debug ?

Thanks
Regards
Alex


 
