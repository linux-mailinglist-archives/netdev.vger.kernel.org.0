Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0838E562
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 13:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhEXL0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 07:26:00 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:37664
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232864AbhEXLZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 07:25:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8mIeeV9UR2M21aWwCIcpuqidU7l6kMSB1yDP2Cz755X/wlGnZZpRK4KgXlZwuTHcQR2RUeVDAvVBVpsEleSp+xDiAQh9JIDES4L3vBW9FtKLOUjTa1M9+z4zrjUhV+fYBIcOKgb0ZAI77ZSvj2gpDbPzOOMATjwylV2JDScH+xqgOd0TvGCrk0NQ7+GFdooXmfMXDhid53+3pP70H3jlxYZBhuOnHJefc5NP8HeNKfVeu34yYRZyphJTpsofCSU5M06vEbz9YeZKfQo8ltH/1x1I3EWyobtjYb1U/iAzmPZWfflzbLoR65eF0VHlmlRnKh8KFxRDLis5+iTHl7tJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHfXGdEc9LN4ryVHf2nbjK/EVjcwcb48qTv00rKHlYA=;
 b=V+i757GtpJV17EVB5nGf9QDPI0eECMGvfWNIrrACu8BqRu3/mVEawjNRdHM5VsY9VGRj+IGcS/tPKScmUPa8kkFUPlha9p5UwX4CfDO80nDhnm6bgkw5O2JMv+gvCZAZwTkVrAfJS4W1Ro1V+itqotDDAKpRQOSAKZp+5vAKHBe52c4H2M3vYlNZlA7zdd8wpXIsDeVqHZNkj8RIHXvQcZICZLCk4k6HC0sXNCWe67Vz0X8Pi8AapTlY7MhNmk7dtlUwmjR3ryXkO8cE/HdXH4Y15Ijpn5iUjTeTSp4uVG3CJR9oQtPGrThuBYSVo6tZYdYsIYVu983FJrRvZXbI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHfXGdEc9LN4ryVHf2nbjK/EVjcwcb48qTv00rKHlYA=;
 b=hJwuSzXn5GKMwd2YnlldCn83g57+fYwFqtNQHlVxfgdiQfDPHSePfYSM9nISAX4MMlF7mw7rpM0GgEwL3KgYxyRE+OuVILvA1ZBLDPqnY/nmy61jF6pDPfDL+L7NO86X0ccLIt0UZbZK8/VwFfwruRznLilwYnb8LPJa2KentoSGnvyTOr3zelwz53nCUaz+qQmpEcTir73VQq+wSTHdZM4CvcCnlAzYZo3XgUWU0ewzxqQb5xLeV8tpUt6EVNMUTuK3nmB1OaxchA/U/N3GyVK3qnXE7L6s7oPHnLanpqjzYIlXyLyV2JMugoDc9bz7ajl4+qT+yHJVAnWHyZ4xHA==
