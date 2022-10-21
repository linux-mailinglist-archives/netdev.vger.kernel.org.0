Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704CE606DFD
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 04:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJUCsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 22:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJUCst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 22:48:49 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A751A2E36
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 19:48:48 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3690482f5dfso11381747b3.6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 19:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuAEp0R7NKnDVyZQrXqYg+LnR4jeiFwa9q5tPjIGnG0=;
        b=Gf1Qu4DZkWWVGVXhJjtEv4zrPk7RzIgVC/qyytSuTpn1qSIZNDhrXeDDWbqDAIV+MR
         i0MQ/njLS1cldGMe7Ago4n2/dvBAxDY2a8HOwfIMV7Q+sH408RDkSEEv/B0RUSEppdWK
         3/JvZfQlghx1NjXQpDK4hnwuMkjRjVf1C9iYyMKAWdbz/QKwboph0sl1KXzgagVbbDxD
         968ietnZDnbN63JXCfVOVyEtuNt8d5cou6x/b/je3D1egAObedYWIAxpSISyEEb6Iv0w
         uFL39GDxeokIblfqdMkZq9MtO45nN04Z1vx3w7/20TE54QlGGK0nRc5/kVX9LcJvHYZl
         k5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuAEp0R7NKnDVyZQrXqYg+LnR4jeiFwa9q5tPjIGnG0=;
        b=CVmJK8MG3nHZ29IWlTxTR5AiiV+d0x9Hazl9aEiDnaDZKnCpYzGs8vtJAC2fbmJEgF
         TjV+WmA4gc7qE3X9TJhGEUEsUdbS/J7pBQ26z4O7eK3O4cq5KO2XrJvNmD/jQDOOx7/p
         ja8KWGlNPLgcRRYstywaojMwS7WPy+LiwP84ucUJVD0HvxRlSzD8Ohr3Xxt9ZOUzrGNd
         xfHFlgH5MUduxWO8Y0rneZoXebCtXhNxJU2+3JOx+Gb4Q5EGJh9ifPKkjtB7yzgBwqUq
         +LWbmlhXuT6YEOXBQFklsXtcwb67MOwzuonxcQbflcg3uTyaorrIaTdVkn8hDEL3mvUU
         73hQ==
X-Gm-Message-State: ACrzQf2962XS8YXjYIbYinCHg/cC9FL6LTWPDFH4pFmWbG5KiRgN8EX6
        iuvaxuoAD9Ydx/+fTDBUw1nWxSK4tzYrODjyjZcyWQ==
X-Google-Smtp-Source: AMsMyM6n8hWG7MOOiHPumyxMeXIVrrdWn9ymfRtRb+N8hLDQaxMS2Jkd1sU1BzxlZVWshGqh0TNAOOfCfsk/EP5BQzQ=
X-Received: by 2002:a81:9a4f:0:b0:367:fbf9:b9f1 with SMTP id
 r76-20020a819a4f000000b00367fbf9b9f1mr7473866ywg.55.1666320527874; Thu, 20
 Oct 2022 19:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
 <20221020182242.503107-2-kamaljit.singh1@wdc.com> <CANn89iKaEqkcOooXY0EpnBScNXY1HhwwgeZuivQYmN4jxLUcJA@mail.gmail.com>
 <29e89051d65ae93dc5515c59f56bed4e2e5d8e9f.camel@wdc.com>
