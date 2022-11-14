Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148F662882D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiKNSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 13:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbiKNSTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 13:19:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1913EE0BC;
        Mon, 14 Nov 2022 10:19:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f5so30412799ejc.5;
        Mon, 14 Nov 2022 10:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uYGLQt8WBm03+H0IaF+VMFd/LMqC+H/3EtuX2os1JUw=;
        b=mnMjJN9MBcIAjanGCcg3JNeIEr1vguhAs9dyjEjeSybL+wGOlc5cvURRZzHugERoq1
         SRsovON8N6v9MM+XmXB6Svh2I+3ZLlqHdfbq//W3LO2xkNqNWq2lW9gfqqaFSUDfCJvu
         tMHiURwlDM2hLbGv+5t0o4NXN9DKk8SVVcFCRL7Tm/lvDSf4fqaseKwOGGB1myd7btRV
         m4Ir9ceUtMSCtQbvYixQnUamyQ27e9+5O4LNqXSdeUu+oXbR3UZsay8etGyIASb2Ngsg
         AZN4LOLwhsFFwZrXSlVQQsBVazB1Dn2xlBz3dgq6omFJtI8ZtZAcX2hNEvP7hFOntj6j
         GoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYGLQt8WBm03+H0IaF+VMFd/LMqC+H/3EtuX2os1JUw=;
        b=2wQjqbMNTTu/JY5xZZi3JjctmSYNe01qZ5AlpZeKqxO+0pHA83t6txLtyQ6cR7AVIS
         LU+5yEoYz9zdn8CIqTGO133wE7tPSYB/ScnMLsUL9hdTKcOprxyP+M49l/EuhMfRQDED
         sHT00jnDH6jeutvPRyQgMEImM7GIBZzRhS9ljKCUp8fKtTUBxZXFj29ZMHzWnNdoaw11
         dCvhFLWdpL30VOLuWiSmqjL2GjWFIP/rzl88udL5145hGhyucaYG7FSswjWMde5DBm7c
         /7GTVszRV3fFTP0KcNyuTCRfi8ayFTnpZR4OfdIIqus7Vq0CyB0kc0fdQMOFjbjuqEsh
         5+PA==
X-Gm-Message-State: ANoB5pkF9dOngVK9RYhlWIyEpS43otwH+uFDkUw/DVrFaR/nthThVY+u
        eLthdOU5/8ngTJ8CKKXgrxQ=
X-Google-Smtp-Source: AA0mqf55m76xYKZiMaAiR4fRPg+sUWuIheqA7U/SOLBNz2dYlebdBItIBPyFWi0OZn32Uap9wm8WFg==
X-Received: by 2002:a17:906:e2c4:b0:7ad:dfb5:a3f2 with SMTP id gr4-20020a170906e2c400b007addfb5a3f2mr10927261ejb.351.1668449969480;
        Mon, 14 Nov 2022 10:19:29 -0800 (PST)
Received: from skbuf ([188.25.170.202])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906210a00b0078dce9984afsm4418084ejt.220.2022.11.14.10.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 10:19:29 -0800 (PST)
Date:   Mon, 14 Nov 2022 20:19:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221114181926.ms5yl5rwzx7oonzn@skbuf>
References: <20221114124214.58199-1-nbd@nbd.name>
 <20221114124214.58199-2-nbd@nbd.name>
 <50a9e9c1-68d6-4edd-42e2-c5b8a9ac7e8a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a9e9c1-68d6-4edd-42e2-c5b8a9ac7e8a@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:59:09AM -0800, Florian Fainelli wrote:
> On 11/14/22 04:42, Felix Fietkau wrote:
> > If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
> > port netdev, assume that it carries the port number and that there is no DSA
> > tag present in the skb data.
> > 
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Is the plan to use the lwoer bits of the 32-bit port_id as the port number
> for now, and we can use the remaining 24 or so bits for passing
> classification (reason why we forward the packet, QoS etc. ) information in
> the future?
> 
> Might be time for me to revive the systemport patches supporting Broadcom
> tags in the the DMA descriptor.

It's not really clear how to expand the HW_PORT_MUX model to provide QoS
info and trap reason, without switching to per-packet allocation, which
is what Jakub seemingly wanted to avoid with skb extensions (among other
more minor things).

https://patchwork.kernel.org/project/netdevbpf/patch/20221104174151.439008-4-maxime.chevallier@bootlin.com/#25078661

Felix didn't present a need for more than the port id either, so this is
why we have what we have right now.
