Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E0D21C11F
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGKA0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 20:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgGKA0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 20:26:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EAEC08C5DC;
        Fri, 10 Jul 2020 17:26:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc9so3289980pjb.2;
        Fri, 10 Jul 2020 17:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ioC5GlIAQw2jANKJm9jDrrwzH+U1xhkRkHlZAU86zzQ=;
        b=KqFy+a5eeoq60rTgnPDnMZDPCGByCC4qsDVrdpRzqXpLIYuLay/TOgasL9LgLDzKs/
         3M4M/1SLIUIl5kYxhevNbjBwtTS4teASEioyXvPGKAoZvaOFRlfBakAS2y2Mgeo0OzYj
         gvIKvhrWC7wVPD726FeRkAwY/vF5nlPZLThmGV1NbhS0J2gpm6lBshtI5Y4jZNECbcKT
         G/VdNwYRlAtbht4qzXllKFk26m5y6VI700I2MXUiOQ7O9Q7EFCSp5cHpAUHt4h515BPV
         WShIgcbQQP9CVmfJQa6eJQ9NFL7RxX2vaFKOgjrXbqQZ0rD1jwYQbCicaWoCVoTT4zi7
         5lFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ioC5GlIAQw2jANKJm9jDrrwzH+U1xhkRkHlZAU86zzQ=;
        b=beuaQ54pUn9gYVUZClUgSjk+QK/+0/4RI0qNwxVkKBYIKvYRfAheGUSbNZMbCY6xMn
         ydjZ5hYc68ZvEUCQNzAK6g4TFXLmGIJaFo7muOuzrR/sx7wE+BFyUj0SdhnStaDNtAJl
         sck96NgKxUd4iRateUFAkpe00YM2m2KX3OcB6+onnMrx/+8Y1lfPCdLsuOkjDF+828Vg
         uJAkZlyFA5iJp2bO5o/Px5XIhyZqE9NFifxh3fvWE2hBCR940LAlwVCsSz+jnBwZOA56
         jKrI6U86zeE15CcEzLxXIYbouJGATEGLBspEwGTazytop9TGPvDFeL3yZA8bXduPtRVa
         Q8Xw==
X-Gm-Message-State: AOAM531PRRyv57AF2g/I/pnGfXgwoAcsdEhubk3GEIVliZqi6GUbx8Fk
        wcTx5sD9kXM4pC47Pd+ZKmw=
X-Google-Smtp-Source: ABdhPJzs1ifNqK061eFgKWidE55Ut6qOHThkYDkz/GAKJoQMCUC9V5Ypu9ZO6gqERl2p/KjnobCHLw==
X-Received: by 2002:a17:90a:1a52:: with SMTP id 18mr7873239pjl.14.1594427203484;
        Fri, 10 Jul 2020 17:26:43 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v3sm7309424pfb.207.2020.07.10.17.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 17:26:42 -0700 (PDT)
Date:   Sat, 11 Jul 2020 08:26:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200711002632.GE2531@dhcp-12-153.nay.redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-2-liuhangbin@gmail.com>
 <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
 <20200710065535.GB2531@dhcp-12-153.nay.redhat.com>
 <2212a795-4964-a828-4d63-92394585e684@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2212a795-4964-a828-4d63-92394585e684@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 07:46:18AM -0600, David Ahern wrote:
> >>
> >> I'm probably missing something fundamental, but why do you need to walk
> >> the keys? Why not just do a lookup on the device index?
> > 
> > This functions is to check if the device index is in exclude map.
> > 
> > The device indexes are stored as values in the map. The user could store
> > the values by any key number. There is no way to lookup the device index
> > directly unless loop the map and check each values we stored.
> 
> Right.
> 
> The point of DEVMAP_HASH is to allow map management where key == device
> index (vs DEVMAP which for any non-trivial use case is going to require
> key != device index). You could require the exclude map to be
> DEVMAP_HASH and the key to be the index allowing you to do a direct
> lookup. Having to roam the entire map looking for a match does not scale
> and is going to have poor performance with increasing number of entries.
> XDP is targeted at performance with expert level of control, so
> constraints like this have to be part of the deal.

Yes, if we have this constraints the performance should have some improvement.

Do you think we should do it right now or in later performance update patch.

Thanks
Hangbin
