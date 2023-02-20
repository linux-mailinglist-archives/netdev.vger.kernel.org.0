Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3010C69C622
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjBTHvb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 02:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBTHva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:51:30 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA251CA3A
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 23:51:22 -0800 (PST)
X-QQ-mid: bizesmtp67t1676879387tizbgi4q
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 20 Feb 2023 15:49:46 +0800 (CST)
X-QQ-SSF: 00400000000000N0P000000A0000000
X-QQ-FEAT: s01D3h/9FXYh4W0MAf49kRxJWgAu+k/epHRPyiX+nn5pNMlYpihhL36hDWcJQ
        weKBfkrmGkF2JTyH1KgiRB90NZhk8fwXHq1q7rKgXkj0PtJVFlX8S9ecQFg/MaYbbgldA6L
        nS7gobF/t4CYJXLBfitPHiHkKD1KPtk+5CrvysDO29+HdKyXyvP6A8KU4chvsrUKbf6hyya
        gVDjHUpNCOE4kfGQiSP/G32mfllepGd/+h1hbm5Im1mLnpnfIFzpbTHI+iq5aM+iCmUaIUw
        UzI2FfTYn93dJVotIZ4OSepmT2LBuagff5TTGq1Rl0k/yYJ8WhYIVLTe1HbCaUN14kyaKNH
        7dAZ8zP1vTXme83B4sXRQyynmsslZyddZEcrhBRYe9YngrU3tdegdz9xbRnhZG6MiAt2/rx
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.51\))
Subject: Re: [PATCH net-next] net: wangxun: Implement the ndo change mtu
 interface
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com>
Date:   Mon, 20 Feb 2023 15:49:35 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <6BD03026-1958-41CD-92F7-CA629749D7CD@net-swift.com>
References: <20230216084413.10089-1-mengyuanlou@net-swift.com>
 <fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
X-Mailer: Apple Mail (2.3731.300.51)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年2月17日 01:38，Alexander Lobakin <aleksander.lobakin@intel.com> 写道：
> 
> From: Mengyuan Lou <mengyuanlou@net-swift.com>
> Date: Thu, 16 Feb 2023 16:44:13 +0800
> 
>> Add ngbe and txgbe ndo_change_mtu support.
>> 
>> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
>> ---
>> drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 +
>> drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 38 ++++++++++++++++++-
>> drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  1 -
>> .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 38 ++++++++++++++++++-
>> .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 -
>> 5 files changed, 76 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> index 77d8d7f1707e..2b9efd13c500 100644
>> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> @@ -300,6 +300,8 @@
>> #define WX_MAX_RXD                   8192
>> #define WX_MAX_TXD                   8192
>> 
>> +#define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
> 
> Please use tabs.
> 
>> +
>> /* Supported Rx Buffer Sizes */
>> #define WX_RXBUFFER_256      256    /* Used for skb receive header */
>> #define WX_RXBUFFER_2K       2048
>> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
>> index 5b564d348c09..78bfaff02aad 100644
>> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
>> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
>> @@ -361,6 +361,15 @@ static void ngbe_up(struct wx *wx)
>> phy_start(wx->phydev);
>> }
>> 
>> +static void ngbe_reinit_locked(struct wx *wx)
>> +{
>> + /* prevent tx timeout */
>> + netif_trans_update(wx->netdev);
> 
> Why doing this? Your driver/device can reload for longer than 5 seconds
> (default Tx timeout) or...?
> 
>> + ngbe_down(wx);
>> + wx_configure(wx);
>> + ngbe_up(wx);
>> +}
>> +
>> /**
>>  * ngbe_open - Called when a network interface is made active
>>  * @netdev: network interface device structure
>> @@ -435,6 +444,32 @@ static int ngbe_close(struct net_device *netdev)
>> return 0;
>> }
>> 
>> +/**
>> + * ngbe_change_mtu - Change the Maximum Transfer Unit
>> + * @netdev: network interface device structure
>> + * @new_mtu: new value for maximum frame size
>> + *
>> + * Returns 0 on success, negative on failure
>> + **/
>> +static int ngbe_change_mtu(struct net_device *netdev, int new_mtu)
>> +{
>> + int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> 
> You must also account `2 * VLAN_HLEN`. The difference between MTU and
> frame size is `ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN`, i.e. 26 bytes.
> ...except for if your device doesn't handle VLANs, but I doubt so.

The code to support vlan has not been added, so VLAN_HLEN is not considered for now.
> 
>> + struct wx *wx = netdev_priv(netdev);
>> +
>> + if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
>> + return -EINVAL;
> 
> (Andrew already said that...)
> 
>> +
>> + netdev_info(netdev, "Changing MTU from %d to %d.\n",
>> +     netdev->mtu, new_mtu);
> 
> As Andrew already said, it's netdev_dbg() at most, but TBH I consider
> this a development-time-only-debug-message that shouldn't go into the
> release code.
> 
>> +
>> + /* must set new MTU before calling down or up */
>> + netdev->mtu = new_mtu;
> 
> If you look at the default implementation, you'll see that netdev->mtu
> must now be accessed using READ_ONCE()/WRITE_ONCE(), so please change
> accordingly. Otherwise there can be race around this field and you'll
> get some unexpected results some day.
> 
>> + if (netif_running(netdev))
>> + ngbe_reinit_locked(wx);
>> +
>> + return 0;
>> +}
>> +
>> static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
>> {
>> struct wx *wx = pci_get_drvdata(pdev);
>> @@ -470,6 +505,7 @@ static void ngbe_shutdown(struct pci_dev *pdev)
>> static const struct net_device_ops ngbe_netdev_ops = {
>> .ndo_open               = ngbe_open,
>> .ndo_stop               = ngbe_close,
>> + .ndo_change_mtu         = ngbe_change_mtu,
>> .ndo_start_xmit         = wx_xmit_frame,
>> .ndo_set_rx_mode        = wx_set_rx_mode,
>> .ndo_validate_addr      = eth_validate_addr,
>> @@ -562,7 +598,7 @@ static int ngbe_probe(struct pci_dev *pdev,
>> netdev->priv_flags |= IFF_SUPP_NOFCS;
>> 
>> netdev->min_mtu = ETH_MIN_MTU;
>> - netdev->max_mtu = NGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
>> + netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
> 
> Same regarding frame size vs MTU.
> Also, these braces are redundant.
> 
>> 
>> wx->bd_number = func_nums;
>> /* setup the private structure */
>> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
>> index a2351349785e..373d5af628cd 100644
>> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
>> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
>> @@ -137,7 +137,6 @@ enum NGBE_MSCA_CMD_value {
>> #define NGBE_RX_PB_SIZE 42
>> #define NGBE_MC_TBL_SIZE 128
>> #define NGBE_TDB_PB_SZ (20 * 1024) /* 160KB Packet Buffer */
>> -#define NGBE_MAX_JUMBO_FRAME_SIZE 9432 /* max payload 9414 */
>> 
>> /* TX/RX descriptor defines */
>> #define NGBE_DEFAULT_TXD 512 /* default ring size */
>> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
>> index 6c0a98230557..0b09f982a2c8 100644
>> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
>> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> For the second driver, the questions are the same.
> 
> Thanks,
> Olek


