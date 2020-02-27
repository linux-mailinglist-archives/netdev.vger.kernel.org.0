Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829A81714C5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 11:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgB0KLZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Feb 2020 05:11:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbgB0KLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 05:11:25 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RA9cOR175435
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 05:11:23 -0500
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydq6x8xhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 05:11:23 -0500
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Thu, 27 Feb 2020 10:11:23 -0000
Received: from us1b3-smtp06.a3dr.sjc01.isc4sb.com (10.122.203.184)
        by smtp.notes.na.collabserv.com (10.122.47.50) with smtp.notes.na.collabserv.com ESMTP;
        Thu, 27 Feb 2020 10:11:13 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp06.a3dr.sjc01.isc4sb.com
          with ESMTP id 2020022710111331-238493 ;
          Thu, 27 Feb 2020 10:11:13 +0000 
In-Reply-To: <20200226204238.GC31668@ziepe.ca>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Date:   Thu, 27 Feb 2020 10:11:13 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20200226204238.GC31668@ziepe.ca>,<000000000000153fac059f740693@google.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP62 November 04, 2019 at 09:47
X-KeepSent: 0B62EDE7:E13D40E8-0025851B:0037F560;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 60603
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 20022710-1059-0000-0000-0000017D012E
X-IBM-SpamModules-Scores: BY=0.209162; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.378364; ST=0; TS=0; UL=0; ISC=; MB=0.076051
X-IBM-SpamModules-Versions: BY=3.00012650; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000293; SDB=6.01339935; UDB=6.00714070; IPR=6.01122299;
 MB=3.00030991; MTD=3.00000008; XFM=3.00000015; UTC=2020-02-27 10:11:20
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-02-27 07:10:20 - 6.00011054
x-cbparentid: 20022710-1060-0000-0000-00004A270103
Message-Id: <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
Subject: RE: possible deadlock in cma_netdev_callback
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_02:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@ziepe.ca> wrote: -----

>To: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>
>From: "Jason Gunthorpe" <jgg@ziepe.ca>
>Date: 02/26/2020 09:42PM
>Cc: chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
>linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
>netdev@vger.kernel.org, parav@mellanox.com,
>syzkaller-bugs@googlegroups.com, willy@infradead.org, "Bernard
>Metzler" <bmt@zurich.ibm.com>
>Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
>
>On Tue, Feb 25, 2020 at 09:39:10PM -0800, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following crash on:
>> 
>> HEAD commit:    6132c1d9 net: core: devlink.c: Hold devlink->lock
>from the..
>> git tree:       net
>> console output:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspo
>t.com_x_log.txt-3Fx-3D16978909e00000&d=DwIBAg&c=jf_iaSHvJObTbx-siA1ZO
>g&r=2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=I4mBjC4dKAL61lpQH5f
>iT4hLQEibtRif2HwliI2VpTA&s=Pd7_6w9kZzU3DupxBL6qo6piAhk8us2gO-BbCVTDj3
>Q&e= 
>> kernel config:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspo
>t.com_x_.config-3Fx-3D3b8906eb6a7d6028&d=DwIBAg&c=jf_iaSHvJObTbx-siA1
>ZOg&r=2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=I4mBjC4dKAL61lpQH
>5fiT4hLQEibtRif2HwliI2VpTA&s=qI_ppGZR3Vy01oD9xwfU3or7fBrclf20NYgmTJ0N
>v4k&e= 
>> dashboard link:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspo
>t.com_bug-3Fextid-3D55de90ab5f44172b0c90&d=DwIBAg&c=jf_iaSHvJObTbx-si
>A1ZOg&r=2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=I4mBjC4dKAL61lp
>QH5fiT4hLQEibtRif2HwliI2VpTA&s=OCNawVVe2X3ySwQUmRx_s2XM3p0r4d4cMFkYU_
>IIAmM&e= 
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspo
>t.com_x_repro.syz-3Fx-3D12808281e00000&d=DwIBAg&c=jf_iaSHvJObTbx-siA1
>ZOg&r=2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=I4mBjC4dKAL61lpQH
>5fiT4hLQEibtRif2HwliI2VpTA&s=_-Ba4z4VxFdS5ran1HOTqcCl5KtbdPUvvthP_yOT
>bJw&e= 
>> C reproducer:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspo
>t.com_x_repro.c-3Fx-3D134ca6fde00000&d=DwIBAg&c=jf_iaSHvJObTbx-siA1ZO
>g&r=2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=I4mBjC4dKAL61lpQH5f
>iT4hLQEibtRif2HwliI2VpTA&s=tTrtxQFoWaR89fJY7q7Z2shNBhVzrshezgxE17uS34
>o&e= 
>> 
>> IMPORTANT: if you fix the bug, please add the following tag to the
>commit:
>> Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com
>> 
>> iwpm_register_pid: Unable to send a nlmsg (client = 2)
>> infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
>> netlink: 'syz-executor639': attribute type 1 has an invalid length.
>> 8021q: adding VLAN 0 to HW filter on device bond1
>> bond1: (slave gretap1): making interface the new active one
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 5.6.0-rc2-syzkaller #0 Not tainted
>> syz-executor639/9689 is trying to acquire lock:
>> ffffffff8a5d2a60 (lock#3){+.+.}, at: cma_netdev_callback+0xc6/0x380
>drivers/infiniband/core/cma.c:4605
>> 
>> but task is already holding lock:
>> ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnl_lock
>net/core/rtnetlink.c:72 [inline]
>> ffffffff8a74da00 (rtnl_mutex){+.+.}, at:
>rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5433
>>
>
>Bernard, this is a siw bug too, it is not allowed to get RTNL in
>siw_create_listen() (though this is probably for silly reasons and
>could be fixed)
>
>It is not easy to get this into the lockdep, I'll send a different
>patch too
>
>Jason
Hi Jason,

Thanks for letting me know! Hmm, we cannot use RCU locks since
we potentially sleep. One solution would be to create a list
of matching interfaces while under lock, unlock and use that
list for calling siw_listen_address() (which may sleep),
right...?

Many thanks,
Bernard.

