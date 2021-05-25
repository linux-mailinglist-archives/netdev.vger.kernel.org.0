Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B261438FD31
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 10:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhEYIyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 04:54:00 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:8289
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230508AbhEYIx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 04:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTPsly3aeD8SYFHlrDIFmpLLWIiSy1/LbUOdn1LgyvrTe3ZgERYRRZqhSuxrXwkLRSgCokAjfMsUe1NIIRywBB1Vj/sBE5QzZTpQgU71d4CNtAQrG10i2hgONHtAVVLSzgPZoMG9PB1qbZWA+b2DtU0uOH2fllzowfB98AH1LUERqfQv90iBK7Uw4XrFytOwf3vLlS8N5kZ8I0f8JgtKkyT43SVNIKRA3pBRPvSCMUfynptDDKb89auvjw49+o506GUlgzI0OSR/IlHV6DPDh8IbkoPHk5s09DQmdapgbtlrqvIt2/+Y0+IWqv/tHW3J1MY9mtjh806YYYQeW1mFEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UATznvdYL1wWMofyFYWzTdTQeHFcRD/veOPqQHrfVtw=;
 b=bdaSm6u+m2v7R/mYLqLwcGdlV+07PKTqAtJHLcejAGFi5CEIVyO0TSH8KZmS4WG5HWmfzYkPttG88ukEtxkVfz/130y07lHdtiZ8GzSuT4+8GKsgzB/KajmcI5an0fRMz71fR2cwA3raxaPyZFqiEyJLOOYkSvJba44K+ClG9gazdDbxPYQq/MG1RFlyR+YZNHdQ17fFd0/SY7fccapXHgI7vETgsL1M8UybtJZVCBc7bt+5B7BjhhmgDbhZSOnI/l/rAf8zoOKoGAmFnOLCgPyjBZP83x9bgoS1HUrMmz9P1eTfX19A/xW0NgdMuH9cuxZOGh8WR5r7ZOJNIEG90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UATznvdYL1wWMofyFYWzTdTQeHFcRD/veOPqQHrfVtw=;
 b=Pn9UfUTP8D+JCbc3b3KNJyr/UjrKC+SPDXkY7yEw79btg1XCw0iJyoiLzWvlqaJwLFu5h9CEpaC6GXBflbsIgk/VbQ8IT1Tui3j+tv0A59EsMgBtsrOeho6jvLdId1ovWtpAUf2/tdMm18DMKZ4iJVvAiPuT0A3qi8AvH8cLCMBjOFOj7ItMZ9kSoR+6oSmmeUQ5KAMYqHOmYzpF08dYSITEVKjzmzHEZBMXTxQYbndzFUgsqgRgwQdbyOpPBR5Kw6b1Kk/raxNYRjaNt/BI/pfcbshE/DwS3pH0J5q5Ae5uUMb5sDBSz2ZOtUTWpbDUO5L5TdWFLZHBauvq9tjhIA==
