Return-Path: <netdev+bounces-6818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB06718511
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB9F628139C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E08C8E6;
	Wed, 31 May 2023 14:35:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C21C11
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:35:20 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D50E2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:35:18 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1q4MKA-0005c7-PI; Wed, 31 May 2023 15:57:14 +0200
Message-ID: <ab31715a-0fe7-f881-be1a-2b69fde82f23@leemhuis.info>
Date: Wed, 31 May 2023 15:57:14 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mlx5 driver is broken when pci_msix_can_alloc_dyn() is false with
 v6.4-rc4
Content-Language: en-US, de-DE
To: Niklas Schnelle <schnelle@linux.ibm.com>,
 Linux regressions mailing list <regressions@lists.linux.dev>,
 Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Eli Cohen <elic@nvidia.com>, netdev@vger.kernel.org
References: <d6ada86741a440f99b5d6fedff532c8dbe86254f.camel@linux.ibm.com>
 <cb093081-ef71-c556-fe2f-9ec30bbcfe80@leemhuis.info>
 <c2702c969f01f9dcf2d6b3d3326e804c3fee86c0.camel@linux.ibm.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <c2702c969f01f9dcf2d6b3d3326e804c3fee86c0.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1685543718;68c0c8c8;
X-HE-SMSGID: 1q4MKA-0005c7-PI
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 31.05.23 15:43, Niklas Schnelle wrote:
> On Wed, 2023-05-31 at 15:33 +0200, Linux regression tracking #adding
> (Thorsten Leemhuis) wrote:
>> [CCing the regression list, as it should be in the loop for regressions:
>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>>
>> [TLDR: I'm adding this report to the list of tracked Linux kernel
>> regressions; the text you find below is based on a few templates
>> paragraphs you might have encountered already in similar form.
>> See link in footer if these mails annoy you.]
>>
>> On 30.05.23 15:04, Niklas Schnelle wrote:
>>>
>>> With v6.4-rc4 I'm getting a stream of RX and TX timeouts when trying to
>>> use ConnectX-4 and ConnectX-6 VFs on s390. I've bisected this and found
>>> the following commit to be broken:
>>>
>>> commit 1da438c0ae02396dc5018b63237492cb5908608d
>>> Author: Shay Drory <shayd@nvidia.com>
>>> Date:   Mon Apr 17 10:57:50 2023 +0300
>>> [...]
>>
>> Thanks for the report. To be sure the issue doesn't fall through the
>> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
>> tracking bot:
>>
>> #regzbot ^introduced 1da438c0ae02396dc5018b63237492cb5908608d
>> #regzbot title net/mlx5: RX and TX timeouts with ConnectX-4 and
>> ConnectX-6 VFs on s390
>> #regzbot ignore-activity
>>
>> This isn't a regression? This issue or a fix for it are already
>> discussed somewhere else? It was fixed already? You want to clarify when
>> the regression started to happen? Or point out I got the title or
>> something else totally wrong? Then just reply and tell me -- ideally
>> while also telling regzbot about it, as explained by the page listed in
>> the footer of this mail.
>>
>> Developers: When fixing the issue, remember to add 'Link:' tags pointing
>> to the report (the parent of this mail). See page linked in footer for
>> details.
>>
>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>> --
>> Everything you wanna know about Linux kernel regression tracking:
>> https://linux-regtracking.leemhuis.info/about/#tldr
>> That page also explains what to do if mails like this annoy you.
> 
> Hi Thorsten,
> 
> Thanks for tracking. I actually already sent a fix patch (and v2) for
> this. Sadly I forgot to link to this mail. Let's see if I can get the
> regzbot command right to update it. As for the humans the latest fix
> patch is here:
> 
> https://lore.kernel.org/netdev/20230531084856.2091666-1-schnelle@linux.ibm.com/
> 
> Thanks,
> Niklas
> 
> #regzbot fix: net/mlx5: Fix setting of irq->map.index for static IRQ case

Looks right, many thx. Sorry, should have looked for that myself. Sadly
regzbot doesn't yet search for existing post on lore with a matching
subject, so for completeness let me point manually to it while at it:

#regzbot monitor:
https://lore.kernel.org/netdev/20230531084856.2091666-1-schnelle@linux.ibm.com/

Ciao, Thorsten

