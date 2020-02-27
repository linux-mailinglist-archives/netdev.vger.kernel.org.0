Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48826172321
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgB0QVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Feb 2020 11:21:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728963AbgB0QVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:21:33 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RGKied080801
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 11:21:32 -0500
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yden2p6ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 11:21:32 -0500
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Thu, 27 Feb 2020 16:21:30 -0000
Received: from us1b3-smtp06.a3dr.sjc01.isc4sb.com (10.122.203.184)
        by smtp.notes.na.collabserv.com (10.122.47.52) with smtp.notes.na.collabserv.com ESMTP;
        Thu, 27 Feb 2020 16:21:22 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp06.a3dr.sjc01.isc4sb.com
          with ESMTP id 2020022716212224-572447 ;
          Thu, 27 Feb 2020 16:21:22 +0000 
In-Reply-To: <20200227155335.GI31668@ziepe.ca>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Date:   Thu, 27 Feb 2020 16:21:21 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20200227155335.GI31668@ziepe.ca>,<20200226204238.GC31668@ziepe.ca>
 <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP62 November 04, 2019 at 09:47
X-KeepSent: 0C6D63D8:F1817050-0025851B:0059D878;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 18363
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 20022716-3633-0000-0000-000001C8796B
X-IBM-SpamModules-Scores: BY=0.021699; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.399202; ST=0; TS=0; UL=0; ISC=; MB=0.012841
X-IBM-SpamModules-Versions: BY=3.00012651; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000293; SDB=6.01340059; UDB=6.00714142; IPR=6.01122420;
 MB=3.00030996; MTD=3.00000008; XFM=3.00000015; UTC=2020-02-27 16:21:29
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-02-27 12:31:36 - 6.00011055
x-cbparentid: 20022716-3634-0000-0000-0000AD5397FE
Message-Id: <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
Subject: RE: possible deadlock in cma_netdev_callback
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@ziepe.ca> wrote: -----

>To: "Bernard Metzler" <BMT@zurich.ibm.com>
>From: "Jason Gunthorpe" <jgg@ziepe.ca>
>Date: 02/27/2020 04:53PM
>Cc: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
>chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>netdev@vger.kernel.org, parav@mellanox.com,
>syzkaller-bugs@googlegroups.com, willy@infradead.org
>Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
>
>On Thu, Feb 27, 2020 at 10:11:13AM +0000, Bernard Metzler wrote:
>
>> Thanks for letting me know! Hmm, we cannot use RCU locks since
>> we potentially sleep. One solution would be to create a list
>> of matching interfaces while under lock, unlock and use that
>> list for calling siw_listen_address() (which may sleep),
>> right...?
>
>Why do you need to iterate over addresses anyhow? Shouldn't the
>listen
>just be done with the address the user gave and a BIND DEVICE to the
>device siw is connected to?

The user may give a wildcard local address, so we'd have
to bind to all addresses of that device...

Best,
Bernard.

>
>Also that loop in siw_create looks wrong to me
>
>Jason
>
>

