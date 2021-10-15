Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8590842EE9F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbhJOKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbhJOKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 06:17:27 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FE1C061755;
        Fri, 15 Oct 2021 03:15:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id x27so39848494lfu.5;
        Fri, 15 Oct 2021 03:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3gr9OcTQADgsroZkxjA4AUKlpE+nrLRpuXBQjxsEHLQ=;
        b=qfFwnpb6M1YIhGtE1mKUJHOToAoQsZrCt9HeWMvbchWj1fg0w/eVD8wsgGJX4ZUCMO
         BlBLXV5Y8niGFiDOL9a+0YFe9JpBJeig49Y4dyf8NPakLkfmKAq6QuE62QsoBSVB8Prk
         OgVxDg512vQjhx3UrVBWP8dyq30z0GDNe4b78+y9TLiBVOigsbKWBQ3418Ja2f+bacW0
         l1prEVovKt/TJm+WGE7emSy8p4oeGQTLLfxJ1JWC4fnI71WoHe6ljXP+CclOILWVgFKK
         Zp9AnsAUYlEDWzc04r0+qKO+Ii6+7wCJrmRYMHXZznfqhDKkpdk/FT/VM3cP5gDZ8bvN
         0tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3gr9OcTQADgsroZkxjA4AUKlpE+nrLRpuXBQjxsEHLQ=;
        b=7SidSsJprU1VB0IisuRuUs63O6hW/jkHU2GV95sHV1SqTtf7csDOVQQqRbJffidNmz
         24q/Maz9tke7nkUMuKrmK5frnV98s7jo7VsFvHIRK/bOd3ZJRQBX6J0oddCX8mGZapwN
         qrMX90ZfFWZPQQHJPqOp6NjTS/0dc8sgmMiTcu3OB+FhssbdyWQoVME7XP4iuYUj5OlE
         UWctXoiqUAaWpe+WyDBCUQkPLn4ft++hcKKoIT5fflsrNYxXZRiseYjroYxJmsQCAy7Y
         enBfhVnz+YRNRpdYLoEIV4NeZm82rXaCd4IAkQtLZxxC2mgTx1oEEV1mq8dPGpXMElTq
         atrA==
X-Gm-Message-State: AOAM532ewhKD9dVEDYs57fRYmKzt+3s5Q+XUeD9dTNppgTuz0+SKzKzt
        Hh4DDk8v6BB9ea9LkDMti/MPSFVpuihaAkBEr5E=
X-Google-Smtp-Source: ABdhPJyEnWCoMDfH2i0HBPnsF/jpVigS3WGJwXYdVWthdfMH0pND3u7CqdgRvstM137UT/hj5eNbqwSpm0nHMR/eZqg=
X-Received: by 2002:a05:6512:b08:: with SMTP id w8mr10144778lfu.505.1634292919050;
 Fri, 15 Oct 2021 03:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090934.2870662-1-zenczykowski@gmail.com>
 <YWlKGFpHa5o5jFgJ@salvia> <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
 <20211015095716.GH2942@breakpoint.cc>
In-Reply-To: <20211015095716.GH2942@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 15 Oct 2021 03:15:07 -0700
Message-ID: <CAHo-OoxsN5d+ipbp0TQ=a+o=ynd3-w5RZ3S3F8Vg89ipT5=UHw@mail.gmail.com>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 2:57 AM Florian Westphal <fw@strlen.de> wrote:
>
> Maciej =C5=BBenczykowski <zenczykowski@gmail.com> wrote:
> > > Hm, I still don't understand why do you need this extra 3rd
> > > update/assured event event. Could you explain your usecase?
> >
> > Currently we populate a flow offload array on the assured event, and
> > thus the flow in both directions starts bypassing the kernel.
> > Hence conntrack timeout is no longer automatically refreshed - and
> > there is no opportunity for the timeout to get bumped to the stream
> > timeout of 120s - it stays at 30s.
> > We periodically (every just over 60-ish seconds) check whether packets
> > on a flow have been offloaded, and if so refresh the conntrack
> > timeout.  This isn't cheap and we don't want to do it even more often.
> > However this 60s cycle > 30s non-stream udp timeout, so the kernel
> > conntrack entry expires (and we must thus clear out the flow from the
> > offload).  This results in a broken udp stream - but only on newer
> > kernels.  Older kernels don't have this '2s' wait feature (which makes
> > a lot of sense btw.) but as a result of this the conntrack assured
> > event happens at the right time - when the timeout hits 120s (or 180s
> > on even older kernels).
> >
> > By generating another assured event when the udp stream is 'confirmed'
> > and the timeout is boosted from 30s to 120s we have an opportunity to
> > ignore the first one (with timeout 30) and only populate the offload
> > on the second one (with timeout 120).
> >
> > I'm not sure if I'm doing a good job of describing this.  Ask again if
> > it's not clear and I'll try again.
>
> Thanks for explaining, no objections to this from my side.
>
> Do you think it makes sense to just delay setting the ASSURED bit
> until after the 2s period?

That would work for this particular use case.... but I don't know if
it's a good idea.
I did of course think of it, but the commit message seemed to imply
there's a good reason to set the assured bit earlier rather than
later...

A udp flow becoming bidirectional seems like an important event to
notify about...
Afterall, the UDP flow might become a stream 29 seconds after it
becomes bidirectional...
That seems like a pretty long time (and it's user configurable to be
even longer) to delay the notification.

I imagine the pair of you know best whether 2 events or delay assured
event until stream timeout is applied makes more sense...

- Maciej
