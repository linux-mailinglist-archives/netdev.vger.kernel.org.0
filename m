Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D92D66B3C3
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 21:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjAOUP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 15:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjAOUPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 15:15:24 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4D512F15
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 12:15:23 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4c24993965eso349930037b3.12
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 12:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=msIL7ye8JhEumBK5IgkqVO0XA0SIne1UgL6aJXYamfA=;
        b=HbIL/axX8YMHhJvqDDNXH9+oWFgtsS++2hHviQU1Bp1ETUx4F67UWYzRta00KpEWs3
         0W3KbaGeOgbZaAY5BqSTNZNQsyZeR6uL5brq6LZhNylAr7EbzeYW0OF+XDp9fGNUO5id
         llCJlC9XZn/7wDq27yXe2tZAnGD1xUBwS0szjpL7eAMZAwXX4OqDpEdsj7n+lVOm+z+D
         xOFMMLWKuHSOOYF565RvT2W5pXbcfsyxH2udoP7MJmbneqRwiUZeRk3zFFexsEuJi7za
         RutxknIK2vNktGNdgqsHpUlii5i5B2iMUTu1i08UdXG81cQmVx9JotABrrOKu9ancOxp
         Cy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msIL7ye8JhEumBK5IgkqVO0XA0SIne1UgL6aJXYamfA=;
        b=ncmAHdYNndb5nZc+qPakSRR99/6CAbvzYupha5Tu+UPA6PemGSJWx/M4kubSME7yoB
         eJVORoKuSqcaFzNaDygg0PnxUIR0XdNz1DdZMtXzOB1SS8/lC+qkc80IvVvxtAj8frur
         C2yn6WL+MjPFaxY4pI50vBdFTAKPtiFMOkiBVA+OYuvxSPmKme/XyOCAr3DHvWeCLq3X
         pzCRnYSl9tWFF0IfEPGxU6jC2OJAaIOG6KPaDCArulki13LeRHqXQNXnRiAmzoYAdQSg
         PheaEDpZ+SoRZfGHwLwensvRLYOMKFd75TaLfGgPgRmTCuEeL4gsjTXSunixNJBNW58Z
         wkRA==
X-Gm-Message-State: AFqh2krAWott2nst2STuIn2ZfH9nbBuXe8mFc0tmWiYLjfAPyhyNVcqn
        DHGLyFd06Wp7DbyAMTQd/z36OA/PdFl2zI/VI5s=
X-Google-Smtp-Source: AMrXdXvn3lfYjqCjJx1ctiUf3fNl2oFbm6OFeOmD0E3G8GD8iDo7F4+NRXfxp0g6rPDP4lMYQiCR/eF/E7M8ZSfTzNc=
X-Received: by 2002:a05:690c:857:b0:38b:17c4:4297 with SMTP id
 bz23-20020a05690c085700b0038b17c44297mr4189678ywb.446.1673813722280; Sun, 15
 Jan 2023 12:15:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
In-Reply-To: <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 15 Jan 2023 15:14:03 -0500
Message-ID: <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Eric Dumazet <edumazet@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 2:40 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Jan 15, 2023 at 6:43 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 1/13/23 8:31 PM, Xin Long wrote:
> > > > For IPv6 jumbogram packets, the packet size is bigger than 65535,
> > > > it's not right to get it from payload_len and save it to an u16
> > > > variable.
> > > >
> > > > This patch only fixes it for IPv6 BIG TCP packets, so instead of
> > > > parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
> > > > gets the pktlen via 'skb->len - skb_network_offset(skb)' when
> > > > skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
> > > > BIG TCP packets.
> > > >
> > > > This fix will also help us add selftest for IPv6 BIG TCP in the
> > > > following patch.
> > > >
> > >
> > > If this is a bug fix for the existing IPv6 support, send it outside of
> > > this set for -net.
> > >
> > Sure,
> > I was thinking of adding it here to be able to support selftest for
> > IPv6 too in the next patch. But it seems to make more sense to
> > get it into -net first, then add this selftest after it goes to net-next.
> >
> > I will post it and all other fixes I mentioned in the cover-letter for
> > IPv6 BIG TCP for -net.
> >
> > But before that, I hope Eric can confirm it is okay to read the length
> > of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
> > instead of parsing JUMBO exthdr?
> >
>
> I do not think it is ok, but I will leave the question to netfilter maintainers.
Just note that the issue doesn't only exist in netfilter.
All the changes in Patch 2-7 from this patchset are also needed for IPv6
BIG TCP packets.

>
> Guessing things in tcpdump or other tools is up to user space implementations,
> trying to work around some (kernel ?) deficiencies.
>
> Yes, IPv6 extensions headers are a pain, we all agree.
>
> Look at how ip6_rcv_core() properly dissects extension headers _and_ trim
> skb accordingly (pskb_trim_rcsum() called either from ip6_rcv_core()
> or ipv6_hop_jumbo())
>
> So skb->len is not the root of trust. Some transport mediums might add paddings.
>
> Ipv4 has a similar logic in ip_rcv_core().
>
> len = ntohs(iph->tot_len);
> if (skb->len < len) {
>      drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
>      __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>     goto drop;
> } else if (len < (iph->ihl*4))
>      goto inhdr_error;
>
> /* Our transport medium may have padded the buffer out. Now we know it
> * is IP we can trim to the true length of the frame.
> * Note this now means skb->len holds ntohs(iph->tot_len).
> */
> if (pskb_trim_rcsum(skb, len)) {
>       __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
>       goto drop;
> }
>
> After your changes, we might accept illegal packets that were properly
> dropped before.
I think skb->len is trustable for GSO/GRO packets.
In ipv6_gro_complete/inet_gro_complete():
The new length for payload_len or iph->tot_len are all calculated from skb->len.
As I said in the cover-letter, "there is no padding in GSO/GRO packets".
Or am I missing something?

Thanks.
