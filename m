Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A514B58C515
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 10:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiHHIx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 04:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbiHHIxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 04:53:55 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D317ACE12;
        Mon,  8 Aug 2022 01:53:54 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 277MocXE032718;
        Mon, 8 Aug 2022 01:53:35 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hsnnqnkwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 01:53:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZQy7MZjKPsfa0nJ1ET930S2zetkOn0SUH6/XQGbOSir9B7HnXzwQcYH56pZT/7mFEIqgvxEySvusgPmICGYMrk5fsmmYioSBX4dFB3OvGBh78lClQalOMoFQs4q51vO2zYHkaKsirxH1zyXwU6LLnVZIO2NRUpmNt7HpA4Gam0Avsjq/YmUDeTjk2ganDeegfUFkTSPDK/leDdzDr4dK0WTTbwU7L041PBMkXTBFcHMwUtn7JhA6W6sRJxZ3lkOBvJPjUm6NWbJZonEH6FRm1ttdA6az7V3U071IYWSuidNOWWcuIzjTzFqq0G4jOQuPphLkADulkHaJHU8v5DsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LuD9xrJb5Y/NEkInxekztsgl3meBZETTxQkSpi0C8pE=;
 b=FHkc75EDZJO4aWijkOoGa9RhZHSxfEzcpzCJx/+ZNsmjP36ZhBmfCu4k/vVqtLiXPwS52J6zsAIMlaHDSJkUjXyArrp0oqSaUL+fuEG6Gdh4tg41Uig/mY43tI0J55eLw4R50U0n5qA7rSPc0M0ol7YZCwGwThR3VHW36VxgdmhifuhErQGYztn9AbRPQM61cTXsg7gBnxSOy/sq9fwVpkkCJZSkvecjw/yaL3KpyaBKA5G2ftfrV+tInOui6KCYOXqM3C0PK/TnABcjS8PpvWLNmjK2+1q9YnKPzjyCMZqnSV1zAJ3jKftPKy4U18Wk6F34AnaH71Da13jX1MyxVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuD9xrJb5Y/NEkInxekztsgl3meBZETTxQkSpi0C8pE=;
 b=Er0nSyv+gW2EzEOq7i9Mt88hqzYFeM1JaQm7g6pF2M+tlnN6Me1mmPDRo9IkllNS2WU4zT+XJPoC+EXikFFeYoLHbUgTxU0OLQGGmWj0ruKpGZPJswT3k06MO/TxAimYvwB+4CgJmsZxUYwadGJiuzaNMxoY+EbfUmc7rtODLKM=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:3::17)
 by DM5PR18MB2279.namprd18.prod.outlook.com (2603:10b6:4:b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Mon, 8 Aug
 2022 08:53:32 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::f1ea:59d1:475:f8f2]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::f1ea:59d1:475:f8f2%4]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 08:53:32 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     AceLan Kao <acelan.kao@canonical.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitrii Tarakanov <Dmitrii.Tarakanov@aquantia.com>,
        Alexander Loktionov <Alexander.Loktionov@aquantia.com>,
        David VomLehn <vomlehn@texas.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v3] net: atlantic: fix aq_vec index out of range
 error
Thread-Topic: [EXT] [PATCH v3] net: atlantic: fix aq_vec index out of range
 error
