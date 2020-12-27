Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18102E30E4
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgL0LU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 06:20:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgL0LU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 06:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609067941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LApBtbLYVR4nVOhn6rQeBe5qLuDrsVTk4tLKcXzpBU=;
        b=IcHbwN1he4rtyQ9IXv30GILx4MhcEff5fGxeqnTKD2O/A7qVBkUOHOMn/eLcDWqMUpdoyn
        AHW8CrN/eRUGN89P3BKoaEM0iT3gX6OMrwVixIkQOj5QOP7rDZKLjZej4Vy7kKcK39q7CU
        Fy+5MZbaJLW/vmNWbLSH3FZdkbJchC0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-AeOMpnDAPluwbgEgfdDkyQ-1; Sun, 27 Dec 2020 06:19:00 -0500
X-MC-Unique: AeOMpnDAPluwbgEgfdDkyQ-1
Received: by mail-wm1-f69.google.com with SMTP id f187so5439275wme.3
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 03:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8LApBtbLYVR4nVOhn6rQeBe5qLuDrsVTk4tLKcXzpBU=;
        b=Hl6NrS8lPuyoNFRA9N2knB82/rYJQ0oMtlE15rb6slgAwZaU/vhLZdO8ZAmYYRxxpR
         Y+M8njFNaUBnIdhUaRD4V73Ehn9W4GPzxMCYNcnOdcakq3Rdek4/5ebqDyZdNn1nJh4I
         ZCSpGTpW50JIFxB1494bFzaQKq5Kz4mt5QuOwcID2qz+HOq6O6NLvLqjurE7lLCH4ux+
         5tgZjxqrzjiBiH0iIP7xdmV3xBN2SaRpYe46Wuvo8pZBZ39yFOuUeAHEul32BZbeCPMy
         thkN2bIoIyY8S/ZYcYvkBVNGVtzcdG4rZRYoyVwVddTQJrs238JXxlWbSCx9iiskeOkI
         q2KQ==
X-Gm-Message-State: AOAM532A+7r4DnJvHQQEj7IUs23YuMAwkp5mWs2Y1jCTXUrZeImJ+6vW
        4cc/ypORF2o7Vx/OCEazJdUId5mKDFZxk++5TRTPytLkqbetpwzm3NBJBskElOOEoVVOH6GlSs3
        zvrfamEWFVAzh6ZDj
X-Received: by 2002:a5d:5105:: with SMTP id s5mr44747941wrt.136.1609067939148;
        Sun, 27 Dec 2020 03:18:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyn4prM0xFLNfmKsCnqirXaeOgmM9Xmrpk1zGoqYAU4AUGjRmjDq8m9TqmaySygRIk0FU1t+w==
X-Received: by 2002:a5d:5105:: with SMTP id s5mr44747927wrt.136.1609067938974;
        Sun, 27 Dec 2020 03:18:58 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id v4sm49928180wrw.42.2020.12.27.03.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 03:18:58 -0800 (PST)
Date:   Sun, 27 Dec 2020 06:18:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: Re: [PATCH net] tun: fix return value when the number of iovs
 exceeds MAX_SKB_FRAGS
Message-ID: <20201227061540-mutt-send-email-mst@kernel.org>
References: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfmKFVZ7_q6nU92YYk-MLKWTa_bkE+L4C8vi5+UQ1_a8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfmKFVZ7_q6nU92YYk-MLKWTa_bkE+L4C8vi5+UQ1_a8A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 10:56:16AM -0500, Willem de Bruijn wrote:
> On Thu, Dec 24, 2020 at 6:51 AM wangyunjian <wangyunjian@huawei.com> wrote:
> >
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> > number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> > we should use -EMSGSIZE instead of -ENOMEM.
> >
> > Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> It might be good to explain why the distinction matters: one denotes a
> transient failure that the caller (specifically vhost_net) can retry,
> the other a persistent failure due to bad packet geometry that should
> be dropped.

It would be good to have a definition of what constitutes a transient
failure. At the moment there's a proposed patch to vhost that
tests for 
	err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS
and we'll likely add EIO to that.

Alternatively, I'm inclined to say any invalid input should
just return EINVAL except maybe for memory access errors
which traditionally are EFAULT.
Then vhost can handle any failure except EINVAL and EFAULT
as transient.

-- 
MST

