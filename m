Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6A3C9F2C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhGONPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhGONPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 09:15:49 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6B9C06175F;
        Thu, 15 Jul 2021 06:12:54 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so6040278wms.0;
        Thu, 15 Jul 2021 06:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i5BqZo+UJii6eVoVtrvlFBm02AdZ6ngSZGRnTQ9knW0=;
        b=Q5wPxqWuyRTCvaA4qSWrVpkXPVblBrXMdEmusZz0L4K4OoH3J00/VnCLF5UkLwFuxc
         /ym+2Z5r+nFS4JaFkIPtdFcgKWyIr/KOwpQ983k87dwKrJlb7zzPOJWiiTcKVBmakMun
         kr+7zEktxOIzyaEVcqbbKcNL2eDhNR4LPqEr0zyhU+IsMei34ydapf1pZGMSooKIHV7+
         q+bkC7OZXWjU/cHx2Vzc9+Z7fFMrMPrjo/ZMcvZODt7yLQA7esgNm4zb+I2zxYQGr7wP
         tokrmlPnTN//zTH/j+e/UPP1h41qvfk5cyrMO1A3GQ3liB7OW7IQAt9GG18rpJWUOuDD
         /ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i5BqZo+UJii6eVoVtrvlFBm02AdZ6ngSZGRnTQ9knW0=;
        b=pFJd1eo2x1bjcPBw1uuX+eK7R/2moqxhUxBeHaPBToHgqvgcVZb1dFVS9rO8H/Xxzi
         hpZOKlAyRURL6cUqSEY9jq1YwHIJg/vj0ymTCW+zr/ihM93lISn0IjSpsLNgYwEheL9T
         qMHR8EW9FDgIq/okFCMdeVKlQ6cowc9/FyaXSFlKiGUxnyVdhPEY0gYJerpbL1KflwZX
         rZJUGzNLk8YyYLesLqHSbCGOFXrH4t8q08sK17WLYwJDDcIrzyfNQM5JtUKs5tJwgHuj
         JoNGsm2BFNcI5HQUQlboEwKk37/wq1yTCkj4zKiW0Nb2T5dKrpoL2HDy9Orevt9xcZZG
         zArA==
X-Gm-Message-State: AOAM531NjGMmHJbpxHbGL7nKVmoHWx6DuEpDnPCrl/NvqM4oqsO8k0rx
        5epYTSMfB3lWvPGRh4ZuYq4=
X-Google-Smtp-Source: ABdhPJx5lVW/56Yyl02hf1vj7XesE1yFC5JK6ae9CjLhh3fUwpB+7mnQ7V50HwlHFjpCmKUWsfl/Dg==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr10731754wmq.40.1626354773280;
        Thu, 15 Jul 2021 06:12:53 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id v30sm7092964wrv.85.2021.07.15.06.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:12:52 -0700 (PDT)
Date:   Thu, 15 Jul 2021 16:12:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210715131251.zhtcsjkat267yrtl@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
 <20210715114908.ripblpevmdujkf2m@skbuf>
 <trinity-0dbbc59b-1e7d-4f58-8611-adb281a82477-1626354270982@3c-app-gmx-bap31>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-0dbbc59b-1e7d-4f58-8611-adb281a82477-1626354270982@3c-app-gmx-bap31>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 03:04:31PM +0200, Lino Sanfilippo wrote:
> Please note that skb_put() asserts that the SKB is linearized. So I think we
> should rather clear both NETIF_F_FRAGLIST and NETIF_F_SG unconditionally since also
> header taggers use some form of skb_put() dont they?

The tail taggers use skb_put() as part of the routine to make room for
the tail tag.

Some of the header taggers use __skb_put_padto() when the packets are
too small (under ETH_ZLEN). When they are so small they are definitely
linear already.

We don't have a third form/use of skb_put().
