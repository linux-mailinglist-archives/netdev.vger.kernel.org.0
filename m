Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF4866B3B1
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 20:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjAOTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 14:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjAOTkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 14:40:51 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1979A9EE6
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 11:40:51 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 9so10679229ybn.6
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 11:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+cnb8j3p0GzGlhdrut3sD5sn5bq6Za8uxXpAkyZQOCc=;
        b=IR+rLmNGKvY1JeUC8gn5oFokYo0VQYRmmuYmkQidXFVsn9fv+sp+yk5lKfLPyd0Q+S
         NHiRXVi4q3iBukH21c4JlgShSWHwp8dXnD3VQhPot9dLh6szov55qUx23xzmlw4tANa4
         b9ePRfcOx6nadvF+xeqPeYYmUj6KKFVJwm1U3m6K3WeXr1h9UlWbYyt0xskXUEer9Ex6
         bKgR82I+dF7ojdgcup8YLwzzRf2Nl5MSH4XWnHt0oBlIz0Vw8ERAIy04P3Hi0uobZAVy
         7VDepxsBrLXo727PLNlsNw42AkqceUkTRcDSppXOTVp00Z9LcamFM9sDDGCqEbVvwcEO
         WaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+cnb8j3p0GzGlhdrut3sD5sn5bq6Za8uxXpAkyZQOCc=;
        b=vfQJUMfx/jojFqswtqoI2MsIe9t2XW7aVwLiJIw/N0cpSWhOtN5EU+LVMRVJRCVzkm
         1a+WhKKZJptGG0sdgbhncWjD8xNEdOha4McbdWsRrkKQ4lfOsqi4Sr76TwR8y3voUf+m
         HJK6GcaajX43mrdhCee89I0wz6iluZEF8/derJGLYkJPivlsBhP6OicPRMdKt3ngUfY7
         LghIP0usFB3/xKaTMTqsRp/KqKs7ukgBidgFOZZQqwxBzzXPcIzRpc/1NCBNdpfbHUOu
         OWkWZqMPj3gM6PktW7yuzhtoDP61KO5lVL+vKZTBChawqEexbx8hkrptBFKmlRKnufpl
         4I4Q==
X-Gm-Message-State: AFqh2kqrrXOBSSwk5+FyuDvQcS2tHd0WWHvTgRho8O0+cPZPljLBv/rT
        n29gAY2x19mEH07eER3dHs+blhMK2awgMe69lXlJ3A==
X-Google-Smtp-Source: AMrXdXt5+fhVHhmkYeXRsbo0MiLCOyqHqAs66UwR1YoydHZh3Ullv2OqcWnaq7jMIwf8Vph2LNKfhUPc9nRKFQgt+Jc=
X-Received: by 2002:a25:fc03:0:b0:7e3:553a:11fb with SMTP id
 v3-20020a25fc03000000b007e3553a11fbmr65568ybd.387.1673811650050; Sun, 15 Jan
 2023 11:40:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
In-Reply-To: <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 15 Jan 2023 20:40:38 +0100
Message-ID: <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 6:43 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 1/13/23 8:31 PM, Xin Long wrote:
> > > For IPv6 jumbogram packets, the packet size is bigger than 65535,
> > > it's not right to get it from payload_len and save it to an u16
> > > variable.
> > >
> > > This patch only fixes it for IPv6 BIG TCP packets, so instead of
> > > parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
> > > gets the pktlen via 'skb->len - skb_network_offset(skb)' when
> > > skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
> > > BIG TCP packets.
> > >
> > > This fix will also help us add selftest for IPv6 BIG TCP in the
> > > following patch.
> > >
> >
> > If this is a bug fix for the existing IPv6 support, send it outside of
> > this set for -net.
> >
> Sure,
> I was thinking of adding it here to be able to support selftest for
> IPv6 too in the next patch. But it seems to make more sense to
> get it into -net first, then add this selftest after it goes to net-next.
>
> I will post it and all other fixes I mentioned in the cover-letter for
> IPv6 BIG TCP for -net.
>
> But before that, I hope Eric can confirm it is okay to read the length
> of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
> instead of parsing JUMBO exthdr?
>

I do not think it is ok, but I will leave the question to netfilter maintainers.

Guessing things in tcpdump or other tools is up to user space implementations,
trying to work around some (kernel ?) deficiencies.

Yes, IPv6 extensions headers are a pain, we all agree.

Look at how ip6_rcv_core() properly dissects extension headers _and_ trim
skb accordingly (pskb_trim_rcsum() called either from ip6_rcv_core()
or ipv6_hop_jumbo())

So skb->len is not the root of trust. Some transport mediums might add paddings.

Ipv4 has a similar logic in ip_rcv_core().

len = ntohs(iph->tot_len);
if (skb->len < len) {
     drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
     __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
    goto drop;
} else if (len < (iph->ihl*4))
     goto inhdr_error;

/* Our transport medium may have padded the buffer out. Now we know it
* is IP we can trim to the true length of the frame.
* Note this now means skb->len holds ntohs(iph->tot_len).
*/
if (pskb_trim_rcsum(skb, len)) {
      __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
      goto drop;
}

After your changes, we might accept illegal packets that were properly
dropped before.
