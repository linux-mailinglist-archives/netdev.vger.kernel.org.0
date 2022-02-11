Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403BD4B2D1A
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiBKSrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:47:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiBKSrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:47:48 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BFEAD
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:47:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxEUAiuPSeaOYU9LScmkkmv4nq9JuVZkuzmi7haF++KeQ5DO0Cr5Uc1AuFzvgvCQJ1XOGfgU/uJiOPEkL+3HJyy//A0yKXNmWaUZFoke0ozL+WUSYyqfCHYBn0zVLKvG2awxKEYLawGppRiYJ1rsUaJfdwWfunEQiTfKviRaAntVIJBJkjV3t3bxV7xi0qz1kDDteTAkDy3/srqWD6+mNyl8t3yQjI0mAfF/2+P79eA9J+GZc9yMZ/wNrLV8iy947nUQ4jIx7ddLN/DpUd7DU7c2J9KVP700Jxnnp2gApa+0zcE570gIBiTSFYd3V5gtZPYMQ98fCCVaeX/l6e6iSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIMskcMmW9xSyjM1KVXk45niQpHfG2Qtf4BedIXwqDY=;
 b=jdnq+dQlRro9vwbt8InV9sw4SMop/u4JDFUEN6cGVN4PTOvS7Oy3t+uRW5k6rANNwfcMOgcvF4Bc3uBg+9KDgiiH9mMPMwW7ub7RwaEHjLFfvZSQjJ1oSEZNnwhT6bAw9ByUhoe8SJHLgEji1dm7kKhdg8yWRRYuqlPwD6TZqrVXRXh6/2YJ+abzdQ6diUdiOLEpdmElsv1CVI7ZeekV59nubLicX1IzDZpFRWBr0MyFYm9UDBGn7xyiYSsT8uWrpRPlUtJfTgEFePeR6cWAcjfjRE23KGQ0acY548ys5atfVC2yMomSgoGG2/SLawIGU/CDy3HnLfza6fr4QVVJVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIMskcMmW9xSyjM1KVXk45niQpHfG2Qtf4BedIXwqDY=;
 b=IhmezGIZbRjjxPaQfbLSUJaADydFcBtbve5wjwLV/15+AGKWlxIJC1inekp9fMiuZ3IoLQ6z3J1I/s6g6NEhd/3IALQ+khJ7RCB643cUJiu1aQyX6F+SVbnRK+QN9l5jcSDZD6VJhAIp+Zl2t0IIsXb+n10tBWlYwqT+Vp/Dy5cyq4yAQsbjVhjQ8r6Oia29S4L6enpiq1XDlNZodOsUYj63szoiIugOZdCV0BsUuI1SqTCHEq0ZkZwdY6uOwi9idW3wcqPWHq+no3O0+xN8CJ+tMJcWri7g1MOcMj8217UrIMlernzXeYJFv6AdIiW+S+q/4x0Oip8gHYCCF7+V4Q==
