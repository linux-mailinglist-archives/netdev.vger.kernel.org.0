Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591BB25FD00
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgIGPWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:22:40 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:42817
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730086AbgIGPWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 11:22:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJc42+u60Z8qZgQy2UGNTC2E7/iIOgPkwUfzMOCriFVYj+ycGG0ewp2mNvm81/fZ3vP9sVAxbJ5VFsOhmLFmvAtEfMuGpFoqMKp6RvX1QNRNvBAKzp5hhSJr9znnDdgVxOivXEA/SmHsAI2McxlTWU9L9FuzURnycTMdrkSslMhAf9TX3X9swAooZYmyjj+cHffHLUvJULmXJI5xxpIWxZGhwleYcPVuUAF0p5cpLl5W6sk530YWuYIQbPW66NwdkHOPh09a7/isYqIhf+IsIfgZ8QCIiqUIGozvGSeRL3u/Rpa+hoXl3QQ5m+RUJzj5OHbWAMlW2RIB2FU6gKlopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRQg3oHNIsxu7+eKb15xuatISCcbYzCNdriepj4POrg=;
 b=H/IMeG7z+0LBF3JI6EftEYDftU+xpXGl7BZvcaTYnNl32DCG53c81gPdFPv/jV+WPIU53m0L18BNhGzHaJLYdIakw8kkKA7PEtIhxt6ONXrD0tYN/zBWyCZeNI7JmJSi1/kLA7Oh3iCuOSnk3En7UPIMoiWqIK3SahxDbDo8FG4+QgaDSmC8xuQG3Z5Fpj4AS1iUPXfqhd7IUgIj+EruXpp7SYFlW1ktIVCVszMKBnFLNcZtXMy+ADXsLGKiOn5OMGRxVe/FWjSUY2iIFAiRfjjG+gZtxI4ZlQ+h9KU7E3ov5SIl6vHC73ov6NlKQS9SbpAX0fwzBKyeD+7wQC3r6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRQg3oHNIsxu7+eKb15xuatISCcbYzCNdriepj4POrg=;
 b=RS+bOKOENaFU3e17A2EzfZper3tHb6og5Mx7q2ZwRmIWlkXWQ/tAeDq28aOK7htcSA/jUeSMoqXODdMSudOohm9qyCUEW90DECd0LQp3e8kpWmuJpctY2h0U4OsD3AMSuC2pm5cwayGgxLSO/CsIVn628AJDbscLpP83Cs1Uarw=
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM5PR11MB1307.namprd11.prod.outlook.com (2603:10b6:3:15::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Mon, 7 Sep 2020 15:05:46 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::7c14:88f9:23cf:4da9]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::7c14:88f9:23cf:4da9%3]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 15:05:45 +0000
From:   "Xue, Ying" <Ying.Xue@windriver.com>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com" 
        <syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com>
Subject: RE: [net-next v2] tipc: fix a deadlock when flushing scheduled work
Thread-Topic: [net-next v2] tipc: fix a deadlock when flushing scheduled work
Thread-Index: AQHWhN6loo4cBb9JtECLH/jy5lJFtaldRYyQ
Date:   Mon, 7 Sep 2020 15:05:45 +0000
Message-ID: <DM6PR11MB26034EB2DC2D5ED3A124D35A84280@DM6PR11MB2603.namprd11.prod.outlook.com>
References: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
 <20200907061725.43879-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20200907061725.43879-1-hoang.h.le@dektech.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dektech.com.au; dkim=none (message not signed)
 header.d=none;dektech.com.au; dmarc=none action=none
 header.from=windriver.com;
