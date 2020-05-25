Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F131E08C3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgEYI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:26:28 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:14149
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727894AbgEYI01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 04:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8ju8sUN0fGFUlKqXQgYQo1QowOYwbh8ej10HKLPRuW9l++4eGLdjFhgVQ5u57ZnGko5AxhmCUO4MehVh9R5qbde4I/VZCqJ0F8dAFbZedJ4XtOMA7EtHxY7vIu1/qfolvgzUJ2qO7rF6xqqkihirgielJzrXeX9U43+5mTySihz5EWZR7es0LOW6IJZazJmYIaen57i20WdetDlgdlzP1DHcQQlBOu9v/ssSy8R6aMxlj9A4NvH/G9iuVzfsV4DC0CQBsp64/v50GxIih8aWwPfEh1ZJ3muzQEP1JKZ8fxLMoDL21JMPxxH3BAejg5U42CA39Uwh77DIuz2NsLhrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FUZli1Im29IpQrvoyQngVOykx998Zw9jvv4pPguzDo=;
 b=Wle0ABrZfJFJ7nGBWXB2QM8xIhUIVVADaqejM1MbI/bMi3qqJKslHwNyPcUjOXFEDLdoZ4t11qtKNiwKfigE+9HElIhxOUXutX43tIrG0Nh70sN0mjimmaOz/YEEAqHSdIlqqq2V16WLxQ+rAVeRkF8Vc1GCbcMstU1M3yeWjb9qx62OZrSiLl6rkMwJj/e1pyN5YRmzQJ3Hl1MZaYx+j0elFoNEOIlAlFeUXRq3uXpTIO1IBf+uDqghTYTSMrV/m4m8yFqdg08y3+3vy5vqFAdnZPM0rx8B/K272HyZn2Q0BxtRo5/a+E/KoUyOxWBt8IUPpQBWDgDs6MOJPn0RgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FUZli1Im29IpQrvoyQngVOykx998Zw9jvv4pPguzDo=;
 b=ecpunrNWxzJexPSlcAeD+ysBO219XM8m98sJPP7+e2Gq+ZtfT+Qh2qWNmp9nWIoiJ5DvGFuDf9NZL1oLWE2GIDuLrygJX9XIXQ+/Gq54mFArLhpUWEsz7M/9fMckcYSOam1th8pFheIHmaJFudv1BBIxD65cWdenza8wWEiCrmY=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3831.eurprd04.prod.outlook.com
 (2603:10a6:209:19::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Mon, 25 May
 2020 08:26:22 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 08:26:22 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Andy Duan <fugang.duan@nxp.com>
Subject: Recall: [PATCH net 1/1] net: stmmac: enable timestamp snapshot for
 required PTP packets in dwmac v5.10a
Thread-Topic: [PATCH net 1/1] net: stmmac: enable timestamp snapshot for
 required PTP packets in dwmac v5.10a
Thread-Index: AQHWMm4rrOvsVv/CYU6TBk+S+aJLnA==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 35
X-FaxNumberOfPages: 0
Date:   Mon, 25 May 2020 08:26:21 +0000
Message-ID: <AM6PR0402MB36079B19687D24D0B0283947FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fdc30e5e-6d74-4366-635f-08d800854e7a
x-ms-traffictypediagnostic: AM6PR0402MB3831:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB3831144CB52D7ABB8A82415FFFB30@AM6PR0402MB3831.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i9BqVR0AkgW9Td9ZzWYn1ukK8UZcTPT18xUykwWH+T6u6FOondn2gJTx+t5zhznx5v5v4SJ2N1mTHa3d5oY1n8O2jf6ZOK0cXuc2x0oqI5TwO/aCvi2WXDbTK5IaYBs4mlpokFj9jlf0/zUEKoplfabBeDDMz2yHTfN0bxxqU+NNRgHHnUBoXNOThYW/0dGfMcL0TGdubhQqNgLlHoq9eHBq5CHlmqNB1Qc+iHSdllHEhUJfofPkFNjoxGKIWqAN7Dsj7sk9dn/MwwecIdPfVxkgy8u7FHR8QTlDQ5hpKKpT78GwN/GxBvVHbSWAANerprbuxg1x5orc1cmGI6Y9gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(8936002)(54906003)(110136005)(558084003)(71200400001)(33656002)(8676002)(316002)(52536014)(86362001)(478600001)(2906002)(4326008)(9686003)(66446008)(64756008)(66556008)(66476007)(66946007)(55016002)(76116006)(7696005)(7416002)(5660300002)(26005)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2u7AAkEI615UdpfNhjvUywdDxfNl1VdILkq0s+YdzpfDNbTz+GeaegO3sn37QH5P5oTRTHWSGlmjJwkBr4jkxB1ESsm2K48rtFzDLbPqD3Davv3zZy87c1HHA/6ttZymfWcJ9M2R9LOYpUYIYMr6866W2jGGI/DjBYWb8DxsCvUc1hIuZZV0npjPlkRcCPOmAo7r+NBlMstj3b3eyPrQaY2XUMxKnhdKDRfiCKJliuXfz9xqrYfOiySzj14X478XO3WFRiA+jodP1+Al9yPis16Fg2pKWXKvtELkuamWMdueDCgfWsWE9vPiopl1eWW2Qa1WaLP+3EXp0wiF8eS51MYTP3Vey6Pf4tSdS99pyDn0nv+z0x4ufm4ol+H6edkwH7V9CXcJ6xh/972nvSpfNGh28wnubhEbpN9UvYohh/Sh6aZzwz/yOw6Ah/W2EeRVtCVBQ7CHrTUFT3M1dVW9763HnG5v3QMBTuFiDmn1WoVNb64JgZItC0lWN9EumIbd
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc30e5e-6d74-4366-635f-08d800854e7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 08:26:21.9439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etwsrsukJz2fcNDMtlw/IrLG8nLK5EgPiBOOaTbuESAMJwoBqlYZ9n5dqJm15SRZG6rC+QZt+NQKDL2jC41IJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3831
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan would like to recall the message, "[PATCH net 1/1] net: stmmac: e=
nable timestamp snapshot for required PTP packets in dwmac v5.10a".=
