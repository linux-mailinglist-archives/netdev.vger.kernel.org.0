Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857D52A4DC4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgKCSAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:00:22 -0500
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:52208
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728133AbgKCSAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 13:00:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2RKerbEFpD5NhE+BoOk6NCMylXgQEPPtLHS06kLC95BRoYqRI1co6qciO/o2ncr2zPEEclzRRecefNqfuGGVmSTK5hvdwcgTXEu1RttR+xJwr2J5opnPUMiRGQZh74GvT7UgtPziGaiKjskxvZUE40WDIO2CSv+Vr9/u07DXbnwgNW7umDEQV4NoBcFm7vB+1UuTBLmXrlcRDaGFv4eustePEiw9wbP546STOCyT/ncF5siCt3731uindJaF4f55YQ4nOOwAbgBf+E7ClXM7hquAvLyaUj41urBrGexAlJ97+TrlQzBGK89lWMQtDJhtZlIwkh74ZhDSKg3cFJy1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVFzxZLVBdW5FJMfJFruf2ErwE0utObXctGFHzF72VM=;
 b=a0QwIjrl37SDxPXxh2KndE0Efxvw1jyWO6gf8J+Q9XGeUgJhzQAbRNtm5bqPj7dRxbnLL+AiiWvc101rEkni6Gf/5Jh4T22upDrrYSfseWyVL4OhxMRZYrYRZRncDfVIhtPrn8Jyi3G5ue/m2W8HLK3lkemYhxzapd9WaPxPPzablTFgr+VsAElK9tp1c/8hKBX6yq4Dusa5oA/RCzXL6pfwL4dueHlMFRfGCeHF09aEh+qnqWb718Ms1Mwqvbux7L4DJAS8DbPjgizhotnWXhgUYtMS27VJPfv18wy4NhGhXS0Do52pr7WVofjULiC0fXnicPTs2newFfl2tSpD2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVFzxZLVBdW5FJMfJFruf2ErwE0utObXctGFHzF72VM=;
 b=fGy6uO2n0v5156zJXr49W9xjNSMUwn7P1ckxy2r7BV9Ch8P5m2wG9LX6KAmx+h/umAt6hPDEfHzz0g1z5MeKRT5pI1h7XT9bPyfdLwjB1jU1DpsI0gmccMjQogJIp0lFJM7D/AAvkx4p8dmL8Y42G7q6qFQjH0fFSUKq29gFp7k=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6512.eurprd04.prod.outlook.com (2603:10a6:803:120::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 18:00:17 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 18:00:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Topic: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Index: AQHWsIORA0PhHKt4BUWPz2Nre8xYCKm1TgOAgADvY4CAAHA4AIAAB7kA
Date:   Tue, 3 Nov 2020 18:00:17 +0000
Message-ID: <20201103180016.bg3djnrqyqbpbpos@skbuf>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-10-vladimir.oltean@nxp.com>
 <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
 <20201103105059.t66xhok5elgx4r4h@skbuf>
 <6c9fccf3-c3be-024b-2aae-e27a61d9c8b2@gmail.com>
In-Reply-To: <6c9fccf3-c3be-024b-2aae-e27a61d9c8b2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: abfd743e-a21f-4bfa-a573-08d880225273
x-ms-traffictypediagnostic: VE1PR04MB6512:
x-microsoft-antispam-prvs: <VE1PR04MB6512C2E4DED6AA21EECFFE47E0110@VE1PR04MB6512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BELi0vdREgXEcHVEL66x2XcIeUX+stzncHDQKtqjwsNiQf1noVkHzCjJWXsSoBrbrUPlqyv9mvzffQv7D4jDsIoQib7kowlodyerzP4aVvWPYM6P++JIJmKjV/+o9ifR4j54Bnm0hmrEcwxrk2xMRbxlaDCkG27Jg0cet1eUESPiVU3PKtxZvBfj0QOXRI03SZE99t/wzLudIGZhMJQspqM/NZTEuHXgH8Hst2xrhO2hBhJLwewUn1h6vA+l8dV+BHerezfVw8uza7pexL5EgDIHzhv+sNu3hCatpz1i1nhvQB18POFXmRM6ymRrF94E8siaQBbqLpZYCl/dkppbzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(39850400004)(376002)(366004)(346002)(4326008)(86362001)(5660300002)(83380400001)(4744005)(6512007)(9686003)(8936002)(64756008)(54906003)(6506007)(6486002)(8676002)(26005)(66476007)(66556008)(316002)(66946007)(186003)(6916009)(76116006)(1076003)(91956017)(71200400001)(2906002)(478600001)(33716001)(44832011)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fkdFjclMm5LYA4KWjb2ZyfdpDihgXjmL/upBQ9DqUuz7TG63UFPM13S7ww8jP8LxZz3J7miFQmgFwB9rggEmfIBbQOX9H6o4MavqN5P1jT9WQVzPBM/0ufR8AVKcpgvJckbOttL2jDSRIAZy5OFUqnXl4UdekLcY/ty2/s6MSLlq93Ie5p/E0VgixrMx0uoR9JnUgUvajlPbpKZPPa/FnfGiiBINxWwBPWVlVBobWsvJgcivUel3VkC3YEFBOv326Rzz3mLOTcUuQvIrjJJw9iHpqWTiqRQUcmuiyRB7X2K27vzwCfwiINuSd3iji7K1FP1BYAfNQ91qghyIemFdkiuTjbUzZPT7YkJ9DgQFaz0tXHccCk9VXF+YaHGvM9jmZpv2ALo1zr84w8WJaQurdmDrDNJ6cK/hWPI+3iNyPVHag7XTOeBdfxF5Cx9uqBmRN/5cor+8suVBvpTyxtPLf3nVqCapTqC4NuFV7/QUAD+Jj+bPlZKqLPx0TZMULgl2uVTRAI9KJ2x+jgRy+VkA1NvudnhG8N9inVq2QX7Uic87KoAQXDemcGtMtT6GyRtRyPREVfNuVUIt7GYR3n7rpPsOey51XGCZ55sMMyh5sBaSmr1p12pNEB4hQoOnx3jdGF4B6ye38LMa/66Rkfdegw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <097099D6AC12C2438A7DB3BD89BEDDF3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfd743e-a21f-4bfa-a573-08d880225273
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 18:00:17.2779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DKpV8+bgEyHD3JY9ttcJCDIUSsmtonFSbm56OZsJ03FZLIZo6TW+Zrjfive4u0pKCNSPWSVKju405ySP7CFHUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 09:32:38AM -0800, Florian Fainelli wrote:
> the length verification is done after the Broadcom tag is stripped off
> the ingress packet.

Aha, that makes sense. So to the DSA master it has the proper length,
but to the switch it doesn't. Interesting problem. It must mean that my
switches pad short frames automatically.=
