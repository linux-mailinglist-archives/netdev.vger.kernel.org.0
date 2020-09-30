Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7527E27F377
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgI3UoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:44:03 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:30816
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3UoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:44:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alHI+cmGa35kTk8zMpoAQO41rPAPyOR8EVq6mbqDeIFmsI2oSsaO6pSAiOd/aGju/cWH1R+zMiVhdyzx9IkMQfihL6EOR0e5W4LAa40qdawzmXYSkMeEhgu757Uhk7vdVK9HBkaHXRG3jth9UC8qaQqkwxfyUVGzR1EizOkN1SxGI/Tilf3wfjlDVJm27lMKFqD2L6djFmoYdE+SBwlu3JmErSmCxTCVgllUR3C6wgym1VoZ3S3kni57USf41/i2esjq5PI5e2gHUlA2qOygPk3AQNHtAVPGoZBcYvWAU9MHU70HoztxcDgIRIzJs863oXg1T5FrMndVwwY8vjYajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcVHd0pOKVlMk5FY3C5pD43m57RQw6IJYsPM2oSwr7Y=;
 b=cIPs9PxhZajo5DHgegJQtRbIeMDiq5XGpygkZnRQ0kZZWNlkbtv6coa30Cw3GAo9rpPwIHHqaUepUxpWD76bAN3l80CcwbRoyr7qyyTvdKKD1SE7CTucWVjQ9FaTEOw9f/GWSbaTnzQ6YJEAV3WGdeJdIn8bONhZwA5r+wEe41PHxJ4B1cNNvpKbuxfB5mPpzsWgoFtjtdWw8ECdZYPF9cCG+DrBRA/uLdbBXA2hRM5S1lw53o4sCwAGNV5ckRygFdX5oIk7AFod0hSYSf1wXyXQcX8y4EytMIU7RKN2WmJMO2pszT2349foAlhu5cUP45iadL4fcso6PFea2J2b6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcVHd0pOKVlMk5FY3C5pD43m57RQw6IJYsPM2oSwr7Y=;
 b=nZm8mFA5vdnU8oCYdiBu03AGaH9cohtfjLx7TFTFfOimm8weUPBwkRCGaYx4LReIkaYVWx9sgGK+pEqh86Ji0dUsCRLjwcnjlfneDy9SXX2OTgi3Jab7GP4Ogcw5e05HZc/WRDFzyDhBkHrs7YHklHaFzKNn4N3hCgB0renAbxM=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 20:43:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 20:43:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Support bridge 802.1Q while untagging
Thread-Topic: [PATCH net-next] net: dsa: Support bridge 802.1Q while untagging
Thread-Index: AQHWl2jkTeQqn7VGgU2tHQ+vhEtr46mBpgUA
Date:   Wed, 30 Sep 2020 20:43:59 +0000
Message-ID: <20200930204358.574xxijrrciiwh6h@skbuf>
References: <20200930203103.225677-1-f.fainelli@gmail.com>
In-Reply-To: <20200930203103.225677-1-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 710b5641-690a-4727-6fe3-08d865818f1d
x-ms-traffictypediagnostic: VE1PR04MB6510:
x-microsoft-antispam-prvs: <VE1PR04MB6510AA30AFB31282CBC6A3EDE0330@VE1PR04MB6510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/L4xHqEbdg8BB2rq9bXULv1/1eSrL/B8Nc00O7YDTSwZ7LHq78IkswE464d+GK9wbJ2KhF1+l2iqP8aJq6EA+3t0WoRmR0qXAk3yfG64ah4pS4rrNDdnfNzZu7Y5IzBfT2MSM38Nkd2osUAZcjJ6x7VakpcMUXrAEZBri9lfDzoYIRjAqMO07nkdVUfhpPRYNLitZaMDj1GxHt51WHER5w79bZrWMAdYrLYvosrgcv2k4gTBxbisBIURpk54io8CnSuJoCfiD0icX1OAlwyP7H8DP+OLCcDA/ZQ4Wd1xOK8emkLLH0VXtkoCwAlqfKUEmv0RB0lW/wf3n8EiwXxgzDsGGR+XURaqzJyZingyih/qI8ZK7bVjo87y7Ubn+wG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(376002)(366004)(346002)(39860400002)(44832011)(316002)(66946007)(6486002)(1076003)(66476007)(66556008)(64756008)(66446008)(8936002)(8676002)(33716001)(91956017)(76116006)(26005)(2906002)(186003)(71200400001)(6506007)(4744005)(9686003)(4326008)(6512007)(54906003)(478600001)(6916009)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MItub4mo2Um6qFL6bMIM9dTwc+6eYlHgcCoS56qVZQXa86E0sPBo45CKvQj/ArC+GSTyB2/1WxAleyI4yRVWa/qhW1IiVwadtmgvQMtevNQF7T9QgfeP+sN9jQhx3BCb84qLn0DwKUqfY4INAhBIS2BDTyAXJwrsnVfIzUana4oq3unEAIk2UvxSI6Tvm0idLVq6LdC5uWp1TUqn9pv0Qrl3ipZ/QcdwUavPLBy6yHMPoKooOWqOwW2TR3BCsGqbT+z49ZHLdpIE5701rq/unPr/JEKICCD3uuPb6ut2ld7OTOJKUorqX9RsjZKtPQYZBZ66TP7TIFyZoXO6D7GB1Dky0ftKEcenqVf/F0/9CkA/bBDEqA57NZBV2DktN5uc8bvTWetnONB/nvLkoZ6RXm3x2OqrD2t0uRLrBLYGAxdZIZ2IM5UZJnQFWbtIPH/y3sAjyFq9Y0uCuMVB2R0YYRnhGeHidAkXJKeZvIzB1pe42Da86j6emHunbdcOzLp9XM6PF7pwyIfXO/ImpE6ttZZqe5su2hmHzA2l5kLUXmcavV4OUppWsvn9kjmXpDrrKScudufxx9ra7z2bdatyx+BlDV9/wNB4ELzxxJaqMpIDEkPBqLFL2XZNtq9a9A/kI8VD3w6RR8OfQ8phRk7s+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B19DF3755EFF194BB9BB87738837FB09@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710b5641-690a-4727-6fe3-08d865818f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 20:43:59.7853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tgrDdCN7NOOHViVdIHSr4+D+hmC6gbxnKR6zpaOnGNO09WindIttLXJqjeKiGfAs3KclieHYCxC1EaPnfDT8bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 01:31:03PM -0700, Florian Fainelli wrote:
> While we are it, call __vlan_find_dev_deep_rcu() which makes use the
> VLAN group array which is faster.

Not just "while at it", but I do wonder whether it isn't, in fact,
called "deep" for a reason:

		/*
		 * Lower devices of master uppers (bonding, team) do not have
		 * grp assigned to themselves. Grp is assigned to upper device
		 * instead.
		 */

I haven't tested this, but I wonder if you could actually call
__vlan_find_dev_deep_rcu() on the switch port interface and it would
cover both this and the bridge having an 8021q upper automatically?=
