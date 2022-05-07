Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2A51E2F7
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445105AbiEGBXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiEGBXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:23:08 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596D170905;
        Fri,  6 May 2022 18:19:22 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dk23so17312237ejb.8;
        Fri, 06 May 2022 18:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjYemBJVf/8eHgTpdeD1HlEfsjJ2ImsEgMWeX/08V/4=;
        b=Ut042dC2Uk3TMhsaP1W5Vy/WhTYksFTVlIyPc3nFf4geBOarVMu1OOCed/8cGmGlK7
         Tarz0Z24qFXW+WoloLhFJ0SKPVpaV1EgAk3xnNNXrjkXe8tV5RCzffjLpDn9CXCUYNcQ
         tCM4q/4kPycklETke8vMrIw7QHzUkhOFh0pZBLCI9rpdhL1L7jT0jiIKVbc+7HqcdwRq
         LevPg6RlBeWpvf8obUSLrJ3USakJ53r1I5ypepqq3xcypPZzIzbE+W4+ynOKH3NC5HBh
         YAqmFfoKbEq4gxFDEhFf0Mnj2vB4/UMMjFy8DRPjJq1au0yEm7GUP7eQnTAw2g+geI7O
         1oFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjYemBJVf/8eHgTpdeD1HlEfsjJ2ImsEgMWeX/08V/4=;
        b=CgpAAZQepz8YEZpUSBeA+ZSrY8oFkreal9w1CRLG6EgTTDES1n27G2Fq7INmoTGfqg
         WFqPiDNZK9UWVckzvkhTTRfDZGy97CoLftrl69SIZB4/hEC3yHYRu4f9NkXczP4TY4yq
         KS3u+Pd8F+uVsFAnKeDWGBEjUcHU7k38Gm5Z66bvY7PUzgLEn0lA3DieaPEUiAEiH7NA
         wVqSgNZpYDQNYF4iR6CApluwvQdSVexyLuaQqEw0e260xdzAsryy8Lsx9AunTu2zZ6AH
         fHUFRroUtk4VYk2vJtJJcht93xFN52JK36BQKcXICxv2SPY5flw5CzgLTiVPJU+VUZOE
         bpsA==
X-Gm-Message-State: AOAM5316eoaY4F4s16jPc+Up4jksXgrgXwmK8y0YA8yQLhTdzSlRufRe
        4MeNKAas15noa0gJmlUDK3jXf2NYSmgSj4XSAQQ=
X-Google-Smtp-Source: ABdhPJwJWHtJ3f0hLJ0WosmEEZ38rtWNGUzHLFHd43oN9OVk/ZkphNmAa0vvcA9sue0370rqNsxqiUuj93Dpop+VzVg=
X-Received: by 2002:a17:907:7da6:b0:6f4:dc6f:1e32 with SMTP id
 oz38-20020a1709077da600b006f4dc6f1e32mr5359827ejc.614.1651886360724; Fri, 06
 May 2022 18:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220319110422.8261-1-zhouzhouyi@gmail.com> <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
 <CAABZP2yK2vCJcReJ_VvcqbkuEekvBpBJCyZ2geG=f83fv_RC=Q@mail.gmail.com>
 <CADVnQy=shHKbvf4OZjX5-3CnFPOm3zyexbaH9XTLZBMk6pxeew@mail.gmail.com> <CAABZP2we5YyL=Z0rk7vVry76OjgQ+YaMu1y8xCU6Cf7VnJ9JCg@mail.gmail.com>
In-Reply-To: <CAABZP2we5YyL=Z0rk7vVry76OjgQ+YaMu1y8xCU6Cf7VnJ9JCg@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 7 May 2022 09:19:09 +0800
Message-ID: <CAABZP2wGzmkAZxvg-E6_OhMFw3bsmksDbs_SLE0jc0Ex3ypPjg@mail.gmail.com>
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
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Thank you for reviewing my patch and guiding me to do the research ;-)

1. Abstract
I performed packetdrill test and security analysis of the patch. I
think we shouldn't apply my patch to the Linux kernel now because of
security challenges.

2. Introduction
RFC 793 In RFC 793, page 72: "If the ACK acks something not yet sent
(SEG.ACK > SND.NXT) then send an ACK, drop the segment, and return."
So, I tried a patch to implement the above.

3. Packetdrill test result
Before apply my patch:
http://154.220.3.115/May062022/run_all.orig.log
After apply my patch:
http://154.220.3.115/May062022/run_all.new.log

Comparing these two logs, I found the difference is caused by
a) the surplus ack from my patch: invalid_ack.pkt (ipv4-mapped-v6 ipv4 ipv6)
b) tcp busy time checking fail: tcp-info-sndbuf-limited.pkt
(ipv4-mapped-v6 ipv4 ipv6)
c) packet time error: close-remote-fin-then-close.pkt (ipv6)

I conclude that the patch does not introduce a serious problem to the
TCP stack from packetdrill's point of view.

4. Possible infinite loop introduced by packet injection
(a) attacker injects one data packet in the A->B direction and one
data packet in the B->A direction

(b) endpoint A sends an ACK for the forged data sent to it, which
will have an ACK beyond B's snd_nxt

(c) endpoint B sends an ACK for the forged data sent to it, which
will have an ACK beyond A's snd_nxt

(d) endpoint B receives the ACK sent by A, causing B to send another
ACK beyond A's snd_nxt

