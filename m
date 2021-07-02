Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC23BA2BC
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhGBP2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 11:28:19 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:42528
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229761AbhGBP2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 11:28:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bd4Dmy9VLB4P532u1gg0Z/wYLmcrTJgSsn9DGJaze8CzV4pwSgK8euTfYJSpEqkVcPl34yZMUtxGLNMk94b9H73lycpS98qXkjhjlV9ZvoDnKECY6S0eMNmyMaXL3tz55tObct+fx2ValeW2aMOK4X+xmkxqeYyCnW+cDouLlDoCj9PCveLF2vFOLYP85xBcmGX9k9L3oyJEdh0F7XCo83f/g+dxXp9WoeJGUm7AxewHGo+5+MD4X2bleROQKvwNROtvTdGiT98nU1dC8VQYnRoEhsbNSkGWuPDdijstYLQ2jW2lrPF6pC24+hCdq/L0D5vRKCng/C0d+lSpUNFsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7DvjBKU+lzi8updN/QuQZNwqHGl0ZMYszAHWb39k4Y=;
 b=PFKiZ4PJlYvDu2X0b4iNp4rNYjEL2eUoRFA9vYRXzU3lsrIHqx311CkuaU0p3ERyP0ZFIwRDVbpnTnFnXPZNQAyNqbWo1mGNlj2S8qOVl/stRvSiVOiavXuPIIK9580UhYTrCpfqSUjWdVZGC7cLn7y9RuED5/8nPcof6DaxxUchvDJZECTt2AUfB4J4ucxR+KinvAt9uFsfK6Qh41GYAVRAU+pEC0P/xcFF7SySrt/pnJ5Eo3t+BvQHt629ZCHHv1sDCljH8YT3eIfmmkPyrDIaH69Yspj8ZHzmeQD3hdDhFbUlDEKqi2iPoQvMB8z/xhpbE45z6qki+WZjGM9jgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7DvjBKU+lzi8updN/QuQZNwqHGl0ZMYszAHWb39k4Y=;
 b=ax6YfM6KtGttdQtOSbe1gUMVrlo165DqrTg8aQIF+YyuKoJApymFk/VvADwJUNXk01R6BcqVNrlBaJlNTrMrcXIBKRzUaWOwYF2XCtEBErSssavQJzALktgH7lHdG0lOTgf2zq2HY66UUbDYPHqT7c+8jZ6xzg00krxOxcUBy+2wYwsO3fbITUTwZNTDQIuGFlVApzA5K38ZcThh6hq4XM+jsOrw+L79yg1j4/fvDjjVPoqwY0fQHy+/Q3xPGSipxpymVrFRh5KxEF9KKmaYJ8hITt9RO9LYgyYSycwTfM2B6He0jskyiLZdZ4DEv/NjkdHWNeZ059khAQxGQae5ig==
Authentication-Results: proxmox.com; dkim=none (message not signed)
 header.d=none;proxmox.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 15:25:45 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4287.030; Fri, 2 Jul 2021
 15:25:45 +0000
