Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936053D8F0B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhG1N3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:29:25 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:46916 "EHLO
        zzt.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236285AbhG1N3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:29:24 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2021 09:29:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GGQUJX01/qHxOH0HY6+f9UrSmlNedb2EpkrQPamkdW4=; b=mHclIhp8yG+1uvz3pLOXQoGITn
        OlyEbwAS2VQ5Nkw6nCnshS1sbQTcScn5e8ed4Hic33pwEwrUImkE6co3SdMyZi87hpFZn0SZTkt9R
        g7isgBlPwmEaRSnezGlh0qydPH0eY2cUAYxqqrAKICQYTuYChSqp/OsVhuWhuKrJ3BcE=;
Received: from 212-39-89-108.ip.btc-net.bg ([212.39.89.108] helo=carbon)
        by zzt.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1m8jCe-0007Ds-3w; Wed, 28 Jul 2021 16:02:29 +0300
Date:   Wed, 28 Jul 2021 16:02:24 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v3 14/31] net: usb: use ndo_siocdevprivate
Message-ID: <YQFVYN1yv8oJotEl@carbon>
Mail-Followup-To: Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org
References: <20210727134517.1384504-1-arnd@kernel.org>
 <20210727134517.1384504-15-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727134517.1384504-15-arnd@kernel.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zzt.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-07-27 15:45:00, Arnd Bergmann wrote: > From: Arnd Bergmann
    <arnd@arndb.de> > > The pegasus and rtl8150 drivers use SIOCDEVPRIVATE ioctls
    > to access their MII registers, in place of the normal > [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-07-27 15:45:00, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The pegasus and rtl8150 drivers use SIOCDEVPRIVATE ioctls
> to access their MII registers, in place of the normal
> commands. This is broken for all compat ioctls today.
> 
> Change to ndo_siocdevprivate to fix it.

Well, ACK i guess... :)


		Petko


> Cc: Petko Manolov <petkan@nucleusys.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/usb/pegasus.c | 5 +++--
>  drivers/net/usb/rtl8150.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..0475ef0efdca 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -987,7 +987,8 @@ static const struct ethtool_ops ops = {
>  	.set_link_ksettings = pegasus_set_link_ksettings,
>  };
>  
> -static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
> +static int pegasus_siocdevprivate(struct net_device *net, struct ifreq *rq,
> +				  void __user *udata, int cmd)
>  {
>  	__u16 *data = (__u16 *) &rq->ifr_ifru;
>  	pegasus_t *pegasus = netdev_priv(net);
> @@ -1245,7 +1246,7 @@ static int pegasus_resume(struct usb_interface *intf)
>  static const struct net_device_ops pegasus_netdev_ops = {
>  	.ndo_open =			pegasus_open,
>  	.ndo_stop =			pegasus_close,
> -	.ndo_do_ioctl =			pegasus_ioctl,
> +	.ndo_siocdevprivate =		pegasus_siocdevprivate,
>  	.ndo_start_xmit =		pegasus_start_xmit,
>  	.ndo_set_rx_mode =		pegasus_set_multicast,
>  	.ndo_tx_timeout =		pegasus_tx_timeout,
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 7656f2a3afd9..4a1b0e0fc3a3 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -822,7 +822,8 @@ static const struct ethtool_ops ops = {
>  	.get_link_ksettings = rtl8150_get_link_ksettings,
>  };
>  
> -static int rtl8150_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
> +static int rtl8150_siocdevprivate(struct net_device *netdev, struct ifreq *rq,
> +				  void __user *udata, int cmd)
>  {
>  	rtl8150_t *dev = netdev_priv(netdev);
>  	u16 *data = (u16 *) & rq->ifr_ifru;
> @@ -850,7 +851,7 @@ static int rtl8150_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
>  static const struct net_device_ops rtl8150_netdev_ops = {
>  	.ndo_open		= rtl8150_open,
>  	.ndo_stop		= rtl8150_close,
> -	.ndo_do_ioctl		= rtl8150_ioctl,
> +	.ndo_siocdevprivate	= rtl8150_siocdevprivate,
>  	.ndo_start_xmit		= rtl8150_start_xmit,
>  	.ndo_tx_timeout		= rtl8150_tx_timeout,
>  	.ndo_set_rx_mode	= rtl8150_set_multicast,
> -- 
> 2.29.2
> 
> 
