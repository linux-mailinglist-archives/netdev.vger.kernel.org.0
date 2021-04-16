Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB3362BD3
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhDPXP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:15:28 -0400
Received: from mail-eopbgr70134.outbound.protection.outlook.com ([40.107.7.134]:10884
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229719AbhDPXP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 19:15:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHPLD/6p+GZeFs+Ln1Nq/EcUWTGgEffkStMnbJJS22uIV1GPatDN8jxK1U+rVt8fhgKSS6CiIOk0F7ZEKATRzHeuvkTmbYIL817UlPERNU0tkfHUjCsYPNvtbRl+jjKnhiD7KlJTLfTOsGjppwM5/lJsGok7derY8Fkwnycg9cuJIgEHXFfC8Zze6lm0kzA9lWwUTXru7DAwD+pZhtFyZcTgRLT4I9J9yfmG9dgDVM4TPIaUNG//RSo7qmzNmfkVo106Etc5h19sVtMhHIpxMfNhwW3ucDf5IMtlxIpKuqxYpi71GPqL68U3owMgJK0SWBeO6H+Q4yCDcJy2iX2iqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkigyxFtXRO0SyRQbIvvCAxQZqs/gWj81njdYp2Nb0s=;
 b=E4WuDIY2RVrX0UDvkx0HYtUr5suhpZTciAajBOfZM8Nn19SAD66UFYV3BoWEKpR2ornmAZFG1x/NPE9PGMovJlPmjGjsB6wcoIaKMxb6LfwS+ytN/IWpVOe8kxgRGsXe+nw2J+yKFrfSSrrOCQvYvigisT/tnqkKnHp6X2Cn8AnHktDP9G+JRVuqM4Kifppwgcd9TKYX4dRLC/V8p7M9+N9shQ9oibGE4s4KygI76jY/vuvauXfVKDAd+3DX3KLJtkXjVshUaYK1AOoGZRrAxTXhmfKk2gXTHbWTlTzG/ii9X1JBupI6atdr2JpPcBZv+OKjOfatKxJUlsCZ1pJNew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkigyxFtXRO0SyRQbIvvCAxQZqs/gWj81njdYp2Nb0s=;
 b=OI0uUbGxvNA+6R6XW/ZCHGGLUejy8+ESq4/ZgcLWflL48zkq6XcGLTMRM69jBeXfDip74vQZK1fToO0QLgM8UBMzhQAG66wIkFI4evlb5bQjAkFhu/RSw2SVFw43vGW+ifkdMfGDT59NvqGruvMedmFVJKBEQX4qo6yjokN8WzE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0089.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Fri, 16 Apr 2021 23:14:58 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 23:14:58 +0000
Date:   Sat, 17 Apr 2021 02:14:56 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH] net: marvell: prestera: add support for AC3X 98DX3265
 device
