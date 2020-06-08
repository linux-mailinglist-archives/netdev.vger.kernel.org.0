Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899041F12A5
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 08:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgFHGCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 02:02:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48291 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728458AbgFHGCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 02:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591596119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h1jA/2yspI1Kg+Xtq3l1EAGzt+HBYj3BxWgseMub36o=;
        b=eiX7vf8LqAOA3oT45nhlA+FpygC4Hqmd9p3PYLBr6NVvbioAgPQU7/+rCIBI4GRMvmXaXo
        Wx23nYR/sPS56AlV12QYpa9L0WNEDsrpGbnWTffPGgzqcE5gkSiPndr6Vk6JWEOGkqAlko
        rtKGeYgCGQd8S4/A0YLTui4AE1GPIRo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-gwxap3ARPyenOPfyS7ettA-1; Mon, 08 Jun 2020 02:01:56 -0400
X-MC-Unique: gwxap3ARPyenOPfyS7ettA-1
Received: by mail-wr1-f70.google.com with SMTP id f4so6711264wrp.21
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 23:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=h1jA/2yspI1Kg+Xtq3l1EAGzt+HBYj3BxWgseMub36o=;
        b=cRRbJy74lv2j8h6GsBbZWflkGUuhcwOUy7IeFktpTvz/Qp8MCOGpIBW5opfBDU2ipl
         yvNUtaY9Qqedo93p+jNEsX7rXtpaF2Iibuc2b7/u5xIt2/DIH3l6Facb1qXPsY4Yul7S
         Sm8ViJjo5vwIe/Z70gyVdIrb38QmqqWIXKwEiQzO83PUtPpJMPjltzzoMcNf6eqgrWW3
         cz9dKoZ2QzN9cvXj/HhrGA32khqYvIfFpC8H50apl9pQvYYk1kQNmVpPw3PixlSfVT6F
         /egYHtoZLG1PosXH7H1q5vy9G/0qHplW5x5GbvxSn2qNuDeHALFeV5MMKQh3dZmz9+lZ
         iZVg==
X-Gm-Message-State: AOAM5334y3Bkro168PyGwsVrP6KvA7ehMuLwEc6THiGPCdOpgy9KO884
        h1b4xTrpVkHgp1gv38YEf1//aq4przhnT/AMkfBd2D8B6PjJElI6w1MvVJsJruIgDQNAc0UnrVa
        5Dumk9O5noBCXKNcQ
X-Received: by 2002:a5d:468d:: with SMTP id u13mr23298764wrq.73.1591596115423;
        Sun, 07 Jun 2020 23:01:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMtROZekUWaS9qn3KFC7xkMhTFpOrxDGPEfYMCPM7y6HFTjboC8wnw+oAxOEoXkXu0WIagpQ==
X-Received: by 2002:a5d:468d:: with SMTP id u13mr23298753wrq.73.1591596115216;
        Sun, 07 Jun 2020 23:01:55 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id g82sm21407426wmf.1.2020.06.07.23.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 23:01:54 -0700 (PDT)
Date:   Mon, 8 Jun 2020 02:01:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 03/13] vhost: batching fetches
Message-ID: <20200608020112-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-4-mst@redhat.com>
 <3323daa2-19ed-02de-0ff7-ab150f949fff@redhat.com>
 <20200604045830-mutt-send-email-mst@kernel.org>
 <6c2e6cc7-27c5-445b-f252-0356ff8a83f3@redhat.com>
 <20200607095219-mutt-send-email-mst@kernel.org>
 <0d791fe6-8fbe-ddcc-07fa-efbd4fac5ea4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d791fe6-8fbe-ddcc-07fa-efbd4fac5ea4@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 11:35:40AM +0800, Jason Wang wrote:
> 
> On 2020/6/7 下午9:57, Michael S. Tsirkin wrote:
> > On Fri, Jun 05, 2020 at 11:40:17AM +0800, Jason Wang wrote:
> > > On 2020/6/4 下午4:59, Michael S. Tsirkin wrote:
> > > > On Wed, Jun 03, 2020 at 03:27:39PM +0800, Jason Wang wrote:
> > > > > On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> > > > > > With this patch applied, new and old code perform identically.
> > > > > > 
> > > > > > Lots of extra optimizations are now possible, e.g.
> > > > > > we can fetch multiple heads with copy_from/to_user now.
> > > > > > We can get rid of maintaining the log array.  Etc etc.
> > > > > > 
> > > > > > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > > > > > Signed-off-by: Eugenio Pérez<eperezma@redhat.com>
> > > > > > Link:https://lore.kernel.org/r/20200401183118.8334-4-eperezma@redhat.com
> > > > > > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > > > > > ---
> > > > > >     drivers/vhost/test.c  |  2 +-
> > > > > >     drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
> > > > > >     drivers/vhost/vhost.h |  5 ++++-
> > > > > >     3 files changed, 47 insertions(+), 7 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > > > > > index 9a3a09005e03..02806d6f84ef 100644
> > > > > > --- a/drivers/vhost/test.c
> > > > > > +++ b/drivers/vhost/test.c
> > > > > > @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
> > > > > >     	dev = &n->dev;
> > > > > >     	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
> > > > > >     	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> > > > > > -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> > > > > > +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
> > > > > >     		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
> > > > > >     	f->private_data = n;
> > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > index 8f9a07282625..aca2a5b0d078 100644
> > > > > > --- a/drivers/vhost/vhost.c
> > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > @@ -299,6 +299,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> > > > > >     {
> > > > > >     	vq->num = 1;
> > > > > >     	vq->ndescs = 0;
> > > > > > +	vq->first_desc = 0;
> > > > > >     	vq->desc = NULL;
> > > > > >     	vq->avail = NULL;
> > > > > >     	vq->used = NULL;
> > > > > > @@ -367,6 +368,11 @@ static int vhost_worker(void *data)
> > > > > >     	return 0;
> > > > > >     }
> > > > > > +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> > > > > > +{
> > > > > > +	return vq->max_descs - UIO_MAXIOV;
> > > > > > +}
> > > > > 1 descriptor does not mean 1 iov, e.g userspace may pass several 1 byte
> > > > > length memory regions for us to translate.
> > > > > 
> > > > Yes but I don't see the relevance. This tells us how many descriptors to
> > > > batch, not how many IOVs.
> > > Yes, but questions are:
> > > 
> > > - this introduce another obstacle to support more than 1K queue size
> > > - if we support 1K queue size, does it mean we need to cache 1K descriptors,
> > > which seems a large stress on the cache
> > > 
> > > Thanks
> > > 
> > > 
> > Still don't understand the relevance. We support up to 1K descriptors
> > per buffer just for IOV since we always did. This adds 64 more
> > descriptors - is that a big deal?
> 
> 
> If I understanding correctly, for net, the code tries to batch descriptors
> for at last one packet.
> 
> If we allow 1K queue size then we allow a packet that consists of 1K
> descriptors. Then we need to cache 1K descriptors.
> 
> Thanks

That case is already so pathological, I am not at all worried about
it performing well.

-- 
MST

