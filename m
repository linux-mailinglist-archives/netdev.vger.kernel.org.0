Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8118866BA36
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjAPJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjAPJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:24:50 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F6E4ECA
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:24:49 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e202so6176922ybh.11
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xgt2GZb/L9Q/1cremGAMsSBPxxgcNhI+hptxQbTP/pc=;
        b=qzcgb9z8Cma8SN4oMGdvQpTNpuMOKvr7JoQWdiZTnM2lbIPKye169cmwYWFF7MXJPO
         /wQptEo63+HnIqIOOYL+RNk7LplLC0vNtbH2aZrEeRGTCyN1pWeU7e05VFpugob2INDw
         z4cWf37ff6EWcImwJYgOL2ZNnz/RCUBC3zqbJUqNgY+clY4QlK+c5AOodi7DZBdFjCy7
         9fldlvXza/Wwaz6byKIg+u1NOvYiYxCbNlWO4bn2Bf5CudMT5K7HUDQVlPnnT2I4Wwae
         ZdjmtPBNbDWcmzRecAEIbdylo8Xd9nrKQaLJt/LbgMMGJQ4dml4YcghcBdM0P3VXfo4O
         Yz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xgt2GZb/L9Q/1cremGAMsSBPxxgcNhI+hptxQbTP/pc=;
        b=XMdV4IrbME357ptls2evVt/RTSBolEnV/belN+NbiMKiPlCCw3kEdFjD76+knAsc5H
         W1h0kbackvF5Hurb6Fwb8ZHqlFEP6G88oCG9vfys/rEKxohq8forH37faPFc4sBOtv/J
         NozB1/f06oPhK+kRwU6JJNcyCnJo5qNt6UPEgUmcyioy1EHExMU3bd1CVZh/CsVII8P/
         hjLt61ox6hYjpUt99TSlV400A4lSB6i+R/HjZABVu+ifNINrvx0fk0jhe66nQyIYbPVc
         pDsctqnKS1xP/oxX+znJZiE3sFP2uoq8jd1EB2YXja/Kg1baGJB3gPYh8LI7KxeZTCdi
         EWyg==
X-Gm-Message-State: AFqh2kreepxqfgpROZP/sIOl8keV2JMkEUXAToPbPqO1+fIwZsicX6nZ
        DM1pXck2TrupvoXceybNr/RAq37Z7DGNsIFXZ2gCcQ==
X-Google-Smtp-Source: AMrXdXsfqghz9e8iLz0g01oSjdiKEGCh1RUvAeFpg12oTV3daMaofK7k4X4ZgngeIMz1NY5WDtm7ycTZKhXWrgxoBDo=
X-Received: by 2002:a25:b7cb:0:b0:7e7:7ad8:2ee8 with SMTP id
 u11-20020a25b7cb000000b007e77ad82ee8mr112931ybj.55.1673861088536; Mon, 16 Jan
 2023 01:24:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com> <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
In-Reply-To: <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 10:24:37 +0100
Message-ID: <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
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

On Sun, Jan 15, 2023 at 9:15 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sun, Jan 15, 2023 at 2:40 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sun, Jan 15, 2023 at 6:43 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
> > > >
> > > > On 1/13/23 8:31 PM, Xin Long wrote:
> > > > > For IPv6 jumbogram packets, the packet size is bigger than 65535,
> > > > > it's not right to get it from payload_len and save it to an u16
> > > > > variable.
> > > > >
> > > > > This patch only fixes it for IPv6 BIG TCP packets, so instead of
> > > > > parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
> > > > > gets the pktlen via 'skb->len - skb_network_offset(skb)' when
> > > > > skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
> > > > > BIG TCP packets.
> > > > >
> > > > > This fix will also help us add selftest for IPv6 BIG TCP in the
> > > > > following patch.
> > > > >
> > > >
> > > > If this is a bug fix for the existing IPv6 support, send it outside of
> > > > this set for -net.
> > > >
> > > Sure,
> > > I was thinking of adding it here to be able to support selftest for
> > > IPv6 too in the next patch. But it seems to make more sense to
> > > get it into -net first, then add this selftest after it goes to net-next.
> > >
> > > I will post it and all other fixes I mentioned in the cover-letter for
> > > IPv6 BIG TCP for -net.
> > >
> > > But before that, I hope Eric can confirm it is okay to read the length
> > > of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
> > > instead of parsing JUMBO exthdr?
> > >
> >
> > I do not think it is ok, but I will leave the question to netfilter maintainers.
> Just note that the issue doesn't only exist in netfilter.
> All the changes in Patch 2-7 from this patchset are also needed for IPv6
> BIG TCP packets.
>
> >
> > Guessing things in tcpdump or other tools is up to user space implementations,
> > trying to work around some (kernel ?) deficiencies.
> >
> > Yes, IPv6 extensions headers are a pain, we all agree.
> >
> > Look at how ip6_rcv_core() properly dissects extension headers _and_ trim
> > skb accordingly (pskb_trim_rcsum() called either from ip6_rcv_core()
> > or ipv6_hop_jumbo())
> >
> > So skb->len is not the root of trust. Some transport mediums might add paddings.
> >
> > Ipv4 has a similar logic in ip_rcv_core().
> >
> > len = ntohs(iph->tot_len);
> > if (skb->len < len) {
> >      drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
> >      __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
> >     goto drop;
> > } else if (len < (iph->ihl*4))
> >      goto inhdr_error;
> >
> > /* Our transport medium may have padded the buffer out. Now we know it
> > * is IP we can trim to the true length of the frame.
> > * Note this now means skb->len holds ntohs(iph->tot_len).
> > */
> > if (pskb_trim_rcsum(skb, len)) {
> >       __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
> >       goto drop;
> > }
> >
> > After your changes, we might accept illegal packets that were properly
> > dropped before.
> I think skb->len is trustable for GSO/GRO packets.
> In ipv6_gro_complete/inet_gro_complete():
> The new length for payload_len or iph->tot_len are all calculated from skb->len.
> As I said in the cover-letter, "there is no padding in GSO/GRO packets".
> Or am I missing something?

This seems to be a contract violation with user space providing GSO packets.

In our changes we added some sanity checks, inherent to JUMBO specs.

Here, a GSO packet can now have a zero ip length, no matter if it is
BIG TCP or not.

It seems we lower the bar for consistency, and allow bugs (say
changing skb->len) to not be detected.

As you said, user space sniffing packets now have to guess what is the
intent, instead of headers carrying all the needed information
that can be fully validated by parsers.
