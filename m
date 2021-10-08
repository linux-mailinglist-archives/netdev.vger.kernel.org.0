Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C534260FA
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhJHAQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:16:45 -0400
Received: from mail-eopbgr30063.outbound.protection.outlook.com ([40.107.3.63]:15584
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231335AbhJHAQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 20:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSTHuQQRdJg+/E+C64EnGiUu/pQT92NlhWr1wUafBJgJL6STru7SUPUqR19kg6J2obz9zcLSL9cCxBZWCx0MJw1od+o/ladhZbvzLdBvK63iGel7dItnAQE/4aLMNRUQmmBoQsaQleVVlDMwmaezUI191Jq3iKDiIkjTWycdQ1spp4DRnmlInds796sSJtcvBeVNinH/A3aN/T9c8/dy6mzlgS21Xq/LZmWWdczbpstoqrA+Zmf1YEPayNfLH3jIoJETsKXjbQUD2qbN2EbhoqiI0N4gZJrfZst+NPhQ9mwvbKXo27eUk22M1Lf5v719s0rn6ECaL8cgCTtoob7Fvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeMhGlpNQW1Z62SAByDherLQNgqwnEAwu5fotQjVvZ8=;
 b=LMN9KPZGsLhKP5F6gZFanDOUqBbNccVkfHaB1JQuN5cB46BCf0ArepZWvYFHTBPUoAwZF/C1rhBosUiH2VcyWU0BtsCZFTUGHxBFl0uT2O+S9PW2dEgmeM3EzmZC21ofkpXcBeRWb6Y2fONFux6jBLv9WJ60NSjS9+rCWK5YOKRJ+JcGAFUmQiWaDfK+E5Iqs7JkP06Z6mnbbhpYOTBDtu9Q3laZ8EJeBAn9KnMpV0Fcp15aHwRYOQ+jTWSWGijHWg9PjYj5htlVHzH3Ji/L3QR2tx/uDgMwBUZ+3VD1YNZjE+vKOZ1bAa4Y9Oi9lbdB8ddJ6XFIBQD1xt6zwOU74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeMhGlpNQW1Z62SAByDherLQNgqwnEAwu5fotQjVvZ8=;
 b=NlNp+Vb/ShCAEEGtFUP0m1CW2wc+PhdZT2dlv9pMCWj9xJM3qC5o53YerAfarRn/89gl8isud3grc9s9ZM3SY72E/wIvF4bqNTESFEefrpdgj/JLTXsrJuLiHDd6/bfWmCYOZoHr7mEcKZX5WHT+pWBCYP4uGWrUqbUPXzl7AmM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5366.eurprd03.prod.outlook.com (2603:10a6:10:f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 00:14:46 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.019; Fri, 8 Oct 2021
 00:14:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 05/16] net: phylink: Automatically attach PCS
 devices
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Saravana Kannan <saravanak@google.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-6-sean.anderson@seco.com>
 <YVwfWiMOQH0U5bay@shell.armlinux.org.uk>
 <61147f21-6de4-d91e-c16f-fdb539e52b42@seco.com>
 <YV7Kp2k8VvN7J0fY@shell.armlinux.org.uk>
Message-ID: <9f73bc4f-5f99-95f5-78fa-dac96f9e0146@seco.com>
Date:   Thu, 7 Oct 2021 20:14:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YV7Kp2k8VvN7J0fY@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::24) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Fri, 8 Oct 2021 00:14:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63885bf2-9681-4bca-83d8-08d989f0a2a7
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:
X-Microsoft-Antispam-PRVS: <DBBPR03MB53660A6453638558C5ECC56E96B29@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jWkMWIfVyhcUgXn+3hwFxuChihjyXgo9K/VLFN4SNHnYj/1cvpinQxfFoKiPQQ/UO7zCIGmwnWeH3cktEtbpHLPzE7wQD8losnRORIX20jRXg95kA5RPdCbsmBgf62dh2CljqXqb4tEmmJYjOiOfpqm4ryD3RAtoYkOB7mRHQy1p1f3ftjebD7WL5d/HKvUYeYvMKf1P1f+XiCD/wonZ9HgKUqLsGwsbK8C4T4J096KfdhMFoyAO6eONfkl69KLzs1l7c6phpIdwFrlEkAqqlvnU4LbFwvdTr83iWqIN4O9vOECT/7jaKa3YV+3kMEKz/GwQET6PeVy4iLO8rIXg165E4AuQ0LGJHYAciSROG9/vEkiyqGX6CAx4P7xhl1o/Cm/KPmofqhs9JRlUo7yxQJ7MlhGavMhYen8t2ZXZiMR18rObP8RZ9BM+rRgJr1LOD4Cav/teJrXorcHhbHjOLaDiMl6MdxqrSY5GQW3CUnyvPmLdrDKjS9/+AqVi0EebD9jRyzeHcKPBEAMoB8gkXbX5ZnaeQuVh/LO3Qr5VMybWA6xrY2szK6+nqCVaaeT45qm+1hNsdvvFHUFTo6t5FcGzCMm4eRmCwwY5lBCBEIroVufJSPf6CPJstQ4g4I8Hx4pzRqn9xu8aYaSTd6yCCXAyMHGHjbAFDs0XfXrL0YqK7i5ff2OdQclgT7eKd4uZ/A5ryqvlAgKbDzZkFlZw5TiW1ZEXPn3lugTX8HbU0b4nAb+4K+ZkF0G995qYZvTq1pMQj53FsuXvDPGm354Bhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(5660300002)(31696002)(44832011)(956004)(36756003)(2616005)(54906003)(83380400001)(16576012)(6666004)(508600001)(316002)(26005)(52116002)(66476007)(8936002)(66556008)(6486002)(31686004)(2906002)(66946007)(4326008)(186003)(38350700002)(6916009)(38100700002)(53546011)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUxjQzdCMkRTUFNzcFFCbGVDTmxhczNxRmphTldaVVhUWHRFT29NYnN4cTIy?=
 =?utf-8?B?bzNZYmFsUjkrcmM5Myt4NE4xaVNIVDM1SVRxVDZ0U2RGNXBnODlzZ3NXUEtO?=
 =?utf-8?B?ZlNBajV1b2lLVFhnNzhHMktDSXF3L2xKSko1YU96SFdQRURZeFg5Z3JQR1FG?=
 =?utf-8?B?STJ6SnZYWVpoMHZ2RWtKUlhiUnJnbk4rU2lOazNac0R0QjdKUVB0M1BkTHI5?=
 =?utf-8?B?SHpkbEtQNWZHMG9Sa2tPeVhLdWJnaitzODBuZlNIQ01MVjdFMUwzcnNVMDN1?=
 =?utf-8?B?b3NscmhqeEtTNjVUaTFYbktoL2YrVE02SmlXYzFhMVMyR2Rxc3pHaU1wWHlT?=
 =?utf-8?B?K0NwUmVaZldOZEpZTVVQam8xZHROZWlmWHVSdHBkYWpqS1oxcnR5Ylc4MFBC?=
 =?utf-8?B?SjVrRUN6VTBRQjBIVjFBWHNmV0RFckFjZlU3M1NYMnhmUWVqMEo0eEdHK2lo?=
 =?utf-8?B?cnhDZXduWUIvR084Q3FvTEdvbDltVjlaRlhhM25uam01cEtRZm1Ca1BZZWxW?=
 =?utf-8?B?eDJrRE1xZUJNTmNmRU9oMVdhajRwcys5d1UzcFhOc0V6Y3p4anFXdnI3NE5C?=
 =?utf-8?B?cXBoZk1Ca0JUd1hoZm5oNDI3M2x1YlNYZHlwb1dTV05iMlRNNkRWU1EzTE82?=
 =?utf-8?B?ZWt2eUJDendJaHRzUTM4N0htNDRSREtOV2JiS3BNWmdTamkrZURqRitSZ0FF?=
 =?utf-8?B?anVKR25PSFNRWVBkb1FTV2hIZTN2a1hEYW5KekF2R0VjZXRMaU5HWUx3RjRE?=
 =?utf-8?B?WDZob0w3U0dPNFJ3dExWOVRSNjdBVW9mdFVZWW5tbU15a2k5a0x5clJlOVhu?=
 =?utf-8?B?WGdTcGt4dHZSdTJhMEZ2akc1aGpwMnlBandqUlF1eU5xVE4rZHN2ZkZNN1BO?=
 =?utf-8?B?NVpEbURNejUzcFUvaFN6ZGhnTTdoRjh1VGgrU1pjRjVib1FIV2V1b29uV1lj?=
 =?utf-8?B?U1o1MlN3ckpUWlNENmpvVjZHNmg2M1RUSFM1WHFqTSsyMUkweVNCUzRYaElx?=
 =?utf-8?B?WHBYSFpIaDRNSmR4bVBxcUMwTW1pWFVmcnJ6ZDAxRWNTMEZUWGc2aUJlUm9T?=
 =?utf-8?B?eTlQaWhjZENxU2VaVlErcGxlamtPTUx1TDFzSkVwNmVQcjU1ZEpZQ0RyUnFH?=
 =?utf-8?B?eFN3TkxyeGs0YXM3Q3F5LzdzWmpxV1ViQlBSb3dzdUNYMmdZRzcwRU9nVzJs?=
 =?utf-8?B?ZVFwV0JvY003NGNqYjErd0Y3SkxiL0Mvd0xPajhvazRwdGlCbDF6OHVjcGJK?=
 =?utf-8?B?dldGMy9oR0Q3cjM4K0ZpaEhRM1VOWVAvWS9nczlIYThrK1lEVjZnYjhIQmpS?=
 =?utf-8?B?UkhTQlJLcGh1NlgzUVhKZzd5MkFJNUdrM3QwVlVPWEM0OGNNN3NIblJzYTV1?=
 =?utf-8?B?R1dVR3FuWmFYbXo1L1BjZ1ZQbSt1UU1LS1oxSjRXQ1VQSkRHbjZVQ0R6OXcw?=
 =?utf-8?B?NGt1b252dDdBdHRSV1Zlc25qdGRBR3FwZUhTckhEVXFXNnhxU1RicmJwcFRi?=
 =?utf-8?B?S1B4STNmMmw0WFZPVm1WQW9VK0Q0OFh1MWoxQ3JZcm90elhld2JnTWQ2UU1r?=
 =?utf-8?B?WlhiWENwTXZrUjFQbStiemRFa2pkalUzOG50SXptVlFoa0VTYUdZeGd1SUM4?=
 =?utf-8?B?ZEFBQkFsbXZCYy91cTRKak5aRHVUVVl5RGU4OHVDU0wwc1dwdDUrc25QUlhP?=
 =?utf-8?B?MVk0R1N2eEsxUXlFcENzdUpGemtwSzNtejdpU2dwZ0ZDbjIvaW85dGFkR1RL?=
 =?utf-8?Q?RCiExsddmE+Wirv01Jke1Jl3UdG274qhDpMKsAK?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63885bf2-9681-4bca-83d8-08d989f0a2a7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 00:14:46.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGlkbQla9Tcan5Etheqt1dNBLwPCvzJRbjacw9bJTTAGMB//3IiBfJXD27X1JxV4+sfl7Hjcp5q35h1E9kXXOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 6:23 AM, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 12:42:53PM -0400, Sean Anderson wrote:
