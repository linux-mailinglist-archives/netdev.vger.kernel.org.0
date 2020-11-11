Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C744D2AF05F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKKMQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgKKMO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:14:28 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25298C0613D1;
        Wed, 11 Nov 2020 04:13:57 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0ABCD51q011582
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 11 Nov 2020 13:13:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1605096785; bh=F6fuXvLQJOEEVeBY/DaPjWmLGIVziSVanF0JahQDxrs=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=IAyI7unbG2/9h+dhvBaJ9v68/okm603f1+Wp09fw9LANUfBs/uymjoj1YP1kJMfXv
         wy7tTmQ0COT6FvHlxCIDyfRNgUbejBmwXDNYeILc7HAmKl5z5iRJKTX89ORkjiduVQ
         k2tkSNRuquO2rp0Itls0UHYZuAq4Ep+KmxggcM3E=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kcozn-00290H-Hj; Wed, 11 Nov 2020 13:13:03 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] net: usb: switch to dev_get_tstats64 and remove usbnet_get_stats64 alias
Organization: m
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
        <35569407-d028-ed00-bf2a-2fc572a938e9@gmail.com>
Date:   Wed, 11 Nov 2020 13:13:03 +0100
In-Reply-To: <35569407-d028-ed00-bf2a-2fc572a938e9@gmail.com> (Heiner
        Kallweit's message of "Tue, 10 Nov 2020 20:51:03 +0100")
Message-ID: <87mtzoqegg.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> Replace usbnet_get_stats64() with new identical core function
> dev_get_tstats64() in all users and remove usbnet_get_stats64().
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/usb/aqc111.c          | 2 +-
>  drivers/net/usb/asix_devices.c    | 6 +++---
>  drivers/net/usb/ax88172a.c        | 2 +-
>  drivers/net/usb/ax88179_178a.c    | 2 +-
>  drivers/net/usb/cdc_mbim.c        | 2 +-
>  drivers/net/usb/cdc_ncm.c         | 2 +-
>  drivers/net/usb/dm9601.c          | 2 +-
>  drivers/net/usb/int51x1.c         | 2 +-
>  drivers/net/usb/mcs7830.c         | 2 +-
>  drivers/net/usb/qmi_wwan.c        | 2 +-
>  drivers/net/usb/rndis_host.c      | 2 +-
>  drivers/net/usb/sierra_net.c      | 2 +-
>  drivers/net/usb/smsc75xx.c        | 2 +-
>  drivers/net/usb/smsc95xx.c        | 2 +-
>  drivers/net/usb/sr9700.c          | 2 +-
>  drivers/net/usb/sr9800.c          | 2 +-
>  drivers/net/wireless/rndis_wlan.c | 2 +-
>  include/linux/usb/usbnet.h        | 2 --
>  18 files changed, 19 insertions(+), 21 deletions(-)

For the qmi_wwan part:

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
