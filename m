Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7544BBC54
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiBRPoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:44:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBRPoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:44:15 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C664718C2E7
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:43:58 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id t22so10418494vsa.4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZlNKOu+PC57cWSc9B8bT89/4L+VjMA7vIqhUEFRfco4=;
        b=A5pZd2CbfalKIrQ8Zz9VDALtD8d0Ppxdsa3oKI8TWnym/Jq71tJqV/zLFLqHw1TCfL
         Jnb30zQNSzXZ520Ak7J0JDNC/yND2NIuEY+vYEYpzNHBAkEi5q7SGZ8gyd9SsseC3DUY
         4+/oN3cZhkbPvFl9P/+iAQVAV5+ACUKiF29y3QzCzJL1zk+CKI/GCDooNzXIfjuuNg0A
         eNm7aEjnd2GPMbwdT0IA4nFSMUGbecguG8fpB25GkrFoZFY0VAbtO6MNcK9k4M/7zksj
         tPQmGRwkwaxPerUdlxUj43PPiQfW7/crp2j6XSzi261L87ckszK0zb24UvQVZAc0WeD8
         sYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZlNKOu+PC57cWSc9B8bT89/4L+VjMA7vIqhUEFRfco4=;
        b=An9Lcj8d+sBGoCWeSrx+4qc8G0ILptq7lEeCzXYpoVQiAD0FaEN/qXlI7Ww/jiesVW
         32IzavyCMlQd/FDo5Obaf0/SnnXtcq91HUBAdNXOaOC+4TO0ncIzsbUz+daFKTnf/VZH
         SACj4Za6UKEvudHzSKeyjyDplbRf66VuO+aogDX5ehDTwA5MS9AvwIK5R/BOwqBXnOzz
         p12KR/vcDCJFQfn4t3RygqAP5sNv5E4InYZ/V3NSYjIfSyXDTlqnThLI24wIe0BMuh2U
         BGUw2gpmu87MNT4CTOzzgp1/aLzOfuMlagUyuFPmzX7QRCysQRIgEOasnpcwBdEKZPsz
         +pag==
X-Gm-Message-State: AOAM532rbPkQB3yvPM95tPTHzE6Cgej4RaODgHQJQ1anYJyu5jCmt8N7
        iptLDE7Mm8UNWO2aLJKJyshhey4DQVw=
X-Google-Smtp-Source: ABdhPJyFBj1CJA5hs4a8Duh825hnclVN+dg+3MaALJtteSzc4rikPxXQV2JSB4RFZCfHNEh/YGIoyw==
X-Received: by 2002:a05:6102:4410:b0:31b:725:1fcd with SMTP id df16-20020a056102441000b0031b07251fcdmr3935618vsb.12.1645199037918;
        Fri, 18 Feb 2022 07:43:57 -0800 (PST)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id c66sm179016vkg.35.2022.02.18.07.43.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 07:43:57 -0800 (PST)
Received: by mail-vk1-f169.google.com with SMTP id f12so5033990vkl.2
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:43:56 -0800 (PST)
X-Received: by 2002:a05:6122:788:b0:331:2063:3645 with SMTP id
 k8-20020a056122078800b0033120633645mr3858580vkr.10.1645199036123; Fri, 18 Feb
 2022 07:43:56 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-3-andrew@daynix.com>
 <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
 <CABcq3pFLXUMi3ctr6WyJMaXbPjKregTzQ2fG1fwDU7tvk2uRFg@mail.gmail.com>
 <CA+FuTSfJS6b3ba7eW_u4TAHCq=ctpHDJUrb-Yc3iDwpJHHuBMw@mail.gmail.com> <CABcq3pE9ewELP0xW-BxFCjTUPBf9LFzmde4tMf1Szivb8nMp7g@mail.gmail.com>
In-Reply-To: <CABcq3pE9ewELP0xW-BxFCjTUPBf9LFzmde4tMf1Szivb8nMp7g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 18 Feb 2022 08:43:20 -0700
X-Gmail-Original-Message-ID: <CA+FuTScisEyVdMcK2LJHnT8TTmduPqs20_7SzukkP_OYDEQpwA@mail.gmail.com>
Message-ID: <CA+FuTScisEyVdMcK2LJHnT8TTmduPqs20_7SzukkP_OYDEQpwA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drivers/net/virtio_net: Added basic RSS support.
To:     Andrew Melnichenko <andrew@daynix.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 12:05 PM Andrew Melnichenko <andrew@daynix.com> wrote:
>
> Hi all,
>
> On Mon, Feb 14, 2022 at 12:09 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > > > @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >         u16 max_queue_pairs;
> > > > >         int mtu;
> > > > >
> > > > > -       /* Find if host supports multiqueue virtio_net device */
> > > > > -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> > > > > -                                  struct virtio_net_config,
> > > > > -                                  max_virtqueue_pairs, &max_queue_pairs);
> > > > > +       /* Find if host supports multiqueue/rss virtio_net device */
> > > > > +       max_queue_pairs = 1;
> > > > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> > > > > +               max_queue_pairs =
> > > > > +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
> > > >
> > > > Instead of testing either feature and treating them as somewhat equal,
> > > > shouldn't RSS be dependent on MQ?
> > >
> > > No, RSS is dependent on CTRL_VQ. Technically RSS and MQ are similar features.
> >
> > RSS depends on having multiple queues.
> >
> > What would enabling VIRTIO_NET_F_RSS without VIRTIO_NET_F_MQ do?
>
> RSS would work.

What does that mean, exactly? RSS is load balancing, does that not
require multi-queue?
