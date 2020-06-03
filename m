Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB9F1EC8EC
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgFCFq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:46:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbgFCFqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591163183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFYS0OZbG8hwL4OxpjxrKV0fFx8ieRxBUuqmPWvEtIg=;
        b=Veibx4R+rbLhSJ9C/od5sYqq+MS/tKfiNxyWGD5VIDDqcDPcW6LF8cYSY15Pp7llPJiVYs
        P3tcBa2GImq0Qwmsei4AI1whVFoi1lAKm+BlpRk3QQiNmYD88+0TVft13xviuJhh+0/Ekt
        QyKdI4CRkQ8RoAGfgRSTOWCXA0W+wEc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-yi4hxHVyNu2qc-obDZSiFg-1; Wed, 03 Jun 2020 01:46:19 -0400
X-MC-Unique: yi4hxHVyNu2qc-obDZSiFg-1
Received: by mail-wm1-f71.google.com with SMTP id b63so1522305wme.1
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 22:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wFYS0OZbG8hwL4OxpjxrKV0fFx8ieRxBUuqmPWvEtIg=;
        b=eI2dWgvTUB0eoV2NgayG/ciCnNZsFO0XSgfIRmYsJHxW1Ol0J1iwglsVeotw9GPCW2
         ujNWb3ZpGjnr412Inx53GJ5/GRjLYO+eXyMCVLnRC+vyrQM9CR17Pdn6jJZGnW0i3/Va
         UNRFGYuc5KQHIyIoiCDD8gnEKhMKDdHU8AkIkF5GcKig94lkJJgBpv8ZNl2Id1r8h1k7
         PILHlJe8Fnu4L2lIC7IkiHpX2uP8Y49JMEapXoAOsD/f8Ime/MwIyiEykGfLl5h/mbD7
         UH+hievjfQxDIBembOMDhIrg+K03YV+VKfJaUczlVHAEQMwgkpwd2WYxjn6Vq+3B9aLJ
         7Q0g==
X-Gm-Message-State: AOAM531ey1L3uCBfm53AEWJiUFiNPwETMPs3SkSgXy2DCzvY8xTA1P7J
        7XIYFjjnDlerpU5OqscBOaMYdyme1Dtf7PCEwi4FO3okVLI158ig4WTbLvkp+Bf9sS0eezH7Fgq
        E2i4wmokdIQ3+SqFX
X-Received: by 2002:a1c:7517:: with SMTP id o23mr6793903wmc.7.1591163178557;
        Tue, 02 Jun 2020 22:46:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWWcvHMWGbwRojFmv9t5UL5Nc9RItm5wpGdiLrpZndMfOKEzQhs5/0Kjxeo9PY/zNdoOyD8Q==
X-Received: by 2002:a1c:7517:: with SMTP id o23mr6793891wmc.7.1591163178293;
        Tue, 02 Jun 2020 22:46:18 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z2sm1536029wrs.87.2020.06.02.22.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 22:46:17 -0700 (PDT)
Date:   Wed, 3 Jun 2020 01:46:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603013600-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
 <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 01:18:54PM +0800, Jason Wang wrote:
> 
> On 2020/6/3 下午12:18, Al Viro wrote:
> > On Wed, Jun 03, 2020 at 11:57:11AM +0800, Jason Wang wrote:
> > 
> > > > How widely do you hope to stretch the user_access areas, anyway?
> > > 
> > > To have best performance for small packets like 64B, if possible, we want to
> > > disable STAC not only for the metadata access done by vhost accessors but
> > > also the data access via iov iterator.
> > If you want to try and convince Linus to go for that, make sure to Cc
> > me on that thread.  Always liked quality flame...
> > 
> > The same goes for interval tree lookups with uaccess allowed.  IOW, I _really_
> > doubt that it's a good idea.
> 
> 
> I see. We are just seeking an approach to perform better in order to compete
> with userspace dpdk backends.
> 
> I tried another approach of using direct mapping + mmu notifier [1] but the
> synchronization with MMU notifier is not easy to perform well.
> 
> [1] https://patchwork.kernel.org/patch/11133009/
> 
> 
> > 
> > > > Incidentally, who had come up with the name __vhost_get_user?
> > > > Makes for lovey WTF moment for readers - esp. in vhost_put_user()...
> > > 
> > > I think the confusion comes since it does not accept userspace pointer (when
> > > IOTLB is enabled).
> > > 
> > > How about renaming it as vhost_read()/vhost_write() ?
> > Huh?
> > 
> > __vhost_get_user() is IOTLB remapping of userland pointer.  It does not access
> > userland memory.  Neither for read, nor for write.  It is used by vhost_get_user()
> > and vhost_put_user().
> > 
> > Why would you want to rename it into vhost_read _or_ vhost_write, and in any case,
> > how do you give one function two names?  IDGI...
> 
> 
> I get you know, I thought you're concerning the names of
> vhost_get_user()/vhost_put_user() but actually __vhost_get_user().
> 
> Maybe something like __vhost_fetch_uaddr() is better.
> 
> Thanks


It's basically vhost_translate_uaddr isn't it?

BTW now I re-read it I don't understand __vhost_get_user_slow:


static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
                                          void __user *addr, unsigned int size,
                                          int type)
{
        int ret;

        ret = translate_desc(vq, (u64)(uintptr_t)addr, size, vq->iotlb_iov,
                             ARRAY_SIZE(vq->iotlb_iov),
                             VHOST_ACCESS_RO);

..
}

how does this work? how can we cast a pointer to guest address without
adding any offsets?



> 
> > 