(e) endpoint A receives the ACK sent by B, causing A to send another
ACK beyond B's snd_nxt

(f) repeat (d) and (e) ad infinitum

If we apply the patch, nothing can stop this infinite loop, we can
only limit the rate of new ack.

To note that, off path attack can achieve above attack by means of TCP
off path exploits [1] [2]

5. Possible new, unanticipated side channels
To mitigate the infinite loop in section 4, we should limit the rate
of the ack. Limiting the rate of global ack has the potential of
introducing new, unanticipated side channels.

6. Conclusion
I think we shouldn't apply my patch to the Linux kernel now because of
security challenges.


[1] "Off-Path TCP Exploits: Global Rate Limit Considered Dangerous"
https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/cao
[2] "Principled Unearthing of TCP Side Channel Vulnerabilities"
https://dl.acm.org/doi/10.1145/3319535.3354250

Thanks
Zhouyi

On Sat, Mar 19, 2022 at 11:31 PM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
> Thank Neil and Eric for your valuable advice!
>
> I will do the test and analysis. Please forgive my hasty reply because
> it will take me some time to fully understand the email.  Also please
> give me about a month to accomplish the test and analysis.
> On Sat, Mar 19, 2022 at 9:57 PM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Sat, Mar 19, 2022 at 7:34 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > >
> > > Thanks for reviewing my patch
> > >
> > > On Sat, Mar 19, 2022 at 7:14 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Sat, Mar 19, 2022 at 4:04 AM <zhouzhouyi@gmail.com> wrote:
> > > > >
> > > > > From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > >
> > > > > In RFC 793, page 72: "If the ACK acks something not yet sent
> > > > > (SEG.ACK > SND.NXT) then send an ACK, drop the segment,
> > > > > and return."
> > > > >
> > > > > Fix Linux's behavior according to RFC 793.
> > > > >
> > > > > Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > > > Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > > > Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > > ---
> > > > > Thank Florian Westphal for pointing out
> > > > > the potential duplicated ack bug in patch version 1.
> > > >
> > > > I am travelling this week, but I think your patch is not necessary and
> > > > might actually be bad.
> > > >
> > > > Please provide more details of why nobody complained of this until today.
> > > >
> > > > Also I doubt you actually fully tested this patch, sending a V2 30
> > > > minutes after V1.
> > > >
> > > > If yes, please provide a packetdrill test.
> > > I am a beginner to TCP, although I have submitted once a patch to
> > > netdev in 2013 (aaa0c23cb90141309f5076ba5e3bfbd39544b985), this is
> > > first time I learned packetdrill test.
> > > I think I should do the packetdrill test in the coming days, and
> > > provide more details of how this (RFC793 related) can happen.
> >
> > In addition to a packetdrill test and a more detailed analysis of how
> > this can happen, and the implications, I think there are at least a
> > few other issues that need to be considered:
> >
> > (1) AFAICT, adding an unconditional ACK if (after(ack, tp->snd_nxt))
> > seems to open the potential for attackers to cause DoS attacks with
> > something like the following:
> >
> >  (a) attacker injects one data packet in the A->B direction and one
> > data packet in the B->A direction
> >
> >  (b) endpoint A sends an ACK for the forged data sent to it, which
> > will have an ACK beyond B's snd_nxt
> >
> >  (c) endpoint B sends an ACK for the forged data sent to it, which
> > will have an ACK beyond A's snd_nxt
> >
> >  (d) endpoint B receives the ACK sent by A, causing B to send another
> > ACK beyond A's snd_nxt
> >
> >  (e) endpoint A receives the ACK sent by B, causing A to send another
> > ACK beyond B's snd_nxt
> >
> >  (f) repeat (d) and (e) ad infinitum
> I will make a full understanding of the above scenery in the coming days.
> >
> > So AFAICT an attacker could send two data packets with 1 byte of data
> > and cause the two endpoints to use up an unbounded amount of CPU and
> > bandwidth sending ACKs in an "infinite loop".
> >
> > To avoid this "infinite loop" of packets, if we really need to add an
> > ACK in this case then the code should use the tcp_oow_rate_limited()
> > helper to ensure that such ACKs are rate-limited. For more context on
> > tcp_oow_rate_limited(), see:
> >
> > f06535c599354 Merge branch 'tcp_ack_loops'
> > 4fb17a6091674 tcp: mitigate ACK loops for connections as tcp_timewait_sock
> > f2b2c582e8242 tcp: mitigate ACK loops for connections as tcp_sock
> > a9b2c06dbef48 tcp: mitigate ACK loops for connections as tcp_request_sock
> > 032ee4236954e tcp: helpers to mitigate ACK loops by rate-limiting
> > out-of-window dupacks
> >
> > Note that f06535c599354 in particular mentions the case discussed in this patch:
> >
> >     (2) RFC 793 (section 3.9, page 72) says: "If the ACK acknowledges
> >         something not yet sent (SEG.ACK > SND.NXT) then send an ACK".
> >
> > (2) Please consider the potential that adding a new ACK in this
> > scenario may introduce new, unanticipated side channels. For more on
> > side channels, see:
> >
> >   https://lwn.net/Articles/696868/
> >   The TCP "challenge ACK" side channel
> I will read the article in the days following.
> >
> >   Principled Unearthing of TCP Side Channel Vulnerabilities
> >   https://dl.acm.org/doi/10.1145/3319535.3354250
> I will read the paper too.
> >
> > best regards,
> > neal
> Best Regards
> Zhouyi
