Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAD173D3D
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgB1QmN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Feb 2020 11:42:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbgB1QmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:42:13 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SGcd2P069453
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 11:42:12 -0500
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.112])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepxbdhfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 11:42:12 -0500
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Fri, 28 Feb 2020 16:42:12 -0000
Received: from us1b3-smtp08.a3dr.sjc01.isc4sb.com (10.122.203.190)
        by smtp.notes.na.collabserv.com (10.122.47.54) with smtp.notes.na.collabserv.com ESMTP;
        Fri, 28 Feb 2020 16:42:03 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp08.a3dr.sjc01.isc4sb.com
          with ESMTP id 2020022816420346-560799 ;
          Fri, 28 Feb 2020 16:42:03 +0000 
In-Reply-To: <20200228133500.GN31668@ziepe.ca>
Subject: Re: Re: Re: possible deadlock in cma_netdev_callback
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Date:   Fri, 28 Feb 2020 16:42:02 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20200228133500.GN31668@ziepe.ca>,<20200227164622.GJ31668@ziepe.ca>
 <20200227155335.GI31668@ziepe.ca> <20200226204238.GC31668@ziepe.ca>
 <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
 <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
 <OFF9E6CFC6.7E79459D-ON0025851C.00472582-0025851C.0047F357@notes.na.collabserv.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP62 November 04, 2019 at 09:47
X-KeepSent: E6F5FD43:5CAFDF8A-0025851C:005AC3E0;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 48399
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 20022816-4615-0000-0000-0000019A70F7
X-IBM-SpamModules-Scores: BY=0.020206; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.411265; ST=0; TS=0; UL=0; ISC=; MB=0.005295
X-IBM-SpamModules-Versions: BY=3.00012657; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000293; SDB=6.01340539; UDB=6.00714412; IPR=6.01122900;
 MB=3.00031011; MTD=3.00000008; XFM=3.00000015; UTC=2020-02-28 16:42:10
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-02-28 12:22:27 - 6.00011059
x-cbparentid: 20022816-4616-0000-0000-0000B8BA7A08
Message-Id: <OFE6F5FD43.5CAFDF8A-ON0025851C.005AC3E0-0025851C.005BBD83@notes.na.collabserv.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_05:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@ziepe.ca> wrote: -----

>To: "Bernard Metzler" <BMT@zurich.ibm.com>
>From: "Jason Gunthorpe" <jgg@ziepe.ca>
>Date: 02/28/2020 02:35PM
>Cc: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>netdev@vger.kernel.org, parav@mellanox.com,
>syzkaller-bugs@googlegroups.com, willy@infradead.org
>Subject: [EXTERNAL] Re: Re: possible deadlock in cma_netdev_callback
>
>On Fri, Feb 28, 2020 at 01:05:53PM +0000, Bernard Metzler wrote:
>> 
>> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
>> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
>> >Date: 02/27/2020 05:46PM
>> >Cc: "syzbot"
><syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>> >netdev@vger.kernel.org, parav@mellanox.com,
>> >syzkaller-bugs@googlegroups.com, willy@infradead.org
>> >Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
>> >
>> >On Thu, Feb 27, 2020 at 04:21:21PM +0000, Bernard Metzler wrote:
>> >> 
>> >> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
>> >> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
>> >> >Date: 02/27/2020 04:53PM
>> >> >Cc: "syzbot"
>> ><syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>> >> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>> >> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>> >> >netdev@vger.kernel.org, parav@mellanox.com,
>> >> >syzkaller-bugs@googlegroups.com, willy@infradead.org
>> >> >Subject: [EXTERNAL] Re: possible deadlock in
>cma_netdev_callback
>> >> >
>> >> >On Thu, Feb 27, 2020 at 10:11:13AM +0000, Bernard Metzler
>wrote:
>> >> >
>> >> >> Thanks for letting me know! Hmm, we cannot use RCU locks
>since
>> >> >> we potentially sleep. One solution would be to create a list
>> >> >> of matching interfaces while under lock, unlock and use that
>> >> >> list for calling siw_listen_address() (which may sleep),
>> >> >> right...?
>> >> >
>> >> >Why do you need to iterate over addresses anyhow? Shouldn't the
>> >> >listen
>> >> >just be done with the address the user gave and a BIND DEVICE
>to
>> >the
>> >> >device siw is connected to?
>> >> 
>> >> The user may give a wildcard local address, so we'd have
>> >> to bind to all addresses of that device...
>> >
>> >AFAIK a wild card bind using BIND DEVICE works just fine?
>> >
>> >Jason
>> >
>> Thanks Jason, absolutely! And it makes things so easy...
>
>Probably check to confirm, it just my memory..
>
>Jason
>
Well, right, marking a socket via setsockopt SO_BINDTODEVICE
does not work - I get -EPERM. Maybe works only from user land
since the ifname gets copied in from there.

What I tested as working is nailing the scope of wildcard
listen via:
s->sk->sk_bound_dev_if = netdev->ifindex;

Without doing it, wildcard listen would end up covering all
interfaces, even if siw is not attached to some. Also, if siw is
attached to more than one interface, only the first bind call
works of course (for wildcard, the rdma_cm calls me for all
interfaces siw is attached to). So without binding to a
device it is not working.

I am not sure what is the right way of limiting the scope
of a socket to one interface in kernel mode. Is above line
the way to go, or do I miss an interface to do such things?
Anybody could help?

Thanks very much!
Bernard.

