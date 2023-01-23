Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E5D677A20
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjAWL2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjAWL2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:28:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9B1117B
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:28:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x36so14112079ede.13
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux4PiLJFapyoUK/S68HgSPaL4amDdN4n8b3J+S07Rxg=;
        b=Un06DrsC0AFN66qi7qYE/8MlX8VMaogxy47RS15W3LZNP6PoQNcwO4HF8zNHGIMaLY
         bwOQT/PHMEX0FeUPMY7VgR/V0KeFdxxWYqRNzFuwoFZQBwe53W1Ke4CBNY3c3RbpoUFC
         jNdEC3jC+om80BOTYhFHnYFnHDz4mPIj+3aXyT3JoeFTJVCDctV0IV07OhyYtVQc1JZ0
         3YW3Nf8UZJ1rfGNwJQSjOW3yEJ/vn2S7OkBNAD4XC0IAaEl1c8nSgxms/S09ajX8ymDL
         s2or222fU9RRDdYC5scwiEv0cmFBHAEdr0RCZiEebir9ByWSwvAJd4rj7OJPIo/eOl7H
         0Fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ux4PiLJFapyoUK/S68HgSPaL4amDdN4n8b3J+S07Rxg=;
        b=TmiJKM+jmkhfOMZbO/AMMQIHOJDjzDAWy1hNx+LrxU3wE4TigVZCYjnv7lkiUe+69u
         DyXLs1/r/cxeUQHsl4/YifZjTZAmv+CXESGQ2SY2Yo73On41I/mOFL8FbtoAkdIM/3ls
         9/9NZW+W627htKJ223tWLP+TZ6n0JU8mUEEcm4p/oz9DS8yxKX8BRXXd7fwKftUvuVQa
         vHEnXIfWWb47vg0PK6RVDzqZv7t5R8cg4WYpjgTu+YDDLi8AAFLElioQWFEsNREnHfux
         37mNqrxZqhVYs8/BgeO13vC+WnolwuLLIpdXJ6rKNovT8ZbfS+kc10obqqAdP2ofCZru
         O5Xw==
X-Gm-Message-State: AFqh2kqgBkL1J1SbghbUvv6sSV3xjGR1+AcMZokyV8r1MbUgPWxu9jKq
        1u9XtCHQ+xh9aEauBGhDCBY=
X-Google-Smtp-Source: AMrXdXvthC3I+Yr7SOcUBEc6f5+DLV4onSEe0EcnP5MlyEE33d5NWrvLMLk+aeXyaZlzeR3xYcpSHg==
X-Received: by 2002:a05:6402:2686:b0:46d:c288:e798 with SMTP id w6-20020a056402268600b0046dc288e798mr34260390edd.21.1674473311232;
        Mon, 23 Jan 2023 03:28:31 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id eo9-20020a056402530900b00463bc1ddc76sm13576990edb.28.2023.01.23.03.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:28:30 -0800 (PST)
Date:   Mon, 23 Jan 2023 13:28:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230123112828.yusuihorsl2tyjl3@skbuf>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
 <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 09:52:15AM +0100, Angelo Dureghello wrote:
> I am now stuck to 5.4.70 due to freescale stuff in it.
> I tried shortly a downgrade of net/dsa part from 5.5,
> but, even if i have no errors, i can't ping out, something
> seems has gone wrong, i don't like too much this approach.
> 
> But of course, i could upgrade to 5.10 that's available
> from freescale, with some effort.
> Then, i still should apply a patch on the driver to have dual
> cpu running, if i understand properly, correct ?

What is the Freescale chip stuck on 5.4 (5.10 with some effort) if I may
ask? I got the impression that the vast majority of SoCs have good
enough mainline support to boot a development kernel and work on that,
the exception being some S32 platforms.
