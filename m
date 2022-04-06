Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A44F6C21
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiDFVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiDFVI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:08:58 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305C3E29EC;
        Wed,  6 Apr 2022 12:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAF04dFHYpl7kDat3ipJghTR4mUhPcGBFCGOOwYMhDhMsICYdR3rIyPkr/1GxeoWogZAZrq5K2AtJEiNp0hKuW8BMUfpHSnTNVOLHY1jIyliVidOv1e7j4cz3mnG7cFxnx2jwqPuatPgKcRw1u1wTyDKHTsPAJ+85nSiEQ0Fp1VceZdeuogZ4dWSE8XTh4yLWwFVFM3JLPBbspoiE6h8qY+i1sNvy5FMo0bc98tndORWbjw4XaS8eAuPnVe7g9CV2ys25jK/ltN4e0uNXSLsrfFSZEBT4gpZFSuUi37W337k9lhn36EKYnYIJlWzrg8eIpbc9Gh2Te3kBi8RSqlX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fu7StXOMwFkxbeA2JYTTW5/+F4CC319d2kKqBe+JTDI=;
 b=ZIwgh5aCi1Qgr7M1lI4B0/NSZ1Fy6Dgk37sIg6o2LHV5I3YndbXqvZPJ5m1O7QJ6pC1NMWXoDXP94ob7yWYhMXBKt5Ro2rtDLqJsg9xwq8VEPYLFoQgTXHaDs3lX6L7jF8uhidcNho/TehW8qJUJOcqJwgRpPvvarfy3WT7eMk/ryto8i8qHqD0qa4Ca+PML/HFtlxW3Gq69mHo3iypIS/oNtBHE6KKx5E7jlejPgVyZ09cjyasifc8tuct0/yWm3sI/9dkAYoRJtWVUG39HnpreHBB8uEui+z05q6D0HBMH/2gzPngPo/TEb1j/oBjiNzASCrDP7voA94nnYr3qKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fu7StXOMwFkxbeA2JYTTW5/+F4CC319d2kKqBe+JTDI=;
 b=Hp4SzY+KXKeqCKYyqzVyCASRbpxUaV+yBU5ETezDmy2iD5YVl0Gvf35AX6Z8n7LqDEEmsbvfaFtJ2qAc9MlF2Utk0RStioYTgodpLzzJ7TIhhL5rUKY0lxGaWFBeDF+J9NgGmLeOgtoZVhVdUBHJvcT1Qptr5sENnvIgfWPhAAU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7492.eurprd04.prod.outlook.com (2603:10a6:20b:282::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 19:47:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 19:47:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.14 1/2] ipv6: add missing tx timestamping on IPPROTO_RAW
Thread-Topic: [PATCH 4.14 1/2] ipv6: add missing tx timestamping on
 IPPROTO_RAW
Thread-Index: AQHYSezApD9O9L2JBUO7kEbsphrFo6zjSdEAgAAAi4A=
Date:   Wed, 6 Apr 2022 19:47:11 +0000
Message-ID: <20220406194711.3apwre6dbzbtw3ou@skbuf>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
 <20220406192956.3291614-2-vladimir.oltean@nxp.com>
 <CA+FuTSdK4T7DBf9wi3GjXA6P9o+6X-7c5vh9V0BN40GwbKSeGw@mail.gmail.com>
