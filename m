Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79A622497
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 08:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiKIHXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 02:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKIHXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 02:23:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6008513D44
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 23:23:39 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so1105901pjl.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 23:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYQFZznynVQuy4d5fU1mZQKCtjVNHuRo6LwSERZKfDM=;
        b=CkG12uhYkBF9mu9Fj2LMf3m0jnoDnaj7pjFiGNrhH3op21sXmo0ru0xVjk8/GOzkV8
         CJG4rwRkkHINIfMxT+HlJctl6zlsKUrl3icX9eofag7zkLEqDYoG7zLCvynA+TCyCyv7
         /dD8ZD/rtrtlQPmO3xhTg9iEDj078kuATc1fCORys8VuBkeY90TgigJb4wX68fHBCiKp
         h1GI7MyPEO2hUd6VgW3uAwcDFtMcotY/Muc0sujYfcqSFlnElF4VtQsWIaL4/E9TjVeU
         zX/f6mRatiaEab1pKdRfM34WcVYvA0b2+HTnkIdkZVLROaLFJ74ttjFHU9t4NJ5g8Zn6
         x7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYQFZznynVQuy4d5fU1mZQKCtjVNHuRo6LwSERZKfDM=;
        b=n7PvuZYPiTNPZ6LLFYJTFd6e3hJkXmSGN7x2bqeIpAkXdDuJZd26RjQzHTd9LFJwFj
         j1N+8T8Prsr6FzuspM9QyXXGi/dVfxhyEqxwNJAg0EKPlKFIcHiuzPHqnzBDfBPv6dE5
         8+/DJVkUJE5Zc+zNmbjakxULYlxgQwR6QMF4tvKECbEA2//zpPuS0FqM8vkOUL7ImSPS
         xQxbxJaxMpci4GG0W1CAK99/vPho5BDVFz5DQ55nif5XywR24ZvLoq0RdqKriKAI9100
         KQwxPFSjCZgbV/f0kMSxwa0fUY/9axKPWA4fln5i/B/aq4xiSrcB9zMUPW2V12NAys/I
         w2ng==
X-Gm-Message-State: ACrzQf0ARiGMhNlLcB1GIDRV5V1TlDpOkflAWv8oPPi1gHYdcpFtxX/O
        Voak/APRYDq9/UUZ8niTiLZJuNqzrFqlmG/tcfZFS6D6zEY7SKod
X-Google-Smtp-Source: AMsMyM57mmesffmGeAQluKldZ1mqs9hIkxO4UCE5h3ZVzsTczkjkhnt4nP+U53jK3xZZGf3tn3k8FyHy6j+CZ3erPrI=
X-Received: by 2002:a17:90a:9dc5:b0:213:c885:bc06 with SMTP id
 x5-20020a17090a9dc500b00213c885bc06mr56307842pjv.223.1667978618774; Tue, 08
 Nov 2022 23:23:38 -0800 (PST)
MIME-Version: 1.0
References: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
 <Y1RJvsTpbC6K5I9Y@pop-os.localdomain> <CAHUXu_Vf5f8G3YkWzNQhqi2ZTjNKGu_BwkuV7SzD-Tc_fHW63g@mail.gmail.com>
 <d309d044-6e9f-e722-6d75-46b174736cc2@gmail.com>
In-Reply-To: <d309d044-6e9f-e722-6d75-46b174736cc2@gmail.com>
From:   "J.J. Mars" <mars14850@gmail.com>
Date:   Wed, 9 Nov 2022 15:22:35 +0800
Message-ID: <CAHUXu_XLRq9u+VpDFscjd--uWPPyHj5MN1oS3_tHD=SF25gsbA@mail.gmail.com>
Subject: Re: Confused about ip_summed member in sk_buff
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Edward, your reply does really help me a lot.
But I have some new questions.

Q1: From your reply, it seems the NIC is stupid or unnecessary to
detect the PROTOCOL of a packet. But on the RX side, some NIC drivers
can detect packet status from their rx desc. What's more, drivers get
some status of checksum from rx desc. Does this mean the NIC can deal
with PROTOCOL in some sense? BTW some advantage abilities like RSS may
need to detect PROTOCOL of a packet as well? I have pool knowledge
about NIC and driver so if my question is stupid or bad please forgive
me :)
Here's some rx desc status defined in e1000_hw.h:
#define E1000_RXD_STAT_UDPCS    0x10    /* UDP xsum calculated */
#define E1000_RXD_STAT_TCPCS    0x20    /* TCP xsum calculated */
#define E1000_RXD_STAT_IPCS     0x40    /* IP xsum calculated */
And in e1000_rx_checksum the driver uses the PROTOCOL status bit to
decide whether to set CHECKSUM_UNNECESSARY or not.

