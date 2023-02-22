Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8569F70F
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBVOtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBVOsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:48:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806482A144;
        Wed, 22 Feb 2023 06:48:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id r7so7828274wrz.6;
        Wed, 22 Feb 2023 06:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/H5cXIcctpxuO6XLoIIrNNpAMDNGx1acKsnsc8cjOBI=;
        b=X6F6vXJSI7fE48tSsmc8px2WHBItnvLfRj0FPikkWKYinpqHq/WhSENoymEdv3VKDY
         dbBZtpjOwtaAC1flDPnxpEWSuaE6a3imgonzTJjLz/lBdjRS5pw7cpG5EutI1LbV1A3U
         b/vfDTdJYfLmyHJMPvyEWgNFUZK1T6IMyvURzA9VDqYWUFDzXgqzjJIgLJpoo4VDyluT
         /Lv1rktpFjL4dnjWoT77mGmDgdyRgINj3BLgatXS32Mqp4qWUbi/utsJT2ZYccYAsUKf
         SnwCIi/OVpb1o57cAqYlsjNWaa16h6TIOPsusBb5S2y2l0NATxYCC0o3pV94sPnSor1E
         zprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/H5cXIcctpxuO6XLoIIrNNpAMDNGx1acKsnsc8cjOBI=;
        b=5/b19j0x3dk68Akpc4ICTuNmtPSxeBGXGwq4I71qY+s3MTTUNKn3WFMvRiCBo7WA26
         1kKG0V+VFO7n2dtzFKeuW2qt4misE7WQYCZ5hNeHuxOvb/tvlNfyYWXrqoqmc5XouACH
         jGpWXuZzn4oTwcRTubbVWeZ8Uk0gsL9GEkfbRqQsa7BQkvxtISKjbRBgLn2ehEW6GCOJ
         XGcdmKojtikGUe9p9yJlnakB7PEB5Nq9thVHjbzzzX3wucPCfLGUChfQoFjUW9bF8U6w
         FP3eNpCcIlzkGvM80D9VP6Mqdyh+ryT3oSa1yOeoDU+ooHlQkdfdvxgv4xrdX48RFGER
         19EQ==
X-Gm-Message-State: AO0yUKU1MrR6PkhiwQG76LUDeJ8m44FSxujC8sa+H7OA1iHgszhljdlX
        ln3fUVMGqTQCNtSdWo0pim0=
X-Google-Smtp-Source: AK7set+I5tZ84a+EnX/rblZEgPfxgF0MY4/n2ZBFatUvW+hrorc/BWVRXkyDqlEzwrqtORRlT1rgnA==
X-Received: by 2002:adf:f3c2:0:b0:2c6:e8f9:b661 with SMTP id g2-20020adff3c2000000b002c6e8f9b661mr7287136wrp.52.1677077290527;
        Wed, 22 Feb 2023 06:48:10 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d4ed1000000b002c4084d3472sm4413786wrv.58.2023.02.22.06.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:48:10 -0800 (PST)
Date:   Wed, 22 Feb 2023 15:47:46 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230222144743.GA12416@debian>
References: <20230130130047.GA7913@debian>
 <20230130130752.GA8015@debian>
 <836bc0f5-004b-3b7d-d0d7-b70b030977c6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <836bc0f5-004b-3b7d-d0d7-b70b030977c6@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Currently, the IPv6 extension headers are parsed twice: first in
> > ipv6_gro_receive, and then again in ipv6_gro_complete.
> > 
> > The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
> > protocol type that comes after the IPv6 layer. I noticed that it is set
> > in ipv6_gro_receive, but isn't used anywhere. By using this field, and
> > also storing the size of the network header, we can avoid parsing
> > extension headers a second time in ipv6_gro_complete.
> > 
> > The implementation had to handle both inner and outer layers in case of
> > encapsulation (as they can't use the same field).
> > 
> > I've applied this optimisation to all base protocols (IPv6, IPv4,
> > Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
> > measure ipv6_gro_complete's performance, and there was an improvement.
> 
> Would be nice to see some perf numbers. "there was an improvement"
> doesn't say a lot TBH...
> 

I just posted raw performance numbers as a reply to Eric's message. Take a
look there.

> > @@ -456,12 +459,16 @@ EXPORT_SYMBOL(eth_gro_receive);
> >  int eth_gro_complete(struct sk_buff *skb, int nhoff)
> >  {
> >  	struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);
> > -	__be16 type = eh->h_proto;
> > +	__be16 type;
> 
> Please don't break RCT style when shortening/expanding variable
> declaration lines.

Will be fixed in v2.

> > @@ -358,7 +361,13 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
> >  		iph->payload_len = htons(payload_len);
> >  	}
> >  
> > -	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> > +	if (!skb->encapsulation) {
> > +		ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
> > +		nhoff += NAPI_GRO_CB(skb)->network_len;
> 
> Why not use the same skb_network_header_len() here? Both
> skb->network_header and skb->transport_header must be set and correct at
> this point (if not, you can always fix that).
> 

When processing packets with encapsulation the network_header field is
overwritten when processing the inner IP header, so skb_network_header_len won't
return the correct value.
