Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D38578839
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiGRRVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiGRRVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:21:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7493420188;
        Mon, 18 Jul 2022 10:21:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z22so3273176edd.6;
        Mon, 18 Jul 2022 10:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0f3GiMIrqbypwt4DAMk15p8Y7Pi+FTgv/VCVPuZRdRI=;
        b=HVUqNUdDg3AfhN/jAlQVmHfmCcWdTr6vZ+SRaItj4Vpq1g4yUdIm12/El49V0tBlSy
         pV/RopMIQo/AlglU5c9UZVBYSO3M61qqgsDW1DNooEK8OVzzGbp2DYuhB+KRbwJkcATt
         m2OpDGJtQWD67WcNJgNQwTfq6ozTzGhQyAmfeeQlxeNETY38Kodtur49eXJPK5OLMRRE
         3OIFxqFc2yA7a7Hu5prmAQmn47aItdw9H4XUWdKzZkDr5SIUexv5kyREn2BsoI62QvEz
         vfbnCNHxIzER8Rd80TA/3IlvfeuDICcQJP+s+mw1IZObeMtxXwC2HyP280erl59qOLCw
         y2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0f3GiMIrqbypwt4DAMk15p8Y7Pi+FTgv/VCVPuZRdRI=;
        b=PHAhLGgZ6McBakmuOf5jIakdnX9+Qqny+QJHmve3XyUW/TEZnGnXH+Uy8BD+BZSs+k
         VUdCAp+jR7tVkybThThwly5avdZoUqGy4RRcxZy9V29wvANsXAxaKC14LFUVFOJyuzFd
         kza7BFVOkVJ43em5Cv2oah5FOKYRWmTUdfmjqQCGUdt6/jcgSd1HmcuDUEKbES2qnwNF
         cCX5A40ffac9PDTzu9as3NeVrUxu2K3cxENsRPD1T7mefz9ggj7dPUeEf9phFC2Fch+F
         GqMRawtL7HZzIuclLb/zHPepyS1MaRoIxb5DwTe3beMgBstKcVg1/ddE1+CLhn0nWHnR
         RhXw==
X-Gm-Message-State: AJIora8+39kZGIaIHnVFRGlOyy36s9FHgBPAC02a1t14BhgoTYaZAw6B
        m4ghQsP0x8X2nCf1YvvCsiA=
X-Google-Smtp-Source: AGRyM1sTk1gknCczvF0V+eI1Y5WY2/mEtX7HflNjCI3Keg0cXIGO2dbU+AU/qt9XvM55hYg0H9eYWw==
X-Received: by 2002:a05:6402:695:b0:435:65f3:38c2 with SMTP id f21-20020a056402069500b0043565f338c2mr38766330edy.347.1658164899068;
        Mon, 18 Jul 2022 10:21:39 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906768b00b0072b3406e9c2sm5687118ejm.95.2022.07.18.10.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:21:37 -0700 (PDT)
Date:   Mon, 18 Jul 2022 20:21:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 4/4] net: dsa: qca8k: split qca8k in common
 and 8xxx specific code
Message-ID: <20220718172135.2fpojugpmoyekcn7@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716174958.22542-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 07:49:58PM +0200, Christian Marangi wrote:
> The qca8k family reg structure is also used in the internal ipq40xx
> switch. Split qca8k common code from specific code for future
> implementation of ipq40xx internal switch based on qca8k.
> 
> While at it also fix minor wrong format for comments and reallign
> function as we had to drop static declaration.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/Makefile                  |    1 +
>  drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1210 +----------------
>  drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++++++
>  drivers/net/dsa/qca/qca8k.h                   |   58 +
>  4 files changed, 1245 insertions(+), 1198 deletions(-)
>  rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (64%)
>  create mode 100644 drivers/net/dsa/qca/qca8k-common.c

Sorry, this patch is very difficult to review for correctness.
Could you try to split it to multiple individual function movements?