Q2: Seems CHECKSUM_COMPLETE contains more data checked than
CHECKSUM_UNNECESSARY. But when the stack handles the packet, like
tcp_v4_rcv->skb_checksum_init, if CHECKSUM_UNNECESSARY is set, it's
free for stack to calculate any checksum while there's still some work
when CHECKSUM_COMPLETE is set. Does it mean CHECKSUM_UNNECESSARY is
more useful to reduce the overhead for stack on certain protocols?

Best wishes.

Edward Cree <ecree.xilinx@gmail.com> =E4=BA=8E2022=E5=B9=B411=E6=9C=889=E6=
=97=A5=E5=91=A8=E4=B8=89 01:13=E5=86=99=E9=81=93=EF=BC=9A

>
> On 08/11/2022 12:32, J.J. Mars wrote:
> > Thanks for your reply. I've been busy these days so that I can't reply =
on time.
> > I've read the annotation about ip_summed in skbuff.h many times but it
> > still puzzles me so I write my questions here directly.
> >
> > First of all, I focus on the receive direction only.
> >
> > Q1: In section 'CHECKSUM_COMPLETE' it said 'The device supplied
> > checksum of the _whole_ packet as seen by netif_rx() and fills out in
> > skb->csum. Meaning, the hardware doesn't need to parse L3/L4 headers
> > to implement this.' So I assume the 'device' is a nic or something
> > like that which supplied checksum, but the 'hardware' doesn't need to
> > parse L3/L4 headers. So what's the difference between 'device' and
> > 'hardware'? Which one is the nic?
>
> Both.
> To implement this feature, the NIC is supposed to treat the packet data
>  as an unstructured array of 16-bit integers, and compute their (ones-
>  complement) sum.
> When the kernel parses the packet headers, it will subtract out from
>  this sum the headers it consumes, and then check that what's left over
>  matches the sum of the L4 pseudo header (as it should for a correctly
>  checksummed packet).
> Note that this design means protocol parsing happens only in software,
>  with the NIC completely protocol-agnostic; thus upgrades to support
>  new protocols only require a kernel upgrade and not a new NIC.
>
> > Q2: Which layer does the checksum refer in section 'CHECKSUM_COMPLETE'
> > as it said 'The device supplied checksum of the _whole_ packet'. I
> > assume it refers to both L3 and L4 checksum because of the word
> > 'whole'.
>
> See above - the device is not supposed to know or care where L3 or L4
>  headers start or where their checksum fields live, it just sums the
>  whole thing, and the kernel mathematically derives the sum of the L4
>  payload from that.
>
> > Q3: The full checksum is not calculated when 'CHECKSUM_UNNECESSARY' is
> > set. What does the word 'full' mean? Does it refer to both L3 and L4?
> > As it said 'CHECKSUM_UNNECESSARY' is set for some L4 packets, what's
> > the status of L3 checksum now? Does L3 checksum MUST be right when
> > 'CHECKSUM_UNNECESSARY' is set?
>
> 'full' here refers to the CHECKSUM_COMPLETE sum described above.
> CHECKSUM_UNNECESSARY refers to the L4 checksum, and may be set by the
>  driver when the hardware has determined that the L4 checksum is
>  correct.  This is an inferior hardware design because it can only
>  support those specific protocols the hardware understands; but we
>  handle it in the kernel because lots of hardware like that exists :(
> L3 checksums are never offloaded to hardware (neither by
>  CHECKSUM_COMPLETE nor by CHECKSUM_UNNECESSARY); because they only
>  sum over the L3 header (not its payload), they are cheap to compute
>  in software (the costly bit is actually bringing the data into cache,
>  and we have to do that anyway to parse the header, so summing it at
>  the same time is almost free).
> AFAIK a driver may set CHECKSUM_UNNECESSARY even if the L3 checksum is
>  incorrect, because it only covers the L4 sum; but I'm not 100% sure.
>
> > Q4: In section 'CHECKSUM_PARTIAL' it described status of SOME part of
> > the checksum is valid. As it said this value is set in GRO path, does
> > it refer to L4 only?
>
> Drivers should not use CHECKSUM_PARTIAL on the RX side; only on TX
>  (for which see [1] for additional documentation).
>
> > Q5: 'CHECKSUM_COMPLETE' and 'CHECKSUM_UNNECESSARY', which one supplies
> > the most complete status of checksum? I assume it's
> > CHECKSUM_UNNECESSARY.
>
> CHECKSUM_COMPLETE is preferred, as per above remarks about protocols.
>
> > Q6: The name ip_summed doesn't describe the status of L3 only but also
> > L4? Or just L4?
>
> Just L4.  It's called "ip_summed" because the "16-bit ones-complement
>  sum" style of checksum is also known as the "Internet checksum"
>  since it is used repeatedly in the Internet protocol suite, such as
>  in TCP and UDP as well as IPv4.  Yes, this is confusing, but it's
>  too late to rename it now.
>
> HTH,
> -ed
>
> [1] https://www.kernel.org/doc/html/latest/networking/checksum-offloads.h=
tml#tx-checksum-offload
