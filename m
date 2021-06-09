Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795B93A11BF
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhFIK4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:56:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43999 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhFIK4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:56:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id e22so19092483pgv.10;
        Wed, 09 Jun 2021 03:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=U97rpvHxMxlurF0f6cbH6mpc1GGUvkZgOKHmGdSdtxQ=;
        b=YzQafSMa7W5bvgCjzf7nC2IrhAbN4B/6z/MM6XeGzvFduGGyKFoZNww+CQjGcEJuUx
         ggT8p1erWrhnsx7GNTwDuHv8k2TrZ0vrctj6e1TT5U9kbDDLuUGw0gKkn2Bp4KMtJ4pD
         u9RozE2kmH/gZzQPYrEDTWgH+cCMuCmQVFzIOJJ5l3ArA3y1hCBXrqmT4DrFBBB93jFf
         WjdRmugLLTlqUwr0aMtNr2MrANEYP0eTeYcw5/j3RGjbQeciU4hSwdbbaLYb0rJ3K4jM
         gbtsWNvKEOQryXjIoy6NZ6sAtKrizhZfVDMIwt2eNPPbEAXDW/zU4l+n4l6ZWeXxg7ES
         rGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=U97rpvHxMxlurF0f6cbH6mpc1GGUvkZgOKHmGdSdtxQ=;
        b=Rd08ulxqyDGISULHc/e/yUcefUqSrBsrg6l9C64fEn29kGd7J7kJtyWogu/H2OR2c+
         21SmzRwF083WRhIBl+Tobwq9K3XaNCoDZEgkV33V8FqGD8NXw2OHWg4TVAZmcdrfSrNW
         yJQQ9aeOTt0QPqZDwu6YI/Ldj2Nk76Rmiz0RrZ6K2KS4xJxbxQ5tYyyRRj0MPQEsXEjg
         M3l2dlVbg+MJw2z4pmCyNenoA7Fe1WhMYeL1Aw1/so+0dNEwJ298q5SW5QIplKL0upcQ
         DXZyikuIgXnTiW2ElGf5FYTHPO2zie+Z1cu+3ZjZmeNA67mTFlfGdJRZhWugHGgirj+W
         xCQw==
X-Gm-Message-State: AOAM531IC3O5ZV+mR72aWT7wQhbdGZNowcpASC/rBVI2+ddDJhI6jbPl
        IU7n2diBg02+68+Uwn4D5FHyQJ2BCMJ3QQ==
X-Google-Smtp-Source: ABdhPJx6xyCXbaWra/O3cSWcOV4v5LPFCQsAEEzw9Z5BAIzEdGzClmP4PSgF4x547bZKG/n5ZCZsEw==
X-Received: by 2002:a63:571d:: with SMTP id l29mr3207688pgb.179.1623236033019;
        Wed, 09 Jun 2021 03:53:53 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id p16sm13516343pgl.60.2021.06.09.03.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:53:52 -0700 (PDT)
Date:   Wed, 9 Jun 2021 03:53:50 -0700
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
Message-ID: <20210609105350.GA64468@www>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
 <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
 <20210607125120.GA4262@www>
 <46d2a694-6a85-0f8e-4156-9bb1c4dbdb69@redhat.com>
 <20210609025412.GA58348@www>
 <927af5e7-6194-d94e-1497-6b3dce26c583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <927af5e7-6194-d94e-1497-6b3dce26c583@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 03:34:33AM -0400, Jon Maloy wrote:
> 
> 
[...]
> It seems like I have been misleading you. It turns out that these messages
> *will* be sent out over the nework in some cases, i.e. at
> multicast/broadcast over an UDP bearer.
> So, what we need is two macros, one with the conditional crypto
> head/tailroom defined as you first suggested, and one that only use the
> non-crypto head/tailroom as we have been discussing now.
> The first one can be defined inside bcast.c, the latter  inside msg.c.
> It might also be a good idea to give the macros more descriptive names, such
> as ONEPAGE_MTU in the broadcast version, and ONEPAGE_SKB in the node local
> version.
> 
> Does that make sense?

I think it's another point which can be optimized. However, with
CONFIG_TIPC_CRYPTO=y, the BUF_HEADROOM used in tipc_buf_acquire() is
always the crypto version, so it donen't work to define FB_MTU with
non-crypto BUF_HEADROOM.

So the point is to make a non-crypto version tipc_buf_acquire(), which
is used to alloc data for non-crypto message with non-crypto
BUF_HEADROOM. And that require us to distinguish the message that don't
crypto. Is there simple way to achieve this goal?

(Btw, I resended the patches for the 'two pages' problems.)

Thanks!
Menglong Dong

> 
> > 
