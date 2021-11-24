Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8C45B527
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbhKXHTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhKXHTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:19:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A0BC061574;
        Tue, 23 Nov 2021 23:16:37 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a18so2362756wrn.6;
        Tue, 23 Nov 2021 23:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=GGb102nGAUHpTk+mlMtmSOgbqXIyprD7aILInQZkk4o=;
        b=XWJSOlO5JpthfTNUJ8Kg8+yS4ZFManiOlwEJdMWDOd1YEH1nRNAzQeKNhT5yu/5C5K
         WJExNCkTKVHTvvVc4x5J8Oi/lvigb1TSO+vjKCvHDYbof7EpvmYIUE8La78u0ZO/o0lC
         zEqZbuXZ4t+ujdZB/ofF8jh+m97b7XBqm2dqRTRxU6Z052Z3opLAk5ucHJ9kVo5H9xfp
         K8ehi/FTzNsVwYYzOvutDn2WJSGgkanHBbEJJTa7LXGZhoUXIcU5m01Xjr6N5PpvrKWh
         BW0HIN3KAwM5g0hnGoBXmb/ofaajWtU8RVu1JjjCrg05GeBMGjgk4mlG+eG9N2Vb188O
         VTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=GGb102nGAUHpTk+mlMtmSOgbqXIyprD7aILInQZkk4o=;
        b=3vNk7CyoFqTAXGJAkPajAeN582r0+MHB/TqzSn9FiiRoy/f9V14mOztM0nmZQqdxxB
         GObrZvqFhd5X+qFMtjmwR66UoxOvPjC4yvcqcaLCBieAhw4/MCWHuRj+l31SA5xEGPRf
         L7u3XIX3wL+2lBoaM2S8/VX04vhFCudITDpab0fnatnQPrJ7AcERYtE8mq+cs4y8e0N8
         WLsWpg+eq00nRQdkIce3iwvaDKPuMBMcPpI/jfczr6YD8H4PJZBOStkCuW2+DWOBLP6V
         ZB2uCTO9uJ/ratSaw3/Xkp2NmiEy1B7Em5P30rJw1BbfLkPw2dQPGu82nBNNl8giMd23
         BCVQ==
X-Gm-Message-State: AOAM531iDyULQ6GVt8+PrfpJ/txNSntIo/3LnS4DL7f6f3YhZWTHKpzv
        8+MU+XKfcfBZH7W+8MdHJxH2hiRR4pM=
X-Google-Smtp-Source: ABdhPJz0SexWJ3QreF1nQcOtqfG/VKHX0phiLtqkQa4pAgnzBOcBgsrLVB3UaIu00RvTx2ys9k5XQw==
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr16003175wri.308.1637738195784;
        Tue, 23 Nov 2021 23:16:35 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:704b:9844:6015:3072? (p200300ea8f1a0f00704b984460153072.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:704b:9844:6015:3072])
        by smtp.googlemail.com with ESMTPSA id v8sm14101828wrd.84.2021.11.23.23.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 23:16:35 -0800 (PST)
Message-ID: <3a8c77ed-7d19-4e4f-3a5f-8e50c709c9ca@gmail.com>
Date:   Wed, 24 Nov 2021 07:52:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, wangjie125@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
 <20211124010654.6753-3-huangguangbin2@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: hns3: format the output of the MAC
 address
In-Reply-To: <20211124010654.6753-3-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.11.2021 02:06, Guangbin Huang wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> Printing the whole MAC addresse may bring security risks. Therefore,
> the MAC address is partially encrypted to improve security.
> 
There's a lot of userspace tools printing the full MAC address.
Is it beneficial to add a proprietary way for crippling the MAC
address just in the syslog?
If there should be a good reason, then wouldn't it be better to
discuss changing the format that %pM prints? Otherwise we may end
up with each driver having to implement such a crippling logic
on its own.

> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 14 +++++
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 29 +++++++---
>  .../hisilicon/hns3/hns3pf/hclge_main.c        | 55 ++++++++++++-------
>  .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  7 ++-
>  4 files changed, 74 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 3f7a9a4c59d5..54caf0dd1204 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -859,6 +859,20 @@ struct hnae3_handle {
>  #define hnae3_get_bit(origin, shift) \
>  	hnae3_get_field(origin, 0x1 << (shift), shift)
>  
> +#define HNAE3_FORMAT_MAC_ADDR_LEN	18
> +#define HNAE3_FORMAT_MAC_ADDR_OFFSET_0	0
> +#define HNAE3_FORMAT_MAC_ADDR_OFFSET_4	4
> +#define HNAE3_FORMAT_MAC_ADDR_OFFSET_5	5
> +
> +static inline void hnae3_format_mac_addr(char *format_mac_addr,
> +					 const u8 *mac_addr)
> +{
> +	snprintf(format_mac_addr, HNAE3_FORMAT_MAC_ADDR_LEN, "%02x:**:**:**:%02x:%02x",
> +		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_0],
> +		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_4],
> +		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_5]);
> +}
> +
>  int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
>  void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 1429235d3a06..0225d6091cf2 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -2251,6 +2251,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
>  
>  static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
>  {
> +	char format_mac_addr_perm[HNAE3_FORMAT_MAC_ADDR_LEN];
> +	char format_mac_addr_sa[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hnae3_handle *h = hns3_get_handle(netdev);
>  	struct sockaddr *mac_addr = p;
>  	int ret;
> @@ -2259,8 +2261,9 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
>  		return -EADDRNOTAVAIL;
>  
>  	if (ether_addr_equal(netdev->dev_addr, mac_addr->sa_data)) {
> -		netdev_info(netdev, "already using mac address %pM\n",
> -			    mac_addr->sa_data);
> +		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
> +		netdev_info(netdev, "already using mac address %s\n",
> +			    format_mac_addr_sa);
>  		return 0;
>  	}
>  
> @@ -2269,8 +2272,10 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
>  	 */
>  	if (!hns3_is_phys_func(h->pdev) &&
>  	    !is_zero_ether_addr(netdev->perm_addr)) {
> -		netdev_err(netdev, "has permanent MAC %pM, user MAC %pM not allow\n",
> -			   netdev->perm_addr, mac_addr->sa_data);
> +		hnae3_format_mac_addr(format_mac_addr_perm, netdev->perm_addr);
> +		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
> +		netdev_err(netdev, "has permanent MAC %s, user MAC %s not allow\n",
> +			   format_mac_addr_perm, format_mac_addr_sa);
>  		return -EPERM;
>  	}
>  
> @@ -2832,14 +2837,16 @@ static int hns3_nic_set_vf_rate(struct net_device *ndev, int vf,
>  static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
>  {
>  	struct hnae3_handle *h = hns3_get_handle(netdev);
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  
>  	if (!h->ae_algo->ops->set_vf_mac)
>  		return -EOPNOTSUPP;
>  
>  	if (is_multicast_ether_addr(mac)) {
> +		hnae3_format_mac_addr(format_mac_addr, mac);
>  		netdev_err(netdev,
> -			   "Invalid MAC:%pM specified. Could not set MAC\n",
> -			   mac);
> +			   "Invalid MAC:%s specified. Could not set MAC\n",
> +			   format_mac_addr);
>  		return -EINVAL;
>  	}
>  
> @@ -4930,6 +4937,7 @@ static void hns3_uninit_all_ring(struct hns3_nic_priv *priv)
>  static int hns3_init_mac_addr(struct net_device *netdev)
>  {
>  	struct hns3_nic_priv *priv = netdev_priv(netdev);
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hnae3_handle *h = priv->ae_handle;
>  	u8 mac_addr_temp[ETH_ALEN];
>  	int ret = 0;
> @@ -4940,8 +4948,9 @@ static int hns3_init_mac_addr(struct net_device *netdev)
>  	/* Check if the MAC address is valid, if not get a random one */
>  	if (!is_valid_ether_addr(mac_addr_temp)) {
>  		eth_hw_addr_random(netdev);
> -		dev_warn(priv->dev, "using random MAC address %pM\n",
> -			 netdev->dev_addr);
> +		hnae3_format_mac_addr(format_mac_addr, netdev->dev_addr);
> +		dev_warn(priv->dev, "using random MAC address %s\n",
> +			 format_mac_addr);
>  	} else if (!ether_addr_equal(netdev->dev_addr, mac_addr_temp)) {
>  		eth_hw_addr_set(netdev, mac_addr_temp);
>  		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
> @@ -4993,8 +5002,10 @@ static void hns3_client_stop(struct hnae3_handle *handle)
>  static void hns3_info_show(struct hns3_nic_priv *priv)
>  {
>  	struct hnae3_knic_private_info *kinfo = &priv->ae_handle->kinfo;
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  
> -	dev_info(priv->dev, "MAC address: %pM\n", priv->netdev->dev_addr);
> +	hnae3_format_mac_addr(format_mac_addr, priv->netdev->dev_addr);
> +	dev_info(priv->dev, "MAC address: %s\n", format_mac_addr);
>  	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
>  	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
>  	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index dd98143a65ee..a0628d139149 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -8761,6 +8761,7 @@ int hclge_update_mac_list(struct hclge_vport *vport,
>  			  enum HCLGE_MAC_ADDR_TYPE mac_type,
>  			  const unsigned char *addr)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	struct hclge_mac_node *mac_node;
>  	struct list_head *list;
> @@ -8785,9 +8786,10 @@ int hclge_update_mac_list(struct hclge_vport *vport,
>  	/* if this address is never added, unnecessary to delete */
>  	if (state == HCLGE_MAC_TO_DEL) {
>  		spin_unlock_bh(&vport->mac_list_lock);
> +		hnae3_format_mac_addr(format_mac_addr, addr);
>  		dev_err(&hdev->pdev->dev,
> -			"failed to delete address %pM from mac list\n",
> -			addr);
> +			"failed to delete address %s from mac list\n",
> +			format_mac_addr);
>  		return -ENOENT;
>  	}
>  
> @@ -8820,6 +8822,7 @@ static int hclge_add_uc_addr(struct hnae3_handle *handle,
>  int hclge_add_uc_addr_common(struct hclge_vport *vport,
>  			     const unsigned char *addr)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	struct hclge_mac_vlan_tbl_entry_cmd req;
>  	struct hclge_desc desc;
> @@ -8830,9 +8833,10 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
>  	if (is_zero_ether_addr(addr) ||
>  	    is_broadcast_ether_addr(addr) ||
>  	    is_multicast_ether_addr(addr)) {
> +		hnae3_format_mac_addr(format_mac_addr, addr);
>  		dev_err(&hdev->pdev->dev,
> -			"Set_uc mac err! invalid mac:%pM. is_zero:%d,is_br=%d,is_mul=%d\n",
> -			 addr, is_zero_ether_addr(addr),
> +			"Set_uc mac err! invalid mac:%s. is_zero:%d,is_br=%d,is_mul=%d\n",
> +			 format_mac_addr, is_zero_ether_addr(addr),
>  			 is_broadcast_ether_addr(addr),
>  			 is_multicast_ether_addr(addr));
>  		return -EINVAL;
> @@ -8889,6 +8893,7 @@ static int hclge_rm_uc_addr(struct hnae3_handle *handle,
>  int hclge_rm_uc_addr_common(struct hclge_vport *vport,
>  			    const unsigned char *addr)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	struct hclge_mac_vlan_tbl_entry_cmd req;
>  	int ret;
> @@ -8897,8 +8902,9 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
>  	if (is_zero_ether_addr(addr) ||
>  	    is_broadcast_ether_addr(addr) ||
>  	    is_multicast_ether_addr(addr)) {
> -		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%pM.\n",
> -			addr);
> +		hnae3_format_mac_addr(format_mac_addr, addr);
> +		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%s.\n",
> +			format_mac_addr);
>  		return -EINVAL;
>  	}
>  
> @@ -8929,6 +8935,7 @@ static int hclge_add_mc_addr(struct hnae3_handle *handle,
>  int hclge_add_mc_addr_common(struct hclge_vport *vport,
>  			     const unsigned char *addr)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	struct hclge_mac_vlan_tbl_entry_cmd req;
>  	struct hclge_desc desc[3];
> @@ -8937,9 +8944,10 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
>  
>  	/* mac addr check */
>  	if (!is_multicast_ether_addr(addr)) {
> +		hnae3_format_mac_addr(format_mac_addr, addr);
>  		dev_err(&hdev->pdev->dev,
> -			"Add mc mac err! invalid mac:%pM.\n",
> -			 addr);
> +			"Add mc mac err! invalid mac:%s.\n",
> +			 format_mac_addr);
>  		return -EINVAL;
>  	}
>  	memset(&req, 0, sizeof(req));
> @@ -8991,6 +8999,7 @@ static int hclge_rm_mc_addr(struct hnae3_handle *handle,
>  int hclge_rm_mc_addr_common(struct hclge_vport *vport,
>  			    const unsigned char *addr)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	struct hclge_mac_vlan_tbl_entry_cmd req;
>  	enum hclge_cmd_status status;
> @@ -8998,9 +9007,10 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
>  
>  	/* mac addr check */
>  	if (!is_multicast_ether_addr(addr)) {
> +		hnae3_format_mac_addr(format_mac_addr, addr);
>  		dev_dbg(&hdev->pdev->dev,
> -			"Remove mc mac err! invalid mac:%pM.\n",
> -			 addr);
> +			"Remove mc mac err! invalid mac:%s.\n",
> +			 format_mac_addr);
>  		return -EINVAL;
>  	}
>  
> @@ -9440,16 +9450,18 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
>  			    u8 *mac_addr)
>  {
>  	struct hclge_vport *vport = hclge_get_vport(handle);
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  
>  	vport = hclge_get_vf_vport(hdev, vf);
>  	if (!vport)
>  		return -EINVAL;
>  
> +	hnae3_format_mac_addr(format_mac_addr, mac_addr);
>  	if (ether_addr_equal(mac_addr, vport->vf_info.mac)) {
>  		dev_info(&hdev->pdev->dev,
> -			 "Specified MAC(=%pM) is same as before, no change committed!\n",
> -			 mac_addr);
> +			 "Specified MAC(=%s) is same as before, no change committed!\n",
> +			 format_mac_addr);
>  		return 0;
>  	}
>  
> @@ -9457,13 +9469,13 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
>  
>  	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
>  		dev_info(&hdev->pdev->dev,
> -			 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
> -			 vf, mac_addr);
> +			 "MAC of VF %d has been set to %s, and it will be reinitialized!\n",
> +			 vf, format_mac_addr);
>  		return hclge_inform_reset_assert_to_vf(vport);
>  	}
>  
> -	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %pM\n",
> -		 vf, mac_addr);
> +	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
> +		 vf, format_mac_addr);
>  	return 0;
>  }
>  
> @@ -9567,6 +9579,7 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
>  {
>  	const unsigned char *new_addr = (const unsigned char *)p;
>  	struct hclge_vport *vport = hclge_get_vport(handle);
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclge_dev *hdev = vport->back;
>  	unsigned char *old_addr = NULL;
>  	int ret;
> @@ -9575,9 +9588,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
>  	if (is_zero_ether_addr(new_addr) ||
>  	    is_broadcast_ether_addr(new_addr) ||
>  	    is_multicast_ether_addr(new_addr)) {
> +		hnae3_format_mac_addr(format_mac_addr, new_addr);
>  		dev_err(&hdev->pdev->dev,
> -			"change uc mac err! invalid mac: %pM.\n",
> -			 new_addr);
> +			"change uc mac err! invalid mac: %s.\n",
> +			 format_mac_addr);
>  		return -EINVAL;
>  	}
>  
> @@ -9595,9 +9609,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
>  	spin_lock_bh(&vport->mac_list_lock);
>  	ret = hclge_update_mac_node_for_dev_addr(vport, old_addr, new_addr);
>  	if (ret) {
> +		hnae3_format_mac_addr(format_mac_addr, new_addr);
>  		dev_err(&hdev->pdev->dev,
> -			"failed to change the mac addr:%pM, ret = %d\n",
> -			new_addr, ret);
> +			"failed to change the mac addr:%s, ret = %d\n",
> +			format_mac_addr, ret);
>  		spin_unlock_bh(&vport->mac_list_lock);
>  
>  		if (!is_first)
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> index 25c419d40066..9b6829e6e54c 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> @@ -1514,15 +1514,18 @@ static void hclgevf_config_mac_list(struct hclgevf_dev *hdev,
>  				    struct list_head *list,
>  				    enum HCLGEVF_MAC_ADDR_TYPE mac_type)
>  {
> +	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
>  	struct hclgevf_mac_addr_node *mac_node, *tmp;
>  	int ret;
>  
>  	list_for_each_entry_safe(mac_node, tmp, list, node) {
>  		ret = hclgevf_add_del_mac_addr(hdev, mac_node, mac_type);
>  		if  (ret) {
> +			hnae3_format_mac_addr(format_mac_addr,
> +					      mac_node->mac_addr);
>  			dev_err(&hdev->pdev->dev,
> -				"failed to configure mac %pM, state = %d, ret = %d\n",
> -				mac_node->mac_addr, mac_node->state, ret);
> +				"failed to configure mac %s, state = %d, ret = %d\n",
> +				format_mac_addr, mac_node->state, ret);
>  			return;
>  		}
>  		if (mac_node->state == HCLGEVF_MAC_TO_ADD) {
> 

