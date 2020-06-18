Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50321FFA78
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbgFRRnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:43:06 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:46078
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbgFRRnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 13:43:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmQ7lFEkVFJMAyNpGiwCOAGACLv4leIHBxMu+HN/CBlxwxCYM80O57aqEHJypJ4khiXUTL+HxKK2IcOSUKCWwacARoaL+LNennmwV4ck3wqetueOOmJl8gzceyyRtQCWBWUrGLA+dOx3OTbdegofjMzoMOBUo+5v6jpe7rHsdbFH+8pzs6dLSFIA5PjrGZNjg9ILpj7/CFgFUp4a/hy5rLKE3SZJX9QPvQ7fMnqaAVQl3eGC4qA7V0WT2+XSMjHZvKoiDCnq1I33z1Q4Xg1AgnkMpgAa5mGAbE9AhTB7MYt4POZDfxHmFW4nmll2grw4qG0GItQz0O2QomUNlREZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF6+C865aOQWwZOWexMsDbNHLSqUA9XkMQbhz33mT8M=;
 b=ari46ef0xBH9f1auyZjOmI9w/vzJtyo1Wq5PepEeYZYEKyNn4JHR+VrMtqpqs+m1c6z0tO3KlDi0WHWz2SV8nm7AzMVj0H5w8Ishcv3j9Lxc1AL3Ok6or4TiuWaTbqDdcpCFOW2BA9nTcoNWceiHeIAnqv+97hXoYGLP1PB3a2Ff1BswDpc8cjq1s33Ask6AZEFzFcroUGQrBQCQd+QmhunLmBS9AVSk2V3BTUfMqjGwcLg3MGvq7OuxH/2fnRGdoKT5DeUYUoSIu2fhE4LIyJ2SfjYBgInf7Jsgn06Y7/lhtU3Su4gzW0IT1yHt6c31bnELTrp3euJucQx8lRoynQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF6+C865aOQWwZOWexMsDbNHLSqUA9XkMQbhz33mT8M=;
 b=iPaTwC02+3kyXRF53lwGd6sfGPK4FFV8TAK06TxvNv7UX2HqgKVtY9Ig/O15yX6P72IhLFsAoeSsVZ/hJ8FmiLi7mVTuhHkfXr4hTN1iDcRnqOL6BlIQYv79tbeitArhCm/C3yxc0xAFDwJLla5uEkSLHJqbLfBVmqfnjofCdBQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 17:43:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 17:43:01 +0000
