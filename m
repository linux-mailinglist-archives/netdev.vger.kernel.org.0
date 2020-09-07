Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B852925F4F1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgIGIWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:22:24 -0400
Received: from mail-vi1eur05on2099.outbound.protection.outlook.com ([40.107.21.99]:26400
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbgIGIWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 04:22:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGIzRLD1ZfCM/kS3id+L/VH1HvV4yxPlDKBgw7ESPI64EAs7JYog8EiRAhjqK3f7712xxw89U7hJ0JC/nN9MWcGn6ag7kCUb5AOpSqzfv9VmfOnNq9QbTt74XwJOMIgnQ6HQrCCPLEZip3/52Se73cMaQskl1qFh5X6qypxBvUhohPZ5sGDUS+2NuFrBVAVgWKFQrE2curm2lFAqv17R+BNAD0KwyeTFDDhxCLNI0iZeGmtgCr796D/UIRRMotM0v6sNXTS9IMmyN0ol7A0NwqPLltPhd8wVdrmSkPdAuX6HRgv/picp7h5J8MDB/KY7Os/z3ZbwyyStnzFPxAG8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEZVnYjlmZVy4ySpCumI0EsLnTRx38na9WL5sSVBJq0=;
 b=Ojj1WBYTw9cds38x285ganSkLCZRlkBgTtzKho9hE/WXJ8IbNk3lBDOlOrXDMAkpCenxY1JW3guJXT6gqA/EfOX6TNQZMjqr0h7jPIi8bScoX0PAT/QnoV73OebldbLqzJEEYDxa/8noMyBtvlqJPd6Ir2ziAlyPxhPWJaTsfrTOSW9Qy0+kHTzJwsfhMxWJ8Zghh2dYBpkUCzOcxMH47J0wfYmrdksMuD5+iXj+Pzc6yvsRdcb/FXjSMsrbkvn6U7LAQoquQfn+ZxDZj4jZOr/bCHuZEjqk6SEVAGQi2PyJ480IE2U+Uwvc8Trl/yPfRJXMpyDeg6AhgCI0Q8VtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEZVnYjlmZVy4ySpCumI0EsLnTRx38na9WL5sSVBJq0=;
 b=focfFPTwk/AWSPNBDsZp0INC4PqikOmujSiNQnYKtkwjG/3FtYkx162lOY2HjOdarXdo5a/RM8M9R7i24Z2GpGwmiupSraf2kXbNgx0E/9FE9L1CvFpKu2ctDmjHWRpwG0+LxfV1V4vScwWI03UU6hVH+hzBwf+rGoWVMNRjNYM=
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VE1PR05MB7247.eurprd05.prod.outlook.com (2603:10a6:800:1ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:22:14 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58%7]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 08:22:14 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com" 
        <syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com>
Subject: RE: [net-next] tipc: fix a deadlock when flushing scheduled work
Thread-Topic: [net-next] tipc: fix a deadlock when flushing scheduled work
Thread-Index: AQHWgz9oRsKA4NIcaEOUMsICoFtZsqlb57kAgADxZiA=
Date:   Mon, 7 Sep 2020 08:22:14 +0000
Message-ID: <VI1PR05MB46059906049E2ECEE1D2D0BCF1280@VI1PR05MB4605.eurprd05.prod.outlook.com>
References: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
 <20200906105656.0e997c96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906105656.0e997c96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [123.20.195.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80ddd045-9f0e-4dee-599a-08d853072040
x-ms-traffictypediagnostic: VE1PR05MB7247:
x-microsoft-antispam-prvs: <VE1PR05MB724754DD9EC2FB5A3A2F2355F1280@VE1PR05MB7247.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5hd2uzznfO9x1JIa+ZdRDpg1usf3892PziuTeRKjfagknGV4EEkzkMxCL+jAUBII12jEh+ZGFOgq3K/0qEumkQTpeCJlk1wlSYUulU+2fHnIjzm4GZX7aSyOd98i8WNL3EFQrDSCMWei0Q66IeVyqSEV609Wkthfq07njWh4dMUFxy2nBeT0BM4QJmJsPUuQXWodcLyf5b9HHz2xqEmqFCxhoiMzfaQL3605VBK1KspQr+PX06XdlyXxW7KqDdEM+7+GV4bvD87U6a1m+S15SKYTxK3OYKliUDGhe+KkxLDiFfIhIhYHoCOVDfNDD/Xco/U8W73bCzBToFW6xkaJiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(39840400004)(366004)(6506007)(6916009)(4326008)(86362001)(8676002)(316002)(478600001)(8936002)(2906002)(54906003)(7696005)(55016002)(9686003)(186003)(5660300002)(52536014)(53546011)(55236004)(64756008)(66556008)(66476007)(66946007)(83380400001)(71200400001)(33656002)(66446008)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IIvfqZZoApOHJ+DlDUi6/KVc3gusY982B+vJOhAh13dHJIgB2rNxxpZRMdF0phlFKaDn5fZQQVvmYqMhlmSeGNaI1qba9MVgs8Pq2qJqjJo7e2b3s8XHn88VJNT7VWvnIANk3FP8tmGwq5tchpfBsxL0ITXksyYlA0yzmj96YoskdK7JnPtMZQKz7vPf/s2BSc7/fPdxB4x75dRRxG1pLh2NclQzxGMZWCQLrK3RS2VKGLRvuqq7yV1FSEs/nlnK9J2PiXda8N2ZEIaugYsQ4oTt8DP5k6XUHVz+OMs3B0II2KzNrM59QOJqDXDaGxaVcu2erYAMoWOxna5bkFiB0AGO8DPfbjEQPY8N5FECZKtKb+nvIgvAR5DeCcI3ny25IGaiLDRc36UgxyyP6swQ9nCoUcs7wnEBvuZbMDeTmu84USCacghhhaZDGfWOiZ0mlikelye47+RKLUEq77QNhjXpGJofkFsQugjmnlsDHZ0SF4OwX5tWwOFlo9NEhWE2Nasrsg9hl6xLUl3jU2O3ExorzesZjDDhTV/81NvCGR6oGvDA0WrUHt3P5p6CHtTMS+mPq1yMvxgkcR7o8fft4ckfSAxXOwQI/lX+JOfA0GIQARL8VVZfYPhJpmGj+Wmm0KC/+OUwqoGsWy18yM4q+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ddd045-9f0e-4dee-599a-08d853072040
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 08:22:14.2480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RmPWc1bJavoyNApVhxyGkhmp3gyLwFsLH6k/OCqcJzEGu59dYa2W/My2/N87ZEkXjGhj611AdYCCLj27Xs4rnaE9JrzUykvBN++3YqLcjkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, September 7, 2020 12:57 AM
> To: Hoang Huu Le <hoang.h.le@dektech.com.au>
> Cc: ying.xue@windriver.com; netdev@vger.kernel.org; jmaloy@redhat.com; ma=
loy@donjonn.com;
> syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
> Subject: Re: [net-next] tipc: fix a deadlock when flushing scheduled work
>=20
> On Sat,  5 Sep 2020 11:45:18 +0700 Hoang Huu Le wrote:
> > In the commit fdeba99b1e58
> > ("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
> > to make sure the tipc_net_finalize_work work item finished if it
> > enqueued. But calling flush_scheduled_work() is not just affecting
> > above work item but either any scheduled work. This has turned out
> > to be overkill and caused to deadlock as syzbot reported:
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: possible circular locking dependency detected
> > 5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
> > ------------------------------------------------------
> > kworker/u4:6/349 is trying to acquire lock:
> > ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workque=
ue+0xe1/0x13e0 kernel/workqueue.c:2777
> >
> > but task is already holding lock:
> > ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0=
xb10 net/core/net_namespace.c:565
> >
> > [...]
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(pernet_ops_rwsem);
> >                                lock(&sb->s_type->i_mutex_key#13);
> >                                lock(pernet_ops_rwsem);
> >   lock((wq_completion)events);
> >
> >  *** DEADLOCK ***
> > [...]
> >
> > To fix the original issue, we replace above calling by introducing
> > a bit flag. When a namespace cleaned-up, bit flag is set to zero and:
> > - tipc_net_finalize functionial just does return immediately.
> > - tipc_net_finalize_work does not enqueue into the scheduled work queue=
.
>=20
> Is struct tipc_net not going to be freed right after tipc_exit_net()
> returns? In that case you'd be back to UAF if the flag is in this
> structure.
>=20
I rework the fix with version 2. In there, I use cancel_work_sync() API to
cancel the specific tipc_net_finalize_work work.
> > @@ -110,10 +111,6 @@ static void __net_exit tipc_exit_net(struct net *n=
et)
> >  	tipc_detach_loopback(net);
> >  	tipc_net_stop(net);
> >
> > -	/* Make sure the tipc_net_finalize_work stopped
> > -	 * before releasing the resources.
> > -	 */
> > -	flush_scheduled_work();
> >  	tipc_bcast_stop(net);
> >  	tipc_nametbl_stop(net);
> >  	tipc_sk_rht_destroy(net);
> > @@ -124,6 +121,9 @@ static void __net_exit tipc_exit_net(struct net *ne=
t)
> >
> >  static void __net_exit tipc_pernet_pre_exit(struct net *net)
> >  {
> > +	struct tipc_net *tn =3D tipc_net(net);
> > +
> > +	clear_bit_unlock(0, &tn->net_exit_flag);
> >  	tipc_node_pre_cleanup_net(net);
> >  }
> >
> > diff --git a/net/tipc/core.h b/net/tipc/core.h
> > index 631d83c9705f..aa75882dd932 100644
> > --- a/net/tipc/core.h
> > +++ b/net/tipc/core.h
> > @@ -143,6 +143,7 @@ struct tipc_net {
> >  	/* TX crypto handler */
> >  	struct tipc_crypto *crypto_tx;
> >  #endif
> > +	unsigned long net_exit_flag;
> >  };
> >
> >  static inline struct tipc_net *tipc_net(struct net *net)
> > diff --git a/net/tipc/net.c b/net/tipc/net.c
> > index 85400e4242de..8ad5b9ad89c0 100644
> > --- a/net/tipc/net.c
> > +++ b/net/tipc/net.c
> > @@ -132,6 +132,9 @@ static void tipc_net_finalize(struct net *net, u32 =
addr)
> >  {
> >  	struct tipc_net *tn =3D tipc_net(net);
> >
> > +	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
> > +		return;
> > +
> >  	if (cmpxchg(&tn->node_addr, 0, addr))
> >  		return;
> >  	tipc_set_node_addr(net, addr);
> > @@ -153,8 +156,13 @@ static void tipc_net_finalize_work(struct work_str=
uct *work)
> >
> >  void tipc_sched_net_finalize(struct net *net, u32 addr)
> >  {
> > -	struct tipc_net_work *fwork =3D kzalloc(sizeof(*fwork), GFP_ATOMIC);
> > +	struct tipc_net *tn =3D tipc_net(net);
> > +	struct tipc_net_work *fwork;
> > +
> > +	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
> > +		return;
> >
> > +	fwork =3D kzalloc(sizeof(*fwork), GFP_ATOMIC);
> >  	if (!fwork)
> >  		return;
> >  	INIT_WORK(&fwork->work, tipc_net_finalize_work);

