Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF28666849
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 02:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjALBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 20:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjALBJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 20:09:10 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2098.outbound.protection.outlook.com [40.107.114.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A924740868;
        Wed, 11 Jan 2023 17:09:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwenzJAikccbtKgp2n6rL4jmwuD76P21xG6RGSMsd+aCdbPKbMiUzK1dionke7wz62p89f6Zu3w/hqA7DAyHsgIfZCjweeNOGSOZxHfBQp6drIKV14Bc+teEymi7YLNKqjkxGmiVfSkgo1Wpe18HV74bJBm3e1hMmrEFtRZh/hZYc2eUZTUB7dq5el70KF2ONHpsZgf4L74VCc36QywKD/7PqWyDm5/X++UJ4KnpdDgEzXwI98KUPf3ZhBnAXlmcis1zL/Ijbpq07zf0fIVUBTQGCpJMZfIpTz7W1TZozVpMyQT8IOwZX7XHPWGWQfOFh/raVXFEAT26T43eVeALyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXnAtK0DDEyxmhqoTCadWI6TalLcc+evJZa0iDf/yDY=;
 b=j8dhFvvNw7vKl4UflGqUNGUSMEXk630rKpHZ2esBjpSwFdyesBZN+iRw+iMe/8tyUjfwuvoNu3tdPCTi290ocGL/nUZoywkwjAuupNijZE+hnvCFrIFmANCVSI+AcXh/WbH3X8aJ4/BWH2F36T8ovlmwADg/NkP2amWytJTswulaGlNTXLquuYGB5BwhDFBme/YlJiLQVMQfR5eMMjHWf1j0hAoluoGDF5I2JwpuLwIQUziefMkyxOxq5Af88B6R2qVdALo0bf0r5ic9H41D0WLrRRTUNJKRaSBcofN9NPDtWVp1KYBWy6UbzJhHSnw+8Rj5CwEveqexmPbrgGwh8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXnAtK0DDEyxmhqoTCadWI6TalLcc+evJZa0iDf/yDY=;
 b=SUs+biRS1GUZ8AANhI9WzZx2+HlJ/0tkV7d8Z7e/VFxAasbhZByfYGqq1v3AxsD6+PaJUAHvY2CGYeeqR+5259xnxZvBF2As30noZpdkmllvz/dypt9PSbC+7UbVHD5TzM4mDgARdFBxy9rKK7gRqysfuIXn8qUsDJnAnO8y6OA=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB10714.jpnprd01.prod.outlook.com
 (2603:1096:400:296::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 01:09:07 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 01:09:07 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/4] net: ethernet: renesas: rswitch: Modify
 initialization for SERDES and PHY
Thread-Topic: [PATCH net-next v2 0/4] net: ethernet: renesas: rswitch: Modify
 initialization for SERDES and PHY
Thread-Index: AQHZJLC3B+YSJ3TTLU6rrD/KOdVcsq6XuEAAgAI3SUA=
Date:   Thu, 12 Jan 2023 01:09:07 +0000
Message-ID: <TYBPR01MB534184D1D7CFBECBA2C4AD64D8FD9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
 <Y713vpQLosOkfeey@shell.armlinux.org.uk>
In-Reply-To: <Y713vpQLosOkfeey@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB10714:EE_
x-ms-office365-filtering-correlation-id: bd000689-d527-4daa-4eb4-08daf4399ab3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbDTOeVkxhM8uRhdqb6h1LlOwsfcNrZNh0846i0Zwc/SmXd48ijN4Lozjz0FQPRhwX0BWpX8FuUdz6NzyL6aJ1gH6rc00kColDQtqJDmh03Bc2gBM5CZ7thMogWKaa6qjPovq4kPRUaTXdH5UqgZRgFTOV8xzFH7mGoRuecHTrq9MReyPOSHGxmNbuG+xsFIkePjH5MxTJkl0wGO1smfqKYjNpK+R88c1cHlc4yqqyAdA3we1tcVK27/xHkCtXkdlRPOI8jSIcM1CtiOtBXCZktJpSUsOyE7evD2bxZgauUqK//WjncTqGONPul9oOShz0k2pUo/ztXycAcDIFIuHyL/5EdITquUlI4wqo8Vc7fK87dRCY8gTIAEyF8AsXGx9WXVknb8c9v2jmoRRCuJxeTObm3XgJ39Or1F7Tl3ZNN0mqqWq5/lC+gSjuvd5vsDUXRWcdtQdYfEynJP5TmDQcl0vGr27HARDnj4NXavJHFDkCWr6QfbN/OQvw80n9S9K/qC+AxrwyDT46S8siYq8iYvwbZVg7W3kkS85bFUezNmiFre6Q8/nCdjcNxk6PYCgvIXG5npfBmICN9GQQgycD/SKgubka7taxw1kz1+I4/o9j3QrXfzD7u9EVSwIgo41r5Q6r7XdYI0xcyLfurDZdve65v1jqk8hhJ4tdmo7RTyka6kxwJIhyxBs0nkVlx55clWRkrzFV3QNmfSZM8gqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(186003)(6916009)(4744005)(8936002)(52536014)(122000001)(7696005)(6506007)(9686003)(66446008)(33656002)(66556008)(66946007)(55016003)(5660300002)(66476007)(64756008)(478600001)(316002)(71200400001)(4326008)(38070700005)(41300700001)(38100700002)(54906003)(76116006)(86362001)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7CSk2kitgMtIssskidt4qr6Xa5MXnnYkah4wVw8KNGj/ahaofHIH0/SMA7nq?=
 =?us-ascii?Q?V8OKo6bc5KFtvGcf9RWqVGO7qENBoRx2SaWb4UWOp11/1jFH8YKuSI4sKwcl?=
 =?us-ascii?Q?17XUWT38N9zZDdEk/mIOr9oPhWxRRsSy84oIyZvi1XTqQLyjRWBhQ6EI5cbu?=
 =?us-ascii?Q?Fx9rZZaReuM3mlgSNDrH5x2gOLLxHNVXdZAbQuGcceUjAHHJuudkxJcDYgDc?=
 =?us-ascii?Q?wpwZOAYtciuBo5YbEyy0BnkI27lrxsr8M7KfDUZY/QWfC1HsDhwo2vpd1wWh?=
 =?us-ascii?Q?fG3T0LcgE72VukoPpvl+D/AkAcZNnms6jDoU73vnaqIJUWCPzLUcwbqs0A/T?=
 =?us-ascii?Q?EYG9pt3xFwONOdeqS6B+LvJJklPa+vBcMOQWfXxChig2gbMpWHjFMCuyYOfD?=
 =?us-ascii?Q?xuhpAA0VvvkQIaexTt7WdPVVhH/NUzFEDM6RiQyQDZRB+CE724gkSNa4+hBR?=
 =?us-ascii?Q?1q7YWojikCxh/O3OLMXGOtvVzbCG+g47trh8aNPy7jCigGZuDy/aZmTcLQTr?=
 =?us-ascii?Q?WobNzLV6+WeywxzTGMsGWqHOxPkp9nHVCGQer+mqiCJ7fu4gfV2UvA07JRbE?=
 =?us-ascii?Q?k/NSp6lOc0G0LhM2sJ0vtoEBfkP7bMotK85Z/HWcnJ0qSoqg3ElaUD3uqA77?=
 =?us-ascii?Q?HAssucLnbvAQeN9t7LltIfba2g5CJ1cdGuXMqWTUACASmH+zpAXOhNLKuJpw?=
 =?us-ascii?Q?KfSLQzPMQa383FHOcf7cYFJd0JtFlxkviBZsa6KOYG5GftxHye66N+x6esIZ?=
 =?us-ascii?Q?bmwC33meYlQA3EOFjHbWA3LSh8lPNgQCUs4f9RJB+OY0FX0Yzd7+qwFybcRk?=
 =?us-ascii?Q?6qByk7KLhQ+G44QPOQDldAXTJQSrLGjpY7D7IZJNVmRlv3fx8dNJNYWqWbui?=
 =?us-ascii?Q?edFigje825MaC32svoSsqEuECED8qDbfsw7BKYUzeIKZolIIumKrikgdAd8N?=
 =?us-ascii?Q?lyrizQb10GVYECrT0TMl1Wv39617ntSu1WFV1uZFu+Z6kTznjXwdJeIkkRPR?=
 =?us-ascii?Q?dHWb3GHnowVidiccpB4eI7+Xf5w+1Qy1tQyrfGqW0HgtUy+seDODQjUyGWne?=
 =?us-ascii?Q?P3kO3Mnl6eNQiAgo9k8b+71p1l6ErjEwQNVm2EY5qO7NTGhMrZUq8+lJt3hl?=
 =?us-ascii?Q?TdEHs6Q5sFxQ7c/QlN0FHdV04XPxde8WPi+sWQT49JX4WnrjslHTzfSSi7RN?=
 =?us-ascii?Q?bDjp5ERlJb5Gwp5xgfFylTlLRLEv71PBDRTM+u3vGfGdOknSQHCS2v2Cl/VW?=
 =?us-ascii?Q?I8yDLnEt67F62dHRSwGunLW4+qEybAmBY7X8AKhOx1z+1zz3Nt96OnzhKVs2?=
 =?us-ascii?Q?18rj65/9UK+Y6O7qMSfQBZfa5RYg2q/m/+OpwMXssWfHQq3+JUMEenziTH2y?=
 =?us-ascii?Q?8cvXubKqjEbxZ18lcKEA92p65qZNajPO3QVtR87yOIJoHaT4M1jfLfbiHMsn?=
 =?us-ascii?Q?L8P9CV0iJuEPWzi/ser1mv3Q0h/yJEBhpwidIG/iHhR6Uv43oc3uUEu6uQeA?=
 =?us-ascii?Q?TD7MjHiG9llb8esFDA6eSlm6Bj/LoqmMYbF99hF8yKEo1DlPkSDPNDpV8IDb?=
 =?us-ascii?Q?FSxd7HI+rv0Y5ecxXSVaJBABBBD9mpUoo8/NL113/AxuCYKecXMGYqFfBb6H?=
 =?us-ascii?Q?+t2pfmohSvOh+w7wTvkyPYCyr20UeaI6x/mpSvV8E7UinJKWbZvIlMbsliXF?=
 =?us-ascii?Q?i78HCg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd000689-d527-4daa-4eb4-08daf4399ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 01:09:07.1633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3iWsS7ADCz+jsbi1qDjPU2a0iyRRvYp/i4cJa0rrrA+KDbkDKsdrdQ9AB6NnQFqekikx5IXHJruItTHnBuIF7QRyuuT3ew2rjf2AosD3Kc7Yu7lD9DrbrpLYwrdrhm6g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10714
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

> From: Russell King, Sent: Tuesday, January 10, 2023 11:36 PM
>=20
> On Tue, Jan 10, 2023 at 02:02:02PM +0900, Yoshihiro Shimoda wrote:
> > The patch [1/4] sets phydev->host_interfaces by phylink for Marvell PHY
> > driver (marvell10g) to initialize the MACTYPE.
>=20
> I don't yet understand the "why" behind the need for this. Doesn't your
> platform strap the 88x3310 correctly, so MACTYPE is properly set?

Oops! I should have shared why the patches are needed.

You're correct.
- My platform has the 88x2110.
- The MACTYPE setting of strap pin on the platform is SXGMII.
- However, we realized that the SoC cannot communicate the PHY with SXGMII
  because of mismatching hardware specification.
- We have a lot of boards which mismatch the MACTYPE setting.

So, I would like to change the MACTYPE as SGMII by software for the platfor=
m.

Best regards,
Yoshihiro Shimoda

