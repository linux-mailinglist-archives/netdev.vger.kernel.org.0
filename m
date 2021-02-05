Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C67310A49
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 12:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBELb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 06:31:28 -0500
Received: from mail-am6eur05on2106.outbound.protection.outlook.com ([40.107.22.106]:54496
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231756AbhBEL2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 06:28:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWUIRMtMvzHZth9ggHAiSO/0WWv5y0X4Si7w1LPx5ya1ntkdB/dKltgMZp9/TN3v6Gz+BqpglXA7nVRDOJg6dbewQyFTw3omf+NOEYwH2FQKSJjuK53a5duoECei9e5bujXEZV8VvvxGgYbUjkjdiq7hvdIAXXtaHltoCkGNBgr69n5dCNE97T9DIAiWnkQdEuxvtSyqvHBHMrgrRb1aI0JGaV0Rx3e4cIw9TUBEp1akgkS+GH9ggib+pat/kijGamP4+q35l9wZl8iAlRZdni3ZLg5NdtdzzNWdcbv8ez1k+vSZvwXJVXEhZdxhb2m+KFmp034B2HIZgOHeTb889Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGU+d48gr+++IUe5PrymIlUPAiz9WHoNIfRo9K+uv34=;
 b=SlxU2CyJlRE6JP4Q13AfBYgzAdLfQvOFnZIsBl7ivKBDc6WVe6D0it6YuIZi5FRtygc0tEoMp1hCLd1OIaCkTMoYt0aRh52CwvTrtEdVE4Tfx0/o1G4OkyZuFfZ+M9BGzPYqvAVS4IHl3Y//6xq953+Fdy6wgs3c2c6/2OyKZA+TEryyKS91k18WNrttg0cSXIBEQEjM+ymPE/OW/E+7V3E9zoXw1yqMubR3WAKV3qP5HfWh/qoI2j3Z+pWrgebe8IG99hi8e2IS6FkHQ/TFG4X+iFPeuWAvZvRjBPPnV+1Kmzpp3ricVEL90YSkrpkS5zHFGuyu6z0KPi+FQI3dDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGU+d48gr+++IUe5PrymIlUPAiz9WHoNIfRo9K+uv34=;
 b=vYJj7FEg5ZUITrxRxm7Hb1VczyUS95Q6qIQfrldoMJ/45Q3OImYABtsISdMkSg1ybdX0iWaNImIwr4xGd+Q7u0Hk6x9W/LVISebD6V4o/SCHG9R2w+IZhmtS1zCRvfaDvvgkCaOJDVYSio71691TfcK404262Gp58xzvB0yiJRY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0393.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Fri, 5 Feb 2021 11:28:04 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Fri, 5 Feb 2021
 11:28:04 +0000
Date:   Fri, 5 Feb 2021 13:28:01 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: marvell: prestera: disable events
 interrupt while handling
Message-ID: <20210205112801.GB19627@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-3-vadym.kochan@plvision.eu>
 <20210204211012.48b044a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204211012.48b044a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0701CA0008.eurprd07.prod.outlook.com
 (2603:10a6:203:51::18) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0701CA0008.eurprd07.prod.outlook.com (2603:10a6:203:51::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Fri, 5 Feb 2021 11:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c5e422d-4fab-4755-fe85-08d8c9c91a7e
X-MS-TrafficTypeDiagnostic: HE1P190MB0393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03932171562961B0D433AE9195B29@HE1P190MB0393.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qi1ZVtItgc4eoiejYtI972j/IH/T/yHi2szdIm9dz9h1XCyHBeWkHa22EWf1erkPlCGyCcp75JZOmsBm7sj2tlCIxxyXg+LIIt4hkoMPUVGvH8PL67Bq2Jkz2FpyySG12FmHUcpPUeTeeTsHhGiKrj89cfbf5x9lIO0ZjqLc6x7ncXiDClKQ/s/K8o+gYQ/2ZTc+bffp6JBUYU0s3vgbXiiBKE6PtpQkOxjLa02octuG2ZzmJ3UiWZZNBdW1L7g5F+ieVr+ekTW5RT//fd/HCHp4yazTpzhKPFWxvlhp2AkDwZmuM/5IZP7WzHvTQQk0q9/N0558VT/UAo3gL4pGwQUD4qufZULC8wYLuxfakOpxakIPAOrQIfYtsdn0XkJqvZkfVzNVwUl5UaKMl5/pnciKfRr7aNClkkOrzgUBW+vSTsJWsFgzWK78FxSlCMWXsL6UzmrSwC/9lD/zUxi8XUbvhaKgjV6UvmFQxvvNCOh1HFT0J56vYmSKcIZuPYQ+0JpkXro/AMMBpT/4EvgPIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39830400003)(26005)(2906002)(16526019)(44832011)(8676002)(6916009)(36756003)(5660300002)(186003)(4744005)(4326008)(956004)(2616005)(1076003)(478600001)(54906003)(316002)(66946007)(8936002)(33656002)(55016002)(7696005)(86362001)(8886007)(52116002)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5VddgwoHWVPbqGv8hun20IXUMP/t+rahkhC2QKGg4wkSXAehIG8uCT/8uj0p?=
 =?us-ascii?Q?XMMNK56Tv/5GsPLvZplRlI339TR8iXlnnPwph3sKzBDCFvEEAH5HMj7Ll1ub?=
 =?us-ascii?Q?AMwOAS7slfGR4DK2Zc3sOIarBcQuxucF/Ou5fqAi6e09pHFvVpRVjjwMvy6/?=
 =?us-ascii?Q?yXKsWGJ4iS5yxPoEq1PIsTd5LtBYz0LucgGMikbXL3hGWYA3I4qkxe2DvLe2?=
 =?us-ascii?Q?2tQ208txr/frSe4y2mwxLizZWenpaB7lnWv8vAS2I93v8ydG8xkILTMh3Mdx?=
 =?us-ascii?Q?lBQNUmtIW4QTT2lhOkryN1ya6n0mm6z56pQSyT6GXLkn59SCG/qzampy6nLo?=
 =?us-ascii?Q?Bzc2ZKvdq6PJR5YwoUK1yhHh6vX/pJGIocVzCRxQeQHDjhjKzcJgGoQexsMu?=
 =?us-ascii?Q?bg9AIGJmUXWKuSJb+B72+sTphN9niITlWZHUJDPbna8+I8mZyRFcz2ewOiF2?=
 =?us-ascii?Q?NgrrR4mVcpbLodHmI1AIHMk9dcimd2nVCvNqWFqj6CVvTn0Vr1JzmoiDKEot?=
 =?us-ascii?Q?y/opBcdUmHDO06FCce7FShwnojoug8G2nzMHqLA0zSEUCwoTz64muYueheAZ?=
 =?us-ascii?Q?tVPcBwdr+bRwWGyHZjO/X+O8ZkNvOtNSizb0W3GLELtOFqxghAYTz9kSQIPn?=
 =?us-ascii?Q?w+H4+Xk4Qyc8wQxzX65Z6fDjPBLk0KbbGfBwubDSeBBnb+S/pFCYa4/N22a2?=
 =?us-ascii?Q?r9qSYGc/WDTShEvq/w2DbZfniUV5DB998WIUQmR8lOUY6zx72QZAbbEutKm6?=
 =?us-ascii?Q?b5V1qiK28e0eOr5xo6PmJ5yM5VTNEongfZzJ6fppnreWjJAjD7R91g/b8db5?=
 =?us-ascii?Q?DYPcvi9QVJOnpPgz8Y2SwjfAymnBehzaGiCkXoDleidSc4jpr7Z+vk47FaoW?=
 =?us-ascii?Q?W0mX98p+T8iTT3M02zcboim/qSkWzS3WwJiKRqZrd7Y87CQ95/Ld3N0TFXSJ?=
 =?us-ascii?Q?rU24yQ2hYBAo8dC4cIsLZL23zsG0x0uJOAaIushja28z8/eQZJLJu2noOeMp?=
 =?us-ascii?Q?fH1/Xct3Fzi2QiQ8nSYeP+YQmqTQ+FGhXuXlDF/8HLFWF61ATUv13fswm1qI?=
 =?us-ascii?Q?WjOIgP6jNZ0hA9BFoMzUOVI6fWgzEfwPX3vR7dtr74U+6RtirJknfrvemnRN?=
 =?us-ascii?Q?JFCXoObpl5EdcjVozqlAnoVF7mYmagRi3JU7NulWPfn49p0cC3Pkjy7txEsP?=
 =?us-ascii?Q?J4nK6JoiHDVqm0yosngPLcu59G0HlD3vhjeN5zG5D+roVnBLaUcPJFsDJP5S?=
 =?us-ascii?Q?N+10Ifd1Fe3tbnn5rfldGwuem+37Ob1sptM3iWlLo2sZ6al/ps3jo+OkcmCH?=
 =?us-ascii?Q?3eT+La34krT09bETJ83qVldh?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5e422d-4fab-4755-fe85-08d8c9c91a7e
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 11:28:04.6273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3uOeXml/yI079yY6/hZo0WqoI6FmeZaj6Q4RFO2T3xMa41Ac5mP2GP42v7tu+2UHCdA3+1nLlQ9C8HH9ayn2nhBh4YCEizSk+6XWdnIQQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0393
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Feb 04, 2021 at 09:10:12PM -0800, Jakub Kicinski wrote:
> On Wed,  3 Feb 2021 18:54:53 +0200 Vadym Kochan wrote:
> > There are change in firmware which requires that receiver will
> > disable event interrupts before handling them and enable them
> > after finish with handling. Events still may come into the queue
> > but without receiver interruption.
> 
> Sounds like you should do a major version bump for this.
> 
> Old driver will not work correctly with new FW.

Right, the old driver version should fail with new fw version.

Thanks, I will re-send new fw version.
