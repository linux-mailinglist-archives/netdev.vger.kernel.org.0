Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CCA4EF649
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349368AbiDAPcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351896AbiDAPDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:03:00 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA9324F2AB
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 07:50:23 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id v13so2282157qkv.3
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mebg0QeJQFAke9hx7Dqws17vyFhHRdF0ruAhkxiWa1M=;
        b=sYxiOPCSK6W2fCmfUF0r1cRZ5v5Z97dlJOO7EeYYiZ5wU001BIl5HTd0lZAgcIJGn2
         stul4gE6f6qnAo4Ufdrh6ezz9KC4pvSRbmeNxoC9AndIOC0yjRJgGISkDV4xe/PxPKwV
         5WOHNtezVuzSEbok8BUiREOu1IIRTqRQb61Aj3bYNICDt90DFkjPjGN+WqayhYcrSBZn
         HEwXEM76FKKSdgsiDpkQafiA5OfLQDQsVuOAAuqFJC4O3Zp14pNISEFucWG9nbIf9cqI
         FOExxw0Pl4Z7dIet1gRst74mF2uroq2H1q9e8xeFcxInQjbVXpEtazC4vgNyWSVEREPT
         fmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mebg0QeJQFAke9hx7Dqws17vyFhHRdF0ruAhkxiWa1M=;
        b=0VW4ZoBabsPSOKSXwiW7u0tFjmfLTwz4+4PVD46vpFEO8PbufbMF8NnttAUW2BcrPn
         BVqSaPckZYMAbAhCMXYlqNsxkbKTEZnchnQmwqdSXk88p7lZCBJZ6rB/NdJN8Fd/vtyS
         35SxOyi/TPcA7UBeK//6p74xZJVuhICMaQk4T4dIsCoBsiYhOn0CG0yZA/RwrStYQY5e
         yL61Vxm4vzRhLF8Ufy0o0E0AGYPF+guDPa6HR20UrGPFmxwEJcLgezKlCZ8wZRXIt/n5
         fLb2Uo7sVH8VLGAbgid29E38EQUstHzwtxdv0FqUdAz/l9optVwcuHJ2N8TKUq3jPvmx
         HRNg==
X-Gm-Message-State: AOAM531MM6XO8qBzjEfWFWy/vLLBLoLMK4j8Nz/QT0YJPiBDNCJtHNwu
        AmUya2x9jWsLpKjCClY7qmbFV9U/GCVXEaMcTITgXhPjT9x12Q==
X-Google-Smtp-Source: ABdhPJzWxpFhE6X+BpP5YPcHSooT6gqtulGJ4RS0ZEkk3jge4HuA/xUPnz0mgDmxPA84Ye94uaOinXL2Jt1AepsQ0K0=
X-Received: by 2002:a05:620a:1424:b0:67d:2bc6:856b with SMTP id
 k4-20020a05620a142400b0067d2bc6856bmr7025217qkj.434.1648824622224; Fri, 01
 Apr 2022 07:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com> <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
In-Reply-To: <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 1 Apr 2022 10:50:05 -0400
Message-ID: <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 7:06 PM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Neal,
>
> This sniff was grabbed ON THE CLIENT HOST.  There is no middlebox or
> anything between the sniffer and the client.  Only the firewall on the
> host itself, where we've already establish the traffic is NOT DISCARDED
> (at least not in filter/INPUT).

Yes, understood. Please excuse my general use of the term
"firewalls/middleboxes" even where in some contexts it's clear the
"middleboxes" aspect of that term could not apply. :-)

> Setup on our end:
>
> 2 x routers, usually each with a direct peering with Google (which is
> being ignored at the moment so instead traffic is incoming via IPT over DD).
>
> Connected via switch to
>
> 2 x firewalls, of which ONE is active (they have different networks
> behind them, and could be active / standby for different networks behind
> them - avoiding active-active because conntrackd is causing more trouble
> than it's worth), Linux hosts, using netfilter, has been operating for
> years, no recent kernel upgrades.
>
> 4 x hosts in mail cluster, one of which you're looking at here.
>
> On 2022/03/31 17:41, Neal Cardwell wrote:
> > On Wed, Mar 30, 2022 at 9:04 AM Jaco Kroon <jaco@uls.co.za> wrote:
> > ...
> >> When you state sane/normal, do you mean there is fault with the other
> >> frames that could not be explained by packet loss in one or both of the
> >> directions?
> > Yes.
> >
> > (1) If you look at the attached trace time/sequence plots (from
> > tcptrace and xplot.org) there are several behaviors that do not look
> > like normal congestive packet loss:
> OK.  I'm not 100% sure how these plots of yours work, but let's see if I
> can follow your logic here - they mostly make sense.  A legend would
> probably help.  As I understand the white dots are original transmits,
> green is what has been ACKED.  R is retransmits ... what's the S?

"S" is "SACKed", or selectively acknowledged. The SACK blocks below
the green ACK lines are DSACK blocks, for "Duplicate SACKs",
indicating the receiver has already received that sequence range.

> What's the yellow line (I'm guessing receive window as advertised by the
> server)?

Yes, the yellow line is the right edge of the receive window of the server.

> >   (a) Literally *all* original transmissions (white segments in the
> > plot) of packets after client sequence 66263 appear lost (are not
> > ACKed). Congestion generally does not behave like that. But broken
> > firewalls/middleboxes do.
> >        (See netdev-2022-03-29-tcp-disregarded-acks-zoomed-out.png )
>
> Agreed.  So could it be that something in the transit path towards
> Google is actually dropping all of that?

It could be. Or it could be a firewall/middlebox.

