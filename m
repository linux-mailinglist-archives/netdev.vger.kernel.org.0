Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A5657B37E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiGTJJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiGTJJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2022B48C8C
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658308160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/Adwn/Zxcap2bDLtk0F6PkpqBBXVv9IA+UfvOCjeBw=;
        b=DexhYWAzjvJqmeh9O5Z2bdpUpwsWnG5D+4OC5U9sWV+eoxCDh/lRIw32PmUYlR+Vuh8sTk
        IcKjGIWHUtjgSSoVu8DpIC/Tyty1CE/edS+PRC/U/Lourp+uerXA1gtOlwyl07EcSkS3FQ
        Z0f2SnJT9EPfrqgJ2oUj0SG8FmklQuo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-FptLSZuqO_C6YtGerDOMxA-1; Wed, 20 Jul 2022 05:09:13 -0400
X-MC-Unique: FptLSZuqO_C6YtGerDOMxA-1
Received: by mail-wm1-f71.google.com with SMTP id v123-20020a1cac81000000b003a02a3f0beeso943345wme.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/Adwn/Zxcap2bDLtk0F6PkpqBBXVv9IA+UfvOCjeBw=;
        b=3xJGrgXQ0f7eJsOV16D9sAcHMKNUwdS2BiRkCLfnzGm8uZC02R6X3CwVvF7cIjElnO
         WqGcz2vj59JTu0IVc8OvSRGWa/VI21YViH0XfGl+5oFgNz6Pep251x8lCE030qI0idmL
         zD0/BWUh6AfBYp4rjhUbkpYyOza9W+T0n6I6XEZEQVVyWHmnvyB+VnDTuVEOVnbPgShB
         8fV1qEQW4yjc7Tc7k8kK8oRfnRXg8NLF1M8T1qBxzGLqqAcR21lmkYQKWeolc9Eo/gb9
         J0op8m8kymiewppuCUM/JYAMg+aXkddN6lJ0L6PyMBwW8fvkN1u0oj2sFzwD52cmxyvF
         O32w==
X-Gm-Message-State: AJIora8j4eP5pxGNTXlFaE2sUA+MtIY1x2YC5i5VNa1dgLnF0qZidIyR
        Y/m+SC/yvDwCh2ltjZuK5CBaZFWo7eg/OUNu5qWUMTHDcO+qjWex4p0y8gz8qdhddmjEiL2nmjE
        fKs5pNbHkEbHipe7n
X-Received: by 2002:adf:da42:0:b0:21d:aa7e:b1da with SMTP id r2-20020adfda42000000b0021daa7eb1damr30465219wrl.330.1658308151814;
        Wed, 20 Jul 2022 02:09:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vF8lLtT6lOYJ2oTY9a6oZxjs7V0nMLexFX/WFgwI99gUbcRL5rAoCkj9UL1DnahbZWYJ854g==
X-Received: by 2002:adf:da42:0:b0:21d:aa7e:b1da with SMTP id r2-20020adfda42000000b0021daa7eb1damr30465200wrl.330.1658308151593;
        Wed, 20 Jul 2022 02:09:11 -0700 (PDT)
Received: from redhat.com ([2.55.25.63])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b003a31f71c5b8sm2077186wmq.27.2022.07.20.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:09:11 -0700 (PDT)
Date:   Wed, 20 Jul 2022 05:09:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720050831-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org>
 <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org>
 <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
 <20220720031436-mutt-send-email-mst@kernel.org>
 <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
 <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 03:45:59PM +0800, Jason Wang wrote:
> On Wed, Jul 20, 2022 at 3:42 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Wed, Jul 20, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jul 20, 2022 at 10:07:11AM +0300, Alvaro Karsz wrote:
> > > > > Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx
> > > > napi on/off.
> > > > > However I am not sure we should treat any value != 1 as napi on.
> > > > >
> > > > > I don't really have good ideas - I think abusing coalescing might
> > > > > have been a mistake. But now that we are there, I feel we need
> > > > > a way for userspace to at least be able to figure out whether
> > > > > setting coalescing to 0 will have nasty side effects.
> > > >
> > > >
> > > > So, how can I proceed from here?
> > > > Maybe we don't need to use tx napi when this feature is negotiated (like Jakub
> > > > suggested in prev. versions)?
> > > > It makes sense, since the number of TX notifications can be reduced by setting
> > > > tx_usecs/tx_max_packets with ethtool.
> > >
> > >
> > > Hmm Jason had some ideas about extensions in mind when he
> > > coded the current UAPI, let's see if he has ideas.
> > > I'll ruminate on compatibility a bit too.
> >
> > I might be wrong, but using 1 to enable tx napi is a way to try to be
> > compatible with the interrupt coalescing.
> >
> > That is, without notification coalescing, if 1 is set, we enable tx
> > notifications (and NAPI) for each packet. This works as if
> > tx-max-coalesced-frames is set to 1 when notification coalescing is
> > negotiated.
> >
> > Thanks
> >
> > >
> > > > > It's also a bit of a spec defect that it does not document corner cases
> > > > > like what do 0 values do, are they different from 1? or what are max values.
> > > > > Not too late to fix?
> > > >
> > > >
> > > > I think that some of the corner cases can be understood from the coalescing
> > > > values.
> > > > For example:
> > > > if rx_usecs=0 we should wait for 0 usecs, meaning that we should send a
> > > > notification immediately.
> > > > But if rx_usecs=1 we should wait for 1 usec.
> > > > The case with max_packets is a little bit unclear for the values 0/1, and it
> > > > seems that in both cases we should send a notification immediately after
> > > > receiving/sending a packet.
> 
> Then we probably need to document this in the spec.
> 
> And we need an upper limit for those values, this helps for e.g
> migration compatibility.
> 
> Thanks

Not a bad idea generally but I suspect this is better done
as part of the admin queue/migration work then.


> > > >
> > > >
> > > > > So the spec says
> > > > >         Device supports notifications coalescing.
> > > > >
> > > > > which makes more sense - there's not a lot guest needs to do here.
> > > >
> > > >
> > > > Noted.
> > > >
> > > > > parameters?
> > > >
> > > >
> > > > I'll change it to "settings".
> > > >
> > > > > why with dash here? And why not just put the comments near the fields
> > > > > themselves?
> > > >
> > > >
> > > > Noted.
> > >

