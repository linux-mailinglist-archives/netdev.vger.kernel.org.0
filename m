Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC911824E3
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgCKWac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:30:32 -0400
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:15740
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729799AbgCKWac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:30:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD+WS2QDxcTR1gyT15+gl8CX/g/ejDarZc3stjpD2yXVgKubk1myP10vwiSGDxEWtWLz9kcl2qbj/jjOcP8jJxF2AiaqALz3QcNW+avhmnAXYdPXXEQGX4xtjr0HWr4SB9muzMe8qBrDgUizpi12Y7Ddfd7T/GPaEFqcgpxBHWaplGjYLUcgpPZ0yjWF/L2trW6EaW+gR+9e5t8gIQJmhk3QsmfuMRUUCIc2KR2P+rzATw5LcZvzwWL+V2kI17wKsLlY0Fs7pdeqLtFP1YoziXygLeL2RMZbz2Kc0KNGVchoRkRAdQyKJu/mRVgPyAtdb8G3eRDMepGWNltmPl3TAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=junn07zVl7UxZNkJ4P4BhPCeAR1iSM8a69dk5FhP8Pc=;
 b=cNl5LhZKovknQXTJPvXRZ0vO0YdA+3JAZU7dbTiSaVfw48Gk3XLL1o0u5Q8XIkbHzHt/1RyBhSukA9Vask+IbL11UXFsrh8X2G9th+++au0CeRTSnujRDnU6tQDWHXFX0PZ1e0KQBTHe96LQ29TZEfvU6OsRDwl18h7psKRTAjBXCBO3UwOfAIrwUMiPIoLfNX4klwovJumAI0S61I9NY0XlISrSSfIu3XtSmISF1dv+tQsHoV7jcCEhTDPtmx330Q9OJwJ+Oh3uVz19EcLDbwZw2V3TAi5fWcpXxKJqZnVzNfidIysmRB7ZtEVXnsHwwnJhdwQZJ8XNDrjrhVOKSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=junn07zVl7UxZNkJ4P4BhPCeAR1iSM8a69dk5FhP8Pc=;
 b=No6kDkRIL4aOMFGqxb9RvLBCLQTaUV3AP29qWrjlt1UjviL9f5i06HrkNtz++Su64x9thl/BBsZ4Tav7y3yWKFmHV6miBcTQxJvUA7kxKr2nrYNfjzh1oCtCGGH8aMjqwq/9fEjPlYEjetTz+n32yJpqCoL79Vu1drsQQDzJ7gM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4293.eurprd05.prod.outlook.com (52.135.162.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Wed, 11 Mar 2020 22:29:51 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.007; Wed, 11 Mar 2020
 22:29:51 +0000
Subject: Re: [PATCH net-next ct-offload v3 13/15] net/mlx5e: CT: Offload
 established flows
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <1583937238-21511-14-git-send-email-paulb@mellanox.com>
 <d883b801-2325-f3b3-c60d-257484dbfff0@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <74aeb587-d4f4-b5a8-258d-8b661585aaf6@mellanox.com>
Date:   Thu, 12 Mar 2020 00:29:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <d883b801-2325-f3b3-c60d-257484dbfff0@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PR3P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::28) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR3P192CA0023.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Wed, 11 Mar 2020 22:29:50 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff6b3546-23e1-41a2-1222-08d7c60bb6ea
X-MS-TrafficTypeDiagnostic: AM6PR05MB4293:|AM6PR05MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4293DEEEF1F47DFCB14BBB7DCFFC0@AM6PR05MB4293.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(6636002)(2906002)(31686004)(2616005)(186003)(16526019)(8676002)(26005)(81156014)(6486002)(956004)(81166006)(66946007)(66556008)(316002)(66476007)(52116002)(110136005)(31696002)(16576012)(8936002)(86362001)(53546011)(36756003)(478600001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4293;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ez5yW5siNTiA7GCQ8N2hjgMZiGm5suureHqKRAD5s6zZ0rwsuum/HNG/e21YBm/RvN/DUuxpkgOEoq+NtM05GUJmGMEcSLk8IiP6haWmvVeMsDGfI+JYdkOupTd319jxIbvUsSj0Ku1TOa9+ULMptnqaqcfz3R1OD5+jrl/OulRcMSmMjUti4tSa5JdkZqDTjYpzobmTsKuz1Sfj0pvdOBFQNTnwt+CpLveefuIn1Q5rIwUtyaRZEFpfC6oda8ywbu1MT0B78Q3bIjnYtZ0CeYJIncuVa6mKbXnEAGj6YBKj0Rvc36wKZ5+XOd2a95zvLhNR6rKgjZVkjTMv4XMpnYsRhRjv2PnqetGR152DB9L/+dKN+Vv155TWjqGfYcNqDlW4DSJ8Gp5PUDJuW72dSCRz5DY8dYk9o9hzx7zUE5pbTxLjgJtzRJMje1oqZCJs
X-MS-Exchange-AntiSpam-MessageData: milzMOaM4EIvsWGHIUF/r80sRccdcStbZKlTpx5lbBf3NlOggFDWo4jpUYMbVO/U4MDKU7gyqGTW2I2K5wWRZJxWEouIUizmCBqGw/h8LolnibnjOG+1pJligaSr6YOIokrc6ptfiMwZZ/xgttgfQw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6b3546-23e1-41a2-1222-08d7c60bb6ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 22:29:51.4463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFcteGB3Rij0rb8ij/R0ruD26WlFQRP9jvmbTL3JqZBhKes0s4trHJB70TTeq+yMX3K3qKdKeV2C9XkRyoCQUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/03/2020 19:45, Edward Cree wrote:
> On 11/03/2020 14:33, Paul Blakey wrote:
>> Register driver callbacks with the nf flow table platform.
>> FT add/delete events will create/delete FTE in the CT/CT_NAT tables.
>>
>> Restoring the CT state on miss will be added in the following patch.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
>> Reviewed-by: Roi Dayan <roid@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
> <snip>
>> +static int
>> +mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
>> +				   char *modact)
>> +{
>> +	u32 offset = act->mangle.offset, field;
>> +
>> +	switch (act->mangle.htype) {
>> +	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
>> +		MLX5_SET(set_action_in, modact, length, 0);
>> +		field = offset == offsetof(struct iphdr, saddr) ?
>> +			MLX5_ACTION_IN_FIELD_OUT_SIPV4 :
>> +			MLX5_ACTION_IN_FIELD_OUT_DIPV4;
> Won't this mishandle any mangle of a field other than src/dst addr?

Yes we didn't expect any other types, it was just the api of mangle.

ill add a else case.

>> +		break;
>> +
>> +	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
>> +		MLX5_SET(set_action_in, modact, length, 0);
>> +		if (offset == offsetof(struct ipv6hdr, saddr))
>> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0;
>> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
>> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 8)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64;
>> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 12)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96;
>> +		else if (offset == offsetof(struct ipv6hdr, daddr))
>> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0;
>> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
>> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 8)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64;
>> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
>> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96;
>> +		else
>> +			return -EOPNOTSUPP;
>> +		break;
>> +
>> +	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
>> +		MLX5_SET(set_action_in, modact, length, 16);
>> +		field = offset == offsetof(struct tcphdr, source) ?
>> +			MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT :
>> +			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
> Ditto.
>
>> +		break;
>> +
>> +	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
>> +		MLX5_SET(set_action_in, modact, length, 16);
>> +		field = offset == offsetof(struct udphdr, source) ?
>> +			MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT :
>> +			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
> s/TCP/UDP/?

yes

thanks will fix

>
> -ed
