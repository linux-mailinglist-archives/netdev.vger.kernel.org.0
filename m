Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D354F1137F1
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 00:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfLDXB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 18:01:58 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45889 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfLDXB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 18:01:58 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so861676lfa.12
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 15:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J0ucEi1G0QnviAHmx5pW9x6HCfetITK2+jAEtIBDfrI=;
        b=jTQIKrnxHb/vY1zX7oguKswg6y2Sv/0RLFLCXXLBLnXxv+Mq8gGIViTnbLaifwF8QS
         bS8o2l7KJnVGLsbTPSvJb7yzHApIt8X2ZaFyq1q16oumzSWVOQfAP4HC9mv868ouRM1O
         05f2cS+n8ZB3TdYJs/drIK67c8yWqvSHYXL237lZ9Em8Jeqz8+8xjf9QVxXj78tpLNrQ
         jKJdSboYvAK38WOwwmzbbMBXwTACGNAKA5d3Xd7ErwNM+eqOhGKs6HOJvEG3+KCzU6go
         FWjQ0SUcpBy5SyPBhfw+YJ/jbD6rehZCIApmSBUOvapgn0rKsUKeB51W9ToTF+tXypv+
         gZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J0ucEi1G0QnviAHmx5pW9x6HCfetITK2+jAEtIBDfrI=;
        b=G65H0Lx0BQWlAhMC/vJw4GmTLYBS9InJjNEheOLXdzzrkFJE5cWHQ8SCSrjdc7dGP0
         VvoVHI93qtwlMfU+Kp5QjlMqeXMKKJN+a+myD3591Me3pFxTNE+0RUVsCa91bvZUR3JO
         lmpCj1p/b9kqaNMY/+uDaOY8M9P1SSQ+/dItYUNAlNAa7QcCvuUuiC9436beaJYgLFOG
         f5sxdWEDFXhu8qpKZOyfe3uoeFa06PP3BRRr9ZF+3+5tI22ThHQa51dd++PKKUQCb4NN
         JpLD5YAgYnk5gj+R1EpIen/KyrIRF/kQTn5jBBRh5YZUQVrCRZj02GyJ1EEJttxk4esD
         +LKA==
X-Gm-Message-State: APjAAAV2F+7p27s8sjmk5YikG/oUqRyKYir6GAvZH/jC24gs2tGglj7y
        Xnv+tQjmP4ICflTXoJjcNEi5ww==
X-Google-Smtp-Source: APXvYqxySJ7CXdTZalDskjNmsGdbbjR3D5tX2IaT+1GugoeOTw3GDKdUgKpg4BA7d25Cv6FtxtJ9WA==
X-Received: by 2002:ac2:5107:: with SMTP id q7mr3389886lfb.177.1575500516805;
        Wed, 04 Dec 2019 15:01:56 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 138sm4101307lfa.76.2019.12.04.15.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 15:01:56 -0800 (PST)
Date:   Wed, 4 Dec 2019 15:01:36 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     willemdebruijn.kernel@gmail.com, vvidic@valentin-vidic.from.hr,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
Message-ID: <20191204150136.2f001242@cakuba.netronome.com>
In-Reply-To: <20191204.125135.750458923752225025.davem@davemloft.net>
References: <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
        <20191204113544.2d537bf7@cakuba.netronome.com>
        <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
        <20191204.125135.750458923752225025.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Dec 2019 12:51:35 -0800 (PST), David Miller wrote:
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Wed, 4 Dec 2019 15:43:00 -0500
> > On Wed, Dec 4, 2019 at 2:36 PM Jakub Kicinski wrote:  
> >> On Wed, 4 Dec 2019 14:22:55 -0500, Willem de Bruijn wrote:  
> >> > On Tue, Dec 3, 2019 at 6:08 PM Jakub Kicinski wrote:  
> >> > > On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:  
> >> > > > ENOTSUPP is not available in userspace:
> >> > > >
> >> > > >   setsockopt failed, 524, Unknown error 524
> >> > > >
> >> > > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>  
> >> > >
> >> > > I'm not 100% clear on whether we can change the return codes after they
> >> > > had been exposed to user space for numerous releases..  
> >> >
> >> > This has also come up in the context of SO_ZEROCOPY in the past. In my
> >> > opinion the answer is no. A quick grep | wc -l in net/ shows 99
> >> > matches for this error code. Only a fraction of those probably make it
> >> > to userspace, but definitely more than this single case.
> >> >
> >> > If anything, it may be time to define it in uapi?  
> >>
> >> No opinion but FWIW I'm toying with some CI for netdev, I've added a
> >> check for use of ENOTSUPP, apparently checkpatch already sniffs out
> >> uses of ENOSYS, so seems appropriate to add this one.  
> > 
> > Good idea if not exposing this in UAPI.  
> 
> I'm trying to understand this part of the discussion.
> 
> If we have been returning a non-valid error code, this 524 internal
> kernel thing, it is _NOT_ an exposed UAPI.
> 
> It is a kernel bug and we should fix it.

I agree. We should just fix this.

As Willem points out the use of this error code has spread, but in
theory I'm a co-maintainer of the TLS code now, and my maintainer 
gut says "just fix it" :)

> If userspace anywhere is checking for 524, that is what needs to be fixed.

FWIW I did a quick grep through openssl and gnutls and fbthrift and I
see no references to ENOTSUPP or 524.

Valentin, what's the strategy you're using for this fix? There's a
bunch of ENOTSUPP in net/tls/tls_sw.c as well, could you convert those,
too?
