Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955BA65B8BB
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 02:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbjACBQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 20:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbjACBQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 20:16:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A172108
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 17:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672708539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TVPzk5o7igQTGpKeVYQ3N+jhV1xQAhqlOB2+IYBNkrg=;
        b=Njrkiv/2H+9nvZ2uqo8S9eJZkESS3GszryPKWHtFWdM29D13YlZCcUpAZUFjVGjQHIqog/
        Rb+4A0qcuJ+/UOrJe2H7oPVcwqpzKTub20tgbn27Ay28PJaij8PqvtsL3GBDl53SXk15Hw
        WGfB97YHzeVRy9O1Av09lXpf8VHUTPY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-zsihtkaiNaCRPMVbCc75JA-1; Mon, 02 Jan 2023 20:15:38 -0500
X-MC-Unique: zsihtkaiNaCRPMVbCc75JA-1
Received: by mail-ej1-f71.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so17894855ejc.9
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 17:15:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TVPzk5o7igQTGpKeVYQ3N+jhV1xQAhqlOB2+IYBNkrg=;
        b=LaFPUnl+PoFvKpWLqCP6gwAb2TAph7lmpSmLBr19PCqL3Qq1OX8mYPnN3hAZsfpZZc
         V/dyqB9U0IuWIx68Uy+Dw2RmdcAjSikgp/LYNliyGExZ07QpkbMsfEu/qs9IW7lEd/wo
         sBtgX6qmbiJc7Eumx2lwi+0swFRd/ptdu5C3vtA31J//eAGDO/PligEK7CHTSe42io3U
         S13oPWMCr6CwrNXinFcQ6wdRT2zNH51inFQlHhvlwxPs2gWm1yUZy3kKWvdMWWVZMvH0
         JU4owcqPlp6ERcJlCvDimr1XTyTclXNduZRne/bpw1f2fL+SXdEchintIS5mvtYIJ45C
         A3wQ==
X-Gm-Message-State: AFqh2krb5GbfeAspR5f2OWPIa2/bVaMOf9rbJYsqKhjqkudzKO1fNlIB
        Sae24MLfxT6XG1w1CmffDkZyl0tKYn0EvlVItMtOLwu1Tk+vysTB4iv8QfKYPF8GAV9f0xyYwee
        b7WURh+/c6thKTC68guKcusHk8GhAXge7
X-Received: by 2002:a17:907:3a52:b0:7c0:e23f:17cd with SMTP id fc18-20020a1709073a5200b007c0e23f17cdmr2418551ejc.491.1672708537449;
        Mon, 02 Jan 2023 17:15:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXteZAesA4qZFLpE6BVuBQWONnaun6dqv2r41kHwVwYftYROWzRaXXqCpu+eRY8AE1t34DS+y77wm++FEdG2dOg=
X-Received: by 2002:a17:907:3a52:b0:7c0:e23f:17cd with SMTP id
 fc18-20020a1709073a5200b007c0e23f17cdmr2418538ejc.491.1672708537107; Mon, 02
 Jan 2023 17:15:37 -0800 (PST)
MIME-Version: 1.0
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
 <20221217000226.646767-7-miquel.raynal@bootlin.com> <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
In-Reply-To: <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 2 Jan 2023 20:15:25 -0500
Message-ID: <CAK-6q+gTQwS5n+YVFDeGTqEnSREt9KjC58zq9r2c8T456zXagQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 6/6] mac802154: Handle passive scanning
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
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

Hi,

On Mon, Jan 2, 2023 at 8:04 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Dec 16, 2022 at 7:04 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +void mac802154_scan_worker(struct work_struct *work)
> > +{
> > +       struct ieee802154_local *local =
> > +               container_of(work, struct ieee802154_local, scan_work.work);
> > +       struct cfg802154_scan_request *scan_req;
> > +       struct ieee802154_sub_if_data *sdata;
> > +       unsigned int scan_duration = 0;
> > +       struct wpan_phy* wpan_phy;
> > +       u8 scan_req_duration;
> > +       u8 page, channel;
> > +       int ret;
> > +
> > +       /* Ensure the device receiver is turned off when changing channels
> > +        * because there is no atomic way to change the channel and know on
> > +        * which one a beacon might have been received.
> > +        */
> > +       drv_stop(local);
> > +       synchronize_net();
>
> Do we do that for every channel switch? I think this is not necessary.
> It is necessary for bringing the transceiver into scan filtering mode,
> but we don't need to do that for switching the channel.
>
> And there is a difference why we need to do that for filtering. In my
> mind I had the following reason that the MAC layer is handled in Linux
> (softMAC) and by offloaded parts on the transceiver, this needs to be
> synchronized. The PHY layer is completely on the transceiver side,
> that's why you can switch channels during interface running. There
> exist some MAC parameters which are offloaded to the hardware and are
> currently not possible to synchronize while an interface is up,
> however this could change in future because the new helpers to
> synchronize softmac/transceiver mac handling.
>
> There is maybe a need here to be sure everything is transmitted on the
> hardware before switching the channel, but this should be done by the
> new mlme functionality which does a synchronized transmit. However we
> don't transmit anything here, so there is no need for that yet. We
> should never stop the transceiver being into receive mode and during
> scan we should always be into receive mode in
> IEEE802154_FILTERING_3_SCAN level without never leaving it.
>
> ... and happy new year.
>
> I wanted to ack this series but this came into my mind. I also wanted
> to check what exactly happens when a mlme op returns an error like
> channel access failure? Do we ignore it? Do we do cond_resched() and
> retry again later? I guess these are questions only if we get into
> active scanning with more exciting sending of frames, because here we
> don't transmit anything.

Ignore that above about stopping the transceiver being in receive
mode, you are right... you cannot know on which channel/page
combination the beacon was received because as the comment says, it is
not atomic to switch it... sadly the transceiver does not tell us that
on a per frame basis.

Sorry for the noise. Still with my previous comments why it's still
valid to switch channels while phy is in receive mode but not in scan
mode, I would say if a user does that... then we don't care. Some
offloaded parts and softMAC handling still need indeed to be
synchronized because we don't know how a transceiver reacts on it to
change registers there while transmitting.

- Alex

