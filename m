Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04001D40E9
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgENW0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:26:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgENW0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:26:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EMDqqs189326;
        Thu, 14 May 2020 22:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=FjvFM6ZaMmmWoZUO4ZUKypUYGMnm9Lz4wPP6z6pKBks=;
 b=IXZ70RR1qu6LUOnFslclk2zI3bsk49kpvW4kiKEz+cu8CrR/b67DCG669SCM03aZLz7K
 aMXeFWr3MJilaBr03/ZmB3gGAh1QW4r1Brcf3Ax/83MxYfszB1n+xUV9/H8XQQWoKtbz
 y6U25I8bcA8eZ/yEAw53IvlyR5GNbR+OSQmxp8NMG5VsULfTYtkO85Nsucm2xwZEwizP
 ciqfOVnpNp0z6JDpdiicmQpsXxDeahPCStfAwwgt4zUKI8LxeiXGK2RLY3JP4ketCJhj
 XrLwatGG9WOE8Iv9OCeZRnM95wQbDz1ugZzvMOXADALTyo1KPIY/r87+gFUHNPz9UgGV +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwwf9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 22:25:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EM8hiY067868;
        Thu, 14 May 2020 22:25:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 310vju2m7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 22:25:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EMPmCW004643;
        Thu, 14 May 2020 22:25:48 GMT
Received: from dhcp-10-175-210-26.vpn.oracle.com (/10.175.210.26)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 15:25:47 -0700
Date:   Thu, 14 May 2020 23:25:39 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
In-Reply-To: <CAEf4BzZpa3Xjevy-tV2oD2Yoxhf=Sm1EPNZdWsv0CoUCSmuF9w@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2005142243090.24127@localhost>
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com> <alpine.LRH.2.21.2005132231450.1535@localhost> <CAEf4BzZpa3Xjevy-tV2oD2Yoxhf=Sm1EPNZdWsv0CoUCSmuF9w@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=818 malwarescore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=837 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=3 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Andrii Nakryiko wrote:

> On Wed, May 13, 2020 at 2:59 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> >
> > - attach a kprobe program to record the data via bpf_ringbuf_reserve(),
> >   and store the reserved pointer value in a per-task keyed hashmap.
> >   Then record the values of interest in the reserved space. This is our
> >   speculative data as we don't know whether we want to commit it yet.
> >
> > - attach a kretprobe program that picks up our reserved pointer and
> >   commit()s or discard()s the associated data based on the return value.
> >
> > - the consumer should (I think) then only read the committed data, so in
> >   this case just the data of interest associated with the failure case.
> >
> > I'm curious if that sort of ringbuf access pattern across multiple
> > programs would work? Thanks!
> 
> 
> Right now it's not allowed. Similar to spin lock and socket reference,
> verifier will enforce that reserved record is committed or discarded
> within the same BPF program invocation. Technically, nothing prevents
> us from relaxing this and allowing to store this pointer in a map, but
> that's probably way too dangerous and not necessary for most common
> cases.
> 

Understood.

> But all your troubles with this is due to using a pair of
> kprobe+kretprobe. What I think should solve your problem is a single
> fexit program. It can read input arguments *and* return value of
> traced function. So there won't be any need for additional map and
> storing speculative data (and no speculation as well, because you'll
> just know beforehand if you even need to capture data). Does this work
> for your case?
> 

That would work for that case, absolutely! Thanks!

Alan



