Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1183B927B
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 15:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhGANwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 09:52:24 -0400
Received: from mail-dm6nam08on2073.outbound.protection.outlook.com ([40.107.102.73]:52641
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhGANwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 09:52:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXU7mvjTU3cEmDtP6r+u3f3n0egOjjfv6MOpad2xo+1GyaWJ+zMav1P4oxOVoI7ZtHVXab3gWUJYb2hoAR5DzYAsPQFEsDJ9RGUX1uMJU5wtnkUU3f3ZeqOG2a4XXc1CEFiElaTk9T5VFrIlmRFoReN2ahYm5jP4S7x79AlGMP1IYe47s9PzO12u53sVcIta2JSlIWgaqxwDHH7+Iq8HoL9xHyKMFhXkRVMXosoGhPylFgcmPKTa4BjLbob04OvTXW/GEXXujFNCmgAq/KxE787vkrrfxwEnGZlncjfmJzEsErCHgzlORW843ZeG498kHgtZImhvcWFA2JlUGEcT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuhyj2bELkvlA7kAEXVaxaE0yF8ig2xmkHlBfrpogbo=;
 b=PEqT0ZWpDWzJHkRDhlfi6528/nZELt3qqDhtm8LBZynv/9Lzzg6gJ/tDbz7dNrlwReN/J2zYabasDgI+wJAShLw4eUhpOREWmBJ4QIXJwlXQDK2QDeNTkP5a2D+5IizI+mW/KaedKIpNQSGj1OShigyKQipYElMYdVmOD5WhUgtSAziJ/WkQZgRkRMuStZYuXBlRa3KwPihV1nqNvo7TsP22xygsOYUtwM2k7ggfCgJidJhecaMBGhbBX/bFSkZePVaX7rb0t+CpMrZL9EIPdObC8jsNfFABVzH1apG9hAmVcbUhKzRmIU5DM8jJK5ygfWu4ZlKRqjFXF1iSMlEfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuhyj2bELkvlA7kAEXVaxaE0yF8ig2xmkHlBfrpogbo=;
 b=SgcjFv2C143mAJPaQ1x4g1Ya1X1fYCGDfrNDhLS320AXf0gnUNdb97qN5hNLD9EBWN0/hRXvXqwAk6h7nOYUlB65a8YkL2QkYGk5B5pGEmNfOLatpFsmE1IUcCHnEJHgbJy2iC6tMTwXrVPaMQ4PgfRhqZ/Y5vWA2ErJ8jmJYzUolh/Us8YMvOuVLKpeKz7loxLqgpQHjRhtU6SRm9WSwYRYoEyMcwZuqB+58yJTyZGZn7PocV1e67/VP+VGI+br44Q27/tKbFDkIPapb2r1Wdym3xdtSGmcozkMCUXQdIUO7l/nXZmJTMB/bQ2f3xKWOIu0YSe+TyVQoSe+QhsKYw==
Authentication-Results: proxmox.com; dkim=none (message not signed)
 header.d=none;proxmox.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 13:49:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3%3]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 13:49:51 +0000
Subject: Re: [PATCH 1/1] net: bridge: sync fdb to new unicast-filtering ports
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <20210701122830.2652-1-w.bumiller@proxmox.com>
 <20210701122830.2652-2-w.bumiller@proxmox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <39385134-e499-2444-aa0d-48b0315e1002@nvidia.com>
