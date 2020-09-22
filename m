Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA62927378F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgIVAjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:39:17 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:12512
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728597AbgIVAjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:39:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn2kb3RnJjoA9ohs8rb9QBKtP0m/ixUjdLhcu2woS7/p2OXPYX5yYzA5ByfyYN0W6+Nbo4Buag0070BAlQcdKVq6lU9qveLVUNEpYcvv+AJnKfD0d3rrXbo531/bhZYzexiW0aaSDShXAsb003iNUCg3YdEaIwLZzQqkpc9uZIf/B7Twmn/FiVddtQLO3rqpUTkMpvVuAwTAXj6H07OzLz/4bi7RmRn02mNJ1Rgg4ItipH6O5XVb3By4eYBOkIGcFPoLYw8h+MMP+UqRQt6VjM8cbHPAdQE+R3Hi3/54pHxfq7Cis1xFTu/CCSs9oA6stBTRvVMCMrVlDXJDOKVfKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5zOy6wf+xDMqTGdHnd5S4p5C5/9SCOeUTanhT3fizc=;
 b=H69iNgxDmVoXt/Jau7Ctrj02fGk0HG/0iyBcvst1SPMUnbhgPNIDbf9Zegea7fluKrGwHTqi6J6CaauXa8T1QYaaIM/GZEXqO3fggcsmzvFEkGCWmgRL5xPbQRByPp0Y7MsXEqZLeiabAGS6WozsoVFONzJrDLLz5oZEYjulB3ovzUaZ0Neu5Q+M2FqBOjOhTw2ca4s6cukVB3os4uWTg7bsY8hXTNx0KgyGJKwNOXTa39dO73C1PSlcSvLBy3v5z6yTyhgGWZlUl6U8FYXKRE3Fc4Ve8nqhG14T7vor/8nZuuVkNhVhdn4rktVsDbHLE5+s68jrsVzjxmB7Ia+g1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5zOy6wf+xDMqTGdHnd5S4p5C5/9SCOeUTanhT3fizc=;
 b=lZofqPqMJo3uzU+tVjkQ0n+qArCjsiVBqsqVNKNkL+4SrF/e4iKgBo2DmW02PuAM40lifGN5Az40w1rQpDo2ixFd8TsVTBsq67EBJG9JEZgchF9Ps+RjyAcStTNrbz6g1RWyaWVlT1cyFh4k22z38fuXFAcs9IB/qO7tw8Jk8g4=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.20; Tue, 22 Sep
 2020 00:39:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 00:39:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net] net: mscc: ocelot: return error if VCAP filter is not
 found
Thread-Topic: [PATCH net] net: mscc: ocelot: return error if VCAP filter is
 not found
Thread-Index: AQHWkHAStUxMXfCGfUezUDR7dF3koKlzzmwAgAACSYA=
Date:   Tue, 22 Sep 2020 00:39:13 +0000
Message-ID: <20200922003913.siqemus3x3emjscd@skbuf>
References: <20200921233637.152646-1-vladimir.oltean@nxp.com>
 <20200921.173102.2069908741483449991.davem@davemloft.net>
In-Reply-To: <20200921.173102.2069908741483449991.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f9bdafd-18a0-4db9-957e-08d85e8fee05
x-ms-traffictypediagnostic: VI1PR04MB4911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB49116EC273FBD51A0C2E6AC7E03B0@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9k2gbONIk+UJMcSiIgLwuHlbxp45ToEbV8751E6xRzlyua0FKMmfVzReeBsQSiS8Jhi0UYTW6lDFdSaofpTEjvdbfL5F9iCfavXsakLXkFa+tzcb48WEeuEZERH+40Mi9NyXjYaGw51yMwRPC6ZATvNiaogWs3VfEvAixhWx04OwNgSCqUGFHyfz2AX0HiYQFR+cCBVSHAMXIwNGJ7MIyYmFVDM526KHcTjWN8yHb62MakukjJIma1tIZJezvBP7RKUneUJvxCJMu3t35kKrMROHymFnGDrqeAH8lN1tCzfoOVgOZNP5vl0ZorJP9THn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(366004)(39860400002)(346002)(376002)(4744005)(316002)(186003)(33716001)(6512007)(26005)(9686003)(2906002)(6486002)(71200400001)(478600001)(86362001)(4326008)(6506007)(66476007)(6916009)(66556008)(66946007)(44832011)(8676002)(54906003)(1076003)(66446008)(8936002)(64756008)(5660300002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AVnfOyD2XhQtdUJyI626KP9yG4VtrTq6KgD/BddvyO2PJ9BYJbhMcT7+ox2pK/HQMF2yC86PNmJ7l7L0wcKFGxtMC7IDR/pqJ0e6MUDBtoEpjJIjTiiF1sQJxdQ7K8Wru0/ghja6i37WWzTBUTHdpg/M/FGlrdhUD2TJ0qV/b9P/s730z18GBtpLqL4aH5Iwg4cdXrzJpwopiQd3KOMr6IsUG+79j/9zuqBz2ujxqtnH3u8YEEHItJdnGE57jlWrgfw0Lf/PwQ6hq7QAHAgP5GJqKo/Djx7ISgztu3RpizOmPGkEMnnEE95VxIRqDygITQBVCqxKzL4luTaOwzsN0pMrbQV9SGqT0cxNMhMsvlwY/SVJE6o0VgiFYmL1wHjAx7gT1GHpG5BIVtgByuaVTxWbMnqeXrcRWE6lk3zLQ8gpZM8A3jB4lxNR+QIC6XCdSTgcs5SuHQl/rxIEt6nr063BWByUHe2mkCqyLekffRvoccQi+2puXLPAMpJ35WE5049jD7V2aAAJ6ePnowxUA1BztiMq37RANF+6rHAzSkN9SPR1h56/Ay7B2Gg/pxMuZBBMpfyO+Niz4BlPD65QhrIfeV1RYqmoTKw9KYg+BRRoiQkE/Ohx71+iAJmWAyREwrYPyzZldxzltX3gnRQ8kw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8B5044AA4B3C642B04DCD6C73BAC520@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f9bdafd-18a0-4db9-957e-08d85e8fee05
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2020 00:39:13.8463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zcy6HZs41EJgfsIOtRgrMAY+/wDhTqFiCCV6F+LqYuN8STn5arZn2XZABQasRPvGZLV1RUCFZZFQSFMy2cuuAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 05:31:02PM -0700, David Miller wrote:
> Please repost this with an appropriate Fixes: tag.

I shouldn't need to do that if you apply the patch using patchwork:

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")

But this tag is more or less decorative, since even the file name has
been renamed in the meantime.

Thanks,
-Vladimir=
