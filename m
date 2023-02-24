Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE16A17B1
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBXIGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBXIGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:06:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD35279B8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677225922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=71xwYKbSApQaBVT454tBZreSDV1iE1mCC6MU3vS/TrY=;
        b=GpxuatPS4h/xq4A9il0yWu2+LIKxoYBbUwSoI8FHx3DIhPoMp5ybQ7WVbzh85D2wHgRdpJ
        QbUGKsdnx388/wOVw1pPW32VVZKPIvJnE4OG0EWJRfG7Rb502hs5GOTfX+/T/McG+OKrDh
        UMbHpQbV7ypLEDWhTYFo1oJQeYj/FG0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-jr9vY6TPNIqUiKBNDCg5KQ-1; Fri, 24 Feb 2023 03:05:20 -0500
X-MC-Unique: jr9vY6TPNIqUiKBNDCg5KQ-1
Received: by mail-ed1-f71.google.com with SMTP id en10-20020a056402528a00b004acbf564d75so17605114edb.5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71xwYKbSApQaBVT454tBZreSDV1iE1mCC6MU3vS/TrY=;
        b=WDKHX4GRNYqwW9RdpGKBqIV0Y8wDrdmvBs59Zde8cFZQdIhH8KQCb0M7fW7BDv8Bny
         NdBj4RTQvn99gdBxOqjFzqnmCI6cbs67GGPwUcGtiHQhMEE3GTUnbYsgj1rYDUe3gbQA
         0pO02n/G7ivkCLgYzXBiRYDJEBH/wIvHVdlG2r6BkJwxzqL6E4QeYxfPLsXBDlQmdIgF
         /k9o/gO4zzuAdHqrgpHcY/eRCy605fht6hWjLoUTeuHtuK8f7841LIRTJ6pM6F91/gTB
         +zMNAsMbqXd5muk0Xq/oLIt0UI0Kqq6UlaIMc77vomsXjSK6ca+ak5/eFKyauHSoemBr
         irjg==
X-Gm-Message-State: AO0yUKXxKjyiqj7WlhLibYfN/GnHXxDyOwy1ud9O9l4WWB2XtLg9d1Du
        8fd4eNYuIT6rHtQ/l1OMu/HQMXkje9LbQ6suHS9qBGoAIFE8CKpM7V56m8kRo51iwuznnn1hrnf
        ElgQ/tjLrley7IkdmRwvrLzzRS5a2cbB2
X-Received: by 2002:a17:906:58cb:b0:88d:ba79:4315 with SMTP id e11-20020a17090658cb00b0088dba794315mr13482487ejs.5.1677225919528;
        Fri, 24 Feb 2023 00:05:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/1Sr27PdW2gmy3YQQrKJoPbZlOsFiz0U7Dcml5TAsEMOWGYWgBsiT7I7cXcBdyI8uH0hASvCdeSz9m/wIyX94=
X-Received: by 2002:a17:906:58cb:b0:88d:ba79:4315 with SMTP id
 e11-20020a17090658cb00b0088dba794315mr13482473ejs.5.1677225919283; Fri, 24
 Feb 2023 00:05:19 -0800 (PST)
MIME-Version: 1.0
References: <20230224004145.91709-1-mschmidt@redhat.com> <BY3PR18MB461261285D1A9357405BD603ABA89@BY3PR18MB4612.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB461261285D1A9357405BD603ABA89@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Michal Schmidt <mschmidt@redhat.com>
Date:   Fri, 24 Feb 2023 09:05:08 +0100
Message-ID: <CADEbmW0eiuMCxk7m27AVauahUz-xDGjRHewQT0U+x2tgo6ai-Q@mail.gmail.com>
Subject: Re: [EXT] [PATCH net] qede: avoid uninitialized entries in coal_entry array
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Sorry, I accidentally sent my reply with HTML, got rejected by the
list, so resending in plain text.]