In-Reply-To: <CA+FuTSdK4T7DBf9wi3GjXA6P9o+6X-7c5vh9V0BN40GwbKSeGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3f023e-a4b9-41f1-5bad-08da18063e48
x-ms-traffictypediagnostic: AM9PR04MB7492:EE_
x-microsoft-antispam-prvs: <AM9PR04MB749226F6ABB8B83E9708A33FE0E79@AM9PR04MB7492.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: er1wHs1ruiIMs3wAYRWXpg4N9xciVPDHY5xalX0AzQT4djx2po04o4K94F/cRiRIrFhxSvoC5Qi3PnUvrrS/j++Y05MgsFphigzYZ/J9eYHmvlW/CkgrtUsqn6JqqSU06cO2j61CEXqUcqSR4eQEQ2zyAqX5Y9mUvXWITmpUu+7ZjI+4x1AKAhB6IE1lvCtORTe2NXnOhdzgBF9GNRDgfYFBoBJNSTniJWt+91B0acI1Fh6xfqexqXsXBkSTUL8xAJ9VT0+vbE8MNywCHoC8ok59KhHI2WtjkIBpeVPntpBeMG2IxZLtLWACjRF3u3Aii5woKqIyrSTIIw8tdnj4QVEFeT1hZuwF5hElt6LqBhAUJS4MkSG7ZyZOd829TxOuVMMKRioVH3Z48OGC4F+6vOo668pTQTJjB+3LC6FfJ3lgvJ9H6qzfCDKY62qfERPurReEOPfh8jCcdGVBBaYRqof+twM7Y2KkxWfDuxniTV8ponScCPjO5RmhA4iRV2psi3shReARJk1oudTdEcFj5ghv86rnu6A4gPxIt4NFJbPu9HPZn+FIFobF78eiWFzf95zsq7/5u5VijYvq0+hXgHSMsxge1MwiTLGf59568YIxmYC8ZEbv34ZkaaONUHrZAr8cF6eB2jzqOgPOZEXTNzAztampqkRhsVTXW1aBvHj9axtV8Ra3cl5MpjZmhcAWVOw+ub2+v/PkKv0+kZAgAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38070700005)(9686003)(186003)(1076003)(6512007)(38100700002)(26005)(44832011)(5660300002)(2906002)(7416002)(8936002)(33716001)(316002)(6506007)(54906003)(86362001)(64756008)(66446008)(71200400001)(508600001)(53546011)(66476007)(6486002)(6916009)(66556008)(122000001)(76116006)(66946007)(8676002)(4326008)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V4VyWWZL+b/3ojtj9jh6CHCAe+DrZUSu8NwWjG94sAa7bSnmAcF2RMgzi+Fs?=
 =?us-ascii?Q?LXiypfOO1RhH6kzuiIHRBBZ604gJYUOC4SAG5i7BFfF8fIzFpRAztO7yccQB?=
 =?us-ascii?Q?zfbXfHRyUvHZsOcaI1lKEsGRtBjaWQGAJMFBRl7Rgt58rYr0qvqnGv4gUgsB?=
 =?us-ascii?Q?mXqCWjQCVlgcgosV0wJqSIv8M8vxVENLAqtFeELwg+pl6pTkXHMQ/MuctDLo?=
 =?us-ascii?Q?QPT+wirmDfGY2z5pk6mZVE9913eMsM40XzBSy1xwRK8kfxvaISep6UTedemT?=
 =?us-ascii?Q?1lFQsLkGzQVCvtYsfsYPf1dhOPttNlk7mDAoX7nWKhw19FZLlwHasZHrNuqS?=
 =?us-ascii?Q?kAq+qkPwIDu0dwBGrCK0Utmcw/VouC+drI5RCemuk5dcX5tLby/YBp+eWKZm?=
 =?us-ascii?Q?qrujjKJx2PVwozRiAyqbNX4jbE36GIec1rWqS032PSKcysYyIAzHFcvBbdVW?=
 =?us-ascii?Q?4tGFy0c3ElveM+xpFgRpkIZvfFi69ls+lJ4ubSMGhHEQmVXvmgc/oMlmtKyn?=
 =?us-ascii?Q?pY+YseZL/U44xxkz8LtCxKGyKTp1uEjfamf+ZSs2PEjeqSaiKlPz9t+x1iR9?=
 =?us-ascii?Q?KL31bqU8e7XzBxWs2PyFC6wXmF6QeDUj7ePmFMcANh8Bj7oizwqekvkkfdCU?=
 =?us-ascii?Q?M8+v8/t/KMTtkm1u7ewK5EI17EvMuOL5EfoMSynJ3QJKtXyAQIoAUazZhkCL?=
 =?us-ascii?Q?3KM8id/CTsd3KMOOTsVRszSOGmse0RiQeDYzrCRL9q5izvnezDhYmyuR0ZUk?=
 =?us-ascii?Q?aoS71tQdDAi0Z09VGUiGVxOh7YyD02F/54HHvH2i8CTqISnjqqDSte4+D7ME?=
 =?us-ascii?Q?E56BpNKhF5NidiLUCr4f6oMmhrVRsVVAYu8HU/CamhLZ1kQjVwNS9Phh6xL9?=
 =?us-ascii?Q?IMVGeE1qrJjlIPHstO2U3NQMkBg8l9p+QbMm4rNEHf43PWmqpLbuN7I4y0yV?=
 =?us-ascii?Q?W1bUzOuEGKK51H3e7yvAD0AQDiuQSvHYB80b/B3rtwP6LYTX9u+/5YR6fRBe?=
 =?us-ascii?Q?0slmnKGzo8cjRcFsJx38oJXDU4UPESJngkSQbceTCWN9UVmSF8n4nfPkSlwq?=
 =?us-ascii?Q?YhGrsopa/2dAKA213KpTC9aZYZfbp5ES6oivPZCSkeUHkid+2Of9q3gfKQLN?=
 =?us-ascii?Q?UXP42N9SnQmbL9Md2dmsOoQcIhWosnucZSGgj150M4iDXDr6AOEDDusliukJ?=
 =?us-ascii?Q?xgnJuaEpljOPep6OVnF1W+REk8rDZTGW2339Puq7pOniZuyOLv7C9DJeUG7U?=
 =?us-ascii?Q?7EHJv8Nh90pPoBmgxN9wfDu7KKszJAIQj7bsG1HvdT/UNTbYfNUJI6kTw4j4?=
 =?us-ascii?Q?YZ7zDGjJJQumJ2Mf7FmzRCDhpRXfSkxfgw6iiaz01o4qo1hphFCNWbQrekp6?=
 =?us-ascii?Q?lTSzRrpgFwQSqpmODo0+IvowDrYMUTVmjAM8+SRpUrj3XBjPTlzpHNPBQO9Q?=
 =?us-ascii?Q?CeGOAXGcg7q5E+QqcddyOAWjhxH0Y/JFdK/1N5BbHy6kuI/apEMNqtSzPD+J?=
 =?us-ascii?Q?k/mEfjQH4VFrEYk0H6GDb6Zu7LlA1MgmslAlcB+Ged75BIKe16M0o1wuaovP?=
 =?us-ascii?Q?MgZjP3rU5RJj/xi642yhBuWBb+hqaK1sgZLyzErG6lHo3WFV0aPjmby9DOUo?=
 =?us-ascii?Q?FH7CXm/UmYjoJALkmehwLR0DL++ZHBNUQR4aaDbLblqGJcvGQjaVI81XHlcF?=
 =?us-ascii?Q?+KdiVZu2Y4FZeNUBK2PnXzaiQibhj1sIc1xczLGwEo4XLxAxaStS2tGJvVOR?=
 =?us-ascii?Q?mbbyfBKqcoNqSDEm8gvFKbQFQIrphHA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE5CF49071F6B247B6B440FEA8BBD1AC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3f023e-a4b9-41f1-5bad-08da18063e48
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 19:47:11.9208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2N45xVCUBJez81u/0tguDi8iyikIekKPe/NJykAlx391YMJ9VJkweZAEaBd95wECyRrK2Pb3NyozKimdXeIdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7492
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 03:45:14PM -0400, Willem de Bruijn wrote:
> On Wed, Apr 6, 2022 at 3:30 PM Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > [ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]
> >
> > Raw sockets support tx timestamping, but one case is missing.
> >
> > IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
> > has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
> > not. Add it.
> >
> > Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> For 4.14.y cherry-pick:
>=20
> Acked-by: Willem de Bruijn <willemb@google.com>

Thanks.

> Might be good to point out that this is not only a clean cherry-pick
> of the one-line patch, but has to include part of commit a818f75e311c
> ("net: ipv6: Hook into time based transmission") to plumb the
> sockcm_cookie. The rest of that patch is not a candidate for stable,
> so LGTM.

Point out how?=
