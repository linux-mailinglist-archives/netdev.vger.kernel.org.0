Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64C11D090D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgEMGwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:52:19 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:58816
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729367AbgEMGwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 02:52:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNt33yRyp6pZA5ITG9lH6KO4vRfMSQaXiNgdzuIlardUj9c/7F6y2BS2q+8ln1mxZKiyezhtPT0fXRS3BLpTE/zdvdg7CuAIcA6w8VBRdqexjJJm+3U8V+hJOxU8tgv8QSTaO+k/57Fn+pMGrxbRtB5a1ltB8PVBjtK0Mpdt0+SbtjDiRuHaXEopFMdIqZtsx1FRtsZajNwc/IumigtYCIdOuXThOEl8oCBcbdtNm3jo+jtemd0+aCxAiIcdqz2Gv7WdOOOcBY4XG8fE+d2C4jeXkJHXFtkW83P6gFhOTsQeafJ4Ls0jyPmQ0Iz/1oHLfh95DMlJlomPKQzGOxWwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGb1GCZ8VGn97lfUO7A57huiSGEhXkm9mmq8DKTaPyE=;
 b=lvtA5LfUl5plKGSg3ulWK9r7FFsivjQbd8nYy/ZIi102AT1gyUEuF61OK2Ibf6BzgzYYUDkLOTtPkrqWevHD9TtCkYxLSswIS2JkK6NiMB5/p4OXh3QHNY4jmslNEzDT0gwvIMHI0/WK3pbI3XEyEqIHDaRIIr1gMN54gIhpAn+vH3aiszdiT9h6yweTOxdH8WtJzBMfhIL9Jl8hWDgfNXEQSx04gnfbtAKIsS/3y0ejAEH/xkTDg6TP5qmOlyqw0JAVOSXrypCzMDNrK2poKYmg3e4e9b9ypEi/Cr5z05hAXa2lhEdHbv66I98aYORMDPuTHyW4BNPJYZJ2yddjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGb1GCZ8VGn97lfUO7A57huiSGEhXkm9mmq8DKTaPyE=;
 b=Ksx6tRYaFYaqQZAKAU4inMI+/NmOGwfEuYPbePSvZZLUzurQzsb7zWElhx+rT1eYQ1Nmsq6qEhc3T4g7QTRa9TwQRwgc+7aGWcViDS1lK/09Ao1f1GJZlydDqu+6z6CVkkHpCOT02P0oHr0zCXRLRckHX8HAJXhNBCj5nAqrL8s=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB3637.namprd03.prod.outlook.com (2603:10b6:a02:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 06:52:14 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 06:52:14 +0000
Date:   Wed, 13 May 2020 14:51:51 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
Message-ID: <20200513145151.04a6ee46@xhacker.debian>
In-Reply-To: <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
References: <20200512184601.40b1758a@xhacker.debian>
        <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HKAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:203:d0::12) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by HKAPR04CA0002.apcprd04.prod.outlook.com (2603:1096:203:d0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Wed, 13 May 2020 06:52:11 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0795a10-fc79-455d-fe1a-08d7f70a2ac6
X-MS-TrafficTypeDiagnostic: BYAPR03MB3637:
X-Microsoft-Antispam-PRVS: <BYAPR03MB363776DEBDA9E41B601E8C40EDBF0@BYAPR03MB3637.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cPpAApvaqIS1dliBRmi9Vrb0GZCoE8nq8kOFJ3SILz97Ljk85njYyb3I4YeYKiqHOnjtHWBI1VSpxmPtehcIw23tndCTXmZAjAXxpEUpp0RTKNU6ZH72vYsywXvYbESKHtj0anm7Ji9SsfVJwDTDaEvW5fnORBs5S6V2w0+AyMgu1i0y2aA01suIhebN5+QAgh0Qg8538OvTYF7mvgNxunxNwAus5ELW22huL5QZmBQozLu8oARKvHewtaiWiNa8Kci+J/dHWEM82mT1APohCXz6ZLiYcM0vRgVFvaBAVisAUVLDgzCMELqIF651bCxklGsfGHXq4QFO6eXjpoALs2M7oXhaydgYUPYIHxwW1wHU7Xj/3ag340XZTQarqBZlpyFb10ItTDvEgP6ykVcWgCK8+0c9Mo0+qfI/jTXmMXZRVqlnHkbia2a6Ak+Dl/fxLLcmESl3b5T+V8bUFKpjIOHHIp9FTsmemQV70nNr34xAlerrJyMOs9/JYUYA5wNFEhIb/8pPozQh3Yi6Z5ECQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(6506007)(7696005)(66946007)(2906002)(16526019)(52116002)(33440700001)(186003)(26005)(6666004)(66556008)(86362001)(55016002)(66476007)(54906003)(5660300002)(8936002)(4326008)(53546011)(498600001)(1076003)(8676002)(9686003)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: crYBwCVxWoevgPaB/J/OipDYZcV4ZyIscuCrCYgyCZj1QA8o0gzkuQKTtrQwP1D9dW6YqjfDw9TavU3gDXX27n7Uo7zlfzSnVlBiyszoXzJCuTCEY+uSbRGgMvEOeXnwKWSImdQBGURKVsJekjrPCq7qi6d+H26qxSrXN31fzKITFMmT9ZQ+chlu4B7W5nQ4GE41K63zYW//pc+UPEeLC4PfjRum+7nCCcD7NsnjviRN+qrKsVL2w9/Me+DluR00a4VFdjQ9ggb3cLK0PhnuOQVUifWpaltE+uY1h2wDiaoKI5COzsoa6SfZi/V0a5HL4nCRd4rZIkVhtonyDfDX1X3VRzgXT9RM5pK36JSu9hDdsWrSKU0R1eeHhecBjZbvF0xRtC1bBycqRIe1CTF/yN9mLWA2wadFQ5HndUCMprKITgJRt++kmpQ4gb/z3SYhe5SrvKUQ7hdPj7jtFg6xlasum5NW2GAl7oaG++Yh0Fsp12fLW0EIRgGwzvdt+zem
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0795a10-fc79-455d-fe1a-08d7f70a2ac6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 06:52:13.9160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7PEVzBMVz5qXiIBgz8rfCzXCNY3o6Y1Q4cOnAyr1009EY4pJxckuWxxekwZ94zA782ttAAPtGbMmJznWVuNvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:

> 
> 
> On 12.05.2020 12:46, Jisheng Zhang wrote:
> > The PHY Register Accessible Interrupt is enabled by default, so
> > there's such an interrupt during init. In PHY POLL mode case, the
> > INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
> > calling rtl8211f_ack_interrupt().  
> 
> As you say "it's not good" w/o elaborating a little bit more on it:
> Do you face any actual issue? Or do you just think that it's not nice?


The INTB/PMEB pin can be used in two different modes:
INTB: used for interrupt
PMEB: special mode for Wake-on-LAN

The PHY Register Accessible Interrupt is enabled by
default, there's always such an interrupt during the init. In PHY POLL mode
case, the pin is always active. If platforms plans to use the INTB/PMEB pin
as WOL, then the platform will see WOL active. It's not good.


> I'm asking because you don't provide a Fixes tag and you don't
> annotate your patch as net or net-next.

should be Fixes: 3447cf2e9a11 ("net/phy: Add support for Realtek RTL8211F")

> Once you provide more details we would also get an idea whether a
> change would have to be made to phylib, because what you describe
> doesn't seem to be specific to this one PHY model.

Nope, we don't need this change in phylib, this is specific to rtl8211f

Thanks,
Jisheng
