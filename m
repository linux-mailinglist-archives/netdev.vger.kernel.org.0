Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535322944FA
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438865AbgJTWNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393806AbgJTWNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:13:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A21C0613CE;
        Tue, 20 Oct 2020 15:13:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b69so307710qkg.8;
        Tue, 20 Oct 2020 15:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x+3vRVHB5+7gkckUhCgsip8Pk+vCn8LWgbRD1RkYGXU=;
        b=eFnYR5Io1VAEEOPBE/PI15hnBT76MgsF9hNiXq+5ZYtpf16BuO9RB0vRoSVFaco8ZO
         7WlCWXVtIhm87j47r1mFdTV0rrMdmRC8AQC4FEZK6tfuuasJofQkh5u7CiUZHa7j8SFQ
         uVPdmaBjBXxnkhnfgXVOAfxSNW1SoI0ppQUZUuaaXU/HUTAapd5F+YLw6xHWjXQa3O6Y
         GRTyFMUbPx2baWXHjeW7y3z6bTxuF/lLV2jr2z5ZUQC1Db5GiX2CtEMfYG6pNBDC0mV1
         VCnNHUs6Jjkvha7nsF+zWRJJ8xBdYxCSi/w6wOXSuoUNOMs9j8k2u+Kc7wxhdBGJbMn5
         4K5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x+3vRVHB5+7gkckUhCgsip8Pk+vCn8LWgbRD1RkYGXU=;
        b=DJbfpY0jsP5TRX6RohkYOHKncK2+sceeIpiqnXD33JsnDkBabSxJN4peqQyOhymAno
         lMVbsA44oqWdUmy0Cjkz8iJIeY9MMHraDiVI4i2+7YTZn7iuLdXYtBs9BFoEZGr5HE1U
         Q9NxLT7j6MvUvvdVWDWzGI+o+SRcYJH4LY/3HYXlLjUg8Qk2mOY8ryRnKTrFaSf57JN8
         HFrtvHYB0qEOYm2cIDraqGfZ16WFh9UFceWVN8iWQhMWqbLfhkI4SHkK/wrLHxml9DdR
         tehTKX1R9ygWIGbfuQEmL0vNuhj62Mdd2H+jy5VQWqdDIIzqBkzDEB6pUsbUIHAXQEM6
         9FyQ==
X-Gm-Message-State: AOAM5314poJkgaO443TfGzh+2S+giry0RVopz1VJR61qeL1NEdIimasM
        g/ZzJTcyVQ/axaJ97asZYFE=
X-Google-Smtp-Source: ABdhPJzTYADJ6eKgQ1w/3p7mdaaKkcQNd7SGGe33vI7uLqteG0Cuc/fuHpPWPyl2ztn+dnT29Cj4mw==
X-Received: by 2002:a37:686:: with SMTP id 128mr377590qkg.421.1603232032859;
        Tue, 20 Oct 2020 15:13:52 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.69])
        by smtp.gmail.com with ESMTPSA id d7sm188584qkg.29.2020.10.20.15.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 15:13:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7E1A1C1632; Tue, 20 Oct 2020 19:13:49 -0300 (-03)
Date:   Tue, 20 Oct 2020 19:13:49 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Michael Tuexen <tuexen@fh-muenster.de>,
        Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-ID: <20201020221349.GH11030@localhost.localdomain>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain>
 <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain>
 <1614a5aa143147a385f7db7bdda0bfd3@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614a5aa143147a385f7db7bdda0bfd3@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 10:08:17PM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 20 October 2020 22:24
> ...
> > > > Did FreeBSD enable it by default too?
> > > No. The default is 0, which means that the encapsulation is turned off.
> > > Setting this sysctl variable to a non-zero value enables the UDP tunneling
> > > with the given port.
> > 
> > Thanks Michael.
> > Xin, then we should change this default value (and update the
> > documentation above accordingly, to still have the standard port #
> > readily available in there).
> 
> Does that mean that you can't have some 'normal' connections and
> others that use UDP encapsulation?
> Seems a pretty strong restriction.

That's not what was said. Just that the socket shouldn't be created by
default.

> 
> (I'm waiting for one of our customers to ask for this...)

It can. The setting in question is for receiving encapsulated packets,
and which doesn't exclude the standard one. It can still receive
normal/non-encapsulated packets.
