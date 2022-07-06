Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43B8568E16
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiGFPpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiGFPpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:45:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEBC31367;
        Wed,  6 Jul 2022 08:39:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u12so27752950eja.8;
        Wed, 06 Jul 2022 08:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UpB4V/X0i/RXIT4mM23nTV8Xeo9GU4ipcxDVNsDMRIk=;
        b=dUCVMshO8wJSmXpVerdRgpYex6b0rIdo5vd/3+6FSG+YKemn5QEvv8R7V7+bOfJ1rc
         12zvTezkM6yR6wUSkwRz3jFbxkrj4+SNrFSbVm8p+iQnSsXfIRWhKdAkQDe3pKPoqV0F
         9kObq2zi178giYn40XUsjkCU4GJWMk1XjvwrrkN7OMlVqD86fH9fibXUrHdZ6e36vcKP
         6rmOV66uC5T2h0Oeo8FUoThDj/JRfPu+PwLz8Ewxl+pBEO6MlHqlYKuKfZLeLENlB1Rj
         uPvsJhNeavL6CbFm2RpErePydYPp5/rWExW7jyxaVZNmUug6Fx9stbwQGV6K7k4Rg7wJ
         OhOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UpB4V/X0i/RXIT4mM23nTV8Xeo9GU4ipcxDVNsDMRIk=;
        b=6o2fwtFUPkwsKgky2aaahGXCkOhQn5qDIh0fStMNil/G28JuUA+B/Y0eWtEf4z0IOH
         uLLq+WGbVWe4TYDdRg3Iwy5kGCLq4lOR16MwioEphSv/nEho3VKX6xywhubntryQmd1V
         /ojioXgd6M4TtBWdSOMKdkh2D1lYQnr/uREDJGiLuIku/+WREV7+Pj+fRKy9Knx2npfl
         edUwdL/JfLB9HEu6hqP0yORBsQ270FBupDymvmfA9DTaDJaDllVQbYDrNpIDDo+vzsMS
         tb3k8MUa1e+3HvNnjPNNy3UCfMuIw4DXvhsPa5kcnfIomBfNBQr0MvW9ThSQ9GKDUzkz
         X0gQ==
X-Gm-Message-State: AJIora/Q7vI7/uJ2DbnRdB+pRiGEX9rIjWXyy2ES1AxHFdUum3qQyl1U
        HSWWqw8BGTVd3PsTE5RR2cymoCH5BWc01dpO
X-Google-Smtp-Source: AGRyM1uhb1KQuofOv9C4q0pwxUFVNmJwOKVNdXS9cNw3e6pbR0GR1HBhX/NPCIf/6WewJE7FNRRNEw==
X-Received: by 2002:a17:906:77c8:b0:722:e753:fbbe with SMTP id m8-20020a17090677c800b00722e753fbbemr38469079ejn.692.1657121946479;
        Wed, 06 Jul 2022 08:39:06 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id hb10-20020a170906b88a00b007266185ca67sm15425197ejb.150.2022.07.06.08.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:39:05 -0700 (PDT)
Date:   Wed, 6 Jul 2022 18:39:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH RFC] net: dsa: qca8k: move driver to qca dir
Message-ID: <20220706153904.jtu2qxczjjcgcoty@skbuf>
References: <20220630134606.25847-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630134606.25847-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 03:46:06PM +0200, Christian Marangi wrote:
> Move qca8k driver to qca dir in preparation for code split and
> introduction of ipq4019 switch based on qca8k.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> 
> Posting this as a RFC to discuss the problems of such change.
> 
> This is needed as in the next future the qca8k driver will be split
> to a common code. This needs to be done as the ipq4019 is based on qca8k
> but will have some additional configuration thing and other phylink
> handling so it will require different setup function. Aside from these
> difference almost all the regs are the same of qca8k.
> 
> For this reason keeping the driver in the generic dsa dir would create
> some caos and I think it would be better to move it the dedicated qca
> dir.
> 
> This will for sure creates some problems with backporting patch.
> 
> So the question is... Is this change acceptable or we are cursed to
> keeping this driver in the generic dsa directory?
> 
> Additional bonus question, since the ethernet part still requires some
> time to get merged, wonder if it's possible to send the code split with
> qca8k as the only user (currently) and later just add the relevant
> ipq4019 changes.
> 
> (this ideally is to prepare stuff and not send a big scary series when
> it's time to send ipq4019 changes)

I think we discussed this before. You can make the driver migration but
you need to be willing to manually backport bug fixes if/when the stable
team reports that backporting to a certain kernel failed. It has been
done before, see commit a9770eac511a ("net: mdio: Move MDIO drivers into
a new subdirectory") as an example. I think "git cherry-pick" has magic
to detect file movement, while "git am" doesn't. Here I'm not 100%
certain which command is used to backport to stable. If it's by cherry
picking it shouldn't even require manual intervention.
