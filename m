Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B105B1B50
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiIHLY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiIHLY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:24:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21B03F336
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqyQcX+G7pb9ZHXibPRhbo9Qd/jycz+hbOTmUyCBTHss5bKK4CZuzAJzqYs161b1zk08BLpKS6ifmV9IobGt1HFZtldWTUvJDQUCA+XrMLuce44pzh1JCRuPueXKZB5p6tGQUJ4swPEkzw3ggOA4ne59YteUPljQnaFW+YWWG2L/WqRPo47OMHICBv8deoARCes8kihILQdVs9BERqZt9YnP6MJXkFM3WQe4yNgIfiXLfJN4IPCXBsR5koBq/YjHt5XPRylXo3bequaGIxPlrt/wAwUkaddemiE+qrcZfKwDIKR1JoMVcs/6Y6Z7ctkhCtPd0JQW7rho5ZWr7r/SuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sc2+Qw/I4Y1uLlpIVXNT4Y6HzCA7COKDNSMPZ3lGKAc=;
 b=J7yzl+oxnI7I0IfElZGWKDsCG6sabzT/CmW+CLtgwdafsTaH5ch1U8vvxPrPCeZSXddoscZ04z4qrzMOrtfFTWTciBJTuctqrfGL2BbcMFRdf/51LKVNNj7g4IsYbKdzGZAQL6V3BoUmaLqjKDNVb+h88Q8tKT3CQ+IA1K/hvLw8MUCpsNbigG201KOeuBoHidA1ubIfYkYxNiF6EBPrZ2EWPBFgF4WeIp/AycjMa6tQEVpLmeqLk61Oenh/sstvaujMHWRvGez1K/7U4Z7VERJRpPuDw1dY4kU6l6XLJVWQtOYW6nqY1KrLp8ZBlZNo/hH1MawqUVauTd+Fk/W08A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc2+Qw/I4Y1uLlpIVXNT4Y6HzCA7COKDNSMPZ3lGKAc=;
 b=VusgZkDDDM91F912U6GboiMiuvLuUyRU+zCFucGRibpOoFS2BPhwUHATnQlDUWqzJ2hvr8pCFHaABOUy7vOhFq0lggPZ8TColcfhsClwR3fU03JIpBKTg9LuEiXo0uHzExC7Lf7KNXSHTqankeMf/sLb+86Z849cBto/gib4xZrkc1WEZ1j8IaUNjTsdvawiA0QB9WKRtEBnD7yW9RHi1xhHHRyFdobkLTKPW80PSe7fHqbQdi4Rp2eItb01CPPQ+KiljBW/m2FT5ax91sMBQUbipRG0kWPtbV2qzVKe9+SkDN6oFqARHVbnjai4UOhjoE4KvgikEEJ80gIroIviGg==
