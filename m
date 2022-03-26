Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB574E80A7
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 12:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiCZLtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 07:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiCZLtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 07:49:49 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769B054BEE;
        Sat, 26 Mar 2022 04:48:10 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id v206so10937843vsv.2;
        Sat, 26 Mar 2022 04:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=0357D2656UqVu+SigEjrjLvK0gyy4ZPxAxjcYc40Zyg=;
        b=gkR9i45V4b44i7GD8hJ/uSI3yMSrPJD74UNN2AkKju2fcF93JCUh0SXgUGEl19yaxM
         pZ5+V/h2PiLDrWTAo7DrC8IFvHYEOQj1ZmucCk3v3ZeJfy34DJfmxuJ0W3Yf5p2GHxXd
         K6OcN01WPt67WWikQCllAmE0mwbq8orN0A+DKhPAh5r7Z/H5qay08WEbeTte7Z6+Lldq
         2/abHVXjYRs3UT452OpU900lISBZHh7TZv0nWRcVapUzUDxgfRunWSE2++f8PIOnTjXr
         oeNdBZ3ru/gYUmrEd8Wu9n8x2iVnmswPf65cC7dgqNIuEcSn8UXZtd963wHCljvrYcx7
         Foog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=0357D2656UqVu+SigEjrjLvK0gyy4ZPxAxjcYc40Zyg=;
        b=5Awfsqm/6Ks74MZuB7tjVbP2bwWnE+f/dO76HvD9B9qD/A7WYXI5Gtm4VdEWcIK9t0
         tFEE6YuWaS0p3gw6cArAjkFEvFpcuSTvGsrre24fzdShZMTMIqh9tDWyTzkN0WmhN+/e
         8vsf8LkiIfweJ02Sf9OthvQ3KGWa9dwbd3VkMtFUUY+N+vOrHbifXwjsnRhAuis8saB4
         p9BlwTCKSfgYEcPzc5qSAsQaRFSbU/YVHjl5KPYfOONEacTpvk0YQkss2MOqb/wvQcC0
         IKDXmIDJypNqw8UBgwSZFBcBD6zvpQxpkj+BoGQbb3G1ZHQYLM2JgKfi4OH7gGL/ojaz
         LcIw==
X-Gm-Message-State: AOAM531CKaD4wLFXKPe6vhwxhTjheOjcCzylmv5/Pf4kjiKgPqO2cwB5
        8CNg0PCtFdvJH/4iTeXQmLGgLuCPQNZgiZHlAoA=
X-Google-Smtp-Source: ABdhPJzjIvvZ2bcyj9RQgKt5WYOWrV3j+6/s0p/JcKHqxNJbc3n95gh3jRkTR0rSAmL47itMrZcHXHiAfoBBLeCBYHU=
X-Received: by 2002:a05:6102:41a9:b0:320:c372:e79f with SMTP id
 cd41-20020a05610241a900b00320c372e79fmr6755002vsb.86.1648295289522; Sat, 26
 Mar 2022 04:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAAZOf27PHWxdZifZpQYfTHb3h=qk22jRc6-A2LvBkLTR6xNOKg@mail.gmail.com>
In-Reply-To: <CAAZOf27PHWxdZifZpQYfTHb3h=qk22jRc6-A2LvBkLTR6xNOKg@mail.gmail.com>
From:   David Kahurani <k.kahurani@gmail.com>
Date:   Sat, 26 Mar 2022 14:47:58 +0300
Message-ID: <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in ax88179_led_setting
To:     davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, phil@philpotter.co.uk,
        syzkaller-bugs@googlegroups.com,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        arnd@arndb.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same here. My apologies.

