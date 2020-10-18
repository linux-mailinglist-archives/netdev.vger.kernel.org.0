Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F3291749
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 14:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgJRMQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 08:16:45 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:11169
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbgJRMQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 08:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P72pGE67qbkvVqxVgyJ/2wx7v6pMijL0CT22uJ3WMXT8WaUbHkWa5BxM7Rl5Pv1JSSF3/xJ4aSh3wqv8pUfa1h0J6nJMM586Cw3rsjteYEc5sv0/Sz84+NnbQThkaTXkZvYfqfmElcu0osG4KroSUXnef/j1sq9v1xaVY8KBoEVdfz94qN4d+65E1qOMHPaWnEGFNxf2CHsJdKYatm5oXlgbXDGxVw6isP3SNJKo3gRT5h/8Ig/9VLg8GhHDZvx8qUA/xUr69EZQENOTOgtHBP4eFNDNVr+RdmHb7V8UEC8Knwbsc6wWNctt//glfZBnBO4j96Anv7K9BY+/GxmcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lq3vPidCM75mFij8rIc5LIvjeTcfpqrsu2aH4dnrtM=;
 b=EBicHyzV8sFpkEgngS8yhId7XAWHbvN52LTMN/nhdMducVvohXhf0kk7mE1DKwh+iRkCmt3jwj6ok4a3V8IvQtDZp6k6OhzFAi6+5lgE9aJUaR2goe5lbnC/uiXTFRe4BcBXIw2vPaJvONfwgVY8lXbvGRKqB2GBbMIGD+0AXBt6v85JbYNPFyaxvxL2vUhmsarxnunQGaGxmhJnW5jwtOzt/qgN7wo+ax8rHzVUubjoc0eATK+O+4K+JtJvqLlxMFsYSQwGyfM3SF8irsRJNI3JsWbohv5WHmYuwurFqSiDqDaghEXioHuVVEvVGOk8yODJs61W8uIdxz0vDN56lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lq3vPidCM75mFij8rIc5LIvjeTcfpqrsu2aH4dnrtM=;
 b=lSo5NQVI4nufJ+x6S71SXlMdweGG8qsHb9tYOM9uJtaaFCcWyPWFeyiNw35B9juYxvFAcNRk9uH3bg4FuHSGPXj+l5M2S6GEvulcx64ckgAB/uZlG9RiD7G5ypkdOxlhgljlGj/adF3RoGzzMN7NhyThhDKz1zW5Y91ixuACwJw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4429.eurprd04.prod.outlook.com (2603:10a6:803:6e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Sun, 18 Oct
 2020 12:16:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 12:16:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Topic: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Index: AQHWpM2VvXEF3YqeV0mNLAH0H5Z1UKmdQ5MAgAAD4gA=
Date:   Sun, 18 Oct 2020 12:16:41 +0000
Message-ID: <20201018121640.jwzj6ivpis4gh4ki@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
In-Reply-To: <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f16c9858-1066-40b9-9d93-08d8735fabf0
x-ms-traffictypediagnostic: VI1PR04MB4429:
x-microsoft-antispam-prvs: <VI1PR04MB44297F13E6761AAC23CB581FE0010@VI1PR04MB4429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lllIsS0jp1inBL9Q4/e9Gc4EvbO3vXXkoE1DnRt8/3T09tptFFlgWWicbXbFPqvJOhbhOzRGkRAmce+5VrqHHoLyd9KSlUbEAYxq/CRPslUZI+G79CvUI2IkXkp3YFe8fRGdeHClSCALyrqalhZq/wQPSY04iW7ilgUKFNVUurJfbcMCoQRUM0NGRtMQevQN5L82p9S4wGFMPEptEQAKPkUmvoDO9Pb84JvOr923jvMkNXFT4qX1ehqD4Hdmh2fe/AlTQOC8T9wInYArIEFoaoYlbLOiGcS8QkxyZxDHc3jaUtrwhByI7vszHZ8/QlYkkD9VwvAhoW0SFdFMhDc6yQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39850400004)(376002)(366004)(346002)(136003)(71200400001)(8676002)(66446008)(26005)(4326008)(64756008)(66556008)(66476007)(66946007)(316002)(44832011)(91956017)(6512007)(76116006)(186003)(8936002)(6486002)(9686003)(1076003)(4744005)(86362001)(54906003)(2906002)(6506007)(33716001)(6916009)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: svcVwTH9dtC1OAznPaSBAOV/q3olvIEIaU8TjmkEx7BQVPBgcqEbdsISC+84eFGZmtgLBAvPC9bmnX5nDQjF2sqgvllKLk7OMu7awWwxllHPc2IHLUYHtfgZVthGM7iSYzSL/guUeusI65Bd1cFVQ1ybae0CHTdvMmAqpW6jOGGerl07bhQuFnQKrHCDPPcm+VbuqEShyg7rTQ9PjZ6EMyFY8iKAT5uSoqwAgx1VUbPiUY1sxmjBw0kEnHXNFrl1I+3beVYY+vH2yinL7m/dCilEwY7kS04pQoC8VxBxysBSFX5Znc9XZ6s/prv7SJmlyyxXM2XYrQjzICGotpi+5REOeCv2vw5e/ylYFDPp/MDgs5f9ge8cQ9wAOGA3eFJgxnKVCcdd/VGz0Lf2lInRa50uE9PXXYLE/Tl/siIfpFXMK6ZlzE4HYuboz8zEo2Y0GOEdEvs1pyBqIP0JBZnNsYkcEb635qyF6p84bJuK5ZENXwgAQ9rXXcPuo8ikMx6VsAWuaMzgPSfDtnjY36vLZEwNPi+cHEft/uszwMBq79VfilR+kQYheQCIqW9XbcyJ1WruzBerAtrnFpPdga81G+BgG2GNWf3MYGIIWHJSxT/TVCquzf1fToUUUciBoVDhW2s/qph/4HzBqPTA7bteaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04525E6CE53956499B681BD51F696A01@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16c9858-1066-40b9-9d93-08d8735fabf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 12:16:41.5885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PmQd9D+kvePksSTDoX/H0CQc+gcAhy+vsvu8tkhgRO5er01xjdFKX+8qSS1mp6mmzDJO0yIMca2AMFwLzPq1kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 02:02:46PM +0200, Heiner Kallweit wrote:
> Wouldn't a simple unsigned long (like in struct net_device_stats) be
> sufficient here? This would make handling the counter much simpler.
> And as far as I understand we talk about a packet counter that is
> touched in certain scenarios only.

I don't understand, in what sense 'sufficient'? This counter is exported
to ethtool which works with u64 values, how would an unsigned long,
which is u32 on 32-bit systems, help?=
