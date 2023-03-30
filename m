Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1366D045B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjC3MIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjC3MIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:08:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D563E136
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:08:23 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ek18so75560127edb.6
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680178102;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NbqLAus2LbgNZOBa+pTsc9YQbXVj2IVKZlVn1wHC3g4=;
        b=LD8Av334KbtYJO5cPBXEdpanZ5GdwRvOGVBnY2/rHUsvpl993re/YdOXEWee8GoVDj
         oa1iHPors+Wo8+1SLKhwKyMlceF6w61Ec+PWr0RbgkuhZXy37l69EjoyWmkgyBhuncKP
         D21mHG0Pb4OqQUQoMyz4sChEeO7mNCPfDiafrXThKTipauksxlpY6LUXeZvcDWA0V6kP
         G9K8ErKQTCj09Egnmeibx/9WL2ohs145fc8Ad0DmdQCFO2jF7fyMKSgaPyJuBOriiksW
         PJMWFBMw28wrsVbl8+YsmfN/jBSDZy9XGrYOfGhXRMQZSZ4Pvlzz7BSXoBoVlE3pk2Z7
         SQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680178102;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NbqLAus2LbgNZOBa+pTsc9YQbXVj2IVKZlVn1wHC3g4=;
        b=TbCRQpLgaI0IgILubwOl4DkSdREqOAd81XSctTdXfmoMszvNbeM+RywwmbcFmmZpAD
         RAnFOexB9NGpS/AqR/jUyGcMv8jAL3m6buykfhOoiR83WIEcuPkgF+iM90vFvOF3mJS/
         RoOhzWK8HsWVyyDhgwfbMDlY4kb3TarLQSGgKktiP+gNH9UkYyvBMlMEWGHKU1yHS2i7
         8BWHhxB2IqEiJ1ror6qYjla2K69JawluvE4KWPLBC/ShYAxOocQBqtzbHqya8rLzezFL
         nDSgVuPKYU5ibDsIrZ1cAz5QrSWao0mb5JkOL/L7jjmHLSfdV7MtIMu9wo+jCNRB3kRY
         A60Q==
X-Gm-Message-State: AAQBX9d9B6g9/YlkqfjsmKcNofF+RVwUGlE5SLn5iK0+ACayMMg+1es7
        OMDvv/cW9I7S4E3nl+P9M/o=
X-Google-Smtp-Source: AKy350YwYTZ7LdoVUHO04JCJv0dK0gsVJK/XMTUh9pC+1MuFpMtIcW0+eZry1AIUH9Sh+AQVAhxGiQ==
X-Received: by 2002:a05:6402:68e:b0:500:3a14:82c1 with SMTP id f14-20020a056402068e00b005003a1482c1mr20861250edy.41.1680178102106;
        Thu, 30 Mar 2023 05:08:22 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y94-20020a50bb67000000b004be11e97ca2sm18117125ede.90.2023.03.30.05.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:08:21 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:08:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        steffen@innosonix.de, Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Enable IGMP snooping on user
 ports only
Message-ID: <20230330120819.yfyzdiixqef657di@skbuf>
References: <20230329150140.701559-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230329150140.701559-1-festevam@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 12:01:40PM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.
> 
> This allows the host CPU port to be a regular IGMP listener by sending out
> IGMP Membership Reports, which would otherwise not be forwarded by the
> mv88exxx chip, but directly looped back to the CPU port itself.
> 
> Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")

I checked to see if the Fixes tag is correct, and... it's complicated.
That patch comes from the consolidation of multiple drivers
(mv88e6123_61_65.c, mv88e6131.c, mv88e6171.c, mv88e6352.c into what
later became the common mv88e6xxx driver. In principle, each of the
above drivers had their own buggy pre-existing logic to enable IGMP/MLD
snooping on all ports, but it seems a pointless exercise to add
individual Fixes: tags for all drivers prior to an unification process
that took place in 2015. So this gets my:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
