Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED8B120CB
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEBRDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 13:03:36 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:42365 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEBRDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 13:03:35 -0400
Received: by mail-io1-f47.google.com with SMTP id c24so2742315iom.9;
        Thu, 02 May 2019 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUiMncgAwtaWZCSEj/35h4lgUlhcfQV0foFT/AHquDY=;
        b=DyXXNWeD7vh/snUyFgfiILnsJ4fdLsazUl9wToiOVlna2UuoQRo6FctvgvRYNHF7sX
         r0bf64Fug3CV5QUm9+Yu4iedlhFkVCJ1JgS7rnMAxQVpG51U1aQm1eACsF8k475Hq5te
         CiH3r+pGqeBB89r0UKwAJQfkyarzLQodbQtkJd7yuGz8/z9ZfNIK82EQ6iFa/S7KwxdD
         OOLVyhiAINbg/TnzTRs+EMJT7FrxHC/d/UPV29JxH/Fs7eSWIcsKluK/JUDDGqPGUbq6
         7l4YZXYCFc+ecUT6t21u/7+VEbtGnt17NWVFJtTXIiVVPhRp1zpaQxt1i7X1H89atnhN
         WjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUiMncgAwtaWZCSEj/35h4lgUlhcfQV0foFT/AHquDY=;
        b=m79Ldgf7Xm1NsQh1gsX4hmQ0XxPqjswhnHxCCAzivOiIZnaR/hJ/8lZuJXHazkiqlN
         HMKgZc0eCai8k93DSoHTiXrHyJh3lgT/0uoYHdPCOoUW5cr8jN1OhXgiqGDga10hk2sP
         NNwhbSHTyL78715fvz/uQtrxLTuCnr1NtHb+GfTiCM3qjeIRCuZqASLRrzjcLXC8lDoP
         wqtPwDbOIQkqqaAoB8Qy3WUAXDWdAP2zr9CLrBDDMtyx3vhzwfpRd1U5jPTExqzk46+i
         63B9sUL86p7+tQMoWwf5w9hLwzQ/o3m5HOpZLS0RoSw5WKGApy5ysVISy/1RlY4U5RK7
         4ETA==
X-Gm-Message-State: APjAAAVM68X4sKrkOtZ+AFgJYHh4u8rDChfrfU2oCvoB0HXB0wwScJv6
        9G53c3P84AUJlHkYEoeatnoT3+mDnSkaM475P910gvaz
X-Google-Smtp-Source: APXvYqyJOGqY1Zb1AUWAAc4tgreWZxWaR2i9c+3SX2R1SOEyGhJM6QEWw8PlJGcHP/t79OcrfNl9Yl7UrzED3KE103E=
X-Received: by 2002:a6b:93d7:: with SMTP id v206mr1747447iod.200.1556816614363;
 Thu, 02 May 2019 10:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
 <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com> <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca>
In-Reply-To: <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 May 2019 10:03:23 -0700
Message-ID: <CAKgT0Uc_OUAcPfRe6yCSwpYXCXomOXKG2Yvy9c1_1RJn-7Cb5g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 8:11 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Wed, May 01, 2019 at 03:52:57PM -0700, Alexander Duyck wrote:
> > I'm not sure how RSS will do much for you here. Basically you only
> > have the source IP address as your only source of entropy when it
> > comes to RSS since the destination IP should always be the same if you
> > are performing a server role and terminating packets on the local
> > system and as far as the ports in your example you seem to only be
> > using 4500 for both the source and the destination.
>
> I have thousands of IPsec clients connecting.  Simply treating them as
> normal UDP packets would work.  The IP address is different, and often
> the port too.

Thanks for the clarification. I just wanted to verify that I know we
have had similar complaints in the past and it turns out those were
only using one set of IP addresses.

> > In your testing are you only looking at a point to point connection
> > between two systems, or do you have multiple systems accessing the
> > system you are testing? I ask as the only way this should do any
> > traffic spreading via RSS would be if the source IPs are different and
> > that would require multiple client systems accessing the server.
>
> I tried changing the client IP address and the RSS hash key.  It never
> changed to another queue.  Something is broken.

Okay, so if changing the RSS hash key has not effect then it is likely
not being used.

> > In the case of other encapsulation types over UDP, such as VXLAN, I
> > know that a hash value is stored in the UDP source port location
> > instead of the true source port number. This allows the RSS hashing to
> > occur on this extra information which would allow for a greater
> > diversity in hash results. Depending on how you are generating the ESP
> > encapsulation you might look at seeing if it would be possible to have
> > a hash on the inner data used as the UDP source port in the outgoing
> > packets. This would help to resolve this sort of issue.
>
> Well it works on every other network card except this one.  Every other
> intel card in the past we have used had no problem doing this right.

The question is what is different about this card, and I don't have an
immediate answer so we would need to do some investigation.

> You want all the packets for a given ipsec tunnel to go to the same queue.
> That is not a problem here.  What you don't want is every ipsec packet
> from everyone going to the same queue (always queue 0).  So simply
> treating them as UDP packets with a source and destination IP and port
> would work perfectly fine.  The X722 isn't doing that.  It is always
> assigning a hash value of 0 to these packets.

You had stated in your earlier email that "Other UDP packets are
fine". Perhaps we need to do some further isolation to identify why
the ESP over UDP packets are not being hashed on while other UDP
packets are.

Would it be possible to provide a couple of raw Ethernet frames
instead of IP packets for us to examine? I noticed the two packets you
sent earlier didn't start until the IP header. One possibility would
be that if we had any extra outer headers or trailers added to the
packet that could possibly cause issues since that might either make
the packet not parsable or possibly flag it as some sort of length
error when the size of the packet doesn't match what is reported in
the headers.

One other thing we may want to look at doing is trying to identify the
particular part of the packets that might be causing the hash to not
be generated. One way to do that would be to use something like
netperf to generate packets and send them toward your test system.
Something like the command line below could be used to send packets
that should be similar to the ones you provided earlier:
     netperf -H <target IP> -t UDP_STREAM -N -- -P 4500,4500 -m 132

If the packets generated by netperf were not hashed that would tell us
then it may be some sort of issue with how UDP packets are being
parsed, and from there we could narrow things down by modifying port
numbers and changing packet sizes. If that does get hashed then we
need to start looking outside of the IP/UDP header parsing for
possible issues since there is likely something else causing the
issue.

Thanks.

- Alex