>>
>>
>> On 10/5/21 5:48 AM, Russell King (Oracle) wrote:
>> > On Mon, Oct 04, 2021 at 03:15:16PM -0400, Sean Anderson wrote:
>> > > This adds support for automatically attaching PCS devices when creating
>> > > a phylink. To do this, drivers must first register with
>> > > phylink_register_pcs. After that, new phylinks will attach the PCS
>> > > device specified by the "pcs" property.
>> > >
>> > > At the moment there is no support for specifying the interface used to
>> > > talk to the PCS. The MAC driver is expected to know how to talk to the
>> > > PCS. This is not a change, but it is perhaps an area for improvement.
>> > >
>> > > I believe this is mostly correct with regard to registering/
>> > > unregistering. However I am not too familiar with the guts of Linux's
>> > > device subsystem. It is possible (likely, even) that the current system
>> > > is insufficient to prevent removing PCS devices which are still in-use.
>> > > I would really appreciate any feedback, or suggestions of subsystems to
>> > > use as reference. In particular: do I need to manually create device
>> > > links? Should I instead add an entry to of_supplier_bindings? Do I need
>> > > a call to try_module_get?
>> >
>> > I think this is an area that needs to be thought about carefully.
>> > Things are not trivial here.
>> >
>> > The first mistake I see below is the use of device links. pl->dev is
>> > the "struct device" embedded within "struct net_device". This doesn't
>> > have a driver associated with it, and so using device links is likely
>> > ineffectual.

