Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D090744BE90
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKJKaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 05:30:05 -0500
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:53984
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229831AbhKJKaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 05:30:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDz9A2w1SRnArUFlGppV3h2kmhyyeG4nBZF3heLHLgpkP/inWjBvsntg+hKLNbKA5y40cyqHDR8P2dlsjy9VrbZm0XHgx7E9JuVSY9E1bCm6MSN2Jefxq75yY643Ei4QUYd+VyZOP4Yfq8R6WNNZYnJ98MxlPKzNHlVPj1pQvTvOTa3bs7mLVzmNO874JOc1vGhnnePydzrXcAkXzfljICrHWEqY3xc7+GWSVK9eX5fD150jbOaA3MpApiyZaxIiGZmAnlxY+h5Eo/RfFwVdked02oU++En5OLKIdz6/ahEdoJr0bM+A8bFPACPvRpqjTAdPveHLFd5Xq0cUWSwfEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yv9KV6bSxHaO/U8w/qCKAlZwN1/9p/HIXVFqxjhFfvM=;
 b=GRf2o+nZSEGeJ39UicSvfmMV10OVhAutXWbvl39aM+vlJVr997+iKVR1Ty/QYqy3HREhIPYuzRxFF/4CUA2vvlmC3sqlvvORyeXYyA7q5j+pKY1I0v/R9jjmgDhq0ADYfkKfQHiKyW3QLyzxd3iY6MIF4g1VeYE8N88lM6CmtyFXzf4EgcGK6czHOMZ0hGQMO7t9tqJflF9vdmzVOoejHn7QUWwBlkCmrshmzGjcMEbSoO3xO+3Ak6YHP7Wdl0XlNlhjr8f5d6TH44gLEAgpLt+Zsi3GK2YuAZLTynAygQmH4yrzgwG/KYUxxtvBgkbQPeZEdRqZ/2twyOu2s6PqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv9KV6bSxHaO/U8w/qCKAlZwN1/9p/HIXVFqxjhFfvM=;
 b=JrFvBJctTCfbeKPcKyvryNh5uoPxHYOXVJoMB8mystVfKsKBakVIjEIXwMEvufgujjouHwy7h+XgU6F8+RJuBfa5QE5TtccLGZPn2+hmu7Giqk04ADONIbOtkdXLdZGhXlmPzKb7Tm0YrmAOlDlnP8H0B0XbHf3XgGmrQSX1KXmgALvNNd3m/1W82HsgVthxPMoFw131tcXcLUTmanRzeF88CnA6E0775J+AqtqQ2vv9XYW9ZXQavOwuAXusMLfgu0P3h/xGhMN8J7urcZJRN9+kLd52wBX7mgcwpJDQ+/mlGNrbHdYFF2kMkGZx9loEZN0gbUhdqzba/xm5BVcKpg==
