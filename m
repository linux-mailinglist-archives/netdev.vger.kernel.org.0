Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621B15AE24C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiIFIS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiIFISu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:18:50 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70122.outbound.protection.outlook.com [40.107.7.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52FA5508C;
        Tue,  6 Sep 2022 01:18:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkH583OOyeEPlGsc5JDRdbPMHJEPsqp4d/T7B6ue4yBmuXJ3MdsHKM/tQ0YYuhK2WCkBCHTJ2a9uxrH3sMTVERYvC2KlPkq4sz6c6FVj/d9p+gQJUcdlXJPnsEN2kcopWi5pdvNnRev9gdIzDO9lVPdSDQ1crp82tScTjK6LnYcxdzmBcvmvxSMbUf/ULGCzzeDWWrlic3FMkwK/aUiDAeiC5n7KpwZeyJ4Q20KNrkllPukHq+gsejiWOMZZDTXEBHhzq4GNbxzTNokQuurDT1wt0DkAszxM65PFzIqhbXGx/1do/JEWggO020csIfgfoDydeK+UH8bdbe88Uw9IMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaiujdpkH3XcYdohweA1rNlIQY8fw53x4NaortKUm4g=;
 b=jZDePrTUlizZoWVlv/7VRuOp0Yh8h5t2N3mkWccYRITRcigYf4E8lRogDULn+lxKg+8q15/c46deCJZ9wil5eUrITal9RCwbM8+wF93CfsKPDoVVeahLeBXNtzvH1BesdIob8HrCMwhSe8UhM9zi6uB+anUkjLAYJNoJWCvQdnUJY/v8lKyU+V2/X88ukWOtnD47slkA6L7n/lyWk/iZVkoEYaRFhZnbgcyq28QOGuf+OsBRY4tjFCNtJoNVY7rmsw4tc2ek4Hb0gkoyQxBX0nfOzqazJKm24gUOqMBqr1iJfVUBagUmB+9v5o5q9fHB6G2y1a0CNti2254C6V1b6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaiujdpkH3XcYdohweA1rNlIQY8fw53x4NaortKUm4g=;
 b=J03fnk528R/uWFkDvI4yepnLZrVwrYjgM2xVm8lOTbuDxHSM7/iGVTwk4Yv/UlyEIQqBddgWdvlP5mXf+1XkAIJg1F06Af/Ozapz4rtad7I3zNEvtmM/esdjfhbO1p3QdtSWpS+M+P5MfjsdgeubdnQXRUaEUglcA0UwvW/Dbcg=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB8P190MB0764.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Tue, 6 Sep
 2022 08:18:45 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336%6]) with mapi id 15.20.5588.014; Tue, 6 Sep 2022
 08:18:45 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH net-next] net marvell: prestera: add support for for
 Aldrin2
Thread-Topic: [PATCH net-next] net marvell: prestera: add support for for
 Aldrin2
