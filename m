Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A19327496
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 22:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhB1V26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 16:28:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhB1V2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 16:28:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614547649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h8Erxl2uAhVRjyIZZpSw14ya09f39S8gw2UbjCw0S0w=;
        b=L5ehP8Y9cQhmOOx6QiQSSQGB+tZK+dGanqKHRw7koB1oe7YYcGKTi7pjwkXLifdATlvB22
        VSO0edHkoaA4RTSNv3YgSDYHChv7orqnWee9dy8ct3l/wPNhfOnN59RWlKSacNkYMpo0pP
        qop+Sbw3+b7ia0tdYU4Fm7gs7PvElv0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-gaPYj_jVPUKfjSTV46ar8g-1; Sun, 28 Feb 2021 16:27:27 -0500
X-MC-Unique: gaPYj_jVPUKfjSTV46ar8g-1
Received: by mail-ed1-f72.google.com with SMTP id i6so1391069edq.12
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 13:27:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h8Erxl2uAhVRjyIZZpSw14ya09f39S8gw2UbjCw0S0w=;
        b=ogjurfaXYJV/7EaNWaHJfyWrakQ2nWb1u/PyuPx4bjbHb1IQbVCjywhIFGmjPYrfe3
         Yh/oJoKxbz4UnnlEYnjBzk/pl1mnsI7yh6CmXBi6zWraUm/LXnX81vkYohN6RFdp3wxG
         QoK+n6v/Q1ugjqAF/wbStcvvfeDBTvTJBASdB3duuMFwp64uUKekHQ3K76DiNteLJSfJ
         YuhJSwEHGZr2bSJc/8lZm4A9PYW6q/r86EEDQS8DMIWDTKzdfmOCPaejL97dk5fntu86
         8wahrMltFBfi8zkw02bYla43YrRDLFRGdrwNwkz6Up9Zxx8Aj8IZNx+Bjs3SQ8rDzrTg
         ttwA==
X-Gm-Message-State: AOAM530uMDE8zQftLjlOhkCWS/Yq6ZHS+wWdpGwLP9ONTKW/N+Nb7gqW
        QsCQpdkLuw1hVxJduT7fN336ex9JKqCCXBDgjCfwWW4SoqHWN+B/liAkbVBoQZu7iO4uKQSvL7S
        1wBmUe5GMNgYMd+8p
X-Received: by 2002:a05:6402:50c8:: with SMTP id h8mr13170594edb.360.1614547646399;
        Sun, 28 Feb 2021 13:27:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQ6jCc9+dU7zV1WxCqoV1CE3zGmJfGpzvUi/N9qj2WdyBA/tM4wl7SoqLgRgWmy6Sdh81JZQ==
X-Received: by 2002:a05:6402:50c8:: with SMTP id h8mr13170588edb.360.1614547646299;
        Sun, 28 Feb 2021 13:27:26 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id cq20sm12388210edb.18.2021.02.28.13.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 13:27:25 -0800 (PST)
Date:   Sun, 28 Feb 2021 16:27:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210228162604-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <3e833db8-e132-0b00-34d0-7559bab10123@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e833db8-e132-0b00-34d0-7559bab10123@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 04:56:42PM -0800, Si-Wei Liu wrote:
> 
> Hi Michael,
> 
> Are you okay to live without this ioctl for now? I think QEMU is the one
> that needs to be fixed and will have to be made legacy guest aware. I think
> the kernel can just honor the feature negotiation result done by QEMU and do
> as what's told to.Will you agree?
> 
> If it's fine, I would proceed to reverting commit fe36cbe067 and related
> code in question from the kernel.
> 
> Thanks,
> -Siwei


Not really, I don't see why that's a good idea.  fe36cbe067 is the code
checking MTU before FEATURES_OK. Spec explicitly allows that.

-- 
MST

