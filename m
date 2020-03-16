Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC61867B2
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgCPJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:18:19 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:34023
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730025AbgCPJST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 05:18:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2lVq3ei6OEDXR8XFP8Vangl9dTu5LQ4pdLRrceGHR6CSFATJ/lJE7hKDBMe3Z7veMWSaXYiTI77lgLL+NSKjZ1jK63wYMXA5EkyqIiiOyUwY/olnM0zryt32GHGe7dbjdSozXSDald3d2+MUgx1vuWPB4CI8+WGhlNG4PRYyX67PTupGFK+GZu+VEVLnAyN45oQkWuDeHUvrtULA5643gmQb3djDq8AdecaZr9pE8hIs0gXgbBc/AgOAeqAdGiLoscicPD06Fmb+pmhU28m0SO3JWe02ynN1+vOTuMp81hIQQvLaWZeQz97HyarNnEqUDY8jO3n0CqFOOzx24Iopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7TjCZpMNfvh9AWDYdsZDn+/pxdSRwjwL6+nBb5oD/A=;
 b=dB64msaiyjJ+LdMtuj/kyfCDdNBeL2VGSXnGRvsMaas5GRf86z4o+k9UdpeZYnMYkOLq7E+CdG9M/CHX5vJ89RXMXRYoitTBpX0wXK1prmdwiTjMRow/JAx7uJh2YrReXn+t9Nv2TbwB9Ci/+cW7olmQxsCpGp/Rh9fPX+i7KZPyDBOJBdH8kLmCxy1Oz11sfIFQZVx+6Sjljt6eUuBpoHaQELy8gjgFJeOav+mRT/drlHULABocON6ywVSwkXZdClGcfhpU5HnDEBtCYWHGER531bHo8ksA3mbj/mCFY1+a/V1ntCQkH34lstNELroOiOIu3Ljjqnzc5m2KoMs9mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7TjCZpMNfvh9AWDYdsZDn+/pxdSRwjwL6+nBb5oD/A=;
 b=KXJ5nTAnlgCWizmj3yTB0UkBTuXRGyNM5b/HcnK2hFrg4QvASy3DavuTeYnMVpGL4ALcS5fXMq2XqgZEOoPR3q24YoCydnCZyCYaDKakrA9fT+IMfWBwtmcV6zhgfwv+pEBR3toZ/kxHC0k0EwfY0K+SDX2qJSP0FzYYDkiUP24=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5588.eurprd05.prod.outlook.com (20.177.118.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Mon, 16 Mar 2020 09:18:15 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 09:18:15 +0000
Subject: Re: ct_act can't offload in hardware
To:     wenxu <wenxu@ucloud.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <bdb0ae4d-b488-b305-4146-e938e8b560f4@ucloud.cn>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <9e5f09b8-286c-c03e-66df-4bbf96d1df90@mellanox.com>
Date:   Mon, 16 Mar 2020 11:18:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <bdb0ae4d-b488-b305-4146-e938e8b560f4@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR05CA0012.eurprd05.prod.outlook.com
 (2603:10a6:208:55::25) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:208:55::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Mon, 16 Mar 2020 09:18:14 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dfe547c-6110-433e-5920-08d7c98af50f
X-MS-TrafficTypeDiagnostic: AM6PR05MB5588:
X-Microsoft-Antispam-PRVS: <AM6PR05MB5588D594E1C26CE07F096248CFF90@AM6PR05MB5588.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(199004)(53546011)(26005)(6486002)(66946007)(186003)(16526019)(2616005)(956004)(66556008)(2906002)(31696002)(66476007)(36756003)(316002)(16576012)(86362001)(81166006)(81156014)(6916009)(5660300002)(8936002)(52116002)(4326008)(8676002)(478600001)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5588;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lK/00F0fqyAqHhy/t5n2BH3+h5W8BzOWQt0s/FjOEg8gupGo6HRW0Cw8IcNhBeL/UGdjqG/zjfz+LGoBG7+iqwVmbIP4MHWV7u2I2gkxIKmGo6zmX6NhXA3OHZb3GeDo3gfHCqyaedJzh+JpAHC3guQsNIOrxgBQGUGyUTOEBfFkSy9iWa/mVrmiA9YThiTuWc+JpN6jiT3CFfUPjEOy5k7CZpDWIjVGwqHSyacsKnHt9EzoOr8XbdFrib6GgNV18LOEbxbPFDmFi8t9Je9GrGAZU3g/aCal8LpMlH1PH9gQ+Wfi3sW3a+6xEU3laaIwRiB6YHQaeW0lb17OQnH1siZlQs1qNZyaxl0HIBjOW1vvCW4Lz/pb+xbDd1qqicGA6MEELsSdJy1DFuyzlpsMUwvSIOVy1cge3sXxYbhrkoF20F3R4LB5zEZu5eEl4m2W
X-MS-Exchange-AntiSpam-MessageData: lAr/N63aIBOx4QZYoD+Bb2G7Y+q5Ryjq5jPq5RDD6v9/0mphGXzrhs2SJPuB/4qBKmCP+QV6pvsP2ILAMXUJhWhlMZGw10sZivE6gO1yHfEH0jIcQj+P2EMmM28XaQVPywF/ppZ9/4Lh/ZXG9aklcg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dfe547c-6110-433e-5920-08d7c98af50f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 09:18:15.2194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNo8e2A1lshyhhXoLy54pqKXurmM1YoMtBRYVDNqegtsR3s5NOEBzedFaSJJ2n0VdnZA/v0e5yaeZX6HVKTbsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5588
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/16/2020 10:23 AM, wenxu wrote:
> Hi paul,
>
>
> I test the ct offload with  tc  in net-next branch and meet some problem
>
>
> gre_sys is a getap device.
>
> # tc filter add dev gre_sys ingress prio 2 chain 0 proto ip flower  enc_dst_ip 172.168.152.75 enc_src_ip 172.168.152.208 enc_key_id 1000 enc_tos 0x0/ff dst_ip 1.1.1.7 ct_state -trk action ct zone 1 nat pipe action goto chain 1
>
> The rule show is not_in_hw
>
> # tc filter ls dev gre_sys ingress
>
> filter protocol ip pref 2 flower chain 0
> filter protocol ip pref 2 flower chain 0 handle 0x1
>   eth_type ipv4
>   dst_ip 1.1.1.7
>   enc_dst_ip 172.168.152.75
>   enc_src_ip 172.168.152.208
>   enc_key_id 1000
>   enc_tos 0x0/ff
>   ct_state -trk
>   not_in_hw
>     action order 1: ct zone 1 nat pipe
>      index 1 ref 1 bind 1
>  
>     action order 2: gact action goto chain 1
>      random type none pass val 0
>      index 1 ref 1 bind 1
>
>
> # dmesg
>
> mlx5_core 0000:81:00.0 net2: Chains on tunnel devices isn't supported without register metadata support
>
> I update the fw to 16.27.1016 and also the problem is exist.
>
> # ethtool -i net2
>
> driver: mlx5e_rep
> version: 5.6.0-rc5+
> firmware-version: 16.27.1016 (MT_0000000080)
> expansion-rom-version:
> bus-info: 0000:81:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: no
>
> Are there aome method to enable the register metadata support?
>
>
> BR
>
> wenxu
Hi

Originally we needed metadata support just because it was enabled by default and
it enabled the loopback feature which is what actually
needed for the above type of rules (tunnel + chain).

But after patch 1e62e222db2e0dc7af0a89c225311d319c5d1c4f - "net/mlx5: E-Switch,
Use vport metadata matching only when mandatory"
metadata is not enabled by default, and it's needed for the above.

My upstream patch
5b7cb74 "net/mlx5: E-Switch, Enable reg c1 loopback when possible"
Enabled the needed loopback feature by default as it was also needed for
connection tracking.

Instead of relying on mlx5_eswitch_vport_match_metadata_enabled(esw) in
parse_tunnel_attr(), we
need to relay on mlx5_eswitch_reg_c1_loopback_enabled(esw). I have a patch under
internal review that does this.

For now,  you can either disable this
mlx5_eswitch_vport_match_metadata_enabled(esw) check in parse_tunnel_attr() or more
correctly replace it with the mlx5_eswitch_reg_c1_loopback_enabled(esw) check.

Thanks,
Paul.
>

