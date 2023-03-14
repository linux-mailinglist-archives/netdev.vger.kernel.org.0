Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05176B9A6E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCNP4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCNP4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:56:05 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C215261B6;
        Tue, 14 Mar 2023 08:56:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so3598421wmb.2;
        Tue, 14 Mar 2023 08:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678809362;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdFrsIiMjK7zaFiXvxcoT7MBwZbH3B8JzNWjOBYQLBA=;
        b=c9i1YHKLupsH6aV0Q0n8iAxu9I4j2VznRLgPrZIVnNZv4UmKK7RIy18hZXxnRLAGGj
         cOXaGdQ724hFoazysdmsot1vsjuhZ6WPr98Itz+rdcPG30R+2h1gKQTNx6tO+J0Jq0AQ
         ZhkDEvpiGMs1Rk6UGCJ5cbDyALNv/PWd7/TmfQsUdqVfhERPphR4yqwMHvIfoB57OAmX
         KOBNsZO3yjPu19W0R0SVP2kpHRWqCkbj6aHG0XVIeFF55Ja5o6YEsd8wkZIrynr0dyzk
         bU3483lb0Wy6/lvHokXf8TsG9nfr684HVCNXElGyTXbgrJZVmnRigh+CKicAqCOD8rla
         gFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678809362;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdFrsIiMjK7zaFiXvxcoT7MBwZbH3B8JzNWjOBYQLBA=;
        b=HfV22WsKbFkUJ4wLVFeLdBCToDRe+ahqGzJADiZ40wsawaZvfP82p9zwO2rM85Thxb
         pIJQqjduGVhGNhDkvlhW7nBJlcA3Uba6A5o4j6UQzD+YIL4V7Sz079szT5oYdqD8tIx8
         D+3ctsTabECl4+SJfy7JKFjhZxUl6I3y5K5J6rLLvl86DXaN4sO00mzlTdsK7MjUOSm5
         PkEMNP1d3qL9ycHzrmSyNNycnETuLj8LWvYxJpu8KTlFb4UnqocRo51YTnXnG/qcosAr
         WIWIb2Pyfli8ypigNiS90xilTKGlEtVR65/maZlWYi/n4thswpVtk/MjUcH/goOZYByJ
         xdZw==
X-Gm-Message-State: AO0yUKUC2A3imm2SrUD11QTmzlvX6GJIl5xrWQ3jYMA4MiLy9ay4vYkW
        VKcEi6JeNkDawzJg2/oFf+A=
X-Google-Smtp-Source: AK7set/Lgtpm4cGMphDCSdbjIzZZ7CRihdQqUuTpFwZgD8GavCor/+cPXMZElp42Yt9hHPsIQZqW9w==
X-Received: by 2002:a05:600c:4fd1:b0:3db:15b1:fb28 with SMTP id o17-20020a05600c4fd100b003db15b1fb28mr16057636wmq.19.1678809362169;
        Tue, 14 Mar 2023 08:56:02 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id l17-20020a7bc351000000b003e21f959453sm3172879wmj.32.2023.03.14.08.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:56:01 -0700 (PDT)
Date:   Tue, 14 Mar 2023 16:55:47 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, alexanderduyck@fb.com, lucien.xin@gmail.com,
        lixiaoyan@google.com, iwienand@redhat.com, leon@kernel.org,
        ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230314155544.GA17833@debian>
References: <20230313162520.GA17199@debian>
 <20230313164541.GA17394@debian>
 <CANn89i+a-d6e3_6PpKckC149_O87GWeUAhe6ztOh62b1fcvBbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+a-d6e3_6PpKckC149_O87GWeUAhe6ztOh62b1fcvBbw@mail.gmail.com>
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

> >
> > Currently the IPv6 extension headers are parsed twice: first in
> > ipv6_gro_receive, and then again in ipv6_gro_complete.
> >
> > By using the new ->transport_proto field, and also storing the size of the
> > network header, we can avoid parsing extension headers a second time in
> > ipv6_gro_complete (which saves multiple memory dereferences and conditional
> > checks inside ipv6_exthdrs_len for a varying amount of extension headers in
> > IPv6 packets).
> >
> > The implementation had to handle both inner and outer layers in case of
> > encapsulation (as they can't use the same field). I've applied a similar
> > optimisation to Ethernet.
> >
> > Performance tests for TCP stream over IPv6 with a varying amount of
> > extension headers demonstrate throughput improvement of ~0.7%.
> >
> > In addition, I fixed a potential future problem:
> 
> I would remove all this block.
> 
> We fix current problems, not future hypothetical ones.
> 

I agree, I did it primarily to avoid an additional branch (the logic
remains exactly the same). I'll remove this part from the commit message.


> >  - The call to skb_set_inner_network_header at the beginning of
> >    ipv6_gro_complete calculates inner_network_header based on skb->data by
> >    calling skb_set_inner_network_header, and setting it to point to the
> >    beginning of the ip header.
> >  - If a packet is going to be handled by BIG TCP, the following code block
> >    is going to shift the packet header, and skb->data is going to be
> >    changed as well.
> >
> > When the two flows are combined, inner_network_header will point to the
> > wrong place - which might happen if encapsulation of BIG TCP will be
> > supported in the future.
> >
> > The fix is to place the whole encapsulation branch after the BIG TCP code
> > block. This way, if encapsulation of BIG TCP will be supported,
> > inner_network_header will still be calculated with the correct value of
> > skb->data.
> 
> We do not support encapsulated BIG TCP yet.
> We will do this later, and whoever does it will make sure to also support GRO.
> 
> > Also, by arranging the code that way, the optimisation does not
> > add an additional branch.
> >
> > Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> > ---
> >
> 
> Can you give us a good explanation of why extension headers are used exactly ?
> 
> I am not sure we want to add code to GRO for something that 99.99% of
> us do not use.

IMO, some common use cases that will benefit from this patch are:
- Parsing of BIG TCP packets which include a hbh ext hdr.
- dstopts and routing ext hdrs that are used for Mobile IPv6 features.

Generally, when a packet includes ext hdrs we will avoid the recalculation
of the ext hdrs len. When there are no ext hdrs, we will not call the
ipv6_exthdrs_len function so the performance isn't negatively impacted
(potentially even saving some opcodes in ipv6_exthdrs_len).
