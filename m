Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D762AEFD5
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgKKLmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:42:24 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:31257
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgKKLmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 06:42:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNcuxKsqk3wPZLei4x8TwHJ0GWZEUR22NZixBwyV5qvT2iid32NiJCM1I3/SGHANTVqXHYXpBsBsmKsvVNoS80qTZ6C0DqOdsRrtlYYL1PYAMCO6Kqu6/dn1296lQo85IbfdtUHRxlCo0iz6Z5YS+GstsNo6ICcIjl9oDeR9ccEpahokapZMxDbkb29kznHsM4zgM6I1SRh765By015A9H4kTUwhZMlMGXxmhFEPbBMF8fqDqml5xJVG/vewUStNebI6HX/UPggjEqacrUnBryRg5x3jHO/SVPCJ8COEnUqaK7nb+3aIx2SQKqquhSOA4AnRKlMuxCKhY0eKLXvStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjXsKoQLzJJSJI3IlFCDAQs4pB/zS2KFXz1acIphj7E=;
 b=KsAmqmL7KtGIdn1eZRmgwX+yea0fPKYdFHh/YCISRyu24QOYV2uDA1DS2kCkUVahWrqIPy7y4xKWGHAmED3k7SFcBODesqg33vfpQhwdndwJcd7dpFhyMEOBDQTuTPMw39gED6617X+K/3pZKdZQfRpU+oWGv//lXBVgiUuyZAkwQGs/2MOp4Vzprc/DwwSy6VD2XNF4dltDFR8yVAcaQ5HvD1Vw9ke8/zeYarGffBUHuqpvSjxtoYGgKO0EsRiyt7whq1IUxR8RHbEomAyfjsoeA2sH+ZhZk/KsJVmWsEzYm70XNTA3fdYNdMpFd2q/gqtsLmn2Ymf6u2wqmXbQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjXsKoQLzJJSJI3IlFCDAQs4pB/zS2KFXz1acIphj7E=;
 b=YIoie9sdDvs83FnjmdNmiMjZfPD8YCX0Xux+oM2SlavbnyRLk9r0NT0QciLavn96GyTojlhKPm4+c5MfiZt8KiSPp2lwplIP9/xlHU+VwOFeJszu6LP7wVW40+JM9dffmUv9TRwLQPNQjaytXoh5efL0oI6R+9Tp30ZLTUOJofo=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6833.eurprd04.prod.outlook.com (2603:10a6:208:17d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 11:41:59 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 11:41:59 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next] enetc: Workaround for MDIO register access issue
Thread-Topic: [PATCH net-next] enetc: Workaround for MDIO register access
 issue
Thread-Index: AQHWt3g5LdPswlGN4kqnYf25WlFReKnB/QGAgADP/kA=
Date:   Wed, 11 Nov 2020 11:41:58 +0000
Message-ID: <AM0PR04MB6754649DFEDEB10A9244FF2096E80@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20201110154304.30871-1-claudiu.manoil@nxp.com>
 <20201110230525.GO1456319@lunn.ch>
