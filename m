Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE83406FAD
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhIJQcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIJQcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:32:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B62C061756;
        Fri, 10 Sep 2021 09:31:03 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id h16so5167993lfk.10;
        Fri, 10 Sep 2021 09:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ot1wSZknEFAuaHQCHHkAEUFlBeAHkhZrdgLFIvcXlmk=;
        b=YQrbyos8oQHIQq79OeYPJpMki7YOoCkZuXxuwup0PtJKdXZmTeX2Ci7KCOEzz31nVA
         o8p+ItoM3f2yfB/8cH6Js/dPSNABYFBbfZJo6lfd5MLvvHXfJ7EFvAA+GE1xn/NCXsxj
         Z4TxCOgs8S4jGIQg34rKT+Qtf2hxKr5FOY1k3eM+h1ekEnkvN/1FdUVsUBEHHyC3XizW
         1brftKIg0TGz3Ag5M6jVYtfWacjHW0llc/n5PqG+04po2N3/0ZG1Ho9T5msccZiHDhIG
         lncKCv8jljzHAbU1PNwS7i13AikiVRMCl8gtaahmUSd3zY2W/VQ9HSczX2wEFp7SVZ9l
         X1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ot1wSZknEFAuaHQCHHkAEUFlBeAHkhZrdgLFIvcXlmk=;
        b=Q1aVieLXw0UQ6tb/G72dx3yVN1g3wMHejD7+t3Gm8YmIcmVdiVKMiGJo4bchSUJr/8
         V+0w04o4FDp9GjXoH4EJxF+WKLMLjatm6h1vTWmOCQyLXShf93qnEZ07MbFiF59n7TZK
         Ndvf+0jO07SQUUoore2vxn1G/Y1og5wUjhJq9NYqi2522kwSXqp1KfNEirYayXV/HDuV
         u8BQbF7/l73MpqrIGNlDJLHT/L7YFX4pZaPADHR1/sW22tc7AbDHl9cC92B8YZ8Gq8jB
         vNr/ZsrquAczjspRrBfEoLqV0Q9o5aSbUjrVm/BUr87ez/AfVp2yu+GUIzJZ3AUXpX4f
         vubw==
X-Gm-Message-State: AOAM5311lVZbSF5AFEGAmCZWm5Jqn1pjKf3C0lq4eBtO390H0399uinM
        JY8bI/hZXTUvLk/MVFha3As=
X-Google-Smtp-Source: ABdhPJyLJq/n5tDgmoSNyoxi0vyV5yRV5AzjRZsVCyBwOC99pA8skIvBmgdquk/abLv14Sl6ZqR4Vw==
X-Received: by 2002:a05:6512:687:: with SMTP id t7mr4310506lfe.399.1631291462283;
        Fri, 10 Sep 2021 09:31:02 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id c19sm640666ljn.75.2021.09.10.09.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:31:01 -0700 (PDT)
Date:   Fri, 10 Sep 2021 19:31:00 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: do not send CAB while scanning
Message-ID: <20210910163100.n6ltzn543f2mnggy@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:04:35PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> During the scan requests, the Tx traffic is suspended. This lock is
> shared by all the network interfaces. So, a scan request on one
> interface will block the traffic on a second interface. This causes
> trouble when the queued traffic contains CAB (Content After DTIM Beacon)
> since this traffic cannot be delayed.
> 
> It could be possible to make the lock local to each interface. But It
> would only push the problem further. The device won't be able to send
> the CAB before the end of the scan.
> 
> So, this patch just ignore the DTIM indication when a scan is in
> progress. The firmware will send another indication on the next DTIM and
> this time the system will be able to send the traffic just behind the
> beacon.
> 
> The only drawback of this solution is that the stations connected to
> the AP will wait for traffic after the DTIM for nothing. But since the
> case is really rare it is not a big deal.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/sta.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> index a236e5bb6914..d901588237a4 100644
> --- a/drivers/staging/wfx/sta.c
> +++ b/drivers/staging/wfx/sta.c
> @@ -629,8 +629,18 @@ int wfx_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
>  
>  void wfx_suspend_resume_mc(struct wfx_vif *wvif, enum sta_notify_cmd notify_cmd)
>  {
> +	struct wfx_vif *wvif_it;
> +
>  	if (notify_cmd != STA_NOTIFY_AWAKE)
>  		return;
> +
> +	// Device won't be able to honor CAB if a scan is in progress on any
> +	// interface. Prefer to skip this DTIM and wait for the next one.

In one patch you drop // comments but you introduce some of your self.

> +	wvif_it = NULL;
> +	while ((wvif_it = wvif_iterate(wvif->wdev, wvif_it)) != NULL)
> +		if (mutex_is_locked(&wvif_it->scan_lock))
> +			return;
> +
>  	if (!wfx_tx_queues_has_cab(wvif) || wvif->after_dtim_tx_allowed)
>  		dev_warn(wvif->wdev->dev, "incorrect sequence (%d CAB in queue)",
>  			 wfx_tx_queues_has_cab(wvif));
> -- 
> 2.33.0
> 
