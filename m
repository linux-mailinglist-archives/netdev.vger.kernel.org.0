Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3A4B20CF
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244800AbiBKI4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:56:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiBKI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:56:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F96E6C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 00:56:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVDkdOrge6/LhjgldVC8wK9qlNSqaWRazYWLSCj8RrqHMHjk6a86gzIW0tEa21SA7ejmeuvZYrXhcJsEQkP7j+oMb5vvhG/JPkkeDXQZpVVqz9ffeOfe2k7jAW/tj8YQ8yqarannlXJgwjkq40l9C2Ih24S6MeZCA+awTktib44SWkHOtI/lDSm6EbY7RjoYq8itdV80xu2pbFFFV/6bUNc6FqCcdOKM34BizOgn6svr+LFQ6c2vVXKMqDFPXqHofBwwQDqC8zqIUVYcHI06mhjNim+Qdu23AAdxZhb+YSgXKcpvGN4rbBdw5nCyo6JtKOVaLwjtTOTWdXPdtOXTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8Y6kqFSN/WZGB6g7iGGcitnl8EIfthhUJL8RVVUST8=;
 b=DhorQAgFdpJsQBqongHppSgIkY9Vv5l+SZpNauvpcpKNExSKJX76daI/BPXM2RQ9jv8SN5oVf+6xnQIaxB3JXlNTOKBgozCq6FVfEr7zqAukfGcnlegYmlrwSA2bpibHejC/ySCgQCs/K7EMw7524xyZf1cH3oxm+4v64U2/FlaDATsbSaj+cYxZab/SzQb3GO86QYeTSb08LYL05rbNz48jihkMxlJg7ACV+SDW4wUFwdPqL+fTwDt0LzVbYOA2hpKb199a83JY/EqPn8KdzGhHNgc8n7DmFFz+EPwslHjor/s0CyldqTbmzvoD03WL23ZgutH2KnuqG1NU7eL0PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8Y6kqFSN/WZGB6g7iGGcitnl8EIfthhUJL8RVVUST8=;
 b=XD9LlUb89zI4BfvSSNwhpmX7fgEA1szB2fY5R8wiNEQqF5A2QV5PWqTzklHjqSx5QVJc/TJvhw/crf0AFFg49tcHxQibk2AMzK94yYnaZnrgydu2C3Dm9aRxGjcT7r5U5FEMOYm9K2R38AaPCqTVhWVTlpojRFeh2TWGGngKnz69el2dBN5wAmI9wRLJlbGMj2IXjvNjfNQDlhwrqlCiU9u6YC25ps6xHHaoE4ix7gf2Cx999o0gpUk/9SuoJSzORQGsTgL4FUE7epbPn+TGFaaF8agsqQmk56kXu5Sbi/lVAkOALYGvpyh76LL8PyAyFYYug/mb1KERQtjS/yl2MA==
Received: from MWHPR02CA0001.namprd02.prod.outlook.com (2603:10b6:300:4b::11)
 by DM5PR12MB1691.namprd12.prod.outlook.com (2603:10b6:4:8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Fri, 11 Feb 2022 08:56:37 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::19) by MWHPR02CA0001.outlook.office365.com
 (2603:10b6:300:4b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Fri, 11 Feb 2022 08:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 08:56:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 08:56:36 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 00:56:32 -0800
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com> <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf> <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Date:   Fri, 11 Feb 2022 08:52:20 +0100
In-Reply-To: <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
Message-ID: <87h795dbnm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8447ff01-0f7c-4289-120e-08d9ed3c6978
X-MS-TrafficTypeDiagnostic: DM5PR12MB1691:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB16919E9017401EA3233F02E7D6309@DM5PR12MB1691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCoeelOGC6KBK/92afMHncUwuIAgi52xedTHk2I48MunotowtWXE9eyzJh6Ctkiz3HKWUmoDPFg+do5H5RpK6KVaLrArHAgv0cCHfsS5vW7/gkdVJRfNCOmHrqLhtTbftirN5nB4084NjAWPDyVP7Jyt3WLxlXNTS7qqk3SyNdu4C1maid+w1plb5xFow7/lm5nDHSOPXTPWLuHJgKwLonMW3qxBEqoOg3gR61r25sLEFLSvTBgJ1kmyJ5+GtrpDssC+3ZRxRvmH1CFLH2y/0Pr678Fy/YqV4vOXzwmAIY26rrF6lHPSNgcqo8J7JBDEGEomYPnWD77/A367tsJ80PTCC+qrG7m4f1T4t24Nfu84vLqP9DH4/rug5jaPK4dDAZFvQsFA2HZKBZLUuo57PxM/arZqMnV1C24fgfV+6oEnLY7aTfYg4e+yEG82wbppKnYza9qVP3emo7iNS37uHt0J3L4l7QTkvElHNPOtrOK/S3jZ0uNDPbTIFSucs6UHRmWZAd6/9EdslMr9TTpOHbO5kaCSFWkE02QWsf+5aMHNW8fAKCaiMS19le8r+DPsvFWYkWYFR/Tn5gkAn8SVwXazfL9jtcLj9CdxWBleYsCaA2+MjMDT9TImNNjapvpRooBpfMivDfpx4pJP2NBUhZjjLA/I9NR/mmQdUOV/WDVteDmeFT8hGLVDZf1CgdEDIE7k9XNt56UzgiTmUaaINw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7416002)(8676002)(4326008)(356005)(508600001)(70586007)(40460700003)(82310400004)(6666004)(8936002)(5660300002)(36756003)(70206006)(2616005)(16526019)(86362001)(6916009)(316002)(36860700001)(47076005)(426003)(336012)(2906002)(81166007)(54906003)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:56:37.1683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8447ff01-0f7c-4289-120e-08d9ed3c6978
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1691
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

