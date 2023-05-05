Return-Path: <netdev+bounces-623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3746F898D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F4E62810AB
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC66CC8F2;
	Fri,  5 May 2023 19:37:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945802F33;
	Fri,  5 May 2023 19:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61D7C433D2;
	Fri,  5 May 2023 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683315465;
	bh=jWX9o4Tm0t1//hnv8aSktj31xHJVqkdPvQ05pgtlg58=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J/5Io5Jq7sJJw06zgLHWlyHmTEMBxfOde3IYl0dGmybhOmjB6ss8x6lki/G78291p
	 Udt0r0wpet2+ew8XA6nRgBhdQcDx5p0OUZvCE9wCSpmScdu6Ya296dYkQw+S1yv9kj
	 AWq8YPs4WZ1Oe8rAc6H/LuMXo7ZraRFRNQ3ldP6FGH1n7FLf1IYUb2yZn4LPJQy+aj
	 lUGXX1Tn301t0U4JE6ag7CVctg2h+2AT6Cyh8eYDPjv6smOLv9Y4cutnbgX1OnNdZy
	 pOeZfksFck92DBZEp7fGr23oAPsvRP3/xs5cbnupi/I/jnj186qPX/gO3uBvC4bkjX
	 2MiJnHPD0ks9w==
Date: Fri, 5 May 2023 12:37:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>,
 =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>, Hayes Wang
 <hayeswang@realtek.com>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and
 RTL8153 Gigabit Ethernet Adapter
Message-ID: <20230505123744.16666106@kernel.org>
In-Reply-To: <57dbce31-daa9-9674-513e-f123b94950da@leemhuis.info>
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
	<87lei36q27.fsf@miraculix.mork.no>
	<20230505120436.6ff8cfca@kernel.org>
	<57dbce31-daa9-9674-513e-f123b94950da@leemhuis.info>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 May 2023 21:20:15 +0200 Linux regression tracking (Thorsten
Leemhuis) wrote:
> > Thorsten, how is the communication supposed to work in this case?
> > Can you ask the reporter to test this?  
> 
> I'd prefer to not become the man-in-the middle, that just delays things
> and is fragile; but I can do that occasionally if developers really are
> unwilling to go to bugzilla.
> 
> Bugbot afaics will solve this, but using it right now would require me
> to do something some maintainers don't like. See this sub-thread:
> 
> https://lore.kernel.org/all/1f0ebf13-ab0f-d512-6106-3ebf7cb372f1@leemhuis.info/
> 
> :-/
> 
> This got me thinking: we could tell bugbot to start monitoring this
> thread and then tell the reporter to CC to the new bug bugbot created.
> Ugly, but might work.
> 
> > I don't see them on CC...  
> 
> Yeah, as stated in the initial mail of this thread: I sadly can't CC
> them, because bugzilla.kernel.org tells users upon registration their
> "email address will never be displayed to logged out users"... #sigh
> 
> I wish things were different, I'm unhappy about this situation myself.

Let's work something out, because forwarding enough info for Bjorn to
respond on the list means that we now have the conversation going in
both places. So it's confusing & double the work for developers.

I don't seem to have the permissions on BZ, but I'm guessing we could
do the opposite - you could flip bugbot on first to have it flush the BZ
report to the list, and then reply on the list with regzbot tracking?

