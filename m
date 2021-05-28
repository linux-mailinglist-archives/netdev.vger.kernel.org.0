Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC023942B6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhE1MmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:42:23 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3961
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230245AbhE1MmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 08:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yb1c8xtVR11/jmky4hsI1FMV3LIx13PSXqSytyyfVt13d2FKHBjRfbL3O8GJyCugBg9pqVTlFEBBS2yaVJBXLd7vIuuxx8bl0kFNS0zIj29D3HimtphMgv0nb/17zTYdB3INlzcPb5xRBYNsNbdmtIJxuwRX0HO9/yAeUVJO1gyWC1CiSicyKLmgkbU/O/jSSSAKeE1SgunHjUhXuybO5I4ppKYZ+yMJGbZu/UyIFZXNIcYdrEws/aWxbHV97U31o/rknvT63U1z/G4/WHm2QofAZdCFnuWPHlEmj2q48zSd5roy3tlrDyb2YkQeOfDJdXQZS2LVHyumF/0SzfKyVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahYcbGZerbwGRRDZMutxozmtzd3B+f4j4QOFMP9LRA8=;
 b=efb4bPlwUnVPdxAu6hNyyTqm1926xXZVjWkrIP92O6gsmZ89pvoJltV44h3DWXukC1NbFXicVISiBzNv5C7uzSPUKjYzDlfAVVs6yCEsHL6r7DZsWWkZSmR7WrCZzV3G2danSY1ovZbyhLGqOCPxofioT+f7ifnjtyHIXFJuPT4LSyT5L5aD+xEhmVBlqHsOp/16ETTg1TMkuAeb4ocvxjP5Iw1NlfDG5DIToZtFY7m1CDE+Ziglxd1jEFPJ6S/vmoGNSHxfl2MvdPrG2SXPnMlAN0IzA5uAzx2e0QgjGLjrJvmFF6fJu4VHW0X0nX4DGsi8OITLdYzS3VzJ0FxREQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahYcbGZerbwGRRDZMutxozmtzd3B+f4j4QOFMP9LRA8=;
 b=qVej5SWnKPOaDMDqQFByNBKXNSjJoQcwTuZnbFQGFInblFwbBUjHZ0aM/oRDGs4Mlj/Hr6ZqVsXXQsi/zPS9TdMjqPODHoOsWAeXlwK3QumOytH4hG/Q9UAsv6BBfJQO1V5tLQlzMmmmEVchg7XEmlmyFiMvsfBskjGiV1dKVrMFjsCrBOavlwbCPYCkQdchK6jtDQiaPRZU0N2TQ9An4PS+43o69d2yEKCNA2dJn5kkJC+DRTSAjKwFt0n2ZFRIa2vd5E/IU3itiapp/VMkIW9cC7Pyy4rLHO1r8vziRhHr0NmbAPGwn91LJi8ZF06bxjiPRw19BRd01S1KG3qkdg==
