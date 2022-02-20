Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DCC4BCE9B
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbiBTNSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:18:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239683AbiBTNR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:17:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EEA740E7B
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 05:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645363057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O5OIMKdTq6zuYT7HitHGg42HGDVHH4hXpFV6GEUd+nw=;
        b=BaSygaw84CrfomW6MHPAhoTTQ/f/IGoVwX+I8QLdxDA6naI5yi0wRwddq/gAhIppfBc3YM
        cGdc6Z/G+PbWYS2Bdkw8KXfpcUihnhS+JBBBhojsq5C4c+PF/EBR3nc748UXgPYS+bkzqT
        fDzyGblXIcc9Mn2V/GEiNQxD6n0Hz38=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-rwAvREZcNpmJSjnTrgEBIg-1; Sun, 20 Feb 2022 08:17:36 -0500
X-MC-Unique: rwAvREZcNpmJSjnTrgEBIg-1
Received: by mail-wr1-f69.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so5895648wrg.19
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 05:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O5OIMKdTq6zuYT7HitHGg42HGDVHH4hXpFV6GEUd+nw=;
        b=h0RUaVefb74isFJou/vQV30+X0ObXxI0txuX37lQFbBmUA6bytzFOR8biMscPiNf7t
         gFP+9Tk04iAL9dHR54JCXeLaD1PrnHBsjyNMyDyS+3HVnwCbCtMUtSpDGZM8eToFgddd
         ITYIuDuctFu+dkI4J2SfZwEFyjZ1HDMu5Qwk4eyOzYlfX2HRU+fkqQek43Nam88/s/hj
         F+NWoQmWgPihKOf97Ywhr5xZcchRsvBPryic2JFtgSK4KGJvTiH/MhHGsh6NPJlYT9Wk
         kqiI8iLXGwGEmopi0m0NHMjKBpKpNhhRVvo8NDBsvFz49ug4IeUQ4af/Zo68j5GZpPdc
         MrAw==
X-Gm-Message-State: AOAM532rjbmnPLjqFxaRCQ09yIqCesmckXJID91oNTp236eqG3oXQoAy
        NHNC7h1XKq0Mgehr9VZhPW9x950Qq5zqCuizvVgQWdpmZMe+95qKminZfd3/Z+96jKXY/mcBu6X
        2obqxieKYD67FJUx/
X-Received: by 2002:a05:600c:3589:b0:37b:b9fb:f939 with SMTP id p9-20020a05600c358900b0037bb9fbf939mr14066338wmq.188.1645363054810;
        Sun, 20 Feb 2022 05:17:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRmBi0QqJHpGmr884+AKGXtd32q6T6Jl+XK/2txKtcCMuV8XOo/I4FCP2NMDb3NuN5veN+Vg==
X-Received: by 2002:a05:600c:3589:b0:37b:b9fb:f939 with SMTP id p9-20020a05600c358900b0037bb9fbf939mr14066329wmq.188.1645363054599;
        Sun, 20 Feb 2022 05:17:34 -0800 (PST)
Received: from redhat.com ([2.55.134.183])
        by smtp.gmail.com with ESMTPSA id x7sm39644133wro.21.2022.02.20.05.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:17:33 -0800 (PST)
Date:   Sun, 20 Feb 2022 08:17:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Andrew Melnichenko <andrew@daynix.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH v3 2/4] drivers/net/virtio_net: Added basic RSS support.
Message-ID: <20220220081148-mutt-send-email-mst@kernel.org>
References: <20220208181510.787069-1-andrew@daynix.com>
 <20220208181510.787069-3-andrew@daynix.com>
 <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
 <CABcq3pFLXUMi3ctr6WyJMaXbPjKregTzQ2fG1fwDU7tvk2uRFg@mail.gmail.com>
 <CA+FuTSfJS6b3ba7eW_u4TAHCq=ctpHDJUrb-Yc3iDwpJHHuBMw@mail.gmail.com>
 <CABcq3pE9ewELP0xW-BxFCjTUPBf9LFzmde4tMf1Szivb8nMp7g@mail.gmail.com>
 <CA+FuTScisEyVdMcK2LJHnT8TTmduPqs20_7SzukkP_OYDEQpwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScisEyVdMcK2LJHnT8TTmduPqs20_7SzukkP_OYDEQpwA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 08:43:20AM -0700, Willem de Bruijn wrote:
> On Thu, Feb 17, 2022 at 12:05 PM Andrew Melnichenko <andrew@daynix.com> wrote:
> >
> > Hi all,
> >
> > On Mon, Feb 14, 2022 at 12:09 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > > > > @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > > >         u16 max_queue_pairs;
> > > > > >         int mtu;
> > > > > >
> > > > > > -       /* Find if host supports multiqueue virtio_net device */
> > > > > > -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> > > > > > -                                  struct virtio_net_config,
> > > > > > -                                  max_virtqueue_pairs, &max_queue_pairs);
> > > > > > +       /* Find if host supports multiqueue/rss virtio_net device */
> > > > > > +       max_queue_pairs = 1;
> > > > > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> > > > > > +               max_queue_pairs =
> > > > > > +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
> > > > >
> > > > > Instead of testing either feature and treating them as somewhat equal,
> > > > > shouldn't RSS be dependent on MQ?
> > > >
> > > > No, RSS is dependent on CTRL_VQ. Technically RSS and MQ are similar features.
> > >
> > > RSS depends on having multiple queues.
> > >
> > > What would enabling VIRTIO_NET_F_RSS without VIRTIO_NET_F_MQ do?
> >
> > RSS would work.
> 
> What does that mean, exactly? RSS is load balancing, does that not
> require multi-queue?

It does, but VIRTIO_NET_F_MQ is a misnomer.
\item[VIRTIO_NET_F_MQ(22)] Device supports multiqueue with automatic
    receive steering.

VIRTIO_NET_F_RSS implies multi queue and does not depend on VIRTIO_NET_F_MQ.

-- 
MST

