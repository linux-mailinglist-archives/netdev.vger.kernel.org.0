Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC267931
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 10:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfGMIHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Jul 2019 04:07:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35276 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfGMIHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 04:07:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so11090717edd.2
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 01:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fZ1NhjBJeZ4cREPMFVgSDcGmpCHrLmQhZqmLuGk2m9k=;
        b=YwDtj4zQzze8MkNje0hZxEwJzQUUhVMTvfrzMcOa/K/eYtljVucOr9N1I+xRCLgzyF
         /I0nWv0V28fC6OPxrap+qfSx0RMqyAXTh1hvE/jWdBMi8DWBAGk8fpDad3WpyR9MA7ck
         7R/V4V80dn7Rr4Vu2zwUBZh3UCOmAAccqAeUSIyF6VHGIuSVs2WnZ1BLF+TrAfWahHmU
         j4JbECL+gPuVe+EplWSnDm573ortU1jQWPEQ1nGvi/OQYz3CW2lHrrKF4PmCG2BQwEL0
         SbGSj7jO7q9ropawpFCwe5ol9pnXZZHwOC4OnqLJEY/vRa21mc/gsQiqixX13XBXmCSX
         77tg==
X-Gm-Message-State: APjAAAWH8QANcqIeNKJJn71ArgZPjM2X+Jbmu278TI+CaDEAbVSpIahO
        KMv+7pxRC61If3ZK/uO4IfMGLw==
X-Google-Smtp-Source: APXvYqxA9giNN1zxkpA/7dm8w3qRkEAELBk7RxwSoD2RglwEf6vb/c/+KNubHdB7m+sLr7cNsuqULA==
X-Received: by 2002:aa7:d4cf:: with SMTP id t15mr13304085edr.215.1563005261151;
        Sat, 13 Jul 2019 01:07:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id br13sm2309873ejb.92.2019.07.13.01.07.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 01:07:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 55B0D181CE6; Sat, 13 Jul 2019 10:07:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
In-Reply-To: <20190713004011.GA24036@localhost.localdomain>
References: <20190707075828.3315-1-idosch@idosch.org> <20190707.124541.451040901050013496.davem@davemloft.net> <20190711123909.GA10978@splinter> <20190711235354.GA30396@hmswarspite.think-freely.org> <87r26vvbz8.fsf@toke.dk> <20190712121859.GB13696@hmswarspite.think-freely.org> <871ryvv3dy.fsf@toke.dk> <20190713004011.GA24036@localhost.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 13 Jul 2019 10:07:39 +0200
Message-ID: <87sgratl10.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Neil Horman <nhorman@tuxdriver.com> writes:

