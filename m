Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7AD1F1309
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgFHGqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 02:46:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37943 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgFHGqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 02:46:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591598758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05DDfjAfIHUdRf5Uem2N9ccJI7OdmXrAgeiSijOGnoQ=;
        b=Oh8XejA4PYyE/bScZJ9LQN9zCgIzh5IUwPjgFSqYsbvhLAYwBiaWu+60nZanaKZco37/eo
        OuMs5rvltpu2oEkUCfk9Gz1d7YixoyAWmfhAlYFh1mN9twoSnPJwwDDl98LBLG5hRMqTzN
        N47dDoNRWvCvKUTsjGNhKGEnsNhRycw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-6zZV5iN9PBqfsm4JB9jftg-1; Mon, 08 Jun 2020 02:45:54 -0400
X-MC-Unique: 6zZV5iN9PBqfsm4JB9jftg-1
Received: by mail-wr1-f70.google.com with SMTP id e7so6782513wrp.14
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 23:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=05DDfjAfIHUdRf5Uem2N9ccJI7OdmXrAgeiSijOGnoQ=;
        b=Iqcuj9ObWPBz9lnabUdipC7mq6VCvx8UTvScTpT2mFzjRwa5urYgS8D8svDo+meKoa
         bKRCxGkvGjqIP8ouX/laHN/vcDys3WsYSDzBeTHdK28haXQJrUREVsATxfKix/LVoT5w
         TGJilnEas0iSYAazbggjcuh/UfMpEOw5NFS5vT8xEVhzGPMI7hJbBw4xVA4IaEVmew48
         nnOhZ9MOUIkhMqidU6kkmWLWpJqEIJmIlAwspphT0bS6eFNNclyTu3y+lXTdsvAc7DlH
         f+DmUC7bdxhaQlicsLHWZtpbiqjOe/ov+VmrGSONsH8qMRp56jyzhBmv9bN+HXEYx+aT
         UTwA==
X-Gm-Message-State: AOAM530NunRuqLNjDwSPn71mZ+eI8vdwGHlbPu9N6/70kFQcSSdtwp+q
        tlDHohe6AdiezkThW+3sMvFhj0YSPUWO6cHGTwl9Y61Wf2OHlR3MH/T5AqiJqtUn3qoSSqi/mBX
        sUp+vert9jqEK2mlF
X-Received: by 2002:a5d:5261:: with SMTP id l1mr22608222wrc.246.1591598753584;
        Sun, 07 Jun 2020 23:45:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKhmvKgwfu6GksB3KTO4SFsuK8YxZWmnpeKf96R+VzqaaCilkPcOAlU2/3T/svRcNiLt4VEA==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr22608211wrc.246.1591598753423;
        Sun, 07 Jun 2020 23:45:53 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id x18sm20730927wmi.35.2020.06.07.23.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 23:45:52 -0700 (PDT)
Date:   Mon, 8 Jun 2020 02:45:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
Subject: Re: [PATCH RFC v5 13/13] vhost: drop head based APIs
Message-ID: <20200608023311-mutt-send-email-mst@kernel.org>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-14-mst@redhat.com>
 <8e3f5b6f-a47b-73cd-e8e3-959d40f6c91c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e3f5b6f-a47b-73cd-e8e3-959d40f6c91c@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 11:57:48AM +0800, Jason Wang wrote:
> 
> On 2020/6/7 下午10:11, Michael S. Tsirkin wrote:
> > Everyone's using buf APIs, no need for head based ones anymore.
> > 
> > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > ---
> >   drivers/vhost/vhost.c | 36 ++++++++----------------------------
> >   drivers/vhost/vhost.h | 12 ------------
> >   2 files changed, 8 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 72ee55c810c4..e6931b760b61 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2299,12 +2299,12 @@ static int fetch_buf(struct vhost_virtqueue *vq)
> >   	return 1;
> >   }
> > -/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> > +/* Revert the effect of fetch_buf. Useful for error handling. */
> > +static
> >   void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> >   {
> >   	vq->last_avail_idx -= n;
> >   }
> > -EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> 
> 
> The same question as previous version.
> 
> Do we need to rewind cached descriptor here?
> 
> Thanks

Good point.  This needs more thought, we need to also
rewind the avail idx each time we flush the descriptor cache.

-- 
MST

