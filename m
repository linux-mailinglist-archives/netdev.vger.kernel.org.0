Return-Path: <netdev+bounces-4625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5323A70D985
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E1A51C20D17
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4646E1E529;
	Tue, 23 May 2023 09:49:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344581E516
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:49:47 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFDCE58
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5HJ2fZL6N+4Ooi0/+BUULak8n4sDKUAA30UDGwl/43TlvUgpZQ1rNEyzdPIXAeigKi/gcRBzlTfbjyP7Wfad5nDSeVaotBsrAlQawq4KIDZkpS/KLeNNwnfEIVY4FevL4i3H9O4eeH5jdmyvYxCkv/TIvEtKH3AukWXVOeyP8HXGlBxkeLDS0WOyJwH8h22TphJ/Nukz6OkiRgOG1S+SVQBMexDeLNvfX7h5lJRrdD/b+3pRuH+02rq0ZvM3EaqNVxFICpI9RO5iXv/LgaUIYNpzFSftbqetl2gElhwwuj6iEfkiFUb0CaSOCnmLzqnmlNdUwPAKAJMG1tkHi3QBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QDFsC7/eF+eUgay2s52gnHJCE5J/NulpkkwCi/eSbg=;
 b=odO9gwDidQHINpURnMnMAmuMLki/D4exV05u9t/7oz7OHzkRtASlIfyhGtDmRxn39NQxcj82F3icEdObRG/PZvrk0IWj0URpWewG5+u+212AuwkUXUu71KS7OYXHNamYQX0a/5pCONibAjqpNDbgkmLYwFN72V3AQJgVCpk+lR9vDGSFP02ARubMJlNY1on9SFqZ/jP21K8AN6gxApxCxPAJ+xeSoQo+FeSc/OgoRcxLr/Cx7mwPWRsdau/TMOiwJaEpOlboY5L0ptE59uAW3ut1c6nWCrw+D0kvXQIu+J0Rzr/DcudWO8UwZdgObLjOepNx19+O5IlCzQL0HK12Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QDFsC7/eF+eUgay2s52gnHJCE5J/NulpkkwCi/eSbg=;
 b=gKrJ0h2FgCU/FlTPF5gR0oZRLV8RIgWV7oQfVn2hQgrgWEtkwTYjv1VXSsKwjFR3n7JA+xmQzZftkonX0NG1WiVlL5GO1evsOt206aY3+7Z04PUoqWZSRtYOFE1H5UqgoY95oWXvLa//vkLUuC4Btk1RwVuj3d9+j92HkXRib3nax3IfRXO2pJv/8URj1g5xh1oGPkZ1hbrAnT85DSeHVSjBGHEd7LTvXefWX9ELcc1OrcGhiGi495TOcT++GG987audQc6bRuIXP2VW0Nmw37RuRQ0bYhcWjsrh9LPtX558VEB+Ku4WIvfw11e3MJGXEtMvZBq9bFwmHsh/SJt2kg==
