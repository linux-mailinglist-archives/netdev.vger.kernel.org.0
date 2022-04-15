Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3C502839
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbiDOKZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiDOKZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:25:01 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30065.outbound.protection.outlook.com [40.107.3.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613CDBBE04;
        Fri, 15 Apr 2022 03:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxnLk/2mXDWxIatgf1ClnbYvVY49KDVr4JCboPvNxFAUjFR2iNfPetV1L+jbE7s5Xa7k0PgUAb/SksgHEfjSxkpgHFNdUWAXXfcgY8fk4hR+s/rGX4mQ1+XbJqAGqSYgOAcqftliPvCIpSgdC3REnly8e+8kH9v+Iv4mCW04SpIr4f2X97bPheEwWmtVtVK3dmI0KFyZdTSjMV4Zr/VrlMz2SZNwhkipwROhuvFkBDJJ87k3DseyjRGh8fDQYtASE26F7NcVeW+xcUb9H2K3sm7iwXOrejcwllM/VGNVHH71pNmOUBUb5X5HzaNuz6OmDLqtZC8rpuEio8H9kolq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2fe0Bva+YyFc1k8S39XfJQs10rTDxfzUXU2e/bcwh0=;
 b=XjgRv0el/QetOtnmYUK47f+ntLeDx0Vhni62If9nBVVflrX5nUh3vWQdVr8iAQ22Jr1BqdOaw9Wq4XYc7CSDfKdMHo9lckETjksdgZOktt0wD3zJdZOma6dgUVC5DftamBPxeswnsTwVp3/wPKGwD+N85fF4d67tEoJ3GtIJEfAFqn5LNTigX+pOP4UO3WBOl7qskX5Sfg5zQKqgJr17mVAxaXFjJw/2kxP2fAbvmiuB1eVuuet8TSWjfXhD93zysw4ZvOmKyPMDtXi8SbnWsdZTyBxAbFYjkDruIi5TnTMOJ+ysX8Mq/Ja2Aover/2FJ7u6PW0PPgSOoWEWAhodgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2fe0Bva+YyFc1k8S39XfJQs10rTDxfzUXU2e/bcwh0=;
 b=nfw0C7aD9mR93rz9g+m+/NEJYh1kZ4dVDUta1OpHiV9JPk23aRXPAakJh9mHg5DZufqAshqqVSFboiVSfO9mHi0iCZlBZ6LdB+cClhiASQJsIm368p7TR8FcKIoZ2yazCz1PryxVpAv1gLV5gvnaMNxUj/c1T7e4LtgCbFQYV/E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3319.eurprd04.prod.outlook.com (2603:10a6:209:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 10:22:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 10:22:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmAgAALg4CAAAEaAIAAARUAgAAAwwCAAGFTAIAAqnKAgAE/VgCAACdRgA==
Date:   Fri, 15 Apr 2022 10:22:29 +0000
Message-ID: <20220415102229.zaoqqjxcs27ofdy3@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf> <Ylc3ca1k1IZUhFxZ@lunn.ch>
 <20220413205350.3jhtm7u6cusc7kh3@skbuf> <Ylc5RhzehbIuLswA@lunn.ch>
 <20220413210026.pe4jpq7jjefcuypo@skbuf>
 <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com>
 <20220414125849.hinuxwesqrwumpd2@skbuf>
 <CAJq09z6XTz7Xb0VBFdFVELb26LztFng7hULe6tSDX7KCQjzUmg@mail.gmail.com>
In-Reply-To: <CAJq09z6XTz7Xb0VBFdFVELb26LztFng7hULe6tSDX7KCQjzUmg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af7e8c4-979e-4825-86ce-08da1ec9d8cd
x-ms-traffictypediagnostic: AM6PR0402MB3319:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3319FA6770B6FD3F58FA64F2E0EE9@AM6PR0402MB3319.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z0M4vLkqphLUH3787fekwvmrwMJA9e5/2mBRdL0NBn9C2nF4Ga0e38Ji3jOheoDMN9+adpsUWfFBy0W3ejQdBxJ/wjXWqg2GKcZ4F1HGOcj16STPJ0sG4DBJAupJHjvME+10aA1EiXmXZwXVVEtPR76GI5zjzmxSi3O9sTRpha6f6Pf//PictwPhiX12eqxEOihCXdVspScT7SD3LCxRohvolYprqbb3ABlDWNnT9jasgmHc/9+Thawbtn0wG2iSAOqMGIo5OXScLAJNJ3Vj9QDyBYHwszBnv53/7vg9W1jbd9tr9d/u8Hs+WfSTQqCLaLjbLtlEAO/rgzKNMoi/0DTeB9Zj104eWkVendtbGcFdpJwyrZRr2WE3wFcMdn/n29eJvwOWW5Zv+QgE7hMhoZqu8JBddwZbMFTo2lVVonBfAbd34y0ddSfHRAWv9KGrbmgCR8mk9iIKTG7cKfi51g9KpIBxu/aWMaHqxQaSfb3UgPtNvZdUHiKF2EBZfMIzEWcIgTO8wHSDVjfa40zQJIyF5OmDa0fuQzRvz3p/F952mgZP6AtVPdjyDUWW8jSYfP8UN15W8p+KcPUzTlmsAUY+W5ZTOHk/jepI9NmJrHDlgv7yvvH0qF2bjSy4sFtucLg0wzSkhApR8tqfUBMdw4HjUY1i02PfpA60ndtn/9uSct0b11Yq2pCA5TVcetj/ph7GUPXQGTzo06ESKD9cToPRzAw8ZJB416+hxcwdLurXahPOk8X4ac5b86H3UpsczE4qQCBff+X7v5sdSst8I3navv4iRBNRIXt6hmwXThM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(38070700005)(38100700002)(1076003)(6486002)(966005)(33716001)(508600001)(71200400001)(83380400001)(66476007)(91956017)(86362001)(7416002)(66556008)(64756008)(66446008)(122000001)(8936002)(5660300002)(186003)(76116006)(66946007)(4326008)(8676002)(44832011)(4744005)(6916009)(6512007)(316002)(54906003)(2906002)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j88kJdFFKR8mjuZqpjGe3+bDPGxeuWvJs7+Dmu+wONBSulq3B6m0+ns7d6ZS?=
 =?us-ascii?Q?fGrRcBwdk21rIDieNtIuM26nVcp9PKm1E69j/awNHiblyCHpC9P2ZDdvgNQx?=
 =?us-ascii?Q?8nbdd2ll6/+IUfXQoeBO+wTKUtAc2fIZIjRpe7e8kifcFzNqdsGyKy+XKlbg?=
 =?us-ascii?Q?DiHafAAr3cRkvUnOY+eUQeEGzr2b/3w6QXHd9eNenQl6xDRZtbaK4bYIIlp/?=
 =?us-ascii?Q?gELQ4/0FLtH41UkToJtcwjy+j2AP7pcWf+tYQReueqYH3u0lAgjRM8V7p42T?=
 =?us-ascii?Q?HqyFEyw67NpNtaxPZ3dhSwrLDVCuoTw3KT5XBc4MewlHscH9e/2+HxAWH7Hl?=
 =?us-ascii?Q?rZCSP6xe1EgRjMqKoc8ggRqewz/5RgPkkPlwyrvEgzZqKcGtvA/jjXsOLh3y?=
 =?us-ascii?Q?eGgctoQiMh9UhZsTOmVL41dVgxQmvUIB8N5Id8hp7D4bp9P9dwLPA8mVE0Nb?=
 =?us-ascii?Q?hkShnyPBFkfYAkucGgWgc3l16GN8Lq0LUmZRru825WJ7gRKS7iDr9Anuxpi4?=
 =?us-ascii?Q?QZtNalZin+O4c5VODloWk84OfQiCYqgOMN8ozeVEgBHZgm9iK2WM9aIu8Ff/?=
 =?us-ascii?Q?18FyGnZF9yUGY9L3By96ReiANGyovsn+dZaPBUrIpX5RQXzoOaLWMULfrVS4?=
 =?us-ascii?Q?2Uy8tSs/Fhq1ynzceEtimA/cT5wbXc4zQXn3UK6J1+f56SKzj0WqAQDpkTQA?=
 =?us-ascii?Q?Tya/jEt8oMtyqYwoN/RolgFwly2LaA/gfjn7uryc9dsP4QKbvFOKKhyn7qW7?=
 =?us-ascii?Q?hWgPriVY3q9F2jUHc9VxD/4gKaXixVtXUP2WpVkxXYqbq2HF1MggkQ67B9jJ?=
 =?us-ascii?Q?U2ZkoMg0l/ydJe9r+CeiUsjwqk1w4ndxZNS6Olrxs7hibzMPEQBp+g7GWj9J?=
 =?us-ascii?Q?nGGaqpkFzeVJNGGdf6LJFtY60XgUMbnUTZ46WtVwGqISaQRdVqDHRdJKAanf?=
 =?us-ascii?Q?sjygG3jQeOe8XhcpP4MD+W0LxDy4WP5ZHIPC5WS4l5oqZEwX5a683EK9QdlK?=
 =?us-ascii?Q?9MsZd2gjU7JRyhltO+VUQdH0lKtZjhLLssvv16wlF16DZAdAyesf4AXt1nAM?=
 =?us-ascii?Q?EclU2VLYYH/+/90qelcTswsdf8F38qIZxuHfKR9buL/xpkt4nFk5MwjkepIg?=
 =?us-ascii?Q?WHLrFXF8gcAxCUzwH2PlFpxv0Rqy9FFNnAQEQJJFAwoAaTAkk05Ls8Notqd2?=
 =?us-ascii?Q?FYE2XmL4Q78GBUjMNiq5IfK/1RPQ2G7A6ONbQxcfMRFVluC+o6P/vWh91ieE?=
 =?us-ascii?Q?UxH0stKagsGlia7PjSi8LQnpL+p7fRig/j/AJIA6E5CFGZgH9fu24QEQ/9XJ?=
 =?us-ascii?Q?PtNuNV/j6QAsZOlySCCT30+zFr+YMzjOCXFb5wETPNhI6TXteQuVOHl7rZw8?=
 =?us-ascii?Q?sWO9W4AYqtIgCeJy5dYOLRGEHAreJBmUksFZOVckDxZjpT4peYKuLoQSF/iQ?=
 =?us-ascii?Q?nTRcbs6ORo6RpgkRaOosNcf8L9NZ1xp/j62tCP+KBEGAMe6P4SwrIag4VW6D?=
 =?us-ascii?Q?lofiPee9YpDAHgjjxZiW0hL3LZztGWs1mfUwxSEI1AWFHSrjZ1WPuTu2wrGG?=
 =?us-ascii?Q?l/Ocy+i9TlFlYXHj2HHNO5uyq1qdjlrWJhED1R9oCsfMPQxTQlhgVVds6mO9?=
 =?us-ascii?Q?6OSgAN+Da7mAQddUA/pRnulbSef4YAK+pw/5ObU6DpA6Hjip3GvF6iTtdkw4?=
 =?us-ascii?Q?NgXZzk3Qc4uUH3ujhljU5Kklp5pD4DcMc7dPcEdmkj81U8k7fh/y8bZzzKD3?=
 =?us-ascii?Q?Y0Sw94X9Bpws4Dja7MWczgc/aomNGc8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E9519CD748A65946922FA4E8F338A752@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af7e8c4-979e-4825-86ce-08da1ec9d8cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 10:22:30.0173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /LOisKeD3jn9D2n68+FS2hyghkTQt3hSmwCA5/RAwRW3lHq/g83RezgkXgA+2yRCL8kbe3PDb2qftuz9G3A8KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3319
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 05:01:46AM -0300, Luiz Angelo Daros de Luca wrote:
> That looks like a larger change.

Well, you asked what are the options in the unlikely event that we'll
see offloading DSA masters for tail tags.

> Should we put this patch on hold waiting for the code refactor or we
> merge it as is (as it tells no lies about current code).

It looks like the patch was marked as "changes requested", my side
comments other than the Reviewed-by tag were probably misinterpreted:
https://patchwork.kernel.org/project/netdevbpf/patch/20220411230305.28951-1=
-luizluca@gmail.com/

So please repost.=