> Hi Andrew,
>
> On Thu, 14 Jan 2021 at 03:03, Andrew Lunn <andrew@lunn.ch> wrote:
>> On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
>> > On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
>> > > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
>> > > > + int     (*port_priority_set)(struct dsa_switch *ds, int port,
>> > > > +                              struct dsa_mall_skbedit_tc_entry *skbedit);
>> > >
>> > > The fact we can turn this on/off suggests there should be a way to
>> > > disable this in the hardware, when the matchall is removed. I don't
>> > > see any such remove support in this patch.
>> >
>> > I don't understand this comment, sorry. When the matchall filter
>> > containing the skbedit action gets removed, DSA calls the driver's
>> > .port_priority_set callback again, this time with a priority of 0.
>> > There's nothing to "remove" about a port priority. I made an assumption
>> > (which I still consider perfectly reasonable) that no port-based
>> > prioritization means that all traffic gets classified to traffic class 0.
>>
>> That does not work for mv88e6xxx. Its default setup, if i remember
>> correctly, is it looks at the TOS bits to determine priority
>> classes. So in its default state, it is using all the available
>> traffic classes.  It can also be configured to look at the VLAN
>> priority, or the TCAM can set the priority class, or there is a per
>> port default priority, which is what you are describing here. There
>> are bits to select which of these happen on ingress, on a per port
>> basis.
>>
>> So setting the port priority to 0 means setting the priority of
>> zero. It does not mean go back to the default prioritisation scheme.
>>
>> I guess any switch which has a range of options for prioritisation
>> selection will have a similar problem. It defaults to something,
>> probably something a bit smarter than everything goes to traffic class
>> 0.
>>
>>       Andrew
>
> I was going through my old patches, and re-reading this conversation,
> it appears one of us is misunderstanding something.
>
> I looked at some Marvell datasheet and it has a similar QoS
> classification pipeline to Vitesse switches. There is a port-based
> default priority which can be overridden by IP DSCP, VLAN PCP, or
> advanced QoS classification (TCAM).
>
> The proposal I had was to configure the default port priority using tc
> matchall skbedit priority. Advanced QoS classification would then be
> expressed as tc-flower filters with a higher precedence than the
> matchall (basically the "catchall"). PCP and DSCP, I don't know if
> that can be expressed cleanly using tc. I think there's something in
> the dcb ops, but I haven't studied that too deeply.

In 802.1Q-2014, port-default priority is handled as APP entries matching
on EtherType of 0. (See Table D-9.) Those are "default priority. For use
when priority is not otherwise specified".

So DCB ops just handle these as APP entries. Dunno what DSA does. In
mlxsw, we call dcb_ieee_getapp_default_prio_mask() when the DCP set_app
hook fires to find the relevant entries and get the priority bitmask.

Now I don't understand DSA at all, but given a chip with fancy defaults,
for the DCB interface in particular, it would make sense to me to have
two ops. As long as there are default-prio entries, a "set default
priority" op would get invoked with the highest configured default
priority. When the last entry disappears, an "unset" op would be called.

Not sure what DSA does with ACLs, but it's not clear to me how TC-based
prioritization rules coexist with full blown ACLs. I suppose the prio
stuff could live on chain 0 and all actions would be skbedit prio pipe
goto chain 1 or something. And goto chain 0 is forbidden, because chain
0 is special. Or maybe the prioritization stuff lives on a root qdisc
(but no, we need it for ingress packets...) One way or another it looks
hairy to dissect and offload accurately IMHO.