In-Reply-To: <20201110230525.GO1456319@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91e3be2e-46f9-4ad0-cd75-08d88636cc7f
x-ms-traffictypediagnostic: AM0PR04MB6833:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6833D8E2E79184710C2E086896E80@AM0PR04MB6833.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: snCrj6cVFhs1qXaQZguKaS45BG32SYqVUG23mitWjX7y1HKnuWcFcpP+rUliUILZBCXRK0R2hMITOxj32q1lrnugAXFim/sDy1hkLdXJ7FVYb2W6VKtYxjWIcWfh1fkx7g75LUf36DgqD2h8+I4y1OeEOFz5WcXoLdQoRWX6i6anuc4L13CDe++nTZ5SStupnW/XbmKiovP4TbodQPABiT2lquzZ14NwFsNl94KzzuTUgCju2mgAJxhsVm1vJlgP2R57Kcr1UyqmBrOn2so9MPG+gsHShyGztVluhPKMDsP7/OTdDkGuleaUuvnrFTwS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(9686003)(33656002)(55016002)(66446008)(66556008)(66476007)(26005)(6916009)(6506007)(478600001)(186003)(86362001)(7696005)(5660300002)(8676002)(64756008)(44832011)(76116006)(8936002)(52536014)(71200400001)(2906002)(316002)(54906003)(83380400001)(4326008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: C3yGQRFf8+hh+NmMzEr+JgzAp53n9+99XuHiiTxNFBYfq98YYJg9INKHor16IBSzAwun9LxdloXS0zY7+0ytx6ytwVGHWkOFNlS5ilIRwVY72VITBEQqom/Q3YZIV6nGn8kbnQQNSiIPMy6i8o3vC7Bwd76gMqlMmwhKziF6Kj61tmZtIlARQcQt5s+uQQabHFvUhT+Wc4xfmEG7tDUGMtnJ5N760dd5MzEQw8M9QiqOPm3Ba7J8nWNyYONVKk3wvyNUSpqE8NbCTVVvHe0pGdhuz+WsaJmzSyVNMXeCLr7k0lrCiyCvdsoJbn3sF3XNgq7YKHT1bWRtXaXchiloeRYde4Q7ppcdvq61nAHFSBtfLqy8wSIEU8PXitStKPU0bCOJoJt61v6uczrtPFDriglOu9eYnC3MvVL6Lja03ij/27DYa57862INvk8TVbyD3HQaZzf1v6A5Cs+fZNIFjPBKU4hBuEsuA3sPRn1dzdD433gjWUx2EXFGRRl1RwSPj8Aa4ZljvALKPWFVaIOYCFVsIPEWOVHW9KOr/ehbaUQSfvJOmKuPUWKrHYaO821yldVJC01tJSLc20jbE58GdOpRZLLHkKfI4WoPr8Y+lhvXmFd5hv/usx7STEKNuMohshMlF/0YjsdvP5C26qercw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e3be2e-46f9-4ad0-cd75-08d88636cc7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 11:41:58.8679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MA2m1cgfC3H90RNVB4MaS9ADvZmz4bypHRxIBKDUhWNTkgg/pnJKcTdFer2+qQLJp6Q9xgKlGEBPHF2XfMq3BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6833
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Wednesday, November 11, 2020 1:05 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; David S .
>Miller <davem@davemloft.net>; Alexandru Marginean
><alexandru.marginean@nxp.com>; Vladimir Oltean
><vladimir.oltean@nxp.com>
>Subject: Re: [PATCH net-next] enetc: Workaround for MDIO register access
>issue
>
>On Tue, Nov 10, 2020 at 05:43:04PM +0200, Claudiu Manoil wrote:
>> From: Alex Marginean <alexandru.marginean@nxp.com>
>>
>> Due to a hardware issue, an access to MDIO registers
>> that is concurrent with other ENETC register accesses
>> may lead to the MDIO access being dropped or corrupted.
>> The workaround introduces locking for all register accesses
>> to the ENETC register space.  To reduce performance impact,
>> a readers-writers locking scheme has been implemented.
>> The writer in this case is the MDIO access code (irrelevant
>> whether that MDIO access is a register read or write), and
>> the reader is any access code to non-MDIO ENETC registers.
>> Also, the datapath functions acquire the read lock fewer times
>> and use _hot accessors.  All the rest of the code uses the _wa
>> accessors which lock every register access.
>
>Hi Claudiu
>
>The code you are adding makes no comment about the odd using of
>read/writer locks. This is going to confused people.
>
>Please could you add helpers, probably as inline functions in a
>header, which take/release the read_lock and the write_lock, which
>don't use the name read_ or write_. Maybe something like
>enetc_lock_mdio()/enetc_unlock_mdio(), enetc_lock_reg(),
>enetc_unlock_reg(). Put comments by the helpers explaining what is
>going on. That should help avoid future confusion and questions.
>

Good point Andrew, will look into using better names and adding comments.
This patch was actually intended as rfc, the final patch should target the =
"net"=20
tree as a fix.

Thanks.
