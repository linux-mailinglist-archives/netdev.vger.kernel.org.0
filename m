Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486F94DCA8F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiCQPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiCQPy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:54:58 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BB9DFF8C
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647532420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0KOhhPtxdVMGXP9WIwE0QcK6mIs6rf+JBlEhpmKXzo=;
        b=Q53PhvFEpx0PM4D6pbV4RmcfEBGKrgbXAYcR719qSrUS5+Fda46tb7weO3/UPfAwVeokaI
        BqvpPwj300w9cHciAcrsb/ehy1LKukTUCNuBszzi3ZM6GvWBCj6MLcRA6GUNzGoCPwyYAg
        VBwZWXRODJIkQzHLi97teyhgluJl0oA=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-3-J1LnrhY0OTWX2I3hEctDlw-1; Thu, 17 Mar 2022 16:53:38 +0100
X-MC-Unique: J1LnrhY0OTWX2I3hEctDlw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3FDw1bE7rEGNHaYh68TBiQGOaj3D5lakvWSrDVaLzyJBxA2u+tzG0sBd2msaFwH20461yOVwVRNS9HOBS9mP619DaBVWjqlbKP3hlX7vdMjBnXvh96ajQ5iB9r4LwZYqSmj2BEwWIuYTp4aWQpAE/xeK+piI2mM6T9jJmecCLhvnkhzod3tc01vbz+xs6mL+CF0Jv3FVtnMflH+3vNU5wu9yfUPZiu/H8gkbO0+niqHrNWrU3kUdXffJpfamONT1dgtopw1au7K4Tt3jQe/8NQuHkTZIrRpM+SYr3gnn+hk27C8lcJ9J3oVk2v6ruzIgrGhB+17eJveddPKVBBdbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcFt66gwfgVRNCmvakVPV0Vfk+ezGdGj5Z3HeYjQ5YE=;
 b=HOxKft7oskgJ97drbuns6DABM91gdsq/N7itBsvEvfNrJhVPDz1XFjEMX8NJZS5et07Wi7GRWIj7Nhh5cQf7oFeUspVaRmdEMOSykDa4iJaTqeqD8QsL6S3r1ClnmLzIvLFO5chHhYvE1GYrwQsvGirPoBdCRfWb0ui98ewPcu6HNXekFq00uXDn+Y5oW6QS5ijHDNwrVh7bQVcqmgSNTAMGigmub0ZfTQTq/KbQDu78t4AuxK8n3LlEiO1VEkFtQ+w/4/e8Tlv/jkj2B4PuPlKwNkVJ5Rz4Ktvl6rO+Del96YP4tCQim0F0vEunWqwqibLmNGmZe2IBJrUcOnHO2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AM0PR0402MB3795.eurprd04.prod.outlook.com (2603:10a6:208:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 15:53:36 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.5061.028; Thu, 17 Mar 2022
 15:53:36 +0000
Message-ID: <a363a053-ee8b-c7d4-5ba5-57187d1b4651@suse.com>
Date:   Thu, 17 Mar 2022 16:53:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de> <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch> <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de> <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YjCUgCNHw6BUqJxr@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::29) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccae6e6e-5efa-49c4-3962-08da082e4c23
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3795:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3795CB690E52FA4085D2F196C7129@AM0PR0402MB3795.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+aMFBDF8pAF+apWBdKbHO+EdUxD9BDsnXxZMFEadIxmOLjBLS1Ak3R96XHVKra6P6ZrcNvutJ++DKsJakCmeG4ELhVIbT9RAdcDrSke44B4V0CMGk5Wrv+/DTHyA4IX4XzGWtzc/f62eEJj3+Lu1PdlUtagvb6OPHDnwWuWr25p4FTTFvn+2MeZ4TKjX72FNApDLbkiGtuRRsNQ5oMaGdjSlTbRvbX6qNiO4euIBd4d4Nn5JFYtR3/7AjD9gR4ujF0H49VZEl8HwhchkyNV0jnw86OyW5SI5vvde7t2+SkKsCJE2fffKfssAGP1lOA4JU3c6b/4qxszuQHxQALIEVVGEEhoC6WBB2imCcwQY16NjdOFkth3eOCtYm7tO72SV6VOewqzoaFSQAyk2+6HHg+hiLJaataTbhhm3MFh1oisgbqX+RF3ZgLoU+wCOB4MhSscCJ5wmHuKnhkRJwZdWAZ9njfBJn+PCM71+0/SKIZtVPIyjxD8vmtQkxBLTiyQb6yhMCxE3otgH0r0ppXhw/LkxWA5HmghotwCs5fhd3TlbIXU6gDpvxnHPzDbIpm5l/f+DI0VZmgT++I0vbB/2FR3AbLrJPUKfXezRQ14mMlrEvJrnX2A5rP4yX6gMdavgoe2zXtZYYnx3aPnVDL4nbSEkllS2lSJMPzeGkeQi2XDXaIIl/ry5sIC55XAy7+9jSzKpkbxhC3jaWMXCT/fzMjqdEavaC/WnkAkeSOlRb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(508600001)(38100700002)(66946007)(83380400001)(6506007)(86362001)(31696002)(6486002)(4326008)(53546011)(8676002)(4744005)(31686004)(8936002)(5660300002)(36756003)(54906003)(186003)(2906002)(110136005)(6512007)(316002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZbugFTrmbT75klmhh8yIQUWx1OCxvJACQG6pkAdgzXZuAPoYvP40aA0Nfumb?=
 =?us-ascii?Q?hcWMiNaRipyy3SZcO7uOX/31iQSKDqC+al7vTX59r1W6SyyqfTEySA5WaGg7?=
 =?us-ascii?Q?VyQ8ZQvWKNhcRozKJmE2Wy1CLKaYvnNjL7gpo6FWomlrlgurJbNrNIKbfNyr?=
 =?us-ascii?Q?t97JiU+1xCg3mm1AWPikgQnNsbTttRh/oLau2KvGwUzWPWXnNKZY9kpN6v0J?=
 =?us-ascii?Q?3eYLBY/+TC3qXdK35Ge8XFkkSVHP67uL3PQrBeK9qh/CMCrUAZeRnGj0CPMl?=
 =?us-ascii?Q?MHU/06By+atn5toJS/HahfaoDSMU4MfHhSWcevsBdOvQ82+Z0U7TUN/6KWMO?=
 =?us-ascii?Q?eGHNTBlgVTJuqc1UvbHeuPNeOgtllKNC1AHRSgzJyZojwBaEXYqcaSoQpEiC?=
 =?us-ascii?Q?lVk6e9eYdjPri7QjhfULnuSVsnwa4E5K95NMeHgJ7EGiXgeTm7F5lzIdXuYy?=
 =?us-ascii?Q?U13IeABSBzw7JDpLP1vP8gvsh2fsnkFQv57Qbeqwq/kVqe6LO7gQg8WLLOf/?=
 =?us-ascii?Q?mW8t3QDIrU7wXeCOrVbVwru2z7L1aBrvD2jbIR6X68Gl6YE1mRXwF60Rvtgg?=
 =?us-ascii?Q?AgMzkRJpIAqhFK6HcnPR847lZyyTd0WYPMS4600RMiaV/MCOlS/7VfcNGIr0?=
 =?us-ascii?Q?LgBRuzAA9jFnbqnOm2L1BiXZ7WLnLy0FWQYzEEQUpge7mNyQTxzFnNkmDeEC?=
 =?us-ascii?Q?LlhpQLidYoAv+m2PpoPpC/t5FOXy7DRDdfkcz88zkXFg2Au5oXw96pWe1+4o?=
 =?us-ascii?Q?8rYVVqGU77C4TpSDM9Oo2Rb67XiPQz2/vi/y/mtWF8NyRe6maABWlW8hrp+1?=
 =?us-ascii?Q?b4yjb4y29itYntjqV2II7qEA8U76KExrSlNZB7o15VUPpwEU3HjFbhpMMYyh?=
 =?us-ascii?Q?JlPOZO6w6u0dN46ySC4QxYfhSmoki/WYMjRqfBQ6TESutdZ332nMvEYkguUP?=
 =?us-ascii?Q?+Ekje+A/o8PZza7Wsm1DFwK7K4ijb8+KCMIY4CzhyF7+gZUkHZEypVqdOPPe?=
 =?us-ascii?Q?04CJwhG2k0DeORQzVXa7JtznsiCb53bWUh3VgYsBCgNuOvk+ALFObRzYtZpi?=
 =?us-ascii?Q?f7SRrsJDVBjfp4jGn+m07y5oZcQsUw5J0WDJnXzOGka1QQTXM45FOvx2KuHA?=
 =?us-ascii?Q?zXjRj/aQW9H9kXIefuDSrnKeJr5+8/JXfBToSt3luK1FN0QUURAICHk8ORMX?=
 =?us-ascii?Q?Zr8ec06bNRP3P7NXwQ3j431tehOc4Ljimac4DltArBiJZ7OQBXIv0hmtO7+W?=
 =?us-ascii?Q?Qo/WqRYUPfbQxt87yqYpa6YKlkBDIK6tRJeoFIXzTuYAWMJLQsBkGcImL4VL?=
 =?us-ascii?Q?8B6Asy2u7k55YAxt1I9R0Vmg9afM+N57MBd8XrIKnTh1hYFG14nK3YeuSnzk?=
 =?us-ascii?Q?6kFugR712xFHMojhu07nb7PnlYRcSKdVx+duXqWiPMiGwnhJbhNoLG5U5Sj7?=
 =?us-ascii?Q?hz8TRIqzMhE6VlCa4SEZSSr73bMZsBxXq1qbvARmDkab3eKayeyEs2Uz3ZxH?=
 =?us-ascii?Q?WZSXkxNQtJXNLDPKnCheQK1udN4NNB2nfoo8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccae6e6e-5efa-49c4-3962-08da082e4c23
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 15:53:36.6803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcZfg/ZnsOGbQORIXKav1JwIc63mQ9y5d35M7a4JJCxh6Kzd+yHj4UMn6uVhxmyXIzvUEW0khLr0DA1LZAWDJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3795
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.03.22 14:28, Andrew Lunn wrote:
>>>> It was linked to unregistered/freed
>>>> netdev. This is why my patch changing the order to call phy_disconnect=
()
>>>> first and then unregister_netdev().
>>> Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
>>>
>>>   usbnet_disconnect()
>>>     unregister_netdev()
>>>     ax88772_unbind()
>>>       phy_disconnect()
>>>     free_netdev()
>>>
>>> Is it illegal to disconnect a PHY from an unregistered, but not yet fre=
ed
>>> net_device?
> There are drivers which unregistering and then calling
> phy_disconnect. In general that should be a valid pattern. But more
> MAC drivers actually connect the PHY on open and disconnect it on
> close. So it is less well used.
Hi,

this is an interesting discussion, but what practical conclusion
do we draw from it? Is it necessary to provide both orders
of notifying the subdriver, or isn't it?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

