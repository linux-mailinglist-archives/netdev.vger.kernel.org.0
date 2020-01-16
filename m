Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9359C13FBB4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgAPVvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:51:01 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:55466 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbgAPVvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:51:00 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B2B29891A9;
        Fri, 17 Jan 2020 10:50:55 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1579211455;
        bh=nx2SaXORqBh5ieTLt4UGgCaqK0gxn5wHdqBIqJIbqXY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=1vATGGmrxk9LMx8caWPsw+OFtmdoBwN0C3CAoeCGZaWcEx0p8Q50cm/VLvxbHzqm4
         cmXRtayFrumVeNwfAgKgEDVPyEV5AO7jjibr5u7oTK6ZTPEbsJ5BEd7hJdet74g3EY
         peZxLTEbzD/DJ3hWF7nX/VwpuY9039ne9wLwRCaGXlRHETaKbpU3SKGTzs8dfcA3rJ
         KrtTOOz07YFAo6KDZ4UwDX4ciDxvK0K9hzpaVI9F0T1V/sM47anI17jK+VyjF2SAay
         F8luKwiknarhhPHTSd6cc9zw9xSkTuVFcRIwW57GnLu+bk8Z6WOZQLNolwb5Z7w6Hj
         pt5oeasqTtCPw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e20dabf0000>; Fri, 17 Jan 2020 10:50:55 +1300
Received: from ridgek-dl.ws.atlnz.lc (ridgek-dl.ws.atlnz.lc [10.33.22.15])
        by smtp (Postfix) with ESMTP id 5A25313EEFE;
        Fri, 17 Jan 2020 10:50:55 +1300 (NZDT)
Received: by ridgek-dl.ws.atlnz.lc (Postfix, from userid 1637)
        id 98A031405FD; Fri, 17 Jan 2020 10:50:55 +1300 (NZDT)
Received: from localhost (localhost [127.0.0.1])
        by ridgek-dl.ws.atlnz.lc (Postfix) with ESMTP id 957B71405F0;
        Fri, 17 Jan 2020 10:50:55 +1300 (NZDT)
Date:   Fri, 17 Jan 2020 10:50:55 +1300 (NZDT)
From:   Ridge Kennedy <ridgek@alliedtelesis.co.nz>
X-X-Sender: ridgek@ridgek-dl.ws.atlnz.lc
To:     Tom Parkin <tparkin@katalix.com>
cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
In-Reply-To: <20200116212332.GD4028@jackdaw>
Message-ID: <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz> <20200116123854.GA23974@linux.home> <20200116131223.GB4028@jackdaw> <20200116190556.GA25654@linux.home> <20200116212332.GD4028@jackdaw>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 16 Jan 2020, Tom Parkin wrote:

> On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
>> On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
>>> I agree with you about the possibility for cross-talk, and I would
>>> welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
>>> ditch the global list.
>>>
>>> As per the RFC, for L2TPv3 the session ID should be a unique
>>> identifier for the LCCE.  So it's reasonable that the kernel should
>>> enforce that when registering sessions.
>>>
>> I had never thought that the session ID could have global significance
>> in L2TPv3, but maybe that's because my experience is mostly about
>> L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
>> restricting the scope of sessions to their parent tunnel would conflict
>> with the RFC.
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
>>> When you're referring to cross-talk, I wonder whether you have in mind
>>> normal operation or malicious intent?  I suppose it would be possible
>>> for someone to craft session data packets in order to disrupt a
>>> session.
>>>
>> What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
>> is loaded, a peer can reach whatever L2TPv3 session exists on the host
>> just by sending an L2TP_IP packet to it.
>> I don't know how practical it is to exploit this fact, but it looks
>> like it's asking for trouble.
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
> I also don't know how practical this would be to leverage to cause
> problems.
>
>>> For normal operation, you just need to get the wrong packet on the
>>> wrong socket to run into trouble of course.  In such a situation
>>> having a unique session ID for v3 helps you to determine that
>>> something has gone wrong, which is what the UDP encap recv path does
>>> if the session data packet's session ID isn't found in the context of
>>> the socket that receives it.
>> Unique global session IDs might help troubleshooting, but they also
>> break some use cases, as reported by Ridge. At some point, we'll have
>> to make a choice, or even add a knob if necessary.
>
> I suspect we need to reach agreement on what RFC 3931 implies before
> making headway on what the kernel should ideally do.
>
> There is perhaps room for pragmatism given that the kernel
> used to be more permissive prior to dbdbc73b4478, and we weren't
> inundated with reports of session ID clashes.
>

A knob (module_param?) to enable the permissive behaviour would certainly
work for me.




