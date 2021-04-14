Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5069735F78E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352058AbhDNPZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:25:44 -0400
Received: from mail-eopbgr750075.outbound.protection.outlook.com ([40.107.75.75]:24224
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346177AbhDNPZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:25:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az14kABFMozncgbJlFFiDWsW6NWkqWDrpV/XPbj3L3r3ecUb7xRqsCnIi5LdkURHsLwhBVlCY+EAz73xZxAr4NRFYAF2bDSB6NrO8+pQFgsn1MGx6uJ3HE7tTfXlQkLbwiS4sGLc4ku+SEYHupO7LOfFNXFwB+IYRUw0gVB9ngJoAzm6Rjn2rjJ2TTgfXRqiJI3LZI0Ypd2e04dbi0ODyFes+X7zOlh3ij5Waglyx+mIdtbEat8pWCsYmRC/A1d07Ni8jAM7lS79VeYV3ogH3I4eq1t9zdCf6se5ozfoJYYnjTK1xegboCypEkrnBi+uC/41DYYg7Y0SAXgZdnAy1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e14ZpX8Lr6jv8REnzt6Tqeh3gMaEDtbMKpwIyGKS0E=;
 b=M2Cdak3BNb7pWEqY3iBfKtil+Ee8m7HuHAhw0XxsUzrV9G1okPGJik/5woq101ita8EMyTHh6mhZwJODL2lEpWcT/QHJfi5+awGTDLAv2OZ0ZN+HUgaRGy0egZnMbxQdEtEDpFO44WWZNjUpdA3Rr+kQMaaHzX26GzWU9J2WbpEp0t7t6bJuIdH18CNqk9JbSlL5UYaDOyA1cdMN6zUx30Q6+5eoeWJ1lxWJ1agSgEBpj9ZGJvdEJft0YkQk7ykgRj24x2aKals9uEGlg1R0QbPbhp2TrJNhhfyQ/x1Nlb+HIwnXQWeYLnUF28QgTwRudokTIFozoi54Os/RSFsDTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e14ZpX8Lr6jv8REnzt6Tqeh3gMaEDtbMKpwIyGKS0E=;
 b=V3uIrXStKi22kpyo1sieYpemjkTJWUQAahKZoMV0J7QSpX9PHpgE+F+6KH30bevmkwxTjy4b/ezyITwkpMjX0ERziiLX49Hy1BLbAz4xoKdEADuytCBVEvOGbP86kErp7/0GqPh/+fy669U7C8OXj0QOt9lZiq970DLPPbGd6Xij80DqMVY9tnKLyIYUJCBhseRNZovCJn72GOTEX0N0jIdPS7Ktfo2g9eQxQBL0knotfNKssWC36gjBhHlX3ipdWC5P/UMFgxPsw0hllGbHajgD4er1js+jNCbLSm84fSPp0rp3AKLGcpHTFa8d4jEiyi0TC7qL2jJYO9ulKf9r3A==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Wed, 14 Apr
 2021 15:25:14 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%7]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 15:25:13 +0000
