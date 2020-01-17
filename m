Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A183140C66
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 15:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgAQO0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 09:26:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47917 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbgAQO0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 09:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579271163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5uUBZeJtzrn3w0iibPYR5cr7grsptNEJmjw7fstmemw=;
        b=RarpSE9JTl2M07ziXAiu2u0QVPERJiBsQGrtrYFlmKaxjuqA3LT3MmGoHVIP8Xq1wYI9qj
        ZckeZ6LLTYI8khI2lsbxzT8vFLsoXtSbq6wU0t1WjiCEuiYjqNUJzdirf+5329YTaEK1HU
        JpOvDzlMjbjPy5Ev1tmGmfGfmahCkrQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-qA7qdIypNV-uZldxT8PWNA-1; Fri, 17 Jan 2020 09:26:02 -0500
X-MC-Unique: qA7qdIypNV-uZldxT8PWNA-1
Received: by mail-wm1-f72.google.com with SMTP id f25so2331576wmb.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 06:26:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5uUBZeJtzrn3w0iibPYR5cr7grsptNEJmjw7fstmemw=;
        b=OMHbMaGS+eUQ/WHrbWVUE4cYi/34jKUBxzkh+hF9fjKZ0zfPOgrnIe+qlNmhsOXVkH
         mN/gffs9cpMH0ddOrJn/Md4UmlVxuO0jlYULfiLCYkKnz+ax8lt62+9pG6Xq9Gw2QSun
         mOO7p80MpbNHi1got7NdfnWb4IQwdihWuz+io2BiSKR3aY/I92xOGhsAWk6RzH72hzQi
         w7/0tejnDrl9EDKGZF9XtmHPmUvaEbngUgYP2WV/SDojEUYPMAl0OigonwnaI+KX3P0b
         79rd39gW8QEN5AGmwezA6e9kvsah6BK67OkmAC2YHZVPlrpzJeU7C0vmD7o61+O+/CIh
         K0ZA==
X-Gm-Message-State: APjAAAUH/wVtwMOLJpHd0Nqo8RNdtOQg55DezC4bxOagEaBagPuq0LA8
        ekPqLgSSdwYMSOyi/OfQhxwcPyW4rvR4BLb1HPj7Mikpc32VIVZIBnFCJ1ayigZaIwP50fV20OY
        E3ZASEew72elkb/+6
X-Received: by 2002:adf:f003:: with SMTP id j3mr3379983wro.423.1579271160920;
        Fri, 17 Jan 2020 06:26:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzX1mwztdliCObRcl02kdbMI1gqL0Sdgh+qyJk2W4b0pBG423rCHLjBQTGtlwDqRJl5oC9+hg==
X-Received: by 2002:adf:f003:: with SMTP id j3mr3379951wro.423.1579271160619;
        Fri, 17 Jan 2020 06:26:00 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id j12sm34688293wrt.55.2020.01.17.06.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 06:25:59 -0800 (PST)
