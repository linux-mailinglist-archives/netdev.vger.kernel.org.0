Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC76F72F56
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfGXM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:58:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40177 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXM64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:58:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so41567096wmj.5
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 05:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cd8m/gbJL5OksdifC0YfQ/Rss3fHMYTARWdXxXEQuIY=;
        b=PVVeBTorfpVzEuXXWBOludHdzIWNNff445uUUfMWD7tWcOFcluPNEA722HgwXnXQpp
         aN/lZY/XbfkBcRNlQV8OO4vyuPHFaBjS7SeeelQy3eMyNqlaYcXHqlGWnfCSRlV/yll7
         5ESXp2FRXaoQ5QYXwpWaqOHeoiAaeRTstyegS+AlXmLjcRwZyudpifZ1gF7sO2SjtVrK
         DXSVlYbyCFrqNDwASfJkFvxTRVNtu/lWGdSUbyGMMKpea7POPOMhVKuGyar49BPaBpwK
         SGrspJ+Kq1558Zy46xv5t276Njv7Mc/6KWfDucILR5Bv+wmWO2zreGSl8CLQPjGljaZH
         sCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cd8m/gbJL5OksdifC0YfQ/Rss3fHMYTARWdXxXEQuIY=;
        b=Tx0KBlzhmwxl9zNvpAyi1dS7Pvp85cY5wkP+QQmfv/U80l09ANWKC5AiDOKrAgD4bI
         eyq+UuLWgMXzSuwC/iAXHT2XbTZi7ia3RK4/HFe8gqrphqXz68e2kfKTrzr8+7aTjLZk
         YQ0KkxgNCNzrfyoGfCuQ7RRVavPGlmkAts5igMOd59JeibSMGQlhXCPVmZGB74bFWPFf
         ed1GtYprQpJLw9vK8dI6oocuXSB5tH9yIw9Jf1hHJn6CFHm8hp39hOzW+ElDT6vd3o0a
         26+0tbtgqFvzk4T1ygg6UYgvZ66K3UwC+ItZ1gy0XenQXNTir2gA6qCEkTNpQNF32d/T
         KhpQ==
X-Gm-Message-State: APjAAAVymZTFvFi2ZKOdN5QBPrykJbGBg+OzUOzRjFe5c6BNQ+Nph/T0
        3rarndH9T75B4OMKRmTICJo=
X-Google-Smtp-Source: APXvYqzUaQww82UjekJGv5ga6GpfLeIPilFtePXBNCrR4z1h5uJ4F4GFWvBJd2lC5j2MgkgKhyia1g==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr72038373wmc.128.1563973133836;
        Wed, 24 Jul 2019 05:58:53 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id x20sm102762048wrg.10.2019.07.24.05.58.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:58:53 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:58:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190724125851.GD2225@nanopsycho>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
 <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk>
 <20190723151423.GA10342@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190723151423.GA10342@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 23, 2019 at 05:14:23PM CEST, idosch@idosch.org wrote:
>On Tue, Jul 23, 2019 at 02:17:49PM +0200, Toke Høiland-Jørgensen wrote:
>> Ido Schimmel <idosch@idosch.org> writes:
>> 
>> > On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
>> >> Is there a mechanism for the user to filter the packets before they are
>> >> sent to userspace? A bpf filter would be the obvious choice I guess...
>> >
>> > Hi Toke,
>> >
>> > Yes, it's on my TODO list to write an eBPF program that only lets
>> > "unique" packets to be enqueued on the netlink socket. Where "unique" is
>> > defined as {5-tuple, PC}. The rest of the copies will be counted in an
>> > eBPF map, which is just a hash table keyed by {5-tuple, PC}.
>> 
>> Yeah, that's a good idea. Or even something simpler like tcpdump-style
>> filters for the packets returned by drop monitor (say if I'm just trying
>> to figure out what happens to my HTTP requests).
>
>Yep, that's a good idea. I guess different users will use different
>programs. Will look into both options.
>
>> > I think it would be good to have the program as part of the bcc
>> > repository [1]. What do you think?
>> 
>> Sure. We could also add it to the XDP tutorial[2]; it could go into a
>> section on introspection and debugging (just added a TODO about that[3]).
>
>Great!
>
>> >> For integrating with XDP the trick would be to find a way to do it that
>> >> doesn't incur any overhead when it's not enabled. Are you envisioning
>> >> that this would be enabled separately for the different "modes" (kernel,
>> >> hardware, XDP, etc)?
>> >
>> > Yes. Drop monitor have commands to enable and disable tracing, but they
>> > don't carry any attributes at the moment. My plan is to add an attribute
>> > (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
>> > you're interested in - SW/HW/XDP. If the attribute is not specified,
>> > then current behavior is maintained and all the drop types are traced.
>> > But if you're only interested in SW drops, then overhead for the rest
>> > should be zero.
>> 
>> Makes sense (although "should be" is the key here ;)).
>> 
>> I'm also worried about the drop monitor getting overwhelmed; if you turn
>> it on for XDP and you're running a filtering program there, you'll
>> suddenly get *a lot* of drops.
>> 
>> As I read your patch, the current code can basically queue up an
>> unbounded number of packets waiting to go out over netlink, can't it?
>
>That's a very good point. Each CPU holds a drop list. It probably makes
>sense to limit it by default (to 1000?) and allow user to change it

Shouldn't the queue len be configurable?


>later, if needed. I can expose a counter that shows how many packets
>were dropped because of this limit. It can be used as an indication to
>adjust the queue length (or flip to 'summary' mode).
