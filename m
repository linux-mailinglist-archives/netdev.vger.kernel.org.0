Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D081844C426
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhKJPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:18:21 -0500
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:49447
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231990AbhKJPSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 10:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4eV8J5aXeZfk2SZ6r1ZU43I6UytZR6vl3niXWCrkUEcZqFynI8BUnnOokCvuB9Sn8ZrHGWq9ZQH82cb4vhSS7cw3WFCRLNOUv0w+uHvUXj9B22P/JeUxw8VcuQeqQImM8IiNFbFG1Y/RB2iAXiG97qQyY2bzYzHFAqfjUisxdr9dy6bbDwBnR+whUQy7JZmM43w6kwYWHN7lBXwQ3Yza+hLb9xxJwKgbRCHKUjNBI9jIn5eqxjTzWIlTGe0WGiVMzlnOps0HWkNGjkqBk4Cu/T+3N+rO9PLzb+XH/GWUoM25QA1RNnfa7yzytUBtCLRzwFLRgsxSKUcCn7Sj/g1zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPujO2ER1Osddm96glwzzwClCnia+hlODCK+URtQuQk=;
 b=U0JRIP8T69wwGUFO8kFFTj/CXw9nEepQD///0olBrf+8pfWcMi3YMew0VOcj0+ZDFu4ECJzby6b6XTyQXRmvrrIXgGXozPFfCUQGtftxhJt0estJMRiGYWCABd4eSPsWQhBJixkqU0F9WAEhMdU63C7aIHau4xZyrK/pCinRcBiyKBfHTkJSfRuH2Z+ezmxnq5k7XEvPnizlUsFN8eSkRKX8I7Eq/elMXj5lRQ0d6a9SAtMEx9FfH3ZMmkEN7x2Zdy5ULqgSi5tdsUuX0KWnbhNXtA20ccKKPREJ1gwh/9cbtlvt6y1/XmBFzXtBUoN/4gFvO2fH9PYKzM8wByGGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPujO2ER1Osddm96glwzzwClCnia+hlODCK+URtQuQk=;
 b=fQjqBAo8u3Hi95vVyp2j+ox4g5nDlifJpCAt3byYgAEOAW2fEqsrAeby52KHb+qk2b96dI8yIm5ycmm6CouuP8qoQPgonuXl+SBO+yWvC+7KBmL2SOIUP+Yldwr9gBhgrJiUsWZeLt+KS+onHi3WtnsXJwqLIEGS4Hb7nOG3f2Z8Z14FGiPEB+G538wjC7CyWKF/WFCXjG25N6WcJ28yi0x7kvlZDUfSeJH2u8AllYnIbkjAJeGmcBhc5Px1n8aiWNGRpmQKQV4PuCEeOwFA2kgtPyqP9wNyry23Nzr9nDkgfbVzqkdK3Obnaa5vnp+X/fLdcvfXdjtcrxZ6oZuCIw==
