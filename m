Return-Path: <netdev+bounces-7673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59563721076
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00588281B28
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3EB7494;
	Sat,  3 Jun 2023 14:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3FD51E
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:30:42 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2129.outbound.protection.outlook.com [40.107.223.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD8F185;
	Sat,  3 Jun 2023 07:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFcW1bPjBVRbIb6h+6ryJMMtkMCFHTTZgHsLRWxYzjAUi//yAfMmFXSXy8fOABSn4zbnIRcNm0+0e1SeETAwgTwd0W3lPR1frwpzKhdL4hKYwIV8Fl7F7PwciJlY37gM5K9mfEUuJUwPA8KYVH+rKzVkw8MD5SqCs98Q7Luwe2PNUPpvia2Z6K8OmidDa4NYy3IpRIPDv3fUOMf2AJd3m5uB5wiQDlK1WePJWlITByJAb6YPXWQWqpgW+RlJQF+Oaxji5/Nvj7fWF6snX1GIU7VD7i1fKvO0cGWWwr/DMPuzozpE01rhQtkWTSuEZk3OQcY7FAhhn4GP792laCNrfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDkbUaaWUNC9SQKP6RJ1vBh7oRT+pd/iM3p+E3I513o=;
 b=VxjNXyUch4dRRqW1n9JC1ug33z4mUmtKarSkRFYXlluomw/htg7/Y16r/wFDqJldqytStxnIRUYY9nas8+LpCm3OLzcr3RonEA0UXbpCwPA2wdkxvO9xGt7TladvLQ5eFjvieM3fOSpJErPmIxqFEzfjVDU0XMJQ79xDJ+TE6JF1TBji1PspUmmlB3vyiUiUdKXZxIi9H+BEk3Kgc4hOQWRBROLdvz1uGdbt7MXthgFKNWgJMVvh6E1UqSoVA0tcbtimuw/1NjhW0ITUH/2FM/5YB9LP4uiMIUMxU2Rdt4xN/gyzqMODxXU8K9vJhAB74gasVCnS9yUd4Q9jd1YnFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDkbUaaWUNC9SQKP6RJ1vBh7oRT+pd/iM3p+E3I513o=;
 b=r7eBrgzkvGiIkgvLXpQSKfVynuvVSiOhYKlaLTAQhBfnpRvogVSv2X8nvuM3cnzxVh5Zl6SO0nW+lhKtBAoAKjuimCvu9K1XpEgiwU6HfuMhNWqAjo2N5UdaUKygLHtdxbCBp1Ifo/oxirZ/dyB7034k2w5YIX5zRis9eBUaXpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5878.namprd13.prod.outlook.com (2603:10b6:303:1c9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 14:30:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:30:38 +0000
Date: Sat, 3 Jun 2023 16:30:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Robert Hancock <robert.hancock@calian.com>
Cc: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Move KSZ9477 errata handling to PHY driver
Message-ID: <ZHtOhhH/+XrcbxFs@corigine.com>
References: <20230602234019.436513-1-robert.hancock@calian.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602234019.436513-1-robert.hancock@calian.com>
X-ClientProxiedBy: AM4PR0501CA0056.eurprd05.prod.outlook.com
 (2603:10a6:200:68::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d71467-7fbf-4c0d-05e8-08db643f19b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5bTRC0/pNuwF9XZq/rLYXi7onEw1TkLHP55MjmdBsDqc/0emsp0CHtm27ppJOmh6L/cvwpPysm/GRlRTn4txYhqNeAFQ9sUZWszkKEAIe5tgVqPpkdCpSOu1sJNvb4GZXctgIzQuCzC1g6F7ZmZau94jM1/ekBl3wC1OXDoZrAfDUZQMJzeeZf8Ffuae531FjrpGFD/3BGEFn3Ai3JOoSxmpRW2q7C6HlnJydJdMM/A3lzr5S0+fzVQgGVuocUyA943Fy7actAGzAXx8Jgkc1Vxhx8r7RorS3wHmMdSZyCXodemGBrcZJKyxhOz04fZo04YXTox6RBuR/FT7AUhNIs2BgxlBVZgOKzwkxb35Db5ktwyQ1j0BpYl85rNX4/hVaIbliNvkJHlJ761fviKCwV82uSlqmjqp2bybYv/TteCvBk/U5MAs7Cap3RNoo4qiF+xCH1GhTMhEm6Ul6LGbuW2IFx49ZR19/DVANhyQDGOViZeRmFlfvJkn20lHSjrdnJhCkJExMbzyHvcuwfup3ICuWZEkUsxyssikXZozYjPgFl9GsNuNQHkoRqaQLvvdankkJeeZD/i2CpqcjDi5GD+W74FTGjx1OGdonZZzYRw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(376002)(346002)(136003)(451199021)(44832011)(7416002)(8676002)(8936002)(5660300002)(4744005)(316002)(41300700001)(2906002)(66556008)(4326008)(66946007)(66476007)(6916009)(54906003)(6486002)(6666004)(6506007)(6512007)(186003)(36756003)(2616005)(83380400001)(478600001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+D6re1E3+4wtqteMh20vtVDRF1R559Oz/Sj6QV/OPSJ2Km5fvxW0+pNqMJe/?=
 =?us-ascii?Q?5AlxDyDCRXjjgjsbT/vHL6I1vAhHEco/fL6kY1Y2OGYQnSB3lypGuBArV0lC?=
 =?us-ascii?Q?bCxNf820kbCqMnf8rGPJJ3SXQpgQIzG+VZkwSg7ZGPDRUWf+DhoIJ0jDEtuY?=
 =?us-ascii?Q?KGEaup6TMkGlMKQPNKG3fD4yCzdhKiovzazPwqFQ4jEegb9WzxdZKbZpbsFF?=
 =?us-ascii?Q?CgGb3BJJe7oYFIq4ko1+3SWr+4JHClMojtjKLxLmPSK9+20UkdXZkDFuqxtm?=
 =?us-ascii?Q?8PU7/UvVWiumJw8rsjNGQMlC0BrOmyYqUzv+G5rzX+u4eF5fsu4ENhjVqLzx?=
 =?us-ascii?Q?v3GSNde8vcvIvxIHBMdiFrtjOEeyKMPyaRhAn5PDIwfHzNBsDDz25DqSf7xm?=
 =?us-ascii?Q?w1lbLiQwTFHuapvBo3bJ3rq8zhinu2V6bbtSKAhGsPnShbJzIIXvTztoBf5d?=
 =?us-ascii?Q?WjCaYTakRX2SMC+y3xlVrfrQ0C86JmCdez4LHMolFLtz6a0qEbE3ryQjVu39?=
 =?us-ascii?Q?fGGsvIlZAObkbeOybO0VOFWDhqpI4Tr+f9hnNv+t4YSDbjiEdwSC5nH08XgO?=
 =?us-ascii?Q?10LvHkH52Ov2RJzxAtrvIM3ws5d6WAKk5FQ7bIk+O8i+MqelK8pa6nl+OmHU?=
 =?us-ascii?Q?cA3caVZgDkdIm+00uJJE1p1YhVs31XwBhj6HQTKxGpZBiexbI5zLcMK/2coI?=
 =?us-ascii?Q?djk0yEniutVzYIb7yolSocforl4c7jB/f+1ovi2YGjgEQgbtaRV9F9g7QqqF?=
 =?us-ascii?Q?OtwoWyD6g7H5Klzi8Qx0CtNF2w3mRw+ap7qCFdfPH9M07jeYJY8NQjNNxZLv?=
 =?us-ascii?Q?qs6a8+kThsWr4c6vi5XGz0CTbjFDGMli1hz6NvuFgnkKwekp5mIcqwqBv4MP?=
 =?us-ascii?Q?DCd+xyc7VioR6pRvJNiHUkDpr0JBVVwX+WK7WYAbKJmn6cDIFPrZP49V/UH3?=
 =?us-ascii?Q?56F6nGMbT5WFSibgg8gJl75AiEeuQ9z1WVvZmHPzSZR1XaSaB1s8FKpO3ofI?=
 =?us-ascii?Q?VFA2bwFovQZhIRxOwCTdz/AA01kGcbZmNNb4cfcBr6DvTCZGGdwZQE0D3grT?=
 =?us-ascii?Q?l0FNGasms9V3l5XNaoAr+YteIUVBfKe5ZZ5UIO0mhICNEv15lPhA19QzIqrX?=
 =?us-ascii?Q?+Kw37wqwBfZQMgAUUeQoOBqtJ+2OBoHg7AJ5PEmCa2lY1z+H7rKC7OUbCtM9?=
 =?us-ascii?Q?DkrgW7yBzCd8BmqIbQk9TS6uGFu2K/NNnPtFZLMk3o6cBupDSFf/xRMHH88U?=
 =?us-ascii?Q?OwUZsZn+vWKc2akuqN0Pj91VDX7SSi/v2LwWiW4RoPZbU56vxz5pS7pZSOKt?=
 =?us-ascii?Q?yG+6cM9xII46xx80kB95SJOyJZzD4cHcIZCB26dMzicb3iF65xpd6dDvVWD9?=
 =?us-ascii?Q?Tdiws68zsqHBxs4YgQsOGqfoGX0km15+W9/eX4CMyxANoPNHgr/OVojerC7m?=
 =?us-ascii?Q?B31Hpwzr3fsA6l01kGRNlWwJl0/u0r5MpVB2POUGpazRLdCIyI2UeR9nwr3n?=
 =?us-ascii?Q?OwREmXYtIswVR53q3O34mfWdPy70LFAFCkF0OXWFn2mmJ/WEhWmexkNnVtBO?=
 =?us-ascii?Q?s3BHHcXz8EKmA+HRXQvZ4Elmx5abDnypDpve7WGLr8x45T0oJB39uizNf1uO?=
 =?us-ascii?Q?NLW6qs8a2nWy10wnAr+BT/dQ0jUAlFcBswnUiqx3lIiHDTQhGunR52kVMe0V?=
 =?us-ascii?Q?gmqUpw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d71467-7fbf-4c0d-05e8-08db643f19b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:30:38.1657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TM9mpj+Bjm+ehTj88CfGFNJhuaXbVcoHCCyKmfzSLiPf+WNENDQH35JTqSwTiv+XlgFrfJgUiWZBI3K1V0OKahtCZc6/h8vNq9Rcoi6cPdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5878
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:40:17PM -0600, Robert Hancock wrote:
> Patches to move handling for KSZ9477 PHY errata register fixes from
> the DSA switch driver into the corresponding PHY driver, for more
> proper layering and ordering.
> 
> Robert Hancock (2):
>   net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
>   net: dsa: microchip: remove KSZ9477 PHY errata handling

Hi Robert,

this series does not seem to apply to net-next.
Please rebase on to of net-next and repost as v2.
And please include the Reviewed-by tags from Andrew Lunn in v2,
assuming there are no other changes.

-- 
pw-bot: rc


