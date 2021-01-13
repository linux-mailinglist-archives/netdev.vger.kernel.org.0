Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651D42F4FA9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbhAMQPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:15:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbhAMQPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:15:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610554461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+bgVaxnOewBSG67HH6+LXedf0FKkNtRDgjYPbazFVQ=;
        b=VIsHYOTVk5HoftlP/RuOj/QmiP624LkwoLnsSTSekBNanSU1EHIrCJIaIp3fhYN2jSBX/h
        zI2y9SuEBMbr0kdZzFBzSRw1q7XvC/Y/pkdx629hLSDrm6Y4UfnxGn2LQ1OKUMzdkvJa3Y
        LoGm/EHaI2lIae6a9NxvNqu/GU8uFzI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-s_SphqpvM2iKPzq3X_agmg-1; Wed, 13 Jan 2021 11:14:19 -0500
X-MC-Unique: s_SphqpvM2iKPzq3X_agmg-1
Received: by mail-wr1-f71.google.com with SMTP id w5so1169408wrl.9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:14:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/+bgVaxnOewBSG67HH6+LXedf0FKkNtRDgjYPbazFVQ=;
        b=tSHeeKfFdkVJ2IuV2G/04/2oUQ6BcAtaqvf9goZe/srTijr7zoOXYBtFwFWeuodByT
         imVtUu8QqAe3H/ayFkjG9XVHc72QwRC5XK85+xzPX7qn+ynsb+WdwK3mB2W+P/a7SEQ4
         esuAbGobKtZGTu1mki1GmTaVmqYQXhWjWRlsNtPAAT5vJQOVrDoaBE6wHCKiJwZbcn+u
         bb1MNmlHNVscRJ1NU83hfDGtSCP1SgjK3EfXgixIkxpxKjjA5HiQQ4TPq6Mg8qU2RtUF
         uEwnLjmZJ+fH+3e4NB9VzqdLitzOKH51TiR2rd4y+ZJ3o7+mXoemOuLafQSTdL76HeNQ
         604A==
X-Gm-Message-State: AOAM533HPBW6q4xiJANpl9YtOG2UD1HQKuPuji4yDrafpmjUfdgBcMB2
        qezKU/22cI51cEVy51diYCxz5pS8Kd80Y+t3ED15u8RTctIRWdRZdPOStMovGi5lvTDZk5h4Qe8
        80BRfTznztNy4BIm0
X-Received: by 2002:adf:eecc:: with SMTP id a12mr3401537wrp.312.1610554458457;
        Wed, 13 Jan 2021 08:14:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjyxcEesIJ5c7y0jYZhpU6NvIGa4tZI8p4lZp0TvMZFrTYeUHcMXtx+n2nX7Hrd7jJMxO46A==
X-Received: by 2002:adf:eecc:: with SMTP id a12mr3401523wrp.312.1610554458302;
        Wed, 13 Jan 2021 08:14:18 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id q15sm3991897wrw.75.2021.01.13.08.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:14:17 -0800 (PST)
Date:   Wed, 13 Jan 2021 11:14:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace
 netdev_alloc_skb_ip_align() with napi_alloc_skb()"
Message-ID: <20210113111337-mutt-send-email-mst@kernel.org>
References: <20210113051207.142711-1-eric.dumazet@gmail.com>
 <2135e96c89ce3dced96c77702f2539ae3ce9d8bb.camel@redhat.com>
 <CANn89iKU9RbxGsMt1t1+o+bQGEE8xz=yv=gadzH3Vua33+=3cg@mail.gmail.com>
 <CANn89iKOiZhOZ1jstMyzfx6KsjfcNmNJ4EFxq=ZbweQyjRtv0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKOiZhOZ1jstMyzfx6KsjfcNmNJ4EFxq=ZbweQyjRtv0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 04:53:38PM +0100, Eric Dumazet wrote:
> On Wed, Jan 13, 2021 at 4:51 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> 
> > To be clear, I now think the revert is not needed.
> >
> > I will post instead a patch that should take care of the problem both
> > for virtio and napi_get_frags() tiny skbs
> 
> Then later, we might change things so that the sk_buff cache being
> changed by Alexander Lobakin
> can also be used for these allocations.

That sounds like a great idea.

-- 
MST

