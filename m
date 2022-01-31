Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099A4A4861
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378992AbiAaNiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:38:16 -0500
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:31840
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1378978AbiAaNhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:37:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThjSenZrHkjHrAzWfu3ULBBbEFyr3n4WLSPMKVVqJGqk20Z/o/HStgpJu5N9KT9t3YcD0CwQNTi8dz2J1ehnrLx2rtUEiXjFt3Y6OX40nnOqavc2+EoU/OdyzRwqQf/VQeqqWqKlMTujpkAUtYd2IRimHw0lRIs4Qu9zyVQY6n9Tb7gKy+zEIfLYdh8CDGrpGKKA6PfuPMtVFeDP/MFfVorCB8rQrnyfWjsSsF0ObPyOjO4JtnsiNnXdxDoaNqwRyWKX/r2psvrku/cfpWkVq8tqoqipNgELckzTnbGY7SO4tnzqkD1eNMfuSz0c96JpDu8INEZvND0CN9slorvZHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msWukM0POXrsPZOxr97ZcuIQuhAiGd5e//rLapmLt+s=;
 b=LjqwNKfHzepeCEjfabSvGuM6d5kk1i74AQhB4T/9WUa75UJqn1SMfnD4FbzavWZqRC9v8xLL/7W2lZ+WvhaZvKFuSNc3AcpgTaL4vbKxpIxBMdP9EwvQ0U0cucp29pphOMcqZnp8YD2lA9alWyJIyQaWG7hr/gXtgg1RrQ3DvF5qA8P1Ff2V9/seDTXkxlO/YSeVg+Ded9dEPaOhG5ox8qgnAUCWRWIxVNMoPoVmzI94Ii2knpKpfXcQMeXYm8bEklmU/88+lT70uVB25+uV3DCfYIObjyA2CP6zVLfoudYTDMpAnxh21oolvRD88Ae73bZJFQ7851nmys5waa9NIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msWukM0POXrsPZOxr97ZcuIQuhAiGd5e//rLapmLt+s=;
 b=bOj8277p0YTiHS6KFHslHUIXHXJshBaCEEftWFCjzGVLMUjdCN3e4Z/8GVt+14+6kwj+Yv6Sil0Nvn39pXH+zDiRffgJVvySeeZQc2dlxc/vAxExq6aiIoTJr6AQJne4ZZ3th2M56BoA4swCkK1snsmleiTxRracpoAlJKLsjUKfrBOO8PtebyW6FLjfthxZsnb4xjrrprpEpNhG6MsGI0ztxndKfVBK9rBuxuw8s2htkhRSTVETtGHqxqptlGoN+tj9Wpl5gds4lltlfYRAQO22xQ5T5cRvUxdISotDgsQOAA5wMmEWHU2bPWnVN7QsemI2vLxDhwZcyi15h8Ur3g==
