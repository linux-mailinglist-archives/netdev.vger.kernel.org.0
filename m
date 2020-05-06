Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455031C6CD3
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgEFJZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:25:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728663AbgEFJZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588757153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=Y9jTSvLtFjObNR5orcw8pImdVUB158gBp3uvoCSgF8ddAXvu1+O6piQfB+384b4Qa1f8z0
        8zTR4H+fWOUu2PyaxYGRyZrHkPgqxIovgMDvMnv1xotQQnbt7lP0/caumZn5Fa6sowR7NF
        DVu8kixTPA8Pd3NTnnysWRgaL0l9njg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-34f20u9SMJmeKWvqSj9wnQ-1; Wed, 06 May 2020 05:25:50 -0400
X-MC-Unique: 34f20u9SMJmeKWvqSj9wnQ-1
Received: by mail-wm1-f70.google.com with SMTP id 14so484543wmo.9
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 02:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=Zr8JbeWsp+yWG1sMkv6bpJoEd15Jn11VL+6FS5vSBvcutZTNw3TbllMtOGOcqq8VAY
         fsZJrd2O5BjIfQSvDv7HzzZn6knwPlLsVCMsLdUFVONiUs92lNvnJcMAPwMeS+6h0Iv7
         tE7LtjcNb1VpQxBxr3Dx9JPisg6fe/KxfNI7p+JQCU/qtluM9elRIRp6or2NcKqczB9b
         TEwpI+ITRRnEo6l86gVXJAPABC3reLUk65hwABxvzipGEEMhn96FZJ56L7wpJm3qh5r3
         Wb5YvTyKK6zBviIl80vCqxM+IUFdJ3/ZhFvq5bxEYUt11GiVVZ0WuFc4xPP6TlAECCBZ
         MaXg==
X-Gm-Message-State: AGi0PubNy//BwV8KsX6imDWS9RYgjVpT16/3tqpemPDGfa4ZCEe4T4Ca
        v8zQXouCP1TSZ/0nD9siKnnA7Z/aVjI5MhyFHflPF3LFvq1urOkdtACsBwm7Lq0RRYtY2X6IBRx
        3MnebirNojojqyAMi
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131685wrn.22.1588757149675;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKDcQLCEb81yrXyKaZpg3LwlEaXE+I6k94/3G8d4AwC2GS8U1KX5Fn5b7fyFPoR8Cv9PqLECw==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131657wrn.22.1588757149453;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id c25sm2030281wmb.44.2020.05.06.02.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:25:48 -0700 (PDT)
Date:   Wed, 6 May 2020 11:25:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Justin He <Justin.He@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldigby@redhat.com" <ldigby@redhat.com>,
        "n.b@live.com" <n.b@live.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] vhost: fixes
Message-ID: <20200506092546.o6prnn4d66tavmjl@steredhat>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200506031918-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506031918-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:19:55AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> > Hi Michael
> > 
> > > -----Original Message-----
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Monday, May 4, 2020 8:16 PM
> > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > > stefanha@redhat.com
> > > Subject: [GIT PULL] vhost: fixes
> > >
> > > The following changes since commit
> > > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > >
> > >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >
> > > for you to fetch changes up to
> > > 0b841030625cde5f784dd62aec72d6a766faae70:
> > >
> > >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > > 10:28:21 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: fixes
> > >
> > > A couple of bug fixes.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Jia He (1):
> > >       vhost: vsock: kick send_pkt worker once device is started
> > 
> > Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> > 
> > --
> > Cheers,
> > Justin (Jia He)
> 
> 
> Go ahead, though recently just including Fixes seems to be enough.
> 

The following patch Justin refers to does not contain the "Fixes:" tag:

0b841030625c vhost: vsock: kick send_pkt worker once device is started


I think we should merge it on stable branches, so if needed, I can backport
and send it.

Stefano

