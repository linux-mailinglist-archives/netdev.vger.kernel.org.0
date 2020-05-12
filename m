Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29871CF1F5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgELJyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:54:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgELJyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 05:54:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C9bGV6107844;
        Tue, 12 May 2020 09:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GK1AIi5OPYKrc/RMd9iCeNtIrj+1KqTmS8w/wbAD5p4=;
 b=tFPAw2LegXrzJfb8kpsa75mkT21HdLumJv5Mu1E08w7NMu7mwfb0KKuTZwYqovWD2aEk
 P8KMOaKhfacxzL17WQxx4EQY3gvPspKKbq7D3xE6Pgg3U2WvefXg1MP+jDYfzf4WVgly
 gWwY8D+JGSfwCXNHPa3IOz3FGOr8c+S8heDHfHpV8UqFUigmNF/Tpw6rikLZwdxWtQM2
 ZEWob8jyQKvCGuFMdQlds03uQewqvHW9k/Y9gut+DY5Em852Btj+RZFW61UIZE10HORd
 Op6Eh0UyvpxDJTqRHjVFO6jwUp5xLcfPIEh7H2fo8+1YW2LTAdRnVTtqgZZtaVlPdG5c tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30x3mbt0q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 09:53:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C9cbLC069232;
        Tue, 12 May 2020 09:53:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30x69svh56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 09:53:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C9rj1A023057;
        Tue, 12 May 2020 09:53:45 GMT
Received: from dhcp-10-175-167-216.vpn.oracle.com (/10.175.167.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 02:53:45 -0700
Date:   Tue, 12 May 2020 10:53:38 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <87h7wlwnyl.fsf@toke.dk>
Message-ID: <alpine.LRH.2.21.2005121009220.22093@localhost>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
 <87h7wlwnyl.fsf@toke.dk>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-480967097-1589277224=:22093"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=3 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-480967097-1589277224=:22093
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 12 May 2020, Toke H=F8iland-J=F8rgensen wrote:

> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>=20
> >> > Currently fentry/fexit/freplace progs have single prog->aux->linked_=
prog pointer.
> >> > It just needs to become a linked list.
> >> > The api extension could be like this:
> >> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> >> > (currently it's just bpf_raw_tp_open(prog_fd))
> >> > The same pair of (attach_prog_fd, attach_btf_id) is already passed i=
nto prog_load
> >> > to hold the linked_prog and its corresponding btf_id.
> >> > I'm proposing to extend raw_tp_open with this pair as well to
> >> > attach existing fentry/fexit/freplace prog to another target.
> >> > Internally the kernel verify that btf of current linked_prog
> >> > exactly matches to btf of another requested linked_prog and
> >> > if they match it will attach the same prog to two target programs (i=
n case of freplace)
> >> > or two kernel functions (in case of fentry/fexit).
> >>=20
> >> API-wise this was exactly what I had in mind as well.
> >
> > perfect!
>

Apologies in advance if I've missed a way to do this, but
for fentry/fexit, if we could attach the same program to
multiple kernel functions, it would be great it we could
programmatically access the BTF func proto id for the
attached function (prog->aux->attach_btf_id I think?).
Then perhaps we could support access to that and associated
ids via a helper, roughly like:

s32 btf_attach_info(enum btf_info_wanted wanted,
=09=09    struct __btf_ptr *ptr,__u64 flags);

The info_wanted would be BTF_INFO_FUNC_PROTO, BTF_INFO_RET_TYPE,
BTF_INFO_NARGS, BTF_INFO_ARG1, etc.

With that and the BTF-based printk support in hand, we could
potentially use bpf_trace_printk() to print function arguments
in an attach-point agnostic way.  The BTF printk v2 patchset has
support for BTF id-based display (it's not currently used in that
patchset though). We'd have to teach it to print BTF func protos
but that's not too tricky I think. An ftrace-like program that
would print out function prototypes for the attached function
would look something like this:

=09struct __btf_ptr func =3D { 0 };
=09btf_attach_info(BTF_INFO_FUNC_PROTO, &func, 0);=20
=09btf_printk("%pT", &func);

Printing args would be slightly more complicated because we'd have
to determine from the BTF func proto whether the function argument
was a pointer or not. The BTF printk code assumes the _pointee_ BTF
type ("struct sk_buff") is specified along with the pointer
(a struct sk_buff *).

So

- if an arg is not a pointer, we'd need to set the pointer value
  in struct __btf_ptr to &arg while using the BTF id from the
  func proto
- if an arg is a pointer we'd want to get the pointee BTF type
  from the func proto while using the argument as the pointer arg.

Perhaps the best way to achieve that would be to pass in
a value/result struct __btf_ptr * as arg and have the
helper do the right thing.  Alternately we could use flags to
specify that for args which are pointers we want the pointee
BTF type.

With all that in place, we'd have all the pieces to write a
generic ftrace-like BPF program that supported function argument
display for any function attach point.=20

I've had trouble keeping up with everything going on so
perhaps there's a way to do some of this already, but my understanding
of most of the referencing of attach BTF id is done at
verifier time. Tweaking the BPF program itself isn't an option
if it is to be shared with multiple attach points.

All of which is to say that if the aux info contains a linked
list, having the attach BTF id for each attached program accessible
such that a helper could retrieve the BTF id of the function it
is attached to would be great!

Thanks!

Alan


> Hi Alexei
>=20
> I don't suppose you've had a chance to whip up a patch for this, have
> you? :)
>=20
> -Toke
>=20
>=20
--8323328-480967097-1589277224=:22093--
