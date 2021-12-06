Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EA446A6CD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349468AbhLFU0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245450AbhLFU0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:26:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A81AC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:23:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so47711526eda.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 12:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ZyvlIwmv4ETcTninoCaP7q03plv31ZCt76oMZ6hi2I=;
        b=Wmn2r+hHSzVGAfAICaQuNBBiNMCSeUlZVBm5rPvv9nqK39dwpNba/qAkeOZphL70SP
         yoYaYMqqrBFosE13O7xQq5Q5fIkPogqjtGeu9YFwrb3jZ34OPm/Vb5TTXLyubbBS8rIO
         IB30xUMNr0kxrFaO2s58zdpN2/gbY2RHyyCjD9+V33QkhSyj3XALIPkr/acLKf0B2wWH
         2TCwNAdK6eOBUcdmrcp1LEbKGDquF4fwFzXZajV9sOJz2c5+ESkGjwFdHKKDByLT3Ht0
         /q9Y+QAGH3IbA/O3j13FFE5Ca9P7MW0PckuItpXj5r8qwNJUOH82MOnPpWNiyuncW2zx
         Gv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ZyvlIwmv4ETcTninoCaP7q03plv31ZCt76oMZ6hi2I=;
        b=L+UVDSSGsDHXpIlvYAgxvTMjY+Vsc+7jnjdjIffCJ8YqD0d0MpLOVMaBH/8j+TcbxB
         M7eaiv8IKk1M2CLJNiWlGO8F59+/txCb/rULp6xbAH1NGr0pppFKuC5a7+8APCKf03kw
         dfrmj4kfIkdWWLn+tMUbs3Q6IMJe4ox4cJemkV3/nXbH3TwJqduJu3upDNQf+d8foFe2
         yNvo3+nB35SzKJZB+geHRiVeiGSAVSIrosdI86Yy0ELxHl91v8WmCzU9jjJjPtcC/VAc
         kukKCXeK4HUOZNSkfKPt2qLWVpJY5qcIWafDFbroZcKO4Vm7oEW9btyR/SukhrEMkO3v
         UwQQ==
X-Gm-Message-State: AOAM530aOiXq74J6NYCvQhLJw5KxjGz0FVw7sDeXJgjxu8jA08mJyUrC
        xrFU9ugAHMZ0Ej16yU8SM5XjDLELW1Y=
X-Google-Smtp-Source: ABdhPJww/epgWVnLC0pQx3EdQCbU6/9WOjLHEyxrcCG8JaD/1SsHqUMcac7FpxjbxknZ/9Gsv/l+FA==
X-Received: by 2002:a17:907:160c:: with SMTP id hb12mr47546612ejc.460.1638822190006;
        Mon, 06 Dec 2021 12:23:10 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id w24sm7260271ejk.0.2021.12.06.12.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:23:09 -0800 (PST)
Date:   Mon, 6 Dec 2021 22:23:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206202308.xoutfymjozfyhhkl@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:07:45PM +0000, Russell King (Oracle) wrote:
> My conclusion from having read this thread is the CPU port is using PPU
> polling, meaning that in mac_link_up():
> 
>         if ((!mv88e6xxx_phy_is_internal(ds, port) &&
>              !mv88e6xxx_port_ppu_updates(chip, port)) ||
>             mode == MLO_AN_FIXED) {
> 
> is false - because mv88e6xxx_port_ppu_updates() returns true, and
> consequently we never undo this force-down.

We know that
1. A == mv88e6xxx_phy_is_internal(ds, port), B == mv88e6xxx_port_ppu_updates(chip, port), C == mode == MLO_AN_FIXED
2. (!A && !B) || C == false. This is due to the effect we observe: link is not forced up
2. C == false. This is due to the device tree.
3. !A && !B == false. This is due to statement (2), plus the rule that if X || Y == false and Y == false, then X must also be false.
4. We know that A is true, again due to device tree: port 4 < .num_internal_phys for MV88E6240 which is 5.
5. !A is false, due to 4.

So we have:

false && !B == false.

Therefore "!B" is "don't care". In other words we don't know whether
mv88e6xxx_port_ppu_updates() is true or not.