Received: from DM3PR11CA0006.namprd11.prod.outlook.com (2603:10b6:0:54::16) by
 BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Wed, 10 Nov
 2021 10:27:15 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::5) by DM3PR11CA0006.outlook.office365.com
 (2603:10b6:0:54::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Wed, 10 Nov 2021 10:27:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 10:27:12 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov 2021 10:27:07
 +0000
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <87r1bqcyto.fsf@nvidia.com>
 <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87mtmdcrf2.fsf@nvidia.com>
 <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
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
In-Reply-To: <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
Message-ID: <87bl2scnly.fsf@nvidia.com>
Date:   Wed, 10 Nov 2021 11:27:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa2d1f10-0597-4d2f-7e8c-08d9a434a8b8
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5555F8A74A995F20C8EF1657D6939@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+suyXaiMYn5V9m0VShiQm8VapDNHWwpuo+aZnYUVITfddqTLmNjTDtyAXjoNDkkda09SLCmQtQGEKdDLWkq9TDjDdvu7iL/xpyRVWWJMfyGw3FwHf2ibhWxEaO6Yh80PFn04lrB2lUwnZh5GXkfdU/wxCSnqLVp4keTynz0n4gbt67a2dbk24Aonkm20uxnb9gWdRXUo18dG7dDDrn0YKAFOVsiBU2cAB/dmZPVYRtTq6t/HPIw4in/keLrvVoy394z9pu2xqYDrebBUHWWwU4s1Lt0tFZlY0DGQhnoZ0ZcTEVeqoi2QWgrAY3KkPly5g88/qybCN5A7GjoOEPnY3b/tvn2GhMHGsIoLbFCaW79Q2o/lnJrpjdk6pthYujUS4/OtkYgekpC0jVDdfYHSIBbyTRciqAbPq4ehCmb3eLfA0xNFu44XriAaHy7POmqXu+c/KbAcfYwKOGK7IPgOI5qV2leHvREdBzljPX2G1068pPrzNFDmWd3mfAm9ZkFMUDDHIH+fEFLTxtCo4uJSRvLz0mJwdrpjr7vggEenslKerFnpPSNQ1nLVEZtLNKUz9cwCAwF0SwDVliGSrvszA818mm4LhbIv20dP9cUU6mnYFCgnSCHd9M3tldGm6jUKbWx0Zd5jHtFUjEfyTJTxGsoa5qiihZ2Qg7PNUdfOFbIzfIw6lDJ3cpIDDtMkBfR/AEoEgWCOU1+PYe4KTrJfA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(82310400003)(36860700001)(86362001)(316002)(83380400001)(186003)(336012)(26005)(7416002)(7636003)(5660300002)(508600001)(36756003)(54906003)(426003)(4326008)(70206006)(47076005)(70586007)(8676002)(6916009)(356005)(16526019)(8936002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 10:27:12.3964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2d1f10-0597-4d2f-7e8c-08d9a434a8b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> Ha, ok, so the RANGE call goes away, it's all in the RTM_GETRCLKSTATE.
>
> The functionality needs to be there, but the message will be gone.

Gotcha.

>> >> > +RTM_SETRCLKSTATE
>> >> > +-----------------
>> >> > +Sets the redirection of the recovered clock for a given pin. This
>> message
>> >> > +expects one attribute:
>> >> > +struct if_set_rclk_msg {
>> >> > +	__u32 ifindex; /* interface index */
>> >> > +	__u32 out_idx; /* output index (from a valid range)
>> >> > +	__u32 flags; /* configuration flags */
>> >> > +};
>> >> > +
>> >> > +Supported flags are:
>> >> > +SET_RCLK_FLAGS_ENA - if set in flags - the given output will be en=
abled,
>> >> > +		     if clear - the output will be disabled.
>> >>
>> >> OK, so here I set up the tracking. ifindex tells me which EEC to
>> >> configure, out_idx is the pin to track, flags tell me whether to set =
up
>> >> the tracking or tear it down. Thus e.g. on port 2, track pin 2, becau=
se
>> >> I somehow know that lane 2 has the best clock.
>> >
>> > It's bound to ifindex to know which PHY port you interact with. It
>> > has nothing to do with the EEC yet.
>>
>> It has in the sense that I'm configuring "TX CLK in", which leads
>> from EEC to the port.
>
> At this stage we only enable the recovered clock. EEC may or may not
> use it depending on many additional factors.
>
>> >> If the above is broadly correct, I've got some questions.
>> >>
>> >> First, what if more than one out_idx is set? What are drivers / HW
>> >> meant to do with this? What is the expected behavior?
>> >
>> > Expected behavior is deployment specific. You can use different phy
>> > recovered clock outputs to implement active/passive mode of clock
>> > failover.
>>
>> How? Which one is primary and which one is backup? I just have two
>> enabled pins...
>
> With this API you only have ports and pins and set up the redirection.

Wait, so how do I do failover? Which of the set pins in primary and
which is backup? Should the backup be sticky, i.e. do primary and backup
switch roles after primary goes into holdover? It looks like there are a
number of policy decisions that would be best served by a userspace
tool.

> The EEC part is out of picture and will be part of DPLL subsystem.

So about that. I don't think it's contentious to claim that you need to
communicate EEC state somehow. This proposal does that through a netdev
object. After the DPLL subsystem comes along, that will necessarily
provide the same information, and the netdev interface will become
redundant, but we will need to keep it around.

That is a strong indication that a first-class DPLL object should be
part of the initial submission.

>> Wouldn't failover be implementable in a userspace daemon? That would get
>> a notification from the system that holdover was entered, and can
>> reconfigure tracking to another pin based on arbitrary rules.
>
> Not necessarily. You can deploy the QL-disabled mode and rely on the
> local DPLL configuration to manage the switching. In that mode you're
> not passing the quality level downstream, so you only need to know if you
> have a source.

The daemon can reconfigure tracking to another pin based on _arbitrary_
rules. They don't have to involve QL in any way. Can be round-robin,
FIFO, random choice... IMO it's better than just enabling a bunch of
pins and not providing any guidance as to the policy.

>> >> Second, as a user-space client, how do I know that if ports 1 and
>> >> 2 both report pin range [A; B], that they both actually share the
>> >> same underlying EEC? Is there some sort of coordination among the
>> >> drivers, such that each pin in the system has a unique ID?
>> >
>> > For now we don't, as we don't have EEC subsystem. But that can be
>> > solved by a config file temporarily.
>>
>> I think it would be better to model this properly from day one.
>
> I want to propose the simplest API that will work for the simplest
> device, follow that with the userspace tool that will help everyone
> understand what we need in the DPLL subsystem, otherwise it'll be hard
> to explain the requirements. The only change will be the addition of
> the DPLL index.

That would be fine if there were a migration path to the more complete
API. But as DPLL object is introduced, even the APIs that are superseded
by the DPLL APIs will need to stay in as a baggage.

>> >> Further, how do I actually know the mapping from ports to pins?
>> >> E.g. as a user, I might know my master is behind swp1. How do I
>> >> know what pins correspond to that port? As a user-space tool
>> >> author, how do I help users to do something like "eec set clock
>> >> eec0 track swp1"?
>> >
>> > That's why driver needs to be smart there and return indexes
>> > properly.
>>
>> What do you mean, properly? Up there you have RTM_GETRCLKRANGE that
>> just gives me a min and a max. Is there a policy about how to
>> correlate numbers in that range to... ifindices, netdevice names,
>> devlink port numbers, I don't know, something?
>
> The driver needs to know the underlying HW and report those ranges
> correctly.

How do I know _as a user_ though? As a user I want to be able to say
something like "eec set dev swp1 track dev swp2". But the "eec" tool has
no way of knowing how to set that up.

>> How do several drivers coordinate this numbering among themselves? Is
>> there a core kernel authority that manages pin number de/allocations?
>
> I believe the goal is to create something similar to the ptp
> subsystem. The driver will need to configure the relationship during
> initialization and the OS will manage the indexes.

Can you point at the index management code, please?

>> >> Additionally, how would things like external GPSs or 1pps be
>> >> modeled? I guess the driver would know about such interface, and
>> >> would expose it as a "pin". When the GPS signal locks, the driver
>> >> starts reporting the pin in the RCLK set. Then it is possible to
>> >> set up tracking of that pin.
>> >
>> > That won't be enabled before we get the DPLL subsystem ready.
>>
>> It might prove challenging to retrofit an existing netdev-centric
>> interface into a more generic model. It would be better to model this
>> properly from day one, and OK, if we can carve out a subset of that
>> model to implement now, and leave the rest for later, fine. But the
>> current model does not strike me as having a natural migration path to
>> something more generic. E.g. reporting the EEC state through the
>> interfaces attached to that EEC... like, that will have to stay, even at
>> a time when it is superseded by a better interface.
>
> The recovered clock API will not change - only EEC_STATE is in
> question. We can either redirect the call to the DPLL subsystem, or
> just add the DPLL IDX Into that call and return it.

It would be better to have a first-class DPLL object, however vestigial,
in the initial submission.

>> >> It seems to me it would be easier to understand, and to write
>> >> user-space tools and drivers for, a model that has EEC as an
>> >> explicit first-class object. That's where the EEC state naturally
>> >> belongs, that's where the pin range naturally belongs. Netdevs
>> >> should have a reference to EEC and pins, not present this
>> >> information as if they own it. A first-class EEC would also allow
>> >> to later figure out how to hook up PHC and EEC.
>> >
>> > We have the userspace tool, but can=E2=80=99t upstream it until we def=
ine
>> > kernel Interfaces. It's paragraph 22 :(
>>
>> I'm sure you do, presumably you test this somehow. Still, as a
>> potential consumer of that interface, I will absolutely poke at it to
>> figure out how to use it, what it lets me to do, and what won't work.
>
> That's why now I want to enable very basic functionality that will not
> go away anytime soon.

The issue is that the APIs won't go away any time soon either. That's
why people object to your proposal so strongly. Because we won't be able
to fix this later, and we _already_ see shortcomings now.

> Mapping between port and recovered clock (as in take my clock and
> output on the first PHY's recovered clock output) and checking the
> state of the clock.

Where is that mapping? I see a per-netdev call for a list of pins that
carry RCLK, and the state as well. I don't see a way to distinguish
which is which in any way.

>> BTW, what we've done in the past in a situation like this was, here's
>> the current submission, here's a pointer to a GIT with more stuff we
>> plan to send later on, here's a pointer to a GIT with the userspace
>> stuff. I doubt anybody actually looks at that code, ain't nobody got
>> time for that, but really there's no catch 22.
>
> Unfortunately, the userspace of it will be a part of linuxptp and we
> can't upstream it partially before we get those basics defined here.

Just push it to github or whereever?

> More advanced functionality will be grown organically, as I also have
> a limited view of SyncE and am not expert on switches.

We are growing it organically _right now_. I am strongly advocating an
organic growth in the direction of a first-class DPLL object.
