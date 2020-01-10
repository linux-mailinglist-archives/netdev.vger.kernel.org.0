Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97B136736
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgAJGNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:13:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725797AbgAJGNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578636786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JUb7J5k9pHQGDMgWElpRTaa3UN/XQp4RFy7vMyL+c3E=;
        b=OT9Wu/mKzzAeyjpxRTYXt2RsGZjq/bfXeGs9VMwjAB/u+h/M4mGFzdUZW5r9rFlma1jhcU
        niNyoEAdw9KsJNce8VrLcKD4LqSOy/BUgt75QjjBpmgUZGGYTzNEFAGeWJa98jE2+zIgAV
        bVJf9v7ZlEFRWJPoMsjDm44qYQAZ1QE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-PZYkGlehNV6yuXMav8zVGg-1; Fri, 10 Jan 2020 01:13:03 -0500
X-MC-Unique: PZYkGlehNV6yuXMav8zVGg-1
Received: by mail-qk1-f197.google.com with SMTP id 194so567704qkh.18
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JUb7J5k9pHQGDMgWElpRTaa3UN/XQp4RFy7vMyL+c3E=;
        b=lfWmMlsCHn8x3L+kQPNLDuybQrWhWmzNmZ2pFHyYbxZo+Uem8l66vKIxYCx6XUW0XT
         Aghhrpos3ipdD8sxjOvpo4dN0aT+g+icDge/mdfZ1Q0z5bKEZN60+RPGnyb26Qi4LtX6
         TLRHsW2yACvPkdBfqcQ0ytds8tIyBhjldF7Z96M59qp5C+UMEy8ppwqbiVGap5+67ccG
         u7/eHmc3eAQqO7sPH8QjxGR/JlMtbAzBb1OPWiOk7DnhzsjgAgZzoLVFk4O9nfiNT/E1
         NogmwzvibqEBn0aptWBtObhapac9O7uDSAlf4P7E95Ww3mPQaMx57p7DSR9jbFwaP7Ye
         osMQ==
X-Gm-Message-State: APjAAAW9DnCvp3fXOAXslTH2kqyRgsPbohB0+Nxo5LQfEXHhzxgELGh2
        A+7w+ehnaTO0PGiyRSAh3vHzroS0k80Wb7VHl/qTfRLndRWOri/2qCEysORtsy8fm/yA6QYNCJA
        DRjvHFWBgw4EeKopC
X-Received: by 2002:ac8:6697:: with SMTP id d23mr1080346qtp.350.1578636783316;
        Thu, 09 Jan 2020 22:13:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqyEBnt7IxTIASPQRiXS/2qwYjQd4GY3gTOeHUpypwIPSrQCqrkSOQtY6sfsyfysgAniCEZu/A==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr1080336qtp.350.1578636783113;
        Thu, 09 Jan 2020 22:13:03 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id z3sm546702qtm.5.2020.01.09.22.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 22:13:01 -0800 (PST)
Date:   Fri, 10 Jan 2020 01:12:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, adelva@google.com,
        willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
Message-ID: <20200110011236-mutt-send-email-mst@kernel.org>
References: <20200105132120.92370-1-mst@redhat.com>
 <20200109.183339.173768060466817001.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109.183339.173768060466817001.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 06:33:39PM -0800, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 5 Jan 2020 08:22:07 -0500
> 
> > The only way for guest to control offloads (as enabled by
> > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
> > through CTRL_VQ. So it does not make sense to
> > acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
> > VIRTIO_NET_F_CTRL_VQ.
> > 
> > The spec does not outlaw devices with such a configuration, so we have
> > to support it. Simply clear VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > Note that Linux is still crashing if it tries to
> > change the offloads when there's no control vq.
> > That needs to be fixed by another patch.
> > 
> > Reported-by: Alistair Delva <adelva@google.com>
> > Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Same patch as v1 but update documentation so it's clear it's not
> > enough to fix the crash.
> 
> Where are we with this patch?  There seems to still be some unresolved
> discussion about how we should actually handle this case.
> 
> Thanks.

Once discussion is resolved I'll post v3 with updated commit log.

