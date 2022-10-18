Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABB4602B9F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJRMVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJRMVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:21:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76BA26114;
        Tue, 18 Oct 2022 05:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666095651; x=1697631651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sZfILRZC386zAULMZyOlWqDLr33z/6h5x5KoFmJSrl0=;
  b=i0hEwQUbDoQaq2VWcM4uMcYOEqnzTc8SxxTFbrbSq92LNvA8wp8Rn8/j
   C9uyMWU7FQwx01NECoJWGIrZ15GsbT13UVibAgL2IU8Qxq4fyNRpUlhaX
   3+tnQCbr70c6XQDWEunAJuQFEhkIeYxN9L6GODSSd2jeJNxmghQkKLXeG
   RnLKKyRJAlC9TRS/xKJK/o8XV1hM4ccIVcQ4Xu/XBV10IIGQlmMLOZpve
   3J9jLFhGo2K4LS6znJAD5qhhrPEcEHwHenBxk+/Hialn0rtQvUHSCigfU
   aAiN88sKyGbL90pPXpYa8/WkSC8mzuXtikM3tTDQ0U6cZ5twWvvP9qLwi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="307172030"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="307172030"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:20:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="754020413"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="754020413"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 18 Oct 2022 05:20:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 05:20:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 05:20:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 05:20:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 05:20:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhO/1+IiLoHb9EWA05x67kQc9wrNscNGXsIjIK/UxoHcYq1mR4ekeD7v6+N3VgT+NsgSgzmY9MQePuEPiXqmOlOvaPMFxUx0vvFIjBUUOS50O65K9qs40xsgkJ8/fZMzbP6KDB1F32/61Xt2DuvLw2ctP7hRoSYCxhEcbuGoPXXyQqEdYISnc5rLIQ9MqmSzfGkVNwjw7qVi2H8uePAKyTEuBCS+Dr7qkrN8+sdzjJzmAY24x5fb9CIstHLBDsQRiSzP2UiHHjQB/2ENMnQaZpItmyQhRYLhXAIVzmF2TaX6V0UmknsM9Ys7ipdJkam8LZYe5M4qfXSEA2i8UxctdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4r9nEOjuz7GDjSwzd2qFlVqSkeMtaPADnIeQDgftQBg=;
 b=DG9eDlMHccarJLB1/Wa3OaOg+WT+WPK+tkDHHnoMX4/fUe1wdYT8XBAV0e3jcpspKqmTA9lzjasLqc+iiVoB9hGGmkv1ETF9au2JeLHy0N4WMz93+N/K3q9w3jGkFntF2tYhpOlSkQVDntUtV2qoVrjxPy2qOFP5uwFxA/9/+K9++bXOkfZu57iCPSQrpn3MA2JofJdB3x2AaGc9fxA8jb4MDNdKiLPhSeFrRG0+AIzuMwn1sKZDYDuSy/jqenfK8UNi20CPKj0aTl4v9HXT5Ag5Pzw5zjNu+kwKWKaLLkcUzGwvNPHLse6TCB0qOc62F+Su+1tUR6vxIFZyd1SpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1324.namprd11.prod.outlook.com (2603:10b6:3:15::14) by
 DM4PR11MB7181.namprd11.prod.outlook.com (2603:10b6:8:113::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.21; Tue, 18 Oct 2022 12:20:43 +0000
Received: from DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee]) by DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:20:43 +0000
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Kees Cook <keescook@chromium.org>,
        "Ruhl@www.outflux.net" <Ruhl@www.outflux.net>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] igb: Do not free q_vector unless new one was
 allocated
Thread-Topic: [PATCH v3 1/2] igb: Do not free q_vector unless new one was
 allocated
Thread-Index: AQHY4tOhXsEwHafDKkupYOAMeXei0K4UEdiQ
Date:   Tue, 18 Oct 2022 12:20:43 +0000
Message-ID: <DM5PR11MB13247434B4473C63898A35A7C1289@DM5PR11MB1324.namprd11.prod.outlook.com>
References: <20221018092340.never.556-kees@kernel.org>
 <20221018092526.4035344-1-keescook@chromium.org>