Date:   Thu, 1 Jul 2021 16:49:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210701122830.2652-2-w.bumiller@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 13:49:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae4177b-6ae5-4731-74bf-08d93c971989
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB554942D947E9B058A6D0A00FDF009@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 877nlGhVt7xqrTiivQR6+71KvUote20wshyRi17XQIh5Uzj+jEYD7epIxD8uauIOxlMaEfr+INpV4SKgYKPOOT13D27HxLhk2MRw4JklwGZVt1WxqAzKNWpZoOL7zM7tQCNGJMSRy3wBsDcZoNroYhcFo0HP/nkygS93YrVbXRVKx8uKYMlaLrPuvXmVLHtbA7qQhcjhr+bylo0Y8bnqP+sl+COGp7fCl7ZApPttVPtWapCyudqyXUotZku/kUIETyJyMoQJ1Zf/dlzW1ZdiAT5SLJRcpxkZdmR1ykm7MLsJvdPrqquHrOKL4V2GKlrOouAuBlB8bum9mWClH4LeGnmtRxCsf6N6O5oNbpQbRFmLpI1PZv+Vt4ryaHYq4L1o9QaABnlUuuajv6bbLtDjaZEU0qeaXJ7oUtP6EEpi9mh4u6O//Fi9RblaHzJbqQVBCzbNJIaOYk8ttE/tfZG4nNzcvojgdVLavZ0TJoeIWi7y1IR72euOmrENzEgYqKQopVzVnHU50xSgv1P4dcbhcnfIGwqQ8mxdL/emnjGeXfJzcUnfH6CcAVJfINmJybsW3HaQHG6y7y/m1JNhOcDGplmdpHVBsQcm9j55zRrx4m3V1kTUbSObCQIJZ+n4Y6nWJvDThJkTjOZgkQL5bOkqNBdn2DQFW0xO89RSl50M179bYVsY08XO9i7f1A123gk3ZL+LElTcP7J+femEyixtc2LdrZd1Y9//Q5OUmeRz/L8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(8676002)(31696002)(66556008)(53546011)(54906003)(6486002)(66946007)(66476007)(2906002)(6666004)(31686004)(186003)(36756003)(38100700002)(86362001)(8936002)(478600001)(4326008)(316002)(16526019)(5660300002)(2616005)(83380400001)(16576012)(26005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzNndTFNdEo1YlBGdUZHbVppaEQzeFBmaHhiMWdNSjhMNEVoeG4wb2x4aFR3?=
 =?utf-8?B?VFhZcVdwVlF0TmFjY09OV3kwUzZJM3VzdGZoWHRSTDU0cEx0czk3bTlYNml3?=
 =?utf-8?B?WGFjUldRRGhuMTh5bmF0QnQzMTllbS9Sa1lEdHd4MDRCenZYcUM3aVFwYVlP?=
 =?utf-8?B?SDk5SVl6aWQ3OU85LzdaRTdKc3FDWFZLbmo5blg2QzNIVTErVzJBNnArYXJJ?=
 =?utf-8?B?UWRiL1RsNzJ1Q0hXMmwzR3ZGTnFPV2R0eDVkU2NBM2xtM1Jid3AyZmd0QldV?=
 =?utf-8?B?VUNxSEJJalhyT0pvR2MrZlhyWUk0VW5uaytXaTlTdExtVlpiMlJRanlzcGc5?=
 =?utf-8?B?U3dhWTJncVhXYTVldjFTSzZnaEtYZW9XUmtWU0RReWNOWCtpQ0g5Yzk2NUFz?=
 =?utf-8?B?dGw3ZkgxVEdSTUlLUzlRY291L3lKMitTVXNIK3VoZGZHM3NqakVzaWtHR2dj?=
 =?utf-8?B?YnZ2aDAvZU9kTkE4RDFtZHN2eUFhUzVrTW5ZeFIzN2g5YjhGeEhXaG9pNUMw?=
 =?utf-8?B?VkNHTXJDT2krMWRobHRiemxPQmRsMmtabFJJZFphNHdGMjM1YTk0cDhJRGdD?=
 =?utf-8?B?amhnb2R1MlZjclNHVTROWmtBNEhLeGxITTI4bzdxNXpmT2tOM3JtT2hXRlVn?=
 =?utf-8?B?aS9xSDVsSDJEbCtqTnIzWi9RY1oyTnVPQ0ZuSHlOUmJvWVlXZEhIMmI0ZzVR?=
 =?utf-8?B?c0RWYks3ajN1RUdqSDcrbDRXc1pyeXNhMEgrTjNrcFd1dmljekx6V2g5cWFB?=
 =?utf-8?B?T2VrRzQxaWlFRzVwbW1iM0dDREpvUjF2czRFZENxNHNTYzkwY1dLcmlvb3k0?=
 =?utf-8?B?VldPUVRnWWc1QXV5V3hOa25oZVFmblZyYmRGMUVJeFV3UWVrckJGZ0srb0Fs?=
 =?utf-8?B?RjFLek5VWC9VbTM0c1lTc0RRN09OdmxVQXZsdDRFM21xOS8vdHg1eGtlY3dC?=
 =?utf-8?B?SVdTakZhWFllTmJzN2xkeU1PUzFBOSswbUZCa2JIRlVOWTBZaWdCZCtHamtv?=
 =?utf-8?B?bTVOSlRnWWVFNGFnck9YOWx5N3RRRlAwZHorUUhld0pBV0RCeXFLdkNRZ2U0?=
 =?utf-8?B?b09oVzNEWVlpbUQ2RVJnK0lRVVg1cVNlN0xuS1IrTDltTHMrbDRDaGl5bmlx?=
 =?utf-8?B?dmpQNmo3R3pVWFNYMm93S2hKeE04dWphaEdESGN0ZVJmNDZEUlR1MTZIKzl4?=
 =?utf-8?B?N2FjeWtjYzN4a0VPemNoa0FXdTYvZEhxamJGNVBKdG5oVUZlQStJcnlCL0h4?=
 =?utf-8?B?ZTRjbmFQRlhPbkU1RjZ0QWxyeUc1aEhLd3NadFZ4UHJVZTRSaE1mNUdjQlBL?=
 =?utf-8?B?U08wNkZYSU9vNXZ2NTBFNWc1Q1Z0K21Yam9ZYldGYmFtVHZaWC9NU2xHVU5i?=
 =?utf-8?B?UG1QRWIyeUVxY21UUUVxbjE0bFUrTUl5Sm1vWElsSy82ZmNEbDZQaU03czQ3?=
 =?utf-8?B?SThPM2cycEdOcG9TWWtyb29GeWNldnp0VzByTE9Jd3o4YU5xVUk4cnBjVmpY?=
 =?utf-8?B?VVFuVjVZdWx0QkpkNnNBUTBFd0lPUzVnZk1yZ0REczU0MmluSzhDZjJJaXhx?=
 =?utf-8?B?Y3RGR1hhS1BuTVhnUlpUOHBoWm5xRW8wdHBRNTl6SWJyYTlJWFRNbVM4VEhR?=
 =?utf-8?B?NGE5cGxxWDQyT2ZQSy94dDJsNzhaaUJBMGVta3p6SjVibzlVTFAyMDhhVnE1?=
 =?utf-8?B?TisxbjliZSs1ZDFuWmxFWGFZVnNITzFCN3RNOVFuWDVIa1FXdGQzT0JzQjRW?=
 =?utf-8?Q?5ZJZHorSNOBsqIIO4CS+F7Wup4ARdbu6J6XXvh+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae4177b-6ae5-4731-74bf-08d93c971989
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 13:49:51.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: an53DrF6DXN80bDAuKkXEUGNjcqMwObvoW6qx0HzgGhcS8GUllbM9mtwUSvrm4t94SwXrZlsrxT14pI3EdtStg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2021 15:28, Wolfgang Bumiller wrote:
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
> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> ---
>  net/bridge/br_if.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f7d2f472ae24..183e72e7b65e 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	list_add_rcu(&p->list, &br->port_list);
>  
>  	nbp_update_port_count(br);
> +	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
> +		/* When updating the port count we also update all ports'
> +		 * promiscuous mode.
> +		 * A port leaving promiscuous mode normally gets the bridge's
> +		 * fdb synced to the unicast filter (if supported), however,
> +		 * `br_port_clear_promisc` does not distinguish between
> +		 * non-promiscuous ports and *new* ports, so we need to
> +		 * sync explicitly here.
> +		 */
> +		if (br_fdb_sync_static(br, p))
> +			netdev_err(dev, "failed to sync bridge addresses to this port\n");
> +	}
>  
>  	netdev_update_features(br->dev);
>  
> 

Hi,
The patch is wrong because br_add_if() can fail after you sync these entries and
then nothing will unsync them. Out of curiousity what's the use case of a bridge with a
single port only ? Because, as you've also noted, this will be an issue only if there is
a single port and sounds like a corner case, maybe there's a better way to handle it.

To be honest this promisc management has caused us headaches with scale setups with thousands
of permanent and static entries where we don't need to sync uc lists, we've actually thought
about flags to disable this altogether.

Thanks,
 Nik

