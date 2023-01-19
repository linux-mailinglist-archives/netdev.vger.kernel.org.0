Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D75672E11
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 02:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjASB0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 20:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjASBYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 20:24:53 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F326DB37
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 17:19:29 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e202so675042ybh.11
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 17:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L4cT3REf5no17JlniuSzQI7gbk8T8WpLTS8P2F6mzoQ=;
        b=oJAp3M92fGAcFhwfFEDlsstzZ4zVBRq8vpJUBVnw/nRbQXS83jZFmfEsXe/wbvs1je
         826mvQuJz3TxT0ML13O88apJfauEgW3B1c90gizT2Hv+lMkI3c2/idKdBfu/c0PrOyjN
         miPbCm2P5OYKPdQf/SoxQqEZ9nD+wEtRVnD9tQafzHiPEu6LYaf5QIBDGb0mlgp76uJi
         yqyk34LluYhHCGvLJ2ttenj9MOU5nemu2HKv3sFMOTXEkax0yCk7FCO6vDG5jP3e2bIb
         5EhirC5bWIwsWtFDnI6gUUPPogyX3tnOYqxPel1TdwrToSfmtcFjiWG+2izX4P9AfXA9
         C4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4cT3REf5no17JlniuSzQI7gbk8T8WpLTS8P2F6mzoQ=;
        b=yUwu6KeKEG9QmD3jc0RKK1K8Zd++DGwqeaJNK02M/uyDKevYa0UJjft+aoRjYNbpP3
         DqnPasqvnd+AxPPhpJC6WDp30jzQrlt/5EEhoKN6uaZzfjwWmTfGCDBg+rCNgZEsrzqi
         djPIWjhSSU+aVyzw6f3/yy/S99VEhwMHlDFxRlnZt20/Zt3n/kiVP6Q84K36Ob+8Ld8u
         UZ71PcFB7EQX2sC1XzWz03CyWCq5JgrKIO9HuXlmvU33/mjI/YGWyhL9sN28oKiYMMGH
         KWKGFFRR3qIVBUs6YTq1c3booY4nvFgrKFCQdtDsU3RNsmUCHv1hfWMJLgOLicXNSJ14
         9jqA==
X-Gm-Message-State: AFqh2ko7mJB5gbDUR8mBlIaXNX+RDpoIH+K/S3YfAbQ4uZh2JCz6JSzg
        QgH3jH/Km7VgqbZmq2X4K0duKkwm99GapFflpLc=
X-Google-Smtp-Source: AMrXdXs05CZ47OOHksmqg4ngbR7QKafGBfxva+WhpAc5TriEwEUBb6AFVzl++cy0KWGhex1cJyigDFkasE0Z1Euehyo=
X-Received: by 2002:a05:6902:4ee:b0:7b9:d00b:5892 with SMTP id
 w14-20020a05690204ee00b007b9d00b5892mr1171790ybs.470.1674091168086; Wed, 18
 Jan 2023 17:19:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
 <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com> <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
In-Reply-To: <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 18 Jan 2023 20:18:07 -0500
Message-ID: <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
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

On Tue, Jan 17, 2023 at 10:47 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Jan 16, 2023 at 3:37 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Jan 16, 2023 at 8:10 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Mon, Jan 16, 2023 at 11:02 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Mon, Jan 16, 2023 at 4:08 PM David Ahern <dsahern@gmail.com> wrote:
> > > > >
> > > >
> > > > > not sure why you think it would not be detected. Today's model for gro
> > > > > sets tot_len based on skb->len. There is an inherent trust that the
> > > > > user's of the gro API set the length correctly. If it is not, the
> > > > > payload to userspace would ultimately be non-sense and hence detectable.
> > > >
> > > > Only if you use some kind of upper protocol adding message integrity
> > > > verification.
> > > >
> > > > > >
> > > > > > As you said, user space sniffing packets now have to guess what is the
> > > > > > intent, instead of headers carrying all the needed information
> > > > > > that can be fully validated by parsers.
> > > > >
> > > > > This is a solveable problem within the packet socket API, and the entire
> > > > > thing is opt-in. If a user's tcpdump / packet capture program is out of
> > > > > date and does not support the new API for large packets, then that user
> > > > > does not have to enable large GRO/TSO.
> > > >
> > > > I do not see this being solved yet.
> > > I think it's common that we add a feature that is disabled by
> > > default in the kernel if the userspace might not support it.
> >
> > One critical feature for us is the ability to restrict packet capture
> > to the headers only.
> >
> > Privacy is a key requirement.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e5289d5e3f98b7b5b8cac32e9e5a7004c067436
> >
> > So please make sure that packet captures truncated to headers will
> > still be understood by tcpdump
> IIUC we can try to adjust iph->tot_len to 65535 or at least the length
> of all headers for IPv4 BIG TCP packets on the PACKET socket rcv
> path? (or even truncate the ipv4 BIG TCP packets there.). This way
> tcpdump will be able to parse all the headers.
>
> But what if some applications want all the raw data via PACKET sockets?
> Maybe adjust iph->tot_len only, not truncate the packet?
>
I think that IPv6 BIG TCP has a similar problem, below is the tcpdump in
my env (RHEL-8), and it breaks too:

19:43:59.964272 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
19:43:59.964282 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
19:43:59.964292 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
19:43:59.964300 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
19:43:59.964308 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]

it doesn't show what we want from the TCP header either.

For the latest tcpdump on upstream, it can display headers well for
IPv6 BIG TCP. But we can't expect all systems to use the tcpdump
that supports HBH parsing.

For IPv4 BIG TCP, it's just a CFLAGS change to support it in "tcpdump,"
and 'tshark' even supports it by default.

I think we should NOT go with "adjust tot_len" or "truncate packets" way,
and it makes more sense to make it supported in "tcpdump" by default,
just like in "tshark". I believe commit [1] was added for some problems
they've met, we should enable it for both.

[1] https://github.com/the-tcpdump-group/tcpdump/commit/c8623960f050cb81c12b31107070021f27f14b18

Thanks.