Subject: Re: [PATCH v3] net: bridge: sync fdb to new unicast-filtering ports
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <20210702120736.3746-1-w.bumiller@proxmox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <c0168781-19a0-724b-09a4-f08dfa05e044@nvidia.com>
Date:   Fri, 2 Jul 2021 18:25:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210702120736.3746-1-w.bumiller@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 15:25:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ef6f51-5fef-4e5a-e88d-08d93d6da91d
X-MS-TrafficTypeDiagnostic: DM8PR12MB5397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5397302FF2D4B7D8A39FE6B1DF1F9@DM8PR12MB5397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAtHVSUtJQBa82ryHLbIVDbYRKMIeWENm6mZZES4pSQU19iui7UOY3CPFsKMqHrTvwuRHhaF+9EK3YTpv2M41Ys0qsHjY23wp2pZQOANhPELhYS7nxTZ/7m3+vyDgfdpIXxsunk755oW+59fkDqMraTrqnZHmZCSVriAWk6Z4SnMJ8utG6ddFSu0iJZc3boRsib28DF3D+8OYQFuHZGcZ3amhsO8j/ylF7NgpJXl5JWsqw+VBHlK/KsDYBtdBi221ZiT/Vlb4nfYWIMB4+tq/MD5v+Li7/K71MqNrdOv1vYo5bVoJGKksBv1ltW0KopDzZzki+YV9/R+swnzbgKJX/tSy50ZfORECuWjuQh5KjLHwerF/IA1RbFkglaXRK33CYHQU7EKDZNopBFTDv73Mchx2LxWAWVmAmAkHYJ4YCU6P0pak1GFLhJh3TqEcLLJViZb0wIECReL/e4cXwd0rTj+zCJJfwUT0PAC6zAUt+xjcf4EWSdlaODBZ6T4qPf+Jf0fiCSGkLy2cOm1WjcfqyaUBEeAFHVCVCIeLLILRyOTktatstJ3/McSqQqXhrciQfRWfiakMr3uQcbQz+rkX+j669HOUjuA0kIjdESKq+6qT4Z+CdKKeJYMgN2P00iJqJlj2mVSxNtDwwrDO/Ri/t2Nuk+/IGxugHHH1+lSPwzJsE4zBRxv/ya0Pa7RbRb5Z79fHJhRHnnd6K7C4SFaSLjvFXACr1VJtTEIc9+ixg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(38100700002)(8676002)(5660300002)(31696002)(186003)(66476007)(956004)(2616005)(66556008)(54906003)(16526019)(31686004)(478600001)(26005)(6666004)(8936002)(16576012)(316002)(66946007)(86362001)(83380400001)(4326008)(36756003)(6486002)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjgzYWxoQkhaT1poQUxneUdZL2NzdkI4bU5MRlM0RWVyWG04dDBiaXNjOUIw?=
 =?utf-8?B?b3FXTVMwMXFvUWtXbEVqMU1SQTY2TCtpRDdyMFdYcmRRZ2dLQkJycTNrOVZZ?=
 =?utf-8?B?ME5raUlPNFdQbzVLMHVkZ2Mzb1hpWlV3bm5SdklpdFJIWVNxYmg1MzMwbnBV?=
 =?utf-8?B?YW1sakRYLytiUUdmSDgzV0IwMjVOZmlldENzZlZFUUFxUkE4SkpIYW9CV3pV?=
 =?utf-8?B?WGo1QlQzNlluU1JDRzZPWGdNYzFjNEpuU0xsTXA4bE5zMXlndjdtZHlxSmwx?=
 =?utf-8?B?VnVvOTRYUTBjNUdXaGVQNWFqYitDQ0R2eDZXWnp2eVlJUzV6QWowZWYrVlp1?=
 =?utf-8?B?VHkxUGJRaVRWakxGYmZsZ284M0cyVnJOVm8rNjRTT0N2eDdEbU10NjJTam1v?=
 =?utf-8?B?YVNQRm55ZSs5MTY0QzgrS0Jha2JmT3JLOFRoanh1MnFHNXVWMWRrelZoWUxa?=
 =?utf-8?B?K0drRVZhKzU2THFXRnhoMkdodEo4VTcxdU1id3A5QnJLcTNCWnRsWlZiWjV3?=
 =?utf-8?B?WDlZOTBKY1NPK2l6VWhIVDA2SzFveWNZcWpYRG9mTnpnMElDbGJrQSt4V01O?=
 =?utf-8?B?dllIRnJONTVSU05oWGk0Vnh4V1R2QzZIanF0SjBZRXg3MlBGNmNaenIzZi9t?=
 =?utf-8?B?UVhkbnNDbWcrRkY2UVhjcy9rM2VSejgvbFNucCtFRFlQVGE4Smc4K1NuVTlu?=
 =?utf-8?B?Y0lqSmlvcVFscG1IVklQb2RwanhQU0k5TlNyRm1oWnhydXNtRUE3eTUxZmd3?=
 =?utf-8?B?aEFjekRIMHVNT1lhbVR5eTVhbEVlczk1TGF4YUNERGU5a3Avam4yeVI4dlFO?=
 =?utf-8?B?K3VFRDkwVFgyY29wbzhKeEh0RkRGQnJ4ak5YcGJkdDVlRnRUdnEwRnFITGJv?=
 =?utf-8?B?Z2NBS1p1U0Z2MitMNW9Pc2dQSzc2d1JxalhyOWF4cjNRdzdlTXcwdFlVUzVu?=
 =?utf-8?B?Q2Q0c3NLWVJkVy9YSU5zTHozMzMxU2NWZWhNWkRPajRJQlVFWU5yVjF5RVBn?=
 =?utf-8?B?OWNKbkNyVW05emZUUW5BbUh6WVMwRHF4dnVYQVFCYXkxbHJRa1BidUhJU1VO?=
 =?utf-8?B?WktydlVpaVhXamJ0R1VkaFZSS21lS2Y2ZlR4VHEyVWZXYk5mZzNJdVZ4Qkdm?=
 =?utf-8?B?NDNNRENTeVRsRmxyTEtqVHJGTmdOcU00SnBKeTY1MHVsTDlHVkNVM2lHcFJF?=
 =?utf-8?B?MTltRCtLRjkyZ2ZmQ2ttRDZRay9FN2JTTmYzdzFOTkQvYkIvakpIMjJWTXhG?=
 =?utf-8?B?dURtK1ZqYU1JbGswVWF1YWEzUlNvcW5YUFJPTXZiOHBudm1rdDZyeUVhdm56?=
 =?utf-8?B?VWJ4cWZwTE5ERWxnRnJCN3hpd2hBQnVWaVprYUUvNG5lU2QwNVorWDgvNDNE?=
 =?utf-8?B?NzZENnF5WXk2cEx2Wlh5QzdLazRJdG1YT21HdDRqN2Z2dG9lZUt2SnE2a2NE?=
 =?utf-8?B?dDROUURibk83QU9pbzh1bjJadG1EVVdiMUc1dHVIZ1gvTkpKVHoxMjdVUEZt?=
 =?utf-8?B?ZzZ2WnMzK3BscGVqTmhpQ0liRVVJdUQyTVZ4Q2lIWlJJMUdRajhSKzY5cUJD?=
 =?utf-8?B?ZEVYOVVDOWo1UTUxWU5xamNtdlNNQVp2Y1E3cjl1NlRyaHlhMlk0aE5YczUw?=
 =?utf-8?B?bGhFRUZEbm5qTHBBN00rS3F0M2YzelFrMlNxWHRZRUpDL2ZoaFdzcTY2YVhW?=
 =?utf-8?B?MXNpWTZMSFhiaTJHWHVvelhkSWxBZEtCMzNTME1DcU5wVXZzMVY4Z1FMMHhX?=
 =?utf-8?Q?Muj6iwLBg8LvEZu2ttejyM0iKd6v+f2X9oGbFFQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ef6f51-5fef-4e5a-e88d-08d93d6da91d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 15:25:44.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8ybpijkvNFdicj0S8SmAM+Dns1DyF74C8U0n/8MzUSEFouurXfIRERrtTm7NZVZ0fXgOklus7Vt0+pQP3GuUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2021 15:07, Wolfgang Bumiller wrote:
