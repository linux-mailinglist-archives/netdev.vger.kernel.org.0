Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FDB319070
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhBKQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:54:28 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:49632
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231846AbhBKQwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 11:52:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsXstBDdsUykiog9vHNV8oB2O0PguhVv7Tqwc8L+Irf6oaMxaJwXEX45vIPpqIpxXn5+cy6qS+DmAbbZlPsVP89Q3X82CvvsrCsyHj5P/dPVdvOzn6A9FCSs8B+hqYGNSTPOrVZZxyf4A3px2vO6PXgIfWh9Omx1YRslZQJFVmdMY01JsOFgWM5gii48bOltpjnhq7VgG0u9840NuNsyUfTuqAIugsZuGo2QlxbF9c2VRDpESFi2MFGA0eSBH4a4PL2pvl6fBWkf94JqMxvFcgV77iVx9NU9AjELefr7I6HGEm/jas0BBYqKz3NrhYQGovQatTQWSvjrDXZx2+0umQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENTpWy0kCvoEmW9RlMve+FR6hI9iVIyeco1K9PrvwFM=;
 b=T19xTRw1LIjF5XFyCwtTDKlfaAELNuJP9i78Yu/mPP8NZOQjGaYHrr3/sAjqvxeO2wWRSW52BLXlV+L1TG4GCmqXE0GV6/LzxmdJTg2YYIC5S750iBpxDr/z71+DL4u/iMsfZ5uHDiaLZptZ9M+OZbpRVY4OFlksGIJ+UslBgXvAQL5eFmLFQ5tlhB2GebHSjIJ8htNHpYWbLQJCmitRb5n2kVgmufl0n1FZDtGA0tmLPn7jzPZfwkK5mbJJEZfRyC9Qqa8XCTFjuvb42kDQZ3ymgTrQgO1/fFEO72Ietqr3++HbchJwGmEonrmbAg3mcW3Hy/gDjbLzwhHWIa70JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENTpWy0kCvoEmW9RlMve+FR6hI9iVIyeco1K9PrvwFM=;
 b=iV8aXYvTV3prWAqnA+XXMl4xBZJFH2tD8To/zfYcZ0FecBlXI2HXDx8v5viy0goVABn2WYrSONMv7U1fKzr7ioonMMbh0buKcRQgQgTpD6zkdvQY/2LBC/LgqvrRWoau1NKBmnGA/h09MQnaV7d41fDURzfa3uOEQ6Swb0KS4NA=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM8P190MB0914.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 16:51:21 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 16:51:21 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH iproute2-next V4] devlink: add support for port params
 get/set
Thread-Topic: [PATCH iproute2-next V4] devlink: add support for port params
 get/set
