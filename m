Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339C5767BC
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiGOTtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiGOTtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:49:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A321113E94;
        Fri, 15 Jul 2022 12:49:02 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oy13so10734990ejb.1;
        Fri, 15 Jul 2022 12:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=nyNdhj7h4w1RZhYEVhON8j8fAKw3816cfmCoVqpY7Vc=;
        b=OfnD2D1APF5Ahz+MfALD3wa03aF1C6CkiZ6G8icXCCRnwZW/btDn5A1wm0WlILrylj
         yEtmwd36pSHI4lV63maegknIJpnrBDiRTNvjuOoGtg+dDqoNfiGbQj9TfMdSRBeFvTKd
         m4U4H9b7/iEcE+YmJAfQ5ZXTlYextHCdZT8z3Wc7pL+VIaoyA1C2//na2fIlWC0is8vD
         44dsw/pL0uNwWmCkpz/W1McXo8IJMUpR/VdjvNnDAyZSopegRWQQwtBdmYdZT4DEVMWx
         CrfLSV043WbQTVIV7Ry+KWHzgBbGhFWHrDIn12GAeoq3JY+a9WftFRP+tATkafIpTry+
         VVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=nyNdhj7h4w1RZhYEVhON8j8fAKw3816cfmCoVqpY7Vc=;
        b=gdlLHmcZW13OsucqSIj3GHvmZyDZpOqT9kUFLZt8mDyjLTJyZloMSRDra8LjYFulfq
         2PAnCuRgUE6xgqLxPbzzx4VhVn8bw+kSNvuFWbnBBC+hJLaqN1JZP7JF6t90fA+/v8/Z
         oOk5dbA/VsrAdVyB25jVzJsvAROMmnCC5n0Zs1j7dYM1/bj4pFZGtjSWGxBCA6+Wg1c4
         nXR8720cu7Nzqy76XmqbJSpNSs5IQsZPjXvbVSJDTvjsVJd0OICqN0zLIxkGvazGs45E
         3WeC3IpOge1mkluISOJ8X7ZNpfbq2z286SMvl5v+IVA5VIaA2JkYa0wQMWcQIMS00K94
         jnpw==
X-Gm-Message-State: AJIora8LNp2Cpgr7YnuY5/gyEPqoHQYrbFdQGdtBdJW4+gWGtxYnmXop
        KdCJfNo84ybn4yBwm1DOsLw=
X-Google-Smtp-Source: AGRyM1vWakNrsj+lGhP9My202oySEsrWktklkZej+gdmR5ILzJTYXJMroOm6suyydpwM2+38eQWwqA==
X-Received: by 2002:a17:907:6da9:b0:72b:58ca:e3a8 with SMTP id sb41-20020a1709076da900b0072b58cae3a8mr15104929ejc.342.1657914540973;
        Fri, 15 Jul 2022 12:49:00 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id kv14-20020a17090778ce00b0072b85a735afsm2305276ejc.113.2022.07.15.12.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 12:49:00 -0700 (PDT)
Message-ID: <62d1c4ac.1c69fb81.a2fa0.5669@mx.google.com>
X-Google-Original-Message-ID: <YtG/QmRUVNgSDA19@Ansuel-xps.>
Date:   Fri, 15 Jul 2022 21:25:54 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
 <20220714220354.795c8992@kernel.org>
 <62d12418.1c69fb81.90737.3a8e@mx.google.com>
 <20220715123743.419537e7@kernel.org>
 <62d1c288.1c69fb81.45988.55fe@mx.google.com>
 <20220715124717.5472ceb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715124717.5472ceb3@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 12:47:17PM -0700, Jakub Kicinski wrote:
> On Fri, 15 Jul 2022 21:16:46 +0200 Christian Marangi wrote:
> > > > Or should I just propose the move and the code split in one series?  
> > > 
> > > Yup that's what I prefer.
> > 
> > Ok no problem, if the current merged commit is a problem, np for me with
> > a revert! (it was really to prevent sending a bigger series, sorry for
> > the mess)
> 
> Oh, I didn't realize Dave already merged it. No worries, it's not a big
> deal. Would be great to prioritize getting the split done next. If both
> are merged for before 5.19 final is cut - it doesn't really matter if
> they were one series or two.

I'm just working on that... hoping to send a patch soon, just need to
investigate regmap bulk read/write changes...

-- 
	Ansuel
