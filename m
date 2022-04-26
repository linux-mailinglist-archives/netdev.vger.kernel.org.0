Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13A550EEFD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 05:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiDZDGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 23:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiDZDGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 23:06:04 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728364BC7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 20:02:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q8so5800511plx.3
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 20:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tVNV+lpOFrQou4OBagKTX+xUF/aQUFtboYpF3YEpMw4=;
        b=Tfu82BAJuGv9EK5XKEdk2M3DniR7klPTIYHa14Or5N0zgMZna77854owklwNSppH7B
         K7jLjlcJPMPSCheCG2d5Ldtv5HE7vvlyC9/9rxJPv3mFKQKZ808tkK6AiGABpHiBSLe7
         pJ39EhjfIQCsttn56n95Pl7+6mxRLNr0yf3JUEqis1+tqY2S2FkQqncHfu/JXHfgRCVF
         H/8K4/m//xDnmWF7yYlgiAytkLSl7VCL9eq6AJ8nAcS/i/My6At2xXc3paxRKesp7u8f
         KBCSlyGw7/jh3j3T5vWnF7cikZzn39G6DKL9NRB22369/HxMdKZKe1I8ZofAjn4ihkOj
         R9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tVNV+lpOFrQou4OBagKTX+xUF/aQUFtboYpF3YEpMw4=;
        b=e413TOSP2NqhdSJ6tN/ER554/vUlGhIZiJ5tOJCzYUbiawPu+XrvJe8soJRkPoYaXh
         2KINawFq0ImFvqKw6FRdyj06ApY64Ra3HH4qJXIprK89CuMM+IuypZizLS6aFM/yFKjO
         9wJa6BCsG4GBUj1iHsz3KQKkL3JaLl1pCXDIKlXm4sejrCnHpj7hMH7JE9xPl/XnLKXS
         GvAcx0vn0wVbbzUoxz5GIl1ZWMSiJi/abXHQHsDSeIlD9aUofhGF1zTCByrxRf9j5xeA
         Y8aSi8ecbWwGV9XOj4yDzFkVmIlUBmbbDjuPGEN5pyue1q4kaPGgxGT9iDqtiUNWrpjC
         /3vQ==
X-Gm-Message-State: AOAM531V9qKLYfzboivuV74eBTJ5IKkpb/bsrcjmq2/j9Kjh08sOdxjK
        IteG8J3oOUemhxYMv6uotbQosQGvGMM=
X-Google-Smtp-Source: ABdhPJymg2ILW5KsMOpM9G/PDK67qkO3NIksDbB6yUhkLvtoRT+7CjQPheiYWKhSqksGAWyqS5FvGg==
X-Received: by 2002:a17:902:7e06:b0:159:6c1:ea2b with SMTP id b6-20020a1709027e0600b0015906c1ea2bmr20888273plm.105.1650942178476;
        Mon, 25 Apr 2022 20:02:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090a064200b001cd498dc152sm1596304pje.2.2022.04.25.20.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 20:02:57 -0700 (PDT)
Date:   Mon, 25 Apr 2022 20:02:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220426030254.GC22745@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425011931.GB4472@hoboy.vegasvil.org>
 <20220425233043.q5335cvto5c6zcck@bsd-mbp.dhcp.thefacebook.com>
 <20220426024915.GA22745@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426024915.GA22745@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 07:49:15PM -0700, Richard Cochran wrote:
> On Mon, Apr 25, 2022 at 04:30:43PM -0700, Jonathan Lemon wrote:

> > The BCM chip inserts a 64-bit sec.nsec RX timestamp immediately after
> > the PTP header.  So I'm recovering it here.  I'll also update the patch
> > to memmove() the tail of the skb up in order to remove it, just in case
> > it makes a difference.
> 
> Okay, this is something different.  This won't work because that
> corrupts the PTP message format.

Wait, I see, you want to copy the back of the frame data over the time
stamp.  That makes sense, and it avoids clobbering the reserved1 field
(which aquired a meaning in 1588 v2.1)

Thanks,
Richard
