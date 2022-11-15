Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32342629912
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiKOMlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbiKOMlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:41:07 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA927903;
        Tue, 15 Nov 2022 04:41:00 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q1so13136376pgl.11;
        Tue, 15 Nov 2022 04:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X48jndA48qamIcOHPaTLYuNvAj5Lrb1g9vbTbZYhFQc=;
        b=HAXj2tHHM24Bhc1gdboVHdUno8Z2VKIRV+vIGCA8EksN02AerQTU0kUcLCBZG4ncI+
         ytcos098fBHesTCNGpcqhVKbGHAhjZniy7hM6Q/SciOSvslmHLOYwqhtq3UXRgKyXfXw
         nMJrdrJc7KvSXh5vDxlRcWlNGIiH9tpbTCBMSnqQaaJ2CKJx+X75cz7L0u5oUAcw6Gck
         IubbLDCtH4egdCuoczxO97lp7+mZbmIJdf93iecJOM6rUV2R51yP3NsgupCih1/wMcjn
         5rVMZBZTSUw9I2Dc5MPKUyIWa4GAkmoSyUcSB0dsA+p1FATPjuYl9kE414bAcy/e8LaF
         pM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X48jndA48qamIcOHPaTLYuNvAj5Lrb1g9vbTbZYhFQc=;
        b=qivblZm28/2pTII1a5d5pBIUG9SoWJw3pt318BC/SX3GxGX7iU76qnHpyCTp8ywAe8
         5n3OGvUHh/wBdvnjKHWXcKy+VJJK5nDPxRNhvbByg+PesmpjIvdk0ivnKdZs+j+RDDJA
         KlpxAouWSS8fAKYfIg2H0RZvaMrgCO4Qr+iu+zgrVSfngXkEV2VkNwcXA1BRMNQm5oeB
         NdWK3fsTzK3C7N0jrBJh3dCbnQUQLlPHlqW85Pob09EPoFD3qO4vT7dv/gayUfvFernc
         6/5XZMjBQONUbVdO+Oahwb9m2y2JbEHDyMeU3tjg9dmNkz4TIw9KngOSuzfRE2PznsTv
         cjWw==
X-Gm-Message-State: ANoB5pmHTfq0CM4fI4PzUWFNDi3Tl7gIuqWG+fh4BFx/puiWSkRkJz8B
        ORVdsHcsfkP+5pT/SZpxXSyfFX8tUYNPUQ/9IO4=
X-Google-Smtp-Source: AA0mqf5+gnQpQgUz/iVfkLxfYcva2ozYe1khPPHOU+EYpTchqGeUYmYHpgL2C6SUuNhn2oJMYwqa3W7NwHxwGITfRAQ=
X-Received: by 2002:a05:6a00:991:b0:571:baf8:8945 with SMTP id
 u17-20020a056a00099100b00571baf88945mr16819734pfg.83.1668516059820; Tue, 15
 Nov 2022 04:40:59 -0800 (PST)
MIME-Version: 1.0
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
 <20221115080538.18503-2-magnus.karlsson@gmail.com> <Y3OGJv2lym4u86C/@boxer>
In-Reply-To: <Y3OGJv2lym4u86C/@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 15 Nov 2022 13:40:48 +0100
Message-ID: <CAJ8uoz3kLArrELgNi7gr_xx_9dPSD6QrwZvw9-2mzqHr9y_yTw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] selftests/xsk: print correct payload for packet dump
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 1:29 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Nov 15, 2022 at 09:05:36AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Print the correct payload when the packet dump option is selected. The
> > network to host conversion was forgotten and the payload was
> > erronously declared to be an int instead of an unsigned int. Changed
> > the loop index i too, as it does not need to be an int and was
> > declared on the same row.
> >
> > The printout looks something like this after the fix:
> >
> > DEBUG>> L2: dst mac: 000A569EEE62
> > DEBUG>> L2: src mac: 000A569EEE61
> > DEBUG>> L3: ip_hdr->ihl: 05
> > DEBUG>> L3: ip_hdr->saddr: 192.168.100.161
> > DEBUG>> L3: ip_hdr->daddr: 192.168.100.162
> > DEBUG>> L4: udp_hdr->src: 2121
> > DEBUG>> L4: udp_hdr->dst: 2020
> > DEBUG>> L5: payload: 4
> > ---------------------------------------
>
> Above would be helpful if previous output was included as well but not a
> big deal i guess.

It would not bring any value IMHO. The only difference is that the
"L5: payload" row is now showing the correct payload.

> >
> > Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index 681a5db80dae..51e693318b3f 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
> >       struct ethhdr *ethhdr;
> >       struct udphdr *udphdr;
> >       struct iphdr *iphdr;
> > -     int payload, i;
> > +     u32 payload, i;
> >
> >       ethhdr = pkt;
> >       iphdr = pkt + sizeof(*ethhdr);
> > @@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
> >       fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
> >       fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
> >       /*extract L5 frame */
> > -     payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
> > +     payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
> >
> >       fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
> >       fprintf(stdout, "---------------------------------------\n");
> > --
> > 2.34.1
> >
