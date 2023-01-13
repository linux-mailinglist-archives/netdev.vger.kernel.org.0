Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0AF6698A5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbjAMNes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbjAMNdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:33:51 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6F86087A;
        Fri, 13 Jan 2023 05:27:04 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v10so29956722edi.8;
        Fri, 13 Jan 2023 05:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LcdSKrbHecxVl2sx8d298kE2LQz+kg4JRhbTRziN4YE=;
        b=SPKHnH0Z7GNksZOapygKhxeLEZp0s/6Ob/2ihugvaz0eaNIP96o7pQyHDWCqGPelt0
         47uTTj84/XoAW38OPeTZOFFaINRWY20zqtpww83IUqIG69+a8hDOzpsp1bQTT5Veodk6
         CZVWnzm6c4WK/fbfEJ5PqTYfP+l1R7RwBerhNpbEQ+dI7XIVOakOj27iQl2jSDt57d3U
         Afh+aAnqtlg/BWlZ3h9JruBajcYlOk8l9fBGMhsH/zH5qrLuSC4+9y+EANeu6KDf0ntT
         RalOFjmNGnUUbny3K3ZEv0XX8VH3XcHdXoAC4DDDvhlE0lPStsz3Ydn1zXp2xAi6oS0B
         aESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcdSKrbHecxVl2sx8d298kE2LQz+kg4JRhbTRziN4YE=;
        b=NMDqqkMrFMdo4c2R+XYPHMbQ78l6tCrQ/UE226uaeye2ZuZRPxCnXUJ6+m2K6Kg3u2
         BbQRIafMjxrtMHUl4Q9crZ7cI0a0B/vzvrJNhpQnawoYZfzgwLQQXxeRM4A7RvmGrk9A
         O0RS3YsNMV9JPRe3nQPcQ3ASA4J58FlUA0bq8kOWffakYTCXcGATxYGNqJTfUoM4cnia
         pI+s6qxC1nf1NTbAcO+9ZNaAi+lwOKdNNNyl74v9aKBbW4pS8/SfCxTh9vFFzCLvSvCi
         EGtzevuzwr5z5jn1GnB610Yh5pEwsi4V/vTPPQ7vhusTTgJLpAgTdf5oqYLuJWTC92Ur
         QSJA==
X-Gm-Message-State: AFqh2kpCCciG9yDe7kZUt2YjT8ikmOF4LclMfZpowLxsrVADFEnaQ2Cd
        Hnv82yTWedoZf+JfQPc9sGI=
X-Google-Smtp-Source: AMrXdXtGDIxyQG8nzLJy07aBvT8JPW8rrV0yCRZVOxkXaiujZ7px5ZR6Roz+YVT2fntQ/PDWeGW4KA==
X-Received: by 2002:aa7:c597:0:b0:499:b53f:1c56 with SMTP id g23-20020aa7c597000000b00499b53f1c56mr15504765edq.38.1673616422673;
        Fri, 13 Jan 2023 05:27:02 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id eg49-20020a05640228b100b00488117821ffsm8265377edb.31.2023.01.13.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 05:27:02 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:26:58 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 1/1] plca.c: fix obvious mistake in checking
 retval
Message-ID: <Y8FcImfvUAVa4NoB@gvm01>
References: <df38c69a85bf528f3e6e672f00be4dc9cdd6298e.1673538908.git.piergiorgio.beruto@gmail.com>
 <Y8EU9bCLj6UOz7g8@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8EU9bCLj6UOz7g8@debian.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 03:23:17PM +0700, Bagas Sanjaya wrote:
> On Thu, Jan 12, 2023 at 04:56:11PM +0100, Piergiorgio Beruto wrote:
> > This patch addresses a wrong fix that was done during the review
> > process. The intention was to substitute "if(ret < 0)" with
> > "if(ret)". Unfortunately, in this specific file the intended fix did not
> > meet the code. After additional review, it seems like if(ret < 0) was
> > actually the right thing to do. So this patch reverts those changes.
> 
> Try to reword the patch description without writing "This patch does foo"
> (prefer imperative mood over descriptive one).
> 
> Thanks.
> 
> -- 
> An old man doll... just what I always wanted! - Clara
Fixed. Thanks.

