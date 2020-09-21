Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72E2271B3B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIUHIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUHIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:08:00 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EB8C061755;
        Mon, 21 Sep 2020 00:07:59 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id y5so11440274otg.5;
        Mon, 21 Sep 2020 00:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IBCwAKxPsT4wgI+ZKAQlpzARiGXtopA8o7THgl5POCk=;
        b=XoTedSWX4WiOMYCFwMhra3sHUINJwbn4jF//5GOY9uXzaKsnIacovpii2d3q9LdXXg
         vq2x/Ogm7s/I4TTr5WNCy/8Rb84ZMEcA/70bcXXyBwMrOEy02AMABecOEdBiF7IAd+8q
         QGfMe9Z8U17aiF2P6cV7ApzSWc3r7H8Mff33qLg08mPRh19XdeUGMeAZ3VrFQqYMs6j/
         HTlJuqAMTuN/jCIZNnB45QPoyOfnABwnmw4fKkJpiYqFLrsS1xwb2DkUJ4+oE+vFRkrp
         jhH417RYFSt+0+Z3O4HmS+wqxrBYxtoN33Yyl7T9wE1YbNhAMJbGu6d/BODyVr6liwxh
         uP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IBCwAKxPsT4wgI+ZKAQlpzARiGXtopA8o7THgl5POCk=;
        b=mnEVjnErarTjA9izagf6QFwYfh7J6OJr0+Ge5NOwRX67IXGvng4r4x8Y7wwabArRFe
         XbNWGnzsZjpBjffC6UnmBLzX7Lq2wwolfGmQHzDPmsDL1DIHDIILRCmRX9jSDXw3DiK2
         /EDcfGYheu/PzWi5Uh54KGznXEUX873LitUqKj8HLlb+k/n7/5GC6N9DVrLPePI5SEaR
         oxoAiiHr7vFpZSOJ9CbuA7FhvBoGPCWa7ev+1P1dxwiNGQ/0wlt4ypy/dNKh8jqDzxvg
         vFPIjyfYjV2MiUltZoahb2CSaJi3ItiDloqdXzzdKIL1ilSAH550tNrdbXdPO4U+uq4H
         IDxQ==
X-Gm-Message-State: AOAM531+MFmEM+T3ZJS6Swg5x3HRlERkZW50UDTOLjYIEK2J2gY7ywxS
        ocxa99NcCON5TOOcl1sXTOfSnm9P4vH3h6LJqXKrYYlwMQDZyg==
X-Google-Smtp-Source: ABdhPJww/tVbXXelVSejpiDpu+OZVVFGY/8oYGkRg3Tnd25nA+NfnJs0C1EQEYw1zA4gG0oqrBozr33YQ5fnWMw9vYE=
X-Received: by 2002:a9d:315:: with SMTP id 21mr32289208otv.278.1600672079022;
 Mon, 21 Sep 2020 00:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de> <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net> <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net> <CAF90-Wiof1aut-KoA=uA-T=UGmUpQvZx_ckwY7KnBbYB8Y3+PA@mail.gmail.com>
 <b0989f93-e708-4a68-1622-ab3de629be77@iogearbox.net>
In-Reply-To: <b0989f93-e708-4a68-1622-ab3de629be77@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Mon, 21 Sep 2020 09:07:46 +0200
Message-ID: <CAF90-Wg7-m0-5HMGJGnfK3VJ-SVSfRaju1gRnCP921FSxsnA6Q@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Fri, Sep 18, 2020 at 10:31 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 9/17/20 12:28 PM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> > On Tue, Sep 15, 2020 at 12:02 AM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> >> On 9/14/20 1:29 PM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> >>> On Fri, Sep 11, 2020 at 6:28 PM Daniel Borkmann <daniel@iogearbox.net=
> wrote:
> >>>> On 9/11/20 9:42 AM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> >>>>> On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.ne=
t> wrote:
> >>>>>> On 9/5/20 7:24 AM, Lukas Wunner wrote:
> >>>>>>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
> >>>>>>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
> >>>>>> [...]
> >>>>>>>> The tc queueing layer which is below is not the tc egress hook; =
the
> >>>>>>>> latter is for filtering/mangling/forwarding or helping the lower=
 tc
> >>>>>>>> queueing layer to classify.
> >>>>>>>
> >>>>>>> People want to apply netfilter rules on egress, so either we need=
 an
