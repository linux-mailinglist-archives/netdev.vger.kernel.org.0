Return-Path: <netdev+bounces-2652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D45702DA6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F75D281024
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BD4C8DB;
	Mon, 15 May 2023 13:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D5B79D4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:10:24 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481E9269F;
	Mon, 15 May 2023 06:10:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ab032d9266so117773155ad.0;
        Mon, 15 May 2023 06:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684156201; x=1686748201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/pd7IH8iQ4KOAD+IGRJ2kpU4wAM/iguRWIx6a9cMo2M=;
        b=G4iss71zL/pAgQitGB/tMRoEosPEK6miLaIAsf+UOJ6GJwmgzEft4m29hABqk+l8nb
         F0V9nt4vcBsaCor6syjSCxACXETUI54Gx4QF5Au3YbYNbI9JcxejZEaFYYLpGkLVajIT
         Yq95TK1jpDTkoSp0xtSBIsHS4orOrXPKMfOsaSQNEYRoOqkjBmLuwwbOPPGM6S144M8I
         PqqTnHX6MAH7SKOS+JWuVZh30B7tBQutM/SSCblobe1HMnhLiQRXWbfI8N80RwfD15Ua
         U3k+05Xza9Dp3M+hlyyFsXF7pln+SC+Qr7Pizzd/EhUl285lvsKilqeWZwnMsndW0M6f
         Y8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684156201; x=1686748201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/pd7IH8iQ4KOAD+IGRJ2kpU4wAM/iguRWIx6a9cMo2M=;
        b=HheP3V51CiVUDKvnBq7PpUDgNqh00EZTHQlxvdwsTDhBld5bujc8C4f3f3wrpgeaA/
         4NGVmi7ff4spt0ncC6K4oKybek2Jur6beUNTZqPzPFF5lSem9xcaAcLBUtBVx0PCzP0Z
         lKOh0CFMon46tqPiBFp6sMjhO5cCuXga5WmYjPV8S02Xdw2dxRhe+YVgqEbzyzilmNCX
         lNU2ksywGYMMcJ4txMQu5t41Mhj5pefYYYUlKF2/Vn+xg1sc6/IWGGywfoS3UWtIY3Ck
         9Chib3rlTKIa/SUay2XmAvso9YyM4JLoRKLf5y/Jl2nguafzaHJKaTAL2wsLbjt+jupO
         sQlQ==
X-Gm-Message-State: AC+VfDw7ivLGy9xcckBOXpJzGn3ILYi4e3AdSraocROK7yDhuW00aBoU
	wtfOudgwo8j3/2yIEvJMYcA=
X-Google-Smtp-Source: ACHHUZ6tAg9ha1mMvaWILouNIGS4l8+m+gtn+R6sNaWAfRPEal9tyuaSig5YDstqPJlQfVeWhCPh7A==
X-Received: by 2002:a17:902:d2c2:b0:1ac:5dfa:3545 with SMTP id n2-20020a170902d2c200b001ac5dfa3545mr36716635plc.68.1684156200448;
        Mon, 15 May 2023 06:10:00 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-3.three.co.id. [180.214.233.3])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001a6a53c3b04sm13519333plx.306.2023.05.15.06.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 06:09:59 -0700 (PDT)
Message-ID: <b3bb9fc7-c7ec-ad32-5d6f-e6ba55e2dd7d@gmail.com>
Date: Mon, 15 May 2023 20:09:49 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Fwd: Freeze after resuming from hibernation (culprit is brcmfmac
 change?)
To: Hans de Goede <hdegoede@redhat.com>,
 Linux Regressions <regressions@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Wireless <linux-wireless@vger.kernel.org>,
 Broadcom 80211 Devices <brcm80211-dev-list.pdl@broadcom.com>,
 SHA cyfmac Subsystem <SHA-cyfmac-dev-list@infineon.com>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>,
 Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
 Franky Lin <franky.lin@broadcom.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>,
 Kalle Valo <kvalo@kernel.org>, julien.falque@gmail.com
References: <018f62d0-ee1d-9198-9c38-e45b10921e2e@gmail.com>
 <f629341e-5920-8061-6120-cb954d22ffe9@redhat.com>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <f629341e-5920-8061-6120-cb954d22ffe9@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 15:56, Hans de Goede wrote:
> Hi,
> 
> On 5/15/23 04:21, Bagas Sanjaya wrote:
>> Hi,
>>
>> I notice a regression report on bugzilla [1]. Quoting from it:
>>
>>>  julien.falque@gmail.com 2023-05-14 09:55:38 UTC
>>>
>>> Since a Kernel update a few weeks ago, my laptop freezes when resuming from hibernation. It seems to handle the resume process normally but at the moment I should see Gnome login screen, I either get a black screen with just a white underscore instead, or nothing displayed at all (no backlight). I can't do anything at that point and I have to hard reboot.
>>>
>>> Steps to reproduce:
>>> - hibernate
>>> - resume
>>> - wait until the resuming process should finish: black screen instead of e.g. Gnome's login screen
>>>
>>> journalctl gives nothing between the beginning of the resume and the crash, as if it never happened.
>>>
>>> I have a Dell XPS 15 (9550) with Arch Linux. The issue happens on linux (since v6.2.0 I think) but linux-lts (currently v6.1.28) is fine.
>>>
>>> A bisect on linux-git gave commit da6d9c8ecd00 as the cause of the problem.
>>
>> See bugzilla for the full thread.
>>
>> Julien: I asked you to also provide dmesg log as I don't know
>> what exactly happened, but you mentioned the culprit was
>> da6d9c8ecd00e2 ("wifi: brcmfmac: add firmware vendor info in driver info"),
>> which implies that the crash involves your wifi device. From my experience
>> though, GDM crashes are usually caused by xwayland.
>>
>> Anyway, I'm adding this to regzbot:
>>
>> #regzbot introduced: da6d9c8ecd00e2 https://bugzilla.kernel.org/show_bug.cgi?id=217442
>> #regzbot title: brcmfmac firmware vendor info addition triggers GDM crash on resuming from hibernation
> 
> da6d9c8ecd00e2 is known to cause a NULL pointer deref on resume,
> which is likely what is happening here. This is fixed by:
> 
> https://lore.kernel.org/regressions/20230510141856.46532-1-hdegoede@redhat.com/
> 
> This patch is ready for merging and is waiting for the wireless-maintainer
> to merge it and send it to Linus.
> 

OK, thanks for the fixup!

#regzbot fix: wifi: brcmfmac: Check for probe() id argument being NULL

-- 
An old man doll... just what I always wanted! - Clara