On Sat, Mar 26, 2022 at 2:28 PM David Kahurani <k.kahurani@gmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit: 85cfd6e539bd kmsan: core: delete kmsan_gup_pgd_range()
> git tree: https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=12d6c53c700000
> kernel config: https://syzkaller.appspot.com/x/.config?x=b9807dd5b044fd7a
> dashboard link: https://syzkaller.appspot.com/bug?extid=d3dbdf31fbe9d8f5f311
> compiler: clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
>
> Based off a previous patch to fix a similar issue.
> -------------------------
>
> From: David Kahurani <k.kahurani@gmail.com>
> Date: Sat, 26 Mar 2022 14:19:47 +0300
> Subject: [PATCH] net: ax88179: add proper error handling of usb read errors
>
> ax88179_178a 2-1:0.35 (unnamed net_device) (uninitialized): Failed to read reg index 0x0001: -71
> ax88179_178a 2-1:0.35 (unnamed net_device) (uninitialized): Failed to read reg index 0x0002: -71
> =====================================================
> BUG: KMSAN: uninit-value in ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
> BUG: KMSAN: uninit-value in ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
>  ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
>  ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
>  ax88179_bind+0xe75/0x1990 drivers/net/usb/ax88179_178a.c:1411
>  usbnet_probe+0x1284/0x4140 drivers/net/usb/usbnet.c:1747
>  usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
>  really_probe+0x67d/0x1510 drivers/base/dd.c:596
>  __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
>  driver_probe_device drivers/base/dd.c:781 [inline]
>  __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
>  bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
>  __device_attach+0x593/0x8e0 drivers/base/dd.c:969
>  device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
>  bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
>  device_add+0x1d3e/0x2400 drivers/base/core.c:3394
>  usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
>  usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
>  usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
>  really_probe+0x67d/0x1510 drivers/base/dd.c:596
>  __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
>  driver_probe_device drivers/base/dd.c:781 [inline]
>  __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
>  bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
>  __device_attach+0x593/0x8e0 drivers/base/dd.c:969
>  device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
>  bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
>  device_add+0x1d3e/0x2400 drivers/base/core.c:3394
>  usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2563
>  hub_port_connect drivers/usb/core/hub.c:5353 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
>  port_event drivers/usb/core/hub.c:5643 [inline]
>  hub_event+0x5ad2/0x8910 drivers/usb/core/hub.c:5725
>  process_one_work+0xdb9/0x1820 kernel/workqueue.c:2298
>  process_scheduled_works kernel/workqueue.c:2361 [inline]
>  worker_thread+0x1735/0x21f0 kernel/workqueue.c:2447
>  kthread+0x721/0x850 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30
>
> Local variable eeprom.i created at:
>  ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1045 [inline]
>  ax88179_led_setting+0x2e2/0x30b0 drivers/net/usb/ax88179_178a.c:1168
>  ax88179_bind+0xe75/0x1990 drivers/net/usb/ax88179_178a.c:1411
>
> CPU: 1 PID: 13457 Comm: kworker/1:0 Not tainted 5.16.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> =====================================================
>
> Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> Reported-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
> ---
>  drivers/net/usb/ax88179_178a.c | 181 +++++++++++++++++++++++++++------
>  1 file changed, 152 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index a31098981..932e21a65 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -224,9 +224,12 @@ static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>   ret = fn(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>   value, index, data, size);
>
> - if (unlikely(ret < 0))
> + if (unlikely(ret < size)) {
> +        ret = ret < 0 ? ret : -ENODATA;
> +
>   netdev_warn(dev->net, "Failed to write reg index 0x%04x: %d\n",
>      index, ret);
> + }
>
>   return ret;
>  }
> @@ -290,8 +293,8 @@ static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
>   return ret;
>  }
>
> -static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -    u16 size, void *data)
> +static int __must_check ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value,
> +                                         u16 index, u16 size, void *data)
>  {
>   int ret;
>
> @@ -354,8 +357,15 @@ static int ax88179_mdio_read(struct net_device *netdev, int phy_id, int loc)
>  {
>   struct usbnet *dev = netdev_priv(netdev);
>   u16 res;
> + int ret;
> +
> + ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
> + return ret;
> + }
>
> - ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
>   return res;
>  }
>
> @@ -951,23 +961,45 @@ static int
>  ax88179_set_features(struct net_device *net, netdev_features_t features)
>  {
>   u8 tmp;
> + int ret;
>   struct usbnet *dev = netdev_priv(net);
>   netdev_features_t changed = net->features ^ features;
>
>   if (changed & NETIF_F_IP_CSUM) {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL,
> +       1, 1, &tmp);
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
> +   ret);
> + return ret;
> + }
> +
>   tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
>   }
>
>   if (changed & NETIF_F_IPV6_CSUM) {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL,
> +       1, 1, &tmp);
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
> +   ret);
> + return ret;
> + }
> +
>   tmp ^= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
>   }
>
>   if (changed & NETIF_F_RXCSUM) {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL,
> +       1, 1, &tmp);
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
> +   ret);
> + return ret;
> + }
> +
>   tmp ^= AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
>         AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
> @@ -980,19 +1012,36 @@ static int ax88179_change_mtu(struct net_device *net, int new_mtu)
>  {
>   struct usbnet *dev = netdev_priv(net);
>   u16 tmp16;
> + int ret;
>
>   net->mtu = new_mtu;
>   dev->hard_mtu = net->mtu + net->hard_header_len;
>
>   if (net->mtu > 1500) {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
> - 2, 2, &tmp16);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC,
> +       AX_MEDIUM_STATUS_MODE,
> +       2, 2, &tmp16);
> + if (ret < 0){
> + netdev_dbg(dev->net,
> +   "Failed to read MEDIUM_STATUS_MODE %d\n",
> +   ret);
> + return ret;
> + }
> +
>   tmp16 |= AX_MEDIUM_JUMBO_EN;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
>    2, 2, &tmp16);
>   } else {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
> - 2, 2, &tmp16);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC,
> +               AX_MEDIUM_STATUS_MODE,
> +       2, 2, &tmp16);
> + if (ret < 0){
> + netdev_dbg(dev->net,
> +   "Failed to read MEDIUM_STATUS_MODE %d\n",
> +   ret);
> + return ret;
> + }
> +
>   tmp16 &= ~AX_MEDIUM_JUMBO_EN;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
>    2, 2, &tmp16);
> @@ -1045,6 +1094,7 @@ static int ax88179_check_eeprom(struct usbnet *dev)
>   u8 i, buf, eeprom[20];
>   u16 csum, delay = HZ / 10;
>   unsigned long jtimeout;
> + int ret;
>
>   /* Read EEPROM content */
>   for (i = 0; i < 6; i++) {
> @@ -1060,8 +1110,15 @@ static int ax88179_check_eeprom(struct usbnet *dev)
>
>   jtimeout = jiffies + delay;
>   do {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> - 1, 1, &buf);
> +    ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> +   1, 1, &buf);
> +
> +    if (ret < 0) {
> +    netdev_dbg(dev->net,
> +       "Failed to read SROM_CMD: %d\n",
> +               ret);
> +    return ret;
> +    }
>
>   if (time_after(jiffies, jtimeout))
>   return -EINVAL;
> @@ -1149,12 +1206,19 @@ static int ax88179_convert_old_led(struct usbnet *dev, u16 *ledvalue)
>
>  static int ax88179_led_setting(struct usbnet *dev)
>  {
> + int ret;
>   u8 ledfd, value = 0;
>   u16 tmp, ledact, ledlink, ledvalue = 0, delay = HZ / 10;
>   unsigned long jtimeout;
>
>   /* Check AX88179 version. UA1 or UA2*/
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1, &value);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1, &value);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read GENERAL_STATUS: %d\n",
> +   ret);
> + return ret;
> + }
>
>   if (!(value & AX_SECLD)) { /* UA1 */
>   value = AX_GPIO_CTRL_GPIO3EN | AX_GPIO_CTRL_GPIO2EN |
> @@ -1178,20 +1242,40 @@ static int ax88179_led_setting(struct usbnet *dev)
>
>   jtimeout = jiffies + delay;
>   do {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> - 1, 1, &value);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> +       1, 1, &value);
> + if (ret < 0){
> + netdev_dbg(dev->net,
> +   "Failed to read SROM_CMD: %d\n",
> +   ret);
> + return ret;
> + }
>
>   if (time_after(jiffies, jtimeout))
>   return -EINVAL;
>
>   } while (value & EEP_BUSY);
>
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
>   1, 1, &value);
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read SROM_DATA_HIGH: %d\n",
> +   ret);
> + return ret;
> + }
> +
> +
>   ledvalue = (value << 8);
>
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
> - 1, 1, &value);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
> +       1, 1, &value);
> +
> + if (ret < 0) {
> + netdev_dbg(dev->net, "Failed to read SROM_DATA_LOW: %d",
> +   ret);
> + return ret;
> + }
> +
>   ledvalue |= value;
>
>   /* load internal ROM for defaule setting */
> @@ -1213,12 +1297,22 @@ static int ax88179_led_setting(struct usbnet *dev)
>   ax88179_write_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
>    GMII_PHYPAGE, 2, &tmp);
>
> - ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
> - GMII_LED_ACT, 2, &ledact);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
> +       GMII_LED_ACT, 2, &ledact);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
> + return ret;
> + }
>
> - ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
> + ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
>   GMII_LED_LINK, 2, &ledlink);
>
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
> + return ret;
> + }
> +
>   ledact &= GMII_LED_ACTIVE_MASK;
>   ledlink &= GMII_LED_LINK_MASK;
>
> @@ -1295,6 +1389,7 @@ static int ax88179_led_setting(struct usbnet *dev)
>  static void ax88179_get_mac_addr(struct usbnet *dev)
>  {
>   u8 mac[ETH_ALEN];
> + int ret;
>
>   memset(mac, 0, sizeof(mac));
>
> @@ -1303,8 +1398,12 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
>   netif_dbg(dev, ifup, dev->net,
>    "MAC address read from device tree");
>   } else {
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
>   ETH_ALEN, mac);
> +
> + if (ret < 0)
> + netdev_dbg(dev->net, "Failed to read NODE_ID: %d", ret);
> +
>   netif_dbg(dev, ifup, dev->net,
>    "MAC address read from ASIX chip");
>   }
> @@ -1572,6 +1671,7 @@ static int ax88179_link_reset(struct usbnet *dev)
>   u16 mode, tmp16, delay = HZ / 10;
>   u32 tmp32 = 0x40000000;
>   unsigned long jtimeout;
> + int ret;
>
>   jtimeout = jiffies + delay;
>   while (tmp32 & 0x40000000) {
> @@ -1581,7 +1681,13 @@ static int ax88179_link_reset(struct usbnet *dev)
>    &ax179_data->rxctl);
>
>   /*link up, check the usb device control TX FIFO full or empty*/
> - ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
> + ret = ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
> +
> + if (ret < 0) {
> + netdev_dbg(dev->net, "Failed to read TX FIFO: %d\n",
> +   ret);
> + return ret;
> + }
>
>   if (time_after(jiffies, jtimeout))
>   return 0;
> @@ -1590,11 +1696,21 @@ static int ax88179_link_reset(struct usbnet *dev)
>   mode = AX_MEDIUM_RECEIVE_EN | AX_MEDIUM_TXFLOW_CTRLEN |
>         AX_MEDIUM_RXFLOW_CTRLEN;
>
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
> - 1, 1, &link_sts);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
> +       1, 1, &link_sts);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read LINK_STATUS: %d", ret);
> + return ret;
> + }
>
> - ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
> - GMII_PHY_PHYSR, 2, &tmp16);
> + ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
> +       GMII_PHY_PHYSR, 2, &tmp16);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
> + return ret;
> + }
>
>   if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
>   return 0;
> @@ -1732,9 +1848,16 @@ static int ax88179_reset(struct usbnet *dev)
>  static int ax88179_stop(struct usbnet *dev)
>  {
>   u16 tmp16;
> + int ret;
>
> - ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
> + ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
>   2, 2, &tmp16);
> +
> + if (ret < 0){
> + netdev_dbg(dev->net, "Failed to read STATUS_MODE: %d\n", ret);
> + return ret;
> + }
> +
>   tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
>   ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
>    2, 2, &tmp16);
> --
> 2.25.1