Date:   Fri, 17 Jan 2020 15:25:58 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117142558.GB2743@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117131848.GA3405@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 01:18:49PM +0000, Tom Parkin wrote:
> On  Fri, Jan 17, 2020 at 10:50:55 +1300, Ridge Kennedy wrote:
> > On Thu, 16 Jan 2020, Tom Parkin wrote:
> > 
> > > On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> > > > On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
> > > > > I agree with you about the possibility for cross-talk, and I would
> > > > > welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
> > > > > ditch the global list.
> > > > > 
> > > > > As per the RFC, for L2TPv3 the session ID should be a unique
> > > > > identifier for the LCCE.  So it's reasonable that the kernel should
> > > > > enforce that when registering sessions.
> > > > > 
> > > > I had never thought that the session ID could have global significance
> > > > in L2TPv3, but maybe that's because my experience is mostly about
> > > > L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
> > > > restricting the scope of sessions to their parent tunnel would conflict
> > > > with the RFC.
> > > 
> > > Sorry Guillaume, I responded to your other mail without reading this
> > > one.
> > > 
> > > I gave more detail in my other response: it boils down to how RFC 3931
> > > changes the use of IDs in the L2TP header.  Data packets for IP or UDP
> > > only contain the 32-bit session ID, and hence this must be unique to
> > > the LCCE to allow the destination session to be successfully
> > > identified.
> > > 
> > > > > When you're referring to cross-talk, I wonder whether you have in mind
> > > > > normal operation or malicious intent?  I suppose it would be possible
> > > > > for someone to craft session data packets in order to disrupt a
> > > > > session.
> > > > > 
> > > > What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
> > > > is loaded, a peer can reach whatever L2TPv3 session exists on the host
> > > > just by sending an L2TP_IP packet to it.
> > > > I don't know how practical it is to exploit this fact, but it looks
> > > > like it's asking for trouble.
> > > 
> > > Yes, I agree, although practically it's only a slightly easier
> > > "exploit" than L2TP/UDP offers.
> > > 
> > > The UDP case requires a rogue packet to be delivered to the correct
> > > socket AND have a session ID matching that of one in the associated
> > > tunnel.
> > > 
> > > It's a slightly more arduous scenario to engineer than the existing
> > > L2TPv3/IP case, but only a little.
> > > 
> > > I also don't know how practical this would be to leverage to cause
> > > problems.
> > > 
> > > > > For normal operation, you just need to get the wrong packet on the
> > > > > wrong socket to run into trouble of course.  In such a situation
> > > > > having a unique session ID for v3 helps you to determine that
> > > > > something has gone wrong, which is what the UDP encap recv path does
> > > > > if the session data packet's session ID isn't found in the context of
> > > > > the socket that receives it.
> > > > Unique global session IDs might help troubleshooting, but they also
> > > > break some use cases, as reported by Ridge. At some point, we'll have
> > > > to make a choice, or even add a knob if necessary.
> > > 
> > > I suspect we need to reach agreement on what RFC 3931 implies before
> > > making headway on what the kernel should ideally do.
> > > 
> > > There is perhaps room for pragmatism given that the kernel
> > > used to be more permissive prior to dbdbc73b4478, and we weren't
> > > inundated with reports of session ID clashes.
> > > 
> > 
> > A knob (module_param?) to enable the permissive behaviour would certainly
> > work for me.
> 
> I think a knob might be the worst of both worlds.  It'd be more to test,
> and more to document.  I think explaining to a user when they'd want
> to use the knob might be quite involved.  So personally I'd sooner
> either make the change or not.
> 
Yes, I'd also prefer to not have a knob, if possible.

> More generally, for v3 having the session ID be unique to the LCCE is
> required to make IP-encap work at all.  We can't reliably obtain the
> tunnel context from the socket because we've only got a 3-tuple
> address to direct an incoming frame to a given socket; and the L2TPv3
> IP-encap data packet header only contains the session ID, so that's
> literally all there is to work with.
> 
I don't see how that differs from the UDP case. We should still be able
to get the corresponding socket and lookup the session ID in that
context. Or did I miss something? Sure, that means that the socket is
the tunnel, but is there anything wrong with that?

> If we relax the restriction for UDP-encap then it fixes your (Ridge's)
> use case; but it does impose some restrictions:
> 
>  1. The l2tp subsystem has an existing bug for UDP encap where
>  SO_REUSEADDR is used, as I've mentioned.  Where the 5-tuple address of
>  two sockets clashes, frames may be directed to either socket.  So
>  determining the tunnel context from the socket isn't valid in this
>  situation.
> 
>  For L2TPv2 we could fix this by looking the tunnel context up using
>  the tunnel ID in the header.
> 
>  For L2TPv3 there is no tunnel ID in the header.  If we allow
>  duplicated session IDs for L2TPv3/UDP, there's no way to fix the
>  problem.
> 
>  This sounds like a bit of a corner case, although its surprising how
>  many implementations expect all traffic over port 1701, making
>  5-tuple clashes more likely.
> 
Hum, I think I understand your scenario better. I just wonder why one
would establish several tunnels over the same UDP or IP connection (and
I've also been surprised by all those implementations forcing 1701 as
source port).

>  2. Part of the rationale for L2TPv3's approach to IDs is that it
>  allows the data plane to potentially be more efficient since a
>  session can be identified by session ID alone.
>  
>  The kernel hasn't really exploited that fact fully (UDP encap
>  still uses the socket to get the tunnel context), but if we make
>  this change we'll be restricting the optimisations we might make
>  in the future.
> 
> Ultimately it comes down to a judgement call.  Being unable to fix
> the SO_REUSEADDR bug would be the biggest practical headache I
> think.
And it would be good to have a consistent behaviour between IP and UDP
encapsulation. If one does a global session lookup, the other should
too.

