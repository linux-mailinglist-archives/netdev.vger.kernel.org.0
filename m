Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CA2400BB3
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhIDOrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 10:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbhIDOrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 10:47:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC94C0613CF
        for <netdev@vger.kernel.org>; Sat,  4 Sep 2021 07:46:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id h9so3994268ejs.4
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGGhM1W4cUcmHXpwbpm+c3b/vJrXUQ7gtGxBdY0GKN0=;
        b=ZhNaJycbdwLvqtID0KJFVrzlrI+E+ZY/eqvfgHhYnbwn7HXlbQmIlZ8Wi4PT4F6+NZ
         81VnBT7aP5BMFAHPNneJQHXVeG15EGVjjFAuBSr/tdWyLh/KDbupWG1EQZRAgx+c7AnV
         9r/QxfFEGGPv+IIaiuSbX7R8N3KzfdjOYOj5RZmqRYGvN8T31v8X2nTn07BkcuiqW8bI
         epxGMMKy27fdljcMcTkbxz3oLIMpu9zkycZQ+Aqh6N5FMFnGad84PmAqQqZ/w+YYrR3K
         3XP3LTeWo9B8LUiGGO3wwAExbP9eYY6p8/4Dd84VSfAKd1ztc6x9hvyGIrBJ+e1yAGEU
         SfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGGhM1W4cUcmHXpwbpm+c3b/vJrXUQ7gtGxBdY0GKN0=;
        b=kpXxZjT3pde0tnrt5hqnsRrOA+cHhIJdvdyicbCQeBG8KsK4NXrDfr/HrOXtzKtao8
         QWjmMmC2x1a+Q39tuVVZhY04uQjrroz+pVbhiWkMIZO+SUXu+1HLRi3N5t7EHT8tnZFM
         cd4aVdvYF5X47FNc/1o/UReWPv1jpT5UGU7GFUAepopqlP3eUcxJKCkjsfoMy7ada826
         r+E9je+GdQNJVGLaB+jVCdnW6OejMUAX2SknF4YEQWiY5245lyCwiRrjaBDGvJNYemOI
         KjtxvwW3FCYIjM5eB/WgaJPWrmSWTRboH4vhREa8MBpBz7fpHRPXuulgtb/hYHENkZlR
         58wA==
X-Gm-Message-State: AOAM530WvurvypZtsjZmZVjxTjkUhpn1RsM65qvTzmFY0c19ll4EotaV
        iWKj5kAG6K13Gua7sIS1SSFQxnHGw6GcJg==
X-Google-Smtp-Source: ABdhPJzrMvKnAr2HngTXw/JUxibCivEEFtkaxch10WE5iL4DYjv4DGEmL+Q6LKgWDgcIQJbSm1R1gQ==
X-Received: by 2002:a17:906:c249:: with SMTP id bl9mr4557272ejb.225.1630766779249;
        Sat, 04 Sep 2021 07:46:19 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id b5sm1160511ejq.56.2021.09.04.07.46.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 07:46:18 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id b10so2979315wru.0
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 07:46:18 -0700 (PDT)
X-Received: by 2002:a5d:464f:: with SMTP id j15mr4313299wrs.325.1630766777712;
 Sat, 04 Sep 2021 07:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
 <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com> <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
In-Reply-To: <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 4 Sep 2021 10:45:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com>
Message-ID: <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 3, 2021 at 7:27 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Sep 3, 2021 at 12:38 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
>
> <snip>
>
> > > whereas if the offset is stored somewhere in the unstripped data we
> > > could then drop the packet and count it as a drop without having to
> > > modify the frame via the skb_pull.
> >
> > This is a broader issue that userspace can pass any csum_start as long
> > as it is within packet bounds. We could address it here specifically
> > for the GRE header. But that still leaves many potentially bad offsets
> > further in the packet in this case, and all the other cases. Checking
> > that specific header seems a bit arbitrary to me, and might actually
> > give false confidence.
> >
> > We could certainly move the validation from gre_handle_offloads to
> > before skb_pull, to make it more obvious *why* the check exists.
>
> Agreed. My main concern is that the csum_start is able to be located
> somewhere where the userspace didn't write. For the most part the
> csum_start and csum_offset just needs to be restricted to the regions
> that the userspace actually wrote to.

I don't quite follow. Even with this bug, the offset is somewhere userspace
wrote. That data is just pulled.

> > > Maybe for those
> > > cases we need to look at adding an unsigned int argument to
> > > virtio_net_hdr_to_skb in which we could pass 0 for the unused case or
> > > dev->hard_header_len in the cases where we have something like
> > > af_packet that is transmitting over an ipgre tunnel. The general idea
> > > is to prevent these virtio_net_hdr_to_skb calls from pointing the
> > > csum_start into headers that userspace was not responsible for
> > > populating.
> >
> > One issue with that is that dev->hard_header_len itself is imprecise
> > for protocols with variable length link layer headers. There, too, we
> > have had a variety of bug fixes in the past.
> >
> > It also adds cost to every user of virtio_net_hdr, while we only know
> > one issue in a rare case of the IP_GRE device.
>
> Quick question, the assumption is that the checksum should always be
> performed starting no earlier than the transport header right? Looking
> over virtio_net_hdr_to_skb it looks like it is already verifying the
> transport header is in the linear portion of the skb. I'm wondering if
> we couldn't just look at adding a check to verify the transport offset
> is <= csum start? We might also be able to get rid of one of the two
> calls to pskb_may_pull by doing that.

Are you referring to this part in the .._NEEDS_CSUM branch?

                if (!skb_partial_csum_set(skb, start, off))
                        return -EINVAL;

                p_off = skb_transport_offset(skb) + thlen;
                if (!pskb_may_pull(skb, p_off))
                        return -EINVAL;

skb_partial_csum_set is actually what sets the transport offset,
derived from start.
