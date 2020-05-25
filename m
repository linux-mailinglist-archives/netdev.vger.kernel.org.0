Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473021E1571
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbgEYU7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388542AbgEYU7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:59:51 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D543EC061A0E;
        Mon, 25 May 2020 13:59:50 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id r3so8569974qve.1;
        Mon, 25 May 2020 13:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XBx7V4HGJFmz/xdv3njXdrSDIV7GwCN6dhLd9svsoZM=;
        b=SFsgL4zmCANb3SR6xlz1x2qGtI9LhPJg1iB+/4BrTl5uQrZP0BDFKS+eCX3a2UvlMj
         amUYU+4JMZzWxTOh5dKRvb68L+T1+f/qUDHO9UPMZhp0IBUOXW8RBq/EJ1GwnNm6B30B
         v5XbhTXwOpbOuRY1ss6Cuo6kz3pZ43PPeCXI6r5dP1QbzsWQIIPrzhB9b6e/T5txy3+W
         SYUVNK/m0GamDLl2V7/2tdLKtnNjsSPbhDwe/cRshSQkqhAZiPDT/zWflYKrBaE/dxBE
         bad2U8QrINAKXMd+dWZFTguNMo3dyEw24hPgtJhN0Llf0ghNNN0OCZ9/W9KhHE5gnSnH
         /udQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XBx7V4HGJFmz/xdv3njXdrSDIV7GwCN6dhLd9svsoZM=;
        b=U6Qrqk7agyJVs/K/3wGLWZhTKaSLOVtlLxhPvN3fhweseg8811HhOW551K9F4djXcc
         bBJy91v5XEo3D/fF028sPWNAph5xwvaF2yZ9Q4oLhtmdeWkgBQs6l/HU8qmGggARUPy9
         ZHJmqbntMl1aEZTht720o+8qp7wZOdRHXNUKA4lZJ/hQqWZeWdiZsnX1rf06Lg8GBBO8
         YoOJnXF0kqpGUkGK+2X7ZPkcVzSMqXC0InPaytTeBDD/FBPiX5YR4o3uZidgc+8ikYAV
         ZlZHIXP9+S5shLRZO2iBwl5TvjtqhRa/VNHNcKoTgFNNHkFL/PFHkb7FRGzOQCA6JodZ
         WrTg==
X-Gm-Message-State: AOAM531FsVaEaPm28SIDKAgOYZ5jk++SzSJelzVnsRqeKJBR8v5/JcRX
        4RVFI6ZPyjb4dzhTFR2Obe4=
X-Google-Smtp-Source: ABdhPJz7SO8AaZ6BTdR5bf9aWrBAUgeCCyEcQZNMSgZyz0wLZwQzM5BrpkhXU8iq7yrdtfHr4MQGSA==
X-Received: by 2002:a05:6214:8e1:: with SMTP id dr1mr16120649qvb.193.1590440390086;
        Mon, 25 May 2020 13:59:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:8992:a39b:b6ab:3df8:5b60])
        by smtp.gmail.com with ESMTPSA id t74sm14893563qka.21.2020.05.25.13.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 13:59:49 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1205AC1B76; Mon, 25 May 2020 17:59:47 -0300 (-03)
Date:   Mon, 25 May 2020 17:59:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-ID: <20200525205947.GC2491@localhost.localdomain>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
 <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 07:37:49PM +0000, David Laight wrote:
> I'm going to post a V3 of my big patch - I spotted an error.
> I'll include a different (smaller) patch in 0/1 that generates
> exactly the same object code but is easier to review.

Please make sure to split at least setsockopt and getsockopt changes
into different patches. That will help quite a lot already.
And to adopt the memset at the end of sctp_setsockopt_auth_key(), to
avoid special handling later on.

Thanks,
Marcelo
