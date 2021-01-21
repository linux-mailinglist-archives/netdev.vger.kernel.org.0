Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8970F2FF64D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbhAUUsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbhAUUso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:48:44 -0500
X-Greylist: delayed 405 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jan 2021 12:48:03 PST
Received: from ellomb.netlib.re (unknown [IPv6:2001:912:1480:10::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02848C061756;
        Thu, 21 Jan 2021 12:48:02 -0800 (PST)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by ellomb.netlib.re (Postfix) with ESMTPA id 0CDC94AC27C9;
        Thu, 21 Jan 2021 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr; s=dkim;
        t=1611261621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y06bW3Z3IKJotzTvjRUlU+gfqobtqICfSf2t1S+NAoY=;
        b=Kr+w7c1SNktsPjpd4t5UpDtPXGZwzilVK8xQwO1Jy95Ce0KoByz+dYu94YTeawg3LiPd3k
        0StO31fcMF/h0NVTG0EtLy4aStY3WphimeGnD27Wd+zvqHYwEhiUxJGx7fSwNT1JdQb0gn
        r7vPkDnlKXRg1TtOOHbhPjw1JW5T6pI=
MIME-Version: 1.0
Date:   Thu, 21 Jan 2021 21:40:19 +0100
From:   Shanti Lombard <shanti@mildred.fr>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     =?UTF-8?Q?Shanti_Lombard_n=C3=A9e_Bouchez-Mongard=C3=A9?= 
        <shanti20210120@mildred.fr>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: More flexible BPF socket inet_lookup hooking after listening
 sockets are dispatched
In-Reply-To: <87r1me4k4l.fsf@cloudflare.com>
References: <afb4e544-d081-eee8-e792-a480364a6572@mildred.fr>
 <CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com>
 <87r1me4k4l.fsf@cloudflare.com>
Message-ID: <e1fc896faf4ad913e0372bc30461b849@mildred.fr>
X-Sender: shanti@mildred.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr;
        s=dkim; t=1611261621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y06bW3Z3IKJotzTvjRUlU+gfqobtqICfSf2t1S+NAoY=;
        b=FdwPr/m5rtd7l8nJ/G+0HqzOn0UiMdB7VcoqiXkY4uim18WYvqthQMpeyAT5Tl3r6p1iol
        qj9JPP7ybn0xp0QzS234VrOCRADk82KKI7sL6WxXzPIHiwJRUZIzk4vVGAvnWPGgfd0QzJ
        lGFdqrgTAbPTgshR561F3Y4ms2lYk8c=
ARC-Seal: i=1; s=dkim; d=mildred.fr; t=1611261622; a=rsa-sha256; cv=none;
        b=lOi2zHzJ2Mw8cEAWmqzn10gTCO8SL4mRrvJw3pgzWh7G8u4e1Hy2Z/pOfJL/uRKz0o6iUn
        SCJ65m9bn2fszv+7oiW7Ys8mf5kHEariixtui2+ikUoBVpgvdXz+3lTYSxDLQ8i/U1A/4i
        QFt2Bn1XvWwDuk0yx+72B0xnbL4VYxk=
ARC-Authentication-Results: i=1;
        ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=shanti@mildred.fr
Authentication-Results: ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=shanti@mildred.fr
X-Spamd-Bar: /
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 2021-01-21 12:14, Jakub Sitnicki a écrit :
> On Wed, Jan 20, 2021 at 10:06 PM CET, Alexei Starovoitov wrote:
> 
> There is also documentation in the kernel:
> 
> https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html
> 

Thank you, I saw it, it's well written and very much explains it all.

> 
> Existing hook is placed before regular listening/unconnected socket
> lookup to prevent port hijacking on the unprivileged range.
> 

Yes, from the point of view of the BPF program. However from the point 
of view of a legitimate service listening on a port that might be 
blocked by the BPF program, BPF is actually hijacking a port bind.

That being said, if you install the BPF filter, you should know what you 
are doing.

>>> The suggestion above would work for my use case, but there is another
>>> possibility to make the same use cases possible : implement in BPF 
>>> (or
>>> allow BPF to call) the C and E steps above so the BPF program can
>>> supplant the kernel behavior. I find this solution less elegant and 
>>> it
>>> might not work well in case there are multiple inet_lookup BPF 
>>> programs
>>> installed.
> 
> Having a BPF helper available to BPF sk_lookup programs that looks up a
> socket by packet 4-tuple and netns ID in tcp/udp hashtables sounds
> reasonable to me. You gain the flexibility that you describe without
> adding code on the hot path.

True, if you consider that hot path should not be slowed down. It makes 
sense. However, for me, it seems the implementation would be more 
difficult.

Looking at existing BPF helpers 
<https://man7.org/linux/man-pages/man7/bpf-helpers.7.html> I found 
bpf_sk_lookup_tcp and bpf_sk_lookup_ucp that should yield a socket from 
a matching tuple and netns. If that's true and usable from within BPF 
sk_lookup then it's just a matter of implementing it and the kernel is 
already ready for such use cases.

Shanti