Received: from MW4PR03CA0177.namprd03.prod.outlook.com (2603:10b6:303:8d::32)
 by BN6PR12MB1796.namprd12.prod.outlook.com (2603:10b6:404:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Mon, 24 May
 2021 11:24:01 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::d0) by MW4PR03CA0177.outlook.office365.com
 (2603:10b6:303:8d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 11:24:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 11:24:01 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 24 May 2021 11:23:58 +0000
References: <20210524061959.2349342-1-vladbu@nvidia.com>
 <20210524100137.GA3194@breakpoint.cc>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pablo@netfilter.org>,
        <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <saeedm@mellanox.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: zero-initialize skb extensions on allocation
In-Reply-To: <20210524100137.GA3194@breakpoint.cc>
Date:   Mon, 24 May 2021 14:23:56 +0300
Message-ID: <ygnhy2c48jeb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d076522-2c02-4291-700f-08d91ea66e7a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1796:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1796A0D2BBD6E1B32D1ECD25A0269@BN6PR12MB1796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rETcwFwiUOcSfaFeVqA941ObhJiG5sU6w4Oz7M+0E6RI95yhb4joVN74gKPTK0iWqxX9dP9bkaLrao4oGSGYx3jt4dZhJ4WNqT+THxsT77HHG+6jhmzU10ECQOPhTw8yoP+bE5v7dnAMqEurrfwOHdl7uoRv+DXkz8kZNZ8p50QnA9tKGsQPk6SSrDOmPBdeWISjIGk/nGNx5cpHBcNK/dkNoC4i4OGveh/G67yF602JYoXacUv7YOI8FElsTTk1zAWzskBf6RnrGLHIwPguVyiwett4BFXoSbicIA3LAhBHljWCcSfDRlB78ojpAkwaoAekMBPyEoH3VJ56vX5a5BpyAdp08NT7zYkYDy4qIHZB2z0z0lqVVdvTUGL5PDLm14TV71mc0y5JNCyYkpwJxLSFjza2SmBRMkrmjq+voy/JEQ2V0mLK8Mss8mJCVMxkhjx3wDqxXP5R8R/qCIKDHehe30V/2f/8PTVeP0cK+ZzW4N2ja2Cg0iBiy79xgKXx7qy6WcwcQYRKx+CeHBpjRo/vBdvfy1dtKilfsojF/gf3tIt9XL0txuVT5dhzG6AgFpfpmDb7IdTnXSrkaOHCd0jPyWGWFM/UO0jbhpGeetgoNlVn9QFH6T6x9WTLo0b/F13IqsAy5EsF+Y54BRp/HjYIXav3ZFQm4XK+8tkBYrM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(46966006)(70206006)(8936002)(36860700001)(8676002)(70586007)(6916009)(47076005)(82310400003)(26005)(82740400003)(356005)(426003)(336012)(7696005)(7636003)(478600001)(2906002)(5660300002)(86362001)(54906003)(16526019)(36906005)(2616005)(186003)(36756003)(4326008)(83380400001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 11:24:01.5538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d076522-2c02-4291-700f-08d91ea66e7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 24 May 2021 at 13:01, Florian Westphal <fw@strlen.de> wrote:
> Vlad Buslov <vladbu@nvidia.com> wrote:
>> Function skb_ext_add() doesn't initialize created skb extension with any
>> value and leaves it up to the user.
>
> That was intentional.
>
> Its unlikely that all extensions are active at the same time on same skb.
>
> This is also the reason why the extension struct uses offset addressing
> to get the extension data rather than the simpler
>
> skb_ext {
> 	struct sec_path sp;
> 	struct nf_bridge_info nfbr;
> 	...
> }
>
> So adding e.g. mptcp extension will only touch 1 cacheline instead of 3
> (or more if more extensions get added in the future).
>
> IOW, i would prefer if tc would add tc_skb_add_ext() or similar and
> zero whats needed there.

Got it. Thanks for the explanation!

>
>> Fix the issue by changing __skb_ext_alloc() function to request
>> zero-initialized memory from kmem cache. Note that skb extension allocation
>> in skb_ext_maybe_cow() is not changed because newly allocated memory is
>> immediately overwritten with content of old skb extension so there is no
>> need to pre-initialize it.
>>
>> Multiple users of skb extension API have already been manually setting
>> newly allocated skb extension memory to zero. Remove such code and rely on
>> skb extension API instead.
>
> Are you sure its safe?

Apparently it is not, since you found a problem with nf_bridge_alloc :)

>
>>  static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
>>  {
>>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>> -	struct nf_bridge_info *b = skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
>> -
>> -	if (b)
>> -		memset(b, 0, sizeof(*b));
>> -
>> -	return b;
>> +	return skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
>
> So in the (unlikely) case where skb_ext_add did not allocate a new
> extension, the memory is no longer cleared.
>
> If the skb had an nf_bridge_info extension previously that got
> discarded earlier via skb_ext_del() this now leaks the old content.

So what would you suggest: provide a dedicated wrapper for TC skb
extension that will memset resulting extension to zero or refactor my
patch to zero-initialize specific skb extension in skb_ext_add() (only
the extension requested and also when previously discarded extension is
reused)?

