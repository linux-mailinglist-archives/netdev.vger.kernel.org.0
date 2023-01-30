Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7A6816AE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbjA3Qmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbjA3Qm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:42:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B8F3F2B8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675096895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WP4UjZlsJcHPiMQ9Euo1Ispa4JRoAVv1ZBBa1CLvgvE=;
        b=IKJpOJvr8IaFFGoJ/hwnllEdVnxs4BFMoTu2yoeSfdh8vY0lU9D7L/eSj2Yyf17NdhOtUA
        lKpPZ7Knc2GMOYuLVIUL3fFNP/MUYXWW5RJgni/EPzvNT0/4OblRIvBVYarwxkf8Ittmev
        sj2e6m4rHC50ukG6oflaHUiQp+Jl3Jk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-9BV755JhPnaYYjr3ZMbO-Q-1; Mon, 30 Jan 2023 11:41:34 -0500
X-MC-Unique: 9BV755JhPnaYYjr3ZMbO-Q-1
Received: by mail-ed1-f70.google.com with SMTP id f11-20020a056402354b00b0049e18f0076dso8513666edd.15
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WP4UjZlsJcHPiMQ9Euo1Ispa4JRoAVv1ZBBa1CLvgvE=;
        b=HcQ09oMizoNyxAKKnqSEKWHEJgfyK1r0BwOmbySv1fj+/euhbSqQwMFL+HW1bsekcv
         M28yynfgIoerwmzHvZzbNNE/lojQOmR9O3mprBx+E8stchmksLb8vWmVMi4DwKiY6o0Y
         dyq/RGX+4EiHPddaREH47h8pnSjxVJMWVjHAQ+vWFoSpjb6jiHezqRd6YxkYGdrBrWDd
         PEB7uYEo/kGa5U1ZIoitgfUFwmbmPcJkh5LO0AXd0LtvdXPS/gtzSus6KgxmGalmtklg
         lRtMq6jwmUP6l5tP7+9MLuHd3ArXRf6y4AOHMF+woH+Kx46+CXpB1U41OTrFX/865R3/
         nIog==
X-Gm-Message-State: AO0yUKWa5SuxdEI6Adm7FnpJcilcff+inqIPY3I70tx7HUy2IsHkxdrV
        FIupnVVzqB42h1jO4yiRFC5TNqFF5km7+RoH9uh2toD+CPDCAuk5dXaWQs07hMbKuMGv9WAutAW
        254SlNDWSzTFrUzfCB0N8tS3e7dAUIt35
X-Received: by 2002:a17:906:14cf:b0:878:69e5:b797 with SMTP id y15-20020a17090614cf00b0087869e5b797mr3521730ejc.228.1675096891781;
        Mon, 30 Jan 2023 08:41:31 -0800 (PST)
X-Google-Smtp-Source: AK7set8n9Tiw100E/JLlm/2foR5n/xnl/cE98ppN5QTqjX1YI7L/tS0/dnGh0f/5yO9IIBkpKJWKzhmbAzfR9nurt5s=
X-Received: by 2002:a17:906:14cf:b0:878:69e5:b797 with SMTP id
 y15-20020a17090614cf00b0087869e5b797mr3521726ejc.228.1675096891621; Mon, 30
 Jan 2023 08:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20230130154306.114265-1-miquel.raynal@bootlin.com> <f604d39b-d801-8373-9d8f-e93e429b7cdd@datenfreihafen.org>
In-Reply-To: <f604d39b-d801-8373-9d8f-e93e429b7cdd@datenfreihafen.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 30 Jan 2023 11:41:20 -0500
Message-ID: <CAK-6q+iOXe2CQ=Bc4Ba8vK=M_hTW7cdJ5TormiHy5DJsiyr_BQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next] mac802154: Avoid superfluous endianness handling
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel test robot <lkp@intel.com>
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

Hi,

On Mon, Jan 30, 2023 at 11:34 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello.
>
> On 30.01.23 16:43, Miquel Raynal wrote:
> > When compiling scan.c with C=1, Sparse complains with:
> >
> >     sparse:     expected unsigned short [usertype] val
> >     sparse:     got restricted __le16 [usertype] pan_id
> >     sparse: sparse: cast from restricted __le16
> >
> >     sparse:     expected unsigned long long [usertype] val
> >     sparse:     got restricted __le64 [usertype] extended_addr
> >     sparse: sparse: cast from restricted __le64
> >
> > The tool is right, both pan_id and extended_addr already are rightfully
> > defined as being __le16 and __le64 on both sides of the operations and
> > do not require extra endianness handling.
> >
> > Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   net/mac802154/scan.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
> > index cfbe20b1ec5e..8f98efec7753 100644
> > --- a/net/mac802154/scan.c
> > +++ b/net/mac802154/scan.c
> > @@ -419,8 +419,8 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
> >       local->beacon.mhr.fc.source_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
> >       atomic_set(&request->wpan_dev->bsn, -1);
> >       local->beacon.mhr.source.mode = IEEE802154_ADDR_LONG;
> > -     local->beacon.mhr.source.pan_id = cpu_to_le16(request->wpan_dev->pan_id);
> > -     local->beacon.mhr.source.extended_addr = cpu_to_le64(request->wpan_dev->extended_addr);
> > +     local->beacon.mhr.source.pan_id = request->wpan_dev->pan_id;
> > +     local->beacon.mhr.source.extended_addr = request->wpan_dev->extended_addr;
> >       local->beacon.mac_pl.beacon_order = request->interval;
> >       local->beacon.mac_pl.superframe_order = request->interval;
> >       local->beacon.mac_pl.final_cap_slot = 0xf;
>
> This patch has been applied to the wpan-next tree and will be
> part of the next pull request to net-next. Thanks!

fyi: in my opinion, depending on system endianness this is actually a bug.

- Alex