> Since commit 2796d0c648c9 ("bridge: Automatically manage
> port promiscuous mode.")
> bridges with `vlan_filtering 1` and only 1 auto-port don't
> set IFF_PROMISC for unicast-filtering-capable ports.
> 
> Normally on port changes `br_manage_promisc` is called to
> update the promisc flags and unicast filters if necessary,
> but it cannot distinguish between *new* ports and ones
> losing their promisc flag, and new ports end up not
> receiving the MAC address list.
> 
> Fix this by calling `br_fdb_sync_static` in `br_add_if`
> after the port promisc flags are updated and the unicast
> filter was supposed to have been filled.
> 
> Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> ---
> Changes to v2:
>   * Added 'fdb_synced' boolean to only unsync on error if it was
>     actually synced.
>     `br_fdb_sync_static()` already unrolls changes if it encounters an
>     error in the middle, so only a successful call will trigger the
>     unsync.
>     I opted for the explicit error handling as I felt that avoiding the
>     error cleanup by moving the code down might be more easily missed in
>     future changes (I just felt safer this way), plus, it's closer to
>     the call which would normally be responsible for doing this which
>     felt more natural to me.
> 
>     I hope this is fine, otherwise I can still move it :-)
> 
>  net/bridge/br_if.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 

Looks good to me, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