Received: from BN6PR16CA0001.namprd16.prod.outlook.com (2603:10b6:404:f5::11)
 by BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 31 Jan
 2022 13:37:44 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::79) by BN6PR16CA0001.outlook.office365.com
 (2603:10b6:404:f5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Mon, 31 Jan 2022 13:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 13:37:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 13:37:41 +0000
Received: from [172.27.13.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 05:37:35 -0800
Message-ID: <fefefc43-1912-c1e5-7f50-76f5f68f9386@nvidia.com>
Date:   Mon, 31 Jan 2022 15:37:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf v2 3/4] bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-4-maximmi@nvidia.com>
 <61efa17548a0_274ca2089c@john.notmuch>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <61efa17548a0_274ca2089c@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed96ccc7-8a26-48cf-0d35-08d9e4bedc47
X-MS-TrafficTypeDiagnostic: BN9PR12MB5381:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53815E200077BC27C5B79D20DC259@BN9PR12MB5381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AoXJ1dVcoM7ncQowpc/QM4y27i2S3BO6KLjBdXr/tbD6awqhna6LfdfffOd5blk6GwuqU2WgR3CBdmKcl4EBLEpBkaMC5xzDGR53t/Uxer6/lstTa9AOZ2qLlio0hq2gtiWKnRsyYfQQP5MmNAWOIuv7mgzzhsbKq6Ytplx4wIgKU0XFATPB/PBQdWkyvqUpimkEd+vadEBnjdmAXcTsuHfo8YJ6na3jREDl40O4jTeQhVD7ZNng8dqhBqZCr3D1RmWzSVuFi57iJfu03BytpAJ4I8KAPUhVh/AxS2Oz/TMcXwrrmBmNwSMFc6TWEjcZvqW2o6s397VNbFVCnuWcziveNrcm/wFd9ziCQnt/WQ7IswagttVjAprdrDHT6gGgtHzywbbDAYUyVKpDJNi6Uyw642cFIy36UZi0g/rJUlOslVPylk+qc4NeZAPF3MpirV/DYQDeEvLLcykYt+G4IfV92NXSMoRRKCGhrEQ4CqHMogNSlnzPrCSZUibKi68PDtbCJJFrpkyUJ7lQNSSPxjKCMgnwcAavxq1Lzl4fp3xXVCujTQf01Aw/hxZraORM4ylsIum2Pj130iwvgPlOhxYeTdGn6QMDTvGXxFkxXijhggo9AoPx7S7Sk2MVolmVKKUEUMIVRNApsez/v0AeG8NTMrDOmwH+iImKV970ObekBE0jb3nj5F2Q5q9J2LTo2zq/oUjlMfPJ1AxlDkl0ZPMS/3PAaH/ZyZpoHGsvAiKQdNQu46GeP0l7/0pXn4E9WIPBrA6caBlIC75WMBtAFQsyauKi1iDtZlaeE3G1LwfmlkGfMTLzwqVTHUEzATPxQKpkdFpFn4LZk2AcDQUSakAErpzAwJ2CafjzTzDKJWVab42N55nGaY7V0bAa8ISOBJwFm4708q3TehdVasPM/bq0/vz2DTE1HQjdZpFi00A=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700004)(46966006)(7416002)(6916009)(316002)(426003)(5660300002)(16576012)(31696002)(36860700001)(47076005)(2616005)(86362001)(966005)(8676002)(70586007)(40460700003)(70206006)(4326008)(336012)(81166007)(186003)(82310400004)(8936002)(83380400001)(54906003)(2906002)(53546011)(6666004)(16526019)(356005)(26005)(508600001)(31686004)(36756003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:37:43.8324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed96ccc7-8a26-48cf-0d35-08d9e4bedc47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5381
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-25 09:06, John Fastabend wrote:
> Maxim Mikityanskiy wrote:
>> When CONFIG_SYN_COOKIES is off, bpf_tcp_check_syncookie returns
>> ENOTSUPP. It's a non-standard and deprecated code. The related function
>> bpf_tcp_gen_syncookie and most of the other functions use EOPNOTSUPP if
>> some feature is not available. This patch changes ENOTSUPP to EOPNOTSUPP
>> in bpf_tcp_check_syncookie.
>>
>> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> This came up in another thread? Or was it the same and we lost the context
> in the commit msg. Either way I don't think we should start one-off
> changing these user facing error codes. Its not the only spot we do this
> and its been this way for sometime.
> 
> Is it causing a real problem?

I'm not aware of anyone complaining about it. It's just a cleanup to use 
the proper error code, since ENOTSUPP is a non-standard one (used in 
NFS?), for example, strerror() returns "Unknown error 524" instead of 
"Operation not supported".

Source: Documentation/dev-tools/checkpatch.rst:

 > ENOTSUPP is not a standard error code and should be avoided in new
 > patches. EOPNOTSUPP should be used instead.
 >
 > See: https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/

>> ---
>>   net/core/filter.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 780e635fb52a..2c9106704821 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6814,7 +6814,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>>   
>>   	return -ENOENT;
>>   #else
>> -	return -ENOTSUPP;
>> +	return -EOPNOTSUPP;
>>   #endif
>>   }
>>   
>> -- 
>> 2.30.2
>>

