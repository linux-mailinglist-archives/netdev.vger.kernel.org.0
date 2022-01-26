Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E83349C951
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbiAZMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiAZMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 07:10:01 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5595FC06161C;
        Wed, 26 Jan 2022 04:10:01 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id j16so11648003plx.4;
        Wed, 26 Jan 2022 04:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AEzAoHuhPGPKCGh3cWJjJrGXHXVQzmvhoLSTyK087Xo=;
        b=djMVuKsI0YKi8jRlWCDcM3ROIbZoH//glenypM9jc7sLmeCe/EE75Y67qRrzAf3wQP
         QUobivH6WxoG9ejnNkyis1z3Jf46rdvKV7V2W3ttwBKNfuyoNAyUMIBSaurN+y6UYFmm
         NVhUjhZGlh0F4MQW6fuIZqv3iIKXwHD+7sUKTw9LzoI4OoSO74QRpxtGqMf2MIVDqMbI
         agGnOSaI6mF2rB8YbiD39ItlFrnyCv+mSU123nGp2x0E17DtbzhA9fwphSrJz4pi+THm
         sozAj6KeeguRAfAJerosUnbKNCaqMDE2tAGjnZPFKcdJtzOKZSovKzaQHvbcJtOXaEow
         fEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AEzAoHuhPGPKCGh3cWJjJrGXHXVQzmvhoLSTyK087Xo=;
        b=ucFFgr5M+eolCZoyfgLebYGRSNJwXNVOuJwNYueTxJ60elXkemnZYDL4sLUnxLXJc2
         UOUc1WDDNHjcKbm4OIASwezgWLsPWDG+nmYFO8TRRloi+/rrH1ch5bW5+iKkkO8BaATb
         wdf/KM0I6UyaM65UiEI5GlRgyJQmhXXoIs+xg9sBHjVeLNCnZ9X/aEu7dtBPleFRPg0f
         h/JItQ4SSYPMPxLb/Wi0Omx598uuRoI+4jjwc5K4uURXZ+PNnCZ9+yohsC+S/iEkTlni
         uLYzhOAcBE9PCxmFdElaKWehJfxhI1g3bMx1GSKIJdAqmDgfJnl91zhYtmlwjTwRJv2p
         BXYQ==
X-Gm-Message-State: AOAM533UPcmYAreym8FLCJP/YzcHRPkAkIRUKFOb90iFLG9E71Idjm3v
        mzLn5Yigi4reCsi2GXXgaFs=
X-Google-Smtp-Source: ABdhPJxncV8VOSnug4ym2aL2nT/IZC7T0uIUIvLBVm9RqV/h+fb+P0gfjEnvrMXmbIV133KdjmCRIg==
X-Received: by 2002:a17:90a:7e8a:: with SMTP id j10mr8400366pjl.13.1643199000857;
        Wed, 26 Jan 2022 04:10:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h9sm1886487pfe.101.2022.01.26.04.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:10:00 -0800 (PST)
Date:   Wed, 26 Jan 2022 17:38:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, toke@redhat.com,
        andrii.nakryiko@gmail.com, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <20220126120809.ihs2wko74dm4r3pi@apollo.legion>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
 <YfEwLrB6JqNpdUc0@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfEwLrB6JqNpdUc0@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 04:57:42PM IST, Lorenzo Bianconi wrote:
> > On 24/01/2022 19:20, Lorenzo Bianconi wrote:
> > > Similar to bpf_xdp_ct_lookup routine, introduce
> > > br_fdb_find_port_from_ifindex unstable helper in order to accelerate
> > > linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
> > > lookup in the associated bridge fdb table and it will return the
> > > output ifindex if the destination address is associated to a bridge
> > > port or -ENODEV for BOM traffic or if lookup fails.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  net/bridge/br.c         | 21 +++++++++++++
> > >  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
> > >  net/bridge/br_private.h | 12 ++++++++
> > >  3 files changed, 91 insertions(+), 9 deletions(-)
> > >
> >
> > Hi Lorenzo,
>
> Hi Nikolay,
>
> thx for the review.
>
> [...]
>
> I guess at the time I sent the series it was just in bpf-next but now it should
> be in net-next too.
> I do not think we need a unregister here.
> @Kumar: agree?
>

Yes, no need to call unregister (hence there is no unregister).

> > [...]



--
Kartikeya