Received: from MW4PR04CA0184.namprd04.prod.outlook.com (2603:10b6:303:86::9)
 by MN0PR12MB5764.namprd12.prod.outlook.com (2603:10b6:208:377::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Tue, 23 May
 2023 09:49:41 +0000
Received: from CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::2d) by MW4PR04CA0184.outlook.office365.com
 (2603:10b6:303:86::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Tue, 23 May 2023 09:49:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT072.mail.protection.outlook.com (10.13.174.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 09:49:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 02:49:28 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 02:49:25 -0700
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder> <20230521124741.3bb2904c@hermes.local>
 <ZGsIhkGT4RBUTS+F@shredder> <20230522083216.09cc8fd7@hermes.local>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Ido Schimmel <idosch@idosch.org>, Vladimir Nikishkin
	<vladimir@nikishkin.pw>, <dsahern@gmail.com>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <eng.alaamohamedsoliman.am@gmail.com>,
	<gnault@redhat.com>, <razor@blackwall.org>, <idosch@nvidia.com>,
	<liuhangbin@gmail.com>, <eyal.birger@gmail.com>, <jtoppins@redhat.com>
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Date: Tue, 23 May 2023 11:31:45 +0200
In-Reply-To: <20230522083216.09cc8fd7@hermes.local>
Message-ID: <87ttw35qe5.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT072:EE_|MN0PR12MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ca806f-c8a4-4a55-87e3-08db5b7307f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kJ0zj/9dDIQFrwehwRLJboQ1H9wOZyjKgRj6ym+X830nBJ+OtlpOBA6CUN4Mq7Iwg7zoGSM/bwqnLZZfrjp27sH8vZVp3sakzcYcjdoqTFxnJ/WXx/iIF0IhOhXsWvocnGujbEYfdG+Y+xpfmQQE6o6k1j4nwA19yDSvKQqPVvAqJ8Y4POOB1Wmqu5rJx65H7vk1WzyMf5nd2sbuh+rv8nXeqHXRU2LEg4+8lb5DNBb9wQCAONdV1nXFQgMa6PY3Zm5/OOA6xBe6FJbXOzGp8Ezck00XTvMLI01LtSBevklJNcLZLZ5IMn9gQfwFLhGAaDoiY7UgNsKsN6LZSoCyiCg/MkjwPPA6jzKYZmtBtXzIPee12HtKu8SN9q0X6QPerZ9p5JFsD3vY9O19AZpNnf4Si+YKFjHA9USe7N0SPyzWM+BTAA0WKq5Qmxi8eO1Z4nr9LIrCTyyunQYq+5SfzkQiOD/xJiF4iyXv6LHgHpjKCOMg26/QnjuUcWHUvzQNiuw0PcLPNoWiLAb6g/yhdZcQV4/JCCWlbQfB18ZtpLa6pe6LXAX23JfhFsr+5XZChux5PvssNq/aiFzChRTZDVk5qo1EkUSix60Y6Uq5AEdbfP89X4iTNFp7EAOYeH7WJCeiuZ7Q1J/IHBfigvAcparFIWraBBIPKQ/xrL87qLQiOsN1m2vgueK9Xk2E/6OcxCbGAQer5J9IOxa9voHe0jKVCNr5DUovntoMu80U0p+wbp7KlghxZpJDWUWs50rg
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(186003)(316002)(26005)(86362001)(16526019)(6666004)(2906002)(8676002)(8936002)(40480700001)(7416002)(36756003)(40460700003)(5660300002)(41300700001)(7636003)(478600001)(36860700001)(54906003)(356005)(82740400003)(336012)(426003)(2616005)(82310400005)(4326008)(47076005)(70586007)(6916009)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 09:49:41.5017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ca806f-c8a4-4a55-87e3-08db5b7307f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5764
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Mon, 22 May 2023 09:15:34 +0300
> Ido Schimmel <idosch@idosch.org> wrote:
>
>> On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
>> > On Sun, 21 May 2023 22:23:25 +0300
>> > Ido Schimmel <idosch@idosch.org> wrote:
>> >   
>> > > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
>> > > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
>> > > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))  
>> > 
>> > That will not work for non json case.  It will print localbypass whether it is set or not.
>> > The third argument is a format string used in the print routine.  
>> 
>> Yea, replied too late...
>> 
>> Anyway, my main problem is with the JSON output. Looking at other
>> boolean VXLAN options, we have at least 3 different formats:
>> 
>> 1. Only print when "true" for both JSON and non-JSON output. Used for
>> "external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
>> "remcsum_tx", "remcsum_rx".
>> 
>> 2. Print when both "true" and "false" for both JSON and non-JSON output.
>> Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".
>> 
>> 3. Print JSON when both "true" and "false" and non-JSON only when
>> "false". Used for "learning".
>> 
>> I don't think we should be adding another format. We need to decide:
>> 
>> 1. What is the canonical format going forward?
>> 
>> 2. Do we change the format of existing options?
>> 
>> My preference is:
>> 
>> 1. Format 2. Can be implemented in a common helper used for all VXLAN
>> options.
>> 
>> 2. Yes. It makes all the boolean options consistent and avoids future
>> discussions such as this where a random option is used for a new option.
>
> A fourth option is to us print_null(). The term null is confusing and people
> seem to avoid it.  But it is often used by python programmers as way to represent
> options. That would be my preferred option but others seem to disagree.
>
> Option #2 is no good. Any printing of true/false in non-JSON output is a diveregence
> from the most common practice across iproute2.

I think Ido means printing something in both true and false cases, not
using literally the words true and false. That would be a divergence,
yes.

> That leaves #3 as the correct and best output.

The attribute should IMHO be present in JSON output always, even when
the value is false. JSON is for programmatic consumption, and always
having the value available makes the code less error prone. You can hard
expect the value to be there, and just test what it is, instead of
assuming that absence means false, and possibly silently consuming the
wrong object, or interpreting based on an old version of iproute2.