In-Reply-To: <29e89051d65ae93dc5515c59f56bed4e2e5d8e9f.camel@wdc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 19:48:36 -0700
Message-ID: <CANn89iLNVU9AokwswAKvxqRZSRqJEZCeYz1OjspJyBSn9bK+Yw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] tcp: Fix for stale host ACK when tgt window shrunk
To:     Kamaljit Singh <Kamaljit.Singh1@wdc.com>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Oct 20, 2022 at 6:01 PM Kamaljit Singh <Kamaljit.Singh1@wdc.com> wr=
ote:
>
> On Thu, 2022-10-20 at 13:45 -0700, Eric Dumazet wrote:
> > CAUTION: This email originated from outside of Western Digital. Do not =
click
> > on links or open attachments unless you recognize the sender and know t=
hat the
> > content is safe.
> >
> >
> > On Thu, Oct 20, 2022 at 11:22 AM Kamaljit Singh <kamaljit.singh1@wdc.co=
m>
> > wrote:
> > > Under certain congestion conditions, an NVMe/TCP target may be config=
ured
> > > to shrink the TCP window in an effort to slow the sender down prior t=
o
> > > issuing a more drastic L2 pause or PFC indication.  Although the TCP
> > > standard discourages implementations from shrinking the TCP window, i=
t also
> > > states that TCP implementations must be robust to this occurring. The
> > > current Linux TCP layer (in conjunction with the NVMe/TCP host driver=
) has
> > > an issue when the TCP window is shrunk by a target, which causes ACK =
frames
> > > to be transmitted with a =E2=80=9Cstale=E2=80=9D SEQ_NUM or for data =
frames to be
> > > retransmitted by the host.
> >
> > Linux sends ACK packets, with a legal SEQ number.
> >
> > The issue is the receiver of such packets, right ?
> Not exactly. In certain conditions the ACK pkt being sent by the NVMe/TCP
> initiator has an incorrect SEQ-NUM.
>
> I've attached a .pcapng Network trace for Wireshark. This captures a smal=
l
> snippet of 4K Writes from 10.10.11.151 to a target at 10.10.11.12 (using =
fio).
> As you see pkt #2 shows a SEQ-NUM 4097, which is repeated in ACK pkt #12 =
from
> the initiator. This happens right after the target closes the TCP window =
(pkts
> #7, #8). Pkt #12 should've used a SEQ-NUM of 13033 in continuation from p=
kt #11.
>
> This patch addresses the above scenario (tp->snd_wnd=3D0) and returns the=
 correct
> SEQ-NUM that is based on tp->snd_nxt. Without this patch the last else pa=
th was
> returning tcp_wnd_end(tp), which sent the stale SEQ-NUM.
>
> Initiator Environment:
> - NVMe-oF Initiator: drivers/nvme/host/tcp.c
> - NIC driver: mlx5_core (Mellanox, 100G), IP addr 10.10.11.151
> - Ubuntu 20.04 LTS, Kernel 5.19.0-rc7 (with above patches 1 & 2 only)
>
>
> >
> > Because as you said receivers should be relaxed about this, especially
> > if _they_ decided
> > to not respect the TCP standards.
> >
> > You are proposing to send old ACK, that might be dropped by other stack=
s.
> On the contrary, I'm proposing to use the expected/correct ACK based on t=
p-
> >snd_nxt.

Please take a look at the very lengthy comment at the front of the function=
.

Basically we are in a mode where a value needs to be chosen, and we do
not really know which one
will be accepted by the buggy peer.

You are changing something that has been there forever, risking
breaking many other stacks, and/or middleboxes.

It seems the remote TCP stack is quite buggy, I do not think we want
to change something which has never been an issue until today in 2022.

Also not that packet #13, sent immediately after the ACK is carrying
whatever needed values.
I do not see why the prior packet (#12) would matter.

Please elaborate.



>
>
> >
> > It has been observed that processing of these
> > > =E2=80=9Cstale=E2=80=9D ACKs or data retransmissions impacts NVMe/TCP=
 Write IOPs
> > > performance.
> > >
> > > Network traffic analysis revealed that SEQ-NUM being used by the host=
 to
> > > ACK the frame that resized the TCP window had an older SEQ-NUM and no=
t a
> > > value corresponding to the next SEQ-NUM expected on that connection.
> > >
> > > In such a case, the kernel was using the seq number calculated by
> > > tcp_wnd_end() as per the code segment below. Since, in this case
> > > tp->snd_wnd=3D0, tcp_wnd_end(tp) returns tp->snd_una, which is incorr=
ect for
> > > the scenario.  The correct seq number that needs to be returned is
> > > tp->snd_nxt. This fix seems to have fixed the stale SEQ-NUM issue alo=
ng
> > > with its performance impact.
> > >
> > >   1271 static inline u32 tcp_wnd_end(const struct tcp_sock *tp)
> > >   1272 {
> > >   1273   return tp->snd_una + tp->snd_wnd;
> > >   1274 }
> > >
> > > Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
> > > ---
> > >  net/ipv4/tcp_output.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index 11aa0ab10bba..322e061edb72 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -100,6 +100,9 @@ static inline __u32 tcp_acceptable_seq(const stru=
ct sock
> > > *sk)
> > >             (tp->rx_opt.wscale_ok &&
> > >              ((tp->snd_nxt - tcp_wnd_end(tp)) < (1 << tp-
> > > >rx_opt.rcv_wscale))))
> > >                 return tp->snd_nxt;
> > > +       else if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
> > > +                !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RE=
CV)))
> > > +               return tp->snd_nxt;
> > >         else
> > >                 return tcp_wnd_end(tp);
> > >  }
> > > --
> > > 2.25.1
> > >
> --
> Thanks,
> Kamaljit Singh <kamaljit.singh1@wdc.com>
