Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314B56795DA
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjAXK56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjAXK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:57:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14C67A85;
        Tue, 24 Jan 2023 02:57:52 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so10612809wmc.1;
        Tue, 24 Jan 2023 02:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+iRy96huUwX2AjRH5KAl7czXmDMKHIrTrxrrNsvynA=;
        b=aOCwvkEPfoRLVBjW+3cFQRXN4J5/Qll7A+x2Mr5eLvdDV4AV54vgZgH3Dzzzxbzkmc
         gByGVJAPIUjdRtPzwS/Uv6MyfKjuVD3g61lKXfpp410UBlp+6KUflItzfVb2SMI6JV1P
         ZucTaDFDAw18NVdOguzmR7GDHKwZvBbqx/u1Nq1MCvj5RhghPpD6Qi71zIP6mzAffUzC
         LsqDLJp3MQgSCi63aznlgALlRiNdfDAlS+BKmelVyarfM3fi5172Iw+5e3G06hkEEU1I
         dniQrLsXJRq9+fESsGwjaLOZzzf2264h9NCuGZHFjLdTNIBDXZEIZqq8aw6zjY4f/Hhv
         a8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+iRy96huUwX2AjRH5KAl7czXmDMKHIrTrxrrNsvynA=;
        b=IqZVvHEqr0AWLaNTIkBvfz4PPqn33CEUzUf/uVSST85STpyRBqCYueA0yBfUsyKF5V
         phWaJGqG2+uZjxAtoj5e/mJWwUXaEBAg7misWi5QXqxXXF89ZatzNAfoJuyU8n4tMcoE
         CS2xa9aepb/6Lnrh4HIwtN2ZrhKJPBB+UsNt6zr+Aj53tqIgq0Mk7qAI6i3EZi6q+1Ue
         DH5AjCfZ7N6C2ABjbgHOyE7X4rPNj9t0wn8Hw2GwvKVd4UjmAi5F90g6DDc9w4H2CbTo
         cpqR3HK5pbDPLthSaEafmZtH/c959WfDec3V3iBJ5O0KV3p+Eyq8qZFyE4JN68EMn2Oy
         KfTw==
X-Gm-Message-State: AFqh2kqPHdpvTqhTA5fXaw8OTYmqG2nXlIqPLgcW2vXzmplx+awkkKt4
        JQjzVHYDScBjkIIOzJMCzFw=
X-Google-Smtp-Source: AMrXdXu5Lz/MfGUfhZbnIJQqqA72u5WFJMgCe7lhHAOqOSEVdYZdIkX3liGkp8sUr3h/1Z8WciF3Dw==
X-Received: by 2002:a05:600c:198a:b0:3d9:cb4c:af5a with SMTP id t10-20020a05600c198a00b003d9cb4caf5amr28500368wmq.33.1674557870628;
        Tue, 24 Jan 2023 02:57:50 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v1-20020a05600c4d8100b003dc175c09c1sm232010wmp.27.2023.01.24.02.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 02:57:50 -0800 (PST)
Date:   Tue, 24 Jan 2023 13:57:45 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v2 0/8] Adding Sparx5 IS0 VCAP support
Message-ID: <Y8+5qSgbSupca1bu@kadam>
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 11:45:03AM +0100, Steen Hegelund wrote:
> This provides the Ingress Stage 0 (IS0) VCAP (Versatile Content-Aware
> Processor) support for the Sparx5 platform.
> 
> The IS0 VCAP (also known in the datasheet as CLM) is a classifier VCAP that
> mainly extracts frame information to metadata that follows the frame in the
> Sparx5 processing flow all the way to the egress port.
> 
> The IS0 VCAP has 4 lookups and they are accessible with a TC chain id:
> 
> - chain 1000000: IS0 Lookup 0
> - chain 1100000: IS0 Lookup 1
> - chain 1200000: IS0 Lookup 2
> - chain 1300000: IS0 Lookup 3
> - chain 1400000: IS0 Lookup 4
> - chain 1500000: IS0 Lookup 5
> 
> Each of these lookups have their own port keyset configuration that decides
> which keys will be used for matching on which traffic type.
> 
> The IS0 VCAP has these traffic classifications:
> 
> - IPv4 frames
> - IPv6 frames
> - Unicast MPLS frames (ethertype = 0x8847)
> - Multicast MPLS frames (ethertype = 0x8847)
> - Other frame types than MPLS, IPv4 and IPv6
> 
> The IS0 VCAP has an action that allows setting the value of a PAG (Policy
> Association Group) key field in the frame metadata, and this can be used
> for matching in an IS2 VCAP rule.
> 
> This allow rules in the IS0 VCAP to be linked to rules in the IS2 VCAP.
> 
> The linking is exposed by using the TC "goto chain" action with an offset
> from the IS2 chain ids.
> 
> As an example a "goto chain 8000001" will use a PAG value of 1 to chain to
> a rule in IS2 Lookup 0.
> 
> Version History:
> ================
> v2      Added corrections suggested by Dan Carpenter.

Thanks!

regards,
dan carpenter

