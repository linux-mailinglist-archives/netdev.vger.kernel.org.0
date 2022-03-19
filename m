Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4684DE90F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbiCSPdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243492AbiCSPdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:33:04 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13B52571BE;
        Sat, 19 Mar 2022 08:31:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bi12so22227673ejb.3;
        Sat, 19 Mar 2022 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fnKN6n4NiW6NRvmL/chWan4dYjQ9Cywizwet4+MazNI=;
        b=ZkyXacelojXl/U6Yy6q1CLI+wwnf3BFWG0oUYNlmlb7wmlJSAs7llguZ1KYdnO8wbU
         IcRO3n8UVr5Fw07JCqsRXv/bc9817NqNOppfW5hGANJTTtgXHm21ocF1LErAHtrNmOLo
         i6BPGwVa/WvIJGXdIqI0dhqjIiBwztKv5d8JgfBox6gNV9TCANLom6JxbzFbfmSYJhvS
         JtGOepoA8V9peMRzicMac6mc74TgDja2OFZbkdBjdZDg9YLAx6C3ABzSK3WgAMaJjeeV
         wxSfsjbvXwe7GXDKhlDQ3q8FHZ/tXQzhNG4puSGXxJrNyAZHELSUKk7/s7D2EAh4jYxb
         UgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fnKN6n4NiW6NRvmL/chWan4dYjQ9Cywizwet4+MazNI=;
        b=6zZUHLTWxucYxmI7KaC8FU8i0fyq1J760EXJwRA07Cipx7p5KRz3o66KrSMiDgZbAG
         nmqum7+m2yUz+SUwJRzQuMtP7YR0FhAqruaO5c3Zj6A2T1BcrKFmiwk+M82CNSHGeWVl
         ODg5ambvhQjda98rmhDkWzHRT1JWLLWAHmb+hQTj5SXECUtUIclrnG1dLBRgJEYwaG33
         /YsBHfustUA/nfAyBaGf6qTVOCp+PqlpDUtHph2y4kj0XokElWBJxe5HDRUWsD4Fz/Wu
         /lKwWCi7l1YVUIR0xvQ/y8MPKJZUFJczn0spZOfewfKsnSmq+aD07CzMscdWlT8+zxTa
         Kkfw==
X-Gm-Message-State: AOAM5338gMML90zP68xu09IH6KZg5GAqSZet+AgIWqc7gmWef2sjBbrf
        bdF9XaBNbCL7b0OaYLboXar3Xv8Ny1iZ5LwfK3Q=
X-Google-Smtp-Source: ABdhPJzQJzvenTokvq0oHajZ9jvqPHzswvfEwpj+/R3c4hYr7mdFo86DeDpwZmp4N6Q+lpd5ha36dPLFIk0jTw0DpSg=
X-Received: by 2002:a17:906:f857:b0:6df:ae2d:73a0 with SMTP id
 ks23-20020a170906f85700b006dfae2d73a0mr9031382ejb.614.1647703901270; Sat, 19
 Mar 2022 08:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220319110422.8261-1-zhouzhouyi@gmail.com> <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
 <CAABZP2yK2vCJcReJ_VvcqbkuEekvBpBJCyZ2geG=f83fv_RC=Q@mail.gmail.com> <CADVnQy=shHKbvf4OZjX5-3CnFPOm3zyexbaH9XTLZBMk6pxeew@mail.gmail.com>
In-Reply-To: <CADVnQy=shHKbvf4OZjX5-3CnFPOm3zyexbaH9XTLZBMk6pxeew@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 19 Mar 2022 23:31:30 +0800
Message-ID: <CAABZP2we5YyL=Z0rk7vVry76OjgQ+YaMu1y8xCU6Cf7VnJ9JCg@mail.gmail.com>
Subject: Re: [PATCH v2] net:ipv4: send an ack when seg.ack > snd.nxt
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wei Xu <xuweihf@ustc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank Neil and Eric for your valuable advice!

