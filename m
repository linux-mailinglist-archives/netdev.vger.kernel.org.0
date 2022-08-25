Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAA45A1172
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiHYNEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242317AbiHYNEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:04:09 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C618B4E8B;
        Thu, 25 Aug 2022 06:03:22 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a15so15054398qko.4;
        Thu, 25 Aug 2022 06:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=GJC7qD9d1W6eDyppasNe8HwkoqM5dpioIU4IhwDYcaQ=;
        b=qHZrw1guA6eKGfxXcu7JwAbjiXJtCGR0zfN/sL+4Ye1Rzl8U9+iRyrunXnD+i+pnrf
         tj+O/OIDAtfqqB+WerC2ZOA81oMUJzValr8n9winslL3AI+xVU178LswuAUeF/zIrGQ0
         gyeakclDrYNGRaCYAEe5Yjts4wUysTzT+/lHFwrWkOlWTlEOIFYk6xJctbLVKGQYQgZv
         gx1+TfVEf0UtDjlTgwyj2brZjp10rQwFJtf8kLriTnQlyxLTF1PpMCCRongDLHz6uGou
         OhAV2dtOAZPV/kFbK+REnJaV9x4gdD8V6RlhTfPk18s75C80MVF8wQqZcF4J7IaN7YQI
         7DfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=GJC7qD9d1W6eDyppasNe8HwkoqM5dpioIU4IhwDYcaQ=;
        b=j3V+/GHpIrl5xY8nFHKaT8070Y8oRA6zifnqxyLqhlV3vzIYTsrIlEaWdwDaz7HXBd
         wYeiXWCX4AdItyjihBYvoyREzAt7+6GImDB1Ql7vDNdxKGoVeAJHE1d5E5Pu1GlhdvYp
         BHbb0WfYzNhy7gfXmBQtm7ZRX7kcAoJ09LybS0BXJEGt6rUTybpEuXcyDcM7sqQNks9d
         UNMpAHYZ4t2wpYa9z/xqSvr1wv/C1hHyh92+z17yz0G2GU3B08xTDfDHzwY/Qj0LHo4S
         oyreELlXhQoAVIqYEKpGJX+8/6Yee1J87ea72/o7siy4LClBN47nSc023rKFO0cllpjC
         Vs0g==
X-Gm-Message-State: ACgBeo1Q17yWwmQiUC6fzweqVWHYcB2ryHmL19S9OJPSWL5BUSBI9FdR
        xDI44Qsz7QMFVepmP+rLGlR3XyLoM1Eu6cEpH7EASkvDCNZc0A==
X-Google-Smtp-Source: AA6agR7sBYeMOY7eBKvp2nOxyOpxuCFGUmrA1j0MJ/awVykpx7cT2eddspJ7lsEj4uv3QA+2icXMK8WQwn4OJIAldQI=
X-Received: by 2002:a05:620a:1786:b0:6bb:38b2:b1d7 with SMTP id
 ay6-20020a05620a178600b006bb38b2b1d7mr2906183qkb.510.1661432595693; Thu, 25
 Aug 2022 06:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
 <20220823154557.1400380-4-eyal.birger@gmail.com> <565cce1e-0890-dd35-7b26-362da2cde128@6wind.com>
 <CAHsH6Gv0AaNamsumhdqVtuTCMkJCwcAam07kZZoQ0vbuZi7tHA@mail.gmail.com> <0e44ad3b-e1a0-6af4-5e8f-f808d3b28715@6wind.com>
In-Reply-To: <0e44ad3b-e1a0-6af4-5e8f-f808d3b28715@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 25 Aug 2022 16:03:05 +0300
Message-ID: <CAHsH6GviZudwDHwG-JDqGapzVP95spY1=J+5xM2GX_711L+DWA@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 3/3] xfrm: lwtunnel: add lwtunnel support for
 xfrm interfaces in collect_md mode
To:     nicolas.dichtel@6wind.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, devel@linux-ipsec.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 1:07 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 24/08/2022 =C3=A0 20:56, Eyal Birger a =C3=A9crit :
> > Hi Nicolas,
> >
> > On Wed, Aug 24, 2022 at 6:21 PM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> >>
> >>
> >> Le 23/08/2022 =C3=A0 17:45, Eyal Birger a =C3=A9crit :
> >>> Allow specifying the xfrm interface if_id as part of a route metadata
> >>> using the lwtunnel infrastructure.
> >>>
> >>> This allows for example using a single xfrm interface in collect_md
> >>> mode as the target of multiple routes each specifying a different if_=
id.
> >>>
> >>> With the appropriate changes to iproute2, considering an xfrm device
> >>> ipsec1 in collect_md mode one can for example add a route specifying
> >>> an if_id like so:
> >>>
> >>> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
> >> It would be nice to be able to specify the link also. It may help to c=
ombine
> >> this with vrf. Something like
> >> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 dev eth0
> >
> > I think I understand how this would work on xmit - if you mean adding l=
ink
> > to the metadata and using it to set fl.flowi_oif in xfrmi_xmit() - in w=
hich
> > case the link would be used in the underlying lookup such that routes i=
n
> > a vrf could specify a device which is part of the vrf for egress.
> Yes.
>
> >
> > On RX we could assign the link in the metadata in xfrmi_rcv_cb() to the=
 original
> > skb->dev. I suspect this would be aligned with the link device, but any=
 input
> > you may have on this would be useful.
> The link is not used in the rx path, only in the tx path to perform the r=
oute
> lookup in the right vrf. You can assign the input iface to the link devic=
e, but
> the if_id should be enough to identify the tunnel.

Thanks. I tested this in the context of VRF and it works well.

I'll include it in v2.

Eyal.
