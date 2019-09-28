Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34343C119E
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 19:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbfI1Rqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 13:46:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfI1Rqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 13:46:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8SHhuQh095199;
        Sat, 28 Sep 2019 17:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=fE//Ab6xCjS3zyHgDuya9QjAizHmfNuzIaig25qXXMQ=;
 b=CPksWsYDYpMKgoKlRK0eqHQRQD716zLixpmP7GrTt+CJgFlSQGh2Kn8hoIRV/izgkmFZ
 zlfkJSTIo1igUBcN5cqLhu9AQ29k5znyRxMWAAaarLwfcptHhV9Zmz8pYQg2nNKq7OOg
 8CmoQf3PohAxjf16EKiQ5cYOsCy/U1ijWNjRSS12a6hGTPQB2hs1IAUgd6nzo2KQYQEH
 5+z/IiswWOSljR5phzX217rY7otpLGzSRajayAYszwduumC864wOg+HRVRorexjgzvgQ
 TtgKkaKQ+jtU8wR8s2xzoJDB2yhBO66zzcF3WjNV8Eg11q5rmBWuA2ncb8oMljHZEiXb 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfpsa38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Sep 2019 17:46:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8SHgvPQ093012;
        Sat, 28 Sep 2019 17:46:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v9xv7e1r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Sep 2019 17:46:27 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8SHkQkY001178;
        Sat, 28 Sep 2019 17:46:26 GMT
Received: from dhcp-10-175-223-161.vpn.oracle.com (/10.175.223.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 28 Sep 2019 10:46:26 -0700
Date:   Sat, 28 Sep 2019 18:46:22 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-218-65.vpn.oracle.com
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically
 possible
In-Reply-To: <CAEf4BzYTQbVVUiQOHEcjL8mZ=iJBSGHFRNxoayRpaMw5ys+iDw@mail.gmail.com>
Message-ID: <alpine.LRH.2.20.1909281844480.5332@dhcp-10-175-218-65.vpn.oracle.com>
References: <20190928063033.1674094-1-andriin@fb.com> <alpine.LRH.2.20.1909281202530.5332@dhcp-10-175-218-65.vpn.oracle.com> <CAEf4BzYTQbVVUiQOHEcjL8mZ=iJBSGHFRNxoayRpaMw5ys+iDw@mail.gmail.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9394 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909280185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9394 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909280185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Sep 2019, Andrii Nakryiko wrote:

> On Sat, Sep 28, 2019 at 4:20 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > On Fri, 27 Sep 2019, Andrii Nakryiko wrote:
> >
> > > This patch switches libbpf_num_possible_cpus() from using possible CPU
> > > set to present CPU set. This fixes issues with incorrect auto-sizing of
> > > PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
> > >
> > > On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> > > be a set of any representable (i.e., potentially possible) CPU, which is
> > > normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> > > tested on, while there were just two CPU cores actually present).
> > > /sys/devices/system/cpu/present, on the other hand, will only contain
> > > CPUs that are physically present in the system (even if not online yet),
> > > which is what we really want, especially when creating per-CPU maps or
> > > perf events.
> > >
> > > On systems with HOTPLUG disabled, present and possible are identical, so
> > > there is no change of behavior there.
> > >
> >
> > Just curious - is there a reason for not adding a new libbpf_num_present_cpus()
> > function to cover this  case, and switching to using that in various places?
> 
> The reason is that libbpf_num_possible_cpus() is useless on HOTPLUG
> systems and never worked as intended. If you rely on this function to
> create perf_buffer and/or PERF_EVENT_ARRAY, it will simply fail due to
> specifying more CPUs than are present. I didn't want to keep adding
> new APIs for no good reason, while also leaving useless ones, so I
> fixed the existing API to behave as expected. It's unfortunate that
> name doesn't match sysfs file we are reading it from, of course, but
> having people to choose between libbpf_num_possible_cpus() vs
> libbpf_num_present_cpus() seems like even bigger problem, as
> differences are non-obvious.
> 
> The good thing, it won't break all the non-HOTPLUG systems for sure,
> which seems to be the only cases that are used right now (otherwise
> someone would already complain about broken
> libbpf_num_possible_cpus()).
>

Understood, thanks for the explanation. 

> >
> > Looking at the places libbpf_num_possible_cpus() is called in libbpf
> >
> > - __perf_buffer__new(): this could just change to use the number of
> >   present CPUs, since perf_buffer__new_raw() with a cpu_cnt in struct
> >   perf_buffer_raw_ops
> >
> > - bpf_object__create_maps(), which is called via bpf_oject__load_xattr().
> >   In this case it seems like switching to num present makes sense, though
> >   it might make sense to add a field to struct bpf_object_load_attr * to
> >   allow users to explicitly set another max value.
> 
> I believe more knobs is not always better for API. Plus, adding any
> field to those xxx_xattr structs is an ABI breakage and requires
> adding new APIs, so I don't think this is good enough reason to add
> new flag. See discussion in another thread about this whole API design
> w/ current attributes and ABI consequences of adding anything new to
> them.
> 
> >
> > This would give the desired default behaviour, while still giving users
> > a way of specifying the possible number. What do you think? Thanks!
> 
> BTW, if user wants to override the size of maps, they can do it easily
> either in map definition or programmatically after bpf_object__open,
> but before bpf_object__load, so there is no need for flags, it's all
> easily achievable with existing API.
> 

Ah, I missed that. Thanks for clarifying!

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>

> >
> > Alan
> >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index e0276520171b..45351c074e45 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
> > >
> > >  int libbpf_num_possible_cpus(void)
> > >  {
> > > -     static const char *fcpu = "/sys/devices/system/cpu/possible";
> > > +     static const char *fcpu = "/sys/devices/system/cpu/present";
> > >       int len = 0, n = 0, il = 0, ir = 0;
> > >       unsigned int start = 0, end = 0;
> > >       int tmp_cpus = 0;
> > > --
> > > 2.17.1
> > >
> > >
> 
