Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D751EBA79
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFBLdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:33:01 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:48577
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgFBLcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3+5lujEl6elIUBPpMbEEKhOwqyxM9xKeF6G/y3+XEnUVZZVjS7nRB3Poh/kDLkEjcOfjB0CeRVg4q5wejBiR8V+N++Kqui9ZkSMNm3Up6bwSMZXjm0pQReFhBM9Kv2igrf10kCJev2GnC0dSyvAu+r2vxAgh9798935KqDpINPoL+Cg4p1eHv4j10eZUpiQPKhQXRoG4ZYUx+xlpDsVmZhnfUzkSj+vUXcuimDcAH9Z5DIEkKDIWxJWQlm4yM3vdmXPRz9NXeeml4hTnHSjGlCI1sjXeJYXFL3cMSMmGBVeJCmg4ZMby5oyhT6vDK8tcJIwdVeuysW7Avm49y/srw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ta4aVBd74aQmPcD9pKcRrMJlCbGT3vSUyFdQ+m+j0B4=;
 b=CXSgRMbROkVD1UdGY2sMqG/ZPSWnxKl4OcP2MRm+pTW1wIBs5XeuFb862GXFFK8Y3ZlQyOSX1+smVIZiwlxEh0bpCoA1mjz2wF5nEAvGSvDz+dKgcsa1Aj3ZqIxyoep0lRdUdPfscn/i9tI2pO/sC0y9BtiC8VWoIuid2i43QEh+MWuLdhdzKP1wmDNYGkq7L4IbPgV0DNOC9Y71C3n84Bn71bk8E+tNgCBIFTuO/XyR1oPKBpk/aOpjiwHL4glTiNczdiydn0aGVPcvJEvUkxa7cLxIlAS5qnQEeO4mJpQ9br7mvp18ytjwiNueOpkMvu50WVZawneZq46vNRqTeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ta4aVBd74aQmPcD9pKcRrMJlCbGT3vSUyFdQ+m+j0B4=;
 b=ME5PphvC6YG4y/FQDxL430LRvawJ3MylYJGadLPSFD3cLeU1ojWEk5qE8td15H6s2WUC4H3SIIYWsTVn+YVcHUVr5nKwqNM7t5xHew3WklWrMBYvuCHfMVv0or2Q27HgBK1NtY4QxulMlAicvTrrM0A7VOOsszqDn2o48ve21vQ=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2815.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Tue, 2 Jun
 2020 11:32:52 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:32:51 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
 <20200529194641.243989-11-saeedm@mellanox.com>
 <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
 <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
 <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <4f07f3e0-8179-e70a-71a5-9f0407b709d6@mellanox.com>
Date:   Tue, 2 Jun 2020 14:32:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0097.eurprd05.prod.outlook.com
 (2603:10a6:207:1::23) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.6.235) by AM3PR05CA0097.eurprd05.prod.outlook.com (2603:10a6:207:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Tue, 2 Jun 2020 11:32:50 +0000
X-Originating-IP: [77.125.6.235]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 57c6e532-ca09-4d0e-efbc-08d806e8af3b
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2815B82598AEB7344E4D7687AE8B0@VI1PR0501MB2815.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCE8VfLYtZZOwpVd6yIqcc2g32XZs4oHY6oR/bAjUpL94/jRUhikpDI16kEjiduJL+4Bjh5A0MISLs0ARDMN5uCuRyvEGMwi1OUjpGKqtfCH/ZwCJsUsZopOspYqZgUT4/5XkfEP9wXfQLd8i8OpOXq93OqBsOmdhblma0OY9TswzoQl0/n+oL4InwVjElHdqXmsRzaEfnQif5ljZxAfOvd0MCpt6qSqBHOD9QeWC9ywdv9jtlJ/7h7Q+brFIDD46Q/4YkT18pWnrPUM0XYCP+gcbtH8VYZkDPBG5wZ0Pl3aDX5jOdJUdgi8k9nDAlXUZNLO6WRSMLI7SkiXlS+RJILVSZsyvJ/ySecV4MwmVO74RY9Ndtek6y4iSnX9/Yw6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(2906002)(186003)(16526019)(53546011)(316002)(8676002)(956004)(26005)(54906003)(8936002)(2616005)(478600001)(110136005)(31696002)(86362001)(16576012)(107886003)(6486002)(83380400001)(66476007)(52116002)(4326008)(31686004)(66556008)(36756003)(6666004)(66946007)(5660300002)(6636002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JUaNbfSMyd0KTlQc66Sx1EABcH9aDi+xtoCTyIlb1X0khw9jLn1nfPaPEUTwvWsty88XfIuhga/2AbjXnJPZIAj2DgxMDQTBAOYZxLfSQ60alfRL3cpxBf6klDeYp6GASeLdOkFyB97E8Pm7demZOrZbHEHNa63Z6b1t0l5ePta8r3girPXOUBcepNvIEDpNAW+MxtoQgOLvfa+5khPo8UHMv/JMQuIrnzd+P4uPc9lqu9f5YxZclO3pC+8kiSLS25xtg/6SzsoIBSr9Keou0hUvus1QBLMfVYCEpnosXf/rPB7U6cIQjVwY1SmRLBf+TtiA5VtZoKl0Tavko4bCgOS/G5qoLhxY10luS3wv61sA8SmV+81FHNkOHugO2dRqY96wPYgcNw7BBfNWgfjJqPbdU3xoSJ6AYI4wdTgnkPwmAELV4ZJR9E76xcmT5y71cNEh/DYltJvvczX4UxVCeGAOoWazwF4oer3fh8qjsqA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c6e532-ca09-4d0e-efbc-08d806e8af3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:32:51.7714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHz+UrfVsWIiQ5Wz8OHhJYv6cOvB02qrNeamDwF8RBubpGQTzoMTtfier4PACg4fE2Dn4cOddMCa5yCpwogD7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 1:12 AM, Jakub Kicinski wrote:
>>>> This is a rare corner case anyway, where more than 1k tcp
>>>> connections sharing the same RX ring will request resync at the
>>>> same exact moment.
>>>
>>> IDK about that. Certain applications are architected for max
>>> capacity, not efficiency under steady load. So it matters a lot how
>>> the system behaves under stress. What if this is the chain of
>>> events:
>>>
>>> overload -> drops -> TLS steams go out of sync -> all try to resync
>>>   
>>
>> I agree that this is not that rare, and it may be improved both in
>> future patches and hardware. Do you think it is critical to improve
>> it now, and not in a follow-up series?
> 
> It's not a blocker for me, although if this makes it into 5.8 there
> will not be a chance to improve before net-next closes, so depends if
> you want to risk it and support the code as is...
> 

Hi Jakub,
Thanks for your comments.

This is just the beginning of this driver's offload support. I will 
continue working on enhancements and improvements in next kernels.
We have several enhancements in plans.

For now, if no real blockers, I think it's in a good shape to start with 
and make it to the kernel.

IMHO, this specific issue of better handling the resync failure in 
driver can be addressed in stages:

1. As a fix: stop asking the stack for resync re-calls. If a resync 
attempt fails, terminate any resync attempts for the specific connection.
If there's room for a re-spin I can provide today. Otherwise it is a 
simple fix that can be addressed in the early rc's in -net.
What do you think?

2. Recover: this is an enhancement to be done in future kernels, where 
the driver internally and independently recovers from failed attempts 
and makes sure the are processed when there's enough room on the SQ 
again. Without the stack being engaged.

Thanks,
Tariq
