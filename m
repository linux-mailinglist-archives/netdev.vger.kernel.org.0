Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36BA673F4F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjASQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjASQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:51:17 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD878088B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:51:11 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id p188so3296558yba.5
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4mRHPqEA0qk1raunEugAKDwGTPcD7KGj5Rcd2ecQAj4=;
        b=jJIDa6+UGbOUbtJHQHFfaMeIA3uYXml0jWgA3pqO1UU/NxiDcmIoCU2Q10JEorYfAf
         OFncswzYw5ZUyvsqZDfdii5hlsj6ViOHJwhracZkVlNLgIWaDTH8sl/uEYTrZ47D3oLV
         AjYzkVHrEvXvLlpHmAhQvf36MI4E0f6UhHdgCHBlKGPzvksVo2zpIUrIL59vP0kSXzPj
         5opXhNssKdqg36bDL/FA3yPkaKX7SPQBsGFqJ0zjecSSb6Px/UvlQ73ODw1AV/kqYht4
         7j5TKvR95HQTvSWF6K09Q9/NCXz9plq6WLyC6PyQWWrZKjg+leN3JqArUoIOBsIUsOkA
         rVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mRHPqEA0qk1raunEugAKDwGTPcD7KGj5Rcd2ecQAj4=;
        b=q94m6kXyPKlaoezAqC45BVkJistmQz3Vv+1UdBqUqvggMoqIAN1e7ATk85Mc+6Txkf
         cHJ5NasZ7SwkcVX2vxFc88QdDTjTRy1EyE+tceFZdrM8Rxq1j6SbcBLLafQUBe23aO92
         D++MY4Bn7upGhv3EFs0MvjUqM5JgMwRiUaYm72YzNK1kyVeQx6X7ebCxW2XSwPHroFQM
         Uem+mcspgVkpUaYEx93LEAm2WXLG2h+Y6l7i6SSJsUWtMZZAvdRw2sCDsnxUmLsgCl0t
         mWDTEpIigLxSvJMr3eSGQS4h8L3MuxopKvMbgmSwZniiir/k32sfaQ9e1DeGd41UdpM/
         h6/Q==
X-Gm-Message-State: AFqh2kqxkkp4j68NK6V1PopVeEVUb03H5SQ+7vQX56/OcSGvPbDS0Hyx
        CRkCFBwaRlsrrCAp7wvCrmpqTOH74kt2mX2IRBYwQTmodPhjLw==
X-Google-Smtp-Source: AMrXdXvIlRUuBHORc+ZdssDUqhm8Axr+UlHCrkyygNZuMjmo4gNbOc6ZnenbEO/Q+MXiQvA+Agh5nRPbsNmbW/S6N/Q=
X-Received: by 2002:a05:6902:4ee:b0:7b9:d00b:5892 with SMTP id
 w14-20020a05690204ee00b007b9d00b5892mr1468427ybs.470.1674147070209; Thu, 19
 Jan 2023 08:51:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
 <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
 <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
 <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
 <CANn89i++s3jhHqsyJT50FePT=icx3_FiYGqJNwQ73a1wt2+m+Q@mail.gmail.com> <65c32f21-ab74-5863-4d65-b87543f8aa89@gmail.com>
In-Reply-To: <65c32f21-ab74-5863-4d65-b87543f8aa89@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 19 Jan 2023 11:49:48 -0500
Message-ID: <CADvbK_dWBbcN-V19y=2_txUk2pbykrBDp1JP6dh6dC7LSQ5+jQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
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

On Thu, Jan 19, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/18/23 8:13 PM, Eric Dumazet wrote:
> > On Thu, Jan 19, 2023 at 2:19 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> >> I think that IPv6 BIG TCP has a similar problem, below is the tcpdump in
> >> my env (RHEL-8), and it breaks too:
> >>
> >> 19:43:59.964272 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> >> 19:43:59.964282 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> >> 19:43:59.964292 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> >> 19:43:59.964300 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> >> 19:43:59.964308 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> >>
> >
> > Please make sure to use a not too old tcpdump.
> >
> >> it doesn't show what we want from the TCP header either.
> >>
> >> For the latest tcpdump on upstream, it can display headers well for
> >> IPv6 BIG TCP. But we can't expect all systems to use the tcpdump
> >> that supports HBH parsing.
> >
> > User error. If an admin wants to diagnose TCP potential issues, it should use
> > a correct version.
>
> Both of those just fall under "if you want a new feature, update your
> tools."
>
>
> >
> >>
> >> For IPv4 BIG TCP, it's just a CFLAGS change to support it in "tcpdump,"
> >> and 'tshark' even supports it by default.
> >
> > Not with privacy _requirements_, where only the headers are captured.
> >
> > I am keeping a NACK, until you make sure you do not break this
> > important feature.
>
> I think the request here is to keep the snaplen in place (e.g., to make
> only headers visible to userspace) while also returning the >64kB packet
> length as meta data.
>
> My last pass on the packet socket code suggests this is possible;
> someone (Xin) needs to work through the details.
>
To be honest, I don't really like such a change in a packet socket,
I tried, and the code doesn't look nice.

I'm thinking since skb->len is trustable, why don't we use
IP_MAX_MTU(0xFFFF) as iph->tot_len for IPv4 BIG TCP?
namely, only change these 2 helpers to:

static inline unsigned int iph_totlen(const struct sk_buff *skb, const
struct iphdr *iph)
{
        u16 len = ntohs(iph->tot_len);

        return (len < IP_MAX_MTU || !skb_is_gso_tcp(skb)) ? len :
                skb->len - skb_network_offset(skb);
}

static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
{
        iph->tot_len = len < IP_MAX_MTU ? htons(len) : htons(IP_MAX_MTU);
}

What do you think?