Received: from MWHPR13CA0018.namprd13.prod.outlook.com (2603:10b6:300:16::28)
 by BN9PR12MB5382.namprd12.prod.outlook.com (2603:10b6:408:103::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 15:15:31 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::a2) by MWHPR13CA0018.outlook.office365.com
 (2603:10b6:300:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.6 via Frontend
 Transport; Wed, 10 Nov 2021 15:15:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 15:15:31 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov 2021 15:15:14
 +0000
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <87r1bqcyto.fsf@nvidia.com>
 <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87mtmdcrf2.fsf@nvidia.com>
 <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87bl2scnly.fsf@nvidia.com>
 <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Wed, 10 Nov 2021 16:15:10 +0100
Message-ID: <874k8kca9t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686d9c86-ba64-4a06-a4f6-08d9a45cefc5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5382:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5382FA059E191F3DF1CF36C0D6939@BN9PR12MB5382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQ+1xCk24XTRf1rpXfH/adFL6jY1rtyXhuFJnLHIZl9pgvkn/oPuTLGsBayW+vD9U54JHdQ3Pgw80SN5rIHKlVsgARUgJEDu5R34pOIYsHhoSDJuGVLslE/5WUsWBc2n+2y6wgSUgvANxv/e+AzkdbcZ/1eVzZNdSP0SsgJhspDmpb8soWx+D6yb25B4M5hiwcBzdOCqZKHyVBh8LDzT6zyMm6GbnfrrFoqmSuvwp02yXUpsIYOFJOcB3NV2uDA8kk1h1z+jka+u78CKJveosMq43dMPpSZquNUTXo4p0HVsztZfoaO0Xwn4Be4Pmho4G8rHkAUTsrER7p3Pstwg6dJ70fyXuc72NNZsJiJL+PSpEMvDZC7iL8J6PGnMwceqwIDOTIp25adWQE7naXI+f5s/hgbsxNOWTlxaFCOKRFMY1atGQS05r+scJDD/ASULInwr2ptHTA4aC7MoeRXsj51wtG0GlAaAVy9NSp9rMw8zO0ljHTl7zPwb9uJW2kPR8MEyJL6c64F9KlUOwn+ZHHVCBhoC8oU1v3Mi5bfGcUll9KAT6WECWJ6V3JbLy2zLATSmonmO0sswTmlaTCxIakBbtij47azB4iMkKZHobxgb817v/wNivzQWiFRMNgdE51OKWSU7xQ33bPycaobl35TnlnCd3V9do0D/UapPrA9gPxZX5AHuu4XJ0bn+lQc2WyqEGlnhV2kH+EIb2knAyw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(5660300002)(86362001)(82310400003)(36860700001)(7636003)(36906005)(26005)(54906003)(70586007)(186003)(2906002)(7416002)(47076005)(70206006)(6916009)(2616005)(8936002)(316002)(356005)(508600001)(16526019)(83380400001)(6666004)(4326008)(36756003)(336012)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 15:15:31.5130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 686d9c86-ba64-4a06-a4f6-08d9a45cefc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> >> >> First, what if more than one out_idx is set? What are drivers / HW
>> >> >> meant to do with this? What is the expected behavior?
>> >> >
>> >> > Expected behavior is deployment specific. You can use different phy
>> >> > recovered clock outputs to implement active/passive mode of clock
>> >> > failover.
>> >>
>> >> How? Which one is primary and which one is backup? I just have two
>> >> enabled pins...
>> >
>> > With this API you only have ports and pins and set up the redirection.
>> 
>> Wait, so how do I do failover? Which of the set pins in primary and
>> which is backup? Should the backup be sticky, i.e. do primary and backup
>> switch roles after primary goes into holdover? It looks like there are a
>> number of policy decisions that would be best served by a userspace
>> tool.
>
> The clock priority is configured in the SEC/EEC/DPLL. Recovered clock API
> only configures the redirections (aka. Which clocks will be available to the
> DPLL as references). In some DPLLs the fallback is automatic as long as
> secondary clock is available when the primary goes away. Userspace tool
> can preconfigure that before the failure occurs.

OK, I see. It looks like this priority list implies which pins need to
be enabled. That makes the netdev interface redundant.

>> > The EEC part is out of picture and will be part of DPLL subsystem.
>> 
>> So about that. I don't think it's contentious to claim that you need to
>> communicate EEC state somehow. This proposal does that through a netdev
>> object. After the DPLL subsystem comes along, that will necessarily
>> provide the same information, and the netdev interface will become
>> redundant, but we will need to keep it around.
>> 
>> That is a strong indication that a first-class DPLL object should be
>> part of the initial submission.
>
> That's why only a bare minimum is proposed in this patch - reading the state
> and which signal is used as a reference.

The proposal includes APIs that we know _right now_ will be historical
baggage by the time the DPLL object is added. That does not constitute
bare minimum.

>> >> >> Second, as a user-space client, how do I know that if ports 1 and
>> >> >> 2 both report pin range [A; B], that they both actually share the
>> >> >> same underlying EEC? Is there some sort of coordination among the
>> >> >> drivers, such that each pin in the system has a unique ID?
>> >> >
>> >> > For now we don't, as we don't have EEC subsystem. But that can be
>> >> > solved by a config file temporarily.
>> >>
>> >> I think it would be better to model this properly from day one.
>> >
>> > I want to propose the simplest API that will work for the simplest
>> > device, follow that with the userspace tool that will help everyone
>> > understand what we need in the DPLL subsystem, otherwise it'll be hard
>> > to explain the requirements. The only change will be the addition of
>> > the DPLL index.
>> 
>> That would be fine if there were a migration path to the more complete
>> API. But as DPLL object is introduced, even the APIs that are superseded
>> by the DPLL APIs will need to stay in as a baggage.
>
> The migration paths are:
> A) when the DPLL API is there check if the DPLL object is linked to the given netdev
>      in the rtnl_eec_state_get - if it is - get the state from the DPLL object there
> or
> B) return the DPLL index linked to the given netdev and fail the rtnl_eec_state_get
>      so that the userspace tool will need to switch to the new API

Well, we call B) an API breakage, and it won't fly. That API is there to
stay, and operate like it operates now.

That leaves us with A), where the API becomes a redundant wart that we
can never get rid of.

