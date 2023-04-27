Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBA46F00E0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbjD0GiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbjD0Gh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:37:59 -0400
Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756861A6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:37:56 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id rvGIpCZ6IgznKrvGIpsgaX; Thu, 27 Apr 2023 08:37:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682577474;
        bh=15cN6xGXcPgpb6mMSQ+wGIww6r6XNUs6lYtchWqDdJ0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=ZE7oJredEGJMjLhQA6WdHlDvcNKKOaGT9pfVF/t/zF7ogQaRmm+bGxoFVu9RSXmxK
         4FeRGHhzgL00PCAgxIQYNm6UFYYN/q3PNL1SWZlaqHELt82QRD5Z4x1+UeoiqYlWSU
         /4NB0mb7+p81lyH0DIYeDMhQxFgUYvKXfZPK/izSXRxmmg1wWMrmWrymAgBqXc2MaH
         6iWcIf3nV9B9jrmRAJ9Mdirh3dSB0Ti1sFpGlcimkJTuiTBrfVKRLPfVMYWuTzZNMX
         +6bBSeJEiRePu3yKPpYNYm8HjQBkh3g4ESzvn+mi0gdHboKh+A5Seu19QW0FiTtdai
         hdhBBe+oN0vZA==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 27 Apr 2023 08:37:54 +0200
X-ME-IP: 86.243.2.178
Message-ID: <bf435a7f-aee6-0f45-2eb8-128977a8a6ae@wanadoo.fr>
Date:   Thu, 27 Apr 2023 08:37:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] wifi: ath11k: Use list_count_nodes()
To:     Kalle Valo <kvalo@kernel.org>, Joe Perches <joe@perches.com>
Cc:     ath11k@lists.infradead.org, christophe.jaillet@wanadoo.fr,
        davem@davemloft.net, edumazet@google.com,
        kernel-janitors@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
 <87v8hiosci.fsf@kernel.org>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <87v8hiosci.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/04/2023 à 06:35, Kalle Valo a écrit :
> Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org> writes:
> 
>> ath11k_wmi_fw_stats_num_vdevs() and ath11k_wmi_fw_stats_num_bcn() really
>> look the same as list_count_nodes(), so use the latter instead of hand
>> writing it.
>>
>> The first ones use list_for_each_entry() and the other list_for_each(), but
>> they both count the number of nodes in the list.
>>
>> While at it, also remove to prototypes of non-existent functions.
>> Based on the names and prototypes, it is likely that they should be
>> equivalent to list_count_nodes().
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
>> ---
>> Un-tested
> 
> I'll run sanity tests on ath11k patches. I'll also add "Compile tested
> only" to the commit log.
> 
> Oh, and ath11k patches go to ath tree, not net-next.
> 
Hi,

[adding Joe Perches]

maybe checkpatch could be instrumented for that?

Something that would print a warning if the MAINTAINERS file has a git 
repo in T: or if F: states something related to 'net'.


WARNING: Your patch is against the xxx.git repo but the subject of the 
mail does not reflect it. Should [PATCH xxx] be used instead?
Also make sure that it applies cleanly on xxx.git to ease merge process.

WARNING: Your patch is related to 'net'. Such patches should state 
[PATCH net] when related to bug fix, or [PATCH net-next] otherwise.

Eventually, something if net-next is closed?


What do you think?
Would it be possible? Would it help?

CJ
