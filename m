Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA46694A8
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbjAMKuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbjAMKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:50:22 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76F376EC1;
        Fri, 13 Jan 2023 02:49:41 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id az20so32314436ejc.1;
        Fri, 13 Jan 2023 02:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9cvZXpcS72IMKj5Po+HwuzOX75feGFTUqZYMrZfX80U=;
        b=el8QkHzE6jaEwCGMzGnJzCRxCUmBp2JeHr0CsO2oJwuZKeb8AOHBvvN1oClCjQqjLy
         Pvdy2UTN/1TN61BnSyPHm+YNzDuZslbEY6eNM2bAj4pGqM4tUgQ8bZ6OREX8XoM4ANZV
         RSBrnTdrmOgsvY1Kskoe6TK9ma9REsg2zxE8509CvD/Yfwdf8vK0+ljhPDY+6eZ1moe6
         /RR9CkL3mW1xJgcq1+R6+FaOxsrCcXtQjy2EAcABCelopdoEiFm56ioSLKNu6QxYtGMx
         5I2aVPqgDRJrmWnpXxaGpDSg271mieWBRlA2I+fCGbmKHFs//DRVE2Mtla6vcRX05Ewz
         ZIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cvZXpcS72IMKj5Po+HwuzOX75feGFTUqZYMrZfX80U=;
        b=g9c047MW8mf2B8EZqfzSEKb9bZAEtx8m9psNtlEMMdrlrBB8nQlrvEdsXaIZXqIayB
         STiVqZanv2YVJYVwu06VIT36MhSvXs4v3n1ThlB6ItdLf4ahcXQ1dcNIRyXaP/gXKN/g
         g1AY2Dl3CNmM5hGJ3+uAy6SnUnfIimcZvvdTli8AYYmK++mw89ANfIyNqaHEXI9rhxAb
         lkkM9SkzBr9UHPGLFga/WC3uIALi95Kq3avfS0JUtpk7uYbMrgkKaGeKy9us+ZKRUB9J
         8h5YxLkF7V3SxOEr7nBDxtNeiBIXkDq/OSF1BfpJ8uipHj1Awbo/p4o943FohJB8BVPl
         kmlg==
X-Gm-Message-State: AFqh2kq+6l8aclWKgoiNlQFVbZfSLJemxhORr9+rsK2HR0vaOhPuFF4m
        OSemycptHePwCHdEoR2/b9s=
X-Google-Smtp-Source: AMrXdXt//PbqJoUmQbTpBnWsDD75TA0X1gO8kdqA9gSdJX3Fng2j1Gidi9g4TmDRrgBszKtVhwCTaA==
X-Received: by 2002:a17:906:24db:b0:7c1:5b5e:4d78 with SMTP id f27-20020a17090624db00b007c15b5e4d78mr2703342ejb.51.1673606980176;
        Fri, 13 Jan 2023 02:49:40 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id wd3-20020a170907d60300b0078ddb518a90sm8404057ejc.223.2023.01.13.02.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 02:49:39 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:49:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113104937.75umsf4avujoxbaq@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
 <Y7gdNlrKkfi2JvQk@lunn.ch>
 <20230113113908.5e92b3a5@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113113908.5e92b3a5@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 11:39:08AM +0100, Lukasz Majewski wrote:
> Are there any more comments, or is this patch set eligible for pulling
> into net-next tree?

How about responding to the comment that was already posted first?
