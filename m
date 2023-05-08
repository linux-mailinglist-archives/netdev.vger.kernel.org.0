Return-Path: <netdev+bounces-825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 011736FA2EF
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F1DF1C2097D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 09:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DAB13AE4;
	Mon,  8 May 2023 09:04:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AF3C22
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:04:19 +0000 (UTC)
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A81FE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:03:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 63554220002;
	Mon,  8 May 2023 11:03:38 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
	by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u8vqnSyyUOLc; Mon,  8 May 2023 11:03:37 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:dc7a:1055:89dc:b0a6] (unknown [IPv6:2a01:8b81:5400:f500:dc7a:1055:89dc:b0a6])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 07617220001;
	Mon,  8 May 2023 11:03:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1683536617;
	bh=ysnvZMOs7sPhAsyADt1J2PZuBDb7uNb5ebUTUAC7iVw=;
	h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
	b=YnJ+Ho3MbvwM4Fmcrsi0RcbaTFJA2E4H52zrpClbAqs7sWOT2XVAmCxgyJmoV4jWo
	 Gz7IoGk72Tqb4rT+c6pvD8KWRIyBMKTJB3ScvEP9VZInzbIxANBESrLvtLfHfE6XSv
	 AAD72MHLyc5U1jsvqqMhAPyqlt4IWIDMjj/jrZg0FQqmWwSpwlZKGfH1jPF2twgyQy
	 FFrJjSZf82V7TrH5rUUXZPJblZJoUbA14G/zSiuYPUjTVoFoxvZgeB6BfpVxyyNGfL
	 BoZ0AVkBWyknBVYCA+4/ZzX1BbfgCyhJvtgRmsp64IrsXrG3gH07igiNDhpMX43pUc
	 yFy6iBOeza9AA==
Message-ID: <c29e3424-f6ef-4d38-e150-fcf82d364ad2@strongswan.org>
Date: Mon, 8 May 2023 11:03:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, de-CH-frami
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
 <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
 <ZFiPyZvW2PhPZHlv@gauss3.secunet.de>
From: Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH ipsec] xfrm: Reject optional tunnel/BEET mode templates in
 outbound policies
In-Reply-To: <ZFiPyZvW2PhPZHlv@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08.05.23 07:59, Steffen Klassert wrote:
> On Fri, May 05, 2023 at 12:16:16PM +0200, Tobias Brunner wrote:
>> xfrm_state_find() uses `encap_family` of the current template with
>> the passed local and remote addresses to find a matching state.
>> If an optional tunnel or BEET mode template is skipped in a mixed-family
>> scenario, there could be a mismatch causing an out-of-bounds read as
>> the addresses were not replaced to match the family of the next template.
>>
>> While there are theoretical use cases for optional templates in outbound
>> policies, the only practical one is to skip IPComp states in inbound
>> policies if uncompressed packets are received that are handled by an
>> implicitly created IPIP state instead.
>>
>> Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> 
> Your patch seems to be corrupt:
> 
> warning: Patch sent with format=flowed; space at the end of lines might be lost.
> Applying: af_key: Reject optional tunnel/BEET mode templates in outbound policies
> error: corrupt patch at line 18

Sorry about that, I'll resend.

> Also, please add a 'Fixes' tag, so that it can be backported.

What should the target commit be?  I saw you used 1da177e4c3f4
("Linux-2.6.12-rc2") in your fix, but maybe the more recent 8444cf712c5f
("xfrm: Allow different selector family in temporary state") would fit
better as that changed `family` to `encap_family` in
`xfrm_state_find()`?  (I guess it doesn't matter in practice as 2.6.36
is way older than any LTS kernel this will get backported to.)

Regards,
Tobias


