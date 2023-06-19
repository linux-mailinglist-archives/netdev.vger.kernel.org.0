Return-Path: <netdev+bounces-11968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 154D673578D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B93F82810FB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA43D10954;
	Mon, 19 Jun 2023 13:04:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D4AAD3C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:04:33 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE7B91;
	Mon, 19 Jun 2023 06:04:31 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 67F665C024E;
	Mon, 19 Jun 2023 09:04:31 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 19 Jun 2023 09:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1687179871; x=1687266271; bh=lo
	98U6NNyBvPDxCtGn35zLY8FueG6iIEIBGk0drXwXE=; b=z8vAYqIkQbtDax2PKx
	L8LhGaTy1GhwxG9wqCIXcXXnQHbMUXWvd1Ky5DGeRTcPvxCcSkU/dX55TLC5u+98
	n5iX7LtYlKFCVnAno9h33SkBL0bqf7V5MAqULGwNc25EEP3fE/N4v5dsNmannGCF
	E2X+qDPeLkzfy5WmEPJrQHi3Nu5xz8vDN1VhhG4ab6flmW9ZPRKTuuLlphsczOe1
	BH6L9prVMoy2oJBGr4gl5LFV4ubcdG7F1W1f1WCOtsOXxWGLifmEq+a17giEkF1R
	Yo5a9JS99/MMRDNZhlrbm+qzhLk2DRCqkFP3t1dS4knzMX7Vdfh/vYe1KZBVXdFx
	Y4qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1687179871; x=1687266271; bh=lo98U6NNyBvPD
	xCtGn35zLY8FueG6iIEIBGk0drXwXE=; b=ORVC3oKwUHMuI6QEg2EiPCIznXzPj
	Wn4rKkey5xpwg/caTm6VFHnI5vlgmDiNKII0YPSFFontMxuwuCbHvD92bnYFjH/B
	OOjcpwil6c6LQHvn+aREPLlYkdSqgSfRp0xQgvUreH0kZQuvryQivGzEhQpM6/aU
	qydt4cSAhKKMqcESudu1LAUGff8jhVbDEM26vw+tsd0McXfMgyIFMO39GzC7rPEJ
	8xu1AqQTmDCoPY1utIim9oDlDh42UJXrkwyeqrQBy7gvbXZOArQDY3qfw27Kme+i
	ejZUBxKglsYqyRn739fWW7JqQMZAFaYw+qJCA9IvahTe4yaAHuKaGp9jw==
X-ME-Sender: <xms:XlKQZHfNK5-eJRX4BUTuej2AWe8oyewiqpJEmPh0NNzfQ1HcH4eLzg>
    <xme:XlKQZNOB6QNODHEJecWl02dhOgXHGl7jHuYEapnX-r8_qemj3gW9zZMh-9wZTXCBA
    RjfGbHXLAPRf6pb59E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:XlKQZAgx9BRBvpOmx-m6dFA6dpopv2GUug69HB-WRFh6e3k2QScoPg>
    <xmx:XlKQZI98SbiQaili2D4ZePuoVRjq3LjmwfyxR-YKlzh-C4LvZmG3bA>
    <xmx:XlKQZDtHSo_ryleXBPzUB7Y9EYBs4YAYrv4GwV2gmY1nocg7s4A4tA>
    <xmx:X1KQZM8mU7c0nMRhQDu-uID-Yr9LvmbKnA-sOMeJYeBrZwzm3TUD7Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id C840CB60086; Mon, 19 Jun 2023 09:04:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-496-g8c46984af0-fm-20230615.001-g8c46984a
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <e3e9f246-5bf7-4868-aedb-0e194f52de5b@app.fastmail.com>
In-Reply-To: <7c448f02-4031-0a90-97e2-0cc663b0cff9@gmail.com>
References: <20230619091215.2731541-1-arnd@kernel.org>
 <20230619091215.2731541-3-arnd@kernel.org>
 <7c448f02-4031-0a90-97e2-0cc663b0cff9@gmail.com>
