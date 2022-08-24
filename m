Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877D45A0154
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbiHXSZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiHXSZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:25:50 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386C351A11;
        Wed, 24 Aug 2022 11:25:50 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id g21so13355472qka.5;
        Wed, 24 Aug 2022 11:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oXovj0168jGVoX33dk8lxmW/CZJtcTeRHxWEl1MbEoI=;
        b=mE2/qg0qYcnyUjaJZ9lx/ZmXD4O3ZG4XfSsZt0zND225HUoFHLq5Qs+ueN+94GYefq
         a9dkoGBED3rw7EUQG15AJx6S3vti7NeljXq+q/it05OjHtDtlNml/p8ulyeac7/1YhUY
         hI+U4TTcBJwIu8cR9no1oz+q1GfFwC1WycaznS68AYG5GSYc+LRmqNeU5aGoen/e4Qof
         CWzMXuPDKxsBHmS0I6BhpTMfwyxCubK4jQl0NBgzog0ApDM0I+IA4atB4MDktR9GIa+U
         DxmWyRTbZVabqGCJCnhrZQNP4tUxAyr2KT7pjpcJufVaIMYfl2Rga33JTaWPQ4tbRGZm
         O5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oXovj0168jGVoX33dk8lxmW/CZJtcTeRHxWEl1MbEoI=;
        b=2UT2oBBZs2lyMEFE4B2QJH3CkCo0EAaEJMEFUE1PI4fHSmgR/y5AGYaixbDVuC5eH7
         IqCzmBkatrn4twrecmhAbcoFLYVzIzZW+AuTW3WvmxnBQkAai5Aa9/x3hbXWmmbF4NJe
         Pkfg4yMJo8uZmDeIJlBeuge98YP5Jw3IbAYhkfvvDL42DgNCdT/vCsbYgyB1UeQJcBJb
         xYHbal1ZmPVPdbAt3X58pR8jXpTuyjvt2nmvYmkbsnXr9UnLuv45IARmnnERdm9Wpb6K
         EW25i2zLaHrhk87XRYVo73oVwJaXCBvieoB9oQ3z0D8s2fISxSpKx5vybMmie662uwIT
         z40w==
X-Gm-Message-State: ACgBeo3FsDAHmuavLNtzuunfYdpAFFL1kpTT00HzB8cPt3BIwaMizK3G
        wLKiiYyBPAeKJ+2CDBVwdaR+dKZ0xzt4RIswFNUWo9rKldl3Cg==
X-Google-Smtp-Source: AA6agR5wBWIVmX1HNvRlsaJLl1pHHAFTgtN0VEIyc/IX7uWR8W51eBrRkfQFQ6VGPgUuc6SZ5xvyn9IWa5KbeAXEJ4c=
X-Received: by 2002:a05:620a:1786:b0:6bb:38b2:b1d7 with SMTP id
 ay6-20020a05620a178600b006bb38b2b1d7mr435812qkb.510.1661365549209; Wed, 24
 Aug 2022 11:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
 <20220823154557.1400380-3-eyal.birger@gmail.com> <6477c6e6-cb01-eaa3-3e3e-b0f796fd08c2@iogearbox.net>
In-Reply-To: <6477c6e6-cb01-eaa3-3e3e-b0f796fd08c2@iogearbox.net>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 24 Aug 2022 21:25:37 +0300
Message-ID: <CAHsH6Gs51Dj8WLOecexK2rE8w+buWMDwSp3C6KJkeM1S=owguA@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: support collect metadata mode
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, devel@linux-ipsec.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Wed, Aug 24, 2022 at 8:06 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Eyal,
>
> On 8/23/22 5:45 PM, Eyal Birger wrote:
> > This commit adds support for 'collect_md' mode on xfrm interfaces.
> >
> > Each net can have one collect_md device, created by providing the
> > IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> > altered and has no if_id or link device attributes.
> >
> > On transmit to this device, the if_id is fetched from the attached dst
> > metadata on the skb. The dst metadata type used is METADATA_XFRM
> > which holds the if_id property.
> >
> > On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> > packet received and attaches it to the skb. The if_id used in this case is
> > fetched from the xfrm state. This can later be used by upper layers such
> > as tc, ebpf, and ip rules.
> >
> > Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> > metadata is postponed until after scrubing. Similarly, xfrm_input() is
> > adapted to avoid dropping metadata dsts by only dropping 'valid'
> > (skb_valid_dst(skb) == true) dsts.
> >
> > Policy matching on packets arriving from collect_md xfrmi devices is
> > done by using the xfrm state existing in the skb's sec_path.
> > The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> > is changed to keep the details of the if_id extraction tucked away
> > in xfrm_interface.c.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>
> Can be done in follow-up (once merged back from net-next into bpf-next),
> but it would be nice to also have a BPF CI selftest for it to make sure
> the ipsec+collect_md with BPF is consistently tested for incoming patches.

Indeed. Note that this requires the addition of set/get bpf helpers for
this metadata as the existing helpers are tied to ip_tunnel_info.

I used such helpers as part of testing this patch series, and plan to submit
them with the respective tests to bpf-next once this feature is merged in
its final form.

Thanks!
Eyal