> On Fri, Jul 12, 2019 at 02:33:29PM +0200, Toke Høiland-Jørgensen wrote:
>> Neil Horman <nhorman@tuxdriver.com> writes:
>> 
>> > On Fri, Jul 12, 2019 at 11:27:55AM +0200, Toke Høiland-Jørgensen wrote:
>> >> Neil Horman <nhorman@tuxdriver.com> writes:
>> >> 
>> >> > On Thu, Jul 11, 2019 at 03:39:09PM +0300, Ido Schimmel wrote:
>> >> >> On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
>> >> >> > From: Ido Schimmel <idosch@idosch.org>
>> >> >> > Date: Sun,  7 Jul 2019 10:58:17 +0300
>> >> >> > 
>> >> >> > > Users have several ways to debug the kernel and understand why a packet
>> >> >> > > was dropped. For example, using "drop monitor" and "perf". Both
>> >> >> > > utilities trace kfree_skb(), which is the function called when a packet
>> >> >> > > is freed as part of a failure. The information provided by these tools
>> >> >> > > is invaluable when trying to understand the cause of a packet loss.
>> >> >> > > 
>> >> >> > > In recent years, large portions of the kernel data path were offloaded
>> >> >> > > to capable devices. Today, it is possible to perform L2 and L3
>> >> >> > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
>> >> >> > > Different TC classifiers and actions are also offloaded to capable
>> >> >> > > devices, at both ingress and egress.
>> >> >> > > 
>> >> >> > > However, when the data path is offloaded it is not possible to achieve
>> >> >> > > the same level of introspection as tools such "perf" and "drop monitor"
>> >> >> > > become irrelevant.
>> >> >> > > 
>> >> >> > > This patchset aims to solve this by allowing users to monitor packets
>> >> >> > > that the underlying device decided to drop along with relevant metadata
>> >> >> > > such as the drop reason and ingress port.
>> >> >> > 
>> >> >> > We are now going to have 5 or so ways to capture packets passing through
>> >> >> > the system, this is nonsense.
>> >> >> > 
>> >> >> > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
>> >> >> > devlink thing.
>> >> >> > 
>> >> >> > This is insanity, too many ways to do the same thing and therefore the
>> >> >> > worst possible user experience.
>> >> >> > 
>> >> >> > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
>> >> >> > XDP perf events, and these taps there too.
>> >> >> > 
>> >> >> > I mean really, think about it from the average user's perspective.  To
>> >> >> > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
>> >> >> > listen on devlink but configure a special tap thing beforehand and then
>> >> >> > if someone is using XDP I gotta setup another perf event buffer capture
>> >> >> > thing too.
>> >> >> 
>> >> >> Dave,
>> >> >> 
>> >> >> Before I start working on v2, I would like to get your feedback on the
>> >> >> high level plan. Also adding Neil who is the maintainer of drop_monitor
>> >> >> (and counterpart DropWatch tool [1]).
>> >> >> 
>> >> >> IIUC, the problem you point out is that users need to use different
>> >> >> tools to monitor packet drops based on where these drops occur
>> >> >> (SW/HW/XDP).
>> >> >> 
>> >> >> Therefore, my plan is to extend the existing drop_monitor netlink
>> >> >> channel to also cover HW drops. I will add a new message type and a new
>> >> >> multicast group for HW drops and encode in the message what is currently
>> >> >> encoded in the devlink events.
>> >> >> 
>> >> > A few things here:
>> >> > IIRC we don't announce individual hardware drops, drivers record them in
>> >> > internal structures, and they are retrieved on demand via ethtool calls, so you
>> >> > will either need to include some polling (probably not a very performant idea),
>> >> > or some sort of flagging mechanism to indicate that on the next message sent to
>> >> > user space you should go retrieve hw stats from a given interface.  I certainly
>> >> > wouldn't mind seeing this happen, but its more work than just adding a new
>> >> > netlink message.
>> >> >
>> >> > Also, regarding XDP drops, we wont see them if the xdp program is offloaded to
>> >> > hardware (you'll need your hw drop gathering mechanism for that), but for xdp
>> >> > programs run on the cpu, dropwatch should alrady catch those.  I.e. if the xdp
>> >> > program returns a DROP result for a packet being processed, the OS will call
>> >> > kfree_skb on its behalf, and dropwatch wil call that.
>> >> 
>> >> There is no skb by the time an XDP program runs, so this is not true. As
>> >> I mentioned upthread, there's a tracepoint that will get called if an
>> >> error occurs (or the program returns XDP_ABORTED), but in most cases,
>> >> XDP_DROP just means that the packet silently disappears...
>> >> 
>> > As I noted, thats only true for xdp programs that are offloaded to hardware, I
>> > was only speaking for XDP programs that run on the cpu.  For the former case, we
>> > obviously need some other mechanism to detect drops, but for cpu executed xdp
>> > programs, the OS is responsible for freeing skbs associated with programs the
>> > return XDP_DROP.
>> 
>> Ah, I think maybe you're thinking of generic XDP (also referred to as
>> skb mode)? That is a separate mode; an XDP program loaded in "native
> Yes, was I not clear about that?

No, not really. "Generic XDP" is not the same as "XDP"; the generic mode
is more of a debug mode (as far as I'm concerned at least). So in the
common case, it is absolutely not the case that the kernel will end up
calling kfree_skb after an XDP_DROP; so I got somewhat thrown off by
your insistence that it would... :)

-Toke
