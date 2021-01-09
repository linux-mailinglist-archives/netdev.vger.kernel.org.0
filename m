Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0BA2F009F
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 16:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbhAIPKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 10:10:40 -0500
Received: from mout.gmx.net ([212.227.15.18]:36151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbhAIPKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 10:10:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1610204926;
        bh=gRQzTwTPdkA2nUI4fsS/KliTKJ50VqqDw/SPyxSJ1bM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=FpRAyloPHi6Vtqg6a1c1Nvvc0w3EgMHYuYpGcYYc5VWYnU9DMFbk0n29hrHWew2gy
         R3QiIBnbR5Owe1HIGGsspox7/Aq9KbY7r0suAUgUDJT8ytZp3MkJw9SS5Xe+FHfaNH
         azrW1+Q8LuDOYt113rK/qnTwrxA4v5YduCCf6QQ0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.208.239]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MLzFr-1kgJSx1U7V-00HwdG; Sat, 09
 Jan 2021 16:08:46 +0100
Date:   Sat, 9 Jan 2021 16:08:44 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in
 mwifiex_config_scan
Message-ID: <20210109160844.4ca73bf1@gmx.net>
In-Reply-To: <20201208124523.8169-1-ruc_zhangxiaohui@163.com>
References: <20201208124523.8169-1-ruc_zhangxiaohui@163.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:30xLTHRB14W9YJQR86cyrEg0JHGs+QTIYyIe0cq6j84p0arEcxj
 +Mov3HHLNZyED4eJhgtdlAjvon21l3NJaiQMmOmOvqhScVZ5wo7kY+P7xgalhWxR7OwfplP
 bW9eZau5EmpinE0gNQb0HHQPBQACyC+8+QIa8G29tXqNGc9b0HDz+o66Xtzis4yeFVzjz9c
 Y0AySjJGRHO+G8KEe7YsA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YK4qyXyFlTg=:PsMa08IRANayP2z91ijaWP
 ExlkyzB2VJtCZLEZDFStybz1cMRof9gIaai9TfhISG8YuaqeLaQ/+VsItNcswAQ+qyEjEfOZr
 7KcevDNZ3d5QZGYFcysPfztV6w7IlIGc4wKk5b423UM7OEsU08PebSi23wEs0joCF2lwmw+H8
 UN4fR/jVqdvhgGmisYcPy7hQxJIDHB3BO3BTAoOfJrb1rDrz9qJwugMHRKjmg2oz3R8L5c2VU
 07zrbGBm9QZQOJ4DaHg6R199efV+FGxGNVqX38BJ8XKlv7FajEjawkoJonG4H22osYaMofKb4
 +Lns3gJB7i0zSrp46lAZk+doUAlmGoYpE7Hs1ptVByvLFja3Z+Jx30VfDKsZJ+4wHD1SS692v
 EQD64Csu9fBLim1stBKt1OCRqwH76QOguiunSwKfib4DCCK7mHywK87UsbfQRMVsgnP2ei86d
 6hIaWaxQcfDb03NGGsbSJDtnIbF4ubi7ToF6C9g8FVkgiqEG3+usG3X393n4YLLz9DPnMT0BM
 ye06uO2AtK2E7sXQFRswq/thzAl5nN44FqHIOlPLlMuKq+tHbHeTdiKCJb008SSXf7petmfM+
 U2kMzXmqMqf44CltqDvkzN9UTVdVXaXjtmwsNhsOJEfFEFMVTVt1pOIJ7qa3Zzy9HHTHBkn1a
 lO5rtnKvFr0CxXyCfnhtaMf26/pmeUafr6fiGwwTIxZVMOJRdMZ43eAVgjQOlVU+18Od51Fxk
 XyNA15gkllSJB9rjXq7MdV8cQkKEXfX1KVsPoz65QYoy22ET7ThBM6sagmJpgyetAE8+ht0sN
 4Q6xZr+6PQ95ROBn0UKfbXK0wM83oscmXy0bskRbFWdIHCWtAn2XKbCm6YGRaeGkVLCaufTff
 ok5cX1mculOVvwtxzf4w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Zhang,

On Tue,  8 Dec 2020 20:45:23 +0800, Xiaohui Zhang <ruc_zhangxiaohui@163.co=
m> wrote:

> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> mwifiex_config_scan() calls memcpy() without checking
> the destination size may trigger a buffer overflower,
> which a local user could use to cause denial of service
> or the execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().
>
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/w=
ireless/marvell/mwifiex/scan.c
> index c2a685f63..b1d90678f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -930,6 +930,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>  				    "DIRECT-", 7))
>  				wildcard_ssid_tlv->max_ssid_length =3D 0xfe;
>
> +			if (ssid_len > 1)
> +				ssid_len =3D 1;

Why do your believe the available size is only '1'? A SSID is expected
to be of size IEEE80211_MAX_SSID_LE/32 and the wildcard_ssid_tlv pointer
is casted from tlv_pos (some lines above) which is a pointer/index into
scan_cfg_out->tlv_buf...

And the define (line 44) indicates there should be enough space for a SSID=
:

  42 /* Memory needed to store a max number/size WildCard SSID TLV for a f=
irmware
  43         scan */
  44 #define WILDCARD_SSID_TLV_MAX_SIZE  \
  45         (MWIFIEX_MAX_SSID_LIST_LENGTH *                              =
   \
  46                 (sizeof(struct mwifiex_ie_types_wildcard_ssid_params)=
   \
  47                         + IEEE80211_MAX_SSID_LEN))

For sure something to improve here instead of using a confusing 'u8 ssid[1=
]'
in struct mwifiex_ie_types_wildcard_ssid_params...

Regards,
Peter

>  			memcpy(wildcard_ssid_tlv->ssid,
>  			       user_scan_in->ssid_list[i].ssid, ssid_len);
>

