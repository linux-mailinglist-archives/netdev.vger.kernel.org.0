Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81DA140F11
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgAQQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:36:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52210 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbgAQQgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579278994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=532HFskFmUQQfmuvRrF7TCbnsOz8cd1ZXmRLJTIUqa8=;
        b=WiDt+po5s4ZmBRMciWMnlyFtrvod/wQQv+48TW6W6LK33K8Q92eNHPg2Fud+eFkBy3YewV
        qrxqzNbousjIvWtu7rASxxB5h4kFyaNVP71xPbCVMZo+NqDLajqvbZjLOuWQ+kJIb+c+Qe
        uzi9wEYFsQUbX4ymae52Qb2aj9nCyKg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-56nQ6Hg4OGCK3DoM3Ky57g-1; Fri, 17 Jan 2020 11:36:32 -0500
X-MC-Unique: 56nQ6Hg4OGCK3DoM3Ky57g-1
Received: by mail-wr1-f69.google.com with SMTP id f17so10736641wrt.19
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 08:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=532HFskFmUQQfmuvRrF7TCbnsOz8cd1ZXmRLJTIUqa8=;
        b=s6XmgmWU0FwvEixZFaMtibTDvDloD25cTy1wHfjZWqeGhjrPBW+6lmSvBJnt6M7Ai2
         kcRT60ubvRcX4o9MN6AFckIPfqqKaZw3NAr6PS8oU0orTHZB8s8Jsw1pFlU62ZgcK7I4
         Jchp7hShH5nfp/Y8Xe25EdA+Hp2DBwIzQ3e4toT/Ikf6Anke3qJ5IVGYYKaFEJNLZpac
         VrnyjDBgcQx2pzJbWmjTEHWZBmycOpSM4hjNf7yaGzPJSjVpRb4/NaNazvzUfUsVYZPI
         57dFHturFOesxPNC8qrtCMoMHELv7hvGI7MRkYE1nj2rIpv3GNPYT2gt77bSviBqZr8r
         uEpw==
X-Gm-Message-State: APjAAAVIAu7aV1jJRAVij2T+xVMhfwVmuI2GnHN0PSfk0/W0B6gaEOSl
        qtzjEieEdnkNuxsLITtJND/EkoNQDVTqp1gCWB9eT/4LoaVdSBOmNioLyjdAJnnhxSOMCg0BNUX
        /GixUMgWpih0GjJbu
X-Received: by 2002:adf:9144:: with SMTP id j62mr4080566wrj.168.1579278990696;
        Fri, 17 Jan 2020 08:36:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDR9VIgiWCLoKRLhFyapzx/K7tcRNBMHDOXBAR5V6HeSZ/2MhFXqYF2Nyzk75+DyrQe/KhkA==
X-Received: by 2002:adf:9144:: with SMTP id j62mr4080537wrj.168.1579278990434;
        Fri, 17 Jan 2020 08:36:30 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id s19sm10200475wmj.33.2020.01.17.08.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 08:36:29 -0800 (PST)
Date:   Fri, 17 Jan 2020 17:36:27 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117163627.GC2743@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116212332.GD4028@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 09:23:32PM +0000, Tom Parkin wrote:
> On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> > On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
> > > I agree with you about the possibility for cross-talk, and I would
> > > welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
> > > ditch the global list.
> > > 
> > > As per the RFC, for L2TPv3 the session ID should be a unique
> > > identifier for the LCCE.  So it's reasonable that the kernel should
> > > enforce that when registering sessions.
> > > 
> > I had never thought that the session ID could have global significance
> > in L2TPv3, but maybe that's because my experience is mostly about
> > L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
> > restricting the scope of sessions to their parent tunnel would conflict
> > with the RFC.
> 
> Sorry Guillaume, I responded to your other mail without reading this
> one.
> 
> I gave more detail in my other response: it boils down to how RFC 3931
> changes the use of IDs in the L2TP header.  Data packets for IP or UDP
> only contain the 32-bit session ID, and hence this must be unique to
> the LCCE to allow the destination session to be successfully
> identified.
> 
> > > When you're referring to cross-talk, I wonder whether you have in mind
> > > normal operation or malicious intent?  I suppose it would be possible
> > > for someone to craft session data packets in order to disrupt a
> > > session.
> > > 
> > What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
> > is loaded, a peer can reach whatever L2TPv3 session exists on the host
> > just by sending an L2TP_IP packet to it.
> > I don't know how practical it is to exploit this fact, but it looks
> > like it's asking for trouble.
> 
> Yes, I agree, although practically it's only a slightly easier
> "exploit" than L2TP/UDP offers.
> 
> The UDP case requires a rogue packet to be delivered to the correct
> socket AND have a session ID matching that of one in the associated
> tunnel.
> 
> It's a slightly more arduous scenario to engineer than the existing
> L2TPv3/IP case, but only a little.
> 
In the UDP case, we have a socket connected to the peer (or at least
bound to a local address). That is, some local setup is needed. With
l2tp_ip, we don't even need to have an open socket. Everything is
triggered remotely. And here, "remotely" means "any host on any IP
network the LCCE is connected", because the destination address can
be any address assigned to the LCCE, even if it's not configured to
handle any kind of L2TP. But well, after thinking more about our L2TPv3
discussiong, I guess that's how the designer's of the protocol wanted.

> I also don't know how practical this would be to leverage to cause
> problems.
> 
> > > For normal operation, you just need to get the wrong packet on the
> > > wrong socket to run into trouble of course.  In such a situation
> > > having a unique session ID for v3 helps you to determine that
> > > something has gone wrong, which is what the UDP encap recv path does
> > > if the session data packet's session ID isn't found in the context of
> > > the socket that receives it.
> > Unique global session IDs might help troubleshooting, but they also
> > break some use cases, as reported by Ridge. At some point, we'll have
> > to make a choice, or even add a knob if necessary.
> 
> I suspect we need to reach agreement on what RFC 3931 implies before
> making headway on what the kernel should ideally do.
> 
> There is perhaps room for pragmatism given that the kernel
> used to be more permissive prior to dbdbc73b4478, and we weren't
> inundated with reports of session ID clashes.
> 
To summarise, my understanding is that global session IDs would follow
the spirit of RFC 3931 and would allow establishing multiple L2TPv3
connections (tunnels) over the same 5-tuple (or 3-tuple for IP encap).
Per socket session IDs don't, but would allow fixing Ridge's case.

