Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74C5551DE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376950AbiFVRDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376402AbiFVRD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:03:27 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475653466F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:03:25 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3185f5623edso9058397b3.1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OwKNJdEq2fSuT6c6/krJqcgyCdnVK9ItawtXpFRBFlw=;
        b=X8R0nCGYt4xCP/TPEs2XC7WfnU+y3rxCP0kcWE2gHcT/OHmnv8ss11MKBNhnCCurrj
         vtvXZJhHlDT1oTt6nZgmuyN/pwg6B8BYRg7Gag6i12oUp7sqeezN+ILgXGfi3bGmXWhl
         982rpk+Yy73ekHr95pdroJBr25jow78QjIi5YKjOAzddn67CYeuKBgzmlRXJu+C3/sg8
         YziAyKnXXJbvIAhitG+EPziQuFcuOVwxwn/xHJre+nsqqrL+hR8ig6cPjXNVspUFsnuS
         DpWO/rp2s0lDFdYCsYoDUYdLcW2IGq5ymO8HFhZVAztm3ZlPNe+T7Y1d+KVnQOrIWHpL
         8mCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OwKNJdEq2fSuT6c6/krJqcgyCdnVK9ItawtXpFRBFlw=;
        b=i923UoxPCi73ktIKWkwrlIcNstE77/4E7sGWjEMtUTMMBFjhaJacRLrBUJehAIKeDu
         6+M19/AG95ARBU38gj5xdV8uGrzppprSwCVWjaHrYH6pSAdyswEbD+3FysIv0gOkwsoG
         5hqrKWAsIp5E9vFGBP9s4H8Mq/3pA0NSNMGsyPcP4+BDD95vlVeGO8HdDF0dn4BAVHhU
         ZDL9vhHjJ7emsHYtPA4zJCKot/DDnjTNEsT+QIMLI2nHNmgrYfklLomYa3X7FW8M+lZI
         MmfyGqnwATOCa5uE/4B2cPCYgHBVmuYS9K44kpgcn+Atfu+nPv86ywbz+dMSKjFGhrtr
         WNbA==
X-Gm-Message-State: AJIora+NT1GfDw38gX8af0Zp1I68wIfRPfWdiRcimZm+FOFjLkByCpr7
        Rs0Ny9kwX0MHZyTdX+exMwLuGATwIuez3bhtaMawVA==
X-Google-Smtp-Source: AGRyM1uNvctPZSp5w0EB0RQnU4eubNzv48h+uIxYf6OemUbClVymTmdnQxEIXF6eIqrmitc51Fi6IKApiyC4HNxxC5s=
X-Received: by 2002:a81:3a81:0:b0:317:7dcf:81d4 with SMTP id
 h123-20020a813a81000000b003177dcf81d4mr5404335ywa.47.1655917403918; Wed, 22
 Jun 2022 10:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org> <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc> <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
 <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org> <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
 <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org> <CANn89iJ=Xc57pdZ-NaRF7FXZnq2skh5MJ3aDtDCGp8RNG4oowA@mail.gmail.com>
 <CANn89i+yy3mL2BUT=uhhkACVviWXCA9fdE1mrG=ZMuSQKdK8SQ@mail.gmail.com> <CANn89iLVHAE5aMwo0dow14mdFK0JjokE9y5KV+67AxKJdSjx=w@mail.gmail.com>
In-Reply-To: <CANn89iLVHAE5aMwo0dow14mdFK0JjokE9y5KV+67AxKJdSjx=w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 19:03:12 +0200
Message-ID: <CANn89i+5pWbXyFBnMqdfz6SqRV9enFNHbcd_2irJub1Ag7vxNw@mail.gmail.com>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 6:47 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jun 22, 2022 at 6:39 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 6:29 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Wed, Jun 22, 2022 at 4:26 PM Ilya Maximets <i.maximets@ovn.org> wrote:
> > > >
> > > > On 6/22/22 13:43, Eric Dumazet wrote:
> > >
> > > >
> > > > I tested the patch below and it seems to fix the issue seen
> > > > with OVS testsuite.  Though it's not obvious for me why this
> > > > happens.  Can you explain a bit more?
> > >
> > > Anyway, I am not sure we can call nf_reset_ct(skb) that early.
> > >
> > > git log seems to say that xfrm check needs to be done before
> > > nf_reset_ct(skb), I have no idea why.
> >
> > Additional remark: In IPv6 side, xfrm6_policy_check() _is_ called
> > after nf_reset_ct(skb)
> >
> > Steffen, do you have some comments ?
> >
> > Some context:
> > commit b59c270104f03960069596722fea70340579244d
> > Author: Patrick McHardy <kaber@trash.net>
> > Date:   Fri Jan 6 23:06:10 2006 -0800
> >
> >     [NETFILTER]: Keep conntrack reference until IPsec policy checks are done
> >
> >     Keep the conntrack reference until policy checks have been performed for
> >     IPsec NAT support. The reference needs to be dropped before a packet is
> >     queued to avoid having the conntrack module unloadable.
> >
> >     Signed-off-by: Patrick McHardy <kaber@trash.net>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
>
> Oh well... __xfrm_policy_check() has :
>
> nf_nat_decode_session(skb, &fl, family);
>
> This  answers my questions.
>
> This means we are probably missing at least one XFRM check in TCP
> stack in some cases.
> (Only after adding this XFRM check we can call nf_reset_ct(skb))
>

Maybe this will help ?

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32ca4a35d05166d471327bc608fa91..49c1348e40b6c7b6a98b54d716f29c948e00ba33
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2019,12 +2019,19 @@ int tcp_v4_rcv(struct sk_buff *skb)
                if (nsk == sk) {
                        reqsk_put(req);
                        tcp_v4_restore_cb(skb);
-               } else if (tcp_child_process(sk, nsk, skb)) {
-                       tcp_v4_send_reset(nsk, skb);
-                       goto discard_and_relse;
                } else {
-                       sock_put(sk);
-                       return 0;
+                       if (!xfrm4_policy_check(nsk, XFRM_POLICY_IN, skb)) {
+                               drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+                               goto discard_and_relse;
+                       }
+                       nf_reset_ct(skb);
+                       if (tcp_child_process(sk, nsk, skb)) {
+                               tcp_v4_send_reset(nsk, skb);
+                               goto discard_and_relse;
+                       } else {
+                               sock_put(sk);
+                               return 0;
+                       }
                }
        }