Received: from DM5PR08CA0043.namprd08.prod.outlook.com (2603:10b6:4:60::32) by
 SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Fri, 11 Feb 2022 18:47:44 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::de) by DM5PR08CA0043.outlook.office365.com
 (2603:10b6:4:60::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Fri, 11 Feb 2022 18:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 18:47:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 18:47:42 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 10:47:39 -0800
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com> <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf> <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
 <87h795dbnm.fsf@nvidia.com> <20220211152901.inmg5klgb6pryms7@skbuf>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Date:   Fri, 11 Feb 2022 19:24:34 +0100
In-Reply-To: <20220211152901.inmg5klgb6pryms7@skbuf>
Message-ID: <878ruhckaf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69325cd4-42cf-4406-685f-08d9ed8efd15
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB43651A985A7E60F4676BF816D6309@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6chhjuIlpSPInd+zLlDnJxqD/x4XS9WprnX+CXpP54yg6u6YZhwjgSmTo5YD6J7fSTs+Hk5K4ckt5nCvGTro3xpp2dbNMKD/kUR9h0+dH2NIkeB9eFUs6uzD0QuEQD1kAFsKcr0xAXIBrsS+0MyH/1Roauwd9MbkgURfcIZ6jK5Xh7I7m0qFBEogoGUgGdVJp5R79H32L24Wsi2/keln0++KccIM9Prmx+d8H+EF+G14SeuDDxBUIIsyRkcrFGIfg/AbmzUNI/6PnoBZatIZ8XAk4GzGkZJERZhxi7zP0jvePqOv5FpshnkWaqVgO66kyeZSypgAAzxPLIsmXs2R6XNB1T0hMdijDuOtmHipPPJ25b6g0K10jbCeHf27zlvwA5NQxS4aK7eHIdDy1E4QXSqRF0gMVMPmzoejxwqKiFbV6lVDFgxjQ7VvhOtoDNisbY+JMliRkRZMgZaLoLV+MQwwQg/H1pDknUUfulQr/28gJTw7BQqYdpBQ95j19qZDIJNXPGm2a5wWNkkA8dpiRKDgNzqC9iitdZ2vQX3dmRPAOq2atCBnQVIa0JGTPfASyMtpp40zNV/CrQ6NWi1hIhsBdjkPf1kepvUn+3hYqK9U6iICR5wZ8j2badsgE9Dv1pXNkad/wMcEQKueVBG8K7NkMoF9bc+SsvPl2h21Q/BvMvbH01x8bfoncz5swoS7QS2EUPRM7dKwcpI7SK+qw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(81166007)(186003)(26005)(36756003)(2616005)(316002)(16526019)(336012)(426003)(5660300002)(2906002)(40460700003)(7416002)(36860700001)(6666004)(70586007)(4326008)(70206006)(47076005)(356005)(83380400001)(8936002)(8676002)(6916009)(54906003)(508600001)(82310400004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 18:47:43.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69325cd4-42cf-4406-685f-08d9ed8efd15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <olteanv@gmail.com> writes:

> On Fri, Feb 11, 2022 at 08:52:20AM +0100, Petr Machata wrote:
>> 
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > Hi Andrew,
>> >
>> > On Thu, 14 Jan 2021 at 03:03, Andrew Lunn <andrew@lunn.ch> wrote:
>> >> On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
>> >> > On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
>> >> > > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
>> >> > > > + int     (*port_priority_set)(struct dsa_switch *ds, int port,
>> >> > > > +                              struct dsa_mall_skbedit_tc_entry *skbedit);
>> >> > >
>> >> > > The fact we can turn this on/off suggests there should be a way to
>> >> > > disable this in the hardware, when the matchall is removed. I don't
>> >> > > see any such remove support in this patch.
>> >> >
>> >> > I don't understand this comment, sorry. When the matchall filter
>> >> > containing the skbedit action gets removed, DSA calls the driver's
>> >> > .port_priority_set callback again, this time with a priority of 0.
>> >> > There's nothing to "remove" about a port priority. I made an assumption
>> >> > (which I still consider perfectly reasonable) that no port-based
>> >> > prioritization means that all traffic gets classified to traffic class 0.
>> >>
>> >> That does not work for mv88e6xxx. Its default setup, if i remember
>> >> correctly, is it looks at the TOS bits to determine priority
>> >> classes. So in its default state, it is using all the available
>> >> traffic classes.  It can also be configured to look at the VLAN
>> >> priority, or the TCAM can set the priority class, or there is a per
>> >> port default priority, which is what you are describing here. There
>> >> are bits to select which of these happen on ingress, on a per port
>> >> basis.
>> >>
>> >> So setting the port priority to 0 means setting the priority of
>> >> zero. It does not mean go back to the default prioritisation scheme.
>> >>
>> >> I guess any switch which has a range of options for prioritisation
>> >> selection will have a similar problem. It defaults to something,
>> >> probably something a bit smarter than everything goes to traffic class
>> >> 0.
>> >>
>> >>       Andrew
>> >
>> > I was going through my old patches, and re-reading this conversation,
>> > it appears one of us is misunderstanding something.
>> >
>> > I looked at some Marvell datasheet and it has a similar QoS
>> > classification pipeline to Vitesse switches. There is a port-based
>> > default priority which can be overridden by IP DSCP, VLAN PCP, or
>> > advanced QoS classification (TCAM).
>> >
>> > The proposal I had was to configure the default port priority using tc
>> > matchall skbedit priority. Advanced QoS classification would then be
>> > expressed as tc-flower filters with a higher precedence than the
>> > matchall (basically the "catchall"). PCP and DSCP, I don't know if
>> > that can be expressed cleanly using tc. I think there's something in
>> > the dcb ops, but I haven't studied that too deeply.
>> 
>> In 802.1Q-2014, port-default priority is handled as APP entries matching
>> on EtherType of 0. (See Table D-9.) Those are "default priority. For use
>> when priority is not otherwise specified".
>> 
>> So DCB ops just handle these as APP entries. Dunno what DSA does. In
>> mlxsw, we call dcb_ieee_getapp_default_prio_mask() when the DCP set_app
>> hook fires to find the relevant entries and get the priority bitmask.
>
> Thanks, these are great pointers. Last time I looked at DCB ops, the dcb
> iproute program didn't exist, one had to use some LLDP tool IIRC, and it
> was a bit cumbersome and I dismissed it without even looking at all the
> details, I didn't notice that the port-default priority corresponds to a
> selector of 1 and a protocol of 0.
>
> The point is that I'm not bent on using tc-matchall for port-based
> default priority, it's just that I wasn't aware of a better way.
> But I'll look into adding support for DCB ops for my DSA driver, sounds
> like a much, much better fit.
>
>> Now I don't understand DSA at all, but given a chip with fancy defaults,
>> for the DCB interface in particular, it would make sense to me to have
>> two ops. As long as there are default-prio entries, a "set default
>> priority" op would get invoked with the highest configured default
>> priority. When the last entry disappears, an "unset" op would be called.
>
> I don't understand this comment, sorry. I don't know what's a "chip with
> fancy defaults".

I'm referring here to Andrew's "I guess any switch [...] defaults to
something [...] a bit smarter than everything goes to traffic class 0".

>> Not sure what DSA does with ACLs, but it's not clear to me how TC-based
>> prioritization rules coexist with full blown ACLs. I suppose the prio
>> stuff could live on chain 0 and all actions would be skbedit prio pipe
>> goto chain 1 or something. And goto chain 0 is forbidden, because chain
>> 0 is special. Or maybe the prioritization stuff lives on a root qdisc
>> (but no, we need it for ingress packets...) One way or another it looks
>> hairy to dissect and offload accurately IMHO.
>
> There's nothing to understand about the DSA core at all, it has no
> saying in how prioritization or TC rules are configured, that is left
> down to the hardware driver.
>
> To make sure we use the same terminology, when you say "how TC-based
> prioritization rules coexist with full blown ACLs", you mean
> trap/drop/redirect by ACLs, right?

Yeah. But also simple stuff, like skbedit priority, but with complex
matching. Think flower match on a side chain that only gets invoked when
another flower match hits.

> So the ocelot driver has a programmable, fixed pipeline of multiple
> ingress stages (VCAP IS1 for VLAN editing and advanced QoS classification)
> and egress stages (VCAP ES0 for egress VLAN rewriting). We model the
> entire TCAM subsystem using one chain per TCAM lookup, and force gotos
> from the current stage to the next. See
> tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh for the
> intended usage model.
>
> Now, that's all for advanced QoS classification, not for port-based
> default, VLAN PCP and IP DSCP. My line of thinking is that we could do
> the latter via dcb-app, and leave the former where it is (skbedit with
> tc-flower), and they'd coexist just fine, right?

That's what we do. I don't like it very much, because DCB is this odd
HW-centric thing that you can't run on bridged veths. But unfortunately
TC filter configuration that describes the dumb stuff and then follows
up with more of the complex stuff that needs to happen _as well_, seems
like it would be a mess to both dissect in the driver and use on the
command line.

Maybe we need a multi-stage clsact qdisc, or something like that... ^o^