Received: from DM3PR11CA0023.namprd11.prod.outlook.com (2603:10b6:0:54::33) by
 SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.22; Fri, 28 May 2021 12:40:45 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::21) by DM3PR11CA0023.outlook.office365.com
 (2603:10b6:0:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Fri, 28 May 2021 12:40:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 12:40:45 +0000
Received: from [172.27.0.142] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 May
 2021 12:40:41 +0000
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS device
 goes down and up
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
 <20210524121220.1577321-3-maximmi@nvidia.com>
 <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <afa246d3-acfd-f3be-445c-3beace105c8f@nvidia.com>
Date:   Fri, 28 May 2021 15:40:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8564c340-c470-4bb2-77d6-08d921d5d039
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4543826FBC6B9CD54003D0B9DC229@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YaT95DCsYqaHjj0xzAcs8dS0iXhzqyGTDL0fVo6ZkXXCEfgCijuES/x1geYxJL6Tep7O1Vj57lK8azqOQuNTa0fDdUSnZxxjTF/W5mPdm8Oi1MXxw4gy43uKYdRvuomoO6tE3cphbIctKfzAnU0itAF+bRScEzatlD4e6pvEEml1DGF4MZJxqQUFsL8TyV1lzxJ4bcaArUie2HRlFKqPcKYAqANaNYtyPeQ0hVLJayryQwll9YhjqjVR3MfsMDlJplMC5rsQfPMoF6zxQQlKr76FdmYfN7XiSdmwLWpBUIaA6Okd/grWXTm/HNhH+7m2Izpl7Fg/LUKv/a4WThSqeu1QU0qlSalnCiw6ZvhGoj1sXgnIRhOQIoBx45rIoNFJ9RQ1HdzqePmU+VtUA3mT1pZ+Y4y8AYPAaJTd9yqxLQdU++EmO5k3L0QuAhPZrcAVyo2KjWZvsxo461knLxVsxDUEDa7X9Ukahroq0gjgD5id0UE2FfBOE2NEGLtyvx9dGjkH9RkfoD8QjX4trq+nYPgHyJleTCdR/2H2L3/E6YN0xHJX6rpjiQAQmP/DXxdW8avnthACg0oqNr2B+7kKe4aZh2QjebvK+AtHRcyNrwJ2zlxCZO3e79OOdUzdU36pPJW01Mk6OesstKwoIZ/hf7Kq2jFhpf0cft8XqfOVEdjZ/NlqAHGUzfFxB84CzSUd
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(6666004)(4326008)(82740400003)(356005)(7636003)(8936002)(82310400003)(83380400001)(5660300002)(2906002)(36756003)(316002)(16576012)(426003)(31696002)(36906005)(26005)(36860700001)(478600001)(54906003)(86362001)(2616005)(8676002)(16526019)(186003)(70586007)(336012)(31686004)(70206006)(53546011)(6916009)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 12:40:45.3634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8564c340-c470-4bb2-77d6-08d921d5d039
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-25 20:39, Jakub Kicinski wrote:
> On Mon, 24 May 2021 15:12:20 +0300 Maxim Mikityanskiy wrote:
>> When a netdev with active TLS offload goes down, tls_device_down is
>> called to stop the offload and tear down the TLS context. However, the
>> socket stays alive, and it still points to the TLS context, which is now
>> deallocated. If a netdev goes up, while the connection is still active,
>> and the data flow resumes after a number of TCP retransmissions, it will
>> lead to a use-after-free of the TLS context.
>>
>> This commit addresses this bug by keeping the context alive until its
>> normal destruction, and implements the necessary fallbacks, so that the
>> connection can resume in software (non-offloaded) kTLS mode.
>>
>> On the TX side tls_sw_fallback is used to encrypt all packets. The RX
>> side already has all the necessary fallbacks, because receiving
>> non-decrypted packets is supported. The thing needed on the RX side is
>> to block resync requests, which are normally produced after receiving
>> non-decrypted packets.
>>
>> The necessary synchronization is implemented for a graceful teardown:
>> first the fallbacks are deployed, then the driver resources are released
>> (it used to be possible to have a tls_dev_resync after tls_dev_del).
>>
>> A new flag called TLS_RX_DEV_DEGRADED is added to indicate the fallback
>> mode. It's used to skip the RX resync logic completely, as it becomes
>> useless, and some objects may be released (for example, resync_async,
>> which is allocated and freed by the driver).
>>
>> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
>> @@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
>>   
>>   	ctx->sw.decrypted |= is_decrypted;
>>   
>> +	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
> 
> Why not put the check in tls_device_core_ctrl_rx_resync()?
> Would be less code, right?

I see what you mean, and I considered this option, but I think my option 
has better readability and is more future-proof. By doing an early 
return, I skip all code irrelevant to the degraded mode, and even though 
changing ctx->resync_nh_reset won't have effect in the degraded mode, it 
will be easier for readers to understand that this part of code is not 
relevant. Furthermore, if someone decides to add more code to 
!is_encrypted branches in the future, there is a chance that the 
degraded mode will be missed from consideration. With the early return 
there is not problem, but if I follow your suggestion and do the check 
only under is_encrypted, a future contributor unfamiliar with this 
"degraded flow" might fail to add that check where it will be needed.

This was the reason I implemented it this way. What do you think?

>> +		if (likely(is_encrypted || is_decrypted))
>> +			return 0;
>> +
>> +		/* After tls_device_down disables the offload, the next SKB will
>> +		 * likely have initial fragments decrypted, and final ones not
>> +		 * decrypted. We need to reencrypt that single SKB.
>> +		 */
>> +		return tls_device_reencrypt(sk, skb);
>> +	}
>> +
>>   	/* Return immediately if the record is either entirely plaintext or
>>   	 * entirely ciphertext. Otherwise handle reencrypt partially decrypted
>>   	 * record.
> 
> 

