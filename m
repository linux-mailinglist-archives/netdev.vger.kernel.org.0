Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58798213961
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgGCLgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:36:05 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:53086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbgGCLgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 07:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGzxYTfBFXWKmng1cILt1e3H5aWNM3OORg9ITn3C8tBMLSP2JzdyGItO2I6M7UCNg6rcLGpzl9i0VQSG2csQlXkER8jfbwO8uwz7LAI0C+gr8ncy7+fvfTUCHf3DrVoyxO+ZkWmuQaAqQqtNz+t1HPcgOMAmWwvFFdv9PETwNYGSDKEL8Wmq6GE9DOlo7LMtYPDQ6Zj0XCsIl4z6M5q6ybq5UIU6Jfyryf300wI/yUuN8T3uBp1w8jKjCnlkIDneLO0LVKq6H3o5xJmfpJ9Hbe4EOVEpdQ0h9f31xBIreWTAlMhe56G7cKT7bCeSW4xIbUw8yxrVnHpohvaD6VFB9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4WXghm2qnT3HD9KDKA0r8RfhzYC44ID+xsS0APwG9A=;
 b=XICDh7SvFSwL34I2aNWyDf/jqdpbIwHRUn2zM83tM3RCMFvsvEJ/yGX+Urk9D21SjowT/j/ifV7WXk24WcbjQl6FhFdI1fR/2wo+q5KpugUk8Kf2b5BB8M/Sys4lR9ia1pynMlxksYG8v8aEBRFkm7irdxprzuhZrMKWtvZ1QD98nd1BmsG3BgpSV5vz9OCLprPghv1OIH5L5DstETpYz5GFHI2IZ6RAvH/6YQrnGe1nh2sVFPEPwTLMHvWmLwO/39+RbYZOOU6S9/cvvhPKaus9bfe1YPWxCTkKlF1bW27Tl9jLX+coWMBVa3DLzHfukR0uX+hNfBpWIQhfNAzsCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4WXghm2qnT3HD9KDKA0r8RfhzYC44ID+xsS0APwG9A=;
 b=C/Acprs7/uSTySKXQ08v4SptaUbKZhNRx34vC1JK4myMB3h/6Vs/ONbqnmNFea68jNQ95sihFSkamTuSXaKOajSg0fPZu7ysd7jk9uBqOtdEiUyNcGRtLKE6hTrb0bNwnS0bwYbZLtDe4vJTUSQwuaI8TVsp2eNcimyiuq86ugU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB3953.eurprd04.prod.outlook.com (2603:10a6:208:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Fri, 3 Jul
 2020 11:36:00 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 11:36:00 +0000
Date:   Fri, 3 Jul 2020 17:05:50 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200703113550.GA16676@lsv03152.swis.in-blr01.nxp.com>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
 <CAHp75VfxpogiUhiwGDaj3wT5BN7U4s9coMd3Rw10zX=sxSn6Lg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfxpogiUhiwGDaj3wT5BN7U4s9coMd3Rw10zX=sxSn6Lg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Fri, 3 Jul 2020 11:35:56 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efd30204-5701-4ab4-5e97-08d81f45423e
X-MS-TrafficTypeDiagnostic: AM0PR04MB3953:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB39533600773ECE50C9696EC2D26A0@AM0PR04MB3953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JPqQVgTr//o4EcwAhuqbUGoj3wj9VKdyWRnhNfjGbdo9spsRMCdD6UVo905Y35CkHF3FLuuSHpoktlxzZiXsviKvkO+CazZIQQ+hBmAaonnmQ/3aJ61yFn5HGpgzvbEYz/A62JYP6R2sDO5dR4a1gTnvPchYtvvahmPCTlj34frpY2o3MXfiaiYHnZxcDDATuT0AbWZrX7bLNGPnO/LzoWMibDEKNr0j8IV7AgerkgAUvLLhqDLqcffv+9t85EXUF8q2ieayyq5FUCaunMX1lvjyrypMAojLX0MQUIyK5aXVXVJua2WUz/RfLk5WXwisd8olVDZB/l1UpNL35+Xwpu/s/WTvEsE8I8uZd2nl6CIZm/N/srywGn5hY4ZMyHun7It0d6ukOYq3WpvLc3rbGKSRBMGU85d28poLPX19bj0C/5gE5XIG68Gf5pY40bugUBw0pqscJipcs8aWXb5LxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(7416002)(478600001)(54906003)(316002)(956004)(7696005)(52116002)(966005)(33656002)(8676002)(16526019)(66556008)(66476007)(66946007)(8936002)(6506007)(4326008)(6666004)(1006002)(186003)(1076003)(44832011)(26005)(5660300002)(53546011)(2906002)(9686003)(6916009)(86362001)(55236004)(55016002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iERKr/v2I8pVPRCIS8fvoFSmm9uJeCfNHQiZ3wCJTZMmBcBzQbNpdxEPADwJDWLxbPU5NXyHFoPE5wDNc6nPREg7Tt8E/6igOuO+lQ34KYLlDViqyh2n++NJFJkd0sGNHEEB+kdJ1tqsJ3IUZiSu3whQbn/zk0JT9Y+PQg5cJnPoPxmqe+56dfR5ZWwlFzTA6cB+4mwgReUQ+pCkHR/eLS9drMcz5hZ4l4iDDLzlWk999UyGLZANOUMiqD2bG4uMHR3KXv3Tm4rWnY7fKvUtLOHHZ9K6xng4x9Z7BH3r0CldXrzNEV1tsxB1nFinP2XyDWEdxI1bx2P2IhDFDi9bsOTo4hgkyiywqWV2/p8Tz1SczXHEGDll8n9VAuN63IjhdOKl6/EY6gpSdaP5c2xKZxa6Ee5FWlvJGOIbHVokt+ArLK3sMzluh326h4Z+v1tWUPnq8TgwVwsiCeMnuyHoTht39E3Yh6cZ/0eV/veQPNt8UuubUZXaWuy5l/UZrsvE
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd30204-5701-4ab4-5e97-08d81f45423e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 11:36:00.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTQ6W1XAWE1Pg5+eV2/IRIpAyt3kQoDQEHjglLNOZ6b9ZU5+3xFoNcyqjAEMJBV7bNS7CSpMftZueF9tNXqydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3953
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 01:27:43PM +0300, Andy Shevchenko wrote:
> On Wed, Jul 1, 2020 at 9:13 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> >
> > An ACPI node property "mdio-handle" is introduced to reference the
> > MDIO bus on which PHYs are registered with autoprobing method used
> > by mdiobus_register().
> 
> ...
> 
> > +                    Package (2) {"mdio-handle", Package (){\_SB.MDI0}}
> 
> Reference as a package? Hmm... Is it really possible to have more than
> one handle here?

I didn't get your question here. Is it becasue of the (2)? I'll remove them
as they are automatically counted.

But if it is about the reference as a package. We've other similar examples.
One of them here:
https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1610/Hi1610AcpiTables/Dsdt/D03Hns.asl#L581

> 
> ...
> 
> > +                   Package (2) {"phy-channel", 2},
> > +                   Package (2) {"phy-mode", "rgmii-id"},
> > +                   Package (2) {"mdio-handle", Package (){\_SB.MDI0}}
> 
> And drop all these 2s. They are counted automatically by `iasl`.
> 
Thanks
Calvin
