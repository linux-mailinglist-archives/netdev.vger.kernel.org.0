Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CEA41C43
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 08:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfFLGcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 02:32:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37783 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbfFLGcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 02:32:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so8185263pfa.4;
        Tue, 11 Jun 2019 23:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OZ+yC7LmAgzBV860nbEWGVmK+NhL+LSi4XpwmZSTZ0M=;
        b=HzX5XPpnQ+ru5hys4B91jhAn0h9r44bGbQT4hnP17W0tEHyfjcSwjqYs+v8k8KaDjb
         8yaMse4P0PgudcmifD0vyijp7xE609LQZil9XTER70cZTHJCL+dekb28EpAc6KWR3X1Y
         cOnK/dEP5L3PpQRvpwZbuJGRk2w7VqjpbVcgKyhhtlRNo7OKEQMQoqdCE6gdmKEMBGvO
         4dmx/aB3ormdjQNCd3VFW6wtMbrWqObX0c7KGypqCNqXO8ILCbrNGyDAHKzyi9ce3Kjv
         pshYYKM7dGWJ9aYW4x9CXQN3P0UI20cjZhNF0mwb6gSoOP9Tz0uGxEgpqoy4dJo/IyKr
         zexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OZ+yC7LmAgzBV860nbEWGVmK+NhL+LSi4XpwmZSTZ0M=;
        b=jrXweqVMQ+uMi6yVOGqZd0qYzCZeIXqZRLsts0qnnTyQy4j2D1kZVTrU+z5wJWZIRA
         hecjgYpB0ZwWXcMucAz79eokxQDOHoRSNwedKKmOMo7kXZ+Gg+X2GuhcaTlTnaSt053G
         w9R5VlbHLKV2Eyh2zGz2lJw5MsFd8TXNc+kWIJvbDBy9sZOPvnrcbJzvRSuN2+TESJEN
         GS5Avw+rE3tN+zhoZfLT7jTkdSpE+zv+t8fWgCW3hUf1/G8F5UZz1HykUrmtYEaD4USE
         NOrkH5ABwXQPCi0WEgQqrDvd7ABHzzpZzf8Ia9D/GtxLrw1gLEn+PKGp71ZKVIazt3e3
         +S4A==
X-Gm-Message-State: APjAAAXfyFZegi7EQDj+o1D0pg8F/PGW3Lo+NycTM/S/e5+snZzpj+y2
        nHcJj16wcBAQd0foyww1Hdc=
X-Google-Smtp-Source: APXvYqxmzfggnMHnVv6UIcB+MEvyCcyy/9yUuTo3xp2sO7XEYH/3uAi2ikci/nu9NIT/0MtNMi3hVw==
X-Received: by 2002:a65:4086:: with SMTP id t6mr23153451pgp.155.1560321120889;
        Tue, 11 Jun 2019 23:32:00 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id r4sm4118576pjd.28.2019.06.11.23.31.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 23:32:00 -0700 (PDT)
Subject: Re: [PATCH net] net: ethtool: Allow matching on vlan CFI bit
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
References: <20190611155456.15360-1-maxime.chevallier@bootlin.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <e4017b1b-56ac-7853-ea81-f89a7f5c9890@gmail.com>
Date:   Wed, 12 Jun 2019 15:31:54 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611155456.15360-1-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/12 0:54, Maxime Chevallier wrote:
> Using ethtool, users can specify a classification action matching on the
> full vlan tag, which includes the CFI bit.
> 
> However, when converting the ethool_flow_spec to a flow_rule, we use
> dissector keys to represent the matching patterns.
> 
> Since the vlan dissector key doesn't include the CFI bit, this
> information was silently discarded when translating the ethtool
> flow spec in to a flow_rule.
> 
> This commit adds the CFI bit into the vlan dissector key, and allows
> propagating the information to the driver when parsing the ethtool flow
> spec.
> 
> Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
> Reported-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> Hi all,
> 
> Although this prevents information to be silently discarded when parsing
> an ethtool_flow_spec, this information doesn't seem to be used by any
> driver that converts an ethtool_flow_spec to a flow_rule, hence I'm not
> sure this is suitable for -net.
> 
> Thanks,
> 
> Maxime
> 
>   include/net/flow_dissector.h | 1 +
>   net/core/ethtool.c           | 5 +++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 7c5a8d9a8d2a..9d2e395c6568 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -46,6 +46,7 @@ struct flow_dissector_key_tags {
>   
>   struct flow_dissector_key_vlan {
>   	u16	vlan_id:12,
> +		vlan_cfi:1,

Current IEEE 802.1Q defines this bit as DEI not CFI, so IMO this should be
vlan_dei.

Toshiaki Makita
