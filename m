Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B116C1E66
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCTRqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCTRpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:45:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2989A2A178;
        Mon, 20 Mar 2023 10:41:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h31so7085781pgl.6;
        Mon, 20 Mar 2023 10:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679334091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jXsORzAzATpiIMon/GzfxOK7NLxGV8EwmaMIYBmS0I=;
        b=X3mlmfkdl1WpAb/hv+kWhBJGn/eOx9nnn8RjNStTAaTfxh9zjIzpbmxCN4LkVo59LL
         d48b7/nMnQZYfb4Xn+Fnv1AYco0fp2qMYUVGkQJCJb9u+5Q6uWGObaRQRiU7MLlKgzvI
         keEE6vI+SjAcMNrTQj+ni0Wl9iTq0mGRZwcJgvAFnUAdwFn/cxMrdkh701Ilv2Qohsrk
         eqIlvT5wLH0Oj0hMIfFJ8ZS1Xt0+hSPeV+5HEqhMk0VRY55rcMhEkMYpfYIlnQUto5jH
         P3RcfgKUfEIBzJAOMYkn5eHsT6k2QzUrVf0nhZs2SGAJkWdHDtUjzAoGsH6UEA7EMSLA
         hfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679334091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+jXsORzAzATpiIMon/GzfxOK7NLxGV8EwmaMIYBmS0I=;
        b=IylAli7VfncPeEcGeaveof/IkMkagVZ/4NyH9n/xpNpInJUOeo/qISvWtAE7oFolns
         iM95kKIsF8LiacC2ZUWedHPB6BoXUc2LmLRADGZN++HDnpOfjZwDS//1u/VTTHDtu4Tf
         txyJnQwncgvH8JmFQpxbWbxYQ9/ZS6cijtkgFj8oMFBsMIHl2VfKJ1vbnYzUUGDVmPnq
         PtpQ8X+SlQkJE3G0RQaeUQngu8ikhrGdvC3YZ93sOmRQnOlf1JcQj+m4L1zKYZTPxcAn
         UXxjVWEHb5V+cYevfCz9zJKIJjeXn68Cayr27BpTKbvsuqGMLUHUQgueXctr0J46VGsb
         xmrA==
X-Gm-Message-State: AO0yUKXadCh0nV4Sj8iYJS6ifKD2Zt35HhSax/gYF31FwsHHkA4u0k3b
        qJosYtnYX7o4Tkd9g83eYAFg396Vaxvagdq+Pa4=
X-Google-Smtp-Source: AK7set//+jyxRSt0k/E22iqEqLXnguu06v5ypSdA0D50hd788gr3RF0q6o+tORTrExIVAv9LiKvEqvWsazq5AekVz1E=
X-Received: by 2002:a65:5183:0:b0:507:8088:9e0d with SMTP id
 h3-20020a655183000000b0050780889e0dmr2197473pgq.7.1679334090955; Mon, 20 Mar
 2023 10:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAE2MWkm=zvkF_Ge1MH7vn+dmMboNt+pOEEVSgSeNNPRY5VmroA@mail.gmail.com>
 <a4ce2c34-eabe-a11f-682a-4cecf6c3462b@blackwall.org> <CAE2MWkkDNZuThePts_nU-LNYryYyWTYOMk5gmuoCoGPh4bf4ag@mail.gmail.com>
In-Reply-To: <CAE2MWkkDNZuThePts_nU-LNYryYyWTYOMk5gmuoCoGPh4bf4ag@mail.gmail.com>
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Mon, 20 Mar 2023 23:11:19 +0530
Message-ID: <CAE2MWkn=ygeVwj=j7ggLd+10mGjPJEC8Et5MGHVzs=dGWLccYg@mail.gmail.com>
Subject: Re: Multicast: handling of STA disconnect
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     roopa@nvidia.com, netdev@vger.kernel.org,
        Kernel <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

Any idea if the station connects back immediately after say 10 sec?
How to resume the session immediately if we delete the MDB on
disconnect? Currently, the station needs to wait until the next
general query to come to STA.

My idea is to send a general query to that specific port to resume the
session immediately from the STA connect event. This will create the
MDB immediately and resume the stream, as we have deleted the MDB from
disconnect.

Thanks,
UjjaL Roy

On Mon, Mar 20, 2023 at 10:55=E2=80=AFPM Ujjal Roy <royujjal@gmail.com> wro=
te:
>
> Hi Nik,
>
> Flushing MDB can only be done when we are managing it per station not
> per port. For that we need to have MCAST_TO_UCAST, EHT and FAST_LEAVE.
>
> Here one more point is - some vendors may offload MCAST_TO_UCAST
> conversion in their own FW to reduce CPU.
>
> So, the best way is to have MCAST_TO_UCAST enabled and MDB will become
> per station, so we can delete MDB on disconnect. Shall, I create one
> patch for review?
>
> Thanks,
> UjjaL Roy
>
> On Mon, Mar 20, 2023 at 5:38=E2=80=AFPM Nikolay Aleksandrov <razor@blackw=
all.org> wrote:
> >
> > On 20/03/2023 13:45, Ujjal Roy wrote:
> > > Hi Nikolay,
> > >
> > > I have some query on multicast. When streams running on an STA and ST=
A
> > > disconnected due to some reason. So, until the MDB is timed out the
> > > stream will be forwarded to the port and in turn to the driver and
> > > dropps there as no such STA.
> > >
> > > So, is the multicast_eht handling this scenario to take any action
> > > immediately? If not, can we do this to take quick action to reduce
> > > overhead of memory and driver?
> > >
> > > I have an idea on this. Can we mark this port group (MDB entry) as
> > > INACTIVE from the WiFi disconnect event and skip forwarding the strea=
m
> > > to this port in br_multicast_flood by applying the check? I can share
> > > the patch on this.
> > >
> > > Thanks,
> > > UjjaL Roy
> >
> > Hi,
> > Fast leave and EHT (as that's v3's fast leave version) are about quickl=
y converging when
> > a leave is received (e.g. when there are no listeners to quickly remove=
 the mdb). They
> > don't deal with interface states (IIUC). Why don't you just flush the p=
ort's mdb entries
> > on disconnect? That would stop fwding.
> >
> > Cheers,
> >  Nik
> >
> >
