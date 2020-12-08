Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4A2D35C3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgLHWDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:03:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40794 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgLHWDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:03:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8LxKPM053029;
        Tue, 8 Dec 2020 22:02:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=hvdxjPy5MyGvTiVa5pu3QObb9iVq99nGN0L0ilpatgw=;
 b=LUeJFtCUZStMcWNePHA6VCGB/nj8xHreDOVC1TD3zKTu/CRo4ztmRdAT5YbJrJ2UsLox
 GzrNQR+c1C0mspR00Gl1SsxN/wDdAHGeaGnikKBJzejgvM4GEB24fpcBLmbVxRKRT013
 3A53BACWbUxXwv1qM9QrA04w6pMRsPOkdjlcMy5hCndoKXd/7G5EBrwZvzoDeTHjEsaX
 iRroACQIElTr6O1lQGRSbdkwyPDQjXGG04lbNk4YTRWTPcbMcLAcbqD31FQeW1k2Y8cU
 Gzs7XgkeG3EzF7RaDrrQ0SuCJ6qXFpmy1GULAukh5cpqWNz40ogwN3h9Zhipe/4CjlQv 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825m57vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 22:02:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8M1joC057611;
        Tue, 8 Dec 2020 22:02:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 358m4ygrgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 22:02:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B8M2ArX030698;
        Tue, 8 Dec 2020 22:02:10 GMT
Received: from dhcp-10-175-161-251.vpn.oracle.com (/10.175.161.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 14:02:09 -0800
Date:   Tue, 8 Dec 2020 22:02:01 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <CAEf4BzbB87SDiD+=4u2u5iLhQiXUCc0Bf-7SX6BXZ4tkhjFU=g@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2012082156300.25628@localhost>
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012060025520.1505@localhost> <CAEf4BzbB87SDiD+=4u2u5iLhQiXUCc0Bf-7SX6BXZ4tkhjFU=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=10
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020, Andrii Nakryiko wrote:

> On Sat, Dec 5, 2020 at 4:38 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> > Thanks so much for doing this Andrii! When I tested, I ran into a problem;
> > it turns out when a module struct such as "veth_stats" is used, it's
> > classified as BTF_KIND_FWD, and as a result when we iterate over
> > the modules and look in the veth module, "struct veth_stats" does not
> > match since its module kind (BTF_KIND_STRUCT) does not match the candidate
> > kind (BTF_KIND_FWD). I'm kind of out of my depth here, but the below
> > patch (on top of your patch) worked.
> 
> I'm not quite clear on the situation. BTF_KIND_FWD is for the local
> type or the remote type? Maybe a small example would help, before we
> go straight to assuming FWD can be always resolved into a concrete
> STRUCT/UNION.
>

The local type was BTF_KIND_FWD, and the target type was BTF_KIND_STRUCT
IIRC; I'll try and get some libbpf debug output for you showing the
relocation info.  If it helps, I think the situation was this; I was
referencing __builtin_btf_type_id(struct veth_stats), and hadn't
included a BTF-generated veth header, so I'm guessing libbpf classified
it as a fwd declaration.  My patch was a bit too general I suspect in
that it assumed that either target or local could be BTF_KIND_FWD and
should match BTF_KIND_STRUCT in local/target, wheres I _think_ the
local only should permit BTF_KIND_FWD.  Does that make sense? 
> 
> >  However without it - when we find
> > 0  candidate matches - as well as not substituting the module object
> > id/type id - we hit a segfault:
> 
> Yep, I missed the null check in:
> 
> targ_spec->btf != prog->obj->btf_vmlinux
> 
> I'll fix that.
> 

Thanks! I think the core_reloc selftests trigger the segfault 
also if you need a test case to verify.

Alan
