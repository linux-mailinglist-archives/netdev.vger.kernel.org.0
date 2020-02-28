Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D5E1737E0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgB1NGJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Feb 2020 08:06:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgB1NGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:06:06 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SCwlNE038894
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:06:04 -0500
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yepwj5twj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:06:04 -0500
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Fri, 28 Feb 2020 13:06:03 -0000
Received: from us1b3-smtp04.a3dr.sjc01.isc4sb.com (10.122.203.161)
        by smtp.notes.na.collabserv.com (10.122.47.39) with smtp.notes.na.collabserv.com ESMTP;
        Fri, 28 Feb 2020 13:05:54 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp04.a3dr.sjc01.isc4sb.com
          with ESMTP id 2020022813055366-387445 ;
          Fri, 28 Feb 2020 13:05:53 +0000 
In-Reply-To: <20200227164622.GJ31668@ziepe.ca>
Subject: Re: Re: possible deadlock in cma_netdev_callback
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Date:   Fri, 28 Feb 2020 13:05:53 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20200227164622.GJ31668@ziepe.ca>,<20200227155335.GI31668@ziepe.ca>
 <20200226204238.GC31668@ziepe.ca> <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
 <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP62 November 04, 2019 at 09:47
X-KeepSent: F9E6CFC6:7E79459D-0025851C:00472582;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 15259
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 20022813-6283-0000-0000-000000FF3003
X-IBM-SpamModules-Scores: BY=0.02035; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.399202; ST=0; TS=0; UL=0; ISC=; MB=0.005929
X-IBM-SpamModules-Versions: BY=3.00012657; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000293; SDB=6.01340466; UDB=6.00714387; IPR=6.01122828;
 MB=3.00031010; MTD=3.00000008; XFM=3.00000015; UTC=2020-02-28 13:06:01
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-02-28 12:46:26 - 6.00011059
x-cbparentid: 20022813-6284-0000-0000-000000CD3278
Message-Id: <OFF9E6CFC6.7E79459D-ON0025851C.00472582-0025851C.0047F357@notes.na.collabserv.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_04:2020-02-26,2020-02-28 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@ziepe.ca> wrote: -----

>To: "Bernard Metzler" <BMT@zurich.ibm.com>
>From: "Jason Gunthorpe" <jgg@ziepe.ca>
>Date: 02/27/2020 05:46PM
>Cc: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>netdev@vger.kernel.org, parav@mellanox.com,
>syzkaller-bugs@googlegroups.com, willy@infradead.org
>Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
>
>On Thu, Feb 27, 2020 at 04:21:21PM +0000, Bernard Metzler wrote:
>> 
>> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
>> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
>> >Date: 02/27/2020 04:53PM
>> >Cc: "syzbot"
><syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>> >netdev@vger.kernel.org, parav@mellanox.com,
>> >syzkaller-bugs@googlegroups.com, willy@infradead.org
>> >Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
>> >
>> >On Thu, Feb 27, 2020 at 10:11:13AM +0000, Bernard Metzler wrote:
>> >
>> >> Thanks for letting me know! Hmm, we cannot use RCU locks since
>> >> we potentially sleep. One solution would be to create a list
>> >> of matching interfaces while under lock, unlock and use that
>> >> list for calling siw_listen_address() (which may sleep),
>> >> right...?
>> >
>> >Why do you need to iterate over addresses anyhow? Shouldn't the
>> >listen
>> >just be done with the address the user gave and a BIND DEVICE to
>the
>> >device siw is connected to?
>> 
>> The user may give a wildcard local address, so we'd have
>> to bind to all addresses of that device...
>
>AFAIK a wild card bind using BIND DEVICE works just fine?
>
>Jason
>
Thanks Jason, absolutely! And it makes things so easy...

Let me prepare and send a patch which drops all that
jumbo mumbo logic to iterate over interface addresses
if the socket interface does the right things anyway.

It implies further simplifications to the siw connection
management, since with that we never have to maintain a
list of listening siw endpoints on a given cm_id; it will
always be max one. I'll cleanup the code accordingly and
prepare an extra cleanup patch, which I can send only
later (have a very tight schedule this week).

Bernard.

