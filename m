Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A964471E7F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 00:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhLLXBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 18:01:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230128AbhLLXBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 18:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639350080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nWAAVnbV6MqAjMvta69bjbT9xwzoQtd+RCXC/QhLjKY=;
        b=C44aFaxmLXk2ClxfwtTQpwloudxdgB7ICI21mq+h3EQFau9SjcGI4w6Gts0pQ2K1HHXsMp
        aQMZs0SELS0SpZ7Mb8vjPcjMonqlEYnfkSNRlIzf0GSF5bkG0dqONey867FdAMLfG+K1Jg
        L0xbWqD0P1cC6AmR5n8Oym0wGEKlAO8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-1x-hSnMAPAyINPo4ct8WOw-1; Sun, 12 Dec 2021 18:01:19 -0500
X-MC-Unique: 1x-hSnMAPAyINPo4ct8WOw-1
Received: by mail-wm1-f70.google.com with SMTP id j193-20020a1c23ca000000b003306ae8bfb7so8772679wmj.7
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 15:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nWAAVnbV6MqAjMvta69bjbT9xwzoQtd+RCXC/QhLjKY=;
        b=w6Fn9K4xscgavXb82nRzKGK1TYxrYhplB15AtdIU9hzvbqEHyOfwqJ6zs4oNlqbHar
         Gl7YWCQwbS1TqLkfuij6zus3mGsIwCCdczMz1edmIEELOVKejsAgim77SBh9NK+4N/8s
         yitJz5cL6F7PcmWJ4I67VksdcJD5F3//sUBejmZU3Z+ZGnzeuDJr9pRmgLinQ82dDWsB
         IY4GwmI4i6wS0fY2mQx4uSE9N6FqgEgnPpLEV/vGhRwQkD7Kd9Ako1dYXHyMLqg6hV2p
         rxslrhBfajbXlcR7DBGZRTSTYUJKONsUNCcFHKKFu+Pk2l3RqkmZ8FXc4E24wYuB/Uyb
         BRgw==
X-Gm-Message-State: AOAM530hPBMFOuAAYUX6NYKDiAteHd2MkKcTrWolyG77UJOnTvgpumP4
        XPTclcKMSEZJS7sBLzAYuA7ka3fHlfbX8dIDx1/bgJe6/ijXt3oUOWLiQu+eCedHucHTus4k7au
        sbKWPkGprVfa0LbIB
X-Received: by 2002:adf:f98c:: with SMTP id f12mr28846577wrr.184.1639350077948;
        Sun, 12 Dec 2021 15:01:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQCdHRAXnhC2AijT3mDyv6Ek9NRjuf014yNW66vb72IH9ZLQVQ9UW9yFVsxil1X5rmlgEpzQ==
X-Received: by 2002:adf:f98c:: with SMTP id f12mr28846567wrr.184.1639350077791;
        Sun, 12 Dec 2021 15:01:17 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107e:eefb:294:6ac8:eff6:22df])
        by smtp.gmail.com with ESMTPSA id o4sm10813418wry.80.2021.12.12.15.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 15:01:17 -0800 (PST)
Date:   Sun, 12 Dec 2021 18:01:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, dan.carpenter@oracle.com, hch@lst.de,
        jasowang@redhat.com, jroedel@suse.de, konrad.wilk@oracle.com,
        lkp@intel.com, maz@kernel.org, parav@nvidia.com,
        qperret@google.com, robin.murphy@arm.com, stable@vger.kernel.org,
        steven.price@arm.com, suzuki.poulose@arm.com, wei.w.wang@intel.com,
        will@kernel.org, xieyongji@bytedance.com
Subject: Re: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20211212180010-mutt-send-email-mst@kernel.org>
References: <20211212175951-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212175951-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The email subject is wrong. it's just bugfixes.
But the tag is ok, and that's what matters, right?

On Sun, Dec 12, 2021 at 05:59:58PM -0500, Michael S. Tsirkin wrote:
> The following changes since commit 0fcfb00b28c0b7884635dacf38e46d60bf3d4eb1:
> 
>   Linux 5.16-rc4 (2021-12-05 14:08:22 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to bb47620be322c5e9e372536cb6b54e17b3a00258:
> 
>   vdpa: Consider device id larger than 31 (2021-12-08 15:41:50 -0500)
> 
> ----------------------------------------------------------------
> virtio,vdpa: bugfixes
> 
> Misc bugfixes.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       virtio: always enter drivers/virtio/
> 
> Dan Carpenter (3):
>       vduse: fix memory corruption in vduse_dev_ioctl()
>       vdpa: check that offsets are within bounds
>       vduse: check that offset is within bounds in get_config()
> 
> Parav Pandit (1):
>       vdpa: Consider device id larger than 31
> 
> Wei Wang (1):
>       virtio/vsock: fix the transport to work with VMADDR_CID_ANY
> 
> Will Deacon (1):
>       virtio_ring: Fix querying of maximum DMA mapping size for virtio device
> 
>  drivers/Makefile                        | 3 +--
>  drivers/vdpa/vdpa.c                     | 3 ++-
>  drivers/vdpa/vdpa_user/vduse_dev.c      | 6 ++++--
>  drivers/vhost/vdpa.c                    | 2 +-
>  drivers/virtio/virtio_ring.c            | 2 +-
>  net/vmw_vsock/virtio_transport_common.c | 3 ++-
>  6 files changed, 11 insertions(+), 8 deletions(-)

