Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302DB6A106D
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 20:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjBWTP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 14:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjBWTOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 14:14:45 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374AD61EE1;
        Thu, 23 Feb 2023 11:14:14 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c12so11565271wrw.1;
        Thu, 23 Feb 2023 11:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UlCNFMibk6cjsBXSukcqkX+TEWEV0k6MvGomAhnq3F8=;
        b=P5IhdTmaKQ5NFE3+BCSo30GjaO92o6k03/6Jsz8n9Caq6fUmjFb8J0wKWAGV78jnD9
         WfwQWsdtqbY17pOOASnZiae4NPGaw+wDaS8tmc2lroRciTwGhyHBZwK5ymNZC4xQMqf1
         5vdqLA61FcFXW8ByviOpdGtnbsmTOEc3DP/xKSOdiCtjX4Qz4UeUk3QtE4w6JBdahZ40
         gbv72IW/LSUi8X4157F20boNAjBiwA1sMl09weliNCOrnrrwcD+DxhVuiiiRIk0SFFW6
         T0QK4SQ06fhbGVEFbmfDfdHDxKOflafgldMYh0UAaDnvuJwVHFL1GaAB2tQ3kST7EcRj
         MK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UlCNFMibk6cjsBXSukcqkX+TEWEV0k6MvGomAhnq3F8=;
        b=TRgSEtPByBXaZmS7gMm0Cz6l3bISDgrBwFVFMKmjNr3AbTynG3kGJHwMDoqqnUkrx/
         EKuo89Dk32QG2fMNxyqiG6rQtVFzsj5hcimxxKo2kD2zo/y5RHSMoZueYfSJclhSPV8q
         H+8kRygR61HgzbSSJ9Q5KsNAfSoB02MSx7BHuZiCXT6Jb5tAjfrsDZ5lJpDY2bJCO4F7
         qGmWp9z77C3HCLovVYj8ofAVdipEtVWsmyRE2v4Q1yxgj187lvDdLIPymVKhNSr0EWiG
         vdo0zUNzC+63qouf97zL2UZmz4T8aNnh/JYNWS21JkR8eiwaa2KGzeLCAGgvRc8b92cI
         AJzA==
X-Gm-Message-State: AO0yUKUqJIy7999WyjCCjQN6P7CLYswNFo3sWiDZk4l8fLUXmHdsBcB2
        ZmfEl4hjXSJTowPG7cZez94=
X-Google-Smtp-Source: AK7set/qrXhliMqCLUOkC1J+k8nKq7oxi9fP2RVtSeN3sWkAG61e2/YyVrSlUzWFxfN9V2JrSOerYg==
X-Received: by 2002:a5d:42d2:0:b0:2c5:788e:3100 with SMTP id t18-20020a5d42d2000000b002c5788e3100mr10206602wrr.42.1677179593704;
        Thu, 23 Feb 2023 11:13:13 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id t13-20020a05600001cd00b002c6d0462163sm9824572wrx.100.2023.02.23.11.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:13:13 -0800 (PST)
Date:   Thu, 23 Feb 2023 20:12:52 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, alexanderduyck@fb.com, lixiaoyan@google.com,
        steffen.klassert@secunet.com, lucien.xin@gmail.com,
        ye.xingchen@zte.com.cn, iwienand@redhat.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230223191249.GA14091@debian>
References: <20230222145917.GA12590@debian>
 <20230222151236.GB12658@debian>
 <CANn89iK03mcdu=dn+kj-St27Y2OvSzQ5G=VzqwutR0Khn1cSUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iK03mcdu=dn+kj-St27Y2OvSzQ5G=VzqwutR0Khn1cSUg@mail.gmail.com>
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

> On Wed, Feb 22, 2023 at 4:13 PM Richard Gobert <richardbgobert@gmail.com> wrote:
> >
> > Currently the IPv6 extension headers are parsed twice: first in
> > ipv6_gro_receive, and then again in ipv6_gro_complete.
> >
> > By using the new ->transport_proto field, and also storing the size of the
> > network header, we can avoid parsing extension headers a second time in
> > ipv6_gro_complete (which saves multiple memory dereferences and conditional
> > checks inside ipv6_exthdrs_len for a varying amount of extension headers in IPv6
> > packets).
> >
> > The implementation had to handle both inner and outer layers in case of
> > encapsulation (as they can't use the same field).
> >
> > Performance tests for TCP stream over IPv6 with a varying amount of extension
> > headers demonstrate throughput improvement of ~0.7%.
> >
> > In addition, I fixed a potential existing problem:
> >  - The call to skb_set_inner_network_header at the beginning of
> >    ipv6_gro_complete calculates inner_network_header based on skb->data by
> >    calling skb_set_inner_network_header, and setting it to point to the beginning
> >    of the ip header.
> >  - If a packet is going to be handled by BIG TCP, the following code block is
> >    going to shift the packet header, and skb->data is going to be changed as
> >    well.
> >
> > When the two flows are combined, inner_network_header will point to the wrong
> > place.
> 
> net-next is closed.
> 
> If you think a fix is needed, please send a stand-alone and minimal
> patch so that we can discuss its merit.

I'll repost when net-next will be opened again.
Thanks.

> 
> Note :
> 
> BIG TCP only supports native IPv6, not encapsulated traffic,
> so we should not bother with inner_network_header yet.