Date:   Thu, 18 Jun 2020 23:12:52 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Message-ID: <20200618174252.GA9430@lsv03152.swis.in-blr01.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
 <20200617173414.GI205574@lunn.ch>
 <a1ae8926-9082-74ca-298a-853d297c84e7@arm.com>
 <CAHp75Vdn=t2UQpCP_kpOyyX_L6kvJ-=vtWp2t87PbYBbJOczTA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vdn=t2UQpCP_kpOyyX_L6kvJ-=vtWp2t87PbYBbJOczTA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR03CA0087.apcprd03.prod.outlook.com
 (2603:1096:4:7c::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0087.apcprd03.prod.outlook.com (2603:1096:4:7c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Thu, 18 Jun 2020 17:42:58 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12c22477-bce3-4d3a-44a2-08d813af0b8a
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB661179A7D732AEEB9F0DBBB8D29B0@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNleWpsL2vIpZ0bNC6JgvBW6dlC9ytm3SkcziZrMY6DbeYouNsWy0vRNtxlTS3pnTvFOlehpJBu539wJO8n84bp+kBgyeMM6SmigvKqnkfVQTRAWn6smCDXnz+CMd+hVHMHXCcoD3YaK87iHjp6t7IxZ7JHmBrzxqK7Ohv9QBNRdzKB693Kr125uey3zJ4nDk7ePszEdNLNdSQ/N+aqXuJYlfXkWf1Hs4HI1zKadjMqJMN9Zslp5gimta6Xxwv8WfG7FTIipu3NwhiEcTEJ0q+Fh+jb+MTm4cjEFTkmtLlF3+WbS5+ACNEe41/NAn0A4Hz9qHLMvDRtIY2Oj5cJRmbvrmkX4HzrodNeOt4AASQ7WCW0Q9SbmbhEGFYsOBwcyahISVGD2mNNkOc+Pg7gqWJ8956CRJuvM9898Cc74sq3647DRUdWIzryaWrHcTgQnBXtSL63IstcBOzsCyWILVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(316002)(66946007)(186003)(54906003)(16526019)(66556008)(8936002)(55236004)(66476007)(26005)(2906002)(6916009)(33656002)(83380400001)(8676002)(6506007)(6666004)(52116002)(1006002)(9686003)(7696005)(966005)(1076003)(55016002)(44832011)(86362001)(956004)(53546011)(4326008)(478600001)(5660300002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D1FytiqpdNGdjaaUVcobqBRx1IWTj2YQzv1t8qgkU5iP5hiDNumjAdDa3xupKp2vLp+cbdIzZ9xtTWXl5uuBcA1lw6cMewwd05p1tnFc9KrT7Ck50aX/ert2puSSD4jlDHtBONUujzfbtSTeyHQ1xKWjpHXuA5eOWuT35T4+lncGtt+YEaqscruYCeG4Zbyl+KQHCa+ainhokBqq1BY6QwZ03Zn2kChwx93ZsUGbXXmOWXvJ2MsbMCCe6UW4zVx9aFrV6DY5tJkm145eBW3gV51qSF0sBIhcHgHsf2p1PXMrttSD0TjzovvWst0K1f3B/zKkMatOX8V+dSSfpOD5cVBlPmJ9yQxNVnDw6FSJfZ0znQIu3Imefvq20PnGRLWRz652QlUytQO8WgkChb7jqtWdPe3zi9jVx0lcu0hd5Pkhtv6/EFzRlRUldrAA997XCU0U5spnEFyVS8gkGr4bUGJoehZTPTsoCaoMnHcvTOK4O3yCE4q0AprBoFzuag8/
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c22477-bce3-4d3a-44a2-08d813af0b8a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 17:43:01.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHUxQzVs6F+5169B3dxMdkCNg13s+yd+51tgllb2y3r9njGv3AmqEj4dRFpBbaVxttMAaVVxVs1Vg3Cia0jvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 18, 2020 at 07:00:20PM +0300, Andy Shevchenko wrote:
> On Thu, Jun 18, 2020 at 6:46 PM Jeremy Linton <jeremy.linton@arm.com> wrote:
> > On 6/17/20 12:34 PM, Andrew Lunn wrote:
> > > On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> > >> From: Jeremy Linton <jeremy.linton@arm.com>
> > >
> > >> +static const struct acpi_device_id xgmac_acpi_match[] = {
> > >> +    { "NXP0006", (kernel_ulong_t)NULL },
> > >
> > > Hi Jeremy
> > >
> > > What exactly does NXP0006 represent? An XGMAC MDIO bus master? Some
> > > NXP MDIO bus master? An XGMAC Ethernet controller which has an NXP
> > > MDIO bus master? A cluster of Ethernet controllers?
> >
> > Strictly speaking its a NXP defined (they own the "NXP" prefix per
> > https://uefi.org/pnp_id_list) id. So, they have tied it to a specific
> > bit of hardware. In this case it appears to be a shared MDIO master
> > which isn't directly contained in an Ethernet controller. Its somewhat
> > similar to a  "nxp,xxxxx" compatible id, depending on how they are using
> > it to identify an ACPI device object (_HID()/_CID()).
> >
> > So AFAIK, this is all valid ACPI usage as long as the ID maps to a
> > unique device/object.
> >
> > >
> > > Is this documented somewhere? In the DT world we have a clear
> > > documentation for all the compatible strings. Is there anything
> > > similar in the ACPI world for these magic numbers?
> >
> > Sadly not fully. The mentioned PNP and ACPI
> > (https://uefi.org/acpi_id_list) ids lists are requested and registered
> > to a given organization. But, once the prefix is owned, it becomes the
> > responsibility of that organization to assign & manage the ID's with
> > their prefix. There are various individuals/etc which have collected
> > lists, though like PCI ids, there aren't any formal publishing requirements.
> 
> And here is the question, do we have (in form of email or other means)
> an official response from NXP about above mentioned ID?

At NXP, we've assgined NXP ids to various controllers and "NXP0006" is
assigned to the xgmac_mdio controller.

Regards
Calvin
