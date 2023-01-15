Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A542966B344
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjAORn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjAORn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:43:27 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEC9C17E
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:43:27 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 203so27907685yby.10
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GAM3HYWSTLTnCy31OkAcTBJEmYkTqwqGKKfF0/Vv6Yk=;
        b=UmPtoWqq8ACAqNhMAV7nmYqW182qZi8V/fZKfKuUkC0Sr0qG6VfA0YMUM6Gtf1zA/K
         /0dbiVpyTvzf46RhCMt06EdstVtycJEQzXLU6/ajccb4rHHt/Lp4R7CJkBMLTMvuMLR0
         gGZ/nPb7NWqDAhwX1CV2TKyTFcHzpfk8WgsgL149Bq3umdqPYbT729FEBf1T3jBMmHMo
         iMn4DdmhZjl9+KCEErITEU/1yThcmgYxPQh0jbqoKl9m9ybRRtTy+wJwDEYpobN/zYhA
         fG40qi7lbWs/hgxAkidORLpXA1BSfXMBeoeqgUXEKVIB5RAzkYTHqOXNsYzF94FjEniG
         OElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAM3HYWSTLTnCy31OkAcTBJEmYkTqwqGKKfF0/Vv6Yk=;
        b=7Iqt2X+1S6kuWQkGApcIyLq7ACn4nTGkX6/kT8TY2npFEgg25xFTNQWuuy9Rp/kaQ1
         ayyigSA7dxpHBQoIRPuPlSjnv8SDDBEizuGmUNnUsLAxgWqVkSB+24OWbMaFgYfzAgcm
         P8fFkRJegdAOtWMRLrkuuimHMicVIcwEFHZHU4Mcej6xXkaBAPRTv7KOTtQrzBxRUj6g
         4fLrcvNWq/aSxydTUp5fvLo2wZ83CuPzvemofAjBdqD2SuGMSDuifsvWZJa/XAe9HDTG
         FYJYJRpM6OgXF6ykPQfcF3mVGOEeF/zcyQBzYkYpkPKMWnk4B2pGKyPOGmRo8KirJ6WN
         PNjg==
X-Gm-Message-State: AFqh2ko4CVYnZxnF0zXHsxz7PF46D/3n2Lb9jkt3cVyVipth2o9l1JfT
        NixILmORtx9hHVC1ZL+BgE2nW7gg86/OBQ5cihg=
X-Google-Smtp-Source: AMrXdXsxw5FriAcFneMIAzGDNum9+5zKNC71ijjEIZK/E5iJmEm5HihnWwnz2P8XjdLZMuiLlYKslcokwlCNQ3PEows=
X-Received: by 2002:a25:8b04:0:b0:7b9:d00b:5892 with SMTP id
 i4-20020a258b04000000b007b9d00b5892mr3402400ybl.470.1673804606178; Sun, 15
 Jan 2023 09:43:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
In-Reply-To: <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 15 Jan 2023 12:42:07 -0500
Message-ID: <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/13/23 8:31 PM, Xin Long wrote:
> > For IPv6 jumbogram packets, the packet size is bigger than 65535,
> > it's not right to get it from payload_len and save it to an u16
> > variable.
> >
> > This patch only fixes it for IPv6 BIG TCP packets, so instead of
> > parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
> > gets the pktlen via 'skb->len - skb_network_offset(skb)' when
> > skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
> > BIG TCP packets.
> >
> > This fix will also help us add selftest for IPv6 BIG TCP in the
> > following patch.
> >
>
> If this is a bug fix for the existing IPv6 support, send it outside of
> this set for -net.
>
Sure,
I was thinking of adding it here to be able to support selftest for
IPv6 too in the next patch. But it seems to make more sense to
get it into -net first, then add this selftest after it goes to net-next.

I will post it and all other fixes I mentioned in the cover-letter for
IPv6 BIG TCP for -net.

But before that, I hope Eric can confirm it is okay to read the length
of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
instead of parsing JUMBO exthdr?

Thanks.
