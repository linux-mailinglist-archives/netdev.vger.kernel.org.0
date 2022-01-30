Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8FD4A35A9
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354351AbiA3KUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 05:20:22 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51678 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiA3KUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 05:20:20 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 0D57D20210D1;
        Sun, 30 Jan 2022 11:20:18 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 0D57D20210D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643538018;
        bh=uuFxwUjYEB9YWSaB5tddVsEP3CAIIFBX/Fppew8H2CY=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=BVjjPlCfQvKt9i0OCQ9GwoFA4onq1D8wguQwWRCCmup1i93d+OnaoTtvHDyOq29/H
         5snD/Owa0G+liXeRj9siZsHNs08flUG5G1SE9C+65i3R1KFMLrrZuAZ5n9chBJogYi
         E+C2MfeiEPZMzG2+GudWNpkua5t0rAp+UDXspF2FrOk3LJCCOAjJMxOu8ZpZxWlYUx
         snnGwQDnf/EMYI9LadzWyAyaLW5pKgnJZbF0U2qH27c8woo1Sm8VoSBYpmqLIczRdd
         YAK1RX8LNTB6MIM2BRU0QC0dFPBt6geLMoJkhkmzjg5cA52i+KODi9zzJHfXvY7tgd
         zmY3ShD4w3YZQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 01E57604E8F3F;
        Sun, 30 Jan 2022 11:20:18 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6On0QGEftcPY; Sun, 30 Jan 2022 11:20:17 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id DFE3E602243D4;
        Sun, 30 Jan 2022 11:20:17 +0100 (CET)
Date:   Sun, 30 Jan 2022 11:20:17 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <873661285.9347975.1643538017855.JavaMail.zimbra@uliege.be>
In-Reply-To: <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be>
References: <20220126184628.26013-1-justin.iurman@uliege.be> <20220126184628.26013-2-justin.iurman@uliege.be> <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be>
Subject: Re: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4026)
Thread-Topic: uapi: ioam: Insertion frequency
Thread-Index: /KQAm3mtUXGCfUqzavbopger1m5EcFGd2Fh0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> diff --git a/include/uapi/linux/ioam6_iptunnel.h
>>> b/include/uapi/linux/ioam6_iptunnel.h
>>> index 829ffdfcacca..462758cdba14 100644
>>> --- a/include/uapi/linux/ioam6_iptunnel.h
>>> +++ b/include/uapi/linux/ioam6_iptunnel.h
>>> @@ -30,6 +30,15 @@ enum {
>>>  enum {
>>>  	IOAM6_IPTUNNEL_UNSPEC,
>>>  
>>> +	/* Insertion frequency:
>>> +	 * "k over n" packets (0 < k <= n)
>>> +	 * [0.0001% ... 100%]
>>> +	 */
>>> +#define IOAM6_IPTUNNEL_FREQ_MIN 1
>>> +#define IOAM6_IPTUNNEL_FREQ_MAX 1000000
>> 
>> If min is 1 why not make the value unsigned?
> 
> The atomic_t type is just a wrapper for a signed int, so I didn't want
> to have to convert from signed to unsigned. I agree it'd sound better to
> have unsigned here, though.

Sorry, I figured out a cast is fine thanks to [1] which says:

"[...] the kernel uses -fno-strict-overflow
(which implies -fwrapv) and defines signed overflow to behave like
2s-complement.
Therefore, an explicitly unsigned variant of the atomic ops is strictly
unnecessary and we can simply cast, there is no UB. [...]"

  [1] https://www.kernel.org/doc/Documentation/atomic_t.txt