> Also the rtnl_eec_state_get won't get obsolete in all cases once we get the DPLL
> subsystem, as there are solutions where SyncE DPLL is embedded in the PHY
> in which case the rtnl_eec_state_get will return all needed information without
> the need to create a separate DPLL object.

So the NIC or PHY driver will register the object. Easy peasy.

Allowing the interface to go through a netdev sometimes, and through a
dedicated object other times, just makes everybody's life harder. It's
two cases that need to be handled in user documentation, in scripts, in
UAPI clients, when reviewing kernel code.

This is a "hysterical raisins" sort of baggage, except we see up front
that's where it goes.

> The DPLL object makes sense for advanced SyncE DPLLs that provide
> additional functionality, such as external reference/output pins.

That does not need to be the case.

>> >> >> Further, how do I actually know the mapping from ports to pins?
>> >> >> E.g. as a user, I might know my master is behind swp1. How do I
>> >> >> know what pins correspond to that port? As a user-space tool
>> >> >> author, how do I help users to do something like "eec set clock
>> >> >> eec0 track swp1"?
>> >> >
>> >> > That's why driver needs to be smart there and return indexes
>> >> > properly.
>> >>
>> >> What do you mean, properly? Up there you have RTM_GETRCLKRANGE
>> that
>> >> just gives me a min and a max. Is there a policy about how to
>> >> correlate numbers in that range to... ifindices, netdevice names,
>> >> devlink port numbers, I don't know, something?
>> >
>> > The driver needs to know the underlying HW and report those ranges
>> > correctly.
>> 
>> How do I know _as a user_ though? As a user I want to be able to say
>> something like "eec set dev swp1 track dev swp2". But the "eec" tool has
>> no way of knowing how to set that up.
>
> There's no such flexibility. It's more like timing pins in the PTP subsystem - we
> expose the API to control them, but it's up to the final user to decide how 
> to use them.

As a user, say I know the signal coming from swp1 is freqency-locked.
How can I instruct the switch ASIC to propagate that signal to the other
ports? Well, I go through swp2..swpN, and issue RTM_SETRCLKSTATE or
whatever, with flags indicating I set up tracking, and pin number...
what exactly? How do I know which pin carries clock recovered from swp1?

> If we index the PHY outputs in the same way as the DPLL subsystem will
> see them in the references part it should be sufficient to make sense
> out of them.

What do you mean by indexing PHY outputs? Where are those indexed?

>> >> How do several drivers coordinate this numbering among themselves?
>> >> Is there a core kernel authority that manages pin number
>> >> de/allocations?
>> >
>> > I believe the goal is to create something similar to the ptp
>> > subsystem. The driver will need to configure the relationship
>> > during initialization and the OS will manage the indexes.
>> 
>> Can you point at the index management code, please?
>
> Look for the ptp_clock_register function in the kernel - it owns the
> registration of the ptp clock to the subsystem.

But I'm talking about the SyncE code.

>> >> >> Additionally, how would things like external GPSs or 1pps be
>> >> >> modeled? I guess the driver would know about such interface, and
>> >> >> would expose it as a "pin". When the GPS signal locks, the driver
>> >> >> starts reporting the pin in the RCLK set. Then it is possible to
>> >> >> set up tracking of that pin.
>> >> >
>> >> > That won't be enabled before we get the DPLL subsystem ready.
>> >>
>> >> It might prove challenging to retrofit an existing netdev-centric
>> >> interface into a more generic model. It would be better to model this
>> >> properly from day one, and OK, if we can carve out a subset of that
>> >> model to implement now, and leave the rest for later, fine. But the
>> >> current model does not strike me as having a natural migration path to
>> >> something more generic. E.g. reporting the EEC state through the
>> >> interfaces attached to that EEC... like, that will have to stay, even at
>> >> a time when it is superseded by a better interface.
>> >
>> > The recovered clock API will not change - only EEC_STATE is in
>> > question. We can either redirect the call to the DPLL subsystem, or
>> > just add the DPLL IDX Into that call and return it.
>> 
>> It would be better to have a first-class DPLL object, however vestigial,
>> in the initial submission.
>
> As stated above - DPLL subsystem won't render EEC state useless.

Of course not, the state is still important. But it will render the API
useless, and worse, an extra baggage everyone needs to know about and
support.

>> > More advanced functionality will be grown organically, as I also have
>> > a limited view of SyncE and am not expert on switches.
>> 
>> We are growing it organically _right now_. I am strongly advocating an
>> organic growth in the direction of a first-class DPLL object.
>
> If it helps - I can separate the PHY RCLK control patches and leave EEC state
> under review

Not sure what you mean by that.
