Return-Path: <netdev+bounces-12040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCB0735C90
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8CC21C20B34
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7524912B62;
	Mon, 19 Jun 2023 16:59:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B34111A9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:59:16 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6351C187;
	Mon, 19 Jun 2023 09:59:14 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f900cd3f96so24615245e9.2;
        Mon, 19 Jun 2023 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687193953; x=1689785953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcgbxV13XHEhA/N3Ft+cQbY1ssnVPurgnzZbLT5IVvg=;
        b=rmSHozbtFZwsTQuNS4qaaFdpHUAsEWtn1O06M+v2RH9pZegxdEClx+Os8kKZ5mv0hD
         Mzg8unGu/utXpqiKwaprjvmUf6qVbRXbrQhonesupUatGu3LWXurCl3Fo2THWDrEL5W3
         qTKPTNa7N1gj32TLPZUmXKusTyLK9o6/dKUVWLH3HODNcEz6XHiDwgEfe+FSykhDf+i3
         UjFo0DqIMvuXYY/BWhqHFy31B7u0fcnClGmiFiyc5itKTEtOrtaP1sWv8BY7c5nLZrk8
         3xR9KPCXfS8eZc2Qr86IJjQ1XDqCsBxtYPfgozJIiir58bi1leS4phMWm2sz/xjsu5tL
         CpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687193953; x=1689785953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcgbxV13XHEhA/N3Ft+cQbY1ssnVPurgnzZbLT5IVvg=;
        b=Ea4u4W6GkSBb0Mw33PGdfWYuATh85QdBxMy8S+aOEoYlLR4Rrmb2iPERivPaBDmJTL
         LkMb0dxdbp7g5MQIZfw+U6NU8BSHrwHNadClEZuauKiB+sGf01AR+3/izSwgRev5lQCn
         NnCdWCUvZeIL3yN8daOeOtyoXEyDM2LPBQ7oay6oAc3cmUf/Dw60qXPlMlKpa+CUZlgw
         EHG21p0Kbq/jEzH+2q+8gJ6iBD30ihGrYs4DWpWGNeX5+eTibwxfriOvhFqSgbK0sEFo
         FcbekOi4nBewMEdyEn/29MIfXewPDSuxn1EmDTDafkcSNYkG6akixgdoUSwLAgi1GaAY
         7fVA==
X-Gm-Message-State: AC+VfDyCXX1U0l/KIQbfJQ3CuiqNKJYg+FfawrBBhWRNEnJJMe5AKKqJ
	rz0OPVoz9qJEuj0wcjvwKu2hlLvC9ehC0A==
X-Google-Smtp-Source: ACHHUZ6ouUZ32BpR+60TvJfH8oq0bL3RBnN5kq+q9HK67ea5Ripk9XfYfuNAYUcPG7Of/DSSqdCBnQ==
X-Received: by 2002:a05:600c:aca:b0:3f6:4cfc:79cb with SMTP id c10-20020a05600c0aca00b003f64cfc79cbmr7150653wmr.31.1687193952643;
        Mon, 19 Jun 2023 09:59:12 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id p21-20020a7bcc95000000b003f739a8bcc8sm229171wma.19.2023.06.19.09.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:59:12 -0700 (PDT)
Message-ID: <8f464cee-55e4-47c3-3666-629ed548167a@gmail.com>
Date: Mon, 19 Jun 2023 17:59:10 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 04/22] net/tcp: Prevent TCP-MD5 with TCP-AO being set
Content-Language: en-US
To: Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
 Ard Biesheuvel <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>,
 Dan Carpenter <error27@gmail.com>, David Laight <David.Laight@aculab.com>,
 Donald Cassidy <dcassidy@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Francesco Ruggeri <fruggeri05@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
References: <20230614230947.3954084-1-dima@arista.com>
 <20230614230947.3954084-5-dima@arista.com>
 <85077827-d11d-d3e6-0d23-9e60974cad0f@kernel.org>
 <1c2537d0-cf64-c010-fec6-9fa9ad758f42@arista.com>
 <9ae5c977-ff9c-591d-3a32-ca9dd00d531e@arista.com>