Ok, so the 'real' device is actually the parent of pl->netdev->dev?

>>
>> So what can the device in net_device be used for?
>
> That is used for the class device that is commonly found in
> /sys/devices/$pathtothedevice/net/$interfacename

By the way, why don't we set pl->dev = config->dev->parent in
phylink_create() when config->type == PHYLINK_NETDEV?

>> > Even with the right device, I think careful thought is needed - we have
>> > network drivers where one "struct device" contains multiple network
>> > interfaces. Should the removal of a PCS from one network interface take
>> > out all of them?
>>
>> Well, it's more of the other way around. We need to prevent removing the
>> PCS while it is still in-use.
>
> devlinks don't do that - if the "producer" device goes away, they force
> the "consumer" device to be unbound.

Ah, I didn't realize that was the relationship being modeled.

> As I mention above, the "consumer" device, which would be the device
> providing the network interface(s) could have more than one interface
> and unbinding it could have drastic consequences for the platform.

Well, then don't unbind the PCS ;)

After reviewing several other subsystems, I think the correct way to
approach this is to add an entry to of_supplier_bindings, which will
help out with ordering, and get the module when looking up the PCS. That
is, something like

int phylink_get_pcs(fwnode, struct phylink_pcs **pcs)
{
	int ret;
	struct fwnode_reference_args ref;

	ret = fwnode_property_get_reference_args(fwnode, "pcs-handle", NULL,
						 0, 0, &ref);
	if (ret)
		return ret;

	*pcs = phylink_find_pcs(ref.fwnode);
	fwnode_handle_put(ref.fwnode);
	if (!*pcs)
		return -EPROBE_DEFER;

	if (!try_module_get(*pcs->owner))
		return -EBUSY;
	return 0;
}

