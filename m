Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96154130401
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgADT1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:27:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33765 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADT1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:27:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so9126163wmd.0
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 11:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lT22MG6hwWy8g9ld6WYWb7s9sZUK8MzkXW5ASUgCToo=;
        b=ob1ycBFkltl76lgyUf9a7ZcKq978K1shmbXvTeNlXxmxnYKX9e6yLO4tBRLNPX6Ld8
         RaQD0h5AUP+nAW0EjXSMv8b6ySGZjhDqrdWXptiZMDOTPicrHdVvcJi/kZZBUjOldoXy
         xXiONzIXSRFosxeobZcel2pcxuJEw5NyBDCxCW9BF0ITznnDmdqwFS7c138CAkVl5zqr
         V5/uEinCCvZ4Tz8XAappNPIL1y4bFGBdCjhpFF09Xva+oOCVsw/p3ogqCRctm3mOSCa+
         q5hTED2GXyNw0d5++lFqiAkAL8rNUeL9+2th+BfgspToe3OiplnwAshK5aBXAK1uEn6E
         YhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lT22MG6hwWy8g9ld6WYWb7s9sZUK8MzkXW5ASUgCToo=;
        b=ssTjBI2yWfJEBs452HPV8yykm3yEVDb1VQvi5WOjdtFsQg3OY18OEulQgFPVwsb7q1
         CFeRHwkG8Y3uJoFL8VnZWGG3SLC77f2A9bMA6bL57ec496p+TR190a369qkYQq4Wpugy
         hz8JhdDBg1HWw+ZA+CliQUTmE/z8ad909jiNx4RA4rYbtSYaf9ht4dwnPxWYeySS93wK
         e7Ced8iVLnlqrMYtq4aqR+ScrOSltj+nenPOAQ5CDlXhcXfuHEpK9VGFBrKdYUS9EMEF
         xt/44c5SGjGrxr0TJAO6R6HP5FIqT0GMbyzthL/NTcjThUZoaOUNQd/0W+YQBQ0NxNVw
         xNxQ==
X-Gm-Message-State: APjAAAUZ0Bj2wZW+f6TEjQ5DorDQaaD812ns2FU3N/YAczCzC++059Tk
        7OIvw2RKUw64YTTwrdtZWw0=
X-Google-Smtp-Source: APXvYqw4sI6U2Ot2yWVMmVkAuxjeSfeArGxKbe/US+d3PpXJJyJOu1BzMMASaYgkjUuctuk3Z0d5dA==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr26030599wmc.47.1578166032859;
        Sat, 04 Jan 2020 11:27:12 -0800 (PST)
Received: from ahabdels-m-j3jg.lan (ppp-94-64-192-96.home.otenet.gr. [94.64.192.96])
        by smtp.gmail.com with ESMTPSA id z8sm64297438wrq.22.2020.01.04.11.27.11
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sat, 04 Jan 2020 11:27:12 -0800 (PST)
Date:   Sat, 4 Jan 2020 21:27:11 +0200
From:   kernel Dev <ahabdels.dev@gmail.com>
To:     kernel Dev <ahabdels.dev@gmail.com>
Cc:     Tom Herbert <tom@herbertland.com>, Erik Kline <ek@loon.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Message-Id: <20200104212711.2067d0c5b20b55ca9f3f421e@gmail.com>
In-Reply-To: <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
        <20200103.124517.1721098411789807467.davem@davemloft.net>
        <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
        <20200103.145739.1949735492303739713.davem@davemloft.net>
        <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
        <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
        <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
        <20200104100556.43a28151003a1f379daec40c@gmail.com>
        <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
        <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry forgot to add the link for the public SRv6 deployment. 
https://tools.ietf.org/html/draft-matsushima-spring-srv6-deployment-status-04

On Sat, 4 Jan 2020 21:02:29 +0200
kernel Dev <ahabdels.dev@gmail.com> wrote:

> Hi Tom, 
> 
> I wasn’t accusing anyone in my message. It is a personal opinion. 
> If my message was misunderstood, then please accept my apologies. 
> 
> Also SRv6 is not highly controversial and this is proven by its adoption rate and ecosystem.
> I have never seen a highly controversial technology that has (in two years) at least 8 public deployments and is supported by 18 publicly known routing platforms from 8 different vendors. Also has support in the mainline of Linux kernel, FD.io VPP, Wireshark, tcpdump, iptables and nftables.
> 
> If you are a network operator, would you deply a highly controversial technology in your network ? 
> 
> 
> On Sat, 4 Jan 2020 09:45:59 -0800
> Tom Herbert <tom@herbertland.com> wrote:
> 
> > On Sat, Jan 4, 2020 at 12:05 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
> > >
> > > Tom,
> > >
> > > I will not go into whether Tom or router vendors is right from IETF perspective as here is not the place to discuss.
> > >
> > > But it seems to me that the motivation behind these patches is just to pushback on the current IETF proposals.
> > >
> > Sorry, but that is completely untrue. The patches are a general
> > improvement. The ability to allow modules to register handlers for
> > options code points has nothing to do with "pushback on the current
> > IETF protocols". This sort of registration is a mechanism used all
> > over the place. Similarly, allowing non-priveledged users to send
> > options is not for any specific protocol-- it is a *general*
> > mechanism.
> > 
> > > The patches timeline is completely aligned with when IETF threads get into tough discussions (May 2019, August 2019, and now).
> > >
> > Yes, discussion about new protocols in IETF tends to correlate with
> > development and implementation of the protocols. That shouldn't
> > surprise anyone. SRv6 for instance was highly controversial in IETF
> > and yet the patches went in.
> > 
> > > I’m not the one to decide, but IMO people should not add stuff to the kernel just to enforce their opinions on other mailers.
> > 
> > I take exception with your insinuation. Seeing as how you might be new
> > to Linux kernel development I will ignore it. But, in the future, I
> > strongly suggest you be careful about accusing people about their
> > motivations based solely on one interaction.
> > 
> > Tom
> > 
> > 
> > >
> > >
> > > On Fri, 3 Jan 2020 16:37:33 -0800
> > > Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > > On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> > > > >
> > > > > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> > > > > >
> > > > > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> > > > > > >
> > > > > > > From: Tom Herbert <tom@herbertland.com>
> > > > > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > > > > >
> > > > > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > > > > > > >>
> > > > > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > > > > >>
> > > > > > > >> > The real way to combat this provide open implementation that
> > > > > > > >> > demonstrates the correct use of the protocols and show that's more
> > > > > > > >> > extensible and secure than these "hacks".
> > > > > > > >>
> > > > > > > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > > > > > > >
> > > > > > > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > > > > > > These are prime examples where we've steered the Internet from host
> > > > > > > > protocols and implementation to successfully obsolete or at least work
> > > > > > > > around protocol ossification that was perpetuated by router vendors.
> > > > > > > > Cisco is not the Internet!
> > > > > > >
> > > > > > > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> > > > > > >
> > > > > > Dave,
> > > > > >
> > > > > > I agree we can't stop it, but maybe we can steer it to be at least
> > > > > > palatable. There are valid use cases for extension header insertion.
> > > > > > Ironically, SRv6 header insertion isn't one of them; the proponents
> > > > > > have failed to offer even a single reason why the alternative of IPv6
> > > > > > encapsulation isn't sufficient (believe me, we've asked _many_ times
> > > > > > for some justification and only get hand waving!). There are, however,
> > > > > > some interesting uses cases like in IOAM where the operator would like
> > > > > > to annotate packets as they traverse the network. Encapsulation is
> > > > > > insufficient if they don't know what the end point would be or they
> > > > > > don't want the annotation to change the path the packets take (versus
> > > > > > those that aren't annotated).
> > > > > >
> > > > > > The salient problem with extension header insertion is lost of
> > > > >
> > > > > And the problems that can be introduced by changing the effective path MTU...
> > > > >
> > > > Eric,
> > > >
> > > > Yep, increasing the size of packet in transit potentially wreaks havoc
> > > > on PMTU discovery, however I personally think that the issue might be
> > > > overblown. We already have the same problem when tunneling is done in
> > > > the network since most tunneling implementations and deployments just
> > > > assume the operator has set large enough MTUs. As long as all the
> > > > overhead inserted into the packet doesn't reduce the end host PMTU
> > > > below 1280, PMTU discovery and probably even PTB for a packet with
> > > > inserted headers still has right effect.
> > > >
> > > > > > attribution. It is fundamental in the IP protocol that the contents of
> > > > > > a packet are attributed to the source host identified by the source
> > > > > > address. If some intermediate node inserts an extension header that
> > > > > > subsequently breaks the packet downstream then there is no obvious way
> > > > > > to debug this. If an ICMP message is sent because of the receiving
> > > > > > data, then receiving host can't do much with it; it's not the source
> > > > > > of the data in error and nothing in the packet tells who the culprit
> > > > > > is. The Cisco guys have at least conceded one point on SRv6 insertion
> > > > > > due to pushback on this, their latest draft only does SRv6 insertion
> > > > > > on packets that have already been encapsulated in IPIP on ingress into
> > > > > > the domain. This is intended to at least restrict the modified packets
> > > > > > to a controlled domain (I'm note sure if any implementations enforce
> > > > > > this though). My proposal is to require an "attribution" HBH option
> > > > > > that would clearly identify inserted data put in a packet by
> > > > > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> > > > > > allow extension header insertion, but require protocol to give
> > > > > > attribution and make it at least somewhat robust and manageable.
> > > > > >
> > > > > > Tom
> > > > >
> > > > > FWIW the SRv6 header insertion stuff is still under discussion in
> > > > > spring wg (last I knew).  I proposed one option that could be used to
> > > >
> > > > It's also under discussion in 6man.
> > > >
> > > > > avoid insertion (allow for extra scratch space
> > > > > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
> > > > > but nothing has been conclusively resolved last I checked.
> > > > >
> > > >
> > > > I saw your proposal. It's a good idea from POV to be conformant with
> > > > RFC8200 and avoid the PMTU problems, but the header insertion
> > > > proponents aren't going to like it at all. First, it means that the
> > > > source is in control of the insertion policy and host is required to
> > > > change-- no way they'll buy into that ;-). Secondly, if the scratch
> > > > space isn't used they'll undoubtedly claim that is unnecessary
> > > > overhead.
> > > >
> > > > Tom
> > > >
> > > > > As everyone probably knows, the draft-ietf-* documents are
> > > > > working-group-adopted documents (though final publication is never
> > > > > guaranteed).  My current reading of 6man tea leaves is that neither
> > > > > "ICMP limits" and "MTU option" docs were terribly contentious.
> > > > > Whether code reorg is important for implementing these I'm not
> > > > > competent enough to say.
> > >
> > >
> > > --
> 
> 
> -- 
> kernel Dev <ahabdels.dev@gmail.com>


-- 
kernel Dev <ahabdels.dev@gmail.com>
