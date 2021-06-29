Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A6D3B7050
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 11:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhF2Jxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 05:53:37 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:38620
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232661AbhF2Jxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 05:53:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6AxceM7yrSTmGUQrQocQSUzr9JVaT3sZv8Su1OZm88FkwayixKBSJSOZYMjF/cO6LeE7B6D9NNvJSK2le7U2ijVTW8DMUg2yGRLVk4piI42ppIbWBCnUhz9Nf/k/3BFmCVeRLawYLmuYoz6mFX9ToeDQrhNGZOC4obUfDrDJkc7Ue2NwRNuzT3g/fZt9oJXWCmefjS0vbYt18iV+cgOb5exT5UCZuoHXXV2c9vMMZ0DoN+DgpcMsHkoa6yrhSyGJznDIIYYaRJRQt1pH60iz8yLZ/vYFn1lwpYSivNgSBJuzncbODnJpCI4KInEuJU9SImhVR3ktbVD/YlzS43niQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvhEUIiHn1tiIyCLVNN0P9Zk0i2mQ9q7B/IDQzHQ6NQ=;
 b=In4VkyCOEzsAvvKvTlqmRqnjyYDPju1NrK6KUGEzkmaga1KCoh+BEQ+PNZlJN5fkww1V4AtWuaVbFOvJbJyYitsEKefpXO5dVQrbfXVwHtDucKqP5mm/to7yrrYFajepvU7O/Jc+e05yaSR4uZG6v2l/fJe75kUBT6bdEu0odW4g0a3wTdlhJEgN/Js0wjcU+teKMFpkEBwMi/uHW2SVMz8JatAHuuY741JwhVYy/E8UKVZCNWTw6rXBVbY3Iv7fe7ZzlM56cJGzZ5wxx0FlEDt4tY3vej4G34cG3aMi7MYXUTEa0IjhdcxY1pZgtPx1iz0RqRTD1/udJyW8gOIPlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=st.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvhEUIiHn1tiIyCLVNN0P9Zk0i2mQ9q7B/IDQzHQ6NQ=;
 b=mGn3YnSJgC+fxHVQokn5afr9SBBy6Zkn6PQ2fRRYtauXXeIUUZuUtew1MuCPaRXqJNzoS03vlzXrUj1WVcGDpbw0ZLDuC1aLXbjMimUd+Hiidk2RFRXkbxL6aeQ7+Sixnuf9CajpkekuXMivaUKIwBADU/exK5oYj87xsebbyyRQKyiDxRC74xvtyz1KhysjzLn/k0KNazUL4ikBrGIKtKnbWAPSdPlzKy1Ph8VNgnnyWTEAo13HKjOZ3pkd0k+GF3TAYXEJHTxJLrcjFOC0rh8oUXHmbp6u2I1CWm2w0sneJ2WvVccD13aRdNV9WpATBPTygKL0Ng0vqe9BG8e2lQ==
