Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1951AED1
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377922AbiEDUPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344522AbiEDUPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:15:33 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA744F44C
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:11:55 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id s14so1572403ild.6
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 13:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bd9BkdfgA4vEQxK1RVTZQAFiAiXcQVsfW/F3sw4bLsQ=;
        b=J1MCM3qvnEq+o2FHC4Lcisg5fxszYjH9DyjPSkXfzXCQJ9nSzN3z2MESvfEUCIEtzX
         N8x+wzJzWnV/zQzTPsblUGo8y2Z9ujKYlec8LciOT5H+bTui0JxZXc1bUWiRLLzQbjMj
         +h0aWPobqnEK50snwMizT6WClKiZ0W1bdU8Tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bd9BkdfgA4vEQxK1RVTZQAFiAiXcQVsfW/F3sw4bLsQ=;
        b=sLktxflr3l+qHfKA/NHE6n8GY2HyQsAJS2Mu9wgpxsC1UD28v7Pr/kc4gFJtRkRvxC
         ttnB+v0yV5OAwTerUq47BKVWBPnA3NcNCB8kIINR7Nem6sOGaHIuw/rlmm98j5UoTaR/
         f6kKPFFmy2zJ0N0IsErBiTjwv3kUtZ2me4t1eO5tXiEK4TH4Rx3HuFgjLlycissnjn/z
         9VdZ8gtz6xX9RhnYZWdPFp8QG3ojAMee5RcH/AByjU49bNlBIp8mi2jAYb+Y3nP9pQMX
         nBat3+GvyZgbpC7Onvph2oEa82uKbbkRuJYmtJxkTaDQ6pb0yGGS692p8PoYqXDoTdUr
         17Nw==
X-Gm-Message-State: AOAM533HflpcH5zVeGPszHeNsVSoda+iG4HZzjdEd5ndZDw6Rw3wIs4v
        kr9ufMYYd7PnicD0/qAIQDEx9HVOs5sD1rsPBLlktg==
X-Google-Smtp-Source: ABdhPJzslFp7VbVmmkw4GMYtZkklz7a12UnLAQseB/VxIVcaHFbnyP5zXrjrknW80YPVwTzHxoRMloFlq7wK6wQTSzI=
X-Received: by 2002:a05:6e02:1a64:b0:2cf:1f40:4aa9 with SMTP id
 w4-20020a056e021a6400b002cf1f404aa9mr5666382ilv.249.1651695114750; Wed, 04
 May 2022 13:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220418231746.2464800-1-grundler@chromium.org>
 <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
 <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com> <CANEJEGtVFE8awJz3j9j7T2BseJ5qMd_7er7WbdPQNgrdz9F5dg@mail.gmail.com>
 <BY3PR18MB4578949E822F4787E95A126CB4C09@BY3PR18MB4578.namprd18.prod.outlook.com>
 <CANEJEGvsfnry=tFOyx+cTRHJyTo2-TNOe1u4AWV+J=amrFyZpw@mail.gmail.com> <BY3PR18MB4578158E656F2508B43B21F6B4C39@BY3PR18MB4578.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB4578158E656F2508B43B21F6B4C39@BY3PR18MB4578.namprd18.prod.outlook.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Wed, 4 May 2022 13:11:41 -0700
Message-ID: <CANEJEGuVwMa9ufwBM817dnbUxBghM0mcsPvrwx1vAWLoZ+CLaA@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
To:     Dmitrii Bezrukov <dbezrukov@marvell.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 4, 2022 at 7:39 AM Dmitrii Bezrukov <dbezrukov@marvell.com> wro=
te:
>
> Hi Grant,
>
> > Did I misunderstand what this code (line 378) is doing in aq_ring.c?
> Yes it's done there. I meant that in 'hw_atl/hw_atl_b0.c" there is not ac=
cess to buffer.

Ah ok - understood.
> And probably it's not a good place to put this your change there. Due to =
you are going to drop this 1/5 patch, it doesn=E2=80=99t make any sense any=
more.


>
> > *nod*
> I'm sorry but I don=E2=80=99t understand what it means.

:) It's an acknowledgement - You have to imagine me nodding my head in "yes=
". :)

>
> > Should this loop be checking against HW_ATL_B0_LRO_RXD_MAX instead?
> No, that's OK to check with MAX_SKB_FRAGS as you do.

OK :)

