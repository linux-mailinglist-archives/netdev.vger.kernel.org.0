Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB3630FC5C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhBDTOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238458AbhBDShl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:37:41 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A615C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:36:43 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id s61so4196184ybi.4
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UqMQ/GMTZ6SvjPq30QG7VPUvPnPGHPYTqgfLdXQVAkc=;
        b=LyZ3A3Lmzqa4HkekOWrcIkvNIGnTiP8h7yn6jpXCpK655PcTayjIddQGPC2ppHDZbt
         DNYCPOMVwbxvrROgrXImQT/KspeG7SDBbwGktObKI3gkhQuesBOKqEJbYsco4Q+F7Y7M
         RPpECwGpoNRF/5S1x0NAovWaucKKgZsW9SonsWJ7l7i1G0r8VKOK9snb9JMlQrfIM0gJ
         L6tQSphrZCO6JLcWzgfXjAQsqzRnJ2EvIdNW3DEhNQ6+ox5vsJLwexcdqVBZf4Fvy8yp
         ZSv8G0CH2ZtFiyMxh8f1/ZX5NMrRP05x5G7AtfhLUqI/BjuWNuh/h1d1fZj/ytGHeaQu
         4MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UqMQ/GMTZ6SvjPq30QG7VPUvPnPGHPYTqgfLdXQVAkc=;
        b=oD4l+ZIdLJ6Cwe5jlqdGyqb9rpTNhM9GKehDQEBVHOtv3FACNaizuHdVxj/PbbjZC7
         9RdSKJGshmUurwic4BvytEJhUX2i4lzjPz3jhKZXUqgmQtlDCWMOCBch5T/16NW9fZ+5
         lrnBhjDWb4ENRoJ8IJ961KvTGObnqkaMsEelRjksg8hf4zeu7xQ+j1VYENEtBIcoz7KS
         P2YSGxViFGQTwI77Ccw13r/wcg5vmp+hXRxIPiAtT/od0136mh9e/s1GikKnefVckJLo
         qlKQplRkF79dDdobWvGUBD9oxPbKFWxgS6qGzmbAOVBWuAMC/lhhAOb56wJPWyIJcbjy
         Gylg==
X-Gm-Message-State: AOAM530ntcU+/3F/HaKHTgTCuqvr1vYctgJBfKElCy22bPpyjLXgB4aS
        kBfmYaqWtB0Arhc0UbMsxrxiGwMJPW4eK1kcCho=
X-Google-Smtp-Source: ABdhPJzNloHxgGPC4oJnyoA85Rq0G3DJrGU2d/8HUY7WajfwjT60zC6XBiMPLUIpZyr5jC/YDS6BF20iR9+NzsehnJo=
X-Received: by 2002:a25:ba13:: with SMTP id t19mr806489ybg.129.1612463802396;
 Thu, 04 Feb 2021 10:36:42 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-9-borisp@mellanox.com>
 <a104a5d1-b4cb-4275-6ced-b80f911b6f47@grimberg.me>
In-Reply-To: <a104a5d1-b4cb-4275-6ced-b80f911b6f47@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 4 Feb 2021 20:36:31 +0200
Message-ID: <CAJ3xEMhSxrjLfDvfzVRCLb27K4KmRh-KHQaKxvDF_6VDbNN8Jw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 08/21] nvme-tcp : Recalculate crc in the end
 of the capsule
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 11:12 AM Sagi Grimberg <sagi@grimberg.me> wrote:

> > @@ -1841,8 +1913,10 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
> >       nvme_tcp_restore_sock_calls(queue);
> >       cancel_work_sync(&queue->io_work);
> >
> > -     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
> > +     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
> > +         test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
> >               nvme_tcp_unoffload_socket(queue);
> > +
>
> extra newline

will remove

> >   }
> >
> >   static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
> > @@ -1970,8 +2044,6 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
> >   {
> >       int ret;
> >
> > -     to_tcp_ctrl(ctrl)->offloading_netdev = NULL;
> > -
>
> Unclear what is the intent here.

yep, unclear indeed.. will look and probably remove

as for your other comment on this patch, will get back to you later on

> >       ret = nvme_tcp_alloc_queue(ctrl, 0, NVME_AQ_DEPTH);
> >       if (ret)
> >               return ret;
