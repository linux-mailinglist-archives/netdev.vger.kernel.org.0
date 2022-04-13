Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83F04FF0AA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiDMHj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiDMHjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:39:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2075.outbound.protection.outlook.com [40.107.20.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9754B6334;
        Wed, 13 Apr 2022 00:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic02qnISjS35wwyOhDMcTTF+r1iJr4aGUXa39wBQQAlwDh0SIVRetUAeU6UatsMoh1WPL7cfyhXL7S1X5Bj5Og3wdQc/CkM7bRF0prBYuazPffWlmEzylis98LX2eAoNNuhxHl9UC7+3/0LXom/ERIQ5Xq73a0qM3jx0n9aRy9dmVH0U++sg9wTXSFoZ8b6lBpQ3/ZX9XO/E/xdf0AzG3RmW+dbcCd/sjYnz2goJMR3bTIfXIRlr8DDcLbCenundBm4GYnvxUfEZs53d6Ug9M7n+PQzTbXv5QRdGvBdHXkP27mNbWXp3NbObg0wZIzuOW9Ht9h7o1lIHjGRDcg/bmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LdZFt2J5tAkBuSwrov77gmOkOz1PArYQ9nJ7qMaHGs=;
 b=lM2+Qy1cQcGm3fOymR/mgVdbyLI/k276yNGCeGmxaqAlD8DYAb5GP9xLnqzWSX3ddU4LvqsfvRN8CfHU+Tb8vVofVcNbgRGHO8MialXdoqiefyIJ4tNj36M3mw6ME9/LVikzZsWRGtwwOZajpr3+tWrTbWT08nzuLF6cM4HLAmAn1TetyU3gIfNVA8dsq603VzDQy6hnaKokiG0fejZvoqeGdvVSkRpkqHyn+A9PmNiYTbHjTCVYXB2roTGRMgg6/bytbDyrku3cfXsiv4+Ohn3Cyj+zHqN9MPDJhT0elsr87BpKqoSHTvLIWBO0i7tdOxxvyU5g0bVK28xgkaJkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LdZFt2J5tAkBuSwrov77gmOkOz1PArYQ9nJ7qMaHGs=;
 b=W6EWWVq0BLtmAWfUI5OyCLio3eYF2bWvE0wJ69a1flgPX5jwwRGaQp9ReGcB1IpGkfiERo3tHffENh7nG+HCPGFK7BPme4VPuw3aAvL8sxAtrF3qe2jbgIe5yveIewAWqOnIkLV8N5sVqqxB852/pO+24NYbae0qbHprMyGr+pY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM8PR04MB7794.eurprd04.prod.outlook.com (2603:10a6:20b:247::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 07:36:58 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 07:36:58 +0000
Date:   Wed, 13 Apr 2022 10:36:55 +0300
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 8/8] dt-bindings: net: dwmac-imx: Document clk_csr
 property
Message-ID: <YlZ9lyniw+4p5RsT@abelvesa>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
 <20220404134609.2676793-9-abel.vesa@nxp.com>
 <Yk3WHSr+OGRxYCg0@robh.at.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk3WHSr+OGRxYCg0@robh.at.kernel.org>
X-ClientProxiedBy: VI1PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:802:2::44) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a66f7bb8-ff8d-4873-59cb-08da1d2063c9
X-MS-TrafficTypeDiagnostic: AM8PR04MB7794:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB77945AFDA4110522E1681570F6EC9@AM8PR04MB7794.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7B4QyQsadHod9851XHUfamLTOFYFVPJUQurx9VKSRa6YRwELtybTeEwQ4c7/GD7k5uN+LSVVIEh4JlK2TmwOWzlP2cmeyhuoDRY58omp+YEuONBlL6sG7138GG6AhH41AAxrWq1Hai0uZxUNIQtl3ALrUw6T6RXig4NnSIp/DRDUF7oK1o618TrIK18LZKfEEF9o1fbIfk3y3WUUuYlgSXJ9LzYwY6wuPTXEYeGDWWnqsW9OCF4EEbEFdZZBB5CRtHWuq0prItHNZP7Dqmvn6i9wq6DIm+UjLRJ3/6hQ7HAiVJZvvRDpCGa1uyfTHOIt8lZ4cp8XcIkglHBTIIogQ8OzcxWbMrNh4ZfWog6SXv5++QmY1QVSg6q1Mqb+kGQNnVjLAAdP/xtT60X9q26hbS2c8MB2dxRIRoQYtLUJYEPs4RumMvKG1XdrhqZfwxKFe/nfCtuQGnXZhN5erBmHAXmuSSXSz+UCSBmlSdOVbWnmTKwHMenrx1LA6dx8sbpZt1s4C08LjiKiLyrnC81r7ktsh7Puevw9qYRoclIvst/xSKVVxXLLDwX9sLP5g9i/9DJY4ZEL9w6sjyZaUySiYUI4rnged6/2X2yTInCUjLxXL4sILhet8j1/Ctxl+uba/GirAob1YpsbplNWRuSO8hwO9XVRPymehwNcpeBd29Lqol6l5HfC5XQV5VMVhVHcHVSjmAv7d4xp9ojSzdgfz5fuFqVIqdGs9LVVG/abvUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(5660300002)(186003)(26005)(4326008)(6486002)(83380400001)(33716001)(38350700002)(38100700002)(86362001)(7416002)(8936002)(44832011)(6512007)(53546011)(52116002)(8676002)(6916009)(6666004)(6506007)(2906002)(316002)(66946007)(66476007)(66556008)(9686003)(54906003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cA5n3LQOzicqHdBthahkkYwYgmQaGz5ATvr0XQjLbrVXjl72Y5Mtp9I1CWv8?=
 =?us-ascii?Q?GS0x1nN6D462Pjx+YZSme856MSzoNTc9e8Q4N5lcUKA9TBTtEl1Ppcno1fV1?=
 =?us-ascii?Q?qK1VEFry4diy20ESQju9rW/oR2hyD1Alvr8KdcXv+Ntw5Bd0fe/MgbB9j0e5?=
 =?us-ascii?Q?moS+rJDbbZvsA7g8RGFaslp5ujBZUGhiY1KNODosmSYfiMRUuuxH17jU2mcY?=
 =?us-ascii?Q?G3JSpE3uBm/iuIbvNolZ4WzsMmE1uXuSkOJjtg5+Nw5Vyfz4YJxlIM0EeokV?=
 =?us-ascii?Q?EarnMiAszelwDPUjTZR/qMWDaq8Up+k0FEuaRbqEkE19yyIgpBOCXWZy4p2w?=
 =?us-ascii?Q?io+XdIo4wC/PUlZkpHTOm0uU9bGmeyPX6mRksR6L25TTDZ8jLujYaOmdTXRl?=
 =?us-ascii?Q?eRBZYYJQ67uzzdZxCS1sIig8A667PAa09GlE0VnUBjDe7qrcYKFMlgAURe8n?=
 =?us-ascii?Q?HFmhFpKz7nrNi2jLTdB8IQBu1Xoig1XUoHDL86yrpU+WGsmN8Tv07eq3dx7z?=
 =?us-ascii?Q?vK15b3T4XkR0fuFdkWWGjYtkXe+geHpxybP3izjSHpx7xmVdjvQ4r4jeCWL7?=
 =?us-ascii?Q?uGJC9MlBcixbc8LSMKk4JKfbV7/4vVHOAifsVzEui50CDvLfM7Oz8QZzFyAg?=
 =?us-ascii?Q?ZxMUsPZiZS113qgZM5yZFWectM7rB0ubhzg8TpVhvCf42JKDzzQ1z4LJEfeT?=
 =?us-ascii?Q?2EgiiUHWr1PB0Lkdhs4Q+cw/vK7ok9oxHD3ehF+YMTAJvgAkwWRG9W23Qf+F?=
 =?us-ascii?Q?cxvEzOLt4by/5J6XwdDDXzkACyEg7zTJiM/J+8pAehtkvJQubY5XW52W/mTA?=
 =?us-ascii?Q?0sIqMY46Jpl9WoXx+j7wNwUEXf+uIRd0oon8D2kNCQQ2u0DNWBvtFahfXwz2?=
 =?us-ascii?Q?OxNuOhGJTj5GFOpuEj2XBGw7TpA7bMcVn9yr1HSqkUjOy+mC+GoUw5rqaoYk?=
 =?us-ascii?Q?EUZ1xOFIqMOXHFl+16Y9Fjd0Xxdyg3yeyW1En853jjomwb2Hvvquqzjyy6Vh?=
 =?us-ascii?Q?3JvRhH7Chfojwg8mEc2E297nPtFa9qxma3FcHh2TxMtlr5d//JxF7/gEAf+i?=
 =?us-ascii?Q?v/m7U8K/Cw1pRnkGw9CajNtigR9A5mU27SsG9rqCtIleElmBojoyWYjhweni?=
 =?us-ascii?Q?Kt4e2gqQQ8Gjl890MpEUWFT2HjtMWPVIj69NAj8L6KkMzpcch7Il8rYHx50V?=
 =?us-ascii?Q?55vCAKaPdckvdiDWQL6ttCuNZ17fjGfLEmMzeviE2hrAFL2mRkz108VtjJE3?=
 =?us-ascii?Q?/eyS6O/uTLhC9NpxdwT5qCbD6ZvId3KlrNiucsfzIA34vOUVsK6HU9uXdpK5?=
 =?us-ascii?Q?NUsH8lrQyaStHrdU8pGa28KMKc3LYAwPiHA12x3DFXtCz6Jd52gjs2av5UwV?=
 =?us-ascii?Q?bsjE6UKsl5g0Wrd11/L9R5ehEw0k42ixHyYB/Z37opXSdlY8sS8DX4ddoh3x?=
 =?us-ascii?Q?n5ufCL3eoc8VjCCGBeflcP+cJ0r62rTfjccrFfSbasyt2aRAa18ww1FUH883?=
 =?us-ascii?Q?NEG8w39dX4CimSsXvG0TkISVoiyr7ctrlbJJSSLpBDJ/0VaxBOEsQjbUcBeC?=
 =?us-ascii?Q?NRp7V+MkyNDKzj+TWWYcRhoePUEp8iuqCaDFZ6v05wjV3pdWDPDS4DNT5jM0?=
 =?us-ascii?Q?dR/vnQ8r2UJ2/WoGLEXIyotaYJV/DVQLQ9vDmiMc9C6gPnwRomRBmI8PaTaK?=
 =?us-ascii?Q?zxH+dwYHI5qYDFFF2jyQ5Low/5uWCl/EwNqa7ZBJSi87ZQZtj0GdWxdQzC3B?=
 =?us-ascii?Q?6O9h4TYubA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a66f7bb8-ff8d-4873-59cb-08da1d2063c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 07:36:58.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJzN/yqvAHsbUCMlPlslMJ4VCccWV33Hvwxw3t+0TXxajzCSPSFSUd5RhOx718EJQ0eBuxIZQlNJ6z+XPEfiWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-04-06 13:04:13, Rob Herring wrote:
> On Mon, Apr 04, 2022 at 04:46:09PM +0300, Abel Vesa wrote:
> > The clk_csr property is used for CSR clock range selection.
>
> Why?

Well, this actually documented in
Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst.

But I think I'll just drop this one and remove the property from the
devicetree node for now. We'll figure it out later when the ethernet
support will be upstreamed.

>
> >
> > Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> > ---
> >  Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> > index 011363166789..1556d95943f6 100644
> > --- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> > +++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> > @@ -32,6 +32,10 @@ properties:
> >                - nxp,imx8dxl-dwmac-eqos
> >            - const: snps,dwmac-5.10a
> >
> > +  clk_csr:
>
> s/_/-/
>
> vendor prefix needed.
>
> And a type is needed.
>
> > +    description: |
> > +      Fixed CSR Clock Range selection
>
> What? Explain all this to someone that doesn't know your h/w.
>
> > +
> >    clocks:
> >      minItems: 3
> >      items:
> > --
> > 2.34.1
> >
> >