Thread-Index: AQHW/s7RYjqgW5h1Mk2IoJVXamua/KpTLXOAgAAA9PY=
Date:   Thu, 11 Feb 2021 16:51:21 +0000
Message-ID: <AM0P190MB0738802983F8F323AFDAB7B7E48C9@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>,<cb7d21da-1300-fb6b-7c64-4caaf5601b34@gmail.com>
In-Reply-To: <cb7d21da-1300-fb6b-7c64-4caaf5601b34@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.219.77.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e378fad-40c3-4250-807e-08d8cead4275
x-ms-traffictypediagnostic: AM8P190MB0914:
x-microsoft-antispam-prvs: <AM8P190MB0914D0A01719EC83E3E195A4E48C9@AM8P190MB0914.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SId0+tMOET3lU0GIFxFG/I28RG86ZjHjqF+4yZeVYLgCA9cqiQjnTYFxCHL+QAvuAuz36sh6Y5UNpLwxsCfnB/Snfb4yYaXN66x9fnbjbQL3C29QIUZFOlhyjyOIUAq/W8sJghZQz/2hc0sj31VsI2+VGWdV6yAnnUuVz83ZG4PGKufnNrIl/eaYASoTFEwJHXNODezMmJYrhLLRN3YzQ6gybURC/ORBrL3cS54xA7jVcNBU+Xp5aB8lab9XKXg0az9jFR4saDumj0UCSDES1G1CrZ8bx0Cl9ODvS/W8S6wgULXsr4sjgXUhf6ir1bTLeJB9Oqwv/cKD+g0LPrwA9kAzEV/nxXHs2T+GsQWktWcER7OgoZSRJnseU4LbRTa0vVS6xSjjjQWLjGFsCnnV4q0yZmiEbKdgQMiG/EZxwMuIsxKpmvBZmrDtt2RyBqKbRYj+ba1DyiwqWM/iGkl+vCUGoxT3OsGzFzMiQ8zDvtFyZUtwZ4UuUT/G6AnX9soEMdP5nBqgSGG9uU4i31041g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(478600001)(110136005)(26005)(86362001)(4744005)(54906003)(4326008)(2906002)(186003)(91956017)(53546011)(5660300002)(66556008)(316002)(66446008)(9686003)(66946007)(66476007)(71200400001)(44832011)(64756008)(8936002)(55016002)(33656002)(76116006)(52536014)(6506007)(7696005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?+kJ+59+dwAoO5h9CQ8NpN2lk70kNj/izKCN14WTIldS32U26puqw3KOAIP?=
 =?iso-8859-1?Q?oNOy5X5aH/xu5itjIKaoKgE+j202LDRm/vVBBtHYN3RQKTY6Yv7nHAgLbK?=
 =?iso-8859-1?Q?N7/QZq+6IHYxezfjhWN05xhqrq7Ro6BASpSB/bEdTDqLHEV8nbGl5mjVFH?=
 =?iso-8859-1?Q?9X0N2ijbRECOP0T+Q93aSchqUkJNpAHX7d/WdniV/PQxHhpsmKonA9rvey?=
 =?iso-8859-1?Q?QipKx8RMrONJ4DBBz5waGzVtLE5cP0bDZLRprXN+zvbs8v7mB0M4NeUUvl?=
 =?iso-8859-1?Q?606yMsdHXPuciHaPzGxiTEuRGig1WKczeshtr4kBPCOlhqdL8lESDOuQgS?=
 =?iso-8859-1?Q?gnV5UIKMBtlSBZS1FD3VNk+WQ/8OUYoCG+zK/572JrSM5apm7HRBk3dCB3?=
 =?iso-8859-1?Q?ztJC+yY1XGuwP6TZUFUnlwxImUd+Qa5G7zFrK6ugnDDmAaNvKSPNuI/8Er?=
 =?iso-8859-1?Q?gQPe8aLYXv3jzM9EzEexdEak/tgn7z0hNRiIohZefO4/U+M+TYVPkmNx2I?=
 =?iso-8859-1?Q?ZmrEJ9m5hGhIvJQ3nxazE/5oh1P8N9JALGFtWAcpEMxmGmnTK085iPP6CQ?=
 =?iso-8859-1?Q?4rdg1C2HIM7kD1ZMaP6oNXGeJa7Um7VYxQ1KTi3ghZCfIXxOpcd7kF5a60?=
 =?iso-8859-1?Q?OowxqaVcurmMm71f18cfd28Y9BnnXWD3eAxF45Xj6GdiY8COwXfjARL9Hi?=
 =?iso-8859-1?Q?tGp0ti1iU2pGmzhptIsvq08eXLs/mwSM/nGyKrAoH0V4a6FXYrJibis6oU?=
 =?iso-8859-1?Q?FvkixxbW8uox720uz6zivxtviRkKvPIgBt71boK7rsUDBkT8HGiRzEZCtz?=
 =?iso-8859-1?Q?HkNERskSNB9ilildGM9N1/YRfPSG4mSMU6vQdhVkVpAL+6tuFOa9UpiiV8?=
 =?iso-8859-1?Q?KTzv62bnMnHfJo9nmJhiqmRcObpQLH2ZzG8p2ozJzOE5oPAp8HJI4oagu3?=
 =?iso-8859-1?Q?ud4SZBJy05hAbVIszIqFLDgFw1kKI6LEMa/YcXtI+t8ZOswAbqGsmO9Ybd?=
 =?iso-8859-1?Q?WHKsqvrf8jS5R9r8ogoA9ff+6VWktAh4Bk+OvnVY/bh/Re2XRz0HF0q0UF?=
 =?iso-8859-1?Q?MW3y5BhiKTMYBVLD1UbVBoekjM2Bw8TfbdkJxtlhsayLwfGyF3xwXFe+8u?=
 =?iso-8859-1?Q?C7Y+yfxZfFC0CSGVeCW79gjVR4uuMlpdcOwEvB9mt1jMQNVUZ0N6ipI52y?=
 =?iso-8859-1?Q?HnpiN4KwoUXxVUJ26/yk1RnYFNCaBhU52nZRAQOBn5Fzg0lENGVTXwdzw0?=
 =?iso-8859-1?Q?9sKdcZsuG2Mqoun1ZUClpkv7+LQ3Qiig42N3U3jJ5uY7xX0a3lDdcfnbtU?=
 =?iso-8859-1?Q?X+tHPOjxFTZlr5k0/BMbHATX0Ncwspx8S/FQ32LQmaZ+YZw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e378fad-40c3-4250-807e-08d8cead4275
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 16:51:21.0465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Knp6FWJEmj/uOPEpt0jan/itfkZraL56JRpyu6FnxbslIxknSLYbEVq+5Agx99GOCTI+vn4H4qSvJmuWGwaHoGfvBNlywsJYbYWfDqEPw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 3:31 AM, Oleksandr Mazur wrote:=0A=
> Add implementation for the port parameters=0A=
> getting/setting.=0A=
> Add bash completion for port param.=0A=
> Add man description for port param.=0A=
> =0A=
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>=0A=
> ---=0A=
=0A=
> applied to iproute2-next.=0A=
=0A=
> In the future, please add example commands - get/set/show, and the show=
=0A=
> commands should have examples for normal and json.=0A=
=0A=
Thanks;=0A=
And yes - sorry; i missed it when uploaded the 4-th patch version (was pres=
ent in V3)...=
