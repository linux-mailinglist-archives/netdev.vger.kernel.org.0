Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3122EC44
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgG0MgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:36:03 -0400
Received: from mail-eopbgr70100.outbound.protection.outlook.com ([40.107.7.100]:31104
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbgG0MgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 08:36:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9RvsqoyWpCW5N1LN7QSlGRJpi3zVaH1wnGMXw6iIpFTlyAb5cdcyj31ihLVTOcx5vZ1glSU3MZ0YSYLPHRAheZC4jx5xfH6PfKUKHJKX6zHkxb54Xk6BGa6TfSibZBYVcdU5/S9Fkb2k6D7YSuPDpKJlfo9m7z5Z7gKqL7grxyIs6GN4M63RGttJfWOibhaNqgSEeAGnHFWOrNKE23FYwnnAcszEipCptq7JKHjmG7M5QF48RjDNfQ+pF+KDjzcJxAsf8bV/skNfjxFMwR9mgUKawGzJGJRK3iFjw+xOo38Dp81vDbflPvxkPk+pleU7oHDO+CBbRiS1yV9gTksHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj87WIcpyEkT6WXf7bC9bT/pIOVTM3t6RBpAjosxdjE=;
 b=UxjGhVJ/rWABS2Tvf5UevogcYFUOURD7xeeEfqgE6Gad8cOF3dM+vkQUlb3HYPB30ZB02fOdAsoQwrxVXxOEBjprh9i+Y9koNw1Xh6kL5Ti3AG30wbgDO0GtNrOV9wfi1UlwzySAVxkpMG1AQePgaAqtmiNH5m+0h2JEYSNbF8baPxdly8wPuMZ2/VTFxhy8IXcS3Mugris34pIfQyFpO5pvoUH8yhErh4mcGmiJa3ma7Y/CMcb/TJaVn5hDJNee2CxGyNqnT5dSi04tuO1elygqM/lVIkB/zXlzeMrAdblmsCy2lziRj1WNsFdgWHxoY0EQlPHFGsd9ZXCd+652UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj87WIcpyEkT6WXf7bC9bT/pIOVTM3t6RBpAjosxdjE=;
 b=tVkPu1dsv+gYyt1WkcEyFOw1F0CYvY3ue07dlFNYjsGvKk3igi2Rbu96d1gtZ4naBbI+bPOS2VH8+w1OHJSjOmOkXYYKzgVN/iwIqTuOUAFhs+Eb0Cz14lRUVfsR5ahvH8vUP/03oR1rk/KSLpJ4q4FxdctiTpLiJFAPWj55qEc=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0469.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.26; Mon, 27 Jul 2020 12:35:57 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 12:35:57 +0000
Date:   Mon, 27 Jul 2020 15:35:53 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200727123553.GC21360@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-3-vadym.kochan@plvision.eu>
 <20200727123205.GJ2216@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727123205.GJ2216@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P194CA0095.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::36) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0095.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Mon, 27 Jul 2020 12:35:55 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87b3411-ccd8-4f91-3f55-08d832299c66
