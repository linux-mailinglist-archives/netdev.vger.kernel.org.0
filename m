Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09A618C0E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKCWvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKCWv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:51:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE29B1AD;
        Thu,  3 Nov 2022 15:51:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id f5so9135051ejc.5;
        Thu, 03 Nov 2022 15:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kqzQruhXx3eIhPRm5egIBhrBjIecuzW4Kx8QQz0kkR0=;
        b=Io3euxkxdP5o8qUZ/KC9TfOXd9DCWFqP51ENEK++HcLUVg3+zEXRSwwwqi8ILOqcPh
         gXQe4bEWguHsZqUgNkM6EdjhasPU+qcANrB56dh1mucwG7YmeyqtBqSSRvlm/xdgjkz0
         5thWthTludIVMHfyzRdT6ZCkyWCPF7EGvbmptMZWQXAf3w16xl/LBQs0OjuMjnb54q+f
         lKeCgt6vgU9SH7jTtI4FQTXuxaYchWNSRC/mf3CUiv5gPL2RMI8EMjEYd54L350edJb2
         eiCytOGRnhfCNsBPmxluy/EaVJkn2dWv+cooRR8A/ZEzG/sulH00OhZvj1+siwC/1ArN
         thjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqzQruhXx3eIhPRm5egIBhrBjIecuzW4Kx8QQz0kkR0=;
        b=PtGkoZXRIF3fdtI75IPJU5tbb+2rL1taFpYC18vwilWVJDIuwBajG9fN/4gtsQY021
         YIVrRw2io6yatQxwrCzlSG8BuVVKnNKbpujxR8UztqJBuBDgc4yfCzQYzk2EwAVJwi1e
         UT7h8CuSpfQQfZDkYznwkXim4+nWod2KA+OYA1qlXjaXfkECcNPCFTF9IMDPXb5IqX4r
         g+SoW+eXjGVPnp5Ol9hRH4fhAvi6tloNlRElJw6YQAfdH1V1WZJsptnBw+v7S+a6GUya
         uzDpvOreyb94Ij0gAkmed5DGolAag2YC58tuiTTIjXXn6TEasJSZ4apmJaGm3nGnZ/DT
         56kw==
X-Gm-Message-State: ACrzQf2i8WUm/3k/emuCXHzfkkh7Vb9ndddfG4jtwLw+QMvcJfahVHGy
        FdmtCO5siZkIQ9smh7Yca2U=
X-Google-Smtp-Source: AMsMyM6SLGdG3ffYIwmlFqPFRnekSghVric67IB0tkvnIzFVi58SJSl2g7iDWrX3VtmM6/FNw4MmSg==
X-Received: by 2002:a17:907:2708:b0:7a6:38d7:5987 with SMTP id w8-20020a170907270800b007a638d75987mr31538019ejk.467.1667515887271;
        Thu, 03 Nov 2022 15:51:27 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ev24-20020a056402541800b00459f4974128sm1064372edb.50.2022.11.03.15.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:51:26 -0700 (PDT)
Date:   Fri, 4 Nov 2022 00:51:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, git@amd.com, harini.katakam@amd.com,
        radhey.shyam.pandey@amd.com, michal.simek@amd.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/2] Add support for Frame preemption (IEEE
Message-ID: <20221103225124.h6nrj2qnypltgqbr@skbuf>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103113348.17378-1-pranavi.somisetty@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pranavi,

On Thu, Nov 03, 2022 at 05:33:46AM -0600, Pranavi Somisetty wrote:
> Frame Preemption is one of the core standards of TSN. It enables
> low latency trasmission of time-critical frames by allowing them to
> interrupt the transmission of other non time-critical traffic. Frame
> preemption is only active when the link partner is also capable of it.
> This negotiation is done using LLDP as specified by the standard. Open
> source lldp utilities and other applications, can make use of
> the ioctls and the header being here, to query preemption capabilities
> and configure various parameters.
> 
> Pranavi Somisetty (2):
>   include: uapi: Add new ioctl definitions to support Frame Preemption
>   include: uapi: Add Frame preemption parameters
> 
>  include/uapi/linux/preemption_8023br.h | 30 ++++++++++++++++++++++++++
>  include/uapi/linux/sockios.h           |  6 ++++++
>  net/core/dev_ioctl.c                   |  6 +++++-
>  3 files changed, 41 insertions(+), 1 deletion(-)
>  create mode 100644 include/uapi/linux/preemption_8023br.h
> 
> -- 
> 2.36.1
> 

Have you seen:
https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/