Message-ID: <20210416231456.GB19191@plvision.eu>
References: <20210416230202.12526-1-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416230202.12526-1-vadym.kochan@plvision.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:203:69::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0202CA0023.eurprd02.prod.outlook.com (2603:10a6:203:69::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 23:14:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8affb71d-031d-496d-4b58-08d9012d7459
X-MS-TrafficTypeDiagnostic: HE1P190MB0089:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00895DC4EF929364CB3B6013954C9@HE1P190MB0089.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +aayQPzxyp19FN5k8djvsyTU2qf+NLgmMliZCguSJXrsPEoVW7oLcRdXuuxtT2m4xhv2SopswfBE0xm3NnuXy8+cEEE4FW0thCCPjL2qvTpB4ep8f3hCFCaGvJizGutJHf8SkB+E3skxvGOZqYSzSy0qSOvwJvMs/2T1RhCoMSzxcs1dnAWEVMFgywIq2Q1eFHzrOo+ygbPq4NOHFWy/kNimnVhQPlBV46d3Moe71i8/SeTs/6N/LG/5M6kefw721OSp03uoOm3kNYaNvX1qIEIAHQ9RNy1rm7E9iqXLrEsdAOHTZviS6CjCjIoHuiTwuBifygKCvNJcTqIPDw/mocLzmNDj2FTq4DG2PaLZJPtDpiKqu3c7ZWlwFHuacVMcWZLC0+m14esRjiYpbhtM5cCkmDZ0aXw19SwNJcJcBD0k1m9HfLgMoQs0+Jf8aki3gt+Anf70ibrYWjJ9LsQyp/bJMy9MQ5bZ4/YlI1YEFfA5D97NzjQTFIxckyxNkwkJbcyoMULRhnUdEsqqGnFTcOdO4sWH+uDfOhbrjz6eZFrCJjnlfQpJkVDEnNf8qcaefc8+4ks4ABmP4oSiBNbdC0lDMGZBSvCzIx/z3+Ob07HleJX8w3mC15EjNtbMoZmkMJDfvqUiolV5Xl3pD5dloAsysxPO99AFn4lIrX1BAN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(136003)(396003)(366004)(38100700002)(8886007)(2906002)(86362001)(1076003)(33656002)(4326008)(478600001)(55016002)(956004)(2616005)(44832011)(8676002)(26005)(186003)(110136005)(7696005)(52116002)(16526019)(36756003)(8936002)(66476007)(316002)(66946007)(5660300002)(38350700002)(66556008)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D3G/Q+EKJ29RhRmuvOfWx1qfqbQsx6KeyfO2WfTUE9e7mzTpK5tX6USgOHY0?=
 =?us-ascii?Q?Kgkji+MlBcIP3gpvRNBwBCU1GaI3x578roOlEN5Pz+zNEEeBdpx67G8OyDHN?=
 =?us-ascii?Q?eAh7x5IBy8Bq7XFtK3NnQmc59t4ED6MA2HJueClwUZsSgHs1RqEJzhJ+DiYh?=
 =?us-ascii?Q?uV3//VYQcfxKZ+GNVRfZSDXGea2HWb8Q80vgF6GYzs+hw6ho1g1HK/TfGRdk?=
 =?us-ascii?Q?4uakiHtEyll79BXes200PwRzU5Xsi69UqqaONb2IoFr/g6TaxwPBZI9I3xwX?=
 =?us-ascii?Q?6r/N04nC8kB+aYhhoubn0W4JDvS3KmnxNGf7ILnUFahyI9qAETV7NYw4fWvS?=
 =?us-ascii?Q?maXhHhnps3HCDdlsI6WV0RGUy/gSTrzky6CUPGD+WjTAexi4N8+polNgzwg6?=
 =?us-ascii?Q?T3fOF6YNLOn4mCCfV/icAxNuKwUpo521Ww7rGrGtF7XjsOnKQHfYJfp6G4Pj?=
 =?us-ascii?Q?40ldXPL045Bo5LEmKJKiz/hCnRsYy7z92kR/LnOY8qAPnA3S/wgG+oBmxFNB?=
 =?us-ascii?Q?RXAY8hEL8lvbNPnAt3Rrwh35jc8V5D/W/nRyTtrB7+fiudrSUzDFOtCvKybn?=
 =?us-ascii?Q?H2WEJIfAglrCWRSW8DUr8wxjyU6ENth0nSSypHGCT4/r6fHSMbjBTv84VCIa?=
 =?us-ascii?Q?ktqdivY7JmqUrGA1qtStKbkFEKs2bnvDncoZA+t8vdzd8jG7PtJuOXxBeddV?=
 =?us-ascii?Q?sGqkzXwlSzK7AvWhMQZH/bucGliPrGbgFVX/UwyhPPK1ncJ02rGsqUVK9l3C?=
 =?us-ascii?Q?OgpnmdBBDyTyUkXVC1MdbEMvubgvKr5yAYMnRhvoSiLggR8NZ0+LMOHVD/iO?=
 =?us-ascii?Q?4G9QBCe5PT1Yba0aQynrfG5+6YnUM2l5JLjkBq5sy/5tOmOyqVxsIvhfgaCb?=
 =?us-ascii?Q?0OZAAupdCDgVcZkoNLuVHtkSJoMZcBpw6d1DHr0ooh8/WTzKI1hicvXdvREq?=
 =?us-ascii?Q?FEJdjdpDm4ulET9Mx+bR29rHGY3dfAtyd15YJnHDqyHdZQxh3DQjbGaABj5H?=
 =?us-ascii?Q?KZNZM/srMZaFf03Uy8vzpoJ49THffoG+5NG0Jc59VZMJyOv28Guimov3iAvm?=
 =?us-ascii?Q?tggWkjUwIFzCfcPMbPj6NKp55ohLhZXiT6IaZOnnWQhye9K+NTxFEb4FaReF?=
 =?us-ascii?Q?q0YLbbbOYNb1EirhCjA/0ZenRG0RboEU/tdLk0wpSLJJqfBlmuG4AH+ylSs8?=
 =?us-ascii?Q?hZvMXV6wPbgykxDdUO60q3RmJZXLNVI8r/nhX5wAxmqBmg37UXyPWqjoxU8E?=
 =?us-ascii?Q?u2Twai2KNT7xf6f/jpaf+FrhJPc09utOi+z7o1o27E2QfJJgj8Iv1dQ5Cz0Z?=
 =?us-ascii?Q?v63QRthmZHFQDR5bBu4RhEjw?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8affb71d-031d-496d-4b58-08d9012d7459
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 23:14:58.7940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jK6+xgAZnQEJ4MxpnapJaGWVh5AzBSqIZk7zHOAbiy/G8UamdxTo93ixs3vrDt3CBAS7n91ZKbVjr7souj6WqlgQeH9ETGA4lsmoQsQRmnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 02:02:02AM +0300, Vadym Kochan wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Add PCI match for AC3X 98DX3265 device which is supported by the current
> driver and firmware.
> 
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> index be5677623455..298110119272 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -756,6 +756,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
>  
>  static const struct pci_device_id prestera_pci_devices[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
> -- 
> 2.17.1
> 

Sorry, will re-send it with net-next label.
