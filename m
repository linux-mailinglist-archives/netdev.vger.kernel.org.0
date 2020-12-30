Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BCA2E7A4D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgL3P1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgL3P1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 10:27:04 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEC8C06179C
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 07:26:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j16so15724063edr.0
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 07:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uFUnyHgVyxuAtcRfcUjkuOgvyPAUgs/GS4VZo6V2EjY=;
        b=OeyEzg4V/aAACZ5WHrZtTgzeyRkX9dR1DakXcYGb6HpW0nZLrHmNUTBsnBP2KFaiiU
         iOvw2Uwo16qyOH63s9Gm2Md+VIjnFMyVYx/hqyGpYmDhMIGRe/hOr4qhldPYy703A+SB
         JX+79yp/Mb5TAHh9HWx6HXB2+j7Y7XoMOXSlPoLN6EpTJ4nHIK1ITdK81nnnKLNjBMC4
         GsOkNhjPIRcZLBXTaQZ9TMEP9Gmx9FG2VZ+2GB4D7tFfTs5uHhyYSh0IWJfdJxg9cg0p
         Ax5r+StVcwQLSjZPH5X4qUHE/V1FqiBD+yKiMJehgoAJkFQM3OI4745vkZXB4amaZ4ns
         UQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uFUnyHgVyxuAtcRfcUjkuOgvyPAUgs/GS4VZo6V2EjY=;
        b=cWBLEsOvGJiUmqg9gfDygCRBBM8LXmxeC5hQPl8M9lyJfCoFfTQvLs/ZUnVzPvH9bb
         5gAIs7NcZSFFhFkJrrI7Q3wUaq09wmKdWtsUFlx5KiT6kgD9K9i8MKTX2NEAAK3B/536
         wn/PH8R/JI4vn92zkq96Db2VvkD6BKYyGbzjOXX9Lucwr+OV8fe9GTgSnFtlX2zA6ajC
         hOnqQKO3taSv5SWNKiuxwswE/7UwS8P/vNTRScuSkbcj37TjNrYARz026OhI1jSE3X0B
         tt5UB0K8P7UIuIvsBYAHTjLAAYbGFYxdnAZ+AwtSoXrAnxU4LmV1O5btU8HC+M2X9R9Q
         FFFg==
X-Gm-Message-State: AOAM533UEqHbvSNde8vSEj1VIVJlH5l54EPYM2tf/X/7ope+YSIiTt2D
        sU4okj7Laeb1Pfg3W+li1lrXZxyWW/B7OgXC0y8=
X-Google-Smtp-Source: ABdhPJzQNQAMolyl/FTKvwlV8rMw5P1Y8XV7RnokIFHNgGsZR+KndkMpIK62C9KqeH1cViiMOgpkAg62xMVFkhZW1K4=
X-Received: by 2002:aa7:c603:: with SMTP id h3mr46830503edq.254.1609341982552;
 Wed, 30 Dec 2020 07:26:22 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-4-willemdebruijn.kernel@gmail.com> <20201230123854.GB2034@hoboy.vegasvil.org>
In-Reply-To: <20201230123854.GB2034@hoboy.vegasvil.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 30 Dec 2020 10:25:46 -0500
Message-ID: <CAF=yD-Ly3cdpj+B25Zgu+KYCE8ijV0+fQ_ssgjBAG2w8=iAp-Q@mail.gmail.com>
Subject: Re: [PATCH rfc 3/3] virtio-net: support transmit timestamp
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 7:38 AM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:33AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional delivery time (SO_TXTIME) offload for virtio-net.
> >
> > The Linux TCP/IP stack tries to avoid bursty transmission and network
> > congestion through pacing: computing an skb delivery time based on
> > congestion information. Userspace protocol implementations can achieve
> > the same with SO_TXTIME. This may also reduce scheduling jitter and
> > improve RTT estimation.
>
> This description is clear, but the Subject line is confusing.  It made
> me wonder whether this series is somehow about host/guest synchronization
> (but your comments do explain that that isn't the case).
>
> How about this instead?
>
>    virtio-net: support future packet transmit time

Yes, that's clearer. As is, this could easily be mistaken for
SOF_TIMESTAMPING_TX_*, which it is not. Will update, thanks.

Related terms already in use are SO_TXTIME, Earliest Delivery Time
(EDT) and Earliest TxTime First (ETF).

I should probably also s/TX_TSTAMP/TX_TIME/  in the code for the same reason.
