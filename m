Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8041C0FD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbhI2Ixw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244892AbhI2Ixu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 04:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632905529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2IuDph5pgXKhZLx55AOzdRIaR0YtM8hQePA5+y0Dae8=;
        b=OE+6WL0YcC/Udth22OlrVUkuwVi9CFM72fJtgSaOO2sJYxT8MvS4kddO1wKeR1FnZ0MP3V
        bppK4sq3GkGHFzp/GyypgSX1H+M0Mc87ymzEIp7YGNWxs7q2u4iO+6e65Ex5F19djP/lUH
        pgBgQknEf+SQX7/pH02SW21xLM763ec=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-usHqDWnJMfmrXlqcDV9vLg-1; Wed, 29 Sep 2021 04:52:08 -0400
X-MC-Unique: usHqDWnJMfmrXlqcDV9vLg-1
Received: by mail-ed1-f70.google.com with SMTP id e21-20020a50a695000000b003daa0f84db2so1603785edc.23
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 01:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2IuDph5pgXKhZLx55AOzdRIaR0YtM8hQePA5+y0Dae8=;
        b=K17JhOePa2jHOhnq7V5yco+4t8noKn51VlOzHX1gFvhh0730fZMfxgb7IF6YMeXdN3
         wsWzyNlmqXuWQh79OA1Q1gEumrKnthHttl9smMOKXLexG0bExm58WqEZr+UIQKdmxget
         huuWrS+fbLVy5oUpys1JKl2EKOrem/Qx2HoG1rJTuL0Pycql4dpZh7q2AVBQ1HSuJH3P
         gnR6+Y8hs3CBn/GwMBWwMfiw3bbsWmBkTikqXfpjI76a8ul1z7O+PqM82EaZTkrnSGvf
         Q8ylvrDdtvgiSDwij8MXbt5CYoN4RQf+rv7BIy/FojmL+CaJP+u5wF2XGZdjiDWOsqLV
         VRMA==
X-Gm-Message-State: AOAM533lH1bt6e4OoZ4inLl1Iwm60zICZ234uGkQ63l1s4KJs4pQp4BA
        L544kstzxIvHTxbA7s8a9oBUuiP6dDi1XX2ZS0tgVP1WsTNmfJEJ0KlXg9Z+kBi2FnJHz7BJcIi
        gte7868QU+dyMqJM7yfDWf3YkE1Xz/prH
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12381702ejx.336.1632905527363;
        Wed, 29 Sep 2021 01:52:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtqxbpW9CaUe0Zk3O9ATbb6SACyGDKbqk1vQT4Q7fBlmtOJCKDORBVyAo1j/qBryhevc0gJzRnOU81x+LCRFw=
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12381683ejx.336.1632905527171;
 Wed, 29 Sep 2021 01:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210929075437.12985-1-lulu@redhat.com> <20210929043142-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210929043142-mutt-send-email-mst@kernel.org>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 29 Sep 2021 16:51:29 +0800
Message-ID: <CACLfguX3TPD0VOUngNVDzB_JYPY6AnPP+Jd7bAKTq5egXw93sA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa:fix the worng input in config_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 4:32 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Sep 29, 2021 at 03:54:37PM +0800, Cindy Lu wrote:
> > Fix the worng input in for config_cb,
> > in function vhost_vdpa_config_cb, the input
> > cb.private was used as struct vhost_vdpa,
> > So the inuput was worng here, fix this issue
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> Maybe add
>
> Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
>
> and fix typos in the commit log.
>
thanks Michael, I will post a new version
> > ---
> >  drivers/vhost/vdpa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 942666425a45..e532cbe3d2f7 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -322,7 +322,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
> >       struct eventfd_ctx *ctx;
> >
> >       cb.callback = vhost_vdpa_config_cb;
> > -     cb.private = v->vdpa;
> > +     cb.private = v;
> >       if (copy_from_user(&fd, argp, sizeof(fd)))
> >               return  -EFAULT;
> >
> > --
> > 2.21.3
>

