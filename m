Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6494DE0BA1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbfJVSm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:42:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40572 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJVSm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:42:56 -0400
Received: by mail-lj1-f195.google.com with SMTP id u22so291645lji.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uUm+UctSJb9Sxi4Yue9+NjzPZQDGfvALN7qvpf9pUtw=;
        b=DNCOyHtx4D8lLN9bKHdBDHQhiNC8SK2djwZ7RMR9aVyFSvOccDBFpvl9AykHBqJ5Od
         QDb9Slw2f/gVnZlNUtWWR3f4w37M/XlSTNb4nEsURuNwsJb8qVoWxXRZbiVxT9PeAVBf
         bdECB0V8iDV+31v0Lp/R21bM20znPWkCfGDfZWzwT0MkPr7Dc4Tbm3j2b3q9g1LuycUz
         FnYQrObEFvdzzmhfFK166Z5wfk6gSNdQLKI7L7SUZn1nwMYpzMq08gt6y66NV4t4B5hu
         +L0YZHW8WmxK8fnNI5fn+doPFpFa2B+NW4rpnhPNvRBxQIRTgasN74AdORatfH5sPwfo
         sYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uUm+UctSJb9Sxi4Yue9+NjzPZQDGfvALN7qvpf9pUtw=;
        b=te+DdTJA0awlqw/fUhhQl0yYdU0f0+o8xYRtoMLFDMqPIT0V+oDPeqFYggZXDYMw1K
         X+P/NntoeSbRulN3lkjCO/EyHKvRrvpjuI3vgV4Ua0zeUo3TebKsmEOLOLP1eN0Wy94z
         3pdTdHXz3Cd7dUoI8qnNkP2kfFDTKHRoJh5tqRriXNz1VB5HoWKmrMV10vQp0ZAA1fX7
         NVBnZPdyOIROrwBJ+n3egnGliIzGBBa8Fxt4kce9k9zMvxpsFRXG4vlY6dRPVGlDGAYT
         WPc/OHKy+6n5Vy53J4+r/hRk0vtauLEQkUS8n+v01ONSXbjyn+GpXo4TucfoTzbhm/v1
         WPww==
X-Gm-Message-State: APjAAAXhqClLSgFdrGicgtj/bKkmg/zmWXBxrvq+7wClT06Cft8VjHGl
        GxKZf1l65Y/xSyLNil+t+5OFWg==
X-Google-Smtp-Source: APXvYqxYqY2Aa34/1hMetn6Ql4KlBPc4RJaCefByGJJ1Jw0kVSJzC2MbynGGiaWik7mZMPJE4k1JYA==
X-Received: by 2002:a2e:880e:: with SMTP id x14mr19099889ljh.42.1571769774579;
        Tue, 22 Oct 2019 11:42:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x2sm7874053ljj.94.2019.10.22.11.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:42:54 -0700 (PDT)
Date:   Tue, 22 Oct 2019 11:42:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Message-ID: <20191022114247.144461a5@cakuba.netronome.com>
In-Reply-To: <b52dee38856c98dc4702ad269d85cf35d3689cf7.camel@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-13-saeedm@mellanox.com>
        <20191018185128.0cc912f8@cakuba.netronome.com>
        <b52dee38856c98dc4702ad269d85cf35d3689cf7.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 18:10:11 +0000, Saeed Mahameed wrote:
> On Fri, 2019-10-18 at 18:51 -0700, Jakub Kicinski wrote:
> > On Fri, 18 Oct 2019 19:38:24 +0000, Saeed Mahameed wrote:  
> > > From: Tariq Toukan <tariqt@mellanox.com>
> > > 
> > > Once the kTLS TX resync function is called, it used to return
> > > a binary value, for success or failure.
> > > 
> > > However, in case the TLS SKB is a retransmission of the connection
> > > handshake, it initiates the resync flow (as the tcp seq check
> > > holds),
> > > while regular packet handle is expected.
> > > 
> > > In this patch, we identify this case and skip the resync operation
> > > accordingly.
> > > 
> > > Counters:
> > > - Add a counter (tls_skip_no_sync_data) to monitor this.
> > > - Bump the dump counters up as they are used more frequently.
> > > - Add a missing counter descriptor declaration for tls_resync_bytes
> > >   in sq_stats_desc.
> > > 
> > > Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>  
> > 
> > Could you document the new counter in tls-offload.rst?  
> 
> Tariq already prepared the patch, do we want this in net or net-next ? 
> most of our kTLS users are going to use 5.3/5.4 stable kernels, but i
> am not sure this should go to net.. 

Thanks, I asked Dave recently about docs and he said we can apply to net
(since doc changes can't really break any code). Since the code is in
net, I think net would be appropriate for the doc as well.
