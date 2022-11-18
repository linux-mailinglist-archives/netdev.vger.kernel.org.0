Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772F562F147
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241953AbiKRJeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiKRJeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:34:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE227678;
        Fri, 18 Nov 2022 01:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668764048; x=1700300048;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cmB46MYntxsasjEvcGtzHFGFTsVREiVIEGw5WPlpe1Y=;
  b=n9H4R0V5e2ZyN+wmOlzc4TpgOVdpjM6ClDRvN4bKE7vaG1imYm620+cB
   GeCnT3OnpMG6XdExIELTLFX38NPwVlA3wMZN0fWV6kW6oB8ZTnf+H7KG/
   R2Nhlrf+l32qaqAOfxFXzSEYcmeJdxBXgkRTRVQOzjL9SUgYEZlZaHGXh
   bLThV5zP1gDO+Oo7nrTEI9zvnVGQa3oAjbRN4X555m9G9fXwzNqWvDisq
   ITJUOGWBx5VOdc/Kes35DoIiflgpj6HHDVd92GVxd5+x8UPZiCmyoVtoP
   ojlH6gR0vFPJIjnqB7NIh2LW25wDAnD/eXWOBmSCx6Th3vMgbdzpSInqV
   w==;
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="189553277"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2022 02:34:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 18 Nov 2022 02:34:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 18 Nov 2022 02:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW6u8MI+K/s7VVx8YW9lLFn4sFKjQbMqgdHeS3eVE3XwmkOt0QqkVuCom/O9/bbgP3oAfZHcBd3txr9bIvZP8EFrM0tyjN0eC+mUMxunlkrcKQBl9WuQYaaI1ReNaHxXcUjT07aDN3DwvNriZanIR2mTlPbwNg1aZ+ecp4wuJ3P1uABv9G8mZDysxZyECxoFcp/mdIYvdx/qpOmP3d8s6NSw6C5L74j7yOt5VTXQDL89xgdFhYHpq1S7FSICttF5Z2M657EMZRmApwFoipOuPsDSH3naXCuO4+herGznN5KNYnXRyq0i6IaBaVfHSJ5cApoi9FX3d6B1SzLgLND6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsoUfxbH5SLSg2lNnQv8pK7WyZF1Ur/coAEseCKvXPw=;
 b=h4qZ1jKkPnYndUBP9CntoM+SkMLLl/OSEpzRWU+SxrZ31sPwg0M53SDTX9G3VRBEi3JEgVllUoES4P5Xc26Iut3WXj6h5VNpOn6ql81crylI3hpcw0Wa4sfpULMQE7QjG7lPfMSnEmiWyT5teYmuO0mdzkTIMh/EfgHbh56JXMr38JF9YvgO7lQrtStz1lTEHTaZ9ldQA/8lK00ORLpXjUhqgRNH9P5TGjKAluK9qa84wKVVlEEsbeiw80AzWM+iXmx8HfN+kqMBDnHzMs7baNP4CTg6ctOCrP/B9qKjaJk5WUZRXytXSRLs22pgSBIOk7Dk7pAvY99CjaoE6PrIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsoUfxbH5SLSg2lNnQv8pK7WyZF1Ur/coAEseCKvXPw=;
 b=ZzgGD8kWgI8gCl1IXjJJknLYGXjDWOkXyGMq6NDk7lBdWdYIO14KPH3YSW8gfwhTcsWwBAGvO0p1DxVWwKGN9iV2FSfcsijC+5h4oWK6Cw6fa2yd4nvE3wAwd0Fm7x0H8Izyszwc5sQVlC1SzVM6tkCphvUeifHY28R2+l7tjH0=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by BL1PR11MB5256.namprd11.prod.outlook.com (2603:10b6:208:30a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 09:34:02 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 09:34:02 +0000
From:   <Daniel.Machon@microchip.com>
To:     <luwei32@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch net] net: microchip: sparx5: Fix return value in
 sparx5_tc_setup_qdisc_ets()
Thread-Topic: [patch net] net: microchip: sparx5: Fix return value in
 sparx5_tc_setup_qdisc_ets()