Subject: Re: [PATCH net-next 1/2] net: bridge: switchdev: refactor
 br_switchdev_fdb_notify
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210414151540.1808871-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b541c88e-879e-ee9d-90d8-2cd37690f7e6@nvidia.com>
Date:   Wed, 14 Apr 2021 18:25:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210414151540.1808871-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0129.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::8) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.177] (213.179.129.39) by ZR0P278CA0129.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 15:25:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28830f3c-fd1b-4fee-1921-08d8ff597fde
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43549010DD198AF55EF312ACDF4E9@DM6PR12MB4354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1XptdJ3BGnLkeSFOR9SZ6eYupUjL6AleqcNfptM38dF9NB6+b4wZDrG03tv+qb90WcXoX6Y1tZ/Gf81d1S4PU6Io0VSSmy05gjisHmfqO14d4KhGU+xMH3VTIhQAOsIfssnrGdpHYyyIixQsHnKbXRBpNuxcRQTHnHNOk3zVmOI62aZdmKflEva1hkTUu36zCogVqi3IHrZW5HE3PdXMnBQfFvl+vVJvAPwpm2tvR8onUbvlK7oVMp82BUgasQ5H6AWjuJmaCNFa+7p+o+GmUubanspRnlWrU26mPZy6+zx1Uw1AdHvwk2lU+tyMvRF5+thYhAMfMzE8OsE42mgBH5DJQY+bHwf5tlA9Bk1mDHvhxkJNcgkgZCY7VoC0Vh0Bx7AjCbfV7mevJbUnK0XOHk8zwdFG8R4UfupCRcJ6d/Js4fQfgtcr9QoReAXwzjWc+RTIHm/a+S8gX442T19MWKBdToI4WwKu5nbxJjZ0WaP3OqAAZ8x1E/Baf7xg0BXUIznMdJITXAoMT5S/NrJiuLsPTdwFs3gRL4Hm29zi33CWEl9kf8glG9p6PghBUrl5pcvUJ3ctVF7bOYgY0M9Kt4FN8UDs6rcnc92LGySula/HLctkRL/PsFO094QDQx5b5Nb0KqnUtpdEyF100EQpf4rtEJIm2kmb6hRduXEa83rJljK9QLkGJgWXN2J76WDy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(53546011)(2616005)(83380400001)(956004)(86362001)(36756003)(6486002)(31696002)(2906002)(186003)(110136005)(31686004)(6666004)(16576012)(66556008)(8936002)(316002)(26005)(16526019)(66946007)(5660300002)(7416002)(38100700002)(4326008)(66476007)(54906003)(478600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2pTWHV5T1JEMnlyZGtjMVZmVjBHY3VlanFlR2dCZEswdnB4ckg3QVJteEFK?=
 =?utf-8?B?ZEpNUzhMWHh6WnQxUUU2WWRJTFpPb0hnMStManNLNVM2c1BEa3VGK3ZPQmJo?=
 =?utf-8?B?Wmo3ZTk5bWF6ZWR4YW11bzhyeFZWZmVrbjdQdEZGZFJ6R21TTUtvcU82RmFr?=
 =?utf-8?B?M0RRTmdkVkp1WGkxeUI2U1dOUVZtbHVhYWdLQ1FVTkt1dmNFOFByaFJoM0Vy?=
 =?utf-8?B?M0FETDNhdllGeWJVeC9xSE8wY0lFNFdlQm5saFAvQ0tGRE45Q3VLeWloZjJD?=
 =?utf-8?B?RGtnK2xpeE10YXFkeDNTRENxdk9VbnUyM0RnSU16dXY3cTlOVmZ4a1pBeXhT?=
 =?utf-8?B?MHhkK0pMQjN0cXVvQTZMQ3B5MXJNbHFsdko3QklvbWFSWVpyS2NidkZhTzdv?=
 =?utf-8?B?aUhpVWN0KzVSemUrdk1Bd0pENjE2ajFiL24xU0pwczU2c0tmejdaME1yMDdT?=
 =?utf-8?B?SXhCaTZqSFlyZStaWkNNVlJwRmk2NE1KRk5SVlkwN3F2ZE85eFl5QXVnS0wy?=
 =?utf-8?B?WjRDL0UwTTM3c3NtOVBjT1g0VFBCdWdkaksrSkZLSldWc0RaRkNVWmJ6M1RF?=
 =?utf-8?B?SFlvakdyd0J5WXh3MUxBRVc4QlFKRm9kZGd0ZnJYbllqNFZ4WjJ1V0ZnNHZq?=
 =?utf-8?B?bHJYc002NEtNVTZKMVhMbnJESFBsSDkwZVhMSUQwSCtCUExQTWlBRGljN2Zt?=
 =?utf-8?B?Z1Iyc2pBL280UUlJS0ovR1hHWjUveTZWWHlHM0J0S3RaSk1ybG5YclVLSTZY?=
 =?utf-8?B?VlNwZVU3ZmtQeEE1MEFxOS8zSXBxVVozSWZBVm5ZMlV0S0YxUHdHV3FCWVdh?=
 =?utf-8?B?K1VSMjlQblBBL3dWY3A3NHJvQkZLMlc1bFdTWks0cTdwYXhrU2FNcFp5RTBy?=
 =?utf-8?B?cFYvZkgvTFhOOWtVUEdFdGNDdG5HYndaaEtuRW1kOHBVNUxsbU9aaUNKOEhB?=
 =?utf-8?B?ZzRPcWlDU2hkOTVPTkZBN0dkajhrUCswWkc1YkljTFAxa2MvL3dwSXc2OE1q?=
 =?utf-8?B?VnZJOXRvbmV5Ny9rSFg2VFI4R1BndnBTMk05d0kybWJSR29Sa28vV3k1SXlu?=
 =?utf-8?B?NTJUVWxTWllnQW1qOURqN29xbXlrRGN3V09raWRzWjRqWnVRM2NvMDV1aTZh?=
 =?utf-8?B?R2xBS01qOFVrb2FrclAwM0c5OTdRdG5zWlZBNVhjVWpWWG13bURDY1R6S21a?=
 =?utf-8?B?em1rWWF4WlFuUjVzbE9XeWtaRlFKaktUSUN6dEFRdXhuTnZLVUN5eEwybFRx?=
 =?utf-8?B?dTF6dnlhaEJiUEhNSEhITlZPOUZNOXhDTVM5RWZwTVZkRGZqNm1IK0EyMWo2?=
 =?utf-8?B?QzBWUUwyNEJ5WjFkeEFoR1pxRXNWVXdCVk1TUnI5cW5zSnlkTXFldEx0bHgv?=
 =?utf-8?B?QlVjVUJ4eHAwVVJ1V0FrblFPTkxzRTJrQ1ZiYmIzTnlHbzd6Lyt6ZGQwTm5u?=
 =?utf-8?B?YW1pNmo5U0hDd3JSNkhGVGhERmZrMTVCbFBaaEY5R3plbGxiQnczQXROajNM?=
 =?utf-8?B?OTZ6NUM5UFlPZFh6VmltSjVzMys4aWtQTTlvV3Nwd0lRc3Bzd2UzL1Noemxt?=
 =?utf-8?B?MUMvQWppY0syV0dUYS9oUVk1WG0wR0ExT1oweldnL0d1cmt2ejMyZUhKclNV?=
 =?utf-8?B?Slc3dVZEbzJ6R0ZvMnJjaDFkQTVySmpHenZqUDAySnJHaC9sblpvRGJ2UmND?=
 =?utf-8?B?blVlNWRidjJMcmxqbm5hbllMVGhXSUJNVmdqWTUyNzAwTVJXZlpBZUYwY2VY?=
 =?utf-8?Q?T/Q00lPiYsEtzSXNmy1SD9Ke3jHJU7vSFhfpEiS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28830f3c-fd1b-4fee-1921-08d8ff597fde
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 15:25:13.7937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UORNLwZ1JiS0Lup0pscb6CdmmGsOAYv6VW6P7A1o0hU3ZBC+1ZWOnzUtn1qwknHramZIttNTlzlIP3M1RMoC3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 18:15, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Instead of having to add more and more arguments to
> br_switchdev_fdb_call_notifiers, get rid of it and build the info
> struct directly in br_switchdev_fdb_notify.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
>  1 file changed, 11 insertions(+), 30 deletions(-)
> 

Hi,
Is there a PATCH 0/2 with overview and explanation of what's happening in this set ?
If there isn't one please add it and explain the motivation and the change.

Thanks,
 Nik

> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 1e24d9a2c9a7..c390f84adea2 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -107,25 +107,16 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  	return 0;
>  }
>  
> -static void
> -br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
> -				u16 vid, struct net_device *dev,
> -				bool added_by_user, bool offloaded)
> -{
> -	struct switchdev_notifier_fdb_info info;
> -	unsigned long notifier_type;
> -
> -	info.addr = mac;
> -	info.vid = vid;
> -	info.added_by_user = added_by_user;
> -	info.offloaded = offloaded;
> -	notifier_type = adding ? SWITCHDEV_FDB_ADD_TO_DEVICE : SWITCHDEV_FDB_DEL_TO_DEVICE;
> -	call_switchdev_notifiers(notifier_type, dev, &info.info, NULL);
> -}
> -
>  void
>  br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>  {
> +	struct switchdev_notifier_fdb_info info = {
> +		.addr = fdb->key.addr.addr,
> +		.vid = fdb->key.vlan_id,
> +		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
> +		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
> +	};
> +
>  	if (!fdb->dst)
>  		return;
>  	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> @@ -133,22 +124,12 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>  
>  	switch (type) {
>  	case RTM_DELNEIGH:
> -		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
> -						fdb->key.vlan_id,
> -						fdb->dst->dev,
> -						test_bit(BR_FDB_ADDED_BY_USER,
> -							 &fdb->flags),
> -						test_bit(BR_FDB_OFFLOADED,
> -							 &fdb->flags));
> +		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
> +					 fdb->dst->dev, &info.info, NULL);
>  		break;
>  	case RTM_NEWNEIGH:
> -		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
> -						fdb->key.vlan_id,
> -						fdb->dst->dev,
> -						test_bit(BR_FDB_ADDED_BY_USER,
> -							 &fdb->flags),
> -						test_bit(BR_FDB_OFFLOADED,
> -							 &fdb->flags));
> +		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
> +					 fdb->dst->dev, &info.info, NULL);
>  		break;
>  	}
>  }
> 

