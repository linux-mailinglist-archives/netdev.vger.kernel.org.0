Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF13432485
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhJRRSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:18:39 -0400
Received: from mail-eopbgr140120.outbound.protection.outlook.com ([40.107.14.120]:17421
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232587AbhJRRSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 13:18:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvXr1ThTpRpnJD0GgNtu9I4gyDAfbEP3UPjn/YZqFDpe8qcQaVCZxlCqrTsDjq1eGMniDd0UD86IaQycewkxasDvnv8kE3xWBwEIX7gRfhW1nF4vKgt/vnKXDXvIMj6uQHncGB3SbfPBB8yrYwk//8JQ3SYY8gOAUDDchpqaqQT7IHA2Bgkbv0CzMRvS9B9b5O/MEhg+3fE86SGUDcnt/FT0eVHNl8qt8JT1JK0KcHMPg61GBUdh1lPzF4Gjz84Fd25jfjQ7Y3m5GrOK+dQ2pwB1967G8GTAFPfqd6RSAVZtztvR5ACcPZ+qplkLvtesBmY7oiKdxgCCFL9VhWXcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ec5L5TptzAHNm7Luda5hyHGvR3q/QQo+EUU4YJgc+Gk=;
 b=BucSG4pGiGYPgLZp06clW/KwMmZh7YZkJofnJxFsOijwPKHdg1Ra3/cYGoNgGpkt/y7L7j9CtCkaOU0SbO/l8iPD+YsvBHDxOFDnOSwSkwNsqsO5238uG5Y7VuiZl6rZyGK/3EBaKbfQ1/g8W33S/E/0HU+Sit4CxcRxbNyBY90cA3eDYyjkSS1rluHGY4xaSBdMVsxZr6FsE2lQG/vP9pHx/54VdDC+/RBUJxrNtJ2fIxOO+NSPRLnCqk+DndDHOgciAO7K/0qWYHFRwcASDCdgk7pUnO1ZEwyn3gB5XDHx6Yjnt4CtlITcn3wLxkX6nI/2HyIYqffWJsBocT3aeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ec5L5TptzAHNm7Luda5hyHGvR3q/QQo+EUU4YJgc+Gk=;
 b=MXPW6ZakWfVDkTm/hkKyBaPlxiYifctJw3ehv+gv9Wi8I75AYr5VfnNkqgXQfiYBLtQZO4F6NEtAaFTKTvuG/e4QpiHhGc35RXs6mvQgsrf/sv3MhJjGLweKXVeM/ZNcOEFTZMQ7cFHP/aXxZuu13NJ/ga95WZyIRIxapmDC60M=
Authentication-Results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=toradex.com;
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com (2603:10a6:10:1a0::8)
 by DB6PR05MB4549.eurprd05.prod.outlook.com (2603:10a6:6:4e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 17:16:24 +0000
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783]) by DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 17:16:24 +0000
Date:   Mon, 18 Oct 2021 19:16:21 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        christophe.leroy@csgroup.eu, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
Message-ID: <20211018171621.GC7669@francesco-nb.int.toradex.com>
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
 <20211018095249.1219ddaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018095249.1219ddaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: GVAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::21) To DBAPR05MB7445.eurprd05.prod.outlook.com
 (2603:10a6:10:1a0::8)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GVAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 17:16:23 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id F2F4510A0FF3; Mon, 18 Oct 2021 19:16:21 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 870c04fe-7966-434e-932d-08d9925b02e3
