Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3644BC118
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiBRUTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:19:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiBRUTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:19:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBA512AA8;
        Fri, 18 Feb 2022 12:19:36 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IJBnfM011227;
        Fri, 18 Feb 2022 20:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : date : message-id : mime-version :
 content-type; s=pp1; bh=dWoLYEztVqtFEjEmwzCNIPrr8BRdAZWSR6a77aO+F7k=;
 b=a/OouFi+tVjEUIogG4CGyT5q6Ura9qK1wDhCqqiHQDu5Y3W+/VJ5pgIM3949EJ41OF+k
 IkZO6Nv8z8nMlHf+gSdRmE9jfv7tdAYzdkQa3eq25zFFZ9bqZw5GSSP8J8UFKtB2FjvQ
 /ocwHAlret6H4tZfe2lRWTgm5yXfF+Qw7G+hUKPHKKt8kTNEMIVwBZP0exGuV7mT2gRH
 o8xjnQJWh4E68sw0nLN69CznFgo4cDKVSvKtOSoN4zCUQ1xZ+k5TnJUjpndZLj/2B3QF
 wAPmSGR1+t0OK3TstqTOv12L7B5RxzITChs+lSrGrOor1BflVLANkcr4Z3f2RTUshZTe Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eahd81he4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 20:19:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IJsGTb018251;
        Fri, 18 Feb 2022 20:19:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eahd81hdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 20:19:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IKE5SA015730;
        Fri, 18 Feb 2022 20:19:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64hav7hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 20:19:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IKJ49I46072150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 20:19:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0DC5204F;
        Fri, 18 Feb 2022 20:19:04 +0000 (GMT)
Received: from localhost (unknown [9.171.19.251])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AD7BE5204E;
        Fri, 18 Feb 2022 20:19:04 +0000 (GMT)
From:   Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
To:     memxor@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, fw@strlen.de,
        john.fastabend@gmail.com, kafai@fb.com, maximmi@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, songliubraving@fb.com, toke@redhat.com,
        yhs@fb.com
Subject: Re: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
In-Reply-To: 
Date:   Fri, 18 Feb 2022 21:19:04 +0100
Message-ID: <87y228q66f.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q2_JNrD740B6SxTKVCCClWOnps0ppJT3
X-Proofpoint-GUID: k7ymj4nEborQ3HFmzCFJ5UAQe6Me-811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 impostorscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

we are having a problem loading nf_conntrack on linux-next:

# modprobe nf_conntrack
modprobe: ERROR: could not insert 'nf_conntrack': Unknown symbol in module, or unknown parameter (see dmesg)
modprobe: ERROR: Error running install command '/sbin/modprobe --ignore-install nf_conntrack  && /sbin/sysctl --quiet --pattern 'net[.]netfilter[.]nf_conntrack.*' --system' for module nf_conntrack: retcode 1
modprobe: ERROR: could not insert 'nf_conntrack': Invalid argument

# dmesg
[ 3728.188969] missing module BTF, cannot register kfuncs
[ 3748.208674] missing module BTF, cannot register kfuncs
[ 3748.567123] missing module BTF, cannot register kfuncs
[ 3873.597276] missing module BTF, cannot register kfuncs
[ 3874.017125] missing module BTF, cannot register kfuncs
[ 3882.637097] missing module BTF, cannot register kfuncs
[ 3883.507213] missing module BTF, cannot register kfuncs
[ 3883.876878] missing module BTF, cannot register kfuncs

# zgrep BTF /proc/config.gz
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y

It seems that nf_conntrack.ko is missing a .BTF section
which is present in debuginfo within
/usr/lib/debug/lib/modules/*/kernel/net/netfilter/nf_conntrack.ko.debug instead.

Am i correct in assuming that this is not supported (yet) ?

We use pahole 1.22 and build linux-next on Fedora 35 as a set of custom
packages. Architecture is s390x.

Thanks
Regards
Alex
 