> >>>>>>> egress hook in the xmit path or we'd have to teach tc to filter a=
nd
> >>>>>>> mangle based on netfilter rules.  The former seemed more straight=
-forward
> >>>>>>> to me but I'm happy to pursue other directions.
> >>>>>>
> >>>>>> I would strongly prefer something where nf integrates into existin=
g tc hook,
> >>>>>> not only due to the hook reuse which would be better, but also to =
allow for a
> >>>>>> more flexible interaction between tc/BPF use cases and nf, to name=
 one
> >>>>>
> >>>>> That sounds good but I'm afraid that it would take too much back an=
d
> >>>>> forth discussions. We'll really appreciate it if this small patch c=
an
> >>>>> be unblocked and then rethink the refactoring of ingress/egress hoo=
ks
> >>>>> that you commented in another thread.
> >>>>
> >>>> I'm not sure whether your comment was serious or not, but nope, this=
 needs
> >>>> to be addressed as mentioned as otherwise this use case would regres=
s. It
> >>>
> >>> This patch doesn't break anything. The tc redirect use case that you
> >>> just commented on is the expected behavior and the same will happen
> >>> with ingress. To be consistent, in the case that someone requires bot=
h
> >>> hooks, another tc redirect would be needed in the egress path. If you
> >>> mean to bypass the nf egress if tc redirect in ingress is used, that
> >>> would lead in a huge security concern.
> >>
> >> I'm not sure I parse what you're saying above ... today it is possible=
 and
> >> perfectly fine to e.g. redirect to a host-facing veth from tc ingress =
which
> >> then goes into container. Only traffic that goes up the host stack is =
seen
> >> by nf ingress hook in that case. Likewise, reply traffic can be redire=
cted
> >> from host-facing veth to phys dev for xmit w/o any netfilter interfere=
nce.
> >> This means netfilter in host ns really only sees traffic to/from host =
as
> >> intended. This is fine today, however, if 3rd party entities (e.g. dis=
tro
> >> side) start pushing down rules on the two nf hooks, then these use cas=
es will
> >> break on the egress one due to this asymmetric layering violation. Hen=
ce my
> >> ask that this needs to be configurable from a control plane perspectiv=
e so
> >> that both use cases can live next to each other w/o breakage. Most tri=
vial
> >
> > Why does it should be symmetric? Fast-paths create "asymmetric
> > layering" continuously, see: packet hit XDP to user space bypassing
> > ingress, but in the response will hit egress. So the "breakage" is
> > already there.
>
> Not quite sure what you mean exactly here or into which issue you ran. Ei=
ther

I don't really know, we were discussing about your issue :)

> you push the xdp buffer back out from XDP layer for load balancer case so=
 upper
> stack never sees it, or you push it to upper stack, and it goes through t=
he
> ingress/egress hooks e.g. from tc side. AF_XDP will bypass either. If you=
 mean
> the redirect from XDP layer to the veth devs where they have XDP support,=
 then
> the reply path also needs to operate /below/ netfilter on tc layer exactl=
y for
> the reason /not/ to break, as otherwise we get potentially hard to debug =
skb
> drops on netfilter side when CT is involved and it figures it must drop d=
ue to

So, the "breakage" is about because it is difficult to debug CT drops,
or maybe it creates asymmetric layering, or maybe problems with nf/tc
interoperation? Sorry, this is so confusing. I suspect that the issue
you're talking about is a consequence of having different hooks,
nothing specifically related to this patch cause these use cases
you're referring to are happening right now with XDP, tc and CT.

The advantage is that with nf you only register the hooks required, so
this won't be a problem. Also, we are having more and more mechanisms
for ingress and CT interoperation, and this will be quite easy to
extend to egress.

> invalid CT state to name one example. That is if there is an opt-in to su=
ch data
> path being used, then it also needs to continue to work, which gets me ba=
ck to
> the earlier mentioned example with the interaction on the egress side wit=
h that
> hook that it needs to /interoperate/ with tc to avoid breakage of existin=
g use
> cases in the wild. Reuse of skb flag could be one option to move forward,=
 or as
> mentioned in earlier mails overall rework of ingress/egress side to be a =
more
> flexible pipeline (think of cont/ok actions as with tc filters or stackab=
le LSMs
> to process & delegate).

Again, a flag is not needed as you can register and de-register nf
hooks on demand.

Thanks!
