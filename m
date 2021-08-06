Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F1F3E31CC
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245560AbhHFWbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:31:43 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:18812 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245533AbhHFWbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 18:31:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628289086; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0kcZXm0e9gEDnSVvSQmVgxtocmMANDqGBxEaKyEClFE=;
 b=FryiNjSk5jYivewvzeI/K8V0NXb1yELKFUZLRkKv7bmI1thCjjOeZ43kr/S5OKRg2VFGcbU1
 8oyYsskkGwlhwVQry+uIBQ+XSjkJPEX6ptDy4pyY0LyH5CoV1PsboYnbHbwYyHyMxCL+buZ5
 IDE0sK1KEqX5l2gKmujLcNv6NkI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 610db814fedc920328a37e37 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 22:30:44
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3E603C43217; Fri,  6 Aug 2021 22:30:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69004C4338A;
        Fri,  6 Aug 2021 22:30:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Aug 2021 16:30:42 -0600
From:   subashab@codeaurora.org
To:     Aleksander Morgado <aleksander@aleksander.es>,
        =?UTF-8?Q?Bj=C3=B8rn_M?= =?UTF-8?Q?ork?= <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
 <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
 <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
Message-ID: <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That default fixed size you're suggesting for the rx_urb_size, isn't
> it supposed to have the same logical meaning as RMNET_MAX_PACKET_SIZE
> at the end?

RMNET_MAX_PACKET_SIZE is the maximum size for uplink. I probably should 
have
named it more clearly. We would need a different value for downlink.

>> Yes, I think it would be good to make the driver DTRT automatically.
>> Coding driver specific quirks into ModemManager might work, but it 
>> feels
>> wrong to work around a Linux driver bug. We don't have to do that.  We
>> can fix the driver.
>> Why can't we break the rx_urb_size dependency on MTU automatically 
>> when
>> pass_through or qmi_wwan internal muxing is enabled? Preferably with
>> some fixed default size which would Just Work for everyone.
>> 
> 

Would something like this work-

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6a2e4f8..c49827e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -75,6 +75,8 @@ struct qmimux_priv {
         u8 mux_id;
  };

+#define MAP_DL_URB_SIZE (32768)
+
  static int qmimux_open(struct net_device *dev)
  {
         struct qmimux_priv *priv = netdev_priv(dev);
@@ -303,6 +305,33 @@ static void qmimux_unregister_device(struct 
net_device *dev,
         dev_put(real_dev);
  }

+static int qmi_wwan_change_mtu(struct net_device *net, int new_mtu)
+{
+       struct usbnet *dev = netdev_priv(net);
+       struct qmi_wwan_state *info = (void *)&dev->data;
+       int old_rx_urb_size = dev->rx_urb_size;
+
+       /* mux and pass through modes use a fixed rx_urb_size and the 
value
+        * is independent of mtu
+        */
+       if (info->flags & (QMI_WWAN_FLAG_MUX | 
QMI_WWAN_FLAG_PASS_THROUGH)) {
+               if (old_rx_urb_size == MAP_DL_URB_SIZE)
+                       return 0;
+
+               if (old_rx_urb_size < MAP_DL_URB_SIZE) {
+                       usbnet_pause_rx(dev);
+                       usbnet_unlink_rx_urbs(dev);
+                       usbnet_resume_rx(dev);
+                       usbnet_update_max_qlen(dev);
+               }
+
+               return 0;
+       }
+
+       /* rawip mode uses existing logic of setting rx_urb_size based 
on mtu */
+       return usbnet_change_mtu(net, new_mtu);
+}
+
  static void qmi_wwan_netdev_setup(struct net_device *net)
  {
         struct usbnet *dev = netdev_priv(net);
@@ -326,7 +355,7 @@ static void qmi_wwan_netdev_setup(struct net_device 
*net)
         }

         /* recalculate buffers after changing hard_header_len */
-       usbnet_change_mtu(net, net->mtu);
+       qmi_wwan_change_mtu(net, net->mtu);
  }

  static ssize_t raw_ip_show(struct device *d, struct device_attribute 
*attr, char *buf)
@@ -433,6 +462,7 @@ static ssize_t add_mux_store(struct device *d,  
struct device_attribute *attr, c
         if (!ret) {
                 info->flags |= QMI_WWAN_FLAG_MUX;
                 ret = len;
+               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
         }
  err:
         rtnl_unlock();
@@ -514,6 +544,8 @@ static ssize_t pass_through_store(struct device *d,
         else
                 info->flags &= ~QMI_WWAN_FLAG_PASS_THROUGH;

+       qmi_wwan_change_mtu(dev->net, dev->net->mtu);
+
         return len;
  }

@@ -643,7 +675,7 @@ static const struct net_device_ops 
qmi_wwan_netdev_ops = {
         .ndo_stop               = usbnet_stop,
         .ndo_start_xmit         = usbnet_start_xmit,
         .ndo_tx_timeout         = usbnet_tx_timeout,
-       .ndo_change_mtu         = usbnet_change_mtu,
+       .ndo_change_mtu         = qmi_wwan_change_mtu,
         .ndo_get_stats64        = dev_get_tstats64,
         .ndo_set_mac_address    = qmi_wwan_mac_addr,
         .ndo_validate_addr      = eth_validate_addr,

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