From: Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <9ae5c977-ff9c-591d-3a32-ca9dd00d531e@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 17:41, Dmitry Safonov wrote:
> On 6/19/23 17:31, Dmitry Safonov wrote:
>> Hi David,
>>
>> On 6/18/23 18:50, David Ahern wrote:
>>> On 6/14/23 4:09 PM, Dmitry Safonov wrote:
>>>> Be as conservative as possible: if there is TCP-MD5 key for a given peer
>>>> regardless of L3 interface - don't allow setting TCP-AO key for the same
>>>> peer. According to RFC5925, TCP-AO is supposed to replace TCP-MD5 and
>>>> there can't be any switch between both on any connected tuple.
>>>> Later it can be relaxed, if there's a use, but in the beginning restrict
>>>> any intersection.
>>>>
>>>> Note: it's still should be possible to set both TCP-MD5 and TCP-AO keys
>>>> on a listening socket for *different* peers.
>>>
>>> Does the testsuite cover use of both MD5 and AO for a single listening
>>> socket with different peers and then other tests covering attempts to
>>> use both for a same peer?
>>
>> Thanks for the question, I have written the following tests for
>> AO/MD5/unsigned listening socket [1]:
>>
>> 1. Listener with TCP-AO key, which has addr = INADDR_ANY
>> 2. Listener with TCP-MD5 key, which has tcpm_addr = INADDR_ANY
>> 3. Listener without any key
>>
>> Then there's AO_REQUIRED thing, which BGP folks asked to introduce,
>> which is (7.3) from RFC5925, an option that is per-ao_info, which makes
>> such socket accepting only TCP-AO enabled segments.
>>
>> So, 4. Listener with TCP-AO, AO_REQUIRED flag.
>>
>> And then, going to non-INADDR_ANY:
>> 5. Listener with TCP-AO and TCP-MD5 keys for different peers.
>>
>> Here again, for each of AO/MD5/unsigned methods, attempt to connect:
>> 6. outside of both key peers
>> 7. inside correct key: i.e. TCP-MD5 client to TCP-MD5 matching key
>> 8. to a wrong key: i.e. TCP-AO client to TCP-MD5 matching key
>>
>> And another type of checks are the ones expecting *setsockopt()* to fail:
>> 9. Adding TCP-AO key that matches the same peer as TCP-MD5 key
>> 10. The reverse situation
>> 11. Adding TCP-MD5 key to AO_REQUIRED socket
>> 12. Setting AO_REQUIRED on a socket with TCP-MD5 key
>> 13. Adding TCP-AO key on already established connection without any key
> 
> Oh, yeah, forgot to mention, there are another 2 tests for TCP_CLOSE
> socket (just a new one), that has both TCP-AO and TCP-MD5 keys and tries
> to call connect(). In discussion with the team, it seems really
> unexpected situation and better to force userspace to remove either AO
> or MD5 key before calling connect(). Those from the output in [1] are:
> 
>> ok 39 AO+MD5 server: client with both [TCP-MD5] and TCP-AO keys:
> connect() was prevented
>> ok 40 AO+MD5 server: client with both TCP-MD5 and [TCP-AO] keys:
> connect() was prevented

And while starring at the selftest results, I noticed in the output
sample a copy-n-paste typo for VRFs, this:
> ok 60 VRF: TCP-AO key (l3index=0) + TCP-MD5 key (no l3index)
> ok 61 VRF: TCP-MD5 key (no l3index) + TCP-AO key (l3index=0)

Should be read as
> ok 60 VRF: TCP-AO key (l3index=0) + TCP-MD5 key (l3index=N)
> ok 61 VRF: TCP-MD5 key (l3index=N) + TCP-AO key (l3index=0)

(those checks are corresponding to the table in VRF-support commit [2])


>> And then another bunch of tests that check TCP-AO/TCP-MD5/unsigned
>> interaction in non/default VRFs.
>> I think the output of selftest [1] is more-or-less self-descriptive,
>> correct me if I could improve that.
>>
>> [1]
>> https://github.com/0x7f454c46/linux/commit/d7b321f2b5a481e5ff0e80e2e0b3503b1ddb9817

[2]
https://lore.kernel.org/all/20230614230947.3954084-22-dima@arista.com/T/#u

Thanks,
             Dmitry