> As stated - I highly doubt this is on our network unless newer kernel
> (on mail cluster) is doing stuff which is causing older netfilter to
> drop perhaps?  But this doesn't explain why newer kernel retransmits
> data for which it received an ACK.

Yes, I agree that the biggest problem to focus on is the TCP code in
the kernel retransmitting data for which the NIC is receiving ACKs.

> >
> >   (b) When the client is retransmitting packets, only packets at
> > exactly snd_una are ACKed. The packets beyond that point are always
> > un-ACKed. Again sounds like a broken firewall/middlebox.
> >        (See netdev-2022-03-29-tcp-disregarded-acks-zoomed-in.png )
> No middlebox between packet sniffer and client ... client here is linux
> 5.17.1.  Brings me back to the only thing that could be dropping the
> traffic is netfilter on the host, or the kernel doesn't like something
> about the ACK, or kernel is doing something else wrong as a result of
> TFO.  I'm not sure which option I like less.  Unfortunately I also use
> netfilter for redirecting traffic into haproxy here so can't exactly
> just switch off netfilter.

Given the most problematic aspect of the trace, where the client-side
TCP connection is repeatedly retransmitting packets for which ACKs are
arriving at the NIC (and captured by tcpdump), it seems some software
in your kernel is dropping packets between the network device and the
TCP layer. Given that you mention  "the only thing that could be
dropping the traffic is netfilter on the host", it seems like the
netfilter rules or software are buggy.

A guess would be that the netfilter code is getting into a bad state
due to the TFO behavior where there is a data packet arriving from the
server immediately after the SYN/ACK and just before the client sends
its first ACK:

00:00:00.000000 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590 >
2a00:1450:4013:c16::1a.25: S 3451342529:3451342529(0) win 62580 <mss
8940,sackOK,TS val 331187616 ecr 0,nop,wscale 7,Unknown Option
3472da7bfe84[|tcp]>

00:00:00.164295 IP6 2a00:1450:4013:c16::1a.25 >
2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: S. 2699962254:2699962254(0)
ack 3451342530 win 65535 <mss 1440,sackOK,TS val 1206542770 ecr
331187616,nop,wscale 8>

# this one is perhaps confusing netfilter?:
00:00:00.001641 IP6 2a00:1450:4013:c16::1a.25 >
2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: P. 1:89(88) ack 1 win 256
<nop,nop,TS val 1206542772 ecr 331187616>

00:00:00.000035 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590 >
2a00:1450:4013:c16::1a.25: . 1:1(0) ack 89 win 489 <nop,nop,TS val
331187782 ecr 1206542772>

00:00:00.000042 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590 >
2a00:1450:4013:c16::1a.25: P. 1:24(23) ack 89 win 489 <nop,nop,TS val
331187782 ecr 1206542772>

Re "so can't exactly just switch off netfilter", are there any other
counters or logs you can somehow check for netfilter drops?

> >
> >   (c) After the client receives the server's "ack 73403", the client
> > ignores/drops all other incoming packets that show up in the trace.
>
> Agreed.  However, if I read your graph correctly, it gets an ACK for
> frame X at ~3.8s into the connection, then for X+2 at 4s, but it keeps
> retransmitting X+2, not X+1?

At t=4s, as I discussed below there are two ACKs that arrive
back-to-back, where the client TCP apparently processes the first but
not the second. That's why it keeps retransmitting the packet beyond
the first ACk but not beyond the second ACK.

>
> >
> >        As Eric notes, this doesn't look like a PAWS issue. And it
> > doesn't look like a checksum or sequence/ACK validation issue. The
> > client starts ignoring ACKs between two ACKs that have correct
> > checksums, valid ACK numbers, and valid (identical) sequence numbers
> > and TS val and ecr values (here showing absolute sequence/ACK
> > numbers):
> I'm not familiar with PAWS here.  Assuming that the green line is ACKs,
> then at around 4s we get an ACK that basically ACKs two frames in one
> (which is fine from my understanding of TCP), and then the second of
> these frames keeps getting retransmitted going forward, so it's almost
> like the kernel ACKs the *first* of these two frames but not the second.

Again, there are two ACKs, where the client TCP apparently processes
the first but not the second, as discussed here:

> >
> >     (i) The client processes this ACK and uses it to advance snd_una:
> >     17:46:49.889911 IP6 (flowlabel 0x97427, hlim 61, next-header TCP
> > (6) payload length: 32) 2a00:1450:4013:c16::1a.25 >
> > 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . cksum 0x7005 (correct)
> > 2699968514:2699968514(0) ack 3451415932 win 830 <nop,nop,TS val
> > 1206546583 ecr 331191428>
>
> >
> >     (ii) The client ignores this ACK and all later ACKs:
> >     17:46:49.889912 IP6 (flowlabel 0x97427, hlim 61, next-header TCP
> > (6) payload length: 32) 2a00:1450:4013:c16::1a.25 >
> > 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . cksum 0x6a66 (correct)
> > 2699968514:2699968514(0) ack 3451417360 win 841 <nop,nop,TS val
> > 1206546583 ecr 331191428>
> >

Here are those same two ACKs again, shown with absolute time and
relative sequence numbers, to make them easier to parse:

(i) The client processes this ACK and uses it to advance snd_una:
17:46:49.889911 IP6 2a00:1450:4013:c16::1a.25 >
2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . 6260:6260(0) ack 73403 win
830 <nop,nop,TS val 1206546583 ecr 331191428>

 (ii) The client ignores this ACK and all later ACKs:
17:46:49.889912 IP6 2a00:1450:4013:c16::1a.25 >
2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . 6260:6260(0) ack 74831 win
841 <nop,nop,TS val 1206546583 ecr 331191428>


neal
