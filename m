Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6FEF222
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfKEAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:40:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40033 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbfKEAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:40:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so12743176pgt.7;
        Mon, 04 Nov 2019 16:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=inB9EM0qj9TflFqd/USrdNr/Cfvzl+WeDzdgBg8jJwo=;
        b=c9ZT7Nq+CXAIguw8HsUHriwOs1Phmzcggj3q/5QtD0XNx/3/zenegZYxhxIrDPsFEi
         vP6iltu6bWCTOzTA2lSgYRCFgymX/HIBroF2T7C5h4jagZEeIJclvsyU6cqqlnAiEx+3
         zSFUChBFp4NgUxL/+Mzgrugr/5hvJELiraPwmnKIsyFXoEUUnSeAsRqAVS+V5ej994YH
         8iGcoei/BE/U1IbQh7HBxH+cnL/Y4cc7WbLoF2ZxGj/q7OLSkoUaJqn7QBy5GpY/CS1H
         7idH6jB4FMJp8E/FOMcQcEFWi+4qmHnm1xXOefl8GP4gkoiXIAjefR+nVE4ZIkYXuuVm
         Y2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=inB9EM0qj9TflFqd/USrdNr/Cfvzl+WeDzdgBg8jJwo=;
        b=ddIeogbgcDr4HYNsDzMoHi7iV5R3m6Vakk6iQ1LCam98icnPBQCrVMO/h2YiZE02N9
         IAWa0apA6byeVWR9Ye7UWDubuQx1YAIBfqAUJDVthCdxQlUT8BR/5M2okNkt0zCjRGgj
         /eOoGe7pbN490wIlOdhPiJZXszOTgYqgFkrALCx6lIrIE4QcNuJ73MwVnhIPajLhsoaw
         j5RoIt1TKD4v1gCKHHa6DR20UtYRCrgRtlWc9adnFdGn4K4bcgea5FV0njPbmrMPqDFU
         z1Rv3WUsdxkZlX5kXa264vvx5YTYgrUDIFBSRdSSfHvMcBhEnPqNBIgbhaykCmlCZqL5
         of/Q==
X-Gm-Message-State: APjAAAVpSD1qxUB4gtmQrv5Ns0GdduibKnKQnYHah14QsxUeF6WZVYF2
        VhGex1pbbLZPENPAk7xQEsY=
X-Google-Smtp-Source: APXvYqxUUQcbtiHqD6ANcbPsK37Rw0Z9ZRkEqjxaejr/Ov0N52U6sQyc+/gskamWYYuOTMPm6grf0w==
X-Received: by 2002:a63:b047:: with SMTP id z7mr33162539pgo.224.1572914419555;
        Mon, 04 Nov 2019 16:40:19 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id d5sm22714815pfa.180.2019.11.04.16.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 16:40:18 -0800 (PST)
Date:   Mon, 4 Nov 2019 16:40:16 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191105004016.GT57214@dtor-ws>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Mon, Oct 14, 2019 at 10:40:19AM -0700, Dmitry Torokhov wrote:
> This series switches phy drivers form using fwnode_get_named_gpiod() and
> gpiod_get_from_of_node() that are scheduled to be removed in favor
> of fwnode_gpiod_get_index() that behaves more like standard
> gpiod_get_index() and will potentially handle secondary software
> nodes in cases we need to augment platform firmware.
> 
> Linus, as David would prefer not to pull in the immutable branch but
> rather route the patches through the tree that has the new API, could
> you please take them with his ACKs?

Gentle ping on the series...

> 
> Thanks!
> 
> v2:
>         - rebased on top of Linus' W devel branch
>         - added David's ACKs
> 
> Dmitry Torokhov (3):
>   net: phylink: switch to using fwnode_gpiod_get_index()
>   net: phy: fixed_phy: fix use-after-free when checking link GPIO
>   net: phy: fixed_phy: switch to using fwnode_gpiod_get_index
> 
>  drivers/net/phy/fixed_phy.c | 11 ++++-------
>  drivers/net/phy/phylink.c   |  4 ++--
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> -- 
> 2.23.0.700.g56cf767bdb-goog
> 

-- 
Dmitry