X-MS-TrafficTypeDiagnostic: DB6P190MB0469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0469D70128FE1F7AA239F9D295720@DB6P190MB0469.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUcqy5UfvMSPZJFETJ3iXysJ2tul1MxrkzZuuRkI5IkIKCMbqhiwGS3imu9U61eODwlKWOMrHvR+oLW4GLjP5dgkF0u4sQSfi7QCmJ6DTTEQCiJiGW9xJnIRKreuWfc0kDMZEz5BIloXCPG1Yid2FpPZfWlaY3BKtY0uCsOpqYD/JN3tyNoWSSq/8Y9tQfVbCJDrlBJfBxcJgA4F4nnQG3U9l0iOII7DhsgXvc8yzFjKLuGf5uHLmRLIXKYKiG2lCXLdVxbFIfayw/oyI69gMmuNxsbS+NnsJyQDvoW1zdbA7C1gmQHvuDVPGWgEUXHL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(66946007)(36756003)(8936002)(66476007)(2906002)(66556008)(956004)(55016002)(83380400001)(2616005)(7416002)(44832011)(4326008)(8886007)(8676002)(86362001)(316002)(186003)(33656002)(26005)(7696005)(16526019)(54906003)(5660300002)(508600001)(6916009)(1076003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /flGuBDFNER0/cCp/MlpclE7RqCj4XeKLVJrrC3Kz2fbp8PNYB+cDr8Jcn76m9vB++fJOCiMEEWuEMPqUar/D4jD1xlp9AYGyMWviA64TQ4k6HxGS4g6ZJ6AMOhyJWqrkVHkQ/cn9iA8gzzbHWAbxlf0V+plV/jAACeHlvbNGmhzo4lO4/+ekIMpx2MakEO6//sr8sP0RjMBjbT61whJig//yzivz0tFceKVGHre+yvR4C1bpJlpZJlKTu8UUxdhlfFU+dbSgThuAAOZQaN1Y43UQMU0FEn199T396uctAFi3JCf+YPvelMi45wNYY28jytiDSQ3MhJWYhfXRuVM2ZG9zJI8oiQgVtzc8iSPBYieP/yjpOJSHlmJjyQnCakqFk0Ybf8uWCKxXOgDbf9HaZElEo+5Y/rJvzYMGkqPiac9pHyQZ6Kz1PuAoZ6GC/bqr+APY/+ze4RuWjZat6HJ8skkT5ONxMCUY2CZ17wbr5k=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f87b3411-ccd8-4f91-3f55-08d832299c66
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 12:35:57.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfcMEQuF0j4hsEwRjXjolXt8I5539ATMf5fzKbstsRbzFvNBwMvx2JGe0T0/HwcF79zvPdL31qFIr+RMcm2L1GxedcQvXk3chXGqH78J44I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0469
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, Jul 27, 2020 at 02:32:05PM +0200, Jiri Pirko wrote:
> Mon, Jul 27, 2020 at 02:22:38PM CEST, vadym.kochan@plvision.eu wrote:
> >Add PCI interface driver for Prestera Switch ASICs family devices, which
> >provides:
> >
> >    - Firmware loading mechanism
> >    - Requests & events handling to/from the firmware
> >    - Access to the firmware on the bus level
> >
> >The firmware has to be loaded each time the device is reset. The driver
> >is loading it from:
> >
> >    /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
> >
> >The full firmware image version is located within the internal header
> >and consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> >hard-coded minimum supported firmware version which it can work with:
> >
> >    MAJOR - reflects the support on ABI level between driver and loaded
> >            firmware, this number should be the same for driver and loaded
> >            firmware.
> >
> >    MINOR - this is the minimum supported version between driver and the
> >            firmware.
> >
> >    PATCH - indicates only fixes, firmware ABI is not changed.
> >
> >Firmware image file name contains only MAJOR and MINOR numbers to make
> >driver be compatible with any PATCH version.
> >
> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> >Acked-by: Jiri Pirko <jiri@mellanox.com>
> 
> You have to remove the tag if you change the patch from last tagged
> version...
> 
OK, sorry, makes sense, should I re-spin with v5 or wait when the status
is changed to 'Changes Requested' in the patchwork ?

> 
> >---
> >PATCH v4:
> >    1) Get rid of "packed" attribute for the fw image header, it is
> >       already aligned.
> >
> >    2) Cleanup not needed initialization of variables which are used in
> >       readl_poll_timeout() helpers.
> >
> >    3) Replace #define's of prestera_{fw,ldr}_{read,write} to static funcs.
> >
> >    4) Use pcim_ helpers for resource allocation
> >
> >    5) Use devm_zalloc() for struct prestera_fw instance allocation.
> >
> >    6) Use module_pci_driver(prestera_pci_driver) instead of module_{init,exit}.
> >
> >    7) Use _MS prefix for timeout #define's.
> >
> >    8) Use snprintf for firmware image path generation instead of using
> >       macrosses.
> >
> >    9) Use memcpy_xxxio helpers for IO memory copying.
> >
> >   10) By default use same build type ('m' or 'y') for
> >       CONFIG_PRESTERA_PCI which is used by CONFIG_PRESTERA.
> >
> 
> [...]