x-originating-ip: [123.123.4.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26a785c1-0a87-4565-321d-08d8533f7f58
x-ms-traffictypediagnostic: DM5PR11MB1307:
x-microsoft-antispam-prvs: <DM5PR11MB13072D638AB0A7882607B24784280@DM5PR11MB1307.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SjMTnsb4byI41Xk9IrHmiLtzGGiz6YKuQiH2E+FeP+ZAAPcwpnkRItAEkXu7Qk+aAufMmK1lWhFFjXMEdgS4rUS6M+RsZVKcawSW5ClMFYMUK7NrIQHYuw6+MCwy3hzZtqWiSv+t4c75cWMj1xfEfYH64qc20YjEIYTPjBMuD6W1XWlSwQ+bPwfrkX/vBmi8bkkLPnmmWNOPC2gYazTLYTiCCa2iCdIpt+nSTueZuDWKhK1oppig+Ii5DBLlw2+ejFGCYLPFmSVf1G7tIAYDOhZtmph9oc+PK4nL87ROkOD0p6EoITLunSgJFnaylWWz1/CqJDrQviRNR3eePVZkaxQH2LZLeMtLe8qWzOMApl+PCs2ymmtuDJbFSGENVR14
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(136003)(376002)(346002)(76116006)(66946007)(66616009)(64756008)(7696005)(66446008)(33656002)(5660300002)(316002)(110136005)(53546011)(52536014)(6506007)(71200400001)(54906003)(26005)(9686003)(55016002)(83380400001)(8676002)(186003)(66476007)(66556008)(478600001)(2906002)(8936002)(4326008)(86362001)(99936003)(9126004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6rV2LLfb6FRRj6P5mrLrdzifw2uOrRO7tGZuIF1yd74N2DJn9ynL8lgBT9YPUSKjJYDjQa7JFntRD5grgN1l9j9vICfbdeFpW54My9rJVSYoRi8wlWnI8bojbSFVMlaV/3UutAVYFPt6koGuIv0xsZHVmzi+3SPu89JBvURL7NKGq3Rh9qYjqKGoyMelGcIUXx0RMj6bVga9rb4Vqi/qODtPRRiFR4dIjIUL6cNq8+7aLICUA3KQPfscsbRvI6q+M85fyMCZoi9oN5Xq9IhFTvQTdD7l497syxMpaT7F09v/iPmIVNoeudRmnpeHtk1uJTfNRwUj0ZsT59eQLxNzrkQ320tAmW4g9i04kVSsXI899+mevavejPwr15d1vT2lyEV8f4BiLBO4oLHgKnMV7DlAY+PSSIXIb5c2s3cm0Y5pGD+4jPs98bK5OzHluFWPGa5r+iPcILSQQcX8z+YAMDkmn1uyyYPeNofUXIGoDDh2ryTtjnOtb3xW+xkrBg74E4JqP6MczKiGe5A0Uh6opxJU1IKqKUBZ+0EkdTZDUmsfhWGF1TqNriS67aXlilo4RGFkvEsqFBCD3gfNvlzAooZkfED5pbehMRSM7WyF0UXWTR7AQVhruSA3ED9VmNRIQtJzTHpH07hPuAxTmFw23Q==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_DM6PR11MB26034EB2DC2D5ED3A124D35A84280DM6PR11MB2603namp_"
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a785c1-0a87-4565-321d-08d8533f7f58
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 15:05:45.5417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZE/majGI4pscfkb+XnTEVYtGa0BvvOxmthWFW+V4xBm8Fl3ZxRzDXuQffOKqafLJn5PeSk0kK7xd2MuJm9J5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_DM6PR11MB26034EB2DC2D5ED3A124D35A84280DM6PR11MB2603namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I don't think we need to make so many lines of changes. Please take a look =
at the attached patch which was created to fix the original deadlock: syzbo=
t+6ea1f7a8df64596ef4d7@syzkaller.appspotmail.com. If you think the attached=
 solution is fine, please consider to rebase it on the latest net-next tree=
.

-----Original Message-----
From: Hoang Huu Le <hoang.h.le@dektech.com.au>=20
Sent: Monday, September 7, 2020 2:17 PM
To: Xue, Ying <Ying.Xue@windriver.com>; netdev@vger.kernel.org
Cc: jmaloy@redhat.com; maloy@donjonn.com; syzbot+d5aa7e0385f6a5d0f4fd@syzka=
ller.appspotmail.com
Subject: [net-next v2] tipc: fix a deadlock when flushing scheduled work

In the commit fdeba99b1e58
("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying to make s=
ure the tipc_net_finalize_work work item finished if it enqueued. But calli=
ng flush_scheduled_work() is not just affecting above work item but either =
any scheduled work. This has turned out to be overkill and caused to deadlo=
ck as syzbot reported:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected 5.9.0-rc2-next-20200=
828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/349 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0=
xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10=
 net/core/net_namespace.c:565

[...]
 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***
[...]

v1:
To fix the original issue, we replace above calling by introducing a bit fl=
ag. When a namespace cleaned-up, bit flag is set to zero and:
- tipc_net_finalize functionial just does return immediately.
- tipc_net_finalize_work does not enqueue into the scheduled work queue.

v2:
Use cancel_work_sync() helper to make sure ONLY the
tipc_net_finalize_work() stopped before releasing bcbase object.

Reported-by: syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Fixes: fdeba99b1e58 ("tipc: fix use-after-free in tipc_bcast_get_mode")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/core.c |  9 +++++----
 net/tipc/core.h |  8 ++++++++
 net/tipc/net.c  | 20 +++++---------------  net/tipc/net.h  |  1 +
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c index 37d8695548cf..c2ff4290=
0b53 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,6 +60,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr =3D 0;
 	tn->addr_trial_end =3D 0;
 	tn->capabilities =3D TIPC_NODE_CAPABILITIES;
+	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold =3D TIPC_DEF_MON_THRESHOLD; @@ -107,13 +108,13 @@ stati=
c int __net_init tipc_init_net(struct net *net)
=20
 static void __net_exit tipc_exit_net(struct net *net)  {
+	struct tipc_net *tn =3D tipc_net(net);
+
 	tipc_detach_loopback(net);
+	/* Make sure the tipc_net_finalize_work() finished */
+	cancel_work_sync(&tn->final_work.work);
 	tipc_net_stop(net);
=20
-	/* Make sure the tipc_net_finalize_work stopped
-	 * before releasing the resources.
-	 */
-	flush_scheduled_work();
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h index 631d83c9705f..1d57a4d3=
b05e 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -90,6 +90,12 @@ extern unsigned int tipc_net_id __read_mostly;  extern i=
nt sysctl_tipc_rmem[3] __read_mostly;  extern int sysctl_tipc_named_timeout=
 __read_mostly;
=20
+struct tipc_net_work {
+	struct work_struct work;
+	struct net *net;
+	u32 addr;
+};
+
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -143,6 +149,8 @@ struct tipc_net {
 	/* TX crypto handler */
 	struct tipc_crypto *crypto_tx;
 #endif
+	/* Work item for net finalize */
+	struct tipc_net_work final_work;
 };
=20
 static inline struct tipc_net *tipc_net(struct net *net) diff --git a/net/=
tipc/net.c b/net/tipc/net.c index 85400e4242de..0bb2323201da 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -105,12 +105,6 @@
  *     - A local spin_lock protecting the queue of subscriber events.
 */
=20
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 static void tipc_net_finalize(struct net *net, u32 addr);
=20
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr) @@ -142,25 +136,=
21 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
=20
-static void tipc_net_finalize_work(struct work_struct *work)
+void tipc_net_finalize_work(struct work_struct *work)
 {
 	struct tipc_net_work *fwork;
=20
 	fwork =3D container_of(work, struct tipc_net_work, work);
 	tipc_net_finalize(fwork->net, fwork->addr);
-	kfree(fwork);
 }
=20
 void tipc_sched_net_finalize(struct net *net, u32 addr)  {
-	struct tipc_net_work *fwork =3D kzalloc(sizeof(*fwork), GFP_ATOMIC);
+	struct tipc_net *tn =3D tipc_net(net);
=20
-	if (!fwork)
-		return;
-	INIT_WORK(&fwork->work, tipc_net_finalize_work);
-	fwork->net =3D net;
-	fwork->addr =3D addr;
-	schedule_work(&fwork->work);
+	tn->final_work.net =3D net;
+	tn->final_work.addr =3D addr;
+	schedule_work(&tn->final_work.work);
 }
=20
 void tipc_net_stop(struct net *net)
diff --git a/net/tipc/net.h b/net/tipc/net.h index 6740d97c706e..d0c91d2df2=
0a 100644
--- a/net/tipc/net.h
+++ b/net/tipc/net.h
@@ -42,6 +42,7 @@
 extern const struct nla_policy tipc_nl_net_policy[];
=20
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr);
+void tipc_net_finalize_work(struct work_struct *work);
 void tipc_sched_net_finalize(struct net *net, u32 addr);  void tipc_net_st=
op(struct net *net);  int tipc_nl_net_dump(struct sk_buff *skb, struct netl=
ink_callback *cb);
--
2.25.1


--_002_DM6PR11MB26034EB2DC2D5ED3A124D35A84280DM6PR11MB2603namp_
Content-Type: application/octet-stream;
	name="0001-tipc-fix-use-after-free-Read-in-tipc_bcast_get_mode.patch"
Content-Description:
 0001-tipc-fix-use-after-free-Read-in-tipc_bcast_get_mode.patch
Content-Disposition: attachment;
	filename="0001-tipc-fix-use-after-free-Read-in-tipc_bcast_get_mode.patch";
	size=6020; creation-date="Mon, 07 Sep 2020 14:59:36 GMT";
	modification-date="Mon, 07 Sep 2020 14:59:36 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiZTZmYzYzMmU3ODhiMjE2NTk4OGNlYmI5NzdlZGVmMWM1MzhhZDY0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZaW5nIFh1ZSA8eWluZy54dWVAd2luZHJpdmVyLmNvbT4KRGF0
ZTogU3VuLCAxNiBBdWcgMjAyMCAyMToyOTo1NyArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHRpcGM6
IGZpeCB1c2UtYWZ0ZXItZnJlZSBSZWFkIGluIHRpcGNfYmNhc3RfZ2V0X21vZGUKCnN5emJvdCBm
b3VuZCB0aGUgZm9sbG93aW5nIGlzc3VlIG9uOgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJl
ZSBpbiB0aXBjX2JjYXN0X2dldF9tb2RlKzB4M2FiLzB4NDAwCm5ldC90aXBjL2JjYXN0LmM6NzU5
ClJlYWQgb2Ygc2l6ZSAxIGF0IGFkZHIgZmZmZjg4ODA1ZTZiMzU3MSBieSB0YXNrIGt3b3JrZXIv
MDo2LzM4NTAKCkNQVTogMCBQSUQ6IDM4NTAgQ29tbToga3dvcmtlci8wOjYgTm90IHRhaW50ZWQg
NS44LjAtcmM3LXN5emthbGxlciAjMApIYXJkd2FyZSBuYW1lOiBHb29nbGUgR29vZ2xlIENvbXB1
dGUgRW5naW5lL0dvb2dsZSBDb21wdXRlIEVuZ2luZSwgQklPUwpHb29nbGUgMDEvMDEvMjAxMQpX
b3JrcXVldWU6IGV2ZW50cyB0aXBjX25ldF9maW5hbGl6ZV93b3JrCkNhbGwgVHJhY2U6CiBfX2R1
bXBfc3RhY2sgbGliL2R1bXBfc3RhY2suYzo3NyBbaW5saW5lXQogZHVtcF9zdGFjaysweDE4Zi8w
eDIwZCBsaWIvZHVtcF9zdGFjay5jOjExOAogcHJpbnRfYWRkcmVzc19kZXNjcmlwdGlvbi5jb25z
dHByb3AuMC5jb2xkKzB4YWUvMHg0MzYKbW0va2FzYW4vcmVwb3J0LmM6MzgzCiBfX2thc2FuX3Jl
cG9ydCBtbS9rYXNhbi9yZXBvcnQuYzo1MTMgW2lubGluZV0KIGthc2FuX3JlcG9ydC5jb2xkKzB4
MWYvMHgzNyBtbS9rYXNhbi9yZXBvcnQuYzo1MzAKIHRpcGNfYmNhc3RfZ2V0X21vZGUrMHgzYWIv
MHg0MDAgbmV0L3RpcGMvYmNhc3QuYzo3NTkKIHRpcGNfbm9kZV9icm9hZGNhc3QrMHg5ZS8weGNj
MCBuZXQvdGlwYy9ub2RlLmM6MTc0NAogdGlwY19uYW1ldGJsX3B1Ymxpc2grMHg2MGIvMHg5NzAg
bmV0L3RpcGMvbmFtZV90YWJsZS5jOjc1MgogdGlwY19uZXRfZmluYWxpemUgbmV0L3RpcGMvbmV0
LmM6MTQxIFtpbmxpbmVdCiB0aXBjX25ldF9maW5hbGl6ZSsweDFmYS8weDMxMCBuZXQvdGlwYy9u
ZXQuYzoxMzEKIHRpcGNfbmV0X2ZpbmFsaXplX3dvcmsrMHg1NS8weDgwIG5ldC90aXBjL25ldC5j
OjE1MAogcHJvY2Vzc19vbmVfd29yaysweDk0Yy8weDE2NzAga2VybmVsL3dvcmtxdWV1ZS5jOjIy
NjkKIHdvcmtlcl90aHJlYWQrMHg2NGMvMHgxMTIwIGtlcm5lbC93b3JrcXVldWUuYzoyNDE1CiBr
dGhyZWFkKzB4M2I1LzB4NGEwIGtlcm5lbC9rdGhyZWFkLmM6MjkxCiByZXRfZnJvbV9mb3JrKzB4
MWYvMHgzMCBhcmNoL3g4Ni9lbnRyeS9lbnRyeV82NC5TOjI5MwoKQWxsb2NhdGVkIGJ5IHRhc2sg
ODA2MjoKIHNhdmVfc3RhY2srMHgxYi8weDQwIG1tL2thc2FuL2NvbW1vbi5jOjQ4CiBzZXRfdHJh
Y2sgbW0va2FzYW4vY29tbW9uLmM6NTYgW2lubGluZV0KIF9fa2FzYW5fa21hbGxvYy5jb25zdHBy
b3AuMCsweGMyLzB4ZDAgbW0va2FzYW4vY29tbW9uLmM6NDk0CiBrbWVtX2NhY2hlX2FsbG9jX3Ry
YWNlKzB4MTRmLzB4MmQwIG1tL3NsYWIuYzozNTUxCiBrbWFsbG9jIGluY2x1ZGUvbGludXgvc2xh
Yi5oOjU1NSBbaW5saW5lXQoga3phbGxvYyBpbmNsdWRlL2xpbnV4L3NsYWIuaDo2NjkgW2lubGlu
ZV0KIHRpcGNfYmNhc3RfaW5pdCsweDIxZS8weDdiMCBuZXQvdGlwYy9iY2FzdC5jOjY4OQogdGlw
Y19pbml0X25ldCsweDRmNi8weDVjMCBuZXQvdGlwYy9jb3JlLmM6ODUKIG9wc19pbml0KzB4YWYv
MHg0NzAgbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jOjE1MQogc2V0dXBfbmV0KzB4MmQ4LzB4ODUw
IG5ldC9jb3JlL25ldF9uYW1lc3BhY2UuYzozNDEKIGNvcHlfbmV0X25zKzB4MmNmLzB4NWUwIG5l
dC9jb3JlL25ldF9uYW1lc3BhY2UuYzo0ODIKIGNyZWF0ZV9uZXdfbmFtZXNwYWNlcysweDNmNi8w
eGIxMCBrZXJuZWwvbnNwcm94eS5jOjExMAogdW5zaGFyZV9uc3Byb3h5X25hbWVzcGFjZXMrMHhi
ZC8weDFmMCBrZXJuZWwvbnNwcm94eS5jOjIzMQoga3N5c191bnNoYXJlKzB4MzZjLzB4OWEwIGtl
cm5lbC9mb3JrLmM6Mjk3OQogX19kb19zeXNfdW5zaGFyZSBrZXJuZWwvZm9yay5jOjMwNDcgW2lu
bGluZV0KIF9fc2Vfc3lzX3Vuc2hhcmUga2VybmVsL2ZvcmsuYzozMDQ1IFtpbmxpbmVdCiBfX3g2
NF9zeXNfdW5zaGFyZSsweDJkLzB4NDAga2VybmVsL2ZvcmsuYzozMDQ1CiBkb19zeXNjYWxsXzY0
KzB4NjAvMHhlMCBhcmNoL3g4Ni9lbnRyeS9jb21tb24uYzozODQKIGVudHJ5X1NZU0NBTExfNjRf
YWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKCkZyZWVkIGJ5IHRhc2sgODg0MzoKIHNhdmVfc3RhY2sr
MHgxYi8weDQwIG1tL2thc2FuL2NvbW1vbi5jOjQ4CiBzZXRfdHJhY2sgbW0va2FzYW4vY29tbW9u
LmM6NTYgW2lubGluZV0KIGthc2FuX3NldF9mcmVlX2luZm8gbW0va2FzYW4vY29tbW9uLmM6MzE2
IFtpbmxpbmVdCiBfX2thc2FuX3NsYWJfZnJlZSsweGY1LzB4MTQwIG1tL2thc2FuL2NvbW1vbi5j
OjQ1NQogX19jYWNoZV9mcmVlIG1tL3NsYWIuYzozNDI2IFtpbmxpbmVdCiBrZnJlZSsweDEwMy8w
eDJjMCBtbS9zbGFiLmM6Mzc1NwogdGlwY19iY2FzdF9zdG9wKzB4MWIwLzB4MmYwIG5ldC90aXBj
L2JjYXN0LmM6NzIxCiB0aXBjX2V4aXRfbmV0KzB4MjQvMHgyNzAgbmV0L3RpcGMvY29yZS5jOjEx
Mgogb3BzX2V4aXRfbGlzdCsweGIwLzB4MTYwIG5ldC9jb3JlL25ldF9uYW1lc3BhY2UuYzoxODYK
IGNsZWFudXBfbmV0KzB4NGVhLzB4YTAwIG5ldC9jb3JlL25ldF9uYW1lc3BhY2UuYzo2MDMKIHBy
b2Nlc3Nfb25lX3dvcmsrMHg5NGMvMHgxNjcwIGtlcm5lbC93b3JrcXVldWUuYzoyMjY5CiB3b3Jr
ZXJfdGhyZWFkKzB4NjRjLzB4MTEyMCBrZXJuZWwvd29ya3F1ZXVlLmM6MjQxNQoga3RocmVhZCsw
eDNiNS8weDRhMCBrZXJuZWwva3RocmVhZC5jOjI5MQogcmV0X2Zyb21fZm9yaysweDFmLzB4MzAg
YXJjaC94ODYvZW50cnkvZW50cnlfNjQuUzoyOTMKClRoZSBidWdneSBhZGRyZXNzIGJlbG9uZ3Mg
dG8gdGhlIG9iamVjdCBhdCBmZmZmODg4MDVlNmIzNTAwCiB3aGljaCBiZWxvbmdzIHRvIHRoZSBj
YWNoZSBrbWFsbG9jLTEyOCBvZiBzaXplIDEyOApUaGUgYnVnZ3kgYWRkcmVzcyBpcyBsb2NhdGVk
IDExMyBieXRlcyBpbnNpZGUgb2YKIDEyOC1ieXRlIHJlZ2lvbiBbZmZmZjg4ODA1ZTZiMzUwMCwg
ZmZmZjg4ODA1ZTZiMzU4MCkKVGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgcGFnZToK
cGFnZTpmZmZmZWEwMDAxNzlhY2MwIHJlZmNvdW50OjEgbWFwY291bnQ6MCBtYXBwaW5nOjAwMDAw
MDAwMDAwMDAwMDAKaW5kZXg6MHgwCmZsYWdzOiAweGZmZmUwMDAwMDAwMjAwKHNsYWIpCnJhdzog
MDBmZmZlMDAwMDAwMDIwMCBmZmZmZWEwMDAyMzc1YzQ4IGZmZmY4ODgwYWEwMDE1NTAgZmZmZjg4
ODBhYTAwMDcwMApyYXc6IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4ODA1ZTZiMzAwMCAwMDAwMDAw
MTAwMDAwMDEwIDAwMDAwMDAwMDAwMDAwMDAKcGFnZSBkdW1wZWQgYmVjYXVzZToga2FzYW46IGJh
ZCBhY2Nlc3MgZGV0ZWN0ZWQKCk1lbW9yeSBzdGF0ZSBhcm91bmQgdGhlIGJ1Z2d5IGFkZHJlc3M6
CiBmZmZmODg4MDVlNmIzNDAwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMAogZmZmZjg4ODA1ZTZiMzQ4MDogZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMg
ZmMgZmMgZmMgZmMgZmMgZmMgZmMKPiBmZmZmODg4MDVlNmIzNTAwOiBmYiBmYiBmYiBmYiBmYiBm
YiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYgogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXgogZmZmZjg4ODA1ZTZiMzU4MDog
ZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMKIGZmZmY4ODgw
NWU2YjM2MDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIGZjIGZjIGZj
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQoKQ29tbWl0IGFkYmE3NWJlMGQyMyAoInRpcGM6IGZpeCBsb2NrZGVwIHdhcm5p
bmcgd2hlbiByZWluaXRpbGFpemluZwpzb2NrZXRzIikgaW50cm9kdWNlZCBhbiBhc3luY2hyb25v
dXMgbWV0aG9kIHRvIGZpbmFsaXplIFRJUEMgbmV0IGluCndvcmsgY29udGV4dCwgaG93ZXZlciwg
aXQgY2F1c2VkIGEgcmFjZSBjb25kaXRpb246IGV2ZW4gYWZ0ZXIKInRuLT5iY2Jhc2UiIGluc3Rh
bmNlIGhhcyBiZWVuIHJlbGVhc2VkIGluIHRpcGNfYmNhc3Rfc3RvcCgpIHdoZW4KdGlwYyBuYW1l
c3BhY2UgaXMgZGVzdHJveWVkIHRocm91Z2ggdGlwY19leGl0X25ldCgpLCB0aGUgaW5zdGFuY2UK
bWF5IGJlIGFjY2Vzc2VkIGluIHRpcGNfYmNhc3RfZ2V0X21vZGUoKSBiZWNhdXNlIHRpcGNfYmNh
c3RfZ2V0X21vZGUoKQppcyBhc3luY2hyb25vdXNseSBjYWxsZWQgYnkgdGlwY19uZXRfZmluYWxp
emVfd29yaygpIGluIHdvcmsgY29udGV4dC4KCkluIG9yZGVyIHRvIGVsaW1pbmF0ZSB0aGUgcmFj
ZSBjb25kaXRpb24sIHdlIGVuc3VyZSB0aGUgZmluYWxpemluZyB0aXBjCm5ldCB3b3JrIG11c3Qg
YmUgY29tcGxldGVkIGJ5IGNhbGxpbmcgY2FuY2VsX3dvcmtfc3luYygpIGJlZm9yZQp0aXBjX2Jj
YXN0X3N0b3AoKS4KClJlcG9ydGVkLWJ5OiBzeXpib3QrNmVhMWY3YThkZjY0NTk2ZWY0ZDdAc3l6
a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQpGaXhlczogYWRiYTc1YmUwZDIzICgidGlwYzogZml4IGxv
Y2tkZXAgd2FybmluZyB3aGVuIHJlaW5pdGlsYWl6aW5nIHNvY2tldHMiKQpTaWduZWQtb2ZmLWJ5
OiBZaW5nIFh1ZSA8eWluZy54dWVAd2luZHJpdmVyLmNvbT4KLS0tCiBuZXQvdGlwYy9jb3JlLmgg
fCAzICsrKwogbmV0L3RpcGMvbmV0LmMgIHwgMyArKysKIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvbmV0L3RpcGMvY29yZS5oIGIvbmV0L3RpcGMvY29yZS5o
CmluZGV4IDYzMWQ4M2M5NzA1Zi4uNjRmMDIwN2QyOTQzIDEwMDY0NAotLS0gYS9uZXQvdGlwYy9j
b3JlLmgKKysrIGIvbmV0L3RpcGMvY29yZS5oCkBAIC0xMzksNiArMTM5LDkgQEAgc3RydWN0IHRp
cGNfbmV0IHsKIAkvKiBUcmFjaW5nIG9mIG5vZGUgaW50ZXJuYWwgbWVzc2FnZXMgKi8KIAlzdHJ1
Y3QgcGFja2V0X3R5cGUgbG9vcGJhY2tfcHQ7CiAKKwkvKiBGaW5hbGl6ZSBuZXQgd29ya2VyICov
CisJc3RydWN0IHdvcmtfc3RydWN0ICpmd29yazsKKwogI2lmZGVmIENPTkZJR19USVBDX0NSWVBU
TwogCS8qIFRYIGNyeXB0byBoYW5kbGVyICovCiAJc3RydWN0IHRpcGNfY3J5cHRvICpjcnlwdG9f
dHg7CmRpZmYgLS1naXQgYS9uZXQvdGlwYy9uZXQuYyBiL25ldC90aXBjL25ldC5jCmluZGV4IDg1
NDAwZTQyNDJkZS4uOTI1NDc0ZjYyNWUwIDEwMDY0NAotLS0gYS9uZXQvdGlwYy9uZXQuYworKysg
Yi9uZXQvdGlwYy9uZXQuYwpAQCAtMTYwLDYgKzE2MCw3IEBAIHZvaWQgdGlwY19zY2hlZF9uZXRf
ZmluYWxpemUoc3RydWN0IG5ldCAqbmV0LCB1MzIgYWRkcikKIAlJTklUX1dPUksoJmZ3b3JrLT53
b3JrLCB0aXBjX25ldF9maW5hbGl6ZV93b3JrKTsKIAlmd29yay0+bmV0ID0gbmV0OwogCWZ3b3Jr
LT5hZGRyID0gYWRkcjsKKwluZXQtPmZ3b3JrID0gJmZ3b3JrLT53b3JrOwogCXNjaGVkdWxlX3dv
cmsoJmZ3b3JrLT53b3JrKTsKIH0KIApAQCAtMTczLDYgKzE3NCw4IEBAIHZvaWQgdGlwY19uZXRf
c3RvcChzdHJ1Y3QgbmV0ICpuZXQpCiAJdGlwY19ub2RlX3N0b3AobmV0KTsKIAlydG5sX3VubG9j
aygpOwogCisJY2FuY2VsX3dvcmtfc3luYyhuZXQtPmZ3b3JrKTsKKwogCXByX2luZm8oIkxlZnQg
bmV0d29yayBtb2RlXG4iKTsKIH0KIAotLSAKMi4yNi4xCgo=

--_002_DM6PR11MB26034EB2DC2D5ED3A124D35A84280DM6PR11MB2603namp_--