Received: from DM3PR14CA0132.namprd14.prod.outlook.com (2603:10b6:0:53::16) by
 BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 08:52:27 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::20) by DM3PR14CA0132.outlook.office365.com
 (2603:10b6:0:53::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:52:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:52:27 +0000
Received: from [172.27.14.13] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:52:23 +0000
Subject: Re: [PATCH net 1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
 <20210524121220.1577321-2-maximmi@nvidia.com>
 <20210524090529.442ec7cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <10605180-22a7-4317-4e71-68e04cb04dd8@nvidia.com>
Date:   Tue, 25 May 2021 11:52:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524090529.442ec7cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c20c006-081e-4aa3-4812-08d91f5a6c81
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5205A4B397FE51FDEFB2B6BFDC259@BL1PR12MB5205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pPowljlqjDzHhh/KNYFgCNAFdJaA5S2uw5IPVDtbkaepYmNVicZAQUAod4xRKtAzRtkIABX+FJcRbxGai6+2yEUe5UXDxkcTdqx8ziLmOki1nofpWs4LZrgEsOtvsAAvy1n7zRhmLZVykyQP4Y0UPoleAW34CEpLxovwwEXV+jXpAc5+g108uwaSlOxfX2ckpWBZbb0C93ccEXcXWUEFNQeOZeqCGViCVQKwHdUnPOjt7MkWjdAwzrIFlPtMgCa+BjSKkBmmB3o71TLlMdojWg5UQ6RJj9fQeYRbuRLuKfEkLBdEwiu21n8QIOrMtlNggtAlh5zHDuIqex07juRpnmNt+CssvlTN1hyIGIZ0cy738OraGkeMDJ1WceDNW/FfKIsPO+Sy3r8khHOf4UCdaEexAQXhbY1SzQn7mZa//3Qr4SHBYXUGCgHrMV31Yof884Mc7MoOYuw3FugIJ+x8U6+F/P6pkjwmnYZvxUWEir5J5mOGYsxEDHhBCLrvn7nNaetM0Aks0NK1N67k7bLaE17YHuKnPls9GuxlfN0pGNcm+1EPCtl4oujTe3ncfQxgXWrgl7+0Oh3Wi89X/8ToArlx12+jsU2R21BYhLzxIGNO6a5E87zrQabFZH/OlGjt7vUFWrjWEKWYGGxZQEQrmumdgXTAqTddBtLd8A4cCqgjJcxGNLeqoJIEf8e7WVo
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(46966006)(36840700001)(54906003)(186003)(31686004)(82310400003)(70586007)(16526019)(356005)(316002)(478600001)(8676002)(36906005)(2616005)(70206006)(2906002)(36860700001)(7636003)(6916009)(82740400003)(47076005)(26005)(8936002)(83380400001)(31696002)(16576012)(53546011)(426003)(5660300002)(86362001)(336012)(36756003)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:52:27.6456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c20c006-081e-4aa3-4812-08d91f5a6c81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-24 19:05, Jakub Kicinski wrote:
> On Mon, 24 May 2021 15:12:19 +0300 Maxim Mikityanskiy wrote:
>> RCU synchronization is guaranteed to finish in finite time, unlike a
>> busy loop that polls a flag. This patch is a preparation for the bugfix
>> in the next patch, where the same synchronize_net() call will also be
>> used to sync with the TX datapath.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/net/tls.h    |  1 -
>>   net/tls/tls_device.c | 10 +++-------
>>   2 files changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/net/tls.h b/include/net/tls.h
>> index 3eccb525e8f7..6531ace2a68b 100644
>> --- a/include/net/tls.h
>> +++ b/include/net/tls.h
>> @@ -193,7 +193,6 @@ struct tls_offload_context_tx {
>>   	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
>>   
>>   enum tls_context_flags {
>> -	TLS_RX_SYNC_RUNNING = 0,
>>   	/* Unlike RX where resync is driven entirely by the core in TX only
>>   	 * the driver knows when things went out of sync, so we need the flag
>>   	 * to be atomic.
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index 76a6f8c2eec4..171752cd6910 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -680,15 +680,13 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
>>   	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
>>   	struct net_device *netdev;
>>   
>> -	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
>> -		return;
>> -
>>   	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
>> +	rcu_read_lock();
>>   	netdev = READ_ONCE(tls_ctx->netdev);
>>   	if (netdev)
>>   		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
>>   						   TLS_OFFLOAD_CTX_DIR_RX);
> 
> Now this can't sleep right? No bueno.

No, it can't sleep under RCU. However, are you sure it was allowed to 
sleep before my change? I don't think so. Your commit e52972c11d6b 
("net/tls: replace the sleeping lock around RX resync with a bit lock") 
mentions that "RX resync may get called from soft IRQ", which 
essentially means that it can't sleep.

Furthermore, no implementations try to sleep in RX resync, as far as I 
see from reviewing the code. For example, nfp_net_tls_resync uses 
GFP_ATOMIC for RX resync and GFP_KERNEL for TX resync. 
mlx5_fpga_tls_resync_rx also uses GFP_ATOMIC.

So, I don't think I'm breaking anything with my change.

> 
>> -	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
>> +	rcu_read_unlock();
>>   	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
>>   }
>>   
> 

