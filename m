Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D291CC8B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfENQKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:10:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50834 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:10:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so3497361wme.0
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 09:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wYcnLcHNEWzuyUPaOSPaqvipKhwQq75NVlrWVwfonxY=;
        b=hyDKTr4oLw9ng34BpE6hV9B2CPowG43bcPj1l1uTMjThqTW4IzgDatFsjEAzBcHwts
         Ndqo1QoOqOMqki5v/OrjJmdtDmaq3ukdA3M30s5KBd9SiSAP/cg0ImJ7NaO7CeisXDU+
         CK9NQJdfE02U0mvlmWQ7p+H/C50p9oHBxrulCHuj5JDrtPgo7408ijU30rgLhKmoyD5V
         Nbq8Z+ra9+37RrPHnnDQ3ZF/0DSpqe0ZKAR6oXYqp5ZpqOzUbgSjwXxeUvF+Yf78B/1g
         4jx6/F/PSTZ0s5iKtTIR2flRrtNNoRILk5/j8rAZ75V2hIuU45NGpTUaE7ayalrjU3jS
         jcHQ==
X-Gm-Message-State: APjAAAXqMIcyt6bnnCMQTL/ndZBVt5HkMU45EQH8387N9mCIyn5rOx9P
        zm7GxDwCqu+J2zC5KXFP8JwgkbTy7Ik=
X-Google-Smtp-Source: APXvYqxqlLOgXzEWalLGMo/rtA7vvFLalOSyrklAhb9ipPKK7DakL4gduRG3L+0mF5EDXgRvQwftWw==
X-Received: by 2002:a1c:2dd2:: with SMTP id t201mr9244992wmt.136.1557850244405;
        Tue, 14 May 2019 09:10:44 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id l2sm5293724wmf.16.2019.05.14.09.10.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 09:10:43 -0700 (PDT)
Date:   Tue, 14 May 2019 18:10:41 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 8/8] vsock/virtio: make the RX buffer size tunable
Message-ID: <20190514161041.y4exigcwwys34naf@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-9-sgarzare@redhat.com>
 <eddb5a89-ed44-3a65-0181-84f7f27dd2cb@redhat.com>
 <8e72ef5e-cf6a-a635-3f76-bdeac95761b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e72ef5e-cf6a-a635-3f76-bdeac95761b8@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 08:46:19PM +0800, Jason Wang wrote:
> 
> On 2019/5/13 下午6:05, Jason Wang wrote:
> > 
> > On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > > The RX buffer size determines the memory consumption of the
> > > vsock/virtio guest driver, so we make it tunable through
> > > a module parameter.
> > > 
> > > The size allowed are between 4 KB and 64 KB in order to be
> > > compatible with old host drivers.
> > > 
> > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > 
> > I don't see much value of doing this through kernel command line. We
> > should deal with them automatically like what virtio-net did. Or even a
> > module parameter is better.
> > 
> > Thanks
> 
> 
> Sorry, I misread the patch. But even module parameter is something not
> flexible enough. We should deal with them transparently.
> 

Okay, I'll try to understand how we can automatically adapt the RX
buffer size. Since the flow is stream based, the receiver doesn't know the
original packet size.

Maybe I can reuse the EWMA approach to understand if the buffers are
entirely filled or not.
In that case I can increase (e.g. double) or decrease the size.

I'll try to do it!

Thanks,
Stefano
