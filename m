Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98242343E2E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCVKnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:43:35 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:30971
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhCVKnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:43:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDLTprA9271A9kQSU7vaHw5VJ5y4lBFavSZtFO0Sl3MSSqXHJffOCXwLAarTovqsqcKtkVzdCipwM5e+sLufPQtnSIWHVV62XirTYHflHWDXJI7i6np6MMTFnV1ZeMKzrPTe0sJviAcaODaRSN2KNPKyw0ojM93UY/44LI0R/06l31rOouABNp8BW7b+/yKnY0hy7yn5SiCHW4sa6RrhiUpynePCOHqCshRUL1wl1ndNT9/NibbDAn7UYnkDq+28NnKhe/TKbm2kUUjIPfyZveOvdO4tvV7Z6hdbq2gc2OhOVgtD+YSECTzW/PDjRerzamkn6iWDyYDpsNRmiLEOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAFzOMVrF2wvf3inMqrD+yAJUDCzhxrmIzCUQE61NaQ=;
 b=PrDMbBJqLcgx/jTCV0SEIVR1iXRs83LWBrDOJlx+3tsev9TBX2Er+nS7Ta4+6PGWKPD69ieS191dvmSS2lV8U1hcx+JFx8/Sk2IM4+VvgsryooPu6jBBVuLr2YlVvDOiVObjld55I4bCyfnLRudR+TkfcxWmnc0BRyBdwgsZk5QqdxqUNYp4HhKNLp7CVjafPOZ1w5vqKNx17fVC8pwlvLwMKLHzG/ZXrrFgdURXsd5b20O+zFda+FvZTy0/VyFNslQJT3BsamxJj1iqUL6TlJZyJOGLznfel0vorb+AoYt44kXaToKzm0o1H2MakK1c0LC11APsz38yx5LnDjLg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAFzOMVrF2wvf3inMqrD+yAJUDCzhxrmIzCUQE61NaQ=;
 b=IQZqbuP3iydg+4pr949nFGLB9YP4KCFUPKMM+GmB/0vQP+ljQovNsYdglajlB3dR6lKM1nezhWB6EXvRrM8uh2kZ8aU5HGLFRD/gH3UOlIA9NmBdbbL0X3ZZrsc5fiNlJjlL2ewwf6iXY0oAjycUWl3RlVuKJLYAIWzOGSVf/GiBnapnYByfkXrc4+/4RAreu3Unnxk3Ayn3yfEQzfkSNi/bIUdMsUGYQZUNC2aSFf6aV1WLh8Nq4I8xTV1BS1X+RVLY3f5BgFOb6svY2J0JNRujy6yfne4/HD7CwtIc0oj7tq4RVIIm9/foUbNv9BI864x+Kv4agFUgIIcRIwYSGA==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3817.namprd12.prod.outlook.com (2603:10b6:5:1c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 10:43:02 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 10:43:02 +0000
Subject: Re: [PATCH net-next] net: bridge: declare br_vlan_tunnel_lookup
 argument tunnel_id as __be64
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210322103819.3723179-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4cf00a0a-c97e-2bd5-5091-3acca0733655@nvidia.com>
Date:   Mon, 22 Mar 2021 12:42:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322103819.3723179-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 10:43:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64f8f517-5815-419e-50ea-08d8ed1f448e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3817:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB38176D9A80612A75EDF3D40FDF659@DM6PR12MB3817.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gSPspeVq9VopPmIqDxPkjcaU58euI7JtAp9sT4zLGR4shGUrX4WsRVW05xAppR+eHfFbe1kjtRN5XPPJAGnve/I7i7Vow/pGzTbQqLPCQmpIIayZc1fmwqZK6RwAHi1HYSVkT3BTKmey1rrviO4i1y5IvToAecZZTWTOr6Vc5gTtny8yZvMlShjbyNExqBAT3ER2e4Vb8Zw2y2d7Hep8bWCtbptCIsRgCzCRUL6zSjWQ2CFFlfc/OQLumgTCCjBCW5w7wyukQTw0rxY8DOmwLpMIO+swAKJBcQVpgdL5P4YXxm5niUCYTzxCWqJxC2dTassHYoi9wrsXFlFkgnp6l64ohYZeKC5izaHmPJxHXm5vGcHr6Tsi7nKQCxc3PeHKXFdL7zI3pzStCdIJTpPcBuyXR2/PmV93EHtov+1M6T7+g0WyK204rMvB+ra7Va3byj1tfD/EJDNY5kWTqlmpDTjxW2fNFoUwsEa2eBus1tmqIlYpzLW2J2cNse+QrNbffAcNEIt7q0NIbo+XcXE7412Fh/p3bdEQW6spyzFx8NEGwWetbFKhRcKfBsgkXep2BYv0yN/0tJ7N+/O/FBKrz4dHsWvP2eDPa1qFzWJhpdx5MSzau8ezvdmrtKQoO4oL5zxqkiZ8+vAyl+7djEV23K0fSqpRN20BU2zXx5rnkAdtS5vY+XcGt3yGqDDqn5cgao3+Clg0WHTXcOKvBYuQ+sDcdSDhhK7X60t3j+EjaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(66556008)(478600001)(31686004)(110136005)(2616005)(316002)(66476007)(31696002)(38100700001)(16576012)(956004)(5660300002)(186003)(54906003)(66946007)(16526019)(4326008)(8936002)(36756003)(8676002)(26005)(86362001)(53546011)(6486002)(2906002)(6666004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RnVoR2NUTmFRZ3lHSWFYczlKOWtDOEhGalpkbG5HT2gvUFduT2VWMkxUQWh3?=
 =?utf-8?B?OHVyaUpxQm50TXlsR2NTZ3VLcDVyVCtCVDhYQ3owTVVMYUNJaE9yTFVtZ1hN?=
 =?utf-8?B?N010ajVDcVFHR0lERXV3bzFpdGVxSUcxNmJEeHdvMi9BVnJjbGZQd2ovSXRV?=
 =?utf-8?B?TlVySloyVTBlbjV2ZEJxSHRTeWt5M0ZkNXpwQVVTY1BYWERuN2VyVnpVZlR1?=
 =?utf-8?B?Tk5EcmlHQmRyZ2Jnbm5wQ1NOek5DWVltL2kydnRzYnJRazM0VGtZbmpWODgy?=
 =?utf-8?B?U2E4Nk5BVXdqZDZRK1F6aDJ6S01nNVUwSjluRHZmelNuR05yZjBjbkJicUh3?=
 =?utf-8?B?VXFhRjBiRG13MUNvNzV3YmhMMUdsakFwRUhmalNaSkhWZS9NNkxBcjU1akVN?=
 =?utf-8?B?b2daL2Q2MURIa0gwaWlkRXMyUjFDcWFOSXNWOTc1ZHF6U0NQemZwVnRHMGhQ?=
 =?utf-8?B?SDFGcFptNGZVL2QyUzRCT3dsTjZ2NUlTQTJlU05tT3ZBQnB2VDhUTm4waFoy?=
 =?utf-8?B?Snc2RjlJUEluTm9vek13NUdURko4NGVOekJkVzQ3UDBXd3dyR2kxdDkvZGpB?=
 =?utf-8?B?d3UvYjMyK202ZDFZN2F5dUxXVHIxZEFESlR2OW5tUnNKQnQ3TVNxRGhGaHdR?=
 =?utf-8?B?NnpPY3hDbEJ3S25Bc3Zqd2NyQUREb0N6RGRTTzZQQTdVNjB5R2lYVDEyUkd4?=
 =?utf-8?B?MXpOZlo2bjAvL1o3ZEVmUVNmNXhEKzN2dWtRUWFPcFI1dStOc1BKNHVhcktk?=
 =?utf-8?B?b21kWUFzYzg2WHdmVkFDZ2pTSGFkSjdhbWxna2M4cStEa1J5NEplOXFQdGRH?=
 =?utf-8?B?cFlSQXpuZ3Z1RHhwTkRVMmF1N0ZCMnJLT0ZDWlNMRi8zVWwyUmFaQTdYNTNS?=
 =?utf-8?B?ZzRNbjJOc2piU2kybUEvYVRTSnRZbmllNnVhbVIvSW9ZK2RMbDJaNVNMUmR5?=
 =?utf-8?B?OWI5QWFTTmcwRjJuNi80V0FpSE9PcFlqbTBiaTZRN2NYeXVSOTYyMlI1OVlo?=
 =?utf-8?B?dllPRm5NVm5OLzkxQTZBMGZudVVFd2lHTFZmZElKNC83NlZlSVU3cEMyQ3pM?=
 =?utf-8?B?di9xWXZDS2NvQzlJV2k0cWR1WDBDZDZVS0k4b0tNcUFQUkF3RzZkU2JvWUFZ?=
 =?utf-8?B?bGVqNWt2WmRVL3h0YmllOVZhSnV4MjVJY2dOTTU2Lzg1M1pHOGNMRWxDYlpr?=
 =?utf-8?B?L3VSc0cvZVlkbGFMVk9JcVEwaDRiZ3JMSndZZ3pzVWt1UklYMis4OHlJVEV4?=
 =?utf-8?B?bXlqL21HaWMrUG15VXduUTZKTm9SZTg0WGxHNWhEUVhUV0lCOWl0NWp1QTZW?=
 =?utf-8?B?aDNSbEdXVmExa2c0VSttZmtxN0JtSithN3EvcG1FUkdDb3ZlZk9lL3VycDA5?=
 =?utf-8?B?aDAwY09aMW1jQlJuUkZ4Y3Rvb0xQTS90T3JkaUQ3NlVxMEtDV2g2a1YyT2Vy?=
 =?utf-8?B?aFpzeFRCOUtVc3hwQ2xUemJkekNUUWJTVytRT1hkTlhVekxQNENRNHBnNFp2?=
 =?utf-8?B?U3N2bmlpVkw1RzRoKzlkaXRjSko2dDJuVTFGK0hFaUJBM09LemdYSUJXdVZH?=
 =?utf-8?B?bkI0SzdhRXFmZHppTXRXQjJpK1h5THhoRXpkbktWZUkrd3k0N3NQTDc1VjUy?=
 =?utf-8?B?YnU2RGkzVkQvWExXbzFQU0wzOTdzTHBidnZ5V0RNSzRIWXBzVDJLYS9OSDYr?=
 =?utf-8?B?bEk2V0ttMFFtUzBqVWhPNkE5OFh3UGhsZkpCbWp2SXc5Qm1BUUptN2M2amh0?=
 =?utf-8?Q?mSqMgeNDDr6jBDM8dkbPYnUKZzIBm/77JACOm4p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f8f517-5815-419e-50ea-08d8ed1f448e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 10:43:02.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpMYiIciNsBA4awr92FxigQzWgAAp/h9VXFk0dU2VVyYRm40qwpU1vM5UIr7fCruG9g6QRei20Npx1NM8S/upQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3817
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2021 12:38, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The only caller of br_vlan_tunnel_lookup, br_handle_ingress_vlan_tunnel,
> extracts the tunnel_id from struct ip_tunnel_info::struct ip_tunnel_key::
> tun_id which is a __be64 value.
> 
> The exact endianness does not seem to matter, because the tunnel id is
> just used as a lookup key for the VLAN group's tunnel hash table, and
> the value is not interpreted directly per se. Moreover,
> rhashtable_lookup_fast treats the key argument as a const void *.
> 
> Therefore, there is no functional change associated with this patch,
> just one to silence "make W=1" builds.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_vlan_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
> index 169e005fbda2..0d3a8c01552e 100644
> --- a/net/bridge/br_vlan_tunnel.c
> +++ b/net/bridge/br_vlan_tunnel.c
> @@ -35,7 +35,7 @@ static const struct rhashtable_params br_vlan_tunnel_rht_params = {
>  };
>  
>  static struct net_bridge_vlan *br_vlan_tunnel_lookup(struct rhashtable *tbl,
> -						     u64 tunnel_id)
> +						     __be64 tunnel_id)
>  {
>  	return rhashtable_lookup_fast(tbl, &tunnel_id,
>  				      br_vlan_tunnel_rht_params);
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

