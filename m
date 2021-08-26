Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05DB3F8560
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 12:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbhHZKfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 06:35:37 -0400
Received: from mail-eopbgr1400130.outbound.protection.outlook.com ([40.107.140.130]:43776
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233966AbhHZKfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 06:35:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4uPz/4s3pwODVp4G3EPm4IplK3wHOMYzphp0xEbyoYJ6zrsozOOwqQXz73HHOC+7yvVG/8hC/RsXrd4sUXPxZu3kmGgZ4kEUFSs7WYcfGsaZR41uU8jQnNLuIR6F0963EG3erbSKYzMxTX2jTRLZku/dJ78MYf42qFJIqPgzaNYqyqJZNZBjqsNDfE159l06GtAWah2OEem5VOwd21UD+NTiUnHpWZYlFeAxIFkhfN7Uk9VzfQju97WWYjn2vax5fKxdnrjf7qOojqhXwM0ROeZ2zBZE7zoqA0AU0Fcgn1B7CP3eE+UZKBd4VUo1+W8fS9F1PDut5VxT4+aY5WcSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cF2qc8Mma4A9YUww893jEAsOtHrSo6F4SH2H6/tKR/w=;
 b=VniGFFV4PKco++YoDXsM3qr3w/orrhIE2coBBIvBynBgmNfsLlqvZGsVzdZCjxkFHIIkZ1UdsYYozw31tmFuQzg2fpFFfU1CfPoNH36BZQ4rXGrBuflqZRKNaCa+oFDNlWPo+d3WbIWS0nxzIQ3Y7lgoWnHlBeBUGBUYLvAhYv4LhPMVyAj8+o8ztfnKdYLiGEjW5PiEirkyys80Psnda3vPJUPvZ+9gNe0EEpR/sMIvmPMbx60x/FiUzpdsZGj8xq/8PQxjJDQGa+IiMfx6bRp6mN9qgyUXnemsrDm3CoHGzznJ0P1F6FaHGTZZQUZWuXEzJezdhvGxy1TMasu+Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cF2qc8Mma4A9YUww893jEAsOtHrSo6F4SH2H6/tKR/w=;
 b=Y7KnXqbg5sr8/KKZlr5i7SDZ5pnM6ix8OfRWBM6vOYip5at24VBHc8Sn5CRx8PZXC63Go8oQqVTifuYP4XCywYjtjg124jD1zQDapB4iWDU+QfjTuRbFK6+3ymTr9xZNu0n0mcdOesgkKWuLabGrjlAt3JpdICjKvluL1sldOwM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1878.jpnprd01.prod.outlook.com (2603:1096:603:1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 10:34:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 10:34:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBCAAEagAIAAAOMg
Date:   Thu, 26 Aug 2021 10:34:46 +0000
Message-ID: <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
In-Reply-To: <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17ba90b1-a5dd-4e97-f9ac-08d9687d202b
x-ms-traffictypediagnostic: OSBPR01MB1878:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB187887970D48D3BE09FD382686C79@OSBPR01MB1878.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CwV3WH5b/hQQRdGA+/3JWVaoxy3J0p4NA8sOYQ+ZyQ9L/StsJ1Tev1/hF2uRIl787nxQsQv16LlXTVw7l+k2SjPjI+T1fTyXCZp/ERgHk4z9JvYrVPvNhFubIGsWKS0pZwCwv+6I7kUDvT/rR9fVw3fwloaBn+65Im0mr9IkbhYMyfzfxlgWku0zcdYjZzAnF2me6uN2MLFG40gM0rmqsa1ZmZUAC1J7RLejT0BmWKCzMUwI1BV781ib7mm9oFAd4z6k+z8uPlSRYUzgFAO3u5he5sIBi+RH8xyHVVE3mJAHyfCvD0M0NMvsfTg5pnwUdKeKC2CaAXrefsVIoeNWp3RZfrP7Glp+oAm/wIsrspYVU6SJHzRKXgtsPvYE11ddOGpTmhPu8tOTIwGJVhveKR76ERIPJS/CPx7NQRwzFqsjnf8P8WuBh6VxeT93KVNQGXxQOVRllW58qP0TnrscCKvppTyju/mwtYCVKbp5f/hl0SViEMBA+ita19N844kiJNvm2m80oADXg7JakD7wSyWwecmjxogOUQvdSmgdqzgPQpv6px8/bFg0V1apGh9EojYK8Us2FEJtFk2+RW6BAkNTfFeE6/Bcy8KPfl+i63m7XnT/bxkcKTgZglaqfVmwOWNE488+r/3k1yoF3U8gtz0pjJZ2YL5BQy7FIYWHv/i0APa8KNLkaH6YKW9WBObE9Pz988CNKRqTmWqDAKcvBsW7BzNXTADq53/z3KSlq8UsbUD/eJFD99Wkc+zPHV4HSQaq0c1P9ZrT+lnBICckEvf+kx7VKFCvQ9+WUNhXkW4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(76116006)(38100700002)(9686003)(478600001)(83380400001)(52536014)(33656002)(5660300002)(66446008)(66946007)(66476007)(66556008)(64756008)(966005)(316002)(122000001)(54906003)(110136005)(8936002)(186003)(2906002)(71200400001)(4326008)(86362001)(26005)(107886003)(45080400002)(38070700005)(7696005)(53546011)(6506007)(55016002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BdTzWdfFHMssySHGyiLIUkQ5DPmHn73+Lonns8/wxQOVjXK1z0swhXfwPzD7?=
 =?us-ascii?Q?m58GIlO55DOAWzzZPSAjnU8KL31+SPiNNiyb+HFCVSQPK/rH/COkkMajuYiQ?=
 =?us-ascii?Q?Q+OIiXGhaZuwhvJaF0L615ke6dQOqLzC5zLMW902ZjjWp1yE1Ky+L9btEa7k?=
 =?us-ascii?Q?SCT2gWuut+GWaQD14Fc+MFpp2ICJjT6OC4ItWB8I1ZwXQDbyzvZJZCMJwb2x?=
 =?us-ascii?Q?2egYGdDBfYsa8Ffgyc/ZQ17DotWV7A680S15jwp+uAwJogHNA4AwQI9v/vBr?=
 =?us-ascii?Q?iDGUaZWmTNr8gf178OnKb/TikUb+QpaO9XdzBgP3bpubLFe3JiU1z3COaiV3?=
 =?us-ascii?Q?RKpJ1ErvIWcPKuSs8pcNks76aGr0aCADr+SiQF4rbWjXoNR31now1Pzrn46M?=
 =?us-ascii?Q?17H/r4opxjfWyAyLgLJT8Ir1BbI2kP9vrhYHGZ6cb4DQo8ffFb0wudQzZ7dB?=
 =?us-ascii?Q?eA4dGQogI9R/T5Ud1vlgWIrw958VnIQLutzq1X26Gk/iE2HPEkQUFvR894zo?=
 =?us-ascii?Q?chGGhD/dD07TiwIQ+vQimQ3RGCc+BcXlK2RN/V1nmjgnkvQGVIA0SLDPK5N2?=
 =?us-ascii?Q?485GiPyr7UtxSynOKPcREeGM02+Vtf9jgyoJdDRWbYKhmr4Zhtn42SMIxJTL?=
 =?us-ascii?Q?dbp9n4liUHzp4CraG2rHYE2KhCAx6zo4vn9R2KOXEw1pRsVOgYc/Quc6QcUO?=
 =?us-ascii?Q?DlGC33ZdTg/ddcPY0AYcfntnlVVxDUXqwTwpIAyGxPBx5y6zY6mWKEQW63qa?=
 =?us-ascii?Q?+fXfoMXBDVxmZB722+AADxlcB26ykxYTIXzP+cKJI9QGHNqLe+KaVSApltR+?=
 =?us-ascii?Q?M9eSd+yej2gXFKWrxTLU+ElAyDHpu0IYATZqtEmaTt8OOdvjFZqlKvp1dW7j?=
 =?us-ascii?Q?WJ7rPSg7Eh5fJiPqGmTE0IR7Rpxk2FVEOhFy+Wx1GlmQgjTn8C1myu9VGDkk?=
 =?us-ascii?Q?0Kal4bD5tjqVJnFf8bxkSuXMRZOf2GZiNsnbdJ+azo4joSBu+XZP9iXMAyoK?=
 =?us-ascii?Q?XvlYgCmYp6xml9uNrA+OMdFPgeBjlgXySEitAlooUBGeq9ZJyHFfDc6H6BLW?=
 =?us-ascii?Q?O+9+TOhyBcTHOwv+MENDCjf+d7dbK4mMVgbRaJfmTAswZvHzV0JV5XI7x+oS?=
 =?us-ascii?Q?XgtNG1EFirNpABiECoUNZX558BHvQEvL9EQ3DKa6eyXf+/OCZRs0/PvdekGa?=
 =?us-ascii?Q?3g+Ia4MAsWVv4ZjHZRTT9taMR7BJxP9KJw2oMkhtWVTz1pLWfE/bKOwfCHdm?=
 =?us-ascii?Q?9zdYIwDEd0O/6cvz9Rm8sLH9hfpmnNqfHg+weoOlA8Ec32CJfR5jcMLdy/xR?=
 =?us-ascii?Q?OsC/1nsV1yISFX3dawa3FTiC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ba90b1-a5dd-4e97-f9ac-08d9687d202b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 10:34:46.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bvrCT8j2UwON+4RkWf8iSQSqcc4xN7PaWLVmlEoiV6CrA3SpZPZ2l/2mqPXsbXmIoD1TuCJ07jYpX6ITyKIXFJiC/1P/bHufDZPbk4v5iFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1878
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
> ravb_hw_info
>=20
> On 26.08.2021 9:20, Biju Das wrote:
>=20
> [...]
> >>> There are some H/W differences for the gPTP feature between R-Car
> >>> Gen3, R-Car Gen2, and RZ/G2L as below.
> >>>
> >>> 1) On R-Car Gen3, gPTP support is active in config mode.
> >>> 2) On R-Car Gen2, gPTP support is not active in config mode.
> >>> 3) RZ/G2L does not support the gPTP feature.
> >>>
> >>> Add a ptp_cfg_active hw feature bit to struct ravb_hw_info for
> >>> supporting gPTP active in config mode for R-Car Gen3.
> >>
> >>     Wait, we've just done this ion the previous patch!
> >>
> >>> This patch also removes enum ravb_chip_id, chip_id from both struct
> >>> ravb_hw_info and struct ravb_private, as it is unused.
> >>>
> >>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> >>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >>> ---
> >>>   drivers/net/ethernet/renesas/ravb.h      |  8 +-------
> >>>   drivers/net/ethernet/renesas/ravb_main.c | 12 +++++-------
> >>>   2 files changed, 6 insertions(+), 14 deletions(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/renesas/ravb.h
> >>> b/drivers/net/ethernet/renesas/ravb.h
> >>> index 9ecf1a8c3ca8..209e030935aa 100644
> >>> --- a/drivers/net/ethernet/renesas/ravb.h
> >>> +++ b/drivers/net/ethernet/renesas/ravb.h
> >>> @@ -979,17 +979,11 @@ struct ravb_ptp {
> >>>   	struct ravb_ptp_perout perout[N_PER_OUT];  };
> >>>
> >>> -enum ravb_chip_id {
> >>> -	RCAR_GEN2,
> >>> -	RCAR_GEN3,
> >>> -};
> >>> -
> >>>   struct ravb_hw_info {
> >>>   	const char (*gstrings_stats)[ETH_GSTRING_LEN];
> >>>   	size_t gstrings_size;
> >>>   	netdev_features_t net_hw_features;
> >>>   	netdev_features_t net_features;
> >>> -	enum ravb_chip_id chip_id;
> >>>   	int stats_len;
> >>>   	size_t max_rx_len;
> >>
> >>     I would put the above in a spearte patch...
>=20
>     Separate. :-)
>=20
> >>>   	unsigned aligned_tx: 1;
> >>> @@ -999,6 +993,7 @@ struct ravb_hw_info {
> >>>   	unsigned tx_counters:1;		/* E-MAC has TX counters */
> >>>   	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has
> multiple
> >> irqs */
> >>>   	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support
> gPTP
> >> active in config mode */
> >>> +	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in
> >> config mode */
> >>
> >>     Huh?
> >>
> >>>   };
> >>>
> >>>   struct ravb_private {
> >> [...]
> >>> @@ -2216,7 +2213,7 @@ static int ravb_probe(struct platform_device
> >> *pdev)
> >>>   	INIT_LIST_HEAD(&priv->ts_skb_list);
> >>>
> >>>   	/* Initialise PTP Clock driver */
> >>> -	if (info->chip_id !=3D RCAR_GEN2)
> >>> +	if (info->ptp_cfg_active)
> >>>   		ravb_ptp_init(ndev, pdev);
> >>
> >>     What's that? Didn't you touch this lie in patch #3?
> >>
> >>     This seems lie a NAK bait... :-(
> >
> > Please refer the original patch[1] which introduced gPTP support active
> in config mode.
> > I am sure this will clear all your doubts.
>=20
>     It hasn't. Why do we need 2 bit fields (1 "positive" and 1 "negative"=
)
> for the same feature is beyond me.

The reason is mentioned in commit description, Do you agree 1, 2 and 3 mutu=
ally exclusive?

1) On R-Car Gen3, gPTP support is active in config mode.
2) On R-Car Gen2, gPTP support is not active in config mode.
3) RZ/G2L does not support the gPTP feature.

Regards,
Biju

>=20
> > [1]
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
.
> > kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fnext%2Flinux-next.git%
> > 2Fcommit%2Fdrivers%2Fnet%2Fethernet%2Frenesas%2Fravb_main.c%3Fh%3Dnext
> > -20210825%26id%3Df5d7837f96e53a8c9b6c49e1bc95cf0ae88b99e8&amp;data=3D04=
%
> > 7C01%7Cbiju.das.jz%40bp.renesas.com%7C142c7f172b4141617e7008d9687c7881
> > %7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C637655706082218315%7CUnk
> > nown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWw
> > iLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DMiy2q4JGEZpwLHlkGxlEBK8P0XAPzuHUX6xi=
b
> > FS8nDs%3D&amp;reserved=3D0
> >
> > Regards,
> > Biju
>=20
> MBR, Sergey
