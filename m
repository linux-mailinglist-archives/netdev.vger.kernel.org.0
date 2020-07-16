Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1462228C9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgGPRRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:17:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbgGPRRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594919826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3fQB3h1kkyYLBylVq5k4Bhd4Kz/DPg9j4ID1VQtmqZc=;
        b=OHB2c3jXF/BdQg3EeXmxv7KJBKLewakgHAePOm9lFr+h03POqpwE4eEh3DYyPufRFvXg13
        j3Hc6nXyzY6WX4WIVMiiEFPTJKcNFCe8yfZKFsM8uASGO5qH9tMn3S0eBRkwxeAUuZB7E6
        mDHadzT5zCqkL5C1Q0GAEw03hz2EpQc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-TQiF8C9tOKucLGuPip5oMw-1; Thu, 16 Jul 2020 13:17:04 -0400
X-MC-Unique: TQiF8C9tOKucLGuPip5oMw-1
Received: by mail-qt1-f199.google.com with SMTP id z26so4265288qto.15
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 10:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fQB3h1kkyYLBylVq5k4Bhd4Kz/DPg9j4ID1VQtmqZc=;
        b=BZSJBCQiaeQDvQaZ/KsZESyVTzBdICHgkl10nDAgIFXPV2XufR7A2Stp9Xbf+bCG7m
         8KHuYAgFUU1E+I1VIQvNK0M0LeHIy8Rs4W2ruhrazoKCL3RHPdaasCIR9IcCVxWropio
         iLeuGB8j6L7HNviwSOiwanRFBSCXqZV1zc6BXz+iUXQQ4AvsoD5yvtGMyEGUxkzefpf2
         vSqmXm9nVumh2nubw509HnoJnNfyQJ2OgPcDu7IPj3sze9v28qb3YLYeYur1koWAkGMt
         Du9FeXSZNl40Bqp044lMGqy3peLrsQlvtopGdVTUmI8Bkl5KEnY6LaWNyqUvjew0OfjN
         Ai6Q==
X-Gm-Message-State: AOAM5327VRt6GVm5wR7f9zIG5JSAqV2O9vv5tTVz4PURBVJpyOduLewV
        fXcb3EG46tWCyAGkpzjFAr+Ms6F/wopKg7l8U+oOK97dQoSFvO4x1wZCoI/1AGitmenSUDVkSbG
        HWjAk8CgSzF28yrciHX3OadNRrzabPa82
X-Received: by 2002:a05:620a:11b3:: with SMTP id c19mr5023051qkk.203.1594919824436;
        Thu, 16 Jul 2020 10:17:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyyC+DL23IP8O9brTPle0l22Dr445jM9hQ5TROISxF5aP01PD5Cpgh6/ubiVQT+bVCdjlg6+/nT3WxD41Gj1I=
X-Received: by 2002:a05:620a:11b3:: with SMTP id c19mr5023025qkk.203.1594919824159;
 Thu, 16 Jul 2020 10:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200622122546-mutt-send-email-mst@kernel.org>
 <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com> <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com> <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org> <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com> <20200710015615-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200710015615-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 16 Jul 2020 19:16:27 +0200
Message-ID: <CAJaqyWf1skGxrjuT9GLr6dtgd-433y-rCkbtStLHaAs2W2jYXA@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:58 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jul 10, 2020 at 07:39:26AM +0200, Eugenio Perez Martin wrote:
> > > > How about playing with the batch size? Make it a mod parameter instead
> > > > of the hard coded 64, and measure for all values 1 to 64 ...
> > >
> > >
> > > Right, according to the test result, 64 seems to be too aggressive in
> > > the case of TX.
> > >
> >
> > Got it, thanks both!
>
> In particular I wonder whether with batch size 1
> we get same performance as without batching
> (would indicate 64 is too aggressive)
> or not (would indicate one of the code changes
> affects performance in an unexpected way).
>
> --
> MST
>

Hi!

Varying batch_size as drivers/vhost/net.c:VHOST_NET_BATCH, and testing
the pps as previous mail says. This means that we have either only
vhost_net batching (in base testing, like previously to apply this
patch) or both batching sizes the same.

I've checked that vhost process (and pktgen) goes 100% cpu also.

For tx: Batching decrements always the performance, in all cases. Not
sure why bufapi made things better the last time.

Batching makes improvements until 64 bufs, I see increments of pps but like 1%.

For rx: Batching always improves performance. It seems that if we
batch little, bufapi decreases performance, but beyond 64, bufapi is
much better. The bufapi version keeps improving until I set a batching
of 1024. So I guess it is super good to have a bunch of buffers to
receive.

Since with this test I cannot disable event_idx or things like that,
what would be the next step for testing?

Thanks!

--
Results:
# Buf size: 1,16,32,64,128,256,512

# Tx
# ===
# Base
2293304.308,3396057.769,3540860.615,3636056.077,3332950.846,3694276.154,3689820
# Batch
2286723.857,3307191.643,3400346.571,3452527.786,3460766.857,3431042.5,3440722.286
# Batch + Bufapi
2257970.769,3151268.385,3260150.538,3379383.846,3424028.846,3433384.308,3385635.231,3406554.538

# Rx
# ==
# pktgen results (pps)
1223275,1668868,1728794,1769261,1808574,1837252,1846436
1456924,1797901,1831234,1868746,1877508,1931598,1936402
1368923,1719716,1794373,1865170,1884803,1916021,1975160

# Testpmd pps results
1222698.143,1670604,1731040.6,1769218,1811206,1839308.75,1848478.75
1450140.5,1799985.75,1834089.75,1871290,1880005.5,1934147.25,1939034
1370621,1721858,1796287.75,1866618.5,1885466.5,1918670.75,1976173.5,1988760.75,1978316

pktgen was run again for rx with 1024 and 2048 buf size, giving
1988760.75 and 1978316 pps. Testpmd goes the same way.

