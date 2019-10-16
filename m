Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F273DD9893
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbfJPRiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:38:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37406 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390469AbfJPRiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:38:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id u20so11609095plq.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 10:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=w7Ckq/LxQ3d6d7YYBCzcWPi1feQ60dLRf7cQPvCEhqo=;
        b=RajRDVwInrMkZw010+5WbKCh97lZZR8zlKYfcMvWu6Qaw823RVFFZDEk+g1eW3o2dt
         zwIX5ubRUcaaX1IsmogloK2MPrJOyEbvr7VtH04STFmKONS7jlPecBpDCZDI9z0CHnTC
         b0l1sR3g9uHLhYVfkCy3w7YRRPZ+TTsZ7jBXN4ZdDJBGFuvNYs5dyMIglHIH00KxVlkw
         0I6rHVkbqD0YujoyQmU1DsSS7kfQOiAUslXc84no2Q4VAP5yqB+7SwejktlpB3/d6qBQ
         7TWeSqRONXgsuwHXVlkiljBeHi7K9CkAJYV4SNE3skYVBMmZ5u1823hOjji9dmxhQLnl
         148w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w7Ckq/LxQ3d6d7YYBCzcWPi1feQ60dLRf7cQPvCEhqo=;
        b=fxEa89/PDyGJCLKT0Wl789TyOT3nRpGl5Wn6WasUIbuQbdCD0vVuh1WQW2JpwwxpYL
         jR2WelkJyuEbm7YKX29yP/nk/mraTPRkDPQUWcqXUUazmuc4gTkrd/tAZHj6pAClvPkd
         19cUFqhfeZe3g78uqi9MyXqwWkNdct/ftCUrhoPFsAKbrewr0JrdjwXmn8lYl1pi5bWV
         KQSXUlAU79AEJ7URff9hqdMjv5us03bewa1HkkU2gR+dYie0JkzNvX4GQZqBxxw/raV1
         r2BQGdzTJ8Bz17hblectcKhqPwm7Yet7go3Su1suHJowUCI8/eBm8LzJgt/IB9f7a34s
         DXWw==
X-Gm-Message-State: APjAAAUWIQ+QIOEf1vRQpNdoVSlqWZyC5p6UAevpTWvyuHicceOJ2bqj
        eT0WCKRMthBqFm1Yj+d0gUklJA==
X-Google-Smtp-Source: APXvYqwtBHxZgR00Q2Yn0ZnfFZxoy2/N+Bm4QyqqVaA3uzsnHpRyGeKpBGlUJRoAu6ZBqDkWWqmIJg==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr25087537plr.324.1571247498740;
        Wed, 16 Oct 2019 10:38:18 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id ep10sm11561976pjb.2.2019.10.16.10.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 10:38:18 -0700 (PDT)
Date:   Wed, 16 Oct 2019 10:38:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v10 4/6] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191016103813.24447c64@cakuba.netronome.com>
In-Reply-To: <20191016192321.c1ef8ea7c2533d6c8e1b98a2@suse.de>
References: <20191015120953.2597-1-tbogendoerfer@suse.de>
        <20191015120953.2597-5-tbogendoerfer@suse.de>
        <20191015122349.612a230b@cakuba.netronome.com>
        <20191016192321.c1ef8ea7c2533d6c8e1b98a2@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 19:23:21 +0200, Thomas Bogendoerfer wrote:
> On Tue, 15 Oct 2019 12:23:49 -0700
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> > On Tue, 15 Oct 2019 14:09:49 +0200, Thomas Bogendoerfer wrote:  
> > > SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> > > It also supports connecting a SuperIO chip for serial and parallel
> > > interfaces. IOC3 is used inside various SGI systemboards and add-on
> > > cards with different equipped external interfaces.
> > > 
> > > Support for ethernet and serial interfaces were implemented inside
> > > the network driver. This patchset moves out the not network related
> > > parts to a new MFD driver, which takes care of card detection,
> > > setup of platform devices and interrupt distribution for the subdevices.
> > > 
> > > Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>  
> > 
> > Looks good, I think.  
> 
> thank you. 
> 
> Now how do I get an Acked-by for the network part to merge it via
> the MIPS tree ?

Oh, via the MIPS tree? It was quite unclear which these would land it,
at least to an untrained mind like mine :) It could be useful to
provide some info on how you want this merged and what you expect from
whom in the cover letter in the future.

Hopefully Dave will be able to give you an official ack.
