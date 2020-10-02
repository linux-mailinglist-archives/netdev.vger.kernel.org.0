Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8BD2810FC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbgJBLJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:09:22 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:20547
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387669AbgJBLJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIMHDYM6SOKolg75MkAcYUdcmJgViRFjG6eYQ5dBi1U=;
 b=AQH1Aku8qm3BnysBPNSSw9XI896Wyp5uUHAuk1d4EIPvcUouHSji4+l79TarGO0Ai8CsU4mN6RqCX+5YnHocXAkXW8qJHFRbu16C8KDr/FeuMgbGNn4h344rPTChpKK7eOxdEu0EgBZopBdJKS3lrUN+Q+jiT0GtgO3B+MeroNg=
Received: from DB6PR07CA0174.eurprd07.prod.outlook.com (2603:10a6:6:43::28) by
 DB7PR08MB3100.eurprd08.prod.outlook.com (2603:10a6:5:28::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.23; Fri, 2 Oct 2020 11:09:10 +0000
Received: from DB5EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:43:cafe::62) by DB6PR07CA0174.outlook.office365.com
 (2603:10a6:6:43::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend
 Transport; Fri, 2 Oct 2020 11:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT059.mail.protection.outlook.com (10.152.21.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 11:09:10 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64"); Fri, 02 Oct 2020 11:09:10 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5e5214c1a5cafbd7
X-CR-MTA-TID: 64aa7808
Received: from 68e6c8c6f6bf.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 86674786-9E8D-4611-AA9B-98441FD1E2EB.1;
        Fri, 02 Oct 2020 11:08:33 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 68e6c8c6f6bf.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 02 Oct 2020 11:08:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsvSpWwcemH8ACp5NqWLhlDJtKef2AJDBEeXTosHdYiBT4kk6bGruxOSvRnpQfN+7BQDAMBY1Frf38RVgZ7G+lDvm1Ff7h/S3qMKyDfzBgAhcZ86i5OMIUYJ3X+FCTnz4DRB2OqK6aH4fQygWs/mwLP40EN0wc2t2BTzaPsOxP/D4jZqxCpH+1E48PsrzApo9eHRuZthDgg8BULdGXs2/l007txtpanuHYN+WLFy3JEDRDVkB+r20ATqB3NgdYBCsBb+bwMCAlKZhM7uA1PUcqGYUySmliRFnHtn/wrhAycbePaLjdADnc9chGxFOWk5nNel7StKOGPyzRN2GVyBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIMHDYM6SOKolg75MkAcYUdcmJgViRFjG6eYQ5dBi1U=;
 b=DgBCGTyUfO2SlH4wFN/s0U9dHxh4SilQ4HuE8XTo/RxTgBaG0sfw0LMoZ4XUPPedbazXasQENYJc8JlQNxvFwrhSUi7QXm4WQlO989ydGmCxke7TYikMxdirVhuABioEM2LFNLt5y4bVJHDCk6QxzCWN4RrG+EwvdJ4/Ior+6ApMrqDmgB0FRe7PmRXziMUeCQvOuqaL6x6ImG/LihsMUDU6hg0DB/9XlGBCCih3u4bHPtHIA+7yHa1Q0o53F5wORmlLcb6GbAHq/2pGTJuL59+WdMvO24amocEhNCqxqTe3mYwSOYCqTrjYdFin+J3kdn56kxRxvKnmY/IagtSV+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIMHDYM6SOKolg75MkAcYUdcmJgViRFjG6eYQ5dBi1U=;
 b=AQH1Aku8qm3BnysBPNSSw9XI896Wyp5uUHAuk1d4EIPvcUouHSji4+l79TarGO0Ai8CsU4mN6RqCX+5YnHocXAkXW8qJHFRbu16C8KDr/FeuMgbGNn4h344rPTChpKK7eOxdEu0EgBZopBdJKS3lrUN+Q+jiT0GtgO3B+MeroNg=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DB7PR08MB3722.eurprd08.prod.outlook.com (2603:10a6:10:33::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 2 Oct
 2020 11:08:32 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 11:08:32 +0000
Subject: Re: [net-next PATCH v1 1/7] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, nd <nd@arm.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-2-calvin.johnson@oss.nxp.com>
 <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <39b9a51d-56f6-75f8-a88e-71a7e01b9f55@arm.com>
Date:   Fri, 2 Oct 2020 12:08:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0084.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::17) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LO2P123CA0084.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:138::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26 via Frontend Transport; Fri, 2 Oct 2020 11:08:28 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e258e3d2-aa75-488d-7b39-08d866c396df
X-MS-TrafficTypeDiagnostic: DB7PR08MB3722:|DB7PR08MB3100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB310021B46E02BFF7E45B4EEB95310@DB7PR08MB3100.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: PS9ZZearumiMCsa6DJF6WBLUiQl14FR5F5zGmHbZrIVsTQN6ZSNwDrcS+jXNtjaLSzFq6MFZqtt27Gtj4ucg7Ywot+F9eoRmpd1/4kBP+0kdTAqrxzk6F/adaT/3mnnQksY7vYc0ffb0sMMEGakinpqvDRGTte1wJ9JacsSaMVpHsHXb6xLaj8tS8gsQDTzYoPAHVkkeLYm6eW6Ja4D8cGMqnHy0FJ7p8dvESCSBnFdFyy3h3lDMknGXA62PT09Lkz29ghdO5NhKJjgYQmwVmo9+88d0YYKwzs7JsTsZCciaoOuvnsrT6PK+m7KeRWTham3CjecvEUIDImrD0UFJyqgb9zSGplFkYShn2WS1AWPObHJ+k3kGqqaykBMsjLrQ
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(26005)(66946007)(36756003)(53546011)(16576012)(83380400001)(7416002)(110136005)(31686004)(478600001)(66476007)(2906002)(66556008)(55236004)(54906003)(186003)(52116002)(6486002)(2616005)(4326008)(956004)(316002)(86362001)(31696002)(44832011)(8936002)(5660300002)(8676002)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KrULciEpFdr1qzV4jNv014+I3s/scxOLE0Da+fnxSmkBTFH9Xy+ss/PbgQO4200wQHtDDSk/zajnS7lC4WQwsiknvCKnCTHidPwxp12JUgNc4fmkMajrPnDBTndAiy+hJJyuwgYN9V06yMQ9mPkluVKnoConh9lvmu3FrbKlnXCvsVzTx393lM4eEL/x098ZDPeRGwzCb34fd/XzMy4Ed4fK0XIi/FlCHMEqkHBDrerFt5p5j0Tc9A6YzWNspdn56Akwn59Ei3fuduQExhdbKnzTXI3eGCcruxPxUj7l80eHXVISBNzFF2qvwPDWZJcLRXoUQKJYFkW3nQMnpDQprcSoK6H2m5kivktWWi+cM+qpKLEnEZFwKEm/8KAkGoDcq0ZG9ByiCY0Ao91YKRhtALN7kMeqLMLACOPEZUJajGAvmot3RxP5RWrb9UNeat0+wom7MXmuR3aHfSS/M5bdBoPonsJpOFktwhNo7EWwve0V/2Qntv1mbUFicMDHeyfruMXRSXwAoTUSB77sTm2nP+jOnrOtf1ttWCjpneHgTaZCRJmzkei+oGguAgijooFyzQpU5Ny8q1FJfhgk4y2DjYfz0aQKj5+qjPzdjXD4kWvNLWUIykLcenN+icvAQyBkgT7XkGjSDlwcxiFvhplQbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3722
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 34bf416b-aff7-4ce2-9a73-08d866c37f53
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMACAbguczCQHOfd/98A2XbmLddbTXc0VVuRhbBQ3/vCcaZ9UKX6RaTrJMq8OSEq/OHGnuw8+9Dr/CSG54JmOImDhWjUNNlI5LIeqRaqLV2H2ijSV1RK4gq08S0mE0HYVHpRLWCDq0aZo9YLx76Djw3ZASDIRbQJh0lPvFau7oRymaRtp3GMlULV6rUV1sET93qXF6IZQhJk5FqEb+CkDN2IyqxhI0UbbUIQ2UQL8U3P+N60aMNPs5cE1dEmBY//UG/rw74wJZz94FBvupmuYK1ENV6vwjE7lLt77HX7/0SmBrLuRUERGPbCnNUZVxLcENiYKCWcbDAdVz5Cu8w0fsVcftov/7fuY/+slJW9CkAYVy7T7IknbOtZ10YAlFbE+uvUtPiM7HiWsJZmH3MVL5MIMXwq0pDnZb2KgIfVghAbwOJH9xM4lYt0xXGH/rubmtp525VEFxP6lqP3WWixtA3A3sgOzylVZeG/jbvmK8w=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966005)(82740400003)(5660300002)(81166007)(16526019)(31686004)(478600001)(450100002)(26005)(47076004)(82310400003)(70586007)(356005)(54906003)(8936002)(336012)(110136005)(6486002)(70206006)(2616005)(53546011)(956004)(55236004)(16576012)(316002)(4326008)(2906002)(8676002)(86362001)(83380400001)(44832011)(186003)(36756003)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 11:09:10.8689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e258e3d2-aa75-488d-7b39-08d866c396df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/09/2020 17:37, Rafael J. Wysocki wrote:
> On Wed, Sep 30, 2020 at 6:05 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
>>
>> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
>> provide them to be connected to MAC.
>>
>> Describe properties "phy-handle" and "phy-mode".
>>
>> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>> ---
>>
>>   Documentation/firmware-guide/acpi/dsd/phy.rst | 78 +++++++++++++++++++
>>   1 file changed, 78 insertions(+)
>>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>>
>> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
>> new file mode 100644
>> index 000000000000..f10feb24ec1c
>> --- /dev/null
>> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
>> @@ -0,0 +1,78 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=========================
>> +MDIO bus and PHYs in ACPI
>> +=========================
>> +
>> +The PHYs on an mdiobus are probed and registered using
>> +fwnode_mdiobus_register_phy().
>> +Later, for connecting these PHYs to MAC, the PHYs registered on the
>> +mdiobus have to be referenced.
>> +
>> +phy-handle
>> +-----------
>> +For each MAC node, a property "phy-handle" is used to reference the
>> +PHY that is registered on an MDIO bus.
> 
> It is not clear what "a property" means in this context.
> 
> This should refer to the documents introducing the _DSD-based generic
> device properties rules, including the GUID used below.
> 
> You need to say whether or not the property is mandatory and if it
> isn't mandatory, you need to say what the lack of it means.
> 
>> +
>> +phy-mode
>> +--------
>> +Property "phy-mode" defines the type of PHY interface.
> 
> This needs to be more detailed too, IMO.  At the very least, please
> list all of the possible values of it and document their meaning.

If the goal is to align with DT, it would be appropriate to point to 
where those properties are defined for DT rather than to have a separate 
description here. I suggest something along the lines of:

    The "phy-mode" _DSD property is used to describe the connection to
    the PHY. The valid values for "phy-mode" are defined in
    Documentation/devicetree/bindings/ethernet-controller.yaml

> 
>> +
>> +An example of this is shown below::
>> +
>> +DSDT entry for MACs where PHY nodes are referenced
>> +--------------------------------------------------
>> +       Scope(\_SB.MCE0.PR17) // 1G
>> +       {
>> +         Name (_DSD, Package () {
>> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> +                Package () {
>> +                    Package (2) {"phy-mode", "rgmii-id"},
>> +                    Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}
> 
> What is "phy-handle"?
> 
> You haven't introduced it above.

Can you elaborate? "phy-handle" has a section to itself in this 
document. Agree that it needs to be defined more, but it does read to me 
as having been defined.

> 
>> +             }
>> +          })
>> +       }
>> +
>> +       Scope(\_SB.MCE0.PR18) // 1G
>> +       {
>> +         Name (_DSD, Package () {
>> +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> +               Package () {
>> +                   Package (2) {"phy-mode", "rgmii-id"},
>> +                   Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY2}}
>> +           }
>> +         })
>> +       }
>> +
>> +DSDT entry for MDIO node
>> +------------------------
>> +a) Silicon Component
> 
> What is this device, exactly?
> 
>> +--------------------
>> +       Scope(_SB)
>> +       {
>> +         Device(MDI0) {
>> +           Name(_HID, "NXP0006")
>> +           Name(_CCA, 1)
>> +           Name(_UID, 0)
>> +           Name(_CRS, ResourceTemplate() {
>> +             Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
>> +             Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
>> +              {
>> +                MDI0_IT
>> +              }
>> +           }) // end of _CRS for MDI0
>> +         } // end of MDI0
>> +       }
>> +
>> +b) Platform Component
>> +---------------------
>> +       Scope(\_SB.MDI0)
>> +       {
>> +         Device(PHY1) {
>> +           Name (_ADR, 0x1)
>> +         } // end of PHY1
>> +
>> +         Device(PHY2) {
>> +           Name (_ADR, 0x2)
>> +         } // end of PHY2
>> +       }
>> --
> 
> What is the connection between the last two pieces of ASL and the _DSD
> definitions above?
> 
