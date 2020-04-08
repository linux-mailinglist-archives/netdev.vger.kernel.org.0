Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FEC1A2B7A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDHVy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:54:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41925 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgDHVy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:54:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id y3so1966444qky.8;
        Wed, 08 Apr 2020 14:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=80oRdp7P30+JZo0JuTVsvbrYkq28bFUCWUY33UXVWVo=;
        b=r8qC0/Urc5VZ4LePFOcQkmQ7Dmtyd5ltpzgZrU1g/XBDNWkyrEPhDJyKfURA9U57yt
         ossduzR5eWPv1pngi0U0VbFRIqAkDJo9sQpuSlfj6IcMluiphgsBNDWV7bXN0q4NLH0B
         gHkX+FBtdtRIxcT2oNn3iIJolzFbOBKybH0j0+tZ9O4d8/uRcd/NEXsWEBpvb9L9P0Or
         6/VTr2TPseeo5uGBM9E7wxORv6GcgPJjF/aCcfh2R6ilJLWL2HIrzD4afImMxRkDHDoS
         qSz/EHoXJUaHGiaHcmsHUO0IfXZeQdpHmp7AoJ0NHzJ1xxCdXzHlskVw5zn1soh//laY
         Wjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=80oRdp7P30+JZo0JuTVsvbrYkq28bFUCWUY33UXVWVo=;
        b=Q5FYvbFJg3Xw4D4/hmRlT0Ggva16+4Ye3EvcFEDF32Ua7Zji4VehZ5C1qJ2Et0TMLO
         HsDAHT3EU08xGzLPQDCDm3TnvCOVB7ROCcql+9pE9xi5sqEqG3SFibr1E2+NCUFkYp5f
         dHJVHBJTIgNKtC0tXKvyZR2WyVvH7aHE7hm44qBRb++9Q/Bk6zR6z3CIwVipw807lBS8
         H6jZiwee2SzpRkNA80aze9/L9WwNsBOpE/uYoxHyyCZPHbpJ50N3sEBp5pIzXXOJcyd5
         Wy5hUyD9hVNb1SpLGlepCrghY0A4ew6w+SHSnD7nWM8yDVTzgBLPSik9ZtgaIuRJOon+
         ZqLQ==
X-Gm-Message-State: AGi0PuaXnIOleIGT6GczD4Q/xHu3ZzL7iUwQNAayOZoQXJ9ubfo+EWJF
        bF9Wz8mY0TSf9exkgyZkz9w=
X-Google-Smtp-Source: APiQypI/IgZ8IFFzz2XkAhS9o8ekvzboQN9JGpH2HUM9MiUgvQbd23WIQ22foaOevBDyoqlmBul5WQ==
X-Received: by 2002:a37:6e87:: with SMTP id j129mr2076673qkc.358.1586382866520;
        Wed, 08 Apr 2020 14:54:26 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.139])
        by smtp.gmail.com with ESMTPSA id u7sm1334132qkj.51.2020.04.08.14.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 14:54:25 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0E018C5510; Wed,  8 Apr 2020 18:54:23 -0300 (-03)
Date:   Wed, 8 Apr 2020 18:54:22 -0300
From:   "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>, Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing
 to _once
Message-ID: <20200408215422.GA137894@localhost.localdomain>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
 <20200403024835.GA3547@localhost.localdomain>
 <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 07:51:22PM +0000, Saeed Mahameed wrote:
...
> > > I understand it is for debug only but i strongly suggest to not
> > > totally
> > > suppress these messages and maybe just move them to tracepoints
> > > buffer
> > > ? for those who would want to really debug .. 
> > > 
> > > we already have some tracepoints implemented for en_tc.c 
> > > mlx5/core/diag/en_tc_tracepoints.c, maybe we should define a
> > > tracepoint
> > > for error reporting .. 
> > 
> > That, or s/netdev_warn/netdev_dbg/, but both are more hidden to the
> > user than the _once.
> > 
> 
> i don't see any reason to pollute kernel log with debug messages when
> we have tracepoint buffer for en_tc .. 

So we're agreeing that these need to be changed. Good.

I don't think a sysadmin would be using tracepoints for
troubleshooting this, but okay. My only objective here is exactly what
you said, to not pollute kernel log too much with these potentially
repetitive messages.