phylink_put_pcs(pcs)
{
	module_put(pcs->owner);
}

and keep phylink_set as-is (the above should be considered along with my comments on patch 10).

Realistically, the only time a PCS is optional is if there isn't a PCS
reference in the device tree.

>> > Alternatively, could we instead use phylink to "unplug" the PCS and
>> > mark the link down - would that be a better approach than trying to
>> > use device links?
>>
>> So here, I think the logic should be: allow phylink to "unplug" the PCS
>> only when the link is down.
>
> When a device is unbound from its driver, the driver has no say in
> whether that goes ahead or not. Think about it as grabbing that USB
> stick plugged into your computer and you yanking it out. None of the
> software gets a look in to say "don't do that".

I suspect the vast majority of PCSs will be DEVICE_FIXED.

> phylink (or any other subsystem) does not have the power to say
> "I don't want XYZ to be removed".

However, we do have the power to say "I don't want XYZ's module to be
removed", which should cover most of the situations where a device is
removed after boot.

> Yes, it's harder to do that with PCS, but my point is that if one asks
> the driver model to unbind the PCS driver from the PCS device, then
> the driver model will do that whether the PCS driver wants to allow it
> at that moment or not. It isn't something the PCS driver can prevent.
>
> One can tell the driver model not to expose the bind/unbind attributes
> for the driver, but that doesn't stop the unbind happening should the
> struct device actually go away.
>
> So, IMHO, it's better to design assuming that components will go away
> at an inconvenient time and deal with it gracefully.

See above, but I think it's better here to assume that components will
stick around and if they disappear at an inconvenient time then we
should just let the netdev be removed as well.

--Sean