In-Reply-To: <20221018092526.4035344-1-keescook@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB1324:EE_|DM4PR11MB7181:EE_
x-ms-office365-filtering-correlation-id: 5a3ce4e5-8933-4009-abc7-08dab1032d91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Vj+e5H7KH72uER5pPH3Dt9yvUz8VDXyCXHk5NtpfZT9g3WnF6SwtSSf9AQzJpciqBqpYKP0g5NCM7/She1HkQZvCjVVxMT8o1jcmveQxyDOni69fxBAE3RkoEh1yO/xTFSOdnazwE2Osf9uTBTMdwLyBdVYOUhygsfj9eDsiwPHV/oZBCPuc7MVdfYMA8Wgh6RrG/nRe+8bG7RZ4m3ldfZXnpKdslcktVKcWeAvgtr5rKkLB8oy3h5oSCR4kkXb79qXZ5OEvrVWfy96tsPltnZYV/8FZXX93agBO2D1hO+6wqB54oZinA9z0r+OFQ9R6Ym+VwdAjifPH9+AYKuF0pgYczF1+43B14WftDQAwZK8pJ0nJioDyo3s6207mokpm3p27hX7wXpWfnW0Tydcp+TyZatEYhJysibGqy8ZMEGS1dMA6g8MPJFs6iuYz5Z4sT6uNUYf5qoHaITr183CqduP7krptlBy0TDgamFuiphjpQx4E0ScbKfpUpugL699G0/DNdHIQMgxGKD3tLnMnqVJ6YXIE4jlcm7vGahtKLq/WtBoImTMBNlEmNF28NQMfog5aaYf4otMy1OWotPdgp23XesvA6ZZSwXhGKt3p71pJ0v1UeyoZVP77RVnrCGeAVo34eqVAmD5jLro+3rxxA3oPyFZG+BSVUEJ14ULdpxgEZt9A8ltiLh4T2f3LzPZAd/sMG2C9Z+Ere21EqsT1pPOcwWU8qz1jx6CAnNW6LtYNqXLOMDwHt9S9/L/cdjSBUw6eCylF79q4jUD0xckxDMfmw2HEwbt2WxdASerl8sc49IFwSJUH4ZdOGDChDv69d4QA4W+etjHiy9vFSO9G05XhegoA4G27Tf0CzUF4SU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(110136005)(6506007)(9686003)(26005)(186003)(52536014)(82960400001)(2906002)(478600001)(66946007)(76116006)(86362001)(66476007)(66556008)(38100700002)(83380400001)(7696005)(4326008)(41300700001)(33656002)(55016003)(5660300002)(122000001)(66446008)(8936002)(7416002)(71200400001)(64756008)(316002)(38070700005)(8676002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tsescKqBU+bngQry9lmDVrkjXq9eCFadvWoVo3K29+tt6bZFDnT33UzLlhqt?=
 =?us-ascii?Q?TqidxAkzighLn6tWMZfP1TEpzFc/vltVjUS8NisLNc06GQNebKwURyWoAKXJ?=
 =?us-ascii?Q?sqVtVREPMQS6Rb6G/ATJdXhtix/NHO+eje4MsscebUJW0/tkc05rYTbCy0u/?=
 =?us-ascii?Q?NS3WveSabcuOJq00j/4Xv5MdPfotdWKWFLM61RbY7bh9SP3A6kWFNjmBrQIw?=
 =?us-ascii?Q?g7SJVOwYK9Xkvg0hoqlSyrxM/ipORjdq5HTVyJNYFJkZqs3gTf6D0uDatK0J?=
 =?us-ascii?Q?EoQozcqjxYR05cBN5SbxCcm38A3ImTAYVuR5GdEbM0cZpfrVaRNCUPF9ARQV?=
 =?us-ascii?Q?Pc1H8i7CfKEoqLJeRvIRLAMG/6yAa4+5NKzi1wf/vwscUOHU0uBb6GJFoexj?=
 =?us-ascii?Q?+I2SmbMPk8YCAtVysRUlUN+wD5U+XPo6r8D52iy6WFbLOVl25X+aN9ULLs4I?=
 =?us-ascii?Q?Syn0cqKEAN4gNcwZKEBm65WOFSuoGmJdItiF9YXph/zL3H5Orj/9+LuLIT4R?=
 =?us-ascii?Q?GpPx0Pd2eoB8P9OgmuMN0x0fJICeLPH3XTBnFWXMUkEqwkFYOR76NxNidfQh?=
 =?us-ascii?Q?+nUUMe8KW3MWSez/DRcbQ2oY0KNul1yViCHQn/UMj63HnLHYt6Vuik/Yd/lZ?=
 =?us-ascii?Q?3ecuLv23WDpBJMQHlDlj+x7qQfxLjmUC41fJnUqE/M5Lgl+2kYud8dc6p7Z8?=
 =?us-ascii?Q?Ys0tkQIVGZkKwoPyNEaduRzoTES2yOa9mGkafa7CwrC4+3Bg5ulRYajNdBFb?=
 =?us-ascii?Q?oPZwgOzKS8dqq8zddhYOfFRRSVRoGPFjKPzpT3X7id8/fJF534OElGPR7zEy?=
 =?us-ascii?Q?G9mN/NkFub1d9ZPAkI/C3ZzePd3zF+oEz/jSnrMLgNK/YCeCA/509++NduMR?=
 =?us-ascii?Q?zAdmSM7GvhLAVxPjkf5dM+WBcMGWgspyJ7kuEdJojlDOK8XTUWnlBtqvs/6Z?=
 =?us-ascii?Q?YFRjrZYoQ/w4BBvhBMrLbsGYC02De0H93pnvku40z2+J4/zG6fqoz3BdDDTM?=
 =?us-ascii?Q?RLDrUwe7ZC14ZcbLEailjw9cJFNUCK6BjVqikGYCth0/0Bnq52L3XBXrFr9k?=
 =?us-ascii?Q?l0/8v30bl9auYc49vQj/4Pivb7QUUGN2JJnbadAOfL5WckqUjmNcCQT0AJp8?=
 =?us-ascii?Q?NhRbzMTO4VnDX3QHRRPW6nrs9fSgm9YfIre1e1kdB/LjewTEN7QNN5uPxBvW?=
 =?us-ascii?Q?yC+E6kjSBYRfaCuv13M//nJ+u4ssCDybsi6StL48Y0c3EWfdoM72+/KeWVFu?=
 =?us-ascii?Q?pJ+TzUJQd5td0WpV2a5cyxtHPVPViFYkuvKfly97ArJmUOgrKNYUywSKFx3B?=
 =?us-ascii?Q?kxcDBa/awMKfziqKWQ+20c7lAEydNEvVsTCjYTNkp2CDmJgO5k1sRoXnO4MY?=
 =?us-ascii?Q?g0ucl8hOKH2iALka/p0fG9XqDWC0SzmlvqdkGYKTTxI6GPRoZIcWqUW0rPvK?=
 =?us-ascii?Q?uvk9pJQYIfGxOJCCe+4qlGENmu3LGHa3/3nSbfRJ+TvfDaQV0BgdVtXsBDuX?=
 =?us-ascii?Q?BpMBd82A0vYGbeR2/VhI9MN85ZWqS3R3lvYJxzACw14v4l1k7q+SZZT6R4l3?=
 =?us-ascii?Q?nduRh+p0k5Ub4K5/DSkNRGFVJD6zhJmImW+pg3GR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3ce4e5-8933-4009-abc7-08dab1032d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 12:20:43.3729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rf6sRZxBY4dwng8txisCZGHbqueKr/eDdXgLQxoG2mQTSN0qQ+NG/B3lGHzvIKVEitEFq204oSHDFEwpkUMdlx7cG93sSyXpyd5ghiEPbao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Kees Cook <keescook@chromium.org>
>Sent: Tuesday, October 18, 2022 5:25 AM
>To: Ruhl@www.outflux.net; Ruhl, Michael J <michael.j.ruhl@intel.com>
>Cc: Kees Cook <keescook@chromium.org>; Brandeburg, Jesse
><jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Paolo Abeni <pabeni@redhat.com>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>hardening@vger.kernel.org
>Subject: [PATCH v3 1/2] igb: Do not free q_vector unless new one was
>allocated
>
>Avoid potential use-after-free condition under memory pressure. If the
>kzalloc() fails, q_vector will be freed but left in the original
>adapter->q_vector[v_idx] array position.
>
>Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
>Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Paolo Abeni <pabeni@redhat.com>
>Cc: intel-wired-lan@lists.osuosl.org
>Cc: netdev@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
> drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
>b/drivers/net/ethernet/intel/igb/igb_main.c
>index f8e32833226c..6256855d0f62 100644
>--- a/drivers/net/ethernet/intel/igb/igb_main.c
>+++ b/drivers/net/ethernet/intel/igb/igb_main.c
>@@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter
>*adapter,
> 	if (!q_vector) {
> 		q_vector =3D kzalloc(size, GFP_KERNEL);
> 	} else if (size > ksize(q_vector)) {
>-		kfree_rcu(q_vector, rcu);
>-		q_vector =3D kzalloc(size, GFP_KERNEL);
>+		struct igb_q_vector *new_q_vector;
>+
>+		new_q_vector =3D kzalloc(size, GFP_KERNEL);
>+		if (new_q_vector)
>+			kfree_rcu(q_vector, rcu);
>+		q_vector =3D new_q_vector;

Ok, that makes more sense to me.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>

Mike


> 	} else {
> 		memset(q_vector, 0, size);
> 	}
>--
>2.34.1

