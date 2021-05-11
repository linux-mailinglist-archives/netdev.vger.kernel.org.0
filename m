Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD437A346
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhEKJSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:18:15 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:8289
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230427AbhEKJSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:18:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwyuTLeprwBVzPbhqaeZrTyU6A5TutN+eWJXUhfDcegGZKli/i5t1eaPM3J9tSDzXAskBbbLZ7GJ7Huj0ybf8hyE5Ww2eyVaAXqxL+uxpUj2CD5i9oTpP5VJ7INywLV00Fqj6bSvDuGAB3m+SpoWobnZifdTOqW0p44TwMY1tV9fQx1K5UoxDTRhVYQcLaXxi9hUUqLqR5jovZ+oJqbHMr6waFgmYHINWObMvS443eVqrn4XbOSzJrAx6yta5xbxZDLFCiodb7KTQ5tDkaaCZLnxCHVlWdzh4b2VcDVUawTQ99ln8jvy1wwc1+y8+/mwc5GOWfqtITfZwPCJyUkjIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+/piBf48LlschlvzBayvAuu29lowlVonGdHNovQ5Jw=;
 b=OGNE59J6e/odCyDx7B+6wfSJJXaXdOIojxmedpdISq7YfbitOHhknlSX2lhz5DTiZ2iGYzzKinjn5GD/1KuGJh+cP2fZ7syht+3ip+PzPtUFPj92RP3YUA3Q6lg9UADonGQVSrb9Mmd78dfR6TRYTjUSb3X7JZXB+a/4crIReMFbgbfPBshxPb8XZxikzD/WIiYUyPc+BnSH/n2QmZdOpGnEi72pU8VWPIYUhesj55GM3T66l7aJsg8yrcljAKTRzcvFiByl7M8aP9nKI1uH92wz96iYH1TubhONaK7RuweeUKpMA30ABDSUkZ1SFp2j9osS9ITWJDVpLzuUz341cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+/piBf48LlschlvzBayvAuu29lowlVonGdHNovQ5Jw=;
 b=iphiAwbP8srCqKteY6esNAUUhFwFKu/VTdpIRjNauBCZkaxBoYneDZpeoLYtMerJXN1659lL6XkUhwKXit+8Bs2a61XPOjHDg4E6aRiy003TXixxwe5l4a17k7qZcIRHNQM4Pd2pXaOtAyZTX3Sb0Thce4A2HMdK7MZyd+TpEgeIxDsdq+f+6lF2wK7CfD+gVFDEmgihY1AqMwubxPJAASBsbSwQJSVTaub1nYzxsuu4FrfZiXc0LN71krmSQg1y8tBg2E3MDsV9nlJ3aKSmENH9DOD5QJzr0bFHHU2ZfLRBtFo4qHOkeTnrvs3p9zhPcgmGs5vect84FW2SbE3j+Q==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5326.namprd12.prod.outlook.com (2603:10b6:5:39f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 09:17:06 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:17:06 +0000
Subject: Re: [net-next v2 06/11] net: bridge: mcast: prepare expiry functions
 for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-7-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <0998c872-f18e-19a0-d137-9144dcb7b18d@nvidia.com>
Date:   Tue, 11 May 2021 12:16:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-7-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0112.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0112.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:17:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ae5742d-99ff-4415-b43e-08d9145d8c21
X-MS-TrafficTypeDiagnostic: DM4PR12MB5326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5326D1AB7F74C7F89A5F6721DF539@DM4PR12MB5326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVocSyJFN1r3D6KvnPLBI1deWX7/7Gsu5k9ewj/U1vvm+K6Pgbi2Wk1roIlcNEW8kVa3ZmPAB7YQ1kEZBnw1Yn+gU2diBKPReBSGj0SzErMEjOXE+5KrF4AOxixknxVd1TQPWclNstSo/KhVDB5Aaj+/8/B5wg5MxrRAZk/XZLOuA8jLPoXNdcnQ3PrbS5Tx3c3Xz426oIGnOG0obG8trxSAQXuBx+B3czWv69KzZlc86RzX4QTmolKE0nrfiDjgF5gkFYNcVhvewTK725YfHj8xs+O4WEnYqDnOLk2RZ7Kp0vbWTClXJmfcTEvVl7SWXoaP2uTj2IiF/MqvMmN42hiwIRclz05KAwZVBWldRhGX/dW97SCJgwD7X92Su5WHty8aZzlOngyieNY5wvAj1hbc6fy6bKPu7P1d/0mW8t+hSRjUCLsi6qYkJc9xzIAhY/ekN7mCiDtwTQ6Nk5eXiXoBoZjEqDHPOVcigsDPF2lQiBZMeSjq1hqWSFS0X23ETDHp8S/3jott5AYauXZ5o+OrJPW6aCQkPA7kUgS9A1tkVdoBWP+UQTSBFneS5/w+4pQrO50/ZbrUOOmfum0GbxxzAoT0oDpB1lAQiJ/fwSrvPbLklk9BJZQmb8TaCIeiQB+FPTaGc5d0bcvxsgwxX3xmQgiCw5nUyLZCTtATIE7dstR7CozwxGtPxAF21UwH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(6486002)(8676002)(54906003)(478600001)(316002)(16576012)(16526019)(186003)(956004)(2616005)(2906002)(4326008)(5660300002)(31686004)(53546011)(26005)(8936002)(38100700002)(66574015)(36756003)(31696002)(86362001)(6666004)(66556008)(66946007)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R3BZSXVkK05WUmZ0T253elJjZXdxNklGc3dZdDNSU25vbC9SUkdVSXdjYkdm?=
 =?utf-8?B?R2dQL05qc0tmMkVYejVvSnNaYUdBRjIyTGI4VmxkTTNKV2Z6WGkwOWh2WHR4?=
 =?utf-8?B?anc0Q2E2aElGbUhMaHVhM3pjODM2bXVSd0FxdG42WXo2ZlovZVBhdlFYZyt1?=
 =?utf-8?B?TWNKQTdvQ3pXdS9GUmNmY3h1aGxPcUNMUDJZNnNQTjZ3UzlVclZMWWtqQmF5?=
 =?utf-8?B?Qk01ZTdXNHYrMy9hNEFyT0N0YnFxelZPU0FkWWh3eDdtSGEvdU8vQXBrSFlU?=
 =?utf-8?B?RTR0Z3FDVUp5bURybUlYWlU1Y1BZbVpDZ0ZoRWFBRGd2WFBMK3lvMDFjL1VU?=
 =?utf-8?B?b3YyZ1Z2bVVUQ3NTOFVJTHNicmV5ZFFYa0k4NmlPdFVQWDNEYWVkeGJFVmRC?=
 =?utf-8?B?UWR5RWN2UWRicnV6eEZWdkRFdVVIWXVVSVBXRVdiM0JBejl1UCsrVHVadTNJ?=
 =?utf-8?B?U3phVTUxdi9TVlNmMWFUMHNVdHYvdXIwajBYZVBydEdzd0x1SVUxL1h1dVo1?=
 =?utf-8?B?NVhUVmFneFJnUDRjY1JRbmZRUFhrQ0x6SHBBWC9yVEpGa0d4VkxOc3p6c0Iw?=
 =?utf-8?B?NkRkMzR2ck9XcGZIU0hwYjBuelgzdlN0QkFKMXVkc3czUUpLajJaaVUrbUdS?=
 =?utf-8?B?Tno1SzR6UmFEMml0aVdjbHBhSDVPelVZbjBOd3J4NmJwdXkxdjBGLzQ4OHhR?=
 =?utf-8?B?K0RlT3c0L0dCV2hqSi9sU0hFZ2VZbnlSdG0yMHZDRG1vclhTL1UyVnZoZ0s3?=
 =?utf-8?B?WFJUNm0wb3RkTnEwcnpGdU5TdUtpZmhidC9DS1JvQWtINklLM1JldThua3JQ?=
 =?utf-8?B?U2FBeXFkeExua05VZkpCNXYrby9uY2dRUUN2N0ZqTnd6d09LSkloZ1hDVFQ5?=
 =?utf-8?B?T0F0YnlxTDg1RTRiWGZaUEJJRGJzMlcyanZXODFKVDlzZnJ4Mnh6M2tTekgy?=
 =?utf-8?B?WmdyblFpZlFnem9NSFA4MUZ3WUlCcUhnYmFOaTY3MU5mWm1wdkhHcmsyNHJy?=
 =?utf-8?B?Wmp1L2FYQWdZUzkzWFcxbVNiQWR3cy9na2lwNU03eWp4Ykhnbk5IL1FBUTJO?=
 =?utf-8?B?NXdaVjFpTk01cUFPV01aaWVDVkJiSnF2UXRYK1FKWTJSUFdhRnloQ1IyRjBh?=
 =?utf-8?B?amV5K0FnZHlFTWk4ckZld2NJNnBOb0pRYWZtSk9wNnRTVmk0RFYzanJuQnBh?=
 =?utf-8?B?bWxBemlTTmo3UU52cUZwRDdzcXR0bFZPcmNWcnJpeDMwZ3JZeVg2Z2pjWUJV?=
 =?utf-8?B?eDhtOVdOVmFmRXdVbHpjdStFVFFOcHY1R0xOdnlXUDNoeWFkNmQwTHFjVitj?=
 =?utf-8?B?dFJWVStLLzFrRnRvS1hqVEg1Uzgya3NFSndxVnJjTXNjcExNVTROY3lxaTAv?=
 =?utf-8?B?Sm16Q2lpRlAxejVvS29oSVVqZWRraWlWbG11WkdXUStvNUtuV3o5bVJyUTZB?=
 =?utf-8?B?cFltSXEwTDJJMEdmMFdGLzNrWVBpUUI0dk0zL2wyYW5HRDZnQ3RwclVMVmhp?=
 =?utf-8?B?Y0NxcGgvYVI4MmFoKzNMM2dmQzEvUm9sRURDMXdMNEM1Z0dIdGJDVjBLMmgw?=
 =?utf-8?B?bXdRZnJseC85U0RYVkR1ZTkvVDJla29CNVdWSzIrNmZ5dm9jUWlIVWV4Q0dq?=
 =?utf-8?B?M1pCV0cxejgxSjR2bWtJUVlZNjNHeXNvd0tqM2VoUUlmdGp3WFlkNjluckEx?=
 =?utf-8?B?Z1lyN2RQRE92MWZVUXdNZS94ZE42b3pzUWpHUlJod25TcDNvb3kyQzh5V1Fo?=
 =?utf-8?Q?S5JOpBZe7reHWpYS80wXa6hTApsJzJrxq6vP4b2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae5742d-99ff-4415-b43e-08d9145d8c21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:17:06.8185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PAq6Fc5izAhbHWwtN/nQdoHq/Fp0VtJDS/bPP2s9gjMdUsaMmaWMPFKCdzM5gUdARVc5h30oibnwTXskW/0Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants move the protocol specific timer access to
> an ip4 wrapper function.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 048b5b9..6c844b2 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1354,16 +1354,16 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
>  }
>  #endif
>  
> -static void br_multicast_router_expired(struct timer_list *t)
> +static void br_multicast_router_expired(struct net_bridge_port *port,
> +					struct timer_list *t,
> +					struct hlist_node *rlist)
>  {
> -	struct net_bridge_port *port =
> -			from_timer(port, t, ip4_mc_router_timer);
>  	struct net_bridge *br = port->br;
>  
>  	spin_lock(&br->multicast_lock);
>  	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
>  	    port->multicast_router == MDB_RTR_TYPE_PERM ||
> -	    timer_pending(&port->ip4_mc_router_timer))
> +	    timer_pending(t))
>  		goto out;
>  
>  	__del_port_router(port);
> @@ -1371,6 +1371,13 @@ out:
>  	spin_unlock(&br->multicast_lock);
>  }
>  
> +static void br_ip4_multicast_router_expired(struct timer_list *t)
> +{
> +	struct net_bridge_port *port = from_timer(port, t, ip4_mc_router_timer);
> +
> +	br_multicast_router_expired(port, t, &port->ip4_rlist);
> +}
> +
>  static void br_mc_router_state_change(struct net_bridge *p,
>  				      bool is_mc_router)
>  {
> @@ -1384,10 +1391,9 @@ static void br_mc_router_state_change(struct net_bridge *p,
>  	switchdev_port_attr_set(p->dev, &attr, NULL);
>  }
>  
> -static void br_multicast_local_router_expired(struct timer_list *t)
> +static void br_multicast_local_router_expired(struct net_bridge *br,
> +					      struct timer_list *timer)
>  {
> -	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
> -
>  	spin_lock(&br->multicast_lock);
>  	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
>  	    br->multicast_router == MDB_RTR_TYPE_PERM ||
> @@ -1400,6 +1406,13 @@ out:
>  	spin_unlock(&br->multicast_lock);
>  }
>  
> +static inline void br_ip4_multicast_local_router_expired(struct timer_list *t)
> +{
> +	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
> +
> +	br_multicast_local_router_expired(br, t);
> +}
> +

Same comment about inlines in .c files, please move them to br_private.h or drop the inline

>  static void br_multicast_querier_expired(struct net_bridge *br,
>  					 struct bridge_mcast_own_query *query)
>  {
> @@ -1615,7 +1628,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
>  	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
>  
>  	timer_setup(&port->ip4_mc_router_timer,
> -		    br_multicast_router_expired, 0);
> +		    br_ip4_multicast_router_expired, 0);
>  	timer_setup(&port->ip4_own_query.timer,
>  		    br_ip4_multicast_port_query_expired, 0);
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -3319,7 +3332,7 @@ void br_multicast_init(struct net_bridge *br)
>  
>  	spin_lock_init(&br->multicast_lock);
>  	timer_setup(&br->ip4_mc_router_timer,
> -		    br_multicast_local_router_expired, 0);
> +		    br_ip4_multicast_local_router_expired, 0);
>  	timer_setup(&br->ip4_other_query.timer,
>  		    br_ip4_multicast_querier_expired, 0);
>  	timer_setup(&br->ip4_own_query.timer,
> 