On Fri, Feb 24, 2023 at 8:25 AM Manish Chopra <manishc@marvell.com> wrote:
>
> > -----Original Message-----
> > From: Michal Schmidt <mschmidt@redhat.com>
> > ----------------------------------------------------------------------
> > Even after commit 908d4bb7c54c ("qede: fix interrupt coalescing
> > configuration"), some entries of the coal_entry array may theoretically be
> > used uninitialized:
> >
> >  1. qede_alloc_fp_array() allocates QEDE_MAX_RSS_CNT entries for
> >     coal_entry. The initial allocation uses kcalloc, so everything is
> >     initialized.
> >  2. The user sets a small number of queues (ethtool -L).
> >     coal_entry is reallocated for the actual small number of queues.
> >  3. The user sets a bigger number of queues.
> >     coal_entry is reallocated bigger. The added entries are not
> >     necessarily initialized.
> >
> > In practice, the reallocations will actually keep using the originally allocated
> > region of memory, but we should not rely on it.
> >
> > The reallocation is unnecessary. coal_entry can always have
> > QEDE_MAX_RSS_CNT entries.
>
> Hi Michal,
>
> Reallocation is necessary here, the motivation for reallocation is commit b0ec5489c480
> ("qede: preserve per queue stats across up/down of interface"). The coalescing configuration
> set from ethtool also needs to be retained across the interface state change, with this change
> you are not going to retain anything but always initialize with default.

It is retained. edev->coal_entry is allocated the first time
qede_alloc_fp_array() executes for the net_device. And then it's never
freed until the destruction of the net_device in__qede_remove().

> IMO, reallocation will
> always try to use same memory which was originally allocated if the requirement fits into it and
> which is the case here (driver will not attempt to allocate anything extra which were originally
> allocated ever). So there should not be any uninitialized contents, either they will be zero or
> something which were configured from ethtool by the user previously.

Yes, that's what I wrote in my description ("In practice, [...]"). But
that's relying on an implementation detail. It is not a part of the realloc
contract. If you need all the contents preserved, then do not lie to the
kernel that you need only a small part of it, i.e. do not realloc to a
smaller size.

Michal

> Nacked-by: Manish Chopra <manishc@marvell.com>
>
> Thanks,
> Manish
>
> >
> > Fixes: 908d4bb7c54c ("qede: fix interrupt coalescing configuration")
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_main.c | 21 +++++++-------------
> >  1 file changed, 7 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 4a3c3b5fb4a1..261f982ca40d 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -963,7 +963,6 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
> > {
> >       u8 fp_combined, fp_rx = edev->fp_num_rx;
> >       struct qede_fastpath *fp;
> > -     void *mem;
> >       int i;
> >
> >       edev->fp_array = kcalloc(QEDE_QUEUE_CNT(edev), @@ -974,20
> > +973,14 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
> >       }
> >
> >       if (!edev->coal_entry) {
> > -             mem = kcalloc(QEDE_MAX_RSS_CNT(edev),
> > -                           sizeof(*edev->coal_entry), GFP_KERNEL);
> > -     } else {
> > -             mem = krealloc(edev->coal_entry,
> > -                            QEDE_QUEUE_CNT(edev) * sizeof(*edev-
> > >coal_entry),
> > -                            GFP_KERNEL);
> > -     }
> > -
> > -     if (!mem) {
> > -             DP_ERR(edev, "coalesce entry allocation failed\n");
> > -             kfree(edev->coal_entry);
> > -             goto err;
> > +             edev->coal_entry = kcalloc(QEDE_MAX_RSS_CNT(edev),
> > +                                        sizeof(*edev->coal_entry),
> > +                                        GFP_KERNEL);
> > +             if (!edev->coal_entry) {
> > +                     DP_ERR(edev, "coalesce entry allocation failed\n");
> > +                     goto err;
> > +             }
> >       }
> > -     edev->coal_entry = mem;
> >
> >       fp_combined = QEDE_QUEUE_CNT(edev) - fp_rx - edev->fp_num_tx;
> >
> > --
> > 2.39.1
>

