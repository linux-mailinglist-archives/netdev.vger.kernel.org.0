Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976DF599464
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbiHSFWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345618AbiHSFV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:21:58 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DBEDA3D2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:21:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x19so4747909lfq.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ctMX1D3w2scxPFWMp1E0nCw34sRdrk40ueb8SwAoGec=;
        b=dtQHh0/yZmMu3q7MeNDpJEiJ6iMNyE0Upv4FDKYD2mMtI6wyqBQdJ/2nUJBdnOXxxc
         PNwuUm7T8u/n6i4QjUQ6Glb+l4BTjUqyDbhT2tQ7IJU8eazmoxLnX8zJpdfweE0A1ldn
         xmVc6Zk49zAfjC/8oHwOvkzqUSCqiEpi85OoP9s1y4AeFDBI+qUK/3tQPjvWHWpMuDzp
         K7jv9tKriEz5PxAhJkPPUym8wi4Z2PSAuk7Ue/ZUFbfNUo9U8kT/6dSqJrSGxNjuOmB4
         O4YgCm2HU02k+hI81vJBM7snIeNwlRYBmlLxKCPy03zCJGjZEN4/azsKr7TRBchuWuj0
         wvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ctMX1D3w2scxPFWMp1E0nCw34sRdrk40ueb8SwAoGec=;
        b=Zk/Pu7EWZcdQ6NgmVjDDDNIpA+ij1bBIQuFJY9T1y09V9xlY0QOUMNfxdk0ef4UyXb
         f8bquCxBvNt3la5i/dxUNw+Kvy7viSNe69O/8IB/9vNzdJN6ireRMtCOnLblvvXWCCHj
         t63IldJg7dpWIxnqyo64s2a7JEY3MVOK/eh4ig4jTtofljFiwfG71NJsz18xqhd2zp0E
         ic3xeQofJNg+82L9mCsMA9kyJZQo7SOdsRMQijShkQrQxLccqyfjQnqMVy4oywEAmf/y
         77aQvLUaN0mIcyDZcvLfpKwgSGJMzPNMdtZ0rhgI2Fa1zTflVV8YemYkqAVQqwNzxRv6
         NSLw==
X-Gm-Message-State: ACgBeo3nbNZivtCP3+/En/DloMMulGLXSbJncvSX/4d7Y9wKKJaRREI1
        5RGdyulbIeZMS5IYyBQaDmE=
X-Google-Smtp-Source: AA6agR7ESrSJ0AefoFuvyqkwq2I8In7uz1MsJhjD0WOrowoV1QpzV4nxBMpOUlhfVnKboIkt8x7qAQ==
X-Received: by 2002:a05:6512:3ca6:b0:48b:2767:4ed5 with SMTP id h38-20020a0565123ca600b0048b27674ed5mr1827528lfv.308.1660886515703;
        Thu, 18 Aug 2022 22:21:55 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id g8-20020a19e048000000b0048b17852938sm494144lfj.162.2022.08.18.22.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 22:21:55 -0700 (PDT)
Message-ID: <1821d27d-5e3d-b8bd-1a28-8c302665a0e9@gmail.com>
Date:   Fri, 19 Aug 2022 07:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next PATCH 1/3] dsa: Add ability to handle RMU frames.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-2-mattias.forsblad@gmail.com>
 <Yv40FjX9WTx8aBih@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yv40FjX9WTx8aBih@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-18 14:44, Andrew Lunn wrote:
>> +static int dsa_inband_rcv_ll(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +	int source_device, source_port;
>> +	struct dsa_switch *ds;
>> +	u8 *dsa_header;
>> +	int rcv_seqno;
>> +	int ret = 0;
>> +
>> +	if (!dev || !dev->dsa_ptr)
>> +		return 0;
>> +
>> +	ds = dev->dsa_ptr->ds;
>> +
>> +	dsa_header = skb->data - 2;
>> +
>> +	source_device = dsa_header[0] & 0x1f;
>> +	source_port = (dsa_header[1] >> 3) & 0x1f;
>> +	ds = dsa_switch_find(ds->dst->index, source_device);
> 
> You should never trust anything you receive from the network. Always
> validate it. ds could be a NULL pointer here, if source_device is
> bad. source_port could also be invalid. Hum, source port is not
> actually used?
> 
Agree, will fix. I think source_port is a remnant from an earlier
version, I will fix it. 

> We send RMU frames with a specific destination MAC address. Can we
> validate the destination address for frames we receive.
>

Yes, I'll add that.
 
>> +
>> +	/* Get rcv seqno */
>> +	rcv_seqno = dsa_header[3];
>> +
>> +	skb_pull(skb, DSA_HLEN);
>> +
>> +	if (ds->ops && ds->ops->inband_receive(ds, skb, rcv_seqno))
>> +		netdev_err(dev, "DSA inband: error decoding packet");
> 
> rate limit this print, so as to avoid the possibility of a DoS.
> 
>      Andrew

Ofc, will fix. Thanks.
