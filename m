Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AB411F3B5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 20:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLNTmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 14:42:32 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34243 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfLNTmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 14:42:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id l127so1548980pfl.1
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 11:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ia/spIDznfx4S80/FG8HXHXLgVjkiCRgw5Vjx44oYK4=;
        b=O93nxUsncuA1/yP9rasJELzXiSOcz3FMwcmxm3crVOEIJgs79xccOyIrJAHE6SvkBo
         YDUQBSe2ctwxz0ZPKudYNqg2ZjtesfAmE7Jc8BvJCb1HQeZ2t+NQsR1pXe7MP1FcLyLy
         QQLaZDoMl/HD7Cr/Rp3eIOxwgHazISf2BtrxP4NVPwMAcFu4CXrbgjP7gYHO+Uu5EJbX
         UCSnAIoXUdxvObTwaxu4Un3vqlodQ49J5poCNVXBv7WLOy6MlFptzU5PZ/AoaXaJmBY6
         kdYMY8a4CmPx6GzVQjYuNSJK7dap7kijIE6bnpC8aRyJodgQViMDgdlUnVPgNFLG16ys
         0ydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ia/spIDznfx4S80/FG8HXHXLgVjkiCRgw5Vjx44oYK4=;
        b=Hs1kCckY9iFTtQb8URpQTz9329JzpqnrWLuXlnFqdoIpN6Nuzj4RkLZ7PSO4/NziKu
         wvGi+KhRYR+8044+lmAAw1ip4xAkmo4CkWCANIQ/ZXQacmzLeyNZi6MIMfeozmPb9uLK
         Vt6YYrYzmxsboTqiPHDtuDAHiAEl0E9ntGaTv3CuNyklC5vPwVzH7JeqzA4C+d8Vej2g
         hL6U4KXiaNi9m9aQM8YCFcTe9qfAeYqFyEndN2TezCRcEM92uz9K7Ts5Jcwxa/OYrdWH
         HUtueTJeZO/ddTuSUKbhWEProgowcl4Vpob3mjDm+Wy9Gwovy06hnYrZ+Enm5MENuf7S
         TqQQ==
X-Gm-Message-State: APjAAAWDDvgCpZS8wnzWPk/gyLSYSW1jGNc/9+P1LDeyibgooAnbI886
        F7+cki1eRlDtZ6CVK7oe4/8KnA==
X-Google-Smtp-Source: APXvYqwF++x6s9ZII887UWHiPagFOHiHdlVpzERJunIckfDzD1H2JxGOw7Y7WlG/yT4B72VKdPW7Ew==
X-Received: by 2002:a62:1944:: with SMTP id 65mr7040188pfz.151.1576352551277;
        Sat, 14 Dec 2019 11:42:31 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 200sm16099626pfz.121.2019.12.14.11.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 11:42:31 -0800 (PST)
Date:   Sat, 14 Dec 2019 11:42:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is
 installed
Message-ID: <20191214114228.45d88138@cakuba.netronome.com>
In-Reply-To: <CACKFLin=JS-5mou=0-b9nvHh=4=9AopZUDGLb+ZkkVYbAsk3WQ@mail.gmail.com>
References: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
        <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com>
        <BY5PR18MB3379AC23267423E0CE9EEA05AB540@BY5PR18MB3379.namprd18.prod.outlook.com>
        <CACKFLin=JS-5mou=0-b9nvHh=4=9AopZUDGLb+ZkkVYbAsk3WQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 13:09:31 -0800, Michael Chan wrote:
> On Fri, Dec 13, 2019 at 1:45 AM Manish Chopra <manishc@marvell.com> wrote:
> 
> > It used to be the case for our devices as well long back. but after the commit 18c602dee4726 ("qede: Use NETIF_F_GRO_HW")
> > that part was removed from our driver and commit 56f5aa77cdad1 ("net: Disable GRO_HW when generic XDP is installed on a device")
> > was added to achieve the same instead of individual driver doing it, but it wasn't caught that time why later commit only does for generic xdp,
> > not for native xdp. So today when native xdp is attached to our device, HW GRO aggregation remains enabled on our device.
> > Please let me know if that fix is good enough to be posted. Will test it out and post.
> >  
> 
> The driver knows when an xdp program is attached and can disable any
> features that are not compatible, so I think it is more efficient to
> keep it this way.  Generic XDP on the other hand, does not involve the
> driver and so we need to disable them for the driver.

The only question is should the driver refuse the XDP prog installation
(with a nice extack message) or should it silently disable the feature?
IIRC ixgbe opts for returning -EINVAL if RSC/LRO is enabled. Micheal
says that bnxt disables automatically. My preference is for the former,
because it's simpler - we all keep the MTU intact and don't disable
queues to make room for XDP, IOW don't automatically change user
controlled configuration is a simpler policy. But I don't feel too
strongly, we should just make sure we document what's the expected
behaviour (even better make netdevsim behave that way and write a test).

Manish, if you were to go ahead with your patch please make sure you
don't disable the features when program is installed in offload mode,
though.
