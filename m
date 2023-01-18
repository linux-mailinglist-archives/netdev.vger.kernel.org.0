Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12D2672B22
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 23:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjARWM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 17:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjARWM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 17:12:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2DB654DA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674079927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZMEMrcYWxCYgncCZ7gZI9FW1ZAN3xqpELmriu9FkXc0=;
        b=R6g08xikj9V1xn3q0YSDj1HrbDbEI20Gwn31F5VWJumqtvo5dU07LYMkvBWUqGP2Ytb9f0
        CYcSIdivNiuOjiGvxi9JdLodADvc7UCD+XgV/o2u0FMhyguOotAkXMHBWwY6bpJrgqS7Tj
        IYpx7FAgNKOioI4HHSlAVxuATwLOJ+w=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-Mqbjx38bNrGPWLTIO-xojQ-1; Wed, 18 Jan 2023 17:12:01 -0500
X-MC-Unique: Mqbjx38bNrGPWLTIO-xojQ-1
Received: by mail-pf1-f199.google.com with SMTP id p1-20020aa78601000000b0058bca6db4a0so7993pfn.20
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMEMrcYWxCYgncCZ7gZI9FW1ZAN3xqpELmriu9FkXc0=;
        b=scMkiKVzXM5cI3SCsi4PNL+/UOIjW6ye5CO1KKov6ydJpWPEsp5bbXFJC6gLzEkq7H
         Fs5r6sqQWBx1Ye6jCIhhHm2JywlJVH8dCcIR3NtAp5S/U98W2CqLhCx59PHbuzFny7IN
         TZ9T53yF0IkvR08KzuvihYSQRr+KiLlJmEvyyu42LwxFZzCjsHJ327S7eKYoxyLLWlAM
         qLpv4f1d5bWQt2GDD83DraAIPOt2CHZvtU2HiGJN9WDyPDDDGkxI6CeRgYZo39Yz8HWw
         q0yShN4QsuXz17071LhIvRyZCjs+0WTJ+zmNFrpJ2gG+X0vgLcz230l/lhe05Dv5PdV6
         bTgg==
X-Gm-Message-State: AFqh2koUFitkdNYPj/E8CzsMIY55P88Q2K3mjj9nVWfCy+vYgrjAiiAS
        BNdqYQ7Zehyq3kAlyXgiiFGO4f+cbsUH9NiZCLGDikgUzlgjZvbrKTvSdC8tJcHHxtp6zCdKgm0
        0KAp8IkupapIGaGjLSZ8gMpNuYFijRJUA
X-Received: by 2002:a17:90a:bd8b:b0:229:3b43:a31f with SMTP id z11-20020a17090abd8b00b002293b43a31fmr1010102pjr.81.1674079920357;
        Wed, 18 Jan 2023 14:12:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsEVBmBylWpQyn2dcYBw+l/HGBhJWmGomA3c22HZNKZfJ0OUa8lD0ANX47rTRzPNb7JB63lpkyMuZfIjLQXNyI=
X-Received: by 2002:a17:90a:bd8b:b0:229:3b43:a31f with SMTP id
 z11-20020a17090abd8b00b002293b43a31fmr1010097pjr.81.1674079920131; Wed, 18
 Jan 2023 14:12:00 -0800 (PST)
MIME-Version: 1.0
References: <20230117181533.2350335-1-neelx@redhat.com> <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
 <CACjP9X-hKf8g2UqitV8_G7WQW7u6Js5EsCNutsAMA4WD7YYSwA@mail.gmail.com> <42e74619-f2d0-1079-28b1-61e9e17ae953@intel.com>
In-Reply-To: <42e74619-f2d0-1079-28b1-61e9e17ae953@intel.com>
From:   Daniel Vacek <neelx@redhat.com>
Date:   Wed, 18 Jan 2023 23:11:23 +0100
Message-ID: <CACjP9X8SHZAd_+HSLJCxYxSRQuRmq3r48id13r17n2ehrec2YQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        Siddaraju <siddaraju.dh@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 9:59 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> On 1/18/2023 7:14 AM, Daniel Vacek wrote:
> > On Tue, Jan 17, 2023 at 7:47 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> >>
> >> At a minimum I think I would only set drop_ts but not not goto skip_ts_read.
> >
> > IIUC, that would still fail to clear the tx->in_use bit in case ice_read_phy_tstamp()
> > returns with error. It would only work for the other case where no error is
> > returned but rather the returned &raw_tstamp is invalid. I'll send a v2 of
> > this fix trying to address the goto concern.
> >
>
> Please re-send the patch with the goto concern addressed. (only set
> drop_ts, and still read the timestamp just in case and make sure that if
> the read function fails while drop_ts is set we still drop the ts).

Just in case it got lost I did send the patch here:

https://lore.kernel.org/intel-wired-lan/20230118161727.2485457-1-neelx@redhat.com/

But unfortunately I misplaced the --in-reply-to header with --reply-to one :-(
Hopefully it arrived to you safely.

> I believe that alleviates my concerns regarding the potential link down
> race with a completed timestamp above.
>
> We also should already be preventing requesting new timestamps while
> link is down so that should be sufficient to combine with this and cover
> the three flows:
>
> 1) request tx timestamp
> 2) link down
> 3) timestamp never occurs
>
> 1) request tx timestamp
> 2) timestamp occurs
> 3) link goes down while processing

I was thinking this is the case we got reported. But then again, I'm
not really experienced in this field.

--nX

> 1) link down
> 2) request tx timestamp rejected
>
> Thanks!
>
> -Jake

