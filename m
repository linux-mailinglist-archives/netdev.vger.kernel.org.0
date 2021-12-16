Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47DA477CCB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241080AbhLPTuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbhLPTuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:50:00 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6056C061574;
        Thu, 16 Dec 2021 11:50:00 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id x32so57913ybi.12;
        Thu, 16 Dec 2021 11:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jv80TOkfa7cxx7XtLHqEOE19yIthxc/CjcWKoC88WJc=;
        b=lv9bgpCr+4ebulx465pm0uZU9BGzdf/8ag2oZ10Aymwf5hX2aexEyLHi2lo4YY4zca
         9Tq51VJ8biOUJ1QRqad4QWxpDZ9LRs0oWFS4VF4xWr3vKkantBPu3Aki/vjdpHD+hStk
         3YvkHnd8paOvU7GrzQJ/+EPM1p5dDtqoY9Du6JZ/Il5PbIbu30yfNZmLE4NzM5kSIy43
         sUHnq9BD7TpR3u7BT4OIf7WvZeh3A7m7w/9hEwO6+48pqwh2ugQ7hMrpcZGyPLkHpqAG
         W0p/6KEkqtecDPvw++oDkLnujyUFYqd5WP1Pr8skyooT56PyxbXpONNQkrlSRNDOqfSU
         ksMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jv80TOkfa7cxx7XtLHqEOE19yIthxc/CjcWKoC88WJc=;
        b=Mv/Ve2VTtilNtTvhp+/ihFbeOt8kXwtHnlDCFa43hJmf+cNKYc6F4xtBGweS3sbL7G
         Fuulxp5jqGUHVJhVq9wdsWrAEId+FtknuhkpcrXuRJ1rZP8+8bPkpuJ83tc2aMfvtGWj
         wuHvuuG6zBWYqMMGafEJhcCREdk5GM7rC5V9dE0XwXpFt8R6K28cg7iTsZiQPsjfetU6
         6/X4+R7p+wrcUKVq6QYRfZ1ys/lNKs2wGyhNHfzwRDMM8GNteDe/5bf3r3nbiK+EkF0+
         2an4mR5TNYbD98UUbNMn1M+sGfWZzjRrzzy9yoK7OvKDMnFT/0SBhLlqrMlemIAnOiQe
         gnrw==
X-Gm-Message-State: AOAM531LUUqJLwRc41hBMQ9tlytShYETtKGIwSWDRFIp799bubpwkUzc
        Z/d3IY1lsiMeYpugAJbrL8q1OMVjgA9CeoNFwuk=
X-Google-Smtp-Source: ABdhPJy28KtyL7QdNhV9aqLFvTdbBWZnj/mKsowyxeyKartXME6iWc860Tz3q3cQtEdxCyUDeP6V97DNK+Jssflkmus=
X-Received: by 2002:a25:ab6c:: with SMTP id u99mr15913664ybi.188.1639684199906;
 Thu, 16 Dec 2021 11:49:59 -0800 (PST)
MIME-Version: 1.0
References: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
 <20211216044839.v9.3.If37d23d1dd8b765d8a6c8eca71ac1c29df591565@changeid>
In-Reply-To: <20211216044839.v9.3.If37d23d1dd8b765d8a6c8eca71ac1c29df591565@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 16 Dec 2021 11:49:49 -0800
Message-ID: <CABBYNZKaD95hQcGJyUKiBrokbnjD6h4BUhm0cpm7HntVtQOG+A@mail.gmail.com>
Subject: Re: [PATCH v9 3/3] bluetooth: mgmt: Fix sizeof in mgmt_device_found()
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Dec 16, 2021 at 4:50 AM Manish Mandlik <mmandlik@google.com> wrote:
>
> Use correct sizeof() parameter while allocating skb.
>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
>
> (no changes since v8)
>
> Changes in v8:
> - New patch in the series.
>
>  net/bluetooth/mgmt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index c65247b5896c..5fd29bd399f1 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9709,7 +9709,7 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>
>         /* Allocate skb. The 5 extra bytes are for the potential CoD field */
>         skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
> -                            sizeof(ev) + eir_len + scan_rsp_len + 5);
> +                            sizeof(*ev) + eir_len + scan_rsp_len + 5);
>         if (!skb)
>                 return;
>
> --
> 2.34.1.173.g76aa8bc2d0-goog

There is already a patch addressing this:

https://patchwork.kernel.org/project/bluetooth/patch/20211213212650.2067066-1-luiz.dentz@gmail.com/

Please use that instead and if that works for you reply adding Tested-by.


-- 
Luiz Augusto von Dentz
