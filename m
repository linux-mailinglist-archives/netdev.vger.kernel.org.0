Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F5D6AE19F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCGOFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:05:41 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD137C3EC;
        Tue,  7 Mar 2023 06:05:40 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a25so52914849edb.0;
        Tue, 07 Mar 2023 06:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678197938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukky4zoXb7wJGuv2PwqjkXqCSu4E9sUcvBY9ClpblM8=;
        b=WmTtxah7q9nBzxqx7en/xWhcf6g3mvU19ql4CesEKYXG64NiuMc9uAOL82+akOEnKQ
         7ir55QPkvw+xO2YWMbA775Gx+Lv3u4JcNN+vKgaJCzhsQKD664uamzXukLyTEiQ26dNt
         SAKPFJOEd2YYuUXI8rLIiO8ZsQa7hyqo4S3Oi+ZtXBoklXJysBs8HP4w0DJj92exG2I4
         7RGPguHrB2jnxFtiA6agVPxI+NN0eeObOAHR4gIxgoU5Kopjz2TTn0N7Y3sipCOfnzMe
         OYn4xbtCqAmFzO647UVFXNurmeFdr4X0BEq4eBUVS05ls9Z7dwqCbZBap8dhG2YtSijP
         TifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678197938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukky4zoXb7wJGuv2PwqjkXqCSu4E9sUcvBY9ClpblM8=;
        b=vwvJGdUfJvgfKtpOq9itoMvT7LifdZfKQGHR+gtkf1dtCGa2+DI+gAlKYC8s1D/q2d
         WCb9EhGvHENcWLFdbKbrFouLnAEv+xon0GJctEU33zFN1p96raUvEys1xnQ3eiCmZNlO
         0QFdg7UfYFk/xyR4xZasgM2DSKg5dUbkJh9aIsaytdFLTyib0+fzEAgl0jnQgmZIUBSV
         5uruOt+/q2tCx+AUe3cQXAymEmNlFBnlEwjqsW2aBFiIs1l/a5HuMZeo/BKaLG4Lzg/T
         oRJ/CofVjzMqx/Oi/kCXeutiwzWI5MtbEnjxm5cLvlWjW+L5qX1/pVpt8VhwnQ6JVG6j
         dirA==
X-Gm-Message-State: AO0yUKV/IDpW00Z/5zVj7NK1KQ1I3cEKxar5Kn2YgdtBfEOV/B+4u95r
        cgiS1Kv4TERVRNMxqMJYBg8=
X-Google-Smtp-Source: AK7set87iTZDtKTRzdXJLXW/WPPD/Y6D6WaOPEe/HB/FsAt0bGvsktUQ0fq3KnJxEhKiKhSoLpsDig==
X-Received: by 2002:a05:6402:884:b0:4b1:2041:f8b2 with SMTP id e4-20020a056402088400b004b12041f8b2mr15722574edy.15.1678197938485;
        Tue, 07 Mar 2023 06:05:38 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id r15-20020a50c00f000000b004bbc90e1fa3sm6772685edb.93.2023.03.07.06.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 06:05:38 -0800 (PST)
Date:   Tue, 7 Mar 2023 16:05:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, sean.anderson@seco.com,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com, tobias@waldekranz.com
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <20230307140535.32ldprkyblpmicjg@skbuf>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <20230307112307.777207-1-michael@walle.cc>
 <684c859a-02e2-4652-9a40-9607410f95e6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684c859a-02e2-4652-9a40-9607410f95e6@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 02:49:27PM +0100, Andrew Lunn wrote:
> On Tue, Mar 07, 2023 at 12:23:07PM +0100, Michael Walle wrote:
> > > To prevent userspace phy drivers, writes are disabled by default, and can
> > > only be enabled by editing the source.
> > 
> > Maybe we can just taint the kernel using add_taint()? I'm not sure if
> > that will prevent vendors writing user space drivers. Thoughts?
> 
> I was thinking about taint as well. But keep the same code structure,
> you need to edit it to enable write.

But as per the commit message, this locks us out of the following
legitimate uses:

- C45-over-C22 (reads)
- Atomic (why only atomic?) (read) access to paged registers

are we ok with the implications?
