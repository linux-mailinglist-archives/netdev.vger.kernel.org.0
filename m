Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E149485D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiATHiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:38:19 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:6017
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229587AbiATHiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 02:38:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBfyQGxIzc01haZqyVOQeLVwYe6GJh1I1cTQNhQkYckSdgVU2N1Yk+Oh+tMUZtr8ZvsSh0jm+IMfFdqNbQKk1F3dM0eLIKBhvp1ALiN0AZcV5UQxwSCZkcIWoxUd0eFgNSCVTZaAZNduEVN+Fr4KrJYf9zxFtzEaUAbqq75P2g/hlLdpZ/2fslfzyWuvanACAtsIFhOcuHW1agE0UfQVKbRD2dJ4sve440Oi16idT6KT4twPsCUGXtsScuGNbQJkDO2/nQUJyzHb//RlbAA65QAk5zy9qQD5M6xcWMsllR630bKTdRx6ODKNht2izipeAbCMGGJitsRSWg8MENc9nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tiA6oSU1z7fzYjIjZPUB0wTdRnfDZ6K7vY3PDSjRhQ=;
 b=Y6IlMI53s2BOlsXQTH0zaKq8BF7Hb/mqnPiwDKbjy8cZYmoxoKjHUvTmTsjSOGhosC7ghGdKvEYnU4UFehIeJ/EvPG9sPknCCwvr/O5kXr90K3dMZY4mbZebNdzm+pKDdA8NoqskRkM6a8hJXPsx1yIzBBBcfJkvBB0MbD9Id4Tr5Be76RpptZBJlqHjWwW1Rck/+Jqg5BEP81BcQZxoEgBAr5BnH062M0glXHDvhEt+DoTXMu2d5pc33l4/ylpmS/AuS70cgdy04ULCe8Q44IHz8JHGXljFljYLtYmreFev1jTcUzIbAVBDlERu2l9NpGGoCPg5GQdfPogCkgzUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tiA6oSU1z7fzYjIjZPUB0wTdRnfDZ6K7vY3PDSjRhQ=;
 b=sA0jILftp2k2gP04FT7nLyuHM4Nox6pEQqxodL6/ZhM5EeVnBdn8jFmw3312hdgPs4UDckcjM5Y7dXVeh2O8GM+CIj48cJrSfxjAiEoLXmTQ09RrqKiONCbGHdEYHTkl5Nqkipl4+V4x5oHSVY4XGOUoMSElvvPLTamn6hX5sPsccwE/K+DEuDw3EbSgJ2cEwuMhq9ARS7J00X22siiWu2k/4uSuhiaTCBQpeDMmqbx9XOoXgF4a/Gx7b45l8OQoTM3JmVn0sOV2VO7k7MHgY0cy4WoYeLv9ziSbzIuKJlA6F9xv+Q0BVnLDa6b6/nqWeOdXnHkwIoMUcg8oxUkJTQ==
