Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A29D3958E0
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhEaKWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:22:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230518AbhEaKWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622456429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+I4L8Ybm0KB4Gou+uepbAq9mkXVhCftc/wwnbvVOfU=;
        b=ED1/MRfNBtXi8RWgpJk8Q16ERjrjDdpJF29y7YqEQ+m144VUD5NPpNcF1XBb/3QSKGnyvH
        ugAWI7VKqhMXLokB/pqSGvgarbsq0IrnBNiFaf3M8SdtPGAg6zhLpAJJPi2U+j71+oMUT0
        ISneGiwk0eQcU2mmSO8DRt+eEFx+ecM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58--2W4wE8WPpWGmLTAI-EmYw-1; Mon, 31 May 2021 06:20:26 -0400
X-MC-Unique: -2W4wE8WPpWGmLTAI-EmYw-1
Received: by mail-wr1-f70.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so2093332wrc.16
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h+I4L8Ybm0KB4Gou+uepbAq9mkXVhCftc/wwnbvVOfU=;
        b=hcG74CskwXeiy/V90KL0sq0Qe5MIet2yBDF28sC+91wCGTy+xTc0ei07uGaDcXXvts
         2aF3R4qWfNgDMhP4Fy0eUPSru73+iT+JYO6LfX6ggGqFXzZUYkkytkDBctHPzpNoa+vy
         qbvYrfKmXZUKwzadxn0UkOxPP2tAjagMOQU1mKod07BKehXv0tRCe1eijVz3xIKJmOU8
         xtCTZHzzzS1ZkVIzZyCWlJpiJzAy3784TOiNarDtqqOZtIiMbcICK2O6YNwGHp7fiO1W
         o/HHy8BBV8qo6Lh270Z29NtxoGTENTxzahfQWJLMoU40x5fRRSaEfvSZfH31e/wwT1jo
         h7Mg==
X-Gm-Message-State: AOAM533RF5EMgTM67O7lD7Fgf0K81+GWjKCXzqswjX5Cp1QsOO5Q3zmJ
        dX6j8d9ZDgVjFsshUI3fYqah2GKrjy04f6qMiofnKNWNvtAFlORDWmIpPs99jFVHeHajsUb/q7O
        9zx/UOs3YXpwEuDaB
X-Received: by 2002:a7b:c7c6:: with SMTP id z6mr20568565wmk.35.1622456424932;
        Mon, 31 May 2021 03:20:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPYHUVdhYBLl6N+z8Oi12/8I7xJS2//O9Zz03YW4kCtGt7KRIltZrH+UlPPfleL3cO8QH9mQ==
X-Received: by 2002:a7b:c7c6:: with SMTP id z6mr20568557wmk.35.1622456424786;
        Mon, 31 May 2021 03:20:24 -0700 (PDT)
Received: from redhat.com ([2a00:a040:196:94e6::1002])
        by smtp.gmail.com with ESMTPSA id u8sm5115260wrb.77.2021.05.31.03.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:20:24 -0700 (PDT)
Date:   Mon, 31 May 2021 06:20:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] virtio: update virtio id table, add
 transitional ids
Message-ID: <20210531061955-mutt-send-email-mst@kernel.org>
References: <20210531072743.363171-1-lingshan.zhu@intel.com>
 <20210531072743.363171-2-lingshan.zhu@intel.com>
 <20210531095804.47629646.cohuck@redhat.com>
 <53862384-be2b-4a5f-adbb-37eb25ec9fe1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53862384-be2b-4a5f-adbb-37eb25ec9fe1@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 05:57:47PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 5/31/2021 3:58 PM, Cornelia Huck wrote:
> > On Mon, 31 May 2021 15:27:42 +0800
> > Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> > 
> > > This commit updates virtio id table by adding transitional device
> > > ids
> > > virtio_pci_common.h
> > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > ---
> > >   include/uapi/linux/virtio_ids.h | 12 ++++++++++++
> > >   1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
> > > index f0c35ce8628c..fcc9ec6a73c1 100644
> > > --- a/include/uapi/linux/virtio_ids.h
> > > +++ b/include/uapi/linux/virtio_ids.h
> > > @@ -57,4 +57,16 @@
> > >   #define VIRTIO_ID_BT			28 /* virtio bluetooth */
> > >   #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
> > > +/*
> > > + * Virtio Transitional IDs
> > > + */
> > > +
> > > +#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
> > > +#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
> > > +#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
> > > +#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
> > > +#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
> > > +#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
> > > +#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
> > > +
> > >   #endif /* _LINUX_VIRTIO_IDS_H */
> > Isn't this a purely virtio-pci concept? (The spec lists the virtio ids
> > in the common section, and those transitional ids in the pci section.)
> > IOW, is there a better, virtio-pci specific, header for this?
> Hi Cornelia,
> 
> yes they are pure virtio-pci transitional concept. There is a virtio_pci.h,
> but not looks like
> a good place for these stuffs, Michael ever suggested to add these ids to
> virtio_ids.h, so I have
> chosen this file.
> 
> https://www.spinics.net/lists/netdev/msg739269.html

Didn't think straight, virtio_pci.h is better.

> Thanks
> Zhu Lingshan
> > 