Received: from BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::26)
 by SA1PR12MB7104.namprd12.prod.outlook.com (2603:10b6:806:29e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 8 Sep
 2022 11:24:55 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::36) by BN9P223CA0021.outlook.office365.com
 (2603:10b6:408:10b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Thu, 8 Sep 2022 11:24:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 11:24:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 11:24:53 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 04:24:50 -0700
References: <87v8qklbly.fsf@nvidia.com> <YwXXqB64QLDuKObh@DEN-LT-70577>
 <87pmgpki9v.fsf@nvidia.com> <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com> <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf> <Yxj5smlnHEMn0sq2@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <vladimir.oltean@nxp.com>, <Allan.Nielsen@microchip.com>,
        <kuba@kernel.org>, <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Thu, 8 Sep 2022 13:18:17 +0200
In-Reply-To: <Yxj5smlnHEMn0sq2@DEN-LT-70577>
Message-ID: <871qsmf6rk.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT057:EE_|SA1PR12MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed42cd7-a106-4917-5ea2-08da918cc0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6V7bJW68QjjKBbG0ihTDb+35Qnvzff4yYjvH5/FqL4ZZGICCeCBS34DHyoXNI3rI+fLzOFuE5ksbqrXMVABQeIoNb9pnLjVEad1TcnW9HBnLsn26QjTnPTtV4ZTSPvPqPXh3zRMBJsbCViFX4ASLinJPJq9AhVNxyvqwb+Xz91oRwSfY8xOIA2ZYlLJKlZJ5YpfB44d2Kg5b/OWfmSdRN/sCcD6OMq4wGZKUN7cCMU0X9fpK3YEZOpm9IehSw24nRFG5QFNmOIGW87j6xu/gEm6jCQpYfvotJPXD+Z1lvijcb0Dhz1QDAfw4BPBuHc/d9Ja2gNLlPuzkHJcZbJKTW2W2XIgesXnMD1m5nGSbO0u+WZEDN/W3QQkend0PSit2KZi4w0B0aL3bIYPaMffAlkRcYKyIZT5pBmg7oiKZ3P+QTOm41nbzj5rG2eMzxNURFArJFtqPqj55ksKabx4SrhmvzkDpEcS1A6+LFx90srJxbv6LVhQlkY/kkV7nnnqRZ7qEhgYCv+t74fxhz6lyHmW6+kDdrquU5NI0X0nHW4jH/vkjtJ+CckKXC0NANLV4HphfrJwgif5yVoo4uex9YqPWNGxbkAJJzVQ8h5Te61PDQ9a567KZ957LKm5NXeDOF8R9YPkHswYaTuecgHXoewDjZPxOTiZee44iIml8xLGeN99EVq/DeX1BBMoU27YJFaIPvUHu0iuVoVwpSEcGvRS4lsB+cPIzX6OZxUhAkpZgzaUv+GCy19hz7WFflAyVVk1vC6dHh25ocdXF+H4JPKoAN5n5e0pKOpLCHD+YH1ri/XOSMBQvJj0AndWAnqU
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(40470700004)(70586007)(316002)(82310400005)(4326008)(36756003)(70206006)(336012)(6666004)(54906003)(478600001)(6916009)(8936002)(8676002)(41300700001)(2906002)(107886003)(5660300002)(81166007)(2616005)(186003)(26005)(426003)(47076005)(16526019)(86362001)(40460700003)(40480700001)(82740400003)(356005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 11:24:53.7983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed42cd7-a106-4917-5ea2-08da918cc0a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7104
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> On Wed, Sep 07, 2022 at 10:41:10AM +0000, Daniel.Machon@microchip.com wrote:
>> > > Regarding the topic at hand, and the apparent lack of PCP-based
>> > > prioritization in the software data path. VLAN devices have an
>> > > ingress-qos-map and an egress-qos-map. How would prioritization done via
>> > > dcbnl interact with those (who would take precedence)?
>> >
>> > Hi Vladimir,
>> >
>> > They shouldn't interact (at least this is my understanding).
>> >
>> > The ingress and egress maps are for vlan interfaces, and dcb operates
>> > on physical interfaces (dcbx too). You cannot use dcbnl to do
>> > prioritization for vlan interfaces.
>> >
>> > Anyway, I think much of the stuff in DCB is for hw offload only, incl. the
>> > topic at hand. Is the APP table even consulted by the sw stack at all - I
>> > dont think so (apart from drivers).
>> 
>> Not directly, but at least ocelot (or in fact felix) does set
>> skb->priority based on the QoS class from the Extraction Frame Header.
>> So the stack does end up consulting and meaningfully using something
>> that was set based on the dcbnl APP table.
>> 
>> In this sense, for ocelot, there is a real overlap between skb->priority
>> being initially set based on ocelot_xfh_get_qos_class(), and later being
>> overwritten based on the QoS maps of a VLAN interface.
>
> Right, so VLAN QoS maps currently takes precedence, if somebody would choose
> to add a tagged vlan interface on-top of a physical interface with existing
> PCP prioritization - is this a real problem, or just a question of configuration?

We have the same deal going on with TC BTW. Whatever prioritization is
transferred from HW to SW is lost when the packet is passed through the
SW TC rules.

And at least on Spectrum, we don't even have a way to transfer the
priority to SW, as far as I know. So in this sense it's exactly like
DCB, where the in-HW prioritization is completely separate from the SW
one. Except that all DCB APP rules are "skip_sw" and can't not be.
