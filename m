Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1F54746C
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiFKMFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 08:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiFKMFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 08:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26FDB65D15
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654949144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mNzCkANMMDAdoCT7KT4RFhbSklFrx3C7rOYfMK6BTTI=;
        b=GXqE5ilJHtjbXrSrFoGWkEI+Lp/GzQDtqMdxn29dYlpJ7Yt+C05X4Pb1qAXeqLAQVCdKhD
        g9Hi9KANOZoQEebAKd37Jra4dfOp3gFPmzgjQ0AH1zHktBUi8NRp9DS2PKS2Vo9/XMhGor
        lfVUuaIY3ExGjbFbd/u+ztp3FC9o4ZA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-gB0TJJemOGmdiD50-J1luw-1; Sat, 11 Jun 2022 08:05:42 -0400
X-MC-Unique: gB0TJJemOGmdiD50-J1luw-1
Received: by mail-qt1-f200.google.com with SMTP id s7-20020ac85cc7000000b00304e11cb41fso1231299qta.4
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mNzCkANMMDAdoCT7KT4RFhbSklFrx3C7rOYfMK6BTTI=;
        b=AeNW1k44xfZx+H2tnKNXu9GbAVena8dngQXgnD5tfcU5jGFaoWckdZ1Ht9HrFNPeSd
         Iw7wTnh/x27bptt8z9OiXzNrL0UIdLYCzBJtGVqS5rNqjpGL8C82UujtFXnhfiDJ3t0p
         tNmdYm225tOt+V9HCUi/12H6kNbsCvOAzb5WELbbMe3lcaoxNjKKeW+NrHFWkF8nCOw2
         bPQGzAyrbQeRdap88FMLtpvq3rr9pPlx9iJYjCpiqJWCmEdB1FwxtDv6e2YjGfRm8XCY
         XlVdTxJD+Ijl8V7n2G9SOTJf9efiGKgwbfi6+350N24pIcsXEHdtdgqXuetKcodrGGdw
         todA==
X-Gm-Message-State: AOAM5306FslWCYF1NVyVEGkV+3CGQbLuBEeTEGv2KtP+Sl0+suSYdaal
        IZMMenUG5Qx2MYxpZN6D4a2NeOdS7QSiGfRvLa2/7LqlB/uHrCvVdHkJzOKDE2b2B8cLu5iHsv0
        maqM2CT6iOJnZehdqpB8Rgutl3YGe3ggz
X-Received: by 2002:a37:510:0:b0:6a6:ab9e:1b80 with SMTP id 16-20020a370510000000b006a6ab9e1b80mr25971433qkf.770.1654949142148;
        Sat, 11 Jun 2022 05:05:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5deeljZNYJcdGdMIxSyheLX6hGleMr2Yw+kWXMUT/C6lBcjJ614i6PbtGfQLvkiqHxBR4pOQadhMXn1dX9XU=
X-Received: by 2002:a37:510:0:b0:6a6:ab9e:1b80 with SMTP id
 16-20020a370510000000b006a6ab9e1b80mr25971398qkf.770.1654949141740; Sat, 11
 Jun 2022 05:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13>
 <20220608163708.26ccd4cc@xps-13> <CAK-6q+iD0_bS2z_BdKsyeqYvzxj2x-v+SWAo2UO02j7yGtEcEg@mail.gmail.com>
 <CAK-6q+gBCakX8Vm1SHuLfex5jBqLKySUiaZKg3So+zjeJaSehw@mail.gmail.com> <20220609174353.177daddb@xps-13>
In-Reply-To: <20220609174353.177daddb@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 11 Jun 2022 08:05:31 -0400
Message-ID: <CAK-6q+haNAxexhNe5_pReU=jpUyP+XKn9oq=DKGC_Leg0w41pA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 9, 2022 at 11:44 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> > > >
> > > >   - How is chosen the beacon order? Should we have a default value?
> > > >     Should we default to 15 (not on a beacon enabled PAN)? Should we be
> > > >     able to update this value during the lifetime of the PAN?
> > > >
> > >
> > > Is there no mib default value for this?
>
> I didn't find anything. I suppose we can ask for that parameter at PAN
> creation, but otherwise I'll keep a backward compatible value: 15,
> which means that the PAN is not beacon enabled (like today, basically).
>

I hope it is not necessary to answer this question, see below.

> > >
> > > >   - The spec talks about the cluster topology, where a coordinator that
> > > >     just associated to a PAN starts emitting beacons, which may enable
> > > >     other devices in its range to ask to join the PAN (increased area
> > > >     coverage). But then, there is no information about how the newly
> > > >     added device should do to join the PAN coordinator which is anyway
> > > >     out of range to require the association, transmit data, etc. Any
> > > >     idea how this is supposed to work?
> > > >
> > >
> > > I think we should maybe add a feature for this later if we don't know
> > > how it is supposed to work or there are still open questions and first
> > > introduce the manual setup. After that, maybe things will become
> > > clearer and we can add support for this part. Is this okay?
> >
> > *I also think that this can be done in user space by a daemon by
> > triggering netlink commands for scan/assoc/etc. (manual setup) and
> > providing such functionality as mentioned by the spec (auto creation
> > of pan, assoc with pan). Things which are unclear here are then moved
> > to the user as the operations for scan/assoc/etc. will not be
> > different or at least parameterized. The point here is that providing
> > the minimum basic functionality should be done at first, then we can
> > look at how to realize such handling (either in kernel or user space).
>
> Actually this is none of the 802.15.4 MAC layer business. I believe
> this is the upper layer duty to make this interoperability work,
> namely, 6lowpan?

I am not sure if I understand your answer, I meant that if
"coordinator" or "PAN coordinator" depends on whatever, if somebody is
running a "coordinator" software in the background on top of a coord
interface.
The kernel offers the functionality for scan/assoc/etc. (offers link
quality, etc. _statistics_ and not _heuristic_) which will be used by
this software to whatever the user defines to realize this behaviour
as it is user specific.

Sure linux-wpan, should then provide at least a standard piece of
software for it.

This has in my opinion nothing to do with 6lowpan.

- Alex