I will do the test and analysis. Please forgive my hasty reply because
it will take me some time to fully understand the email.  Also please
give me about a month to accomplish the test and analysis.
On Sat, Mar 19, 2022 at 9:57 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Sat, Mar 19, 2022 at 7:34 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> >
> > Thanks for reviewing my patch
> >
> > On Sat, Mar 19, 2022 at 7:14 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Sat, Mar 19, 2022 at 4:04 AM <zhouzhouyi@gmail.com> wrote:
> > > >
> > > > From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > >
> > > > In RFC 793, page 72: "If the ACK acks something not yet sent
> > > > (SEG.ACK > SND.NXT) then send an ACK, drop the segment,
> > > > and return."
> > > >
> > > > Fix Linux's behavior according to RFC 793.
> > > >
> > > > Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > > Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > > Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > ---
> > > > Thank Florian Westphal for pointing out
> > > > the potential duplicated ack bug in patch version 1.
> > >
> > > I am travelling this week, but I think your patch is not necessary and
> > > might actually be bad.
> > >
> > > Please provide more details of why nobody complained of this until today.
> > >
> > > Also I doubt you actually fully tested this patch, sending a V2 30
> > > minutes after V1.
> > >
> > > If yes, please provide a packetdrill test.
> > I am a beginner to TCP, although I have submitted once a patch to
> > netdev in 2013 (aaa0c23cb90141309f5076ba5e3bfbd39544b985), this is
> > first time I learned packetdrill test.
> > I think I should do the packetdrill test in the coming days, and
> > provide more details of how this (RFC793 related) can happen.
>
> In addition to a packetdrill test and a more detailed analysis of how
> this can happen, and the implications, I think there are at least a
> few other issues that need to be considered:
>
> (1) AFAICT, adding an unconditional ACK if (after(ack, tp->snd_nxt))
> seems to open the potential for attackers to cause DoS attacks with
> something like the following:
>
>  (a) attacker injects one data packet in the A->B direction and one
> data packet in the B->A direction
>
>  (b) endpoint A sends an ACK for the forged data sent to it, which
> will have an ACK beyond B's snd_nxt
>
>  (c) endpoint B sends an ACK for the forged data sent to it, which
> will have an ACK beyond A's snd_nxt
>
>  (d) endpoint B receives the ACK sent by A, causing B to send another
> ACK beyond A's snd_nxt
>
>  (e) endpoint A receives the ACK sent by B, causing A to send another
> ACK beyond B's snd_nxt
>
>  (f) repeat (d) and (e) ad infinitum
I will make a full understanding of the above scenery in the coming days.
>
> So AFAICT an attacker could send two data packets with 1 byte of data
> and cause the two endpoints to use up an unbounded amount of CPU and
> bandwidth sending ACKs in an "infinite loop".
>
> To avoid this "infinite loop" of packets, if we really need to add an
> ACK in this case then the code should use the tcp_oow_rate_limited()
> helper to ensure that such ACKs are rate-limited. For more context on
> tcp_oow_rate_limited(), see:
>
> f06535c599354 Merge branch 'tcp_ack_loops'
> 4fb17a6091674 tcp: mitigate ACK loops for connections as tcp_timewait_sock
> f2b2c582e8242 tcp: mitigate ACK loops for connections as tcp_sock
> a9b2c06dbef48 tcp: mitigate ACK loops for connections as tcp_request_sock
> 032ee4236954e tcp: helpers to mitigate ACK loops by rate-limiting
> out-of-window dupacks
>
> Note that f06535c599354 in particular mentions the case discussed in this patch:
>
>     (2) RFC 793 (section 3.9, page 72) says: "If the ACK acknowledges
>         something not yet sent (SEG.ACK > SND.NXT) then send an ACK".
>
> (2) Please consider the potential that adding a new ACK in this
> scenario may introduce new, unanticipated side channels. For more on
> side channels, see:
>
>   https://lwn.net/Articles/696868/
>   The TCP "challenge ACK" side channel
I will read the article in the days following.
>
>   Principled Unearthing of TCP Side Channel Vulnerabilities
>   https://dl.acm.org/doi/10.1145/3319535.3354250
I will read the paper too.
>
> best regards,
> neal
Best Regards
Zhouyi