Date: Mon, 19 Jun 2023 15:04:10 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Edward Cree" <ecree.xilinx@gmail.com>, "Arnd Bergmann" <arnd@kernel.org>,
 "Martin Habets" <habetsm.xilinx@gmail.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: Netdev <netdev@vger.kernel.org>, linux-net-drivers@amd.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sfc: selftest: fix struct packing
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On Mon, Jun 19, 2023, at 12:25, Edward Cree wrote:
> On 19/06/2023 10:12, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> Three of the sfc drivers define a packed loopback_payload structure with an
>> ethernet header followed by an IP header. However, the kernel definition
>> of iphdr specifies that this is 4-byte aligned, causing a W=1 warning:
>> 
>> net/ethernet/sfc/siena/selftest.c:46:15: error: field ip within 'struct efx_loopback_payload' is less aligned than 'struct iphdr' and is usually due to 'struct efx_loopback_payload' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
>>         struct iphdr ip;
>> 
>> As the iphdr packing is not easily changed without breaking other code,
>> change the three structures to use a local definition instead.
>> 
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Duplicating the definition isn't the prettiest thing in the world; it'd
>  do for a quick fix if needed but I assume W=1 warnings aren't blocking
>  anyone, so maybe defer this one for now and I'll follow up soon with a
>  rewrite that fixes this more cleanly?  My idea is to drop the __packed
>  from the containing struct, make efx_begin_loopback() copy the layers
>  separately, and efx_loopback_rx_packet() similarly do something less
>  direct than casting the packet data to the struct.
>
> But I don't insist on it; if you want this fix in immediately then I'm
>  okay with that too.
>
>> ---
>>  drivers/net/ethernet/sfc/falcon/selftest.c | 21 ++++++++++++++++++++-
>>  drivers/net/ethernet/sfc/selftest.c        | 21 ++++++++++++++++++++-
>>  drivers/net/ethernet/sfc/siena/selftest.c  | 21 ++++++++++++++++++++-
>>  3 files changed, 60 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/sfc/falcon/selftest.c b/drivers/net/ethernet/sfc/falcon/selftest.c
>> index 6a454ac6f8763..fb7fcd27a33a5 100644
>> --- a/drivers/net/ethernet/sfc/falcon/selftest.c
>> +++ b/drivers/net/ethernet/sfc/falcon/selftest.c
>> @@ -40,7 +40,26 @@
>>   */
>>  struct ef4_loopback_payload {
>>  	struct ethhdr header;
>> -	struct iphdr ip;
>> +	struct {
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +		__u8	ihl:4,
>> +			version:4;
>> +#elif defined (__BIG_ENDIAN_BITFIELD)
>> +		__u8	version:4,
>> +			ihl:4;
>> +#else
>> +#error	"Please fix <asm/byteorder.h>"
>> +#endif
>> +		__u8	tos;
>> +		__be16	tot_len;
>> +		__be16	id;
>> +		__be16	frag_off;
>> +		__u8	ttl;
>> +		__u8	protocol;
>> +		__sum16	check;
>> +		__be32	saddr;
>> +		__be32	daddr;
>> +	} __packed ip; /* unaligned struct iphdr */
>>  	struct udphdr udp;
>>  	__be16 iteration;
>>  	char msg[64];
>> diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
>> index 3c5227afd4977..440a57953779c 100644
>> --- a/drivers/net/ethernet/sfc/selftest.c
>> +++ b/drivers/net/ethernet/sfc/selftest.c
>> @@ -43,7 +43,26 @@
>>   */
>>  struct efx_loopback_payload {
>>  	struct ethhdr header;
>> -	struct iphdr ip;
>> +	struct {
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +		__u8	ihl:4,
>> +			version:4;
>> +#elif defined (__BIG_ENDIAN_BITFIELD)
>> +		__u8	version:4,
>> +			ihl:4;
>> +#else
>> +#error	"Please fix <asm/byteorder.h>"
>> +#endif
>> +		__u8	tos;
>> +		__be16	tot_len;
>> +		__be16	id;
>> +		__be16	frag_off;
>> +		__u8	ttl;
>> +		__u8	protocol;
>> +		__sum16	check;
>> +		__be32	saddr;
>> +		__be32	daddr;
>> +	} __packed ip; /* unaligned struct iphdr */
>>  	struct udphdr udp;
>>  	__be16 iteration;
>>  	char msg[64];
>> diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
>> index 07715a3d6beab..b8a8b0495f661 100644
>> --- a/drivers/net/ethernet/sfc/siena/selftest.c
>> +++ b/drivers/net/ethernet/sfc/siena/selftest.c
>> @@ -43,7 +43,26 @@
>>   */
>>  struct efx_loopback_payload {
>>  	struct ethhdr header;
>> -	struct iphdr ip;
>> +	struct {
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +		__u8	ihl:4,
>> +			version:4;
>> +#elif defined (__BIG_ENDIAN_BITFIELD)
>> +		__u8	version:4,
>> +			ihl:4;
>> +#else
>> +#error	"Please fix <asm/byteorder.h>"
>> +#endif
>> +		__u8	tos;
>> +		__be16	tot_len;
>> +		__be16	id;
>> +		__be16	frag_off;
>> +		__u8	ttl;
>> +		__u8	protocol;
>> +		__sum16	check;
>> +		__be32	saddr;
>> +		__be32	daddr;
>> +	} __packed ip; /* unaligned struct iphdr */
>>  	struct udphdr udp;
>>  	__be16 iteration;
>>  	char msg[64];
>>

