Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6B46B3FE5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCJNEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjCJNEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:04:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15899DF73A;
        Fri, 10 Mar 2023 05:04:50 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cy23so20024595edb.12;
        Fri, 10 Mar 2023 05:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678453488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y1+Ht7bpjXNxL3DSBoFsxftwWgsER2HIl43Y7H2zIXs=;
        b=Bk9tLrVf9D7yor55A71SxKQN+LJrV+Ko7AXWHdYQ7WZn4V0gBBxdSs08zOPTcTSre1
         U7UJfJWU5ic+DjQ5HMPjDvsYxbJ2TjUsUtTWKsrJ7x5FOl6d/tMD1IagfQPz9bkfkO1I
         KktxjsQrenf8RHXDfRpZ02ziB6phUlOnQmcK3F56VHa72UpqVXZqhQLtG0Ay1DihgGkO
         RTSBGO+MKteSxUzHcVupWJx/DlnFCjUz173Gnv156MIuGRNbSD6yV0HnYzKN3VeZrRUP
         oXRALbVAifAySTnxUiXIoYOY4jc79mdhqjMP8ONvxTKeDsDwPhnRUap2oB2ntWJ03oYf
         fBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678453488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1+Ht7bpjXNxL3DSBoFsxftwWgsER2HIl43Y7H2zIXs=;
        b=iV2MDekZSGBLQ9bwiMa/vOdSOMO3DR4w2YmGPcBgfBfUyIxp3+oVcFR/J0XKE4bnuC
         DUOzSbXdCNo9hHvTadIOntioeaK/pdvBOqhZSGaxUzLiWv/Q8jfICY27t7fBZCeuJAxB
         SbzNFQmfzGQ9v/pFTgTsD0HW5b2gOipZ8uVEcuUnCdatTWZE0Y7QhFh2q/AwL50/QkcD
         s4YT/qtJgP/QC6s+URSsno6Sn3l6QezJLBFG4jvuJjvnAhhrtWXeOzSY7w3cKyMmt/Yc
         NrWGmUec2V+yEP87EClw+Q2OrdY1lQItEqX19kJVpSUFaAggH9TjEcD2dYH8CHQg/b1K
         7zrw==
X-Gm-Message-State: AO0yUKUvDTxbgajFojCvTh6Dj6Tov6oVezmFy+y8My5Gf4bWYHFlP7Yl
        ijqx+h21BqDChNTs+uzPFfA=
X-Google-Smtp-Source: AK7set8R49OYlTwb7KxRqCzIepr8zmxcayyNgw7OkKqlpDZnx2rGetgkhNsYDbh2XxLfoPErgTv8LA==
X-Received: by 2002:a17:906:2f0c:b0:878:61d8:d7c2 with SMTP id v12-20020a1709062f0c00b0087861d8d7c2mr24675192eji.39.1678453488479;
        Fri, 10 Mar 2023 05:04:48 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m25-20020a170906235900b008ca52f7fbcbsm942158eja.1.2023.03.10.05.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 05:04:48 -0800 (PST)
Date:   Fri, 10 Mar 2023 15:04:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310130446.ltgtqpqpn4cboyfb@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <ZAsh12DdwDfKUW8F@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAsh12DdwDfKUW8F@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:25:59PM +0000, Russell King (Oracle) wrote:
> This is similar analysis to what I did for a previous patch set, and
> came to the conclusion that we need code in the driver to validate
> that the addition of these values is in fact correct. See my previous
> reviews and my recommendations on how to structure these patch sets,
> so we as reviewers don't _have_ to go to this level of verification.

Ok, I haven't read other patches or comments except for 1/7 yet.

> > I guess I will have to fix this now, since you haven't done it.
> 
> I'm sorry, but why is this Lukasz's problem to fix? If it's broken today
> when using mv88e6xxx with this PHY, and Lukasz doesn't have this PHY,
> why does Lukasz have to solve this?

Well, in principle no one has to solve it. It would be good to not move
around broken code if we know it's broken, is what I'm saying. This is
because eventually, someone who *is* affected *will* want to fix it, and
that fix will conflict with the refactoring. Lukasz would have had the
interest in fixing it because he's touching that code. Again, I will do
this when I find the time.

> > > +	/* Max Frame Size.
> > > +	 * This value corresponds to the memory allocated in switch internal
> > > +	 * memory to store single frame.
> > > +	 */
> > 
> > What is the source of this definition?
> > 
> > I'm asking because I know of other switches where the internal memory
> > allocation scheme has nothing to do with the frame size. Instead, there
> > are SRAM cells of fixed and small size (say 60 octets) chained together.
> 
> The switch documentation only really talks about maximum frame sizes
> that the switch can handle, with a few bits that configure what the
> maximum frame size is. We also know how large the SRAM is, but how
> the SRAM is allocated to packets is for Marvell engineers to know
> and not us mere mortals.
> 
> So, the base definition for this is the information provided in the
> switch documentation.

Agree with the "mere mortals" comment. I was trying to suggest that the
given definition tries to make it appear that we know more about the
switch internal memory allocation than we really do. "This value
corresponds to the memory allocated in switch internal memory to store
single frame" -> how do we know that it corresponds?
