Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFBC1801C0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCJP0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:26:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40515 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJP0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:26:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so6625666pfl.7
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVMUYWTQnoWR6WyUIxyGMJBB5qwPEH8yil0w30IPHg0=;
        b=wFRJE6CD2JJYo8TYYh7XHAW1xCwuxoiZQLcuatIM39vb4GrctGxCfButTsCxjuhQxD
         nOUoI1nrvybwNQvU7VeGRmp1GoKAueFUxigNYo943B2YeDFTyDnoAQIDDmh527RLFKVX
         W4oFzzmeh5/noiUSQZV/KcEjnBQEoWe5DjgMMOP1ztAaS50npIBoPZA/KZOY9PMTjWvx
         H+ffvF/nnj6Lr1sO0AAVEkw9PRmR6X3VVGzKghv6zwiU+d72p5eXVyaav7aYDNgZ1Zil
         mUC2RU8OqizJg5pUeTiYWWeaCL/TrR8jZx991AWyl0YdVyMQIqbvDwmFg8MZtVXhwtc7
         Bn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oVMUYWTQnoWR6WyUIxyGMJBB5qwPEH8yil0w30IPHg0=;
        b=bANFWWnekiR2ivJUF+R9to6uaJB6obKWSUpkMfuDv1D2MgBCkSN2Fo3DyGqyfgZ4J4
         5x6hOU9GRbh4CLxrDTCi9z2H3V11N/0UnIRAnDygIJ43hj3Wg7HjIPb5RMsopC47Gjz/
         N+KIkSndKa9if+7f8ONw57mcqB3V+s/712UlnZm8qvnuIwIc1nKiZshM71rjXhlnZEyO
         gxL34p3EqKI8ICGBD5WDjYhXPxMLXsa5bGxsd1sz7bDsnt1H1u+jg+riPIPy8uPdBtyo
         mcMLvBmRnkFzzXmXLctoTckP9A2jJU0jc8czyuA0+Wb5xBHXBC45yFU7gQ/RFw9KeZRl
         ImXw==
X-Gm-Message-State: ANhLgQ09YGVXDZEnuugc5aoedTn8FxSdmDBP4oC1NFpnqBCPtMn+W4Yz
        FC5LELsU9XuihiqdscleHd6gLJhUznA=
X-Google-Smtp-Source: ADFU+vuxm0mezmXhrNsXTVjhjdHFL2dkuA2l4Y4ihoKqsSofciPgb7wO9eexj4BWUvmARNwnqBnYiA==
X-Received: by 2002:a63:d4d:: with SMTP id 13mr21011068pgn.376.1583853993520;
        Tue, 10 Mar 2020 08:26:33 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x18sm37043574pfo.148.2020.03.10.08.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:26:33 -0700 (PDT)
Date:   Tue, 10 Mar 2020 08:26:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        Martin Pohlack <mpohlack@amazon.de>
Subject: Re: TCP receive failure
Message-ID: <20200310082625.4d9d070a@hermes.lan>
In-Reply-To: <dbbd0ba6d602b5106b484f7d9df7126e40c9b5e0.camel@infradead.org>
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
        <20200310103928.GB18192@1wt.eu>
        <dbbd0ba6d602b5106b484f7d9df7126e40c9b5e0.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 13:07:49 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2020-03-10 at 11:39 +0100, Willy Tarreau wrote:
> > Hi David,
> > 
> > On Tue, Mar 10, 2020 at 09:40:04AM +0000, David Woodhouse wrote:  
> > > I'm chasing a problem which was reported to me as an OpenConnect packet
> > > loss, with downloads stalling until curl times out and aborts.
> > > 
> > > I can't see a transport problem though; I think I see TCP on the
> > > receive side misbehaving. This is an Ubuntu 5.3.x client kernel
> > > (5.3.0-40-generic #32~18.04.1-Ubuntu) which I think is 5.3.18?
> > > 
> > > The test is just downloading a large file full of zeroes. The problem
> > > starts with a bit of packet loss and a 40ms time warp:  
> > 
> > So just to clear up a few points, it seems that the trace was taken on
> > the client, right ?  
> 
> Yes. Sorry, meant to make that explicit.
> 
> I have a server-side capture too. The absolute TCP sequence numbers are
> different, implying that there's some translation or load balancer or
> some other evilness happening. But as far as I can tell there's only
> the delta in the seq#s and it isn't actually perturbing the connection
> in any other way.
> 
> The server itself (also Linux but 4.9 IIRC) genuinely is sending those
> weird 'future' packets, interleaved with the catch-up packets as noted.
> 
> Which are probably what's causing nf_conntrack to get out of sync with
> the receive window.
> 
> > (...)  
> > > 19:14:03.040870 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735803185, win 24171, options [nop,nop,TS val 2290572281 ecr 653279937,nop,nop,sack 1 {1735831937:1735884649}], length 0
> > > 
> > > Looks sane enough so far...
> > > 
> > > 19:14:03.041903 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735950539:1735951737, ack 366489597, win 235, options [nop,nop,TS val 653279937 ecr 2290572254], length 1198: HTTP
> > > 
> > > WTF? The server has never sent us anything past 1735884649 and now it's
> > > suddenly sending 1735950539? But OK, despite some confusing future
> > > packets which apparently get ignored (and make me wonder if I really
> > > understand what's going on here), the client is making progress because
> > > the server is *also* sending sensible packets, and the originally
> > > dropped segments are being recovered...
> > > 
> > > 19:14:03.068337 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735803185:1735804383, ack 366489597, win 235, options [nop,nop,TS val 653279944 ecr 2290572281], length 1198: HTTP
> > > 19:14:03.068363 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735804383, win 24171, options [nop,nop,TS val 2290572309 ecr 653279944,nop,nop,sack 1 {1735831937:1735884649}], length 0  
> > 
> > (...)  
> > > 19:14:03.211316 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735884649, win 24171, options [nop,nop,TS val 2290572452 ecr 653279980], length 0
> > > 
> > > OK, now it's caught up. Client continues to ignore bogus future packets
> > > from the server, and doesn't even SACK them.  
> > 
> > That's what caught my eyes as well.
> >   
> > > 19:14:03.211629 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735967311:1735968509, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572422], length 1198: HTTP  
> > 
> > (... no ack here ...)  
> > > 19:14:03.251516 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736028409:1736029607, ack 366489597, win 235, options [nop,nop,TS val 653279989 ecr 2290572452], length 1198: HTTP
> > > 
> > > Server finally comes to its senses and actually sends the packet that
> > > the client wants. Repeatedly.  
> > 
> > This makes me think that there's very likely nf_conntrack on the client
> > machine and the TCP packets you're seeing reach tcpdump but not the TCP
> > layer. For some reason they're very likely considered out of window and
> > are silently dropped. Since we don't have the SYN we don't know the
> > window size, but we can try to guess. There was 82662 unacked bytes in
> > flight at the peak when the server went crazy, for an apparent window of
> > 24171, making me think the window scaling was at least 4, or that the
> > server wrongly assumed so. But earlier when the client was sending SACKs
> > I found bytes in flight as high as 137770 for an advertised window of
> > 24567 (5.6 times more), thus the window scaling is at least 8. So this
> > indicates that the 82kB above are well within the window and the client
> > should ACK them. But maybe they were dropped as invalid at the conntrack
> > layer for another obscure reason.  
> 
> 19:14:03.469417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280045 ecr 2290572452], length 1198: HTTP
> 19:14:03.933488 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280161 ecr 2290572452], length 1198: HTTP
> 19:14:04.861503 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280393 ecr 2290572452], length 1198: HTTP
> 19:14:06.735809 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280858 ecr 2290572452], length 1198: HTTP
> 19:14:10.524440 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653281788 ecr 2290572452], length 1198: HTTP
> 19:14:17.881996 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653283648 ecr 2290572452], length 1198: HTTP
> 
>  (...goes back to reporter to check logs ... )
> 
> Mar  9 20:14:03 kernel: [71401.451732] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=1250 TOS=0x00 PREC=0x00 TTL=120 ID=48152 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:03 kernel: [71401.452582] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=1250 TOS=0x00 PREC=0x00 TTL=120 ID=48154 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:03 kernel: [71401.479972] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=1250 TOS=0x00 PREC=0x00 TTL=120 ID=48158 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:03 kernel: [71401.480304] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=1250 TOS=0x00 PREC=0x00 TTL=120 ID=48160 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:18 kernel: [71416.575237] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=52 TOS=0x00 PREC=0x00 TTL=120 ID=48252 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:18 kernel: [71416.777021] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=64 TOS=0x00 PREC=0x00 TTL=120 ID=48253 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:18 kernel: [71417.019399] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=64 TOS=0x00 PREC=0x00 TTL=120 ID=48254 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> Mar  9 20:14:19 kernel: [71417.526725] [UFW BLOCK] IN=tun0 OUT= MAC= SRC=10.28.82.105 DST=192.168.0.195 LEN=64 TOS=0x00 PREC=0x00 TTL=120 ID=48255 DF PROTO=TCP SPT=80 DPT=53754 WINDOW=235 RES=0x00 ACK URGP=0 
> 
> Yeah, spot on. Thanks. Will stare accusingly at nf_conntrack, and
> perhaps also at the server side which is sending the later sequence
> numbers and presumably confusing it.
> 

There were cases in the past of busted middle boxes that ignored TCP window scaling.

These were boxes based on old (buggy) version of FreeBSD firewall code that did
not remember the window scaling from the handshake and would then see packets as
out of window.

You could try turning TCP window scaling off to see if that changes it.
