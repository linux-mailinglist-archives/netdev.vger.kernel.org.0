Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA320A0C8
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405357AbgFYOZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:25:57 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56452 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405189AbgFYOZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:25:57 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D12202005A;
        Thu, 25 Jun 2020 14:25:55 +0000 (UTC)
Received: from us4-mdac16-14.at1.mdlocal (unknown [10.110.49.196])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CE7B6800A7;
        Thu, 25 Jun 2020 14:25:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 596CA100076;
        Thu, 25 Jun 2020 14:25:55 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D8C24280079;
        Thu, 25 Jun 2020 14:25:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 15:25:47 +0100
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexander Lobakin <alobakin@dlink.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20200624210606.GA1362687@zx2c4.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <948c5844-b8e4-81d3-b5eb-b13b1d3cda38@solarflare.com>
Date:   Thu, 25 Jun 2020 15:25:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200624210606.GA1362687@zx2c4.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25502.003
X-TM-AS-Result: No-8.467000-8.000000-10
X-TMASE-MatchedRID: 6lay9u8oTUP4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizz5+tteD5RzhSM5
        wlSREDM/WmsJv3fWRTB/t5tveyBGENQ2aCZEo62uW1M77Gh1ugYCn5QffvZFlZm3TxN83Lo4xhj
        hqpdN+tOgsFZCbdeTipGMbxV80b6VapfXOeR2mRBfYa9W9OjitUqAhuLHn5fEHdFjikZMLIdj8X
        zdqXhnXgwF8/THlfq/yhwb4lo9EEbRcG2uoPA4K1D5LQ3Tl9H74OCVFpLw5QdjEZl+QzZVx462G
        g+W5SqYvTmxe72H2fw0bxihdDeK0UhOq1If1JZJolVO7uyOCDWXGEdoE+kH/xlLPW+8b7SaLxCe
        axJSK3nhSunPCuGncBjGorU1NmcepjulPTq1lMjQeUylZ/mLlx5FmvZzFEQu4y4k0rGe+U1+Dha
        0AlenCaA8+iTsk6pAX7bicKxRIU23sNbcHjySQd0H8LFZNFG7CKFCmhdu5cWiItBUvtSBTuEj2l
        W5ghb68OX2rXTBoSTUKzkd80eTXBWEjKJBN/KG2Y3fBwwcQFREa0tj12CQNy7wfafhNZfoX+VGu
        9Js0FqigEHy7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU56oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.467000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25502.003
X-MDID: 1593095155-7j6FC8I8iKWF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/06/2020 22:06, Jason A. Donenfeld wrote:
> Hi Alexander,
>
> This patch introduced a behavior change around GRO_DROP:
>
> napi_skb_finish used to sometimes return GRO_DROP:
>
>> -static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
>> +static gro_result_t napi_skb_finish(struct napi_struct *napi,
>> +				    struct sk_buff *skb,
>> +				    gro_result_t ret)
>>  {
>>  	switch (ret) {
>>  	case GRO_NORMAL:
>> -		if (netif_receive_skb_internal(skb))
>> -			ret = GRO_DROP;
>> +		gro_normal_one(napi, skb);
>>
> But under your change, gro_normal_one and the various calls that makes
> never propagates its return value, and so GRO_DROP is never returned to
> the caller, even if something drops it.
This followed the pattern set by napi_frags_finish(), and is
 intentional: gro_normal_one() usually defers processing of
 the skb to the end of the napi poll, so by the time we know
 that the network stack has dropped it, the caller has long
 since returned.
In fact the RX will be handled by netif_receive_skb_list_internal(),
 which can't return NET_RX_SUCCESS vs. NET_RX_DROP, because it's
 handling many skbs which might not all have the same verdict.

When originally doing this work I felt this was OK because
 almost no-one was sensitive to the return value — almost the
 only callers that were were in our own sfc driver, and then
 only for making bogus decisions about interrupt moderation.
Alexander just followed my lead, so don't blame him ;-)

> For some context, I'm consequently mulling over this change in my code,
> since checking for GRO_DROP now constitutes dead code:
Incidentally, it's only dead because dev_gro_receive() can't
 return GRO_DROP either.  If it could, napi_skb_finish()
 would pass that on.  And napi_gro_frags() (which AIUI is the
 better API for some performance reasons that I can't remember)
 can still return GRO_DROP too.

However, I think that incrementing your rx_dropped stat when
 the network stack chose to drop the packet is the wrong
 thing to do anyway (IMHO rx_dropped is for "there was a
 packet on the wire but either the hardware or the driver was
 unable to receive it"), so I'd say go ahead and remove the
 check.

HTH
-ed
