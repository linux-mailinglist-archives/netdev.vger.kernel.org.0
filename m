Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C7E1E3CC2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgE0I4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:56:09 -0400
Received: from mail-eopbgr40121.outbound.protection.outlook.com ([40.107.4.121]:38464
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728152AbgE0I4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 04:56:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV9+N++sl5nsTBWbGIraYVZsAmbAA/APnlMFLLEvxnFhEKKTs+Odg3ZzsZZk03AQ5u9f+z4AhSNXrjv7MWlmyZi7cqNFOdYEjuiXMeYwdKOOeAny1yVZFMukyJ4/2nJxqfuwjHc+kg6JiTfR1d5ydzKUgaoXhFISJnH3tq39VIpIvnq6lb1bZaKhi1dmyZ3iOb06iV3HvB5GTSF5vyFlykAFQEjL5rKnUAdDCFutTsDFL5VQwdS77kiumXO9xpdcyYfggQAwnqsyy7OxJ4C+vU6zy/K8klGKBWZ8vuEuDh1+KPTAbJV1eyHhfvf+qs7uGTyZrrL06yBlK0Lq0SKNoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+fvXWkMkehPtVt+p31dqzo7m6Wun6usH51TKefFn8A=;
 b=Cl1sQuFytulAbbB1Uap+0Z8Kf9HnkN+4XoYTnG0pNenUmrMBVLMipgqgSGkmv20xpT3luae2XtbAPseGavzQWS0VOqBEnqwHgeK0PTRuaS1MY7piuL+bOy3e/O7vfpdJXcF0LtIwiwNALg61F9FXrLJHxvZM3izHeDZB3CsGllEiYvASiXkcho3AwIQsUR2YJKJeW9ahAH/Iyra9wwMS+xo/r+9fTN+AZJcogpNI+rQf/hfbUcYg58eFwfxib/mOTK1dlnrtW1ibp0dK0HVSXRPOJbBxAHjJMJb/CkUUwWsvjMvOWZ2UJsS8DMf+A3GrOENIy3NBG3TzwhrXRCz9JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+fvXWkMkehPtVt+p31dqzo7m6Wun6usH51TKefFn8A=;
 b=Pxpjz2BfaOuaynfFkDjsb12t2j0toaDOas1yU1tjpx/RJ2frwrPqiqpDbv1EyUs6VrOv8Flo4SMlwG7izIXL3iDwfbHg6Yn2+msFZ47uL1kPAg2rMXOLPFJAkeHkYibjwbDeLollWNjXk1dkPqeRO2r54M+/NS9pouIoYegpQeM=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0142.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 08:56:05 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Wed, 27 May 2020
 08:56:05 +0000
Date:   Wed, 27 May 2020 11:55:57 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200527085538.GA18716@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200511112346.GG2245@nanopsycho>
 <20200526162644.GA32356@plvision.eu>
 <20200527055305.GF14161@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527055305.GF14161@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BE0P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::24) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by BE0P281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 08:56:03 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c0f0689-bb9a-45ed-39dc-08d8021bca05
