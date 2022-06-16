Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D7954E136
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 14:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376420AbiFPM5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 08:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376380AbiFPM5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 08:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AABD93B7
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 05:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655384247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJVjgB1WV8axjnD/ZQGZ1cJuRqJKIs9CwL3dt0JUN1o=;
        b=I3axTmT6dSF82THq4vTnl3OmT/UIVPFj7bq5iCW3wbU3hZyfcnMisSmOGc81JOn/sSEMWZ
        6fJbuT7UM48sBOvbnAV2asRJ+AUz4qhhRNnV+es4Yk8kSQc5QBU2EhyPnMtPCrEMXCDjVZ
        x83K7OSaYPRg4utBSVBxrMEiGAgswt8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-WKgnV3HyPn2DB68XEALYlw-1; Thu, 16 Jun 2022 08:57:26 -0400
X-MC-Unique: WKgnV3HyPn2DB68XEALYlw-1
Received: by mail-qk1-f197.google.com with SMTP id u16-20020a05620a431000b006a98f2a9ff0so1606054qko.17
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 05:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJVjgB1WV8axjnD/ZQGZ1cJuRqJKIs9CwL3dt0JUN1o=;
        b=7x8fEGjDkq3B5rsGFenl/AkXgXLtqavyE+EjRgKzez8DLw3YzMA8uPK0LzUie4e/Iy
         ZeQmoXRhRKAwCtNhxwBkvjbib4YXDV5t7zz/1KWj54BxW/F9gHywWnb2Yi//TaalZdYF
         PNQfZSKLhaoPSEvAAZg7E8A5qpMnW+EHJFyuMGDUpcT1rrtPAK+0qYkrP/dcKxXDMqwG
         ZnkjNj/HXIuEkUvk8hrHdLGlsQuxtKUlyCJQHhvL/BnmMS0fJR5jWghqsV7klVldN6sy
         eyxjNfxP6GNl/yGHD9w01yKowxyJpVp008E+4aWP+5iS9y1NHrKQIXhhxi5xsC4EKBx+
         E2VA==
X-Gm-Message-State: AJIora+OuYJ0huXViDRTKF55Sfuu9oBn+TpZXUC/XAVvRhlTmlJ2J/AQ
        VRLYBOjGEns5vxBN4bRw+vCkdEtN4u5n/uzrlHN6ZS1bpr4ClgflobDAKSVMHQWeK3D6G2D1Uze
        ieAEHHuG+9f8KoNTH9apem/WTt2Cn+xrd
X-Received: by 2002:ad4:594d:0:b0:46b:9c03:4fd1 with SMTP id eo13-20020ad4594d000000b0046b9c034fd1mr3802383qvb.92.1655384245579;
        Thu, 16 Jun 2022 05:57:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ukGxTO+VKqdTBk2Vgne3ZioipDrRA+O1zB9SXLtMaJG21eu2euN8ScJErYqjnPyjwRthzssZduk3HqZTRQ89U=
X-Received: by 2002:ad4:594d:0:b0:46b:9c03:4fd1 with SMTP id
 eo13-20020ad4594d000000b0046b9c034fd1mr3802374qvb.92.1655384245372; Thu, 16
 Jun 2022 05:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220613032922.1030739-1-aahringo@redhat.com> <20220613032922.1030739-2-aahringo@redhat.com>
 <3b7a9363-1fea-d4a3-360d-a2e60b1038c7@datenfreihafen.org>
In-Reply-To: <3b7a9363-1fea-d4a3-360d-a2e60b1038c7@datenfreihafen.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 16 Jun 2022 08:57:14 -0400
Message-ID: <CAK-6q+hT4-w4Hw5wq_7orUffkDPWYxJ50kurqy+hPxyH91WC5Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next 2/2] 6lowpan: nhc: drop EEXIST limitation
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 16, 2022 at 3:57 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
>
> Hello Alex.
>
> On 13.06.22 05:29, Alexander Aring wrote:
> > In nhc we have compression() and uncompression(). Currently we have a
> > limitation that we return -EEXIST when it's the nhc is already
> > registered according the nexthdr. But on receiving handling and the
> > nhcid we can indeed support both at the same time.
>
> The sentence above is not really clear to me. Do you want to say that on
> rx we can support more than one nhcid? I am a bit confused why you write
> both here. Where does the limit to two come from?
>

It's simple when you look at how it's working. On rx we have nhcid
lookup and on tx we have nexthdr lookup. These are two different
registration numbers and there can be multiple compression for one
nexthdr:

N:1

The limit was always there because we did not support multiple nexthdr
registrations.

> We remove the current
> > static array implementation and replace it by a dynamic list handling to
> > get rid of this limitation.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >   net/6lowpan/nhc.c | 69 ++++++++++++++++++++++++++++++-----------------
> >   1 file changed, 44 insertions(+), 25 deletions(-)
> >
> > diff --git a/net/6lowpan/nhc.c b/net/6lowpan/nhc.c
> > index 7b374595328d..3d7c50139142 100644
> > --- a/net/6lowpan/nhc.c
> > +++ b/net/6lowpan/nhc.c
> > @@ -12,13 +12,30 @@
> >
> >   #include "nhc.h"
> >
> > -static const struct lowpan_nhc *lowpan_nexthdr_nhcs[NEXTHDR_MAX + 1];
> > +struct lowpan_nhc_entry {
> > +     const struct lowpan_nhc *nhc;
> > +     struct list_head list;
> > +};
> > +
> >   static DEFINE_SPINLOCK(lowpan_nhc_lock);
> > +static LIST_HEAD(lowpan_nexthdr_nhcs);
> > +
> > +const struct lowpan_nhc *lowpan_nhc_by_nexthdr(u8 nexthdr)
> > +{
> > +     const struct lowpan_nhc_entry *e;
> > +
> > +     list_for_each_entry(e, &lowpan_nexthdr_nhcs, list) {
> > +             if (e->nhc->nexthdr == nexthdr &&
> > +                 e->nhc->compress)
> > +                     return e->nhc;
>
> We will always go with the first one we find? Do I miss something or
> does that mean the one registered as seond and above will never be taken
> into acount?

That is currently true for the tx side. This just allows more than we
currently support without breaking the past.

- Alex

