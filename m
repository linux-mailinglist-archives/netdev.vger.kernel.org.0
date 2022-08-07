Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3878A58B99F
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiHGEve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 00:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiHGEvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 00:51:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BB8BE20;
        Sat,  6 Aug 2022 21:51:27 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2773NfGC006917;
        Sat, 6 Aug 2022 21:51:11 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hsnnqj5fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Aug 2022 21:51:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LznFZeVwELxYcRYXkZzWruZM1gUVW2h/Bn5oHg+iq+eHId/MPLMdXlAURuvOMS3dBCeVf4HBUpWjlYKBwtBs7m88T6yxQYs5+m9bm5R9/yzb9EkeVdfzZnXiUCkr2Qjo38gelR1FAmdEpgKV/EOOIiF9dp2pnP6vsv+1QkczGCP4mO4rj/Z3BpTf945nALM7nHzvBMWhZtpH2ezvdzfBLeHksUYQYS3lTFdL98HszMjNK5L3oUzW5EF/MteTZV/b8e3XQiEz8SyVz0L1OZV5s85t9/SUszjdMin45u4oqx+jz6HfOvDKjM+/DmXZp333zlCqgcSPENd7nHvo0nJhjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMtHEX6Xgg0Wt63VrNvhVhLfPBsyx/DlKrV4BwThM8k=;
 b=ITsAsMFm2oNRjFN/MAtJ4BR8pV+njFvtzgi64fLKvo3AJzic2C3uWSFwowBJFqbeyILw4nS9swIesNW8WaVuhCgnjJIpAW8xZcvgBDZNKjsAw8iwm/vyVPPzt1f5YJbv+Fc84Crr0fWN/vlAP250P1HJ68F1AUrFYR9Ps+oKaUlhjNkawGO/j+qtZ2grZ+x7dn++9xXoDrNB39idD26Uw0ROYDIUKIP/py/iBudLFjWj3wxQiBPH9cIflVfozhsdFXrcSdf9z7/qw6K2pHfhRMYHR1JPCC01zilpPVNRGcyOgskcYab6HQXzcO1RBBzsbQ6YByM4ZfAvyTQrNrvo3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMtHEX6Xgg0Wt63VrNvhVhLfPBsyx/DlKrV4BwThM8k=;
 b=ftYgh8q/cdGWMjMqxsdmPIWZREANhbwxHgulN8vMQtidm32JBeVeQNdfF3tE/7qtexsYc15LMx1+OPy/tqfBmxYyaOi+C7BJe20PUCcwNMzaD/KBBi26KSRSZGDd9BzpJ4OKegxuUwZcKICa2/1ondBqHRioXLo/Ls/YFGGZMt8=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:3::17)
 by PH0PR18MB5114.namprd18.prod.outlook.com (2603:10b6:510:167::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sun, 7 Aug
 2022 04:51:07 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::f1ea:59d1:475:f8f2]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::f1ea:59d1:475:f8f2%5]) with mapi id 15.20.5504.017; Sun, 7 Aug 2022
 04:51:07 +0000
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
Subject: RE: [PATCH v2] net: atlantic: fix aq_vec index out of range error
Thread-Topic: [PATCH v2] net: atlantic: fix aq_vec index out of range error
Thread-Index: AQHYqZl+JzOR6mN0YkORruNiXPcVeK2i2z4w
Date:   Sun, 7 Aug 2022 04:51:07 +0000
Message-ID: <PH0PR18MB4039168B1CBDAB8949F7C934D3609@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <20220806133558.3897444-1-acelan.kao@canonical.com>
In-Reply-To: <20220806133558.3897444-1-acelan.kao@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99c82e21-da4c-45e0-818b-08da783070e4
x-ms-traffictypediagnostic: PH0PR18MB5114:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zP/5UPI6j/sJ4O+FkFXOc5v6W+isoYgO4glykRxMREFsDChK6mOcThNH+IfWmDmtFAPicYfJ4OZWyg8U6CaxZ+DkDzNdqA+nVeor/SkWg6T9mPlZ/D3bOrhyiL0qT9EkYgCCvmGFLVLP5ocqH+ObO4zewuLVJAC9+mBhO1JDAcN4j/ueWytDeXtWQrUPdOkkZ1pNoiTN1F/Rphq6eGhcVs00NGluLbLBzVM4pQqF1gjw48G027M5511VgwdiWP1n6nvnKk4Fxcg/El91xV4Z2641TMP4Pdb2fOYcGF3KDStOOCD689qcFyMoXHht9J8OOvor+TdhRED5C53+NCQ73m6dQ8SslH3T5kIuKc552xoG+ELEdUXm4JrVRrw9Mrow0vij743m2SynQKziUBwk8WNUaikxFvtdx5b5pTrxr/D0ZRXIhMmO9zhxo/hRk8SZP9npUpEYX7NJVFerlryYe+LW13e9GCz0a7I4Hm6rn27U4RmUTcOUz2Ee7FFFwbNBwFsH/01bh4Ib9dtoPdfzoC2SmFYuq0L9GmvOV6qTC+vwcEtG9PS6fvCpI0qmoG7Ke8AB+UDFCj8HPJVU5Leu891TRrqgWJvzRxDKn4Q7c7kGWY0AuZdmPvKbvrC14eWui5eUuKSsvY9SM6NKe7yypVkqDQtnMUr8eu/FpEOxxxwCIjZ76tabzpOuUvBTYuRbuHrUp7kPtk0FeusUSVSbOHTVkk+FKJS/QHnOPXOkNegV+Ic9RrDd4x9YKkabD0r8jw2iiu8j11vp+xF96j/qUqru+OOPR8+DcGV/aN3I7SzYnUifbfr3ruSgAhp4b5neqCOLGls5Ua8/PdyUm1UCnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(376002)(366004)(136003)(396003)(346002)(41300700001)(86362001)(122000001)(2906002)(38100700002)(186003)(110136005)(7696005)(6506007)(316002)(921005)(478600001)(7416002)(8936002)(55016003)(53546011)(33656002)(5660300002)(66556008)(66476007)(83380400001)(64756008)(52536014)(38070700005)(8676002)(71200400001)(66946007)(66446008)(9686003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yh41lxZWsDfXkZJe6RR4mkD2JPXJAMZ039tO9dCw0vFgczbGrN00iTcV9GlS?=
 =?us-ascii?Q?Ec2z97FeWXe0K2hhhgbrcSOnjHDOEcAcoaahV7NXh9iK4mzqUL3qDe3sj2h5?=
 =?us-ascii?Q?8sfcvnikGM0EaH2mZs2I88Y7CrdZYhDihxn8KW6dEAeR2pm5IwmG++zxB5jY?=
 =?us-ascii?Q?B/l3hUlB144m1sbJA6kP7YX5PG8kPe175Po5re0Ck2JKo7fDUO0uIwPdBFdO?=
 =?us-ascii?Q?dauCgdfG/1UWkOSok1i/B7wfoKpWoF6Z6ZLqzyci6T0a0iiKypoB082dyV3B?=
 =?us-ascii?Q?HFOyBl8pUk1iHYXyyHNoqSYwxq/m/fmHJCFCIRsLnVMjffq5PmDVFko/tpPj?=
 =?us-ascii?Q?+VM2Xpw9mbbZ9hF6rVWeNKSIFYxROKw9q/Z/DAge3BbXOIya7DVHbMBdr1Vs?=
 =?us-ascii?Q?00qvxoa+JpbHGf4oOq6OUZJAzXOZPsI88246m1cAG5Lz5rUdnNVJ8Lc2avsU?=
 =?us-ascii?Q?Vn/u1nkmtUagQPvkrpjXDosQ/w5HSoH7DEQaMG8pB6h5wGrkdjux+hL7++D0?=
 =?us-ascii?Q?jUqgKJKgU+KN9Q2m8tNtASYJcZnx6708U4ZfoE1l2mG6rKTDBnl3brZl4Mgr?=
 =?us-ascii?Q?i0iceGleXpKuyf08N5CUEk8artAAqK3+IEqSyBC2QsBovrV7Zx71xrB2p62w?=
 =?us-ascii?Q?PeZEi4mGXybxFxIQNv4evRCYfW0t1pJM86MZ+cly0SNv/RmEflF0Truvxe33?=
 =?us-ascii?Q?Ka8aZIrD0TOSMynatAQsN1gS4TQc+r61OZzfdTgYNFIGU5hhhskP2P/Kjw8O?=
 =?us-ascii?Q?6SvsIOIVCULgfBuR0q817tFHEpvCs9ToE7r7poaPZns1k2IyOP5B1LP1Kg6k?=
 =?us-ascii?Q?UxFhBRtbBchaXwrDy79ASPQqeVUD8ISllLbInv/fH3nQh/52L3GMXBjC3teX?=
 =?us-ascii?Q?FSqUnRgydAp/aLrUlMAoo8ZzY8JqUR9Z6byuRgPaDqbqrKnJwoEonm7/IqwI?=
 =?us-ascii?Q?9z/y8vH8Qyxjl+xSSkuB/7M9I4H2OehHUXm2J/mbwOdXyBvVchM8bNlcYJqk?=
 =?us-ascii?Q?6VZn4PG0vTnEZxLOtiffRsBEF/yGo6eAPGt2+T8ohT7vv6BVWLn5fvGjPNxg?=
 =?us-ascii?Q?ckywjwufXj47BIsCROl0ru4FJubsUzC3aaqFb7qpKDuOZJySjx+5ApElEU/q?=
 =?us-ascii?Q?dpTvDfBhPF46gsis1OxoBwBj9vE8gQmL8hZZ9GfUkAUW4pr43M9it5LeLFNp?=
 =?us-ascii?Q?/X2bQ5qAst7GNMckhf/lSqK1WdxCOE2k69vmwF4ZqhS33x630YRpY2xEgZQa?=
 =?us-ascii?Q?QBf+1Mytuac8iAufB93BTghiyTPA6X2TIY5pxEjpdaST0p1p+iVwEV+5A4v5?=
 =?us-ascii?Q?fIRQm39grba4Rq0H914fJHvl6PzkHfpMhw/CcBVm4NiGelI6+w/B6NQiCcB1?=
 =?us-ascii?Q?39DqrkCsDrW0OQnZ1mq1v7SzgRd2RXKRWfQUIssXS8zAcDZMC0Yd2zZaROBJ?=
 =?us-ascii?Q?/D+dseMKtZ1uewF//o+7amAC3yX3gHS/wIYcUXv65ndU5JbbEQ/Z4Gncycta?=
 =?us-ascii?Q?TMqcScD10DpBeEujcZzLq7WcY+brM3dqZGBbA0sw7dUL222sPLcRfdcgCHJa?=
 =?us-ascii?Q?+rIcOXEaiJlc/dtxWhcz7pIo2NvbSMRT3wXn8TMxVVm+kweuI5r7dpPmLwaW?=
 =?us-ascii?Q?fOPJ7Ly7lEL1R84w3vuwvVqXp+GJqOytoqEz0VIyERu4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c82e21-da4c-45e0-818b-08da783070e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2022 04:51:07.3664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+fKRSdO+7w2mQrqXSBiFJqu7ABy+Kn1FWy72QilGvh3lZP0J2+FjxtdENiJ4szAL2d2JaNhhpNm6jB1X+qboA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5114
X-Proofpoint-ORIG-GUID: Ku_o2lZFdqLzAcA4Z8t8Kpw9KZD-vTNi
X-Proofpoint-GUID: Ku_o2lZFdqLzAcA4Z8t8Kpw9KZD-vTNi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-07_02,2022-08-05_01,2022-06-22_01
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
> Sent: Saturday, August 6, 2022 7:06 PM
> To: Igor Russkikh <irusskikh@marvell.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Dmitrii
> Tarakanov <Dmitrii.Tarakanov@aquantia.com>; Alexander Loktionov
> <Alexander.Loktionov@aquantia.com>; David VomLehn
> <vomlehn@texas.net>; Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] net: atlantic: fix aq_vec index out of range error
>=20
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
> Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific
> code")
> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index e11cc29d3264..6986f0080072 100644
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
> @@ -1065,10 +1063,11 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64
> *data)
>=20
>  	for (tc =3D 0U; tc < self->aq_nic_cfg.tcs; tc++) {
>  		for (i =3D 0U, aq_vec =3D self->aq_vec[0];
> -		     aq_vec && self->aq_vecs > i;
> -		     ++i, aq_vec =3D self->aq_vec[i]) {
> +		     aq_vec && self->aq_vecs > i; ++i) {
>  			data +=3D count;
>  			count =3D aq_vec_get_sw_stats(aq_vec, tc, data);
> +			if (self->aq_vecs > i)
> +				aq_vec =3D self->aq_vec[i];
>  		}

AeLan, thanks for the changes. Could you please simplify this logic as well=
 (like other instances). Say,
     for (i =3D 0U; self->aq_vecs > i; ++i) {
        ...
        count =3D aq_vec_get_sw_stats(self->aq_vec[i], tc, data);

>  	}
>=20
> @@ -1382,7 +1381,6 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
>=20
>  int aq_nic_stop(struct aq_nic_s *self)
>  {
> -	struct aq_vec_s *aq_vec =3D NULL;
>  	unsigned int i =3D 0U;
>=20
>  	netif_tx_disable(self->ndev);
> @@ -1400,9 +1398,8 @@ int aq_nic_stop(struct aq_nic_s *self)
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

