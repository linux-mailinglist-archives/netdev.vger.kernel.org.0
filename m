Return-Path: <netdev+bounces-12038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59777735C3F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 146922811A6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4301118C;
	Mon, 19 Jun 2023 16:41:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEA322E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:41:53 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F70F9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:41:52 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f90b8ace97so24057845e9.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1687192911; x=1689784911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ibNl8hagn3rTly8LUTpZEDxxRnM23ysNCd6OX53mne8=;
        b=kPezCUnVg3j3Fk/Uq6JUrVFKWzbGW0Ll1GLgoW75fYv7O7ORrpHKAOsmnXohdQ8auu
         vjOZvJTe/A1C63Z2PX4W56gGJs7dtF3urgNos6T1fqfLXqxrkdUDzAkxPPCWcnS8OTgs
         TyYJKnOiu6P08SHtX1spdj7HxAOyu9KuLjV11E+od3lm66RbWTwsN66KjsQuRZTuOuCv
         agl2UYrFCg3TiV4NvhX0CQkvWHdI5qlq4z2P84XyaVM+bWAg1UfNmQuqKfeBiCJgEZg2
         XGWpHyOovrfhUHkqN2qftnVxpIqAl403XTtAbjOlvnnDGKAZXo6CWWOJ73rTFyBGjqtZ
         rIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687192911; x=1689784911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibNl8hagn3rTly8LUTpZEDxxRnM23ysNCd6OX53mne8=;
        b=P9IWfO1w2K0NTlAjN+IXnZxwXYTGpNAuGSTLgdzqj0GxaS6m5H1U1ExFOJbQBiHTk7
         xZZSy3uqm4XTD6UTLRwdapre2p8fAj26MkA7VpM5tq4QPsYyHEwjOewx+NK6ynw+/0t5
         qMJfq3T22H2azmUG7/gsFAF4l/IfRy2jTwZ1XIMbbymocYXxYiFb9eiD/ZEQ4zYX0Q8q
         vTR7iyJn4i6YzoIrXUJSTCT+6Wtl+OLoDZb6CW9GgqQBAlRAlnpeyWb90tFzEQCiTifw
         YkNujmwmdYDpySxcDDG2Ee7SIJstahF9hc5j1wsijKlGBJV0fSHPlxV7xY2RC326g5rU
         YWOw==
X-Gm-Message-State: AC+VfDwkHK6RyuVpbDWo+vVwumjLmBJx5rDrwSGQMKabARnuij8qxyuV
	NhRuL+BGl6VcgpLtdQjcZY973Q==
X-Google-Smtp-Source: ACHHUZ5YA9SJlPEJfePsXwU8aR532C5VQlv4CirPkKCK3EEV97r3WWChCB1H8ckLL/a74gTEf5Eidg==
X-Received: by 2002:a1c:f709:0:b0:3f6:9634:c8d6 with SMTP id v9-20020a1cf709000000b003f69634c8d6mr9034792wmh.18.1687192910721;
        Mon, 19 Jun 2023 09:41:50 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id z8-20020a05600c220800b003f9b12b1598sm3232781wml.22.2023.06.19.09.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:41:50 -0700 (PDT)
Message-ID: <9ae5c977-ff9c-591d-3a32-ca9dd00d531e@arista.com>
Date: Mon, 19 Jun 2023 17:41:48 +0100
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
To: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
 Ard Biesheuvel <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>,
 Dan Carpenter <error27@gmail.com>, David Laight <David.Laight@aculab.com>,
 Dmitry Safonov <0x7f454c46@gmail.com>, Donald Cassidy <dcassidy@redhat.com>,
 Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
References: <20230614230947.3954084-1-dima@arista.com>
 <20230614230947.3954084-5-dima@arista.com>
 <85077827-d11d-d3e6-0d23-9e60974cad0f@kernel.org>
 <1c2537d0-cf64-c010-fec6-9fa9ad758f42@arista.com>
From: Dmitry Safonov <dima@arista.com>
In-Reply-To: <1c2537d0-cf64-c010-fec6-9fa9ad758f42@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 17:31, Dmitry Safonov wrote:
> Hi David,
> 
> On 6/18/23 18:50, David Ahern wrote:
>> On 6/14/23 4:09 PM, Dmitry Safonov wrote:
>>> Be as conservative as possible: if there is TCP-MD5 key for a given peer
>>> regardless of L3 interface - don't allow setting TCP-AO key for the same
>>> peer. According to RFC5925, TCP-AO is supposed to replace TCP-MD5 and
>>> there can't be any switch between both on any connected tuple.
>>> Later it can be relaxed, if there's a use, but in the beginning restrict
>>> any intersection.
>>>
>>> Note: it's still should be possible to set both TCP-MD5 and TCP-AO keys
>>> on a listening socket for *different* peers.
>>
>> Does the testsuite cover use of both MD5 and AO for a single listening
>> socket with different peers and then other tests covering attempts to
>> use both for a same peer?
> 
> Thanks for the question, I have written the following tests for
> AO/MD5/unsigned listening socket [1]:
> 
> 1. Listener with TCP-AO key, which has addr = INADDR_ANY
> 2. Listener with TCP-MD5 key, which has tcpm_addr = INADDR_ANY
> 3. Listener without any key
> 
> Then there's AO_REQUIRED thing, which BGP folks asked to introduce,
> which is (7.3) from RFC5925, an option that is per-ao_info, which makes
> such socket accepting only TCP-AO enabled segments.
> 
> So, 4. Listener with TCP-AO, AO_REQUIRED flag.
> 
> And then, going to non-INADDR_ANY:
> 5. Listener with TCP-AO and TCP-MD5 keys for different peers.
> 
> Here again, for each of AO/MD5/unsigned methods, attempt to connect:
> 6. outside of both key peers
> 7. inside correct key: i.e. TCP-MD5 client to TCP-MD5 matching key
> 8. to a wrong key: i.e. TCP-AO client to TCP-MD5 matching key
> 
> And another type of checks are the ones expecting *setsockopt()* to fail:
> 9. Adding TCP-AO key that matches the same peer as TCP-MD5 key
> 10. The reverse situation
> 11. Adding TCP-MD5 key to AO_REQUIRED socket
> 12. Setting AO_REQUIRED on a socket with TCP-MD5 key
> 13. Adding TCP-AO key on already established connection without any key

Oh, yeah, forgot to mention, there are another 2 tests for TCP_CLOSE
socket (just a new one), that has both TCP-AO and TCP-MD5 keys and tries
to call connect(). In discussion with the team, it seems really
unexpected situation and better to force userspace to remove either AO
or MD5 key before calling connect(). Those from the output in [1] are:

> ok 39 AO+MD5 server: client with both [TCP-MD5] and TCP-AO keys:
connect() was prevented
> ok 40 AO+MD5 server: client with both TCP-MD5 and [TCP-AO] keys:
connect() was prevented

> 
> And then another bunch of tests that check TCP-AO/TCP-MD5/unsigned
> interaction in non/default VRFs.
> I think the output of selftest [1] is more-or-less self-descriptive,
> correct me if I could improve that.
> 
> [1]
> https://github.com/0x7f454c46/linux/commit/d7b321f2b5a481e5ff0e80e2e0b3503b1ddb9817

Thanks,
          Dmitry