>
> >Sorry, I'm not understanding your conclusion. Is the "goto err_exit"
> >in this case doing what you described?
> >Does this patch have the right idea (even if it should test against a di=
fferent constant)?
> >
> >My main concern is the CPU gets stuck in this loop for a very long
> >(infinite?) time.
> Yes this is exactly that I meant, that in this case, the condition to pus=
h packet to stack will not be ever reached.
> So to close session I guess need to set is_rsc_completed to true when num=
ber of frags is going to exceed value MAX_SKB_FRAGS, then packet will be bu=
ilt and submitted to stack.
> But of course need to check that there will not be any other corner cases=
 with this new change.

Ok. Sounds like I should post a v2 then and just drop 1/5 and 5/5
patches.  Will post that tomorrow.

Thanks again!
grant

>
> Best regards,
> Dmitrii Bezrukov
>
> -----Original Message-----
> From: Grant Grundler <grundler@chromium.org>
> Sent: Tuesday, May 3, 2022 8:07 PM
> To: Dmitrii Bezrukov <dbezrukov@marvell.com>
> Cc: Grant Grundler <grundler@chromium.org>; Igor Russkikh <irusskikh@marv=
ell.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>=
; netdev <netdev@vger.kernel.org>; David S . Miller <davem@davemloft.net>; =
LKML <linux-kernel@vger.kernel.org>; Aashay Shringarpure <aashay@google.com=
>; Yi Chou <yich@google.com>; Shervin Oloumi <enlightened@google.com>
> Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
>
> Hi Dmitrii!
>
> On Tue, May 3, 2022 at 4:15 AM Dmitrii Bezrukov <dbezrukov@marvell.com> w=
rote:
> >
> > Hi Grants,
> >
> > >[1/5] net: atlantic: limit buff_ring index value
> >
> > >diff --git
> > >a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >index d875ce3ec759..e72b9d86f6ad 100644
> > >--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >@@ -981,7 +981,9 @@  int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s
> > >*self, struct aq_ring_s *ring)
> > >
> > >                       if (buff->is_lro) {
> > >                               /* LRO */
> > >-                              buff->next =3D rxd_wb->next_desc_ptr;
> > >+                              buff->next =3D
> > >+                                      (rxd_wb->next_desc_ptr < ring->=
size) ?
> > >+                                      rxd_wb->next_desc_ptr : 0U;
> > >                               ++ring->stats.rx.lro_packets;
> > >                       } else {
> > >                               /* jumbo */
> >
> > I don=E2=80=99t find this way correct. At least in this functions there=
 is no access to buffers by this index "next".
>
> Did I misunderstand what this code (line 378) is doing in aq_ring.c?
> 342 #define AQ_SKB_ALIGN SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> 343 int aq_ring_rx_clean(struct aq_ring_s *self,
> 344                      struct napi_struct *napi,
> 345                      int *work_done,
> 346                      int budget)
> 347 {
> ...
> 371                                 if (buff_->next >=3D self->size) {
> 372                                         err =3D -EIO;
> 373                                         goto err_exit;
> 374                                 }
> 375
> 376                                 frag_cnt++;
> 377                                 next_ =3D buff_->next,
> 378                                 buff_ =3D &self->buff_ring[next_];
>
> My change is redundant with Lines 371-374 - they essentially do the same =
thing and were added on
> 2021-12-26 by 5f50153288452 (Zekun Shen)
>
> The original fuzzing work was done on chromeos-v5.4 kernel and didn't inc=
lude this change. I'll backport 5f50153288452t to chromeos-v5.4 and drop my=
 proposed change.
>
> > Following this fix, if it happens then during assembling of LRO session=
 it could be that this buffer (you suggesting to use buffer with index 0) b=
ecomes a part of current LRO session and will be also processed as a single=
 packet or as a part of other LRO huge packet.
> > To be honest there are lot of possibilities depends on current values o=
f head and tail which may cause either memory leak or double free or someth=
ing else.
>
> *nod*
>
> > There is a code which calls this function aq_ring.c: aq_ring_rx_clean.
>
> Exactly.
>
> > From my POV it's better to check that indexes don't point to outside of=
 ring in code which collects LRO session.
>
> Sounds good to me. I don't have a preference. I'm ok with dropping/ignori=
ng [1/5] patch.
>
> > There is expectation that "next" is in range "cleaned" descriptors, whi=
ch means that HW put data there wrote descriptor and buffers are ready to b=
e process by assembling code.
> > So in case if "next" points to something outside of ring then guess it =
would be better just to stop collecting these buffers to one huge packet an=
d treat this LRO session as completed.
> > Then rest of buffers (which should be it that chain) will be collected =
again without beginning and just dropped by stack later.
>
> That makes sense to me. And apologies for not noticing Zekun Shen's
> 2021-12-26 change earlier. I've been working on this off and on for sever=
al months.
>
> > > [4/5] net: atlantic: add check for MAX_SKB_FRAGS
> > >
> > >diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> > >b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> > >index bc1952131799..8201ce7adb77 100644
> > >--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> > >+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> > >@@ -363,6 +363,7 @@  int aq_ring_rx_clean(struct aq_ring_s *self,
> > >                       continue;
> > >
> > >               if (!buff->is_eop) {
> > >+                      unsigned int frag_cnt =3D 0U;
> > >                       buff_ =3D buff;
> > >                       do {
> > >                               bool is_rsc_completed =3D true; @@
> > >-371,6 +372,8 @@  int aq_ring_rx_clean(struct aq_ring_s *self,
> > >                                       err =3D -EIO;
> > >                                       goto err_exit;
> > >                               }
> > >+
> > >+                              frag_cnt++;
> > >                               next_ =3D buff_->next,
> > >                               buff_ =3D &self->buff_ring[next_];
> > >                               is_rsc_completed =3D @@ -378,7 +381,8 @=
@
> > >int aq_ring_rx_clean(struct aq_ring_s *self,
> > >                                                           next_,
> > >
> > >self->hw_head);
> > >
> > >-                              if (unlikely(!is_rsc_completed)) {
> > >+                              if (unlikely(!is_rsc_completed) ||
> > >+                                  frag_cnt > MAX_SKB_FRAGS) {
> > >                                       err =3D 0;
> > >                                       goto err_exit;
> > >                               }
> >
> > Number of fragments are limited by HW configuration: hw_atl_b0_internal=
.h: #define HW_ATL_B0_LRO_RXD_MAX 16U.
>
> Should this loop be checking against HW_ATL_B0_LRO_RXD_MAX instead?
>
> > Let's imagine if it happens: driver stucks at this point it will wait f=
or session completion and session will not be completed due to too much fra=
gments.
> > Guess in case if number of buffers exceeds this limit then it is requir=
ed to close session and continue (submit packet to stack and finalize clear=
ing if processed descriptors/buffers).
>
> Sorry, I'm not understanding your conclusion. Is the "goto err_exit"
> in this case doing what you described?
> Does this patch have the right idea (even if it should test against a dif=
ferent constant)?
>
> My main concern is the CPU gets stuck in this loop for a very long
> (infinite?) time.
>
> >
> > > [5/5] net: atlantic: verify hw_head_ is reasonable diff --git
> > >a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >index e72b9d86f6ad..9b6b93bb3e86 100644
> > >--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> > >@@ -889,6 +889,27 @@  int hw_atl_b0_hw_ring_tx_head_update(struct aq_h=
w_s *self,
> > >               err =3D -ENXIO;
> > >               goto err_exit;
> > >       }
> > >+
> > >+      /* Validate that the new hw_head_ is reasonable. */
> > >+      if (hw_head_ >=3D ring->size) {
> > >+              err =3D -ENXIO;
> > >+              goto err_exit;
> > >+      }
> > >+
> > >+      if (ring->sw_head >=3D ring->sw_tail) {
> > >+              /* Head index hasn't wrapped around to below tail index=
. */
> > >+              if (hw_head_ < ring->sw_head && hw_head_ >=3D ring->sw_=
tail) {
> > >+                      err =3D -ENXIO;
> > >+                      goto err_exit;
> > >+              }
> > >+      } else {
> > >+              /* Head index has wrapped around and is below tail inde=
x. */
> > >+              if (hw_head_ < ring->sw_head || hw_head_ >=3D ring->sw_=
tail) {
> > >+                      err =3D -ENXIO;
> > >+                      goto err_exit;
> > >+              }
> > >+      }
> > >+
> > >       ring->hw_head =3D hw_head_;
> > >       err =3D aq_hw_err_from_flags(self);
> >
> > Simple example. One packet with one buffer was sent. Sw_tail =3D 1, sw_=
head=3D0. From interrupt this function is called and hw_head_ is 1.
> > Code will follow "else" branch of second "if" that you add and conditio=
n "if (hw_head_ < ring->sw_head || hw_head_ >=3D ring->sw_tail) {" will be =
true which seems to be not expected.
>
> Correct - I've got this wrong (head/tail swapped). Even if I had it right=
, As Igor observed, debatable if it's necessary. Please drop/ignore this pa=
tch as well. Aashay and I need to discuss this more.
>
> thank you again!
>
> cheers,
> grant
>
>
> >
> > Best regards,
> > Dmitrii Bezrukov
> >
> > -----Original Message-----
> > From: Grant Grundler <grundler@chromium.org>
> > Sent: Tuesday, April 26, 2022 7:21 PM
> > To: Igor Russkikh <irusskikh@marvell.com>
> > Cc: Grant Grundler <grundler@chromium.org>; Dmitrii Bezrukov
> > <dbezrukov@marvell.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; netdev <netdev@vger.kernel.org>; David S . Miller
> > <davem@davemloft.net>; LKML <linux-kernel@vger.kernel.org>; Aashay
> > Shringarpure <aashay@google.com>; Yi Chou <yich@google.com>; Shervin
> > Oloumi <enlightened@google.com>
> > Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
> >
> > [reply-all again since I forgot to tell gmail to post this as "plain
> > text"...grrh... so much for AI figuring this stuff out.]
> >
> >
> > On Tue, Apr 26, 2022 at 9:00 AM Igor Russkikh <irusskikh@marvell.com> w=
rote:
> > >
> > > Hi Grant,
> > >
> > > Sorry for the delay, I was on vacation.
> > > Thanks for working on this.
> >
> > Hi Igor!
> > Very welcome! And yes, I was starting to wonder... but I'm now glad
> > that you didn't review them before you got back. These patches are no
> > reason to ruin a perfectly good vacation. :)
> >
> > > I'm adding here Dmitrii, to help me review the patches.
> > > Dmitrii, here is a full series:
> > >
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.kern=
el.
> > > org_project_netdevbpf_cover_20220418231746.2464800-2D1-2Dgrundler-40
> > > ch
> > > romium.org_&d=3DDwIFaQ&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DAliKLBUTg9lFc5s=
IMTzJ
> > > t8
> > > MdPiAgKbsC8IpLIHmdX9w&m=3D1LeNSCJMgZ7UkGBm56FcvL_Oza8VOX45LEtQf31qPE2=
K
> > > LQ
> > > cr5Q36aMIUR2DzLhi7&s=3DfVFxLPRO8K2DYFpGUOggf38nbDFaHKg8aATsjB1TuB0&e=
=3D
> > >
> > > Grant, I've reviewed and also quite OK with patches 1-4.
> >
> > Excellent! \o/
> >
> >
> > > For patch 5 - why do you think we need these extra comparisons with s=
oftware head/tail?
> >
> > The ChromeOS security team (CC'd) believes the driver needs to verify "=
expected behavior". In other words, the driver expects the device to provid=
e new values of tail index which are between [tail,head) ("available to fil=
l").
> >
> > Your question makes me chuckle because I asked exactly the same questio=
n. :D Everyone agrees it is a minimum requirement to verify the index was "=
in bounds". And I agree it's prudent to verify the device is "well behaved"=
 where we can. I haven't looked at the code enough to know what could go wr=
ong if, for example, the tail index is decremented instead of incremented o=
r a "next fragment" index falls in the "available to fill" range.
> >
> > However, I didn't run the fuzzer and, for now, I'm taking the ChromeOS =
security team's word that this check is needed. If you (or Dmitrii) feel st=
rongly the driver can handle malicious or firmware bugs in other ways, I'm =
not offended if you decline this patch. However, I would be curious what th=
ose other mechanisms are.
> >
> > > From what I see in logic, only the size limiting check is enough ther=
e..
> > >
> > > Other extra checks are tricky and non intuitive..
> >
> > Yes, somewhat tricky in the code but conceptually simple: For the RX bu=
ffer ring, IIUC, [head,tail) is "CPU to process" and [tail, head) is "avail=
able to fill". New tail values should always be in the latter range.
> >
> > The trickiness comes in because this is a ring buffer and [tail, head) =
it is equally likely that head =3D< tail  or head > tail numerically.
> >
> > If you like, feel free to add comments explaining the ring behavior or =
ask me to add such a comment (and repost #5). I'm a big fan of documenting =
non-intuitive things in the code. That way the next person to look at the c=
ode can verify the code and the IO device do what the comment claims.
> >
> > On the RX buffer ring, I'm also wondering if there is a race condition =
such that the driver uses stale values of the tail pointer when walking the=
 RX fragment lists and validating index values. Aashay assures me this race=
 condition is not possible and I am convinced this is true for the TX buffe=
r ring where the driver is the "producer"
> > (tells the device what is in the TX ring). I still have to review the R=
X buffer handling code more and will continue the conversation with him unt=
il we agree.
> >
> > cheers,
> > grant
> >
> > >
> > > Regards,
> > >   Igor
> > >
> > > On 4/21/2022 9:53 PM, Grant Grundler wrote:
> > > > External Email
> > > >
> > > > ------------------------------------------------------------------
> > > > --
> > > > --
> > > > Igor,
> > > > Will you have a chance to comment on this in the near future?
> > > > Should someone else review/integrate these patches?
> > > >
> > > > I'm asking since I've seen no comments in the past three days.
> > > >
> > > > cheers,
> > > > grant
> > > >
> > > >
> > > > On Mon, Apr 18, 2022 at 4:17 PM Grant Grundler
> > > > <grundler@chromium.org>
> > > > wrote:
> > > >>
> > > >> The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic
> > > >> driver in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
> > > >> Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
> > > >>
> > > >> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__docs.google=
.
> > > >> co
> > > >> m_document_d_e_2PACX-2D1vT4oCGNhhy-5FAuUqpu6NGnW0N9HF-5Fjxf2kS7ra
> > > >> Op
> > > >> OlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK_pub&d=3DDwIBaQ&c=3DnKjWec=
2b6
> > > >> R0
> > > >> mOyPaz7xtfQ&r=3D3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=3DQo=
xR8
> > > >> Wo
> > > >> QQ-hpWu_tThQydP3-6zkRWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=3D620j=
q
> > > >> eS vQrGg6aotI35cWwQpjaL94s7TFeFh2cYSyvA&e=3D
> > > >>
> > > >> It essentially describes four problems:
> > > >> 1) validate rxd_wb->next_desc_ptr before populating buff->next
> > > >> 2) "frag[0] not initialized" case in aq_ring_rx_clean()
> > > >> 3) limit iterations handling fragments in aq_ring_rx_clean()
> > > >> 4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()
> > > >>
> > > >> I've added one "clean up" contribution:
> > > >>     "net: atlantic: reduce scope of is_rsc_complete"
> > > >>
> > > >> I tested the "original" patches using chromeos-v5.4 kernel branch:
> > > >>
> > > >> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__chromium-2D=
r
> > > >> ev
> > > >> iew.googlesource.com_q_hashtag-3Apcinet-2Datlantic-2D2022q1-2B-28
> > > >> st
> > > >> atus-3Aopen-2520OR-2520status-3Amerged-29&d=3DDwIBaQ&c=3DnKjWec2b6=
R0m
> > > >> Oy
> > > >> Paz7xtfQ&r=3D3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=3DQoxR8=
WoQ
> > > >> Q-
> > > >> hpWu_tThQydP3-6zkRWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=3D1a1YwJq=
r
> > > >> Y- be2oDgGAG5oOyZDnqIok_2p5G-N8djo2I&e=3D
> > > >>
> > > >> The fuzzing team will retest using the chromeos-v5.4 patches and
> > > >> the b0 HW.
> > > >>
> > > >> I've forward ported those patches to 5.18-rc2 and compiled them
> > > >> but am currently unable to test them on 5.18-rc2 kernel (logistics=
 problems).
> > > >>
> > > >> I'm confident in all but the last patch:
> > > >>    "net: atlantic: verify hw_head_ is reasonable"
> > > >>
> > > >> Please verify I'm not confusing how ring->sw_head and
> > > >> ring->sw_tail are used in hw_atl_b0_hw_ring_tx_head_update().
> > > >>
> > > >> Credit largely goes to Chrome OS Fuzzing team members:
> > > >>     Aashay Shringarpure, Yi Chou, Shervin Oloumi
> > > >>
> > > >> cheers,
> > > >> grant