Thread-Index: AQHY+o1Tfm6LJWrfM0uVJIUKPTcpqa5Eb72A
Date:   Fri, 18 Nov 2022 09:34:02 +0000
Message-ID: <Y3dUG42A/UkVTpaa@DEN-LT-70577>
References: <20221117150722.2909271-1-luwei32@huawei.com>
In-Reply-To: <20221117150722.2909271-1-luwei32@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|BL1PR11MB5256:EE_
x-ms-office365-filtering-correlation-id: 9a2b3fd4-b7ee-4dd4-198a-08dac9480720
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3VnYy3GoooY4S9d4LAiFjAwou9QmgqPxTk5uEnLWidjwDmZiTkcCbRQdEZPeDdlHOPyClPiJhq/9bmKF4aq9qtXAHU5itn93uHamuzdxnLmDMqkoClrL+ZZ5yBSeT6Gx0+Mvrlvs6wLc6qHXYL+i8w1JDgvbGmLljRJ3kB5ZfPqfg0eeldhHkTQBrb8k55JnA2BRu8hZYV/ybFSx+oL6lig5Uyvoj0nQAl73dMSIpYoqgy2XdENBtgncfLvrwXWAnIkDdSlcCohMDAyGILcxOS6wseOWbPX3sE67k/mOwWAUCZL+VuFQ3QZwFTzoHzmnwHmMLYynhUc/tp4fI2MFCkzfn5bmdU8KXjzJNwlXefqyeCnYR8dfz3Q67NzoHHhnGfCMq8EmuaMFeoeBEmwfttYWTfDoOlVkcyw61C7bSBw2fKS5ASdyiwRoxh6pv9Ml35Og8NajydYaM753JuHESzXcSE7shcRkNKy1WJYzCZpJVRPHLCfLKUSu4NsqMrUEjv6qGS8PK1on7V4RMDoSgrJbIsSJGzvHZqUQkOqisqm9VQvjgl8zNUs9nJWSXDGnjAqI61wB2nqiUG/8LQZK060eIx/xaLhivWDLpmuFHQvWZ8aOa19w0xGdtvLG4rvS729K+KANbvqmZi9CqLKe8qldv+k4EIKcMpLnYC5/1JwlM9dNhnsHlqesSAp0cDWV1QAnpMNBca4GRAGCyTEgYVcvOHffDHBzxMIa8JzN0RI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199015)(6506007)(478600001)(316002)(91956017)(9686003)(6512007)(71200400001)(2906002)(26005)(6916009)(54906003)(4326008)(6486002)(66556008)(66946007)(66476007)(8676002)(64756008)(76116006)(41300700001)(966005)(5660300002)(8936002)(186003)(66446008)(83380400001)(86362001)(33716001)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tzPudNNibswwWCt7SzvcOpl2xVH7q0aYzZKv/zbrDp4qb1T9O7oeV0Mb2LbT?=
 =?us-ascii?Q?sIeuMDykZibEZhm266NgkLKCnuLp9Q6MfcFfjKmaGXgBAq3ZjZRAw//KuSdv?=
 =?us-ascii?Q?wdtmJSYd2UPLCMhsD/ush8xQb6F14hvjiHa0abmsDjEYYqrlqgnaRX3SMeoX?=
 =?us-ascii?Q?gW2B5Ci0qVsOU1IH76RRqZtEUwl5GR6ABGIogYRUILFuyo2AMnZbxGLyxvQw?=
 =?us-ascii?Q?ZD+2WfrHWuAxE1Qd1PGoJdfPiLF6eU2E+BPdzdYt+pRVCM0YmUwEP8oNb1+C?=
 =?us-ascii?Q?CwTMWs6L4QAtIAM+6BgXAxNnJAEB8R7qi49YUIc11xEVqnQ/v1puHoMy8V2+?=
 =?us-ascii?Q?sCw6vQjNaFukZFvxhrLdVlneg0+r/XwrEx1IJilgQg+hEtIDeiYd2ylzM0gy?=
 =?us-ascii?Q?pEcIU+di2zO2YRidm8z7FY4H/SeLM+dSER4t2+uK9i+ZBFocYrGkinuke32X?=
 =?us-ascii?Q?eALtsH8gFXYVHQWhPl4Gx4fhs/NqZu6XXd7D2wL5iyMi6g/8WIQh9rtlsfPm?=
 =?us-ascii?Q?ENH2Xwvky/A8IKmupEEVYnlnYpfCsKDbXekYIiGHRL+h3WCFabpxGP0dWwPN?=
 =?us-ascii?Q?L+XoMj/fbgE3BgMlCk8o3lwtXXxb4ayNgsB1xnNAuV6znSbldpka1woaLM7G?=
 =?us-ascii?Q?/EGuS3835E5l6G8wsYJzv0TKxk5g1HpYWZh2iScxpKJ0L6xF1YFofXpzxoPn?=
 =?us-ascii?Q?wrnejbwSBtoWPwJ4nVyWcGue48DUBEyKSbX1LLndNfrf0/wVCp0AOUCs1txH?=
 =?us-ascii?Q?q2vQ+rixb5Jsjg72wci3+6K3Bmn+5/1PAgAr9h4QIMX/XXmi/RPx2fjjGxXY?=
 =?us-ascii?Q?SPY2/2hAJubxkvWSLmbugL9ykp8pyXF+lwsoOvLFT9cNfBY4wRmlNmI2VhZZ?=
 =?us-ascii?Q?ql7JlObRJpFzg/Jqdo5FBMARKib9eTIxXoS3zu73kUnlDs24sX6Z1oiqgAfK?=
 =?us-ascii?Q?6usUGGMR+v5rBD0gDQoPQLjBYJ6VVBBkJu5+aDaW2DJPAIQEqSP9YLGMrrOh?=
 =?us-ascii?Q?7pokvwSJ77BjfpME7+7MsjyvtmWqp2tfDGrFDp4b4znCA5gQb6OHfD3LDGbD?=
 =?us-ascii?Q?fmDJd+ErHcJTM9IYl3nT2PFRRkGgj2QXSiB6usBYHLvzQEkElL4qAdlujC5a?=
 =?us-ascii?Q?wSLAGqJWyzf0oGxrm8+NptPfW8rBE3SVYMZttrdHBMJMBE7TJHsk6TkSLhR0?=
 =?us-ascii?Q?kcIGwgtKM8gWwmtEdVoX/BA/LMOc//NYXzCcemFOunSalnOu27471qo7LXnd?=
 =?us-ascii?Q?DXO3sNUP58QRCfYJo+pmOYRrNQO5U/+m9056h8pacJozjkPVO9Dk0Y9PgYlH?=
 =?us-ascii?Q?km+1f513h0uJwKTwj605kNQ+pQROin7Ch32N9csCoAYKEUp9f/5MZPR3a67f?=
 =?us-ascii?Q?kbUEfyrsamlu+1gOQ28Go082ebCpKesX+RHckdQHUYWNd/H9Zhx2CwoWJIUd?=
 =?us-ascii?Q?aTLzbZVOs2Uai2tX6Uhli25rnX5Fq1frYk4KR33t39739mKtoQCuKxolsN1x?=
 =?us-ascii?Q?YD5VY7s5bMcmOxLOGnAlk4ulSGwUnZVJVTjE1KZ6xUVH1re0yaLNwqEkFDn7?=
 =?us-ascii?Q?ROu5+emPXtBctjeW4bO+7vwHykas6RmHS/ZCCsjEK6emEGQ3mmrzKoPbhWFA?=
 =?us-ascii?Q?Q/79eldL0vVBobQUNtnpdfI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CEF8F139CF04D94BB63BC287AE88D29F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2b3fd4-b7ee-4dd4-198a-08dac9480720
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 09:34:02.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXoZkUic7wkKWdZFLvtwjzJNAeubolbAE4b5DoJevgNmFipjruTFTRXVmQyMSlx+IM/5xPGJQRfPeF2y+djo/b7MNDGkLrYtEoGxq5ErSkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5256
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Thu, Nov 17, 2022 at 11:07:22PM +0800 skrev Lu Wei:
> [Some people who received this message don't often get email from luwei32=
@huawei.com. Learn why this is important at https://aka.ms/LearnAboutSender=
Identification ]
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Function sparx5_tc_setup_qdisc_ets() always returns negative value
> because it return -EOPNOTSUPP in the end. This patch returns the
> rersult of sparx5_tc_ets_add() and sparx5_tc_ets_del() directly.
>=20
> Fixes: 211225428d65 ("net: microchip: sparx5: add support for offloading =
ets qdisc")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_tc.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/=
net/ethernet/microchip/sparx5/sparx5_tc.c
> index e05429c751ee..dc2c3756e3a2 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
> @@ -90,13 +90,10 @@ static int sparx5_tc_setup_qdisc_ets(struct net_devic=
e *ndev,
>                         }
>                 }
>=20
> -               sparx5_tc_ets_add(port, params);
> -               break;
> +               return sparx5_tc_ets_add(port, params);
>         case TC_ETS_DESTROY:
>=20
> -               sparx5_tc_ets_del(port);
> -
> -               break;
> +               return sparx5_tc_ets_del(port);
>         case TC_ETS_GRAFT:
>                 return -EOPNOTSUPP;
>=20
> --
> 2.31.1
>

Looks like ets_offload_change() does not check the return value of
ndo_setup_tc() here [1] - I wonder why this is. This also explains why
my ETS tests were passing.

Anyway, thank you for the patch.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[1] https://elixir.bootlin.com/linux/v6.1-rc5/source/net/sched/sch_ets.c#L1=
43
