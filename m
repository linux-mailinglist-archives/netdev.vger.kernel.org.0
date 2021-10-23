Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005084385ED
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 01:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhJWX21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 19:28:27 -0400
Received: from smtp.skoda.cz ([185.50.127.80]:35447 "EHLO smtp.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhJWX20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 19:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenaugust2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1635031564; x=1635636364;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iajyVca4EPY+fJSmDTnpEXKOB8KUMFch7nhdTm1VaPk=;
        b=BhWa+ZUaxYknli3SHzYkpNY8Iy/RU/mrDB0bJxtIt2MoEg0+uVCwJ80oGmkZZ7zO
        teNqD3e9CbcJJs5H6vDbFgSt24/t7Q1Q1uwwAwUzEuq4yIi0XMPb3xFbNIlJXKwX
        vBzX3l6Z/CemFsnPfIgHGr9UFynXyGXgdWcysP7cpdB865YSet2JehwzznkgbsEB
        4CAV0b1aB4heSsvrkhD/kI55W/MgTO5Gt/lBc7Kw/wWb1nU+3k0qQ1ftvcmOoUh+
        ipnAfs07nktScTshRzkIRQSfWqGrGrS+N3VZJk7wHHawwwV9MbpGThq63BJsVvOD
        Cl7c507fcRympmzSsrjmbQ==;
X-AuditID: 0a2a0137-1666f70000011b28-44-61749a0cfc7a
Received: from trnn1532h.skoda.cz (TRNN2396.skoda.cz [10.99.100.50])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp.skoda.cz (Mail Gateway) with SMTP id 71.46.06952.C0A94716; Sun, 24 Oct 2021 01:26:04 +0200 (CEST)
From:   Cyril Strejc <cyril.strejc@skoda.cz>
To:     willemdebruijn.kernel@gmail.com
Cc:     cyril.strejc@skoda.cz, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: multicast: calculate csum of looped-back and forwarded packets
Date:   Sun, 24 Oct 2021 01:26:08 +0200
Message-Id: <20211023232608.1095185-1-cyril.strejc@skoda.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
References: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42LhSk4x0uWZVZJosGSjjsXe11vZLeacb2Gx
        uLCtj9Xi2AIxi8U/NzA5sHpsWXmTyWPnrLvsHptWdbJ5vLhxkdXj8ya5ANYoLpuU1JzMstQi
        fbsErow/fRtYCn6JVXzsnc7YwPhYsIuRk0NCwERiTkMHSxcjF4eQwDwmiZvHtrKAJNgEtCTm
        dk5m7mLk4BARUJboXOIJYjILxEo8v2wOUiEsECGx8vd/VhCbRUBVorflOSOIzStgI/Hn3m1G
        iPHyEjMvfWcHsTkFAiU27v4HZgsJBEj8WfaMDaJeUOLkzCdgW5mB6pu3zmaewMg7C0lqFpLU
        AkamVYy8xbklBXrF2fkpiXrJVZsYQaGlxWi+g/HGKbdDjEwcjIcYJTiYlUR403KLE4V4UxIr
        q1KL8uOLSnNSiw8xSnOwKInzus/VSRQSSE8sSc1OTS1ILYLJMnFwSjUw8shckMpQfMp8IqI/
        4r7m/Ra/Wbz35iv7fV4nvk1jR2fzL0NXo9TuDr47mwLeCbB/8l9mymOpohzvcPZpy6Gq4l/X
        S1Qzbkd2XEsV7/r+fmOp9A+5Iw6pV/+yGoX52M1bLyhwOPG7wFW3f8yznm1g4HbeWPGnlY11
        z41vBfvnW9YVXy54VjVViaU4I9FQi7moOBEAE5PRXhsCAAA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 9:08 PM, Willem de Bruijn wrote:
>> We could fix this as follows:
>>
>> 1. Not set CHECKSUM_UNNECESSARY in dev_loopback_xmit(), because it
>>    is just not true.
>
> I think this is the right approach. The receive path has to be able to
> handle packets looped from the transmit path with CHECKSUM_PARTIAL
> set.

As You clarified, the receive path handles CHECKSUM_PARTIAL.

There is a problem with CHECKSUM_NONE -- the case when TX checksum
offload is not supported by a NIC. Kernel does not set
CHECKSUM_UNNECESSARY with a correct value of csum_level when a packet
is being prepared for transmission, but just set the CHECKSUM_NONE.

>> 2. I assume, the original idea behind setting CHECKSUM_UNNECESSARY in
>>    dev_loopback_xmit() is to prevent checksum validation of looped-back
>>    local multicast packets. We can adjust
>>    __skb_checksum_validate_needed() to handle this as the special case.
>>
>> Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
>> ---
>>  include/linux/skbuff.h | 4 +++-
>>  net/core/dev.c         | 1 -
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 841e2f0f5240..95aa0014c3d6 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -4048,7 +4048,9 @@ static inline bool __skb_checksum_validate_needed(struct sk_buff *skb,
>>                                                   bool zero_okay,
>>                                                   __sum16 check)
>>  {
>> -       if (skb_csum_unnecessary(skb) || (zero_okay && !check)) {
>> +       if (skb_csum_unnecessary(skb) ||
>> +           (zero_okay && !check) ||
>> +           skb->pkt_type == PACKET_LOOPBACK) {
>
> This should not be needed, as skb_csum_unnecessary already handles
> CHECKSUM_PARTIAL?
>

Still we need some solution for the CHECKSUM_NONE case which triggers
checksum validation.

>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 7ee9fecd3aff..ba4a0994d97b 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -3906,7 +3906,6 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>>         skb_reset_mac_header(skb);
>>         __skb_pull(skb, skb_network_offset(skb));
>>         skb->pkt_type = PACKET_LOOPBACK;
>> -       skb->ip_summed = CHECKSUM_UNNECESSARY;
>>         WARN_ON(!skb_dst(skb));
>>         skb_dst_force(skb);
>>         netif_rx_ni(skb);
>> --
>> 2.25.1
>>
>

Alternatively, we could solve the CHECKSUM_NONE case by a simple,
practical and historical compatible "TX->RX translation" of ip_summed
in dev_loopback_xmit(), which keeps CHECKSUM_PARTIAL and leaves
__skb_checksum_validate_needed() as is:

	if (skb->ip_summed == CHECKSUM_NONE)
		skb->ip_summed = CHECKSUM_UNNECESSARY;

or:
	if (skb->ip_summed != CHECKSUM_PARTIAL)
		skb->ip_summed = CHECKSUM_UNNECESSARY;


