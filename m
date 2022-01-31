Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152294A4863
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379009AbiAaNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:38:20 -0500
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:22112
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379021AbiAaNiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:38:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INmGoJd0A1ffXtQ7qKHJ1WYz6x6hbGwfT4gdWFdvR9KvhzurwmFWfGZkmOdHeVWFWB8PGcTyxHN/E8kqdeTdYVrphmW5VYTrYXjNKAod+QHWreVMLKFL3Hq/T8Y/5VwB4gcczgJpmCSd1ANA4SNzE+ayo+re+MsO/YOeWRspQoCCulwvdaPHzpcRC9satnmuVBIH0W1J8dYGqQLUoGmU/K9yfXJGP0rMXBQfWAXeCBHezlmvJ4Q5/plmQniTGnxOn+eabNqceJ4AtDXcuy51cGZbD4IafuvLHKKmU2tn4Mk476gJFLu5CNCN74Mjka0P48sjPmPSINGbOdAZtTcuJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xElgux6BmgiP3E8QHmkO7CYpOBQZzIRl9G86QN75/xQ=;
 b=GDdX4gL9QG+sjmgpOZDa7Klejej5+irKC8Jqm6VrzJSLzieVXWYYUamHy3yMIocalsS33xo8Hbutja7HdvAIj5t4TRP9SGmarM1YXE/djNTgtSk4c3TFZk2IgFrx64Fb71RvHqXhqIK+mVwhoDKFUFz3MakIi1p1oa8BnSHt5CvXDJg0LSE1TqRXvhuz9+a9jB3XkHKYgk1a8maRQInb0VjK7yF/wb14xIP9Hl7slPg5w5DGdsE+Ix/g2c3zlG9ibUjw65bUi0FkVvDBpTSPcFMzjRzQA57EwhqAQ5N2MQsAqjjwXm8SIr59NC/JMU37YgpBdHVCVRG2jDq5WP93kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xElgux6BmgiP3E8QHmkO7CYpOBQZzIRl9G86QN75/xQ=;
 b=lMw5qJWhiNB5NAkBxQvYOFBgdBC6n3yPlGPLH1/d08lS/cXGJo6WW56DeZk2/+l/S+pXEAFvVkU+i8v9KjmPnc/Qfx1SjqsypMNUdMwH+O37ZGO2yfV7kmH+hp0XTS+WyT12Q4TLh2JLI7EjD5BMBm/iLyvdzDGP6Pgg6BB27wrfxdEL8/5YiHGj1FlDpVdBX9phFPwd+4faNxwksB6K/ryTw7adGkG+XngSGctYawm+287W+04g76WeWNnpPAmqMqpqV6T+CDaMVfSTT7HSXfF+s+w1f6yXLN7Ag4HBjgDE5iJbn6g7fD7hd0h9LeISvMD7qpokL8soF7QWvOAu2w==
Received: from BN9PR03CA0504.namprd03.prod.outlook.com (2603:10b6:408:130::29)
 by BN6PR1201MB2499.namprd12.prod.outlook.com (2603:10b6:404:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 13:37:59 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::c8) by BN9PR03CA0504.outlook.office365.com
 (2603:10b6:408:130::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 13:37:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 13:37:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 13:37:58 +0000
Received: from [172.27.13.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 05:37:52 -0800
Message-ID: <5090da78-305c-dc42-65a6-ef0b2927db51@nvidia.com>
Date:   Mon, 31 Jan 2022 15:37:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf v2 4/4] bpf: Fix documentation of th_len in
 bpf_tcp_{gen,check}_syncookie
Content-Language: en-US
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-5-maximmi@nvidia.com>
 <CACAyw9_5-T5Y9AQpAmCe=aj9A0Q=SMyx1cMz6TRQvnW=NU9ygA@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CACAyw9_5-T5Y9AQpAmCe=aj9A0Q=SMyx1cMz6TRQvnW=NU9ygA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d1f3692-2bae-4c83-7b88-08d9e4bee57e
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2499:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2499085651EE12AFAA7EC4C4DC259@BN6PR1201MB2499.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H2PGwsmtUfbxUH9sliN6xOBdxoiv/P+pgZi+3N4HyOnfshCusPsgh5Sf0BxYtJzrD+L4sh1iuj3Jgq9UajMdwo4uQbLa57MEbKofE1RpqGWC//ApiGVBM7FwcgCIwVCGnbWCiu4O9/fa0dW6K9bSxsbH4Fs3OpMFz7xKF0C/bnWxrxra3gUQ0309MEed2X0oCeTHdUmnkLisje4iEyqWOeCCOl9GABjv20sR7o5EOvRC0oVshYiLFuNfYFVJYxUfv2RuSJr/4hz+4QcpACkEQSJPKLdkAMZQSO+AH8AynJCyo0Pzo+vzldm65aQZbV5bO6BQDx2K8ju9lK4mqZlL7GvHJiwlHHeqoooCu1lVRfLGp78JGe9rjBV+y2bbVJnF+wCd6zNv4k/MisvMIgqNC7iLI6AnmwnHmv5AGz9D7sIoL17ekEDk8fDXgSZxXjoX8L5QEgKpgXDemEUb+g6Bs/c7id95D1cDyxkNzORspked4vb3+5Lh+UJUupP5BIKTqc6hyRaBt646ZOqxnPJNpZffeutp+UHh5846+WPNlBIyE0HpoDvH4lm29raKLBjZ86bAdV0r+r2+V3f7E0JmvWkpd7qTlv4ygL8MliwGqxN31+DF5Ra0ekvUDm/tylw69fR3cgoiUO+ILB/gOrU9X6cqZFHXr57g8M0VH/dldqYiXOa7HwfQ2CuI8AMFxTIBxDCVZtYweRinTvO7OCrCMosAfk9TtiHvm+eX/hgU6E0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(86362001)(6916009)(508600001)(31696002)(70586007)(70206006)(54906003)(356005)(316002)(81166007)(16576012)(31686004)(36860700001)(4326008)(8936002)(8676002)(36756003)(26005)(16526019)(5660300002)(2616005)(2906002)(7416002)(6666004)(53546011)(47076005)(336012)(426003)(40460700003)(83380400001)(82310400004)(186003)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:37:59.3108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1f3692-2bae-4c83-7b88-08d9e4bee57e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 11:45, Lorenz Bauer wrote:
> On Mon, 24 Jan 2022 at 15:13, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie expect the full length
>> of the TCP header (with all extensions). Fix the documentation that says
>> it should be sizeof(struct tcphdr).
> 
> I don't understand this change, sorry. Are you referring to the fact
> that the check is len < sizeof(*th) instead of len != sizeof(*th)?
> 
> Your commit message makes me think that the helpers will access data
> in the extension headers, which isn't true as far as I can tell.

Yes, they will. See bpf_tcp_gen_syncookie -> tcp_v4_get_syncookie -> 
tcp_get_syncookie_mss -> tcp_parse_mss_option, which iterates over the 
TCP options ("extensions" wasn't the best word I used here). Moreover, 
bpf_tcp_gen_syncookie even checks that th_len == th->doff * 4.

Although bpf_tcp_check_syncookie doesn't need the TCP options and 
doesn't enforce them to be passed, it's still allowed.

> That
> would be a problem in fact, since it could be used to read memory that
> the verifier hasn't deemed safe.

It's safe, because bpf_tcp_gen_syncookie reads up to th_len, which is 
ARG_CONST_SIZE for the TCP header.
