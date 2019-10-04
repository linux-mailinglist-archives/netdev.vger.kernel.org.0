Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890A8CB725
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfJDJPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:15:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39891 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729874AbfJDJPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 05:15:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so3518306pff.6;
        Fri, 04 Oct 2019 02:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s8tqsqMy+G0/tcU7luJERjELtm00m1qaFN1WnG1XMF0=;
        b=Hkj0H1a17gfTA4IBRSDEr6jhOfHZKhPzQr7hTppiuNBr3rWcHa/1fVLIkJ7nLgY4MS
         rpwqpba5HkFXM8g3eza+y2a9Z5Fu8jqQM8g61sED46Fzj8LDnDTTOtLerEFsicimyY9u
         wtPARiHwWAULUZ0lDo8Ismp0mWIJJD0Z7yKJqRL+4uqQ062DbR9/y+6sQfqTxvaD1/Ps
         77pPN3urY0mkMJ0KY4uN63apCjxPV482S+HU7GTuU9JfEPT75wb8JWK8L4yzI3jflByi
         iPhYVTjwxRUhjQyKDNmCSrhynfidTWyls8p5tlPx4fz+TMCLYc0nH+at53J0y8lQMafG
         wOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s8tqsqMy+G0/tcU7luJERjELtm00m1qaFN1WnG1XMF0=;
        b=RiZQbDe7xr3Qw5oXxeufNTEbVANIaBJu04wQRgKvhuSji+guu5Tx7p9/HcjovmjvBQ
         xdIDKCDtYAOropsQwgMcTWyLjTt1TnOCJwR79yKixnkh9XCZJZjj4oyj3ZIBW0TPXMKN
         754KF7AnTI4HSK3T7BJWnHtRqR/V3yvRJgTAG3J5ytBs8ZHh8nVGv6WPq8ZurCdsJV+E
         /+w6R+ZRHY3vYv9SCT5F6t52x/MDyMYgZTnixWZsQtw3Vt2rYPADXjC7cjsXlmmBorth
         BfJxzghPtVv7WJaDaO3+SvbM9qZq5S6HYRuonO64C6ba63dil287Hltt4FZKS6KKf8mk
         cfKg==
X-Gm-Message-State: APjAAAXLvDGWNDpRl1awymimjg23DFKVP0dz228R6cJXGBm3YdA0wAXo
        /FwpIHesAX9kYfoLktDUPOuSbSUrHj4=
X-Google-Smtp-Source: APXvYqx9jVrJypPIFTpq5omupfOySz1o3av2IBN3FGqG+lYUCL6l0UwNhhdXupVN4qNFWjnTwQYi8w==
X-Received: by 2002:a17:90a:e50b:: with SMTP id t11mr15594108pjy.50.1570180551460;
        Fri, 04 Oct 2019 02:15:51 -0700 (PDT)
Received: from f1 (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id bb15sm3451428pjb.2.2019.10.04.02.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 02:15:50 -0700 (PDT)
Date:   Fri, 4 Oct 2019 18:15:45 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        GR-Linux-NIC-Dev@marvell.com, linux-kernel@vger.kernel.org,
        Manish Chopra <manishc@marvell.com>
Subject: Re: [PATCH v2 0/17] staging: qlge: Fix rx stall in case of
 allocation failures
Message-ID: <20191004091545.GA29467@f1>
References: <20190927101210.23856-1-bpoirier@suse.com>
 <20191004081931.GA67764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004081931.GA67764@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/04 10:19, Greg Kroah-Hartman wrote:
> On Fri, Sep 27, 2019 at 07:11:54PM +0900, Benjamin Poirier wrote:
[...]
> 
> As this code got moved to staging with the goal to drop it from the
> tree, why are you working on fixing it up?  Do you want it moved back
> out of staging into the "real" part of the tree, or are you just fixing
> things that you find in order to make it cleaner before we delete it?
> 
> confused,
> 

I expected one of two possible outcomes after moving the qlge driver to
staging:
1) it gets the attention of people looking for something to work on and
the driver is improved and submitted for normal inclusion in the future
2) it doesn't get enough attention and the driver is removed

I don't plan to do further work on it and I'm admittedly not holding my
breath for others to rush in but I already had those patches; it wasn't
a big effort to submit them as a first step towards outcome #1.

If #2 is a foregone conclusion, then there's little point in applying
the patches. The only benefit I can think of that if the complete
removal is reverted in the future, this specific problem will at least
be fixed.
