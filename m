Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A911E23C96
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392379AbfETPxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:53:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34523 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389246AbfETPxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:53:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so6929305plz.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LEDUdN4h7CJGbK0Ho7cpn+GdpkHhGHnX5CljcvGCU28=;
        b=AknxJqb/SvO7MqGBjcbD3Q1MrhxlWuhNtNr6+if4RueqArvk0CaDdrnmY3fJWXn+PH
         Wn2By67kwExDmGrJuxC7i7lAiu4aN/Gz2pM2idLEHGiK7GGtEYl6CHQSTNJ2IOnixVBQ
         gWJsZCVndjFeXvUq19Aia0n/90IZ+u7MKhIOmjwui8Df4Ni1hlIGXOkJGeBC7890Rwhk
         oOuYKiFBQEa/i/MJLlJnmhoxupX3/STPHXewb5RJVCG/c2kAlGdZE6eYl808/W+er2wV
         N6R88Wh7JzsQBslYCC/s/0l9lWpc1RJmETX5OW7984KGJh242Z2qjx2xHDheH975Vv62
         vN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEDUdN4h7CJGbK0Ho7cpn+GdpkHhGHnX5CljcvGCU28=;
        b=rW/qj3fB+BsK6duYkGUe56OnX9Q9bz5Wk7aab6usSLPubkiP5Tf3ecNQOadPnrN9Qz
         T6cKkO3BtJHCYR5UR/zlhvouvzYVkCFxhnT+62qK8pH75iPM2UZwBghlgNDzifsUCXDb
         dB6S/SVXNH5fB/WPBHfi6tBHJ8lew2q7xJTaYMBYWy1iOjvzt4A+Xr9tZPRwVwnp0nPM
         pjVJ46XMkGkUyAjmnqcNrSW6jsqIcA+mX0R0YUJ7RBr6HlUqU5qU0Ih/GFuoeO8p+QaY
         DjspLBR/wYlWRZKG1BfkTPL9XZgB/y+zsfNsSlrVkMPRtE5se3B7aSTasiP3fbapsFGt
         LZAw==
X-Gm-Message-State: APjAAAWVRUtRhjhDb7AtnNAGQdaN+v6oZiHcDoAmCjSzrqOlA2Vw4Kh2
        TyTltq/WnaCch8pjhZPbatiz8A==
X-Google-Smtp-Source: APXvYqyh4/B+y5Lf+Lfk4HdOTVWT/2Awv4SRzSG/urGvGWOvhpdahEasiW01kKZGNmwbPY01L+UzvQ==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr77206034plk.109.1558367622948;
        Mon, 20 May 2019 08:53:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f5sm19798150pfn.161.2019.05.20.08.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 08:53:42 -0700 (PDT)
Date:   Mon, 20 May 2019 08:53:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190520085340.4f44ac8b@hermes.lan>
In-Reply-To: <20190520091105.GA2142@nanopsycho>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
        <20190519031046.4049-3-sthemmin@microsoft.com>
        <20190520091105.GA2142@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 May 2019 11:11:05 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
> >When a device is stacked like (team, bonding, failsafe or netvsc) the
> >XDP generic program for the parent device is not called.  In these
> >cases, the rx handler changes skb->dev to its own in the receive
> >handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
> >do_xdp_generic if necessary before starting another round.
> >
> >Review of all the places RX_HANDLER_ANOTHER is returned
> >show that the current devices do correctly change skb->dev.
> >
> >There was an older patch that got abandoned that did the
> >same thing, this is just a rewrite.
> >
> >Suggested-by: Jason Wang <jasowang@redhat.com>
> >Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
> >Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> >Acked-by: Jason Wang <jasowang@redhat.com>
> >---

> I'm always scarred of changes like this. The history tells us that this
> codepaths are very fragile. It took us non-trivial efford to fix bonding
> here, not to mention vlans (that was pain).
> 
> The reason for troubles was often fact that different flows were treated
> differently (vlan accel/non-accel).

Yes, this is a sensitive path. Another alternative is to fix it
inside each device (netvsc). That is what my earlier patch did and that
is what is being done now (probably will make it into the RHEL on Azure
drivers).
 
> This patch calls do_xdp_generic for master device in different point in
> the receive patch comparing to lower device. Would it be possible to
> unify this? E.g. by moving do_xdp_generice() call from
> netif_rx_internal()/netif_receive_skb_internal() here,
> to the beginning of __netif_receive_skb_core()?
> 

That could work, but has the question about doing XDP farther down
call stack (lower performance).

There is also the case what if both paths support XDP in driver.
This would be the ideal case, how would this work?