X-MS-TrafficTypeDiagnostic: VI1P190MB0142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0142D55EFD94C3041796A16E95B10@VI1P190MB0142.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oF2cZ62HsnID79yHCeqZRedt7qQT5Iv4OiRhH7pi8Dr1b/3CC5Gn2HR4Hx3qRB5ajtSJ6cyx3LozX67WBPtTWYJg0zOrfSTWEFye5WnfhPQxG7UxcLyz0dHX82hm08+n/4Ka8cq5bdl/c+ztfQ3QPvs1Uv8U1flQAw+mjQiq31p3H/reMzthwo8gBnhCIwdAX28V+4N18dA4gSb33CgwfJ7A84x2YOpZ8/i+Rhn6E1cXmSowIfeUhm7a/uwjc80Al0REJLN0YyCMPOk3Qbat47f3DgUOCMSaj9vD7mzEoMFi3LsBBsZo7e86GSfEnD7n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(346002)(396003)(376002)(366004)(2616005)(956004)(55016002)(54906003)(26005)(36756003)(8886007)(508600001)(186003)(44832011)(16526019)(8676002)(5660300002)(8936002)(1076003)(6666004)(316002)(2906002)(86362001)(52116002)(66556008)(4326008)(6916009)(33656002)(7696005)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OPtldAQRTlqoLwm+iUxgeST34au8uZUz/2MpRljba2QBqWTaE8fKKs/cmjLU638bhRcsrMm9aKurixoc1fr1B0mgCtAJF8NEM7VH+Rduk9vL7riSXZYPKAdXj5EDyXeLfKlaMtRN4EPskiVdss6G04qcX3QfWyGbek+EVRpne12XDVsZZ1YqYq4YHm5PSHJa1E04/i0g3HOkmS0MOyzQF3U9ja8cptauwYpNvXCcinfedBXBuYIauREhM0UM3V5yq1MYjhkg1d6QEq7EMvzlvOCQeb36xQEtAiNh7oul3xHiN7R2h24UZHZ90sQt6cYXCBiaIyTCIhm+Z0Q2+mZpiCbTu9nMqCIjfydENzHe+kwdwrx0YNFvaqV5RZrx9YwBsPez1bp8thwH+HFwk7QackAgLA6CCkL5QVOHpV3AZ2aogzyCtOHHmcv80u1dcvZVD6P0tSojM7SguS/9drstUmXy1AUo38qmYE3FVSdH/oePa4CwERgaYu+3oIlj19Nw
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0f0689-bb9a-45ed-39dc-08d8021bca05
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 08:56:05.1996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kMCQNgal7WgDydmbYO0vttuvf6YoKAnsnPg2CaPeaZv6wNl2Lyb2ZJCuk5fuckZv94xTuV60cuyHNiILshI9EzKdrXXWW+E4voYw4TKLvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Wed, May 27, 2020 at 07:53:05AM +0200, Jiri Pirko wrote:
> Tue, May 26, 2020 at 06:26:44PM CEST, vadym.kochan@plvision.eu wrote:
> >On Mon, May 11, 2020 at 01:23:46PM +0200, Jiri Pirko wrote:
> >> Fri, May 01, 2020 at 01:20:49AM CEST, vadym.kochan@plvision.eu wrote:
> >> >Add PCI interface driver for Prestera Switch ASICs family devices, which
> >> >provides:
> >
> >[...]
> >> 
> >> This looks very specific. Is is related to 0xC804?
> >> 
> >Sorry, I missed this question. But I am not sure I got it.
> 
> Is 0xC804 pci id of "Prestera AC3x 98DX326x"? If so and in future you
> add support for another chip/revision to this driver, the name "Prestera
> AC3x 98DX326x" would be incorrect. I suggest to use some more generic
> name, like "Prestera".

We are planning to support addition devices within the same family of
'Prestera AC3x' and therefore "Prestera AC3x 98DX32xx" is mentioned.
Additional families also up-coming: "Prestera ALD2 98DX84xx"

> 
> 
> 
> >
> >> 
> >> >+	.id_table = prestera_pci_devices,
> >> >+	.probe    = prestera_pci_probe,
> >> >+	.remove   = prestera_pci_remove,
> >> >+};
> >> >+
> >> >+static int __init prestera_pci_init(void)
> >> >+{
> >> >+	return pci_register_driver(&prestera_pci_driver);
> >> >+}
> >> >+
> >> >+static void __exit prestera_pci_exit(void)
> >> >+{
> >> >+	pci_unregister_driver(&prestera_pci_driver);
> >> >+}
> >> >+
> >> >+module_init(prestera_pci_init);
> >> >+module_exit(prestera_pci_exit);
> >> >+
> >> >+MODULE_AUTHOR("Marvell Semi.");
> >> 
> >> Author is you, not a company.
> >> 
> >> 
> >> >+MODULE_LICENSE("Dual BSD/GPL");
> >> >+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
> >> >-- 
> >> >2.17.1
> >> >