X-MS-TrafficTypeDiagnostic: DB6PR05MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB454959C2A8D29638F2E67D12E2BC9@DB6PR05MB4549.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+R5/qsqgVS3QOAKrggarbJRDaXXVt/r36+ZUOB+crduWnLTg8fbjz1k+22eKmo4uhzdvo9OayW9buT8ZJQ3Kmv8gRBVtvhoXCyAjVGNkLal64pY9TGjC3T5jTzwGfL0aWlKKiP6uG5SrAPFgKkSApw8QDbAidsncvNh46tuWBsZvlLCn+CUq5zkNselkkn51isl21gjo172CNKeC8ifrgTMe408AFUg8rt9UYyUdeLEWicSCKEEl4os1PH6ogDxu6Fwrn5jFwTm3eueLDCV579AsfvHgdS2d+ySMEj7us7blDKGrjeSyz1j2LaYaSmCk6zYVshOD2iQG7zvMb70/v6Imve+0sOHi6wtOacVCqRxNrTKazneUOL7llmq/rfV9vr5UvZAYMly9Kt5AMpDT+tARTXVyUOSSJz3+Xxk/jWt8VSJ/CUnQSfuhFxEqMaU1tncs1/AFD6ppBvZNV0NvN9qM3INnmoL+mSlyF8i1yDvcb0zJESQt1mMnsAFI0MdT4cugyRoUpJSGTwdGvM++B7/FBucbxJA2R99Hcj9Ees1yNnAmmvoYHId7nZ5BSTw876UWlV2DrqI/Wj3II4PDqXyY/DOz6mOEMrKtJ+LDfdEWzOjOchCb1oV1Oy2iLAKzYbt7hDUMws3tqITIx/gMUMONzVX6AjtxzvQ8uqMRrwCH1aCHudZ/sx2vq8aIZ0EgMaZ1apk2My5QbZE4+3AzAIcL7wwL9U3WsHbYy4+xVm+do6JstPfD3uNjzbs/7w1QlfZwtTKvJl2XYoS5UtAmLo/hW38CiVdsW3WGic51G8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7445.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(4326008)(52116002)(44832011)(8936002)(8676002)(966005)(42186006)(316002)(33656002)(6266002)(54906003)(86362001)(5660300002)(1076003)(38100700002)(38350700002)(7416002)(66946007)(508600001)(6916009)(83380400001)(26005)(2906002)(66556008)(66476007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?moS3REKXWjcGsmRkPGXT+h7iYSEyut7t+4lfFv6Ql/fzqNN1epucV8RSTWWh?=
 =?us-ascii?Q?UZxc0uld03zqizB0+JNxni6qknU9Qss+DT7xEd2qAyy405ap6EKEr4gU/RVj?=
 =?us-ascii?Q?J+4/sM9d82tBc+0dvJdxZlLQfvR5t82pvQixzXeU1MChiBIyBslE+viK2TLu?=
 =?us-ascii?Q?NfBQkVS93Y/dvoNcFy3ivHYujQCEZIhMVZ71XXZsBWvX9CfW6lcNXQn3ipHp?=
 =?us-ascii?Q?SbplQRJ0c3SGunkiK4AbJ5eS1kuA0qd9uL5xF6nN+tTPQKWZHg45k2uW9EnC?=
 =?us-ascii?Q?i2TV/P0dcFihKygBxt3ympvAhg5hFVD1EwV8ia8lI6e3h2RSo8MCRrteSvQf?=
 =?us-ascii?Q?GZo/NZwaC5RgWP9bfTnIdBjCfEBH5aQGX6S2b/eGU5W9tSuZUMPWtyawYT0p?=
 =?us-ascii?Q?/2FpM4GrEUNWqvXIJwmhRvQKlf+EByDdE1w9FqdGWY3pnbvMvqHmsw2h0mTS?=
 =?us-ascii?Q?GIAtRvOTavY9Sy19FwM4Qv+6NO25kQUh9JUqP06GDUUfEqbE5nGJ589xq7Gp?=
 =?us-ascii?Q?mv4Yws9yXhuJFt/orlPaXTVZGBnNeEwsrMX9hyJDSSQNvhdnY91cjttftu6+?=
 =?us-ascii?Q?OiKGX+WGILEY5JOmw5dk4/gxYitXwC3IJItjGTKF06TIjCo/OzZZUkE5RMSY?=
 =?us-ascii?Q?TxLdeciMY6xnQWeIQDAmWSEhaA/RT1s9cUNIYP7tEMvMQOn9MF00D1c5N7+b?=
 =?us-ascii?Q?rPZ+S1JQHMeRkiK2UoGXYJNaReM1oD5v+/4smuv/iNl4AFGXCJbPl5zWme8P?=
 =?us-ascii?Q?Galh3OgX9tzMC8uFjdDT8Qg4fiPEttN91Okrp/NahD/y3LM+Fu6Veb1Jovrp?=
 =?us-ascii?Q?5eFFtrSbMrjKmfFJmWjDdsph/mTDe6LYcPbQKy6HWpYINAuUz234VkXhb4qg?=
 =?us-ascii?Q?dErH6U1YNy58DYeMDVq4kB4x12gqvSNAwA1qQQMq3JMlqN6ZCCmyTkpYdJqh?=
 =?us-ascii?Q?X6brS3s1k00zw/+NxVfKG4Ik49cUAZy3oypPhNMwyfqcJQRpmH2cLwHEbId6?=
 =?us-ascii?Q?ng14k+Bdt9CcEBv2reYtYj6m9jGjQnNrUS8OOvYrdMnEr5Own5oAA540TebH?=
 =?us-ascii?Q?eyKBZeEJFmaUyoVC7aL8I1IjEVY33JsUwkvT9h4xmsDGn3Z9Jw8PBjBdsJz4?=
 =?us-ascii?Q?9WXVvWdroY8Zgi8I2qy1KCM6K6EK4deObntdkH+d4o6tNtbZ9WzXr0oZM+Wo?=
 =?us-ascii?Q?HzncXN0h5TcgibwICrJRJOVNWiH2ivyLyI5cXR6SPSO/xB4S4pjIt0qCEa6L?=
 =?us-ascii?Q?GyKkr7yfUGLwvdMUcUNJiyw4wRdHVayW3+TdYbvHulHxaInSwuKGZ2s6gGJK?=
 =?us-ascii?Q?OFd3YzfYa4qzdzMjBqZT8iFl?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870c04fe-7966-434e-932d-08d9925b02e3
X-MS-Exchange-CrossTenant-AuthSource: DBAPR05MB7445.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 17:16:23.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N9tU1Zc4rD2RiNdVyKJMWr3mzc15lKD1on6zmCzBxghbHJB23y3Xzlie46ScZNocXcEcQEUyZI6GeAOEPj2/916PBmHlrpcgrCGtlr5v5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Mon, Oct 18, 2021 at 09:52:49AM -0700, Jakub Kicinski wrote:
> On Mon, 18 Oct 2021 11:42:58 +0200 Francesco Dolcini wrote:
> > From: Stefan Agner <stefan@agner.ch>
> > 
> > Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
> > the power down mode bit (0.11). If the PHY is taken out of power down
> > mode in a certain temperature range, the PHY enters a weird state which
> > leads to continously reporting RX errors. In that state, the MAC is not
> > able to receive or send any Ethernet frames and the activity LED is
> > constantly blinking. Since Linux is using the suspend callback when the
> > interface is taken down, ending up in that state can easily happen
> > during a normal startup.
> > 
> > Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
> > clock recovery when using power down mode. Even the latest revision (A4,
> > Revision ID 0x1513) seems to suffer that problem, and according to the
> > errata is not going to be fixed.
> > 
> > Remove the suspend/resume callback to avoid using the power down mode
> > completely.
> > 
> > [*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf
> > 
> > Signed-off-by: Stefan Agner <stefan@agner.ch>
> > Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> > Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Is this the correct fixes tag?
> 
> Fixes: 1a5465f5d6a2 ("phy/micrel: Add suspend/resume support to Micrel PHYs")
The errata is from 2016, while this commit is from 2013, weird? Apart of that I
can add the Fixes tag, should we send this also to stable?

> Should we leave a comment in place of the callbacks referring 
> to the errata?
I think is a good idea, I'll add it.

Francesco
