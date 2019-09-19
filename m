Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B2B7A69
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389539AbfISNZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:25:52 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39929 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388408AbfISNZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:25:51 -0400
Received: by mail-yw1-f65.google.com with SMTP id n11so1216732ywn.6
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODzgNTUmVPuH64CjVFVddrF9fsWejPsYydv8I2uPAKg=;
        b=Jttb49oGSGPOMheyOLS+vXPhu5wpu9g0pA6WUTqthvXtKUy4dQqpZnCdqWpzY0npa0
         Aa0zzFRfXlUfwPHUjue/mZL6fgpiXJ+hk6nrTd2MVYTYctpugdC60W9n+KvPCu2Atl9z
         KB0P3EdluuwuWeWP53+Rs9bpSjTdkgH5Q/ZYSq9dlqVfRXlSdZkwa8VESamUwOrcxtMs
         QLX/aYp+zbSTTXoDeKeXZ5VfSQz7eiu69ttzUjtQ/gzAWHEU2Rc3SsX0fVnLMAYKEtqy
         hHNPW3sjeKvak+cYRu5faiFnJsaBA9agouWPAL8zwaPcoiIrjKuKeJZuvfvAHjsajaJG
         h2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODzgNTUmVPuH64CjVFVddrF9fsWejPsYydv8I2uPAKg=;
        b=GadLjwS+9fCe1N59/bmICbh2so9cMqGDDjQRwyp9B/XTyOKKIiofv80/xX+OmgYZkc
         fE9+m/TgZ4mxXhlxm9JW6bACP6hTiHzqhZTaEs80eoxhgLVUGFioiw1HkkULf/W2g4na
         sWiYNpeu/sUwzILBH56lq9ktiAXMHYcctmLoT3t0xlIeLWQc7vrjzkcHyTTiHOryVirE
         zRPQmEYh1OezGRk6IgFJO9pDxNW/aAhtvD3/v2jTpmI8vSk5c3aHZrg/XEUJCWew9fvJ
         F0cBkeaqmTpQmFgCvG1KgxMvdZ7LQLHo7eO3gsX6vGEa0iynICkMBLrk5qGQ8OsPhB9M
         obWw==
X-Gm-Message-State: APjAAAUWWsxs0I1DZnLaDP2GevcHZmFpoSXG7WEeBbxTadOS2j+JwCvT
        PM6nkYWPYwrqo5kvot8IbNWxyAql
X-Google-Smtp-Source: APXvYqxXapFz5108pRICyC0PrrYc+xWhfU3sn4KAY46GKbT04XFczMajK8Bxo4x2S1uUbuvpoBHXhg==
X-Received: by 2002:a81:9a92:: with SMTP id r140mr7842894ywg.285.1568899548572;
        Thu, 19 Sep 2019 06:25:48 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id z124sm1891905ywf.89.2019.09.19.06.25.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 06:25:47 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id y6so1304802ybq.12
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:25:47 -0700 (PDT)
X-Received: by 2002:a25:d54:: with SMTP id 81mr6404857ybn.391.1568899547184;
 Thu, 19 Sep 2019 06:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190918165817.GA3431@localhost.localdomain> <CA+FuTSf0N9uhOM3r8xvXiVj0xhx0KqL6-rV9EGhBJ=d8oGaxyg@mail.gmail.com>
 <20190919130746.GC3431@localhost.localdomain>
In-Reply-To: <20190919130746.GC3431@localhost.localdomain>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Sep 2019 09:25:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSebcFKP4kedJYMXg9WTTxmcaVx_erCHuxTB==UNfNLNGQ@mail.gmail.com>
Message-ID: <CA+FuTSebcFKP4kedJYMXg9WTTxmcaVx_erCHuxTB==UNfNLNGQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 9:07 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Sep 19, 2019 at 08:55:22AM -0400, Willem de Bruijn wrote:
> > On Wed, Sep 18, 2019 at 12:58 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> > > > On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> > > > <steffen.klassert@secunet.com> wrote:
> > > > >
> > > > > This patchset adds support to do GRO/GSO by chaining packets
> > > > > of the same flow at the SKB frag_list pointer. This avoids
> > > > > the overhead to merge payloads into one big packet, and
> > > > > on the other end, if GSO is needed it avoids the overhead
> > > > > of splitting the big packet back to the native form.
> > > > >
> > > > > Patch 1 Enables UDP GRO by default.
> > > > >
> > > > > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > > > > this implements one of the configuration options discussed
> > > > > at netconf 2019.
> > > > >
> > > > > Patch 3 adds a netdev software feature set that defaults to off
> > > > > and assigns the new listifyed GRO feature flag to it.
> > > > >
> > > > > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
> > > > >
> > > > > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> > > > > GRO supported socket is found.
> > > >
> > > > Very nice feature, Steffen. Aside from questions around performance,
> > > > my only question is really how this relates to GSO_BY_FRAGS.
> > >
> > > They do the exact same thing AFAICT: they GSO according to a
> > > pre-formatted list of fragments/packets, and not to a specific size
> > > (such as MSS).
> > >
> > > >
> > > > More specifically, whether we can remove that in favor of using your
> > > > new skb_segment_list. That would actually be a big first step in
> > > > simplifying skb_segment back to something manageable.
> > >
> > > The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
> > > dealing with frags instead of frag_list was considered easier to be
> > > offloaded, if ever attempted.  So this would be a step back on that
> > > aspect.  Other than this, it should be doable.
> >
> > But GSO_BY_FRAGS also uses frag_list, not frags?
>
> /me is scratching his head.
> My bad. I thought it was already using frags. Thanks.
>
> >
> > And list_skb->len for mss.
>
> Which stands more for 'current frag size', yes.
> (list_skb, not head_skb)

Great. I thought I missed something :)

Frags might be cheaper from an allocation point. If at some point
going down that road.

But in the meantime, it looks like we can handle these too with
skb_segment_list, then (not necessarily in the initial patch set).
