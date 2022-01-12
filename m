Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2548C19E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349570AbiALJvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:51:42 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:41918
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238931AbiALJvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 04:51:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4tLZMosm7JsCM0jthqek01l+sisFK+ztFlo9lAvJ6YI0OjXPymPRcZV4U4I2HQjpIDOy+ycarRxs2M3O9F16LABzfagXeYjO3HvUsL2CkiBkoTQc159V1mznVAOHw30je2ArWA2Oym3zCiEc66KuyBB1/8YrS/mhFwGueI2NBpv4fDu2hlb99IGrjH3poZLT9dRWt0G21nCiMkcR23kYvemVvkndjsS2V6MH0/omGr2qx2dqgnQghl+KyVqXa83WYOHq5mJVIYDh4hMC9oEJEOwphJZN+DN1LcO/jA9BEkwUCeiulGtw4jUTbq1VLSXs2FZQg6If2Zv+ecl/Cp/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8/Rcj7qksWxc80QpPxaFJ/P3yLApCmbm0qMbv9mKiE=;
 b=kmqoI7dDYLcSoIurAivwbFd/eZxWNXbZluQn1n/rYuLZuZPRnis2CtcDmjIi2arShNgxuhH5rxH+I1USSWxCwy2jg7E5HuDLoYZkLXIDQXRhcCTXHGdfLKddOYD19WR3oGDUPAvpDiuAswBQVanprQVSU766aURjS50bm/6pqyEj06lwkpbJN3YS7AEXRWwWwRzIHeWH/N5bDgcSEV+asPRPkWxhdlkmfiErFBu9KJbl/mJh6adyNvvjwL9AswBUYZJj7E9wq1+0Mh9CXaIS1QQ8oKe1ruJDaBhoaDFwA0TBMm/TzCFetlCTaYLU0KB1grYYGAjLgO6UJzH5iqfViw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8/Rcj7qksWxc80QpPxaFJ/P3yLApCmbm0qMbv9mKiE=;
 b=VWXSRwbeW2d9DOIIK4j+wASNSSlhxUI+vesBJkDOKNxxaizR28BWQv6NRBy6MMflADAul7b8ihzNvJ/cP69ZH6mnllQPoh7KBP+2UOn1S7sK6q3U537XqgpXTW5XB6UdtgWLBbLqUdb/sToTLzP9I8YAMHQLpGiviCQGT4PO9yU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5594.namprd11.prod.outlook.com (2603:10b6:510:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 09:51:12 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 09:51:12 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Wed, 12 Jan 2022 10:51:04 +0100
Message-ID: <12255658.RqvdlaKrbL@pc-42>
Organization: Silicon Labs
In-Reply-To: <Yd4CjAM+3/PmLSyY@robh.at.kernel.org>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-3-Jerome.Pouiller@silabs.com> <Yd4CjAM+3/PmLSyY@robh.at.kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::22) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0b5add0-8b28-4bfc-b5c1-08d9d5b11104
X-MS-TrafficTypeDiagnostic: PH0PR11MB5594:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5594C645C44A5121B208B66793529@PH0PR11MB5594.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5nR2V7HdTMc15dHBoj2O9L4q0+2PPwVKBgFrMoqkenKhaWhddJ079RwTtUgxWoKdSPZ7i50mGO58he3UAbRWsfiZrpkOgxFzcUBSXNys0wbivtatb5fbz0q7f7FNXOaC5RvN2UFNfYsOx+ORBPZPOhAKbKUxQcxOAZFeeIq+mEa/ouLcqUpqmzorAB8foBBTuwBwXioWKRn/JyZK1h0oxHN5P6gvQsI1AvoU8S8YUjQrIrYzQMVUIXmgbRdbl10HgVh3OCJEaRrIU9Sh3NGctYQxaWaimiW0Ol9lakMem1Uj7SyFtf44/w+udsXJfe6B3qLxACG5HHW8VYzhPSLbvtMCRRQ2QYnbw5Qu5zRE6BuGa7qO2P7hxmmCu9rFqfugRSEKowyzjBf+OKXSc//ZxbAi15XqNy/dT6FAmUlRALIg3aGS3kzqVOfkROWD1j8FIFNRSKjhG3JL5bi+s1natDtcyqcOxO9tTnx5AGHus2Zlp1h4Xn+npAPCboWiBY1spjpSNK/dV1IiMrzNWDV1kHlmUmLe8RN2SpZhe1CJH1r8pRr9Xi18z4tnb6JVx82hDedOZV8m3k4jgUDP1NzbJICnoO4cdTvaT9KUz3sMPd00wnAuYWCPMGeeuqItkzoDohEjd4YQAHBm/hhdtw9vFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(508600001)(9686003)(6512007)(186003)(8936002)(66946007)(38100700002)(8676002)(6486002)(66556008)(4326008)(66476007)(36916002)(5660300002)(6666004)(52116002)(6506007)(33716001)(54906003)(66574015)(7416002)(2906002)(86362001)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1GZXGRrQLRCMPKJWhsHBXgIxf4NoDASfWEZiDvIe3dJG9dcoRKMxkqgUzH?=
 =?iso-8859-1?Q?J6xpmYpj6oXx7RHYJNHqGGNKi879FfZ4ZGtfICnmIhgPuRSr61p3cePoN7?=
 =?iso-8859-1?Q?MidA6jUTGiO+3NL8WKgv11kth3OLaF1qLVtJT3TM68hPcbwIPrxYdkKZzr?=
 =?iso-8859-1?Q?rcuuZmZBypZj15BN7LvcZJ3EUblMeKVa14ZbZ9VgRfa1duOMZFtJPjB+CD?=
 =?iso-8859-1?Q?BynV/vaAcCFkp41QXiKeShpwuU8+b3Uy6zoF+EVbYg0GYN2pbLAMvUTBDV?=
 =?iso-8859-1?Q?o3ionqvt7/FPNvO8vepz1Ht3pLM6MrIQBXcv1H4ovF9Y6DU0P5JCQpmVUV?=
 =?iso-8859-1?Q?+yCSIY01DY2ew2J1f5z4yDG3SBRCZ5hm+93jz9qDO+r2W2POeLW3SkhCmH?=
 =?iso-8859-1?Q?BalFmzcmJc2o192kh758nVZGdKAjWWqhqRSpj0ys7q5B9yBoCeec+Zdcn0?=
 =?iso-8859-1?Q?5xw2yohRHfvxNpwxyMO4+4lAOgwvBThYXwXMuQiYOXvesNTXN/xHjo6YoO?=
 =?iso-8859-1?Q?vELiXf5hRfOPQLAznR/G8J5U5Nt2YCAm5DbyUW42/nbT3gbJnKKJpyNHSc?=
 =?iso-8859-1?Q?TWKZdrUWi0UfwRUd96/6Mx44UQHuhX+ZU6xL2dwqxbQx6cW5/OUvw6pKsj?=
 =?iso-8859-1?Q?cu8LdWW5QK7NkO58nd+YEWtzNxzk2srq+hUvfk4zzxuB656E4FirsiQLeG?=
 =?iso-8859-1?Q?UyJhvuUMASHIN1RMs25gIRB8BRh2jsSbBx5y+KGoMU5e6mE1UfVAWytLmP?=
 =?iso-8859-1?Q?LfeqVkbU/qXXVh+9kYC8fcQTR1BOZQ+h4yrbqlsrntA2/xUuCy15ywiQYr?=
 =?iso-8859-1?Q?Zq9NgMKCrVoHF/+IF4AG4HYfaIvvgo9+7ORmQRha02+v3sEHsd81fDK7Mx?=
 =?iso-8859-1?Q?nTVQKXsU1TGLeBokgfWY3+KTlRqtFpLCtp82B0e2lJxWfosw+ThHa2+8v+?=
 =?iso-8859-1?Q?lvACBL0dWyvYpWlZkK3WcFCVZmwDvs43dre4ZCoZtQbXVRjlq1B4TvwDYZ?=
 =?iso-8859-1?Q?5FqVGURBUGat0r/UN21yWDOwZF9PPiYHYqcNnOmQYatXdGVpK9uj8BYjFR?=
 =?iso-8859-1?Q?OtWVfVpDqBH9kV+N8VA7xDyKOp5KlIpUVtpNb3pMEyvcloth+GdsFblUao?=
 =?iso-8859-1?Q?UL2JSABUh/dLm5JJAf9Uc2bhNKUsKE1teeMk8nziO14cedAbuzQOasa7wT?=
 =?iso-8859-1?Q?eomcNysWGdxKcf1GS6TTfrsdJdCVp/cNMDc/lG6/+tOJVaX+gQsrKGhFr/?=
 =?iso-8859-1?Q?gNnF1aSD+R49I0xoWXDSKS91YItB9NErOEX3E1XgdkZIzoeCwqQQdOr1dz?=
 =?iso-8859-1?Q?1fKURc7AQujWISlrePfPH9gWKjmqIcg76lzzq9WNc0xwABplDSHwO9f9Q3?=
 =?iso-8859-1?Q?KbJR8Z8c67c6tm9SBvtMV5L9sbhFGClILKB3vMT9S2vyT+aJ1oW2sOK+Db?=
 =?iso-8859-1?Q?0oc1bjbQIzm2ZD/h180aGUaIM/BFuzNlML4UnuKYRfdYwYqAmaXK0/K4K9?=
 =?iso-8859-1?Q?zg7JavTD6yPTPyMvombEnBJ0TFCjzkaRtjhz8EKy78mbwgC9FiSDKcHRSR?=
 =?iso-8859-1?Q?zTM+B3YsmZQcPeg4uWD8TZSIwWEHEf9Nwr2uL+Wkoxhq7Wi/j5La9/mFf+?=
 =?iso-8859-1?Q?sPMVd4V/UMI4XgEJwKPgEI9s+pAkW1kXgjnpRlV0Nnj357ly6bNfJsDaBZ?=
 =?iso-8859-1?Q?F1GIFie9giw7mlKk/90A1r3BIoFsfj2NXv8DepyEil6r+TpyXfM+oO/BoV?=
 =?iso-8859-1?Q?qQAlT1CMwl5DoiL7b1/Ubiv2s=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b5add0-8b28-4bfc-b5c1-08d9d5b11104
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 09:51:12.6083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bT9vkrQEQZknBRhVJF8DrgUa4KQcuBBJ3/wqM2ZVHHa8Weytg7j+NOdUAcOxuFWnZtPBy1UB/yNZkopKDCjhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5594
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 11 January 2022 23:19:56 CET Rob Herring wrote:
> On Tue, Jan 11, 2022 at 06:14:02PM +0100, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Prepare the inclusion of the wfx driver in the kernel.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  .../bindings/net/wireless/silabs,wfx.yaml     | 138 ++++++++++++++++++
> >  1 file changed, 138 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/sila=
bs,wfx.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.=
yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> > new file mode 100644
> > index 000000000000..d12f262868cf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml

[...]

> > +properties:
> > +  compatible:
> > +    anyOf:
> > +      - const: silabs,wf200    # Chip alone without antenna
> > +      - const: silabs,brd4001a # WGM160P Evaluation Board
> > +      - const: silabs,brd8022a # WF200 Evaluation Board
> > +      - const: silabs,brd8023a # WFM200 Evaluation Board
>=20
> This still defines that compatible is a single entry. You need something
> like:
>=20
> items:
>   - enum:
>       - silabs,brd4001a
>       - silabs,brd8022a
>       - silabs,brd8023a
>   - const: silabs,wf200
>=20
> You need a separate 'items' list for different number of compatible
> entries (e.g. if a single string is valid) and that is when you need to
> use 'oneOf'. Plenty of examples in the tree.

Ok.

[...]

> > +  interrupts:
> > +    description: The interrupt line. Triggers IRQ_TYPE_LEVEL_HIGH and
> > +      IRQ_TYPE_EDGE_RISING are both supported by the chip and the driv=
er. When
>=20
> Unless there is a mode you can configure, supporting both is wrong even
> though edge will mostly work for a device that is really level.
>=20
> What a driver supports is not relevant to the binding.

hmm... right.

> > +      SPI is used, this property is required. When SDIO is used, the "=
in-band"
> > +      interrupt provided by the SDIO bus is used unless an interrupt i=
s defined
> > +      in the Device Tree.
> > +    maxItems: 1
> > +
> > +  reset-gpios:
> > +    description: (SPI only) Phandle of gpio that will be used to reset=
 chip
> > +      during probe. Without this property, you may encounter issues wi=
th warm
> > +      boot. (For legacy purpose, the gpio in inverted when compatible =
=3D=3D
> > +      "silabs,wfx-spi")
>=20
> What legacy? This is a new binding.

This driver already exist in staging/. But, it is probably the right moment
to drop this legacy binding.

[...]

--=20
J=E9r=F4me Pouiller