Thread-Index: AQHYqv9/2hlN0hS2xka3N3KMHXPfRa2krUBQ
Date:   Mon, 8 Aug 2022 08:53:31 +0000
Message-ID: <PH0PR18MB40391BF3480001525D82D1C5D3639@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <20220808081845.42005-1-acelan.kao@canonical.com>
In-Reply-To: <20220808081845.42005-1-acelan.kao@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 197dbfd8-e952-4124-1612-08da791b788a
x-ms-traffictypediagnostic: DM5PR18MB2279:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aowlfxk5TcOtCBKDlrAC1/g0Q2Ab3/xNOa5D/i5BYvcTn/nHAymOlb3hJnCgodPwbwA12530zNpt+YZAzjQqAdrilEBHQj55OhkKp3SvJWjR4+EMMbzHE59XD0TW3Oik5su2HGH6N+Ii9VvTMKq+U8lvT+3RgZLfHbro7RzrGHI1/F/tfwpsHmetWskXIqYPxNVqLY1a6NgK8Mce5NVnNYUL/hoT9rdDY/DJtXJzDhdESJwg1pLRDaDL4KDMIEKaCyhnaf27KLJSbYuHRqXmRpCeayUJ7hLuwnUZuxHtjSvd9I5PFqVO72nOQu5L1DG07dJdROcL7G/6xfboqmf7nl4Qajmowy0ab7s5neH8i9i70Va2vYGe8NoryMIE2uenFjU9rPze4WJtzHxFgSlweEkfaKGvbh8P7bJ+I+DlkB2mZhUskbp5Z8flt9z7FlGgodODvYCM9aWBaqGJHnYmnF+KbfEiM2atfJSWG7jV/TiU34qqTC4CsQOUipdyz+W5zcvnk8yv29mAjDfAG97l64f9YAO0FoU2AriQM1uWkqQrIGqBHHdOe45VrPFg3CwalHTfBj4kCX8ZbROrzKqMxdSVHdSXcEpH8pHIJzKWCN5Z83+7CQJBravRUHeR2YsErPFmpFLZNTijiR5nCfo8l1cFez+Yqokkk6e2I4dawa9PECOhO8Z5jZoaXvw9Fu+7XKw0fmjJQyHmCGvc46nFluiVYG655xAPfiQj45RZiC3LdkVqUZNo9Z1ZqiE/IJWmFWRYThmsKkTl4WiOo5hej757G9zdwIN8fBzr+SEm4l92O+oY7fo31+NOpRokRyPtk9Vy+oYUL6W62waHqPP3Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(2906002)(921005)(38070700005)(9686003)(53546011)(26005)(41300700001)(7696005)(6506007)(83380400001)(55016003)(38100700002)(122000001)(186003)(33656002)(478600001)(52536014)(71200400001)(66556008)(8676002)(64756008)(66446008)(66476007)(76116006)(8936002)(66946007)(110136005)(86362001)(316002)(5660300002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?roYGTnwjHu1z+AKGyAA6YzqNi4F6fSaTBaUDI+qMwkXsoMCEYnrDTPfxW/AW?=
 =?us-ascii?Q?B42f9Eoq+tTZYeXy/e267uJ4rJs9VqqwrJeWHDXBchDdCQEHs5MOIW0VqtnV?=
 =?us-ascii?Q?Wl295Odp/zIiFTP7IMaIkwqED+nMjp7ZAvuGpW1mZW/jizsy/h+7CLH99+Fa?=
 =?us-ascii?Q?fqkArOVRjea5RnRwD1GloVJ/i+vrw8arQ65K6lHez6+NipiG4EG3M12D/J5U?=
 =?us-ascii?Q?b0kxngO7iaGO4ncWmrfGuJsfnN8wsuTfwVShY/4B48E3hjF5ghY1TT+GOJHf?=
 =?us-ascii?Q?OCWl+5FCfCn1qyNsD/SLlKZhOJYUcn25++2l+mpcrtUi1lfqeN053rR6vHdQ?=
 =?us-ascii?Q?uxw/AMBmngV4yvPC4ipu2QWzvztaFg1TQBQbPPVXor9rO4bxfTem7p/EjIyn?=
 =?us-ascii?Q?6SeCW+KkcSkRDHnFWO/sM+SnW3kyU8RQpfe92y9OKycYLAZU67Xyup2kkoT6?=
 =?us-ascii?Q?1CC9FgF87HVQl0gGH8K45tBgzSvtk0vAvgaKOm8G7jb0wUFpwtvdWMgplUKb?=
 =?us-ascii?Q?UrSr0NI9IKEDatIknCJFHRC/znHkpMEwI76d9ormPmGKPq0bbMyDxVFRN8bO?=
 =?us-ascii?Q?OseYg5FyvIsVUV5VDq4ZwpIM5BfA54MNbaa1xZP9uzGggCKXel02WWeItxHh?=
 =?us-ascii?Q?RS4eZzhDQQvZozHg6zCWZoQfeEG1hyK3SL9MjLI+4+437xIsKlEVouThawBw?=
 =?us-ascii?Q?oZumdJZwwiFxDYmU0ghrxH1RePKPwMXFPjmkOe7tpTU0omyfOtYk1Jne8kFb?=
 =?us-ascii?Q?F9NHxLJhZWl5sUoPR7h9R4prAz5FZ5+V6mT7kr1z/5CD5/bU96ExCeCb45Ln?=
 =?us-ascii?Q?daysQPl3eIxjrKTtNNMMj5vydaf3nku3RMIi+G0Ksp+lDIFhsy94ZUFjtBwZ?=
 =?us-ascii?Q?jiXvh1ZkrXkh/pwOdD1TBnRU3Zm0zwJ3HADopXiIwTZtarr5mBthP24Gf0b6?=
 =?us-ascii?Q?tzyax4U8V5wqj3yhPo/wi4figJFoiZxxjxQQZX2mKdesdwxX7620ct9Y7PX7?=
 =?us-ascii?Q?17CFMD8i3gwMnuhj4S6ibwTTJVJdVwwXZ+c/uqFvublD4pVXk2U5P4pIaoUi?=
 =?us-ascii?Q?SJHJ0XyikPlp5bB34AUPMjbm4n/Ffl4WQTCKXgcqL5gAzxVoO0zPEXyWx3ai?=
 =?us-ascii?Q?lqI0Q6y1RPaINWLyFxLzqop6y8+dCoHBfD2ayGkKkV1zzWb8X5HUi99WEWIa?=
 =?us-ascii?Q?24dSvHkS8WHUDCk9vYz1n1lSXP/vu3Csm6aZaiGsF+hMomFrpa0eS4d/OFsi?=
 =?us-ascii?Q?aZ+IUnrw4kd4TVPr/lB5jBBOsFkjdujsEGfRtODY48BM00Nz2OcRcc6fXg00?=
 =?us-ascii?Q?ufXtos9mIP7cbrq0GWeZ9aRVfjh4n4TS5cOYEOUVk9T449VYxXWm8TJYokoR?=
 =?us-ascii?Q?tHFUKMpyTYiqHoS9tIM4r5fhnwc/iEm/vt0PysSonmx8ks9EZTDa2LJkVvl4?=
 =?us-ascii?Q?EcYLWk8onvj48hx5f66+75Vq4Bm2XlU4P+QYDnBVQHJLRwwuJzhr2xDEYfTa?=
 =?us-ascii?Q?RPjWXXh8B0d6RA2DkOAFLldYug/SVlTCNwg0UX/dQV63WtlhY2jjMGqWCT2A?=
 =?us-ascii?Q?kAUptwY3R5oFLxnP8w3jr2tbYEPdXQJnD6TSpNof?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197dbfd8-e952-4124-1612-08da791b788a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 08:53:31.9271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tE7zi5Usjk7XpAr4kSsTUE9OAYdUMIjzXXMVnJ0+1mAbLDir5BRTSjko1r6E4RlqIFoUzoHcJ558D6ef3wlWAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2279
X-Proofpoint-ORIG-GUID: B3WUNrj6FrouHC7kXoBNJaFRJ5v25O6j
X-Proofpoint-GUID: B3WUNrj6FrouHC7kXoBNJaFRJ5v25O6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_05,2022-08-05_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: AceLan Kao <acelan@gmail.com> On Behalf Of AceLan Kao
> Sent: Monday, August 8, 2022 1:49 PM
> To: Igor Russkikh <irusskikh@marvell.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Dmitrii
> Tarakanov <Dmitrii.Tarakanov@aquantia.com>; Alexander Loktionov
> <Alexander.Loktionov@aquantia.com>; David VomLehn
> <vomlehn@texas.net>; Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sudarsana Reddy
> Kalluru <skalluru@marvell.com>
> Subject: [EXT] [PATCH v3] net: atlantic: fix aq_vec index out of range er=
ror
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>=20
> The final update statement of the for loop exceeds the array range, the
> dereference of self->aq_vec[i] is not checked and then leads to the index=
 out
> of range error.
> Also fixed this kind of coding style in other for loop.
>=20
> [   97.937604] UBSAN: array-index-out-of-bounds in
> drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1404:48
> [   97.937607] index 8 is out of range for type 'aq_vec_s *[8]'
> [   97.937608] CPU: 38 PID: 3767 Comm: kworker/u256:18 Not tainted 5.19.0=
+
> #2
> [   97.937610] Hardware name: Dell Inc. Precision 7865 Tower/, BIOS 1.0.0
> 06/12/2022
> [   97.937611] Workqueue: events_unbound async_run_entry_fn
> [   97.937616] Call Trace:
> [   97.937617]  <TASK>
> [   97.937619]  dump_stack_lvl+0x49/0x63
> [   97.937624]  dump_stack+0x10/0x16
> [   97.937626]  ubsan_epilogue+0x9/0x3f
> [   97.937627]  __ubsan_handle_out_of_bounds.cold+0x44/0x49
> [   97.937629]  ? __scm_send+0x348/0x440
> [   97.937632]  ? aq_vec_stop+0x72/0x80 [atlantic]
> [   97.937639]  aq_nic_stop+0x1b6/0x1c0 [atlantic]
> [   97.937644]  aq_suspend_common+0x88/0x90 [atlantic]
> [   97.937648]  aq_pm_suspend_poweroff+0xe/0x20 [atlantic]
> [   97.937653]  pci_pm_suspend+0x7e/0x1a0
> [   97.937655]  ? pci_pm_suspend_noirq+0x2b0/0x2b0
> [   97.937657]  dpm_run_callback+0x54/0x190
> [   97.937660]  __device_suspend+0x14c/0x4d0
> [   97.937661]  async_suspend+0x23/0x70
> [   97.937663]  async_run_entry_fn+0x33/0x120
> [   97.937664]  process_one_work+0x21f/0x3f0
> [   97.937666]  worker_thread+0x4a/0x3c0
> [   97.937668]  ? process_one_work+0x3f0/0x3f0
> [   97.937669]  kthread+0xf0/0x120
> [   97.937671]  ? kthread_complete_and_exit+0x20/0x20
> [   97.937672]  ret_from_fork+0x22/0x30
> [   97.937676]  </TASK>
>=20
> v2. fixed "warning: variable 'aq_vec' set but not used"
>=20
> v3. simplified a for loop
>=20
> Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific
> code")
> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_nic.c   | 21 +++++++------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index e11cc29d3264..06508eebb585 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> @@ -265,12 +265,10 @@ static void aq_nic_service_timer_cb(struct
> timer_list *t)  static void aq_nic_polling_timer_cb(struct timer_list *t)=
  {
>  	struct aq_nic_s *self =3D from_timer(self, t, polling_timer);
> -	struct aq_vec_s *aq_vec =3D NULL;
>  	unsigned int i =3D 0U;
>=20
> -	for (i =3D 0U, aq_vec =3D self->aq_vec[0];
> -		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
> -		aq_vec_isr(i, (void *)aq_vec);
> +	for (i =3D 0U; self->aq_vecs > i; ++i)
> +		aq_vec_isr(i, (void *)self->aq_vec[i]);
>=20
>  	mod_timer(&self->polling_timer, jiffies +
>  		  AQ_CFG_POLLING_TIMER_INTERVAL);
> @@ -1014,7 +1012,6 @@ int aq_nic_get_regs_count(struct aq_nic_s *self)
>=20
>  u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)  {
> -	struct aq_vec_s *aq_vec =3D NULL;
>  	struct aq_stats_s *stats;
>  	unsigned int count =3D 0U;
>  	unsigned int i =3D 0U;
> @@ -1064,11 +1061,11 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64
> *data)
>  	data +=3D i;
>=20
>  	for (tc =3D 0U; tc < self->aq_nic_cfg.tcs; tc++) {
> -		for (i =3D 0U, aq_vec =3D self->aq_vec[0];
> -		     aq_vec && self->aq_vecs > i;
> -		     ++i, aq_vec =3D self->aq_vec[i]) {
> +		for (i =3D 0U; self->aq_vecs > i; ++i) {
> +			if (!self->aq_vec[i])
> +				break;
>  			data +=3D count;
> -			count =3D aq_vec_get_sw_stats(aq_vec, tc, data);
> +			count =3D aq_vec_get_sw_stats(self->aq_vec[i], tc,
> data);
>  		}
>  	}
>=20
> @@ -1382,7 +1379,6 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
>=20
>  int aq_nic_stop(struct aq_nic_s *self)
>  {
> -	struct aq_vec_s *aq_vec =3D NULL;
>  	unsigned int i =3D 0U;
>=20
>  	netif_tx_disable(self->ndev);
> @@ -1400,9 +1396,8 @@ int aq_nic_stop(struct aq_nic_s *self)
>=20
>  	aq_ptp_irq_free(self);
>=20
> -	for (i =3D 0U, aq_vec =3D self->aq_vec[0];
> -		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
> -		aq_vec_stop(aq_vec);
> +	for (i =3D 0U; self->aq_vecs > i; ++i)
> +		aq_vec_stop(self->aq_vec[i]);
>=20
>  	aq_ptp_ring_stop(self);
>=20
> --
> 2.25.1

Thanks for the change.

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
