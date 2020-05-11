Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E261CE90A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgEKX2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKX2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:28:03 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E6C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:28:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so2660644pgn.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ucol5IbLTP6u06Wtjgq3+uxk05B29oz3kzR4nXUwo+4=;
        b=J7rSJdlt0cUSeyW8XEaTCN8D4FKhKpssZZA4pzv7swU3T5eA0vie0oApA5Rbg3JJlF
         P8tDXtpZY46GJgTRrQSMmBBSLd0jufhi9unaHfDSSM324c3paEazdlHRU7o50bC2lbZC
         ANc7ot8UeVM8oAbj9bFHzV0F5SlPxq0H01BOGM2R80I4y5YquoT/ayoq2m/ANU+DKqcK
         TZiWCIzrFXeiIZ0TNkmKKBxmobVzVd04nN75AmCJOnjFurFr2140CGuRrDyp0vloL79t
         nAYbilT9ozljVbsS3tszC4QKDwooR3C9gVhVSIxqvhgbTZ8u/PKgIDEtMhPsRtG2HyXN
         OWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ucol5IbLTP6u06Wtjgq3+uxk05B29oz3kzR4nXUwo+4=;
        b=nbIyETC3LNVXL+o7i0geKO6+l8EZ1h5W0VuB7K9xzjhK5J7mM5yCbtUjM1ygFT/krz
         8Ya05WcSZVyLTx7XdVTCTsh5HjJoXX9PJIgxACnCI5ugKU1NMadRwWsg3RKEPQGkr4iC
         SCkc8iVwJPOngBikW4OsE2/Wb3FBeB+5XbCsE50vHs3mUSjdVO9WTKjTIonf/8owSkiT
         9y1CCTofnnPPQTwO2kfcx2Cj4PNdPJakwQyeXrHmx9AF4XTTM5g/CcZT2vPa4HMhHQfs
         utStxW/W7er5oi6rwecaztxUVd5BiV6z2cdw+/EcCaPCUoNkEgKZj/Jih9RInyfnCqmN
         pnuA==
X-Gm-Message-State: AGi0PuZCm+dfDtbf7V+79mahuAlg0COG4MlCxHD9Si0fEr4w8PiGTT70
        EaIW5yxprkAFJaevOklJLKA8CKaZ
X-Google-Smtp-Source: APiQypJUx5U45np/lZdfMfoJviiCzF7ubOttwzb8zZ4PPtW2D2xF1cfrxMxp4wDCZ/TtgE3W5a0Qdw==
X-Received: by 2002:a62:7981:: with SMTP id u123mr18704551pfc.200.1589239682716;
        Mon, 11 May 2020 16:28:02 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h13sm8813203pgm.69.2020.05.11.16.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 16:28:02 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] DSA: promisc on master, generic flow
 dissector code
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20200511202046.20515-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <525db137-0748-7ae1-ed7f-ee2c74820436@gmail.com>
Date:   Mon, 11 May 2020 16:28:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511202046.20515-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The initial purpose of this series was to implement the .flow_dissect
> method for sja1105 and for ocelot/felix. But on Felix this posed a
> problem, as the DSA headers were of different lengths on RX and on TX.
> A better solution than to just increase the smaller one was to also try
> to shrink the larger one, but in turn that required the DSA master to be
> put in promiscuous mode (which sja1105 also needed, for other reasons).
> 
> Finally, we can add the missing .flow_dissect methods to ocelot and
> sja1105 (as well as generalize the formula to other taggers as well).

On a separate note, do you have any systems for which it would be
desirable that the DSA standalone port implemented receive filtering? On
BCM7278 devices, the Ethernet MAC connected to the switch is always in
promiscuous mode, and so we rely on the switch not to flood the CPU port
unnecessarily with MC traffic (if nothing else), this is currently
implemented in our downstream kernel, but has not made it upstream yet,
previous attempt was here:

https://www.spinics.net/lists/netdev/msg544361.html

I would like to revisit that at some point.
-- 
Florian
