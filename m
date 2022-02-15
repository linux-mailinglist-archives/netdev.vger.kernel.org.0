Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B478A4B7205
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiBOPwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:52:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiBOPwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:52:16 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20043.outbound.protection.outlook.com [40.107.2.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7905D9D4E3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:52:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fhb4vprAWpVGJZ6vsbUBmFFBdzFT6x444lKAYEt6UgUckmOnLuRZtx7bT9oZxcHYdSNVIzHqI8XCkXTMGTa+OxejvZOWUOTNBqmGGo3NtM9RU6eNll9xIBXfx9/kidj7sy6EFD/6BIQkb6hde/1Qr/CgHCu9rzLtKUCn06I3Z1BPJTk5ZBx98T0GZV9UR9pHZLt6cW39QSB5DvUicQXY5dl3pN69irdztn7RGxIHu+2gCXL+S9xoOqdNqnmA1H+ucOmXlGca1ArD5wlQ4Pujhxo1zMkFstQpf1cV3SzoFb75Zr3zFk2nxSHe40sDEkGsw7Fxliir0GVYip/MM59AtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWUOJY4L0JKv9Rk4hR/m2GqtKa0Iw1un7NfFhfK+deQ=;
 b=kBFzrHzvy+lsqTie5DcpX3ebk1YjsWDcXIsel5Ot+zvSH9QOBlP+gSoxEchJOzteUrkDlSAzTFbI+AIf4/QupualUcIuWC3A+VJP17Hn15VWW+XQYK5CTYFS1QT/nRINVlLwd/WaGGf3nBMmFEKFroRq/slEMgBACpDbcmkdcw3X8d5mNQs0XjJwdkjCLwzpHtfFSncehNMvELnYf0s3MVH0O7skcfPkTBXJ1ebIGLyWsIMAD4HDB9uTUA3173dZNCcZzrl8jFykKA96tb7gPP2yrvK2F6jkA7pQwUMWkzueNKXMAzbWJTSt8pOJO3WUSlaYF8CQxqvLc4mK7OvAFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWUOJY4L0JKv9Rk4hR/m2GqtKa0Iw1un7NfFhfK+deQ=;
 b=IRdO/Y1gkjfyaJwbVRxfm+zbT1rZTlfv9O8ZxbU/1w1miJj7ow+nLs98rYy6kSGsAt/BLlMo/5bqza2UNFo28ldght/btkXjrCAwVZF/MgrEh2JMTDuIqYQqzeDHhMmgSEIcbUdnAD45nl+EEK/3i3w+ylO4Ylhen9V1bZj9Ejw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4525.eurprd04.prod.outlook.com (2603:10a6:803:6b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 15:52:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 15:52:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4CAAAUOgIAABQWAgAAKo4CAAEtkgIAAAegAgAACAAA=
Date:   Tue, 15 Feb 2022 15:52:02 +0000
Message-ID: <20220215155202.vfrg2xbxtetpdk6q@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
 <20220215103009.fcw4wjnpbxx5tybj@skbuf>
 <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
 <20220215153803.hlibqjxa4b5x2kup@skbuf>
 <49709ba6-7f4f-493d-88c9-553d7c300397@nvidia.com>
In-Reply-To: <49709ba6-7f4f-493d-88c9-553d7c300397@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd5d0f75-209a-4583-0d0d-08d9f09b1c02
x-ms-traffictypediagnostic: VI1PR04MB4525:EE_
x-microsoft-antispam-prvs: <VI1PR04MB45251722B3C3E4CAB1A373FBE0349@VI1PR04MB4525.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6H6vKAy3UYfa4QkPFl4TMAQd0Sd7Nf8pcIO/ne0a6dFMuC130wqwuL82AvJpROyCkcnIi399ehrO/gnZMVdqUue9Y9wzyn2nCTbyLvcUO/h83Z6xP3gj9YxpKMTSxVB2AoycCkPa7nug7YW0qyMOOspUAUjGTWuym8Bb9Tz0l3H4qD6SO9PhYRDo9A6t/n5gjxSFLwrjk3aL11PxScienSgw1YHVcewv/XCY+hYOYgndKer7VwQmbhXha8OOSIrqFVruFNRZGJ3NEi+ZFjlhsQ/tO5qz41Zw+1a2HEu4wHG/64dmJMO1l7oU6hLzMtlUODsZglAeOC5bFiMObjHAfb/IuUXCGFUSqcwbIhvLlQYWGAzwAiFgj2XV1ySM5SBwevkOKi4VRUVcBSiWiXe/37WsOpfV0bmwiqF0FF+qMAWJm905WidJqoVYMF7xLuqSTWKq4LNkto5qaBJhZXiEl+2csnwf+vy50SIumFai+y+tVHf0+LLisq+LIoWfQ1VN5i71z3I5Hx+l4Sw+q5buIBUqG76SybTH8xncQJWk2uGhNLEf9m2I6WO7DFrDJg5gu/5G1W1fq+Uw98h6Wh3bN/WO5U3yx3IbEw6S0zuGLIXDNbcbiqCnfchF7qEQu+RftRQ63ORwBKvjsKt0wnJfJ0j+biwJVPUmc34Dvam6Il8YtmK07AXea9mUuwOpuUuiCycK6ZKrkhFZk2Q/9+xB4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(122000001)(38100700002)(26005)(64756008)(316002)(66446008)(66946007)(33716001)(66476007)(186003)(66556008)(86362001)(38070700005)(508600001)(7416002)(5660300002)(54906003)(8676002)(6916009)(9686003)(6512007)(71200400001)(6506007)(4326008)(8936002)(6486002)(44832011)(4744005)(2906002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1GGAuLbeYSFeD2SHHmSZVknxx5zS5BB1EuKp1/AQK6dtlwfYN33nqGLCAU/P?=
 =?us-ascii?Q?fBHKYiVA6J9rSVvQ+oJ7YmSuGbplkMjOroppghElObo8EbQ/WlniCIewenih?=
 =?us-ascii?Q?dKwuj0KW43nHnijtP2FlYVcaoCPVmm9WrYm5udmtDCkUD3J79CTQLrf5zcij?=
 =?us-ascii?Q?18k0c0Fyl4/x0BnPmHZ/g2e0bVeR7kUnzJhpJpNJHkDfbYH+b63aMqoChk0+?=
 =?us-ascii?Q?PzRMwRVaUh5VbvU0mkZRONEFVRzUy+0NMzS90isPH9QCVhZY8sQZh0RbKEnt?=
 =?us-ascii?Q?qEG/Y8KNQLYWt0aKdOnzUNiAnd1mOYke6BjCa8y00CXpjDJgJM/N0wXejyHa?=
 =?us-ascii?Q?jBl6vdxDsuggAc4d/zEKybp866GkTlkY0wCZg5BaEYKtYsvo3ZQQwd+JSgJH?=
 =?us-ascii?Q?n2PJpbweR8kxOJzve1pr6H5CX9KsOCvf56Tnk3nMDTxqzPVAxP8DDRw31119?=
 =?us-ascii?Q?l0C3jWaSGLEd9iImoXIl8aDCLhFOHUW6VS8EmUFhh3T+KifKWFRtAE8rQesE?=
 =?us-ascii?Q?Qtx6w31Ey63Y2fyhvjha21qvTm8eJojgNvjB350gexXCqc1G2uXl2KJtTOhZ?=
 =?us-ascii?Q?qpD/5HXE+uvySjE5a98NAIexnNhbCFfRqpEeVOpOlbuqWgGebX+zmaBEcwzW?=
 =?us-ascii?Q?oXoODiKE47O/3qKBcSTU1y1EKUceE3AT8WrqGClLwPV2f4uu56iOoNn0v277?=
 =?us-ascii?Q?O3ryYZVfIO0sKCPVv/yma3Ih2jGBZWPUG587H0lvvRyED+s40f4raS5A4zxw?=
 =?us-ascii?Q?XkEAvozQk8VcGOl4mkTzKMccnyEe9zZUBx6ai8EczLSJnkHFaOrG9W9eM3nH?=
 =?us-ascii?Q?SZMQJT7EelkOT1KHttM0m9l5IdJSf73s6b8M+9Kc2yCjdKNDB2/bWr2GafqY?=
 =?us-ascii?Q?+A404bSIHLpfJGWNKFzxPLdZ1PdDYAcRY5iJJCjGxibSOBteJKHcwX4FnHEK?=
 =?us-ascii?Q?feCWG8MKZ4pvxl74T/zRU15CK+Qtf5MFpH/9mjRtVzFqCVW4OFTJOOsTCtZH?=
 =?us-ascii?Q?x1jabK73pnuADt1izc2N/fEX7WSENMKhJ/YzBhzWyyY1uma8lngQ0mvFXw4R?=
 =?us-ascii?Q?VwIsaO1jOXg1HHHJCsB+ndFjREC85F3MuejmQqDQcs6truLy+kF05SbrV7Nx?=
 =?us-ascii?Q?IACF2wvBxCb6bf4FDlp5Y+shgwHK+6YB/rNBr+fH6iV969OTMoXCF8QoCC1E?=
 =?us-ascii?Q?AAD5RpqUjIcWCY2UIi27pSobOYzCLbWEAzOm/oo5xTU7VyIvp9pouvh88FHT?=
 =?us-ascii?Q?tvUjLinkQsswI9M9pOevpzhH9GQbVPipoLzbbrqC8omK0G8dnXaJLgBZFQRZ?=
 =?us-ascii?Q?Lkfnnw+R+0nRGPW9fcpBBQ5xP69hx3asakj6QmjsC/4CSNWOJkcgdYyrgybg?=
 =?us-ascii?Q?pgM4Drb3kQio/h4A19Q44hFPkp6qGFanDpNRh8ro57BulJh602hSKdXvzGu6?=
 =?us-ascii?Q?zM31cjS4DrmZh1VQ3P25DHREv+IT1dqnP1njOC1YglxCVSz99WvjcYgmd4hg?=
 =?us-ascii?Q?vwLEFegUF1BUjObUPe/re9GH9xKBZ2icraGce3HQo9EmU5bjkwRaXeu/C5wo?=
 =?us-ascii?Q?q4qf6bBt54KvGgC5pMWx2wDmBz6vBrOk+sewSEsKTCkKW/F2EYESm7dtiOvZ?=
 =?us-ascii?Q?eAU9vKTo+FArXE+mJumQdl5X7dFNjbUJP2/YrDfQMNnO?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <079CAD4E386700439CB96A152FC507BC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5d0f75-209a-4583-0d0d-08d9f09b1c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 15:52:02.9191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8v4pnIQwx1/DV0393WQ7HMfTDiedhoTiUPLiFyVkhfS0rbZL7zdGK9o/fWV46hiq9Pp/mWbDAt2X104FAu0Sbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4525
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 05:44:52PM +0200, Nikolay Aleksandrov wrote:
> > Would you mind if I added an extra patch that also does this (it would
> > also remove the need for this check in drivers, plus it would change th=
e
> > definition of "changed" to something IMO more reasonable, i.e. a master
> > VLAN that isn't brentry doesn't really exist, so even though the
> > !BRENTRY->BRENTRY is a flag change, it isn't a change of a switchdev
> > VLAN object that anybody offloads), or is there some reason I'm missing=
?
>=20
> I agree, patch looks good to me. I see that everyone already filters the
> !BRENTRY case anyway.

Thanks, this simplifies things quite a bit.=
