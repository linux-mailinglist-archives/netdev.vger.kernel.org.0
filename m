Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4036B3FF0
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCJNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjCJNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:06:40 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6336BCF0FE;
        Fri, 10 Mar 2023 05:06:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a25so20343554edb.0;
        Fri, 10 Mar 2023 05:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678453598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8b+TwHjq5psufUfXnhex/vZckZzcuD/CYLoQAdV9/vM=;
        b=kZZoigZJcGhoUXyaYnubwFwsELDfRCHHa6dYqBWQBm52vjPe9rmcFTXwDqh/9uriMl
         LJ5Jp7OYvCdQPeNDb2VgLigdbhhu4J9Z3VZ5bvDKFjeETbAlG2xw6sNKc9zXoUPOQ0ZZ
         bP51kg+9eJpcSNy8dwayuYKfQim2k1cxzJu1QlzU/BRW3tDkjHpqpE1DoZnKuTXqyCCR
         8gaHkviR5GgENayayHQMpqgAP7mBSl79BpWHOYSORhAQFqhun3Kf72DT0K2GD2hVFows
         vsFv188MrEQ6EUMKojG/5644gDShGhBdWT+OSr6yIQQfQ1NqGM6/2EDCd6wqxcf7xv0J
         qYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678453598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b+TwHjq5psufUfXnhex/vZckZzcuD/CYLoQAdV9/vM=;
        b=n78J2fshN/qvHJ4c7pLXuDy1YWgpPGgawwtGxYiiA9EgAJ8ZUyJWtBNhtQJjIf3ztH
         f9ST7iwQx1IBqP9opweSAzgpa/b3QH/amSeVPxL9XJByRlQxgGm8SgeszWNeWfHkD1aV
         yrd+9QZHVUTOPG4vvS75w0aHYHeASukLmIQOXl6bGXKzKurAkn7PRb0N+0IbISQlJkyO
         jbU+H72IBf10E05l8/S7Hz1F0K3mRx3BoAjKw2fMKK5YmaX5GzyoCUVi/t/+xPXoiRa6
         uP9dkmYFxs76XvEqxYCjC72JScwRz5GyD3c4faL+4fk8+oyrxz/DKzTx1q0hHs9D5/Uv
         ZBTQ==
X-Gm-Message-State: AO0yUKViNPNLJwugKBZWvHOh1L5SglM9XAWcI+vJ+a67bEOciPSmgg6F
        b7SHraW58jPoFG1+NHF0TbQ=
X-Google-Smtp-Source: AK7set+dF1Dup24EQ1bhn/POd6AH4GUahNAdDKzqdLbVO66wXD5qUN6x8PLjFlkCv4lVdyQUFN7c/Q==
X-Received: by 2002:a05:6402:690:b0:4ad:7301:fe77 with SMTP id f16-20020a056402069000b004ad7301fe77mr22193114edy.9.1678453597796;
        Fri, 10 Mar 2023 05:06:37 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e26-20020a50a69a000000b004bc59951d6fsm812697edc.57.2023.03.10.05.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 05:06:37 -0800 (PST)
Date:   Fri, 10 Mar 2023 15:06:35 +0200
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
Message-ID: <20230310130635.xuhyj4vuom22pgbh@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <ZAsh12DdwDfKUW8F@shell.armlinux.org.uk>
 <20230310130446.ltgtqpqpn4cboyfb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310130446.ltgtqpqpn4cboyfb@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 03:04:46PM +0200, Vladimir Oltean wrote:
> > I'm sorry, but why is this Lukasz's problem to fix? If it's broken today
> > when using mv88e6xxx with this PHY, and Lukasz doesn't have this PHY,
> > why does Lukasz have to solve this?
> 
> Well, in principle no one has to solve it. It would be good to not move
> around broken code if we know it's broken, is what I'm saying. This is
> because eventually, someone who *is* affected *will* want to fix it, and
> that fix will conflict with the refactoring. Lukasz would have had the
> interest in fixing it because he's touching that code. Again, I will do
> this when I find the time.

also: what PHY? :-/
