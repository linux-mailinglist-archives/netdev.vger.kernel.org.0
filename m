Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55D5785D0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiGROva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiGROvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:51:19 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D1625C67;
        Mon, 18 Jul 2022 07:51:16 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id x23-20020a05600c179700b003a30e3e7989so5303711wmo.0;
        Mon, 18 Jul 2022 07:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z92yTjAN/2+L5C4RPZ2HrP6dUZpkbVOybJDG5s2/LsE=;
        b=krx5guhSQH1VfpU2Cg2S0jZ5CLuUy3vd3BinIhd2nX1SNFp7GmlFLTD0o3YXgPcySA
         nasbbbdZaUwGPoCd6pP8fBocq+g5BSxssuWtfsWBIGFyoBSjMvsvAO1dLoSKwDSIV4VX
         1asYr3V8idPvk7p3c8RtJ53NCm6XyWYFROrOe6PTH8eVbQL+tl+oEoqat1k87nf04oPj
         2CvdN7q6apajCbNioNF9udQAh/i112+XbhT1H9UWeMdiuox9PAtByxT3kO1ivHJP1Y07
         MPeWuU9kZ9BvxGZktJQp34y/x1k4f51uugTwKNlpQVmOYGEsHtdG2IGVuFk2muJjzjtK
         XomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z92yTjAN/2+L5C4RPZ2HrP6dUZpkbVOybJDG5s2/LsE=;
        b=oV94EbYduPelzSdHIoCA7n+X4r+3bf7wjieuSzK9NYAX2blvtol41SVUD0NzVh8B6P
         Khph5l5wEUtsphzAdueEvWYwXIs8nn3+31H13ZHgpLtvr4Goxo7O9g/qG5OQj7DqKe2G
         Z3qtYko26Li5DgE5DoTEWXkBDaGBlBA2Q4kwl5vOyIlGG5oM5rZ/8Z5stI2Y2EPSA+RF
         LdD22N1hOmalBlUULcYeuAC+w6qWTuqVl0j4bPYZDVyKktVCNMhkLNw91Pc/hhgLkKkt
         sSMza5CNASc6dguZCoKx5FKlVOUSCi+VZYBG19vhx/fEGAnksm4lf7B9T71v9mowPXtK
         ETLg==
X-Gm-Message-State: AJIora8QaEhTUwZLZbDMNzcTRyPjIo8KTg9IikqRvAzUumPPhWYgz2Zi
        ezp54RJ9C10Z3niM2xRTEAM=
X-Google-Smtp-Source: AGRyM1smVPOrqjJesfaPP8XvlOPmmFZgki4hJx1c9CTw/3oAl9wWDySoT0q5uO3gGzpfskA7xSCUPg==
X-Received: by 2002:a05:600c:4f4d:b0:3a1:98de:abde with SMTP id m13-20020a05600c4f4d00b003a198deabdemr32996425wmq.36.1658155875157;
        Mon, 18 Jul 2022 07:51:15 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id u10-20020a05600c19ca00b003a31df6af2esm2521299wmq.1.2022.07.18.07.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 07:51:14 -0700 (PDT)
Message-ID: <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
X-Google-Original-Message-ID: <YtVyPB/EsXnWW4BB@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 16:46:20 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716174958.22542-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 07:49:54PM +0200, Christian Marangi wrote:
> This is posted as an RFC as it does contain changes that depends on a
> regmap patch. The patch is here [1] hoping it will get approved.
> 
> If it will be NACKed, I will have to rework this and revert one of the
> patch that makes use of the new regmap bulk implementation.
>

The regmap patch that this series depends on has been accepted but needs
some time to be put in linux-next. Considering the comments from the
code move, is it urgent to have the changes done or we can wait for the
regmap patch to get applied?

(this was asked from the regmap maintainer so here is the question)

> Anyway, this is needed ad ipq4019 SoC have an internal switch that is
> based on qca8k with very minor changes. The general function is equal.
> 
> Because of this we split the driver to common and specific code.
> 
> As the common function needs to be moved to a different file to be
> reused, we had to convert every remaining user of qca8k_read/write/rmw
> to regmap variant.
> We had also to generilized the special handling for the ethtool_stats
> function that makes use of the autocast mib. (ipq4019 will have a
> different tagger and use mmio so it could be quicker to use mmio instead
> of automib feature)
> And we had to convert the regmap read/write to bulk implementation to
> drop the special function that makes use of it. This will be compatible
> with ipq4019 and at the same time permits normal switch to use the eth
> mgmt way to send the entire ATU table read/write in one go.
> 
> (the bulk implementation could not be done when it was introduced as
> regmap didn't support at times bulk read/write without a bus)
> 
> [1] https://lore.kernel.org/lkml/20220715201032.19507-1-ansuelsmth@gmail.com/
> 
> Christian Marangi (4):
>   net: dsa: qca8k: drop qca8k_read/write/rmw for regmap variant
>   net: dsa: qca8k: convert to regmap read/write API
>   net: dsa: qca8k: rework mib autocast handling
>   net: dsa: qca8k: split qca8k in common and 8xxx specific code
> 
>  drivers/net/dsa/qca/Makefile                  |    1 +
>  drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1638 +++--------------
>  drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++
>  drivers/net/dsa/qca/qca8k.h                   |   61 +
>  4 files changed, 1463 insertions(+), 1411 deletions(-)
>  rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (60%)
>  create mode 100644 drivers/net/dsa/qca/qca8k-common.c
> 
> -- 
> 2.36.1
> 

-- 
	Ansuel