Thread-Index: AQHYwSlvwiAbWychmEio6tCriSQ6m63SD84f
Date:   Tue, 6 Sep 2022 08:18:45 +0000
Message-ID: <GV1P190MB20194E2C26F15E21AF1C6E5CE47E9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220905131414.8318-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220905131414.8318-1-oleksandr.mazur@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b18c7e8-e006-4577-ade8-08da8fe06ad9
x-ms-traffictypediagnostic: DB8P190MB0764:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C/vaei+VIRYkTqjVw9GEsbSFCgOmaFSsU8iAXFED5YtslI8riWOnU1jtkqgY4QKd4ocobhMRWsHAcRXIcpdSdjVt29jdOf/g4ELiESuhztzn/lu2zDURwmAviwIDjnjsNH5pEm6RqXa6QW3Zi/CyxAf/ufS9Mg9q21RqlvWPeIqVqvZq+PZeKSx1C8FVWL62G7FxMp6hKwDRIv8+qejknCZ/uq2DYuNZXhE7A7kAYOsOi+Pn87qnwv2Tq1U7W53J7FvZaxtjQYorAXwn3ZzG0imrAaIsEo5f0nrl6ZB1aG64D0fH9sYoz8pKTEjHO98aH8vzIpXz95fpaYALgk2bRRKiYKsEetZzkBWmJiWE80kmY3xu19OytPRFsck9FHycXJ08PnTu/KzPRDQ8d6141KtMt4jkDVMtqKmF+jBSOPHc1JYExFpeJAHWP/g7GuAwKvROcFB77wUxDPJaSezIu8DAe35AWZCF/uBkzIV26Vti7nej/KCI9qFkTVWMV5pdY0UCz3PA+8aWT3oAAFeAfzQTAarrJAs2Ny5CXMuWDvz07s8fqaHsRvfy16K5pfJp1tR47woOlnEHsv0Dwc0gjJHNlicpfjimwF+nG181Wr91UvgpUrxYejRjpz0A1iCLgbVoz7VvTOinrnCEevqsIY9n8nYEoaYO74Q705vx0PEsoUs1qyuxwrcCYOacjynzgJ4zZlI811OCXVm64h58zuf1y1kTsuHQAglbLFJvnGbuYnU2Ps4zRY3hDe0RVlWg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(34036004)(136003)(39830400003)(376002)(396003)(346002)(52536014)(5660300002)(8936002)(2906002)(44832011)(38070700005)(122000001)(38100700002)(41300700001)(55016003)(71200400001)(508600001)(26005)(7696005)(6506007)(107886003)(9686003)(54906003)(110136005)(316002)(41320700001)(76116006)(91956017)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(186003)(33656002)(86362001)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?CJE/ONpaB0gebsQ7BxaCyeulFXoKir3Ew69obSl72pYqgLkN8Z1iN3SnvV?=
 =?iso-8859-1?Q?Rtws5frvoShEBwpDihZ/yhsFeNOT21wJoP+c3IIB5T2yGTaOuiEB7dBBM3?=
 =?iso-8859-1?Q?UJeQRDXD3fIFxPs5E4mYdftNjmrRbaMn9xCgk+3M/Ud8p6rzJCwgXdJjTd?=
 =?iso-8859-1?Q?sbElfNYObSQlRqrw8mkUzuCoEe92t8BwLw2gDVRUY8lQjzy5ngo6xaliYQ?=
 =?iso-8859-1?Q?qHtTWJk6bvXUfa0/xXwAahrxUTMZmtfdshlPsuOKEtHUk++1bRkwzbnhH+?=
 =?iso-8859-1?Q?lUgg2mQXF+1cWOsa3GBYkvzPt5P7J1xB0o2zZqtZ3Bg3thVN2B3sycn8UG?=
 =?iso-8859-1?Q?gTQ1MfS9VnpcKfXLyObEIucVb6Or/v4vD8y2utEwbG+zEEqL+aHeQZ2X+K?=
 =?iso-8859-1?Q?yrogCoc5KQhBpucg8WCLzRirSBQL3rx4vzvDLMs/scy/pukR14me70B7vO?=
 =?iso-8859-1?Q?xGzGRAZHW04vu3nw1rUJVC5SgBQ09BOR9cIimJzYkHgryY6hftRzUmlhdT?=
 =?iso-8859-1?Q?/XL8CUuTv042Q6jFcp6Zhzm35F7geQWzdryVVQ8Qgx0Zj7QazkaIxWFyv4?=
 =?iso-8859-1?Q?1LS4yvitIrd1o2K28EhJtBSCM4N9/2hO/Tw+sc+s6vrENmjXixE9u8x4e0?=
 =?iso-8859-1?Q?VgW5/UVl8kxwjcK9aIvRBcQMqONwHNYGjIez45lBrSFxlloL8eDRKwHuIK?=
 =?iso-8859-1?Q?xUO1RBHF6kfm3jGF5WpNRiIO9rMMgePRYEn0nXKf2hBstR2biqF5wNF0Hf?=
 =?iso-8859-1?Q?OcYIM3YrxFPrBrVMwkbOzbF4xzZbdjWsKJV/k2b7podrrIzHd0/dFUYaYT?=
 =?iso-8859-1?Q?V7M02yp8FKcaaOGj+NOGlehffSHti/gwJZ00EAsWeh8QDUuExalzXeXO0W?=
 =?iso-8859-1?Q?q2sOeuQDgQr3WEF6AHhWOLhBOfzhmfwfrfw1JsqhB4YkoSW8mRHtaESDha?=
 =?iso-8859-1?Q?PQJ3lCgonvV9URyUW1pnr0LTU37nb6nXne82pe/W9dWB0aFYQOQVStTCsP?=
 =?iso-8859-1?Q?GGiRfk/B+mYP3mIg5CnPeZ1/wIQ3umDTeY9HAedqwlRH9uPVD9I74G7Lfy?=
 =?iso-8859-1?Q?DJQN8s2QHbiGRKfTLEcAGa5IpHpnWvFH2myKDSlP72QwpkdWs4GUPZkXwZ?=
 =?iso-8859-1?Q?WWVwoDLGaVGMWOMLoOq+hcwVd4cnQXcLBj6si5eJQ+12XtYOY9cz3BVNRU?=
 =?iso-8859-1?Q?TW0jz9YhBXYD8zgcfMmQiICrIRcuHVEgxmXaH4Fz/Ps3EyUL1BozvwEKNR?=
 =?iso-8859-1?Q?YZdGGBrCYKcxHQvYAvDvK6xHYXpSJPMnExvuhXwNUulk8qYgQXJ6bq3V+Y?=
 =?iso-8859-1?Q?dND3KbEq6fZw+V5aIuCKKjAVw6RFLndVI2Rb2imPVx10SwobrlQsMUOB1y?=
 =?iso-8859-1?Q?fYhl8yrOoN+fFASU3duk1K//CAtFEMknF0gS9cYaMmsyuLKKzrCDzLyWyx?=
 =?iso-8859-1?Q?PvIIwXugEVf30OQdfj8SxHTA0HUfdcVZt94E2xwmjRkR12dUHSwTNezQBM?=
 =?iso-8859-1?Q?NKeWDqI1hE2Mg/aF8sTWAhDlwIDtKjDwlQ7X1L0PSauuB921Kt8L6naLIT?=
 =?iso-8859-1?Q?X9FJSSHXmFP/Ts7YqnNqsqK+GXgg8NTa25ftlr5CSzV61YK/rG43jXW5nT?=
 =?iso-8859-1?Q?PKHXCg/7ztfK32RIQRPb1rfUwdK/TnX+qU?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b18c7e8-e006-4577-ade8-08da8fe06ad9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 08:18:45.4131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p99c6ZcP1TQ98hzgCrmXJfPgbpI4J4yQmqc6HIYOcXBlcHnFeLzL/R+r5MoRnewMAuPoke/SeZivxqfJ697Uz7VIO2CvPPCj1UbgJkg7rSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0764
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently i've missed the colon to the subject:=0A=
> net marvell=0A=
instead of "net: marvell".=0A=
=0A=
Should i resend V2 with mentioned issue fixed?=
