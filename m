Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94F691DC4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbfHSH0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:26:14 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:8967
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbfHSH0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 03:26:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eav+ted1V/Rg2C9X3ZT2Bx44G9ENNWJSnEPgWuHo+YT8qQWicFpfTR5Sv9TUEBX/yjBaL9rZn5O/kQg2XvXf4cgIzPy69dy3Sf8ccnVWjFAR9hy80LdCfn4sW1ZcUQX7gLgfi6wWyRv1H1SMcyKfE5PNo0JzAsAYzATMSUquEK4Y41WOZ00beMt972pPV6Xf9qu9x57mgEcnj40U4ZZNeyEvP+FPkO2iSlZHE2MeKtQjxu/BBZFfkGYj3dpAzDvqoQ8cKHwbDgVx3ijlkhXYIpeye2a/Ehbrh7tReh8GPBmFCcPG1pYnd0tju6MdYwuPvp/lONSQitbmRYxm8RFxMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTyH273LxHaNXbGiYrBtrifweDZ35AcglXf6xcuJqHY=;
 b=iY3QEMDXKS/LQu9NKO4XXuvR3zqfxMgidmEEZPnitgOX2qdIA547NKxZ/F9G0yWqkOn6/ad+oAqq+e/DGeje2WP8UtioJIn3pqXgqpHmGAx/f9V8s9HCh6D31MdEG7caLY/dylI/FK424nlFIi1qZ4pzh35Le83pRvn7OS0jOTm27uz2BvkISqV5ZqVTpYay7dWT5oPMGaN/85s28YJGb8W3ezKH2MSu6SrF59yQCiYlUDt58OpgaXLyZqZWRjlzt9emEQXmij79EXmFij4I36TEljUal3+3vOfv8aWojiVHxGt9Vuc/fkLNH27x5HTbKjpLdAlbYAY4OTcMoKaz8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTyH273LxHaNXbGiYrBtrifweDZ35AcglXf6xcuJqHY=;
 b=ibM8V5Ax6LCbzydppapwh5QgdXvDaePXvZJxam0j2q0GXwAc5WJzRkuuApF6RZKb4ZUF+IX2AuRDeAtZp2Mfp8XZrDfGilB3RPJw1bCeGahkOo3LLwrLQfs0g8h7HlnF8YnPSsqzPut/dXyU3z9SEzF5uhRurLq7/mTkq/2U2S8=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4768.eurprd05.prod.outlook.com (20.176.4.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 07:26:07 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 07:26:07 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, wenxu <wenxu@ucloud.cn>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get multi-subsystem
 block
Thread-Topic: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Thread-Index: AQHVTL1pG2KieeISTEa5YG2C2+XO7qb3lk2AgAJmXYCAA/G0gIAAMACAgAQG3YA=
Date:   Mon, 19 Aug 2019 07:26:07 +0000
Message-ID: <vbftvady5tg.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
 <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
 <vbfimr2o4ly.fsf@mellanox.com>
 <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
 <vbfpnl55eyg.fsf@mellanox.com> <20190816105627.57c1c2aa@cakuba.netronome.com>
In-Reply-To: <20190816105627.57c1c2aa@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::14) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb819aea-1ff3-44eb-50e2-08d724768031
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4768;
x-ms-traffictypediagnostic: VI1PR05MB4768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4768977D20DD54831D4DA9D8ADA80@VI1PR05MB4768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(199004)(189003)(256004)(14444005)(386003)(102836004)(6506007)(26005)(66476007)(66556008)(64756008)(186003)(8676002)(229853002)(66446008)(66946007)(81166006)(81156014)(8936002)(53936002)(476003)(2616005)(11346002)(446003)(6512007)(6246003)(486006)(6916009)(4326008)(25786009)(6436002)(14454004)(6486002)(478600001)(7736002)(305945005)(99286004)(86362001)(71200400001)(71190400001)(52116002)(76176011)(316002)(54906003)(2906002)(6116002)(36756003)(5660300002)(3846002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4768;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T88tX0i1ULQkCH95CS1LkHFfjApNFzoYazyhEYCmig0G+8N0T1vE4v0JY42rtz4BKkcfcSGicPbRe2A6+pl+YQC2fQNnV2U2PlT03K3SXcRn2DVkxLETffJZfZVF+UxuzJ4Y7CXb3Ki8g/uTx6rE5tYORqT2zYNPPtsapCiovyetMYhvLtpc+G+E1izrPxscjzymi2qg/kE7iQjtnBaGFkZcITAmCOBi76CtwdmEreWfbF8ifXeebQ3m36Fc7zeGYPn+udMDsg6+5IbNmuLhI/tJwTjG2J8/07J3yNgXQpvEGnW0Z8xvKxS3yVccWrxOAlWoqppvF6aH7oTwZFo505E5+bhrLLQtED0dvrjxZi5HPWKyuBpS/0w+pHkObDTTqs4aFE+NtC2NAdYeWB81NX6BGr5REx1W0bPG3jvx69s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb819aea-1ff3-44eb-50e2-08d724768031
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 07:26:07.3210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xnSbgpHvNeaR4lsS9Q8ASufFWI4KJeycpi5hKXdQSDH4oa5oPFZXx48f0fILOMxcLkcuu3zGyTA7ubhR7WgXKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 16 Aug 2019 at 20:56, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Fri, 16 Aug 2019 15:04:44 +0000, Vlad Buslov wrote:
>> >> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000001
>> >> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007=
fad892d30f8
>> >> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 00000=
00000000001
>> >> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 00000=
0000000000a
>> >> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 00000=
00000000002
>> >> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007=
fad893a3740
>> >>
>> >> I don't think it is correct approach to try to call these callbacks w=
ith
>> >> rcu protection because:
>> >>
>> >> - Cls API uses sleeping locks that cannot be used in rcu read section
>> >>   (hence the included trace).
>> >>
>> >> - It assumes that all implementation of classifier ops reoffload() do=
n't
>> >>   sleep.
>> >>
>> >> - And that all driver offload callbacks (both block and classifier
>> >>   setup) don't sleep, which is not the case.
>> >>
>> >> I don't see any straightforward way to fix this, besides using some
>> >> other locking mechanism to protect block_ing_cb_list.
>> >>
>> >> Regards,
>> >> Vlad
>> >
>> > Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add,=
 delete?
>> >
>> > the callbacks_lists. the add and delete is work only on modules init c=
ase. So the
>> >
>> > lookup is also not frequently(ony [un]register) and can protect with t=
he locks.
>>
>> That should do the job. I'll send the patch.
>
> Hi Vlad!
>
> While looking into this, would you mind also add the missing
> flow_block_cb_is_busy() calls in the indirect handlers in the drivers?
>
> LMK if you're too busy, I don't want this to get forgotten :)

Hi Jakub,

I've checked the code and it looks like only nfp driver is affected:

- I added check in nfp to lookup cb_priv with
  nfp_flower_indr_block_cb_priv_lookup() and call
  flow_block_cb_is_busy() if cb_priv exists.

- In mlx5 en_rep.c there is already a check that indr_priv exists, so
  trying to lookup block_cb->cb_indent=3D=3Dindr_priv is redundant.

- Switch drivers (mlxsw and ocelot) take reference to block_cb on
  FLOW_BLOCK_BIND, so they should not require any modifications.

Tell me if I missed anything. Sending the patch for nfp.

Regards,
Vlad
