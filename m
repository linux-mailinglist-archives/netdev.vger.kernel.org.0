Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD256B8F08
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCNJzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNJzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:55:22 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B678763CD;
        Tue, 14 Mar 2023 02:55:20 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id ay14so3624688uab.13;
        Tue, 14 Mar 2023 02:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678787719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Il9aSYFgvyC+QVRpoSnFZREA4Z/90xca38uXI7ssx4=;
        b=BlgOw0/01AaBqF4PBzqRb/yWW8lU9q25ndV1l+QuScHpAkN7rAsPaRoQUtQdvC7Ua8
         D3ch+bOhUiZ49p0QsJK8wdz1/i4RL3Mu2JzVuBj/oZ3bpdA0UJYjds2MsF8YViyzJDAJ
         RshGQkpSPISDwgMT9up973C4JEimUoC4CS3rLrRjqJN3caI91vd31shRXIhW9lG+qEnz
         8Q3eJx4vKGCM9de8y0EcjZb3oZ3BxCHdodZlkhPrxGHpHpfFBeQK9ih7YXylguCE2yde
         F/CKD0LsFDoLgkPc1S7Mqb6sh5LM87CT5wFSQeai35PPQxXfPL/SnA429hlul+CjF+XZ
         Mlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678787719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Il9aSYFgvyC+QVRpoSnFZREA4Z/90xca38uXI7ssx4=;
        b=YGSBQtGXUQTxxU9JCQxex9t09fYVE4ndosamj4LvZpaFtTWO8ygA36/QrHN2Yn8DCw
         OX9t7e+98ft6GuLieoR6pkFV22ZdwWhZp+NusTiCvIOJRERhvcEfuVvBkcUafeO/aILX
         fC9XynYtHvl9ezk7JlO9kE86QyhV0IAXkYW85h+ew+Kj0lhOc9zUXQn1ciGvUfX1+5K4
         uvL8G4WpXuMRblmvNoEv+IL6OG1Mg+qdutDcAQoi464ft3mjoHRpqVTpVRqWOP1/fErt
         n8QqmB3ThTe8Hbq94LsGg6Gc0SPtKro/Is0GxjuxWJqWgCnjS4bDka61cuuBf92XJ2zS
         8dhA==
X-Gm-Message-State: AO0yUKVOJH44gvJcmzdwJ2upY389iAGOzz6oMpLlfOFJ/VL7CaTKl3Xr
        kgnS02mzbRT4+qN6VHJXYWiFzEUQbLRyizxibHk=
X-Google-Smtp-Source: AK7set/6MKWlYVJvaeh02CQeRyORxAEuEoedzIGcjVDrdsjiQrC3m8yxILNOPoyMBLBiQgoIWG1KVoPTUJFEuhsMIPE=
X-Received: by 2002:a05:6122:1424:b0:432:3ef:c8be with SMTP id
 o4-20020a056122142400b0043203efc8bemr3494988vkp.3.1678787719334; Tue, 14 Mar
 2023 02:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <ZA9T14Ks66HOlwH+@corigine.com> <20230312163726.55257-1-josef@miegl.cz>
 <57238dfc519a27b1b8d604879caa7b1b@miegl.cz> <ZA9s2Ti9PlUzsq/m@corigine.com>
In-Reply-To: <ZA9s2Ti9PlUzsq/m@corigine.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 14 Mar 2023 11:55:07 +0200
Message-ID: <CAHsH6GsUAzye2puFES_5iemTtQZyoiR590NRPC8ZXrTg4B+OMA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: geneve: accept every ethertype
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Mar 13, 2023 at 8:35=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Mar 13, 2023 at 05:14:58PM +0000, Josef Miegl wrote:
> > March 13, 2023 5:48 PM, "Simon Horman" <simon.horman@corigine.com> wrot=
e:
> >
> > > +Pravin
> > >
> > > On Sun, Mar 12, 2023 at 05:37:26PM +0100, Josef Miegl wrote:
> > >
> > >> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Typ=
e
> > >> field, which states the Ethertype of the payload appearing after the
> > >> Geneve header.
> > >>
> > >> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protoc=
ol")
> > >> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed t=
he
> > >> use of other Ethertypes than Ethernet. However, it imposed a restric=
tion
> > >> that prohibits receiving payloads other than IPv4, IPv6 and Ethernet=
.
> > >>
> > >> This patch removes this restriction, making it possible to receive a=
ny
> > >> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag =
is
> > >> set.
> > >>
> > >> This is especially useful if one wants to encapsulate MPLS, because =
with
> > >> this patch the control-plane traffic (IP, IS-IS) and the data-plane
> > >> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> > >> lightweight overlay networks a possibility.
> > >
> > > Hi Josef,
> > >
> > > I could be mistaken. But I believe that the thinking at the time,
> > > was based on the idea that it was better to only allow protocols that
> > > were known to work. And allow more as time goes on.
> >
> > Thanks for the reply Simon!
> >
> > What does "known to work" mean? Protocols that the net stack handles wi=
ll
> > work, protocols that Linux doesn't handle will not.
>
> Yes, a good question. But perhaps it was more "known to have been tested"=
.
>
> > > Perhaps we have moved away from that thinking (I have no strong feeli=
ng
> > > either way). Or perhaps this is safe because of some other guard. But=
 if
> > > not perhaps it is better to add the MPLS ethertype(s) to the if claus=
e
> > > rather than remove it.
> >
> > The thing is it is not just adding one ethertype. For my own use-case,
> > I would need to whitelist MPLS UC and 0x00fe for IS-IS. But I am sure
> > other people will want to use GENEVE` for xx other protocols.
>
> Right, so the list could be expanded for known cases.
> But I also understand your point,
> which I might describe as this adding friction.
>
> > The protocol handling seems to work, what I am not sure about is if
> > allowing all Ethertypes has any security implications. However, if thes=
e
> > implications exist, safeguarding should be done somewhere down the stoc=
k.
>
> Yes, I believe that the idea was to limit the scope of such risks.
> (Really, it was a long time ago, so I very likely don't recall everything=
.)

Digging a little into the history of this code I found this discussion [1]
where this specific point was raised:

<quote>
>> +       if (unlikely(geneveh->proto_type !=3D htons(ETH_P_TEB)))
>
> Why? I thought the point of geneve carrying protocol field was to
> allow protocols other than Ethernet... is this temporary maybe?

Yes, it is temporary. Currently OVS only handles Ethernet packets but
this restriction can be lifted once we have a consumer that is capable
of handling other protocols.
</quote>

This seems to have been ported as is when moving to a generic net device.

So now that the consumer is capable of other protocols, the question is
whether the restrictions should be lifted for any protocol or moderately.

I went with the moderate approach when adding IP support, but I do see the
merits in allowing any protocol without having to fiddle with this code.

https://www.spinics.net/lists/netdev/msg290579.html
