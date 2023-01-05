Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AF65E949
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjAEKt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbjAEKtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:49:17 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56B350E69;
        Thu,  5 Jan 2023 02:49:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u19so89108462ejm.8;
        Thu, 05 Jan 2023 02:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RqNhCEp4bteb35PgE8tJqSPBDMlwYzzV7hStphy00eY=;
        b=aak24eOQVSlj5aH7JVsbtgYLikHKGDVAcZCW7NmR/gnQZ/HYbGY+GRf0hGuLt6rKE7
         TLTleutIAHtccme1bSQJGowj5jvqHlSprkxzpQ/13NJlJAuul8GP6DZzGCWyIEbZcmEP
         s/+XGdRLPFAaneuCVK3uzYE5DOC1QCS4BfoSrdyRHpT6kreOP2gN+hYvtsT0D+/N61+k
         XkKG7N1NjC0qrO/9lfBbH3f5JCr40j1rirHlDLY16QEkLiwJv0Mgi8g2PSQ+g1kPKJ4R
         XjkH300UgqTE/iGIsmuUcr+0YOO2e0dwLuBOQy0VgkVh4OCc5uA8Jp7SRN6BeJQiY4Mt
         uR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqNhCEp4bteb35PgE8tJqSPBDMlwYzzV7hStphy00eY=;
        b=4yP0pO7HWvwk+2ncXl5kbXyGpyg8eRp/lBQz9xnvjm1sdsPv22Pl+ncScrkkfUBIne
         Jy48BtfZn7hobNpnEtEk99VTDgRQNSzE2SX7n+9u03lBRZTyvcw+avcqoIghavZ7FpiY
         3fm2K94i/lzYGhRV3F1ynk0YnReQ3TGR3JAJzcNMjgTN7y7eqxmV0oL0XCZ6tM00TUhu
         bxHELvmOOMGOadRalYlLepdm90J6mNuDeBMsnyspmIdWUp9af5nxB2aArnYWU+Fr5jKR
         TMS5Poe/lmCg+tFq4pD0F2/c92h2Cpr5clgOTud9t05DTwSAUCqbkd6pszAnWmI7U+Fl
         oFVg==
X-Gm-Message-State: AFqh2kpzmW/EAgkNYy45JS11HM/5h/vHj3unZ9/nuYzIa2xTorLRrK7g
        azIeF2KHlWWfTm94AsQmafo=
X-Google-Smtp-Source: AMrXdXvj47O1ps1STbJ3BDB8/k5vony7tB01NliVO1v2HDEeFA1UQaVnV7xPzliVogztMCrcrRqwcw==
X-Received: by 2002:a17:906:e98:b0:7c1:39e:db7e with SMTP id p24-20020a1709060e9800b007c1039edb7emr56740176ejf.59.1672915753422;
        Thu, 05 Jan 2023 02:49:13 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id l22-20020a1709065a9600b00780982d77d1sm16317802ejq.154.2023.01.05.02.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:49:12 -0800 (PST)
Date:   Thu, 5 Jan 2023 11:49:18 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y7arLoRBJ40eMizO@gvm01>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <5d9b49cb21c97bf187502d4f6000f1084a7e4df7.1672840326.git.piergiorgio.beruto@gmail.com>
 <Y7aSco7bDOHQhQv7@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7aSco7bDOHQhQv7@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:03:46AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 04, 2023 at 03:06:30PM +0100, Piergiorgio Beruto wrote:
> > This patch adds the required connection between netlink ethtool and
> > phylib to resolve PLCA get/set config and get status messages.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  drivers/net/phy/phy.c        | 172 +++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c |   3 +
> >  include/linux/phy.h          |   7 ++
> >  3 files changed, 182 insertions(+)
> 
> <...>
> 
> > +	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);
> > +	if (unlikely(!curr_plca_cfg)) {
> 
> Please don't put likely/unlikely on kamlloc and/or in in control path
> flow.
Fixed. Although, I am curious to know why exactly it is bad to
linkely/unlikely on kmalloc. Is this because if we're in a situation of
low memory we don't want to put more "stress" on the system failing
branch predictions?
> 
> Thanks