Received: from CO2PR04CA0174.namprd04.prod.outlook.com (2603:10b6:104:4::28)
 by DM4PR12MB5344.namprd12.prod.outlook.com (2603:10b6:5:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 07:38:17 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:4:cafe::69) by CO2PR04CA0174.outlook.office365.com
 (2603:10b6:104:4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Thu, 20 Jan 2022 07:38:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 07:38:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 07:38:16 +0000
Received: from localhost.localdomain.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 19 Jan 2022 23:38:14 -0800
References: <20210325153533.770125-1-atenart@kernel.org>
 <20210325153533.770125-2-atenart@kernel.org>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <echaudro@redhat.com>,
        <sbrivio@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info
 when PMTU triggers an ICMP reply
In-Reply-To: <20210325153533.770125-2-atenart@kernel.org>
Date:   Thu, 20 Jan 2022 09:38:05 +0200
Message-ID: <ygnhh79yluw2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c25fcc6e-84bb-4092-4586-08d9dbe7d30a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5344:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5344A403A1027790839FDFE7A05A9@DM4PR12MB5344.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rvNQ4Pcr6qGveDXZYGHskSkX1UXNTj9P0OZtZdhdVAAKaoyL0jCE1x9drwA6//bao+2DgSbOmWN9MqdRTg6tCDboMO/zukEmlSQIj+jmb97Q8y8yo5J6SQTML0YluWbDfC7WDPu1n7wwOKHZLvLGKdBtYjojIruLrSHGRP3NLHkmtriC56djf+L7XGvsFHF0HMTVDfQjFYS+o6V8x6Z3Rlh1NdOQAclTlj5+BCqkfU/ps4cIds10bCv/1l9LUr+JycqbleUgWij+hVcytw8b1HFqSksGKBp3foPavVqLWmk5h4jMti+zu8g8g/bhQDiIDx3myMw/16wfUI2x992TpW5zEwmMjkvJliW808riLaDYnVurt67R8eqTMLQHIWn8cPbQgS9enA9o/B4fsfhRIhr1wmfplAzG0Xu+GLwRgXSmC+dfYmD7OQULKT6CxJCxRlpFUYa9jBMVfZP7wQSLtDqb3xl9qGhoMNrJd0H9j9TyxNBhirIpUjmzEJKWmkZG/zfzwEPMedkDicvZvl+XEeqzK1+E90l28fp0gI0/7m6YzcOCeT8gN2q5/sRB2OAUUactp3XgCQS/aaL3/6bIw1TmIpUfLs2Hpxs68o5pZqo9KYdEQnx00q0uG/TRZ4haOYKcokJqP0LoQXfSfy6kMioD+MrUm8KCb753CfVQAiGyqSBP4YXfE0OZ2U3pqzBzGJskAVJfDsUtlzvWwzkC2CmMGl+/5YeGKwTPF4BegJ4hzfZ2gUOkL83Iu4OkLg3PLKQCDDl1SHl2SaBbnnZAxIFx49Lo8KNM0FE/d0zv/g=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(7696005)(356005)(36860700001)(508600001)(186003)(82310400004)(86362001)(26005)(5660300002)(81166007)(426003)(316002)(70586007)(336012)(36756003)(6666004)(6916009)(4326008)(2906002)(8936002)(16526019)(40460700001)(83380400001)(47076005)(54906003)(2616005)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 07:38:17.3136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25fcc6e-84bb-4092-4586-08d9dbe7d30a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Antoine,

On Thu 25 Mar 2021 at 17:35, Antoine Tenart <atenart@kernel.org> wrote:
> When the interface is part of a bridge or an Open vSwitch port and a
> packet exceed a PMTU estimate, an ICMP reply is sent to the sender. When
> using the external mode (collect metadata) the source and destination
> addresses are reversed, so that Open vSwitch can match the packet
> against an existing (reverse) flow.
>
> But inverting the source and destination addresses in the shared
> ip_tunnel_info will make following packets of the flow to use a wrong
> destination address (packets will be tunnelled to itself), if the flow
> isn't updated. Which happens with Open vSwitch, until the flow times
> out.
>
> Fixes this by uncloning the skb's ip_tunnel_info before inverting its
> source and destination addresses, so that the modification will only be
> made for the PTMU packet, not the following ones.
>
> Fixes: fc68c99577cc ("vxlan: Support for PMTU discovery on directly bridged links")
> Tested-by: Eelco Chaudron <echaudro@redhat.com>
> Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/net/vxlan.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 666dd201c3d5..53dbc67e8a34 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2725,12 +2725,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  			goto tx_error;
>  		} else if (err) {
>  			if (info) {
> +				struct ip_tunnel_info *unclone;
>  				struct in_addr src, dst;
>  
> +				unclone = skb_tunnel_info_unclone(skb);
> +				if (unlikely(!unclone))
> +					goto tx_error;
> +

We have been getting memleaks in one of our tests that point to this
code (test deletes vxlan device while running traffic redirected by OvS
TC at the same time):

unreferenced object 0xffff8882d0114200 (size 256):
  comm "softirq", pid 0, jiffies 4296140292 (age 1435.992s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 3b 85 84 ff ff ff ff  .........;......
    a1 26 b7 83 ff ff ff ff 00 00 00 00 00 00 00 00  .&..............
  backtrace:
    [<0000000097659d47>] metadata_dst_alloc+0x1f/0x470
    [<000000007571c30f>] tun_dst_unclone+0xee/0x360 [vxlan]
    [<00000000d2dcfd00>] vxlan_xmit_one+0x131d/0x2a00 [vxlan]
    [<00000000281572b6>] vxlan_xmit+0x8e6/0x4cd0 [vxlan]
    [<00000000d49d33fe>] dev_hard_start_xmit+0x1ba/0x710
    [<00000000eac444f5>] __dev_queue_xmit+0x17c5/0x25f0
    [<000000005fbd8585>] tcf_mirred_act+0xb1d/0xf70 [act_mirred]
    [<0000000064b6eb2d>] tcf_action_exec+0x10e/0x350
    [<00000000352821e8>] fl_classify+0x4e3/0x610 [cls_flower]
    [<0000000011d3f765>] tcf_classify+0x33d/0x800
    [<000000006c69b225>] __netif_receive_skb_core+0x18d6/0x2ae0
    [<00000000dd256fe3>] __netif_receive_skb_one_core+0xaf/0x180
    [<0000000065d43bd6>] process_backlog+0x2e3/0x710
    [<00000000964357ae>] __napi_poll+0x9f/0x560
    [<0000000059a93cf6>] net_rx_action+0x357/0xa60
    [<00000000766481bc>] __do_softirq+0x282/0x94e

Looking at the code the potential issue seems to be that
tun_dst_unclone() creates new metadata_dst instance with refcount==1,
increments the refcount with dst_hold() to value 2, then returns it.
This seems to imply that caller is expected to release one of the
references (second one if for skb), but none of the callers (including
original dev_fill_metadata_dst()) do that, so I guess I'm
misunderstanding something here.

Any tips or suggestions?

>  				src = remote_ip.sin.sin_addr;
>  				dst = local_ip.sin.sin_addr;
> -				info->key.u.ipv4.src = src.s_addr;
> -				info->key.u.ipv4.dst = dst.s_addr;
> +				unclone->key.u.ipv4.src = src.s_addr;
> +				unclone->key.u.ipv4.dst = dst.s_addr;
>  			}
>  			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
>  			dst_release(ndst);
> @@ -2781,12 +2786,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  			goto tx_error;
>  		} else if (err) {
>  			if (info) {
> +				struct ip_tunnel_info *unclone;
>  				struct in6_addr src, dst;
>  
> +				unclone = skb_tunnel_info_unclone(skb);
> +				if (unlikely(!unclone))
> +					goto tx_error;
> +
>  				src = remote_ip.sin6.sin6_addr;
>  				dst = local_ip.sin6.sin6_addr;
> -				info->key.u.ipv6.src = src;
> -				info->key.u.ipv6.dst = dst;
> +				unclone->key.u.ipv6.src = src;
> +				unclone->key.u.ipv6.dst = dst;
>  			}
>  
>  			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);

