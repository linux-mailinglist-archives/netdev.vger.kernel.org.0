Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C156318958B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCRGEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:04:05 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:49033
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgCRGEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 02:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miUEYDnCOT6IhbafWqyICIA/18MfDUDGwWZyb7G5YvcTSxyDsUThQmKlKjOGzF/p+EidDgiKXCSKgUz8fa8UnIhKuTG1bDQmONdJbgfWLSsmHXKNiof9Qef7BP+nXKX84ksfzgLKWbvL3tTbTwyP00LvIIV/BzAoLqizpdQb7LLL78QqVpSfarRPr6i9X8qThrnfb6dltzh8gQsbIEyiHnYz4QFEGJovr2h+Q0A/S8LuJgmv2BJCK4O0wHqwTCbBmlqevrfrLMbXZdtWtiKRx4oQ7d4IN4tvQNsKIv7g+N3BmeDipBbMNtJ3tA4ezrN+kySb6+1EMjEUJ5jrWcwMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tis0CEjhJ4S44RqDanuK14m1ghIE+VgY8FLeVy5Apx4=;
 b=Hntf30xZ8/T3DrJzZAGFs3rOzCjYxucjCXyPlioinJarff61mYIYM0sd9gIjhgvV2CC0CXpoRJEvUWlETcY0JfHFaYKU+Ag2bNlB41bfMmEGEgOLJ2Ri/BEEe17w0gTMtq73wnV4kqIzhE70viVSwy/BRG4dB6jHM8uxOOQJNVkyk4Dmaj2qmoKaT6pOFmQbNOxMmmtuXWg/U0sMBE2x69ecMuLfDpIsK03x0n1UBkx+slEIr/UKNkjCi2TGPCLjBvp5zq7IUu7gBRAfflc93LZkxRc/m/haa1/YCd9ul1FOL4+Ytr0lv9kdeEjpoG3cFkbpo2BPuECB0i6q4iKzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tis0CEjhJ4S44RqDanuK14m1ghIE+VgY8FLeVy5Apx4=;
 b=lWgDEZQJdG6ic7k7tIlhOcZp06HmSI6mVh+DlwyOdJOfJfQyYHtFzelKYMwO3ErsfivI4V2FRB38bjQqaHcuX2lVbWhuJcY07c2PrFcZwELG5rTxdgQtu0cxGh5jSNINKtOBIsbOeGaNqc4GB0PY/VE30ES7oEVUTAW4dor4gCw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB3986.eurprd04.prod.outlook.com (52.134.91.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Wed, 18 Mar 2020 06:04:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 06:04:01 +0000
Date:   Wed, 18 Mar 2020 11:33:47 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Message-ID: <20200318060347.GA21824@lsv03152.swis.in-blr01.nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
 <20200317113650.GA6016@lsv03152.swis.in-blr01.nxp.com>
 <20200317140426.GR24270@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317140426.GR24270@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0161.apcprd06.prod.outlook.com
 (2603:1096:1:1e::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0161.apcprd06.prod.outlook.com (2603:1096:1:1e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 06:03:56 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27eaa456-e9b8-4d4f-c034-08d7cb02272e
X-MS-TrafficTypeDiagnostic: AM0PR04MB3986:|AM0PR04MB3986:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB398636A232EE97DC26BD9B81D2F70@AM0PR04MB3986.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(199004)(55236004)(6506007)(7416002)(26005)(16526019)(66556008)(956004)(186003)(2906002)(66946007)(66476007)(1006002)(44832011)(6666004)(316002)(33656002)(5660300002)(54906003)(81156014)(81166006)(6916009)(86362001)(8936002)(55016002)(7696005)(9686003)(52116002)(4326008)(1076003)(8676002)(478600001)(966005)(110426005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB3986;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPc4UiWXPwPHyxadYtDJx2tzLqNDVJ60gY+q5l+FSN18cgajuMbOjWVftt3YOfRZLl3apJcCb0pf9wRm1e/pedNRBH2bGfUMp/IyUyV8Dh/k/jqjNWtWewaDHOQ/o8R1abOPKWPmhN9Oqj5T5jYQ95AZiFH3rJ5rwpVtUaGwPQjp/hDHKEauJQo3N3sU76oNDjJhaTDmzmml6Oz1RvinXRNwwo0OtvkUznCgIH2Q+OCrLuNssg1PaP1fZphcCCeNDEHs7Vj+4ZKR6JUPosXBhB8ZXTMGcEF/lGyweIHoXYL1q1EnfLhXQ0Lh3wM6ymrE4L6B2uBoUBECG9vzjjj4zXu/9j/dgdh5w7o0BjCeKYHH70CZP0R97r5ntXQ3BqdIHBg/pQAk/BePz1X15NDofANf1On85vOgtrYVSzvtEEJRhDsfG0uukquB1z4hGjfz59e/VKAvAgvTVkNRLUx2rxi4+W7GIBnqs0yCNYFJZKt5icOLuPShnKPEXUxGbrAaHP9nkK2eWSnle2IX4bp8G6ST3KTSdCXso+YHjPYIaDipCgAarG+1Kmlq1DdyMZq0wUSCIbDrREMghfMAqItVaQ==
X-MS-Exchange-AntiSpam-MessageData: cDXoVQKBOGw0D8KMjDosxkIck2uu9WmOa5CyLzXuU+PYco8Ec5vrPDD3VTvkimUMtIvObewwrvk2aR/X/mwLWIVFtjbbubgdufsbKUe2lO/kpVH7QVBdlBgvCfG0W6b7q8QisXymwqtMQ0Au726xvw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27eaa456-e9b8-4d4f-c034-08d7cb02272e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 06:04:01.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfdzkOLq5NmUsg9+vJzy7poPSc4Q173MU73NYClh3yljGoID6b7GxgPqZ2gMxJbyIQFWBgeO6r9bmDvfMnhJUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3986
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Mar 17, 2020 at 03:04:26PM +0100, Andrew Lunn wrote:
> On Tue, Mar 17, 2020 at 05:06:50PM +0530, Calvin Johnson wrote:
> > Hi,
> > 
> > On Fri, Jan 31, 2020 at 09:04:34PM +0530, Calvin Johnson wrote:
> > 
> > <snip>
> > 
> > > +/**
> > > + * fwnode_mdiobus_child_is_phy - Return true if the child is a PHY node.
> > > + * It must either:
> > > + * o Compatible string of "ethernet-phy-ieee802.3-c45"
> > > + * o Compatible string of "ethernet-phy-ieee802.3-c22"
> > > + * Checking "compatible" property is done, in order to follow the DT binding.
> > > + */
> > > +static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = fwnode_property_match_string(child, "compatible",
> > > +					   "ethernet-phy-ieee802.3-c45");
> > > +	if (!ret)
> > > +		return true;
> > > +
> > > +	ret = fwnode_property_match_string(child, "compatible",
> > > +					   "ethernet-phy-ieee802.3-c22");
> > > +	if (!ret)
> > > +		return true;
> > > +
> > > +	if (!fwnode_property_present(child, "compatible"))
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > 
> > Can we use _CID in ACPI to get the compatible string? Is there any other method
> > to handle this kind of situation where we would like to pass C45 or C22 info to
> > the mdiobus driver?
> 
> Hi Calvin
> 
> Is there any defacto standardised way to stuff this device tree
> property into ACPI? It is one of the key properties, so either there
> is one standard way, or lots of variants because nobody can be
> bothered to go to the ACPI standardisation body and get it formalised.

_DSD package is used to stuff this kind of DT property. IMO, this is not the
standard way as C22 and C45 are key properties for MDIO.

Eg usage of _DSD:
https://source.codeaurora.org/external/qoriq/qoriq-components/edk2-platforms/tree/Platform/NXP/LX2160aRdbPkg/AcpiTables/Dsdt/Mdio.asl?h=LX2160_UEFI_ACPI_EAR1

      Name (_DSD, Package () {
        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
          Package () {
            Package () {"reg", 5},
            Package () {"phy-addr", 5},
            Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
        }
      })

Ideally, MDIO bus should be part of the ACPI spec.
Maybe this property can be included in:
https://uefi.org/sites/default/files/resources/nic-request-v2.pdf

I'm still looking for a better approach than _DSD till ACPI spec defines it.

Regards
Calvin
