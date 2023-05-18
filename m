Return-Path: <netdev+bounces-3748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C29DD7087FE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792A0281920
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5C26FB8;
	Thu, 18 May 2023 18:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE4A194
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:50:24 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD40EE51;
	Thu, 18 May 2023 11:50:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id E3DB86018D;
	Thu, 18 May 2023 20:50:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684435819; bh=K8oNufpSLIVY22ScmOQ8KrTxRaX7cOkQGgVlcFXyBxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QsO1SSqrfrrKTZHMgrcF3d1wlYs03rbOv/7UdABTD7oPgOIRAl+Gfy4GY3Atn36Ew
	 fDrHSugB0N6BrmNk5ur6FSud1XVySJgaq/yGjqBPKk++Ln16AuC8P06w7r83Zx+FgA
	 cxD2VRrbtXBFr43a8eKpOKs/rlBq1oPSZMzi9OociU4UpFl6yrhDnTFj7W6M0jjWgz
	 4dEJE7OiGxhXvKIWxw3Lfqj0NvK5wYAQunIM0OX8KDNU4tqv3OTXfvmdED+TqA7Jwq
	 iJHSilN57sRTjcGtonSIyXPlQ4M7lq7MP8qaWpjXRe2u2fh7k8W9Mm2PsemGqOI7oT
	 ihnYaxyABObZQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l4Am7MWZocqH; Thu, 18 May 2023 20:50:17 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id DE58760189;
	Thu, 18 May 2023 20:50:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684435817; bh=K8oNufpSLIVY22ScmOQ8KrTxRaX7cOkQGgVlcFXyBxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K3ufSmqMB0cmdFpNQ4l6jwGEZIqMEu8gltlVYyjClEOtNOEMIg53LlniDCwvnFBQS
	 i5xf4wDHrpj6JLpRLTHsLLp6LIAnOXrRmhmOEkr5ImwEBOOSi0yHy4UTMDbKgIrJVu
	 cxnS5t2UYtHtUov/OIPMyaOHciEIKE3pZtQTODaAjRnoWMIPwPj/GXybj1CGhd3yw0
	 h2HLpBTxqvi+C1LydlNsHQ5SCaFb2pUoaSm7g5DiPTM/O5Q8ZN+roa0cgxZNvmNKeD
	 hwHxNLb5MkTmG1FVrPhM2L7tSeOPK/fJn/PTmDeAAibnoZ+xbSwfiHridiwoOkE4fz
	 l3WUh510xM4Cg==
Message-ID: <d574c978-c2b8-f2e0-abc5-19899b4fefe6@alu.unizg.hr>
Date: Thu, 18 May 2023 20:50:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
Content-Language: en-US
To: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leonro@nvidia.com>
References: <20230517213101.25617-1-mirsad.todorovac@alu.unizg.hr>
 <056e71bd6a06779bfcb1ef4518a2f67f67730fe7.camel@sipsolutions.net>
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <056e71bd6a06779bfcb1ef4518a2f67f67730fe7.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/17/23 23:34, Johannes Berg wrote:
>>
>> Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
>> Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr/
>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>> Link: https://lore.kernel.org/all/cdc80531-f25f-6f9d-b15f-25e16130b53a@alu.unizg.hr/
>> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>
> 
> You really should say what you changed, but anyway, it's too late - I
> applied a previous version yesterday.

Yes. Sorry, I was following Andy's advice to resend, at the wrong
assumption that the system ate the patch after three weeks of
inactivity. :-/

The difference is really in the mailbox containing the patch, but git
somehow ate that, too. Beginner's errors. :-(

---
v4 -> v5:
- Some cleanup, keeping the longer stacktrace as requested
v3 -> v4:
- Added whole lockdep trace as advised.
- Trimmed irrelevant line prefix.
v2 -> v3:
- Fix the Fixes: tag as advised.
- Change the net: to wifi: to comply with the original patch that
   is being fixed.
v1 -> v2:
- Minor rewording and clarification.
- Cc:-ed people that replied to the original bug report (forgotten
   in v1 by omission).

  net/mac80211/tx.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

Rest assured, the code did not change. It is a rather obvious fix
to the interrupt caused deadlock.

> Also, I suspect you just collected the reviewed-by tag here, which
> really you shouldn't be doing a resend for.

This is correct, plus cosmetic removal of Cc:s as advised.

Sorry for confusion, I am really having a great time with the Intel
Linux team and I am currently updating my homework on Wi-Fi.

Provided that there will be more use of me for the wireless.

But I can always justify anything used in multimedia or graphic
rendering as my field of research. Well, almost anything :-)

Best regards,
Mirsad