Received: from MW4PR03CA0014.namprd03.prod.outlook.com (2603:10b6:303:8f::19)
 by MN2PR12MB3184.namprd12.prod.outlook.com (2603:10b6:208:100::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 09:51:06 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::3e) by MW4PR03CA0014.outlook.office365.com
 (2603:10b6:303:8f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend
 Transport; Tue, 29 Jun 2021 09:51:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 09:51:05 +0000
Received: from [172.27.15.186] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Jun
 2021 09:50:56 +0000
Subject: Re: [PATCH net v2] xdp, net: fix for construct skb by xdp inside xsk
 zc rx
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        <intel-wired-lan@lists.osuosl.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210617145534.101458-1-xuanzhuo@linux.alibaba.com>
 <20210628104721.GA57589@ranger.igk.intel.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <9d017748-3a4e-367f-94f4-2dcc6bb3e50e@nvidia.com>
Date:   Tue, 29 Jun 2021 12:50:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628104721.GA57589@ranger.igk.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 847ad19a-f49d-4f83-02a4-08d93ae36981
X-MS-TrafficTypeDiagnostic: MN2PR12MB3184:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3184543D5725FFEEA9982C0EDC029@MN2PR12MB3184.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prjIAk98aOTBsAGSG07NlFNcGpwRlgnkUeJSKjxXPKLEGtFzOUeEzU07BzzJMbYq3RDUJuqIqnD3S5yKaC+b4yzE+yvMr3dwYnryxk3olb93HglKHIE3n5b38yThqERei8WW0NJMsiB3iuPFFeO+KGkhxg0iE4H9vlOUZgTt9FgITbavKqrZlfsKtXlwcefsM5zFtIamAxJrMHMAN8bsPj8EoIei6nPGqKtf9U8km3lu1YDPwMei3vmChiH1XLUskjDYrXIwcjiXkeU9lwLi/jwfxVnP7dVHmISWkXZxcArv8toSaEr9jQZL6O7QcpTbix+92bRvIOEihcweWadIhc6eMaHaTWhovt/SWDbGqdfD+V7DgwqssgW0WSw5Z2fLC4tewZ05kuehUnvybX/zBOTRRJoLXB5c5XvMDUFEDxobwdqbIdZiPa6WkWyqQ8Dqd41VwihiRqBZcwiBTU8KCprGwZQxxMH+hXsfL7UfT6jUhBWZG7Zr9Qa7wYwlBM5NJlQD9894+cR5g7yzni/83Kb8u+H9Pfoc8CYj+XuqhKCUZWxjPadNn7jtvMQwuXKIlymfJlEwL+6ZQHXhcn9EGsX/gdInOLkUwR4aBFHeneVbsEsbtPuplde5b63J+r2pv6XDE0GDrwQxW6svCym41bnRkeDhj9tI+fM2bC8CYAJRr94Zw+K12BMpl10MEbWTa9eXcA0WQFD5lyZx66T8ysdEOUx+kYUmIyBzCDSAP5xTHd5Db1YgDXxKPDyLgvqs
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(5660300002)(83380400001)(110136005)(107886003)(82310400003)(26005)(356005)(8676002)(54906003)(8936002)(2906002)(478600001)(16526019)(186003)(7636003)(70586007)(53546011)(4326008)(7416002)(70206006)(82740400003)(16576012)(336012)(36756003)(6666004)(36860700001)(47076005)(2616005)(316002)(30864003)(31696002)(426003)(86362001)(31686004)(83323001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 09:51:05.0276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 847ad19a-f49d-4f83-02a4-08d93ae36981
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-28 13:47, Maciej Fijalkowski wrote:
> On Thu, Jun 17, 2021 at 10:55:34PM +0800, Xuan Zhuo wrote:
>> When each driver supports xsk rx, if the received buff returns XDP_PASS
>> after run xdp prog, it must construct skb based on xdp. This patch
>> extracts this logic into a public function xdp_construct_skb().
>>
>> There is a bug in the original logic. When constructing skb, we should
>> copy the meta information to skb and then use __skb_pull() to correct
>> the data.
> 
> Thanks for fixing the bug on Intel drivers, Xuan. However, together with
> Magnus we feel that include/net/xdp.h is not a correct place for
> introducing xdp_construct_skb. If mlx side could use it, then probably
> include/net/xdp_sock_drv.h is a better fit for that.
> 
> Once again, CCing Maxim.
> Maxim, any chances that mlx driver could be aligned in a way that we could
> have a common function for creating skb on ZC path?

I'm sorry I missed the v1.

I have reviewed the differences between mlx5e_xsk_construct_skb and 
xdp_construct_skb. I would say it is possible for mlx5 to adapt and use 
the new API, but it may also require changes to xdp_construct_skb. 
Please see the list of differences below.

> 
> Otherwise, maybe we should think about introducing the Intel-specific
> common header in tree?

Sure, you can do it to share Intel-specific stuff between Intel drivers. 
However, in this particular case I think all XSK-enabled drivers would 
benefit from this function, especially after previous efforts that aimed 
to minimize the differences between drivers, the amount of code in the 
drivers and to share as much as possible. So, in my opinion, this stuff 
belongs to xdp_sock_drv.h. (Moreover, I see this patch also changes 
stmmac, so it's no longer Intel-specific.)

Differences between mlx5e_xsk_construct_skb and xdp_construct_skb:

1. __napi_alloc_skb is called with __GFP_NOWARN in xdp_construct_skb, 
but without this flag in mlx5. Why do we need to use non-default flags? 
Why can't we stick with napi_alloc_skb? I see only Intel drivers and XSK 
in stmmac use __napi_alloc_skb instead of napi_alloc_skb, and it looks 
to me as it was just copied from the regular (non-XSK) datapath of i40e 
(i40e_construct_skb) to i40e's XSK, then to stmmac, then to 
xdp_construct_skb, and I don't truly understand the reason of having 
__GFP_NOWARN where it first appeared (i40e_construct_skb). Could someone 
explain the reason for __GFP_NOWARN, so that we could decide whether we 
want it in a generic XSK helper?

2. skb_put in mlx5 vs __skb_put in xdp_construct_skb - shouldn't be a 
big deal, the difference is just an extra overflow check in skb_put.

3. XDP metadata. mlx5 calls xdp_set_data_meta_invalid, while other 
XSK-enabled drivers set metadata size to 0 and allow the XDP program to 
push some metadata. xdp_construct_skb only supports xdp_buffs with 
metadata, it will break if xdp_data_meta_unsupported. There are a few 
possible ways to address it:

3.1. Add a check for xdp_data_meta_unsupported to xdp_construct_skb. It 
will lift the undocumented limitation of this function and allow it to 
handle all valid kinds of xdp_buff.

3.2. Have two versions of xdp_construct_skb: one for xdp_buffs with 
metadata, the other for ones without metadata. Sounds ugly and not 
robust, but could spare a few CPU cycles for drivers that can't have 
metadata.

3.3. Remove xdp_set_data_meta_invalid from mlx5. I think the reason for 
this call was some design decision, rather than a technical limitation. 
On the other hand, even though it will allow mlx5 to work with 
xdp_construct_skb in its current implementation, it would still be nice 
to combine it with 3.1 to avoid having issues with future drivers (if 
not, at least document in a clear way that the xdp_buff parameter must 
have metadata). Tariq/Saeed, could you comment on this point?

Thanks,
Max

>>
>> Fixes: 0a714186d3c0f ("i40e: add AF_XDP zero-copy Rx support")
>> Fixes: 2d4238f556972 ("ice: Add support for AF_XDP")
>> Fixes: bba2556efad66 ("net: stmmac: Enable RX via AF_XDP zero-copy")
>> Fixes: d0bcacd0a1309 ("ixgbe: add AF_XDP zero-copy Rx support")
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 16 +---------
>>   drivers/net/ethernet/intel/ice/ice_xsk.c      | 12 +-------
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 12 +-------
>>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +-------------
>>   include/net/xdp.h                             | 30 +++++++++++++++++++
>>   5 files changed, 34 insertions(+), 59 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> index 68f177a86403..81b0f44eedda 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> @@ -246,23 +246,9 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
>>   static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
>>   					     struct xdp_buff *xdp)
>>   {
>> -	unsigned int metasize = xdp->data - xdp->data_meta;
>> -	unsigned int datasize = xdp->data_end - xdp->data;
>>   	struct sk_buff *skb;
>>   
>> -	/* allocate a skb to store the frags */
>> -	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
>> -			       xdp->data_end - xdp->data_hard_start,
>> -			       GFP_ATOMIC | __GFP_NOWARN);
>> -	if (unlikely(!skb))
>> -		goto out;
>> -
>> -	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>> -	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
>> -	if (metasize)
>> -		skb_metadata_set(skb, metasize);
>> -
>> -out:
>> +	skb = xdp_construct_skb(xdp, &rx_ring->q_vector->napi);
>>   	xsk_buff_free(xdp);
>>   	return skb;
>>   }
>> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
>> index a1f89ea3c2bd..f95e1adcebda 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
>> @@ -430,22 +430,12 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
>>   static struct sk_buff *
>>   ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
>>   {
>> -	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
>> -	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
>> -	unsigned int datasize_hard = rx_buf->xdp->data_end -
>> -				     rx_buf->xdp->data_hard_start;
>>   	struct sk_buff *skb;
>>   
>> -	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
>> -			       GFP_ATOMIC | __GFP_NOWARN);
>> +	skb = xdp_construct_skb(rx_buf->xdp, &rx_ring->q_vector->napi);
>>   	if (unlikely(!skb))
>>   		return NULL;
>>   
>> -	skb_reserve(skb, rx_buf->xdp->data - rx_buf->xdp->data_hard_start);
>> -	memcpy(__skb_put(skb, datasize), rx_buf->xdp->data, datasize);
>> -	if (metasize)
>> -		skb_metadata_set(skb, metasize);
>> -
>>   	xsk_buff_free(rx_buf->xdp);
>>   	rx_buf->xdp = NULL;
>>   	return skb;
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index f72d2978263b..123945832c96 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -203,22 +203,12 @@ bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
>>   static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
>>   					      struct ixgbe_rx_buffer *bi)
>>   {
>> -	unsigned int metasize = bi->xdp->data - bi->xdp->data_meta;
>> -	unsigned int datasize = bi->xdp->data_end - bi->xdp->data;
>>   	struct sk_buff *skb;
>>   
>> -	/* allocate a skb to store the frags */
>> -	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
>> -			       bi->xdp->data_end - bi->xdp->data_hard_start,
>> -			       GFP_ATOMIC | __GFP_NOWARN);
>> +	skb = xdp_construct_skb(bi->xdp, &rx_ring->q_vector->napi);
>>   	if (unlikely(!skb))
>>   		return NULL;
>>   
>> -	skb_reserve(skb, bi->xdp->data - bi->xdp->data_hard_start);
>> -	memcpy(__skb_put(skb, datasize), bi->xdp->data, datasize);
>> -	if (metasize)
>> -		skb_metadata_set(skb, metasize);
>> -
>>   	xsk_buff_free(bi->xdp);
>>   	bi->xdp = NULL;
>>   	return skb;
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index c87202cbd3d6..143ac1edb876 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -4729,27 +4729,6 @@ static void stmmac_finalize_xdp_rx(struct stmmac_priv *priv,
>>   		xdp_do_flush();
>>   }
>>   
>> -static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
>> -					       struct xdp_buff *xdp)
>> -{
>> -	unsigned int metasize = xdp->data - xdp->data_meta;
>> -	unsigned int datasize = xdp->data_end - xdp->data;
>> -	struct sk_buff *skb;
>> -
>> -	skb = __napi_alloc_skb(&ch->rxtx_napi,
>> -			       xdp->data_end - xdp->data_hard_start,
>> -			       GFP_ATOMIC | __GFP_NOWARN);
>> -	if (unlikely(!skb))
>> -		return NULL;
>> -
>> -	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>> -	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
>> -	if (metasize)
>> -		skb_metadata_set(skb, metasize);
>> -
>> -	return skb;
>> -}
>> -
>>   static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
>>   				   struct dma_desc *p, struct dma_desc *np,
>>   				   struct xdp_buff *xdp)
>> @@ -4761,7 +4740,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
>>   	struct sk_buff *skb;
>>   	u32 hash;
>>   
>> -	skb = stmmac_construct_skb_zc(ch, xdp);
>> +	skb = xdp_construct_skb(xdp, &ch->rxtx_napi);
>>   	if (!skb) {
>>   		priv->dev->stats.rx_dropped++;
>>   		return;
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index a5bc214a49d9..561e21eaf718 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -95,6 +95,36 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>>   	xdp->data_meta = meta_valid ? data : data + 1;
>>   }
>>   
>> +static __always_inline struct sk_buff *
>> +xdp_construct_skb(struct xdp_buff *xdp, struct napi_struct *napi)
>> +{
>> +	unsigned int metasize;
>> +	unsigned int datasize;
>> +	unsigned int headroom;
>> +	struct sk_buff *skb;
>> +	unsigned int len;
>> +
>> +	/* this include metasize */
>> +	datasize = xdp->data_end  - xdp->data_meta;
>> +	metasize = xdp->data      - xdp->data_meta;
>> +	headroom = xdp->data_meta - xdp->data_hard_start;
>> +	len      = xdp->data_end  - xdp->data_hard_start;
>> +
>> +	/* allocate a skb to store the frags */
>> +	skb = __napi_alloc_skb(napi, len, GFP_ATOMIC | __GFP_NOWARN);
>> +	if (unlikely(!skb))
>> +		return NULL;
>> +
>> +	skb_reserve(skb, headroom);
>> +	memcpy(__skb_put(skb, datasize), xdp->data_meta, datasize);
>> +	if (metasize) {
>> +		__skb_pull(skb, metasize);
>> +		skb_metadata_set(skb, metasize);
>> +	}
>> +
>> +	return skb;
>> +}
>> +
>>   /* Reserve memory area at end-of data area.
>>    *
>>    * This macro reserves tailroom in the XDP buffer by limiting the
>> -- 
>> 2.31.0
>>

