Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8CF4F6E5C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiDFXHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiDFXGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:06:39 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6D3DF0A
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:04:41 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w18so4355541edi.13
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 16:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ng4BE5kXBR6M7iRnLhtVmJwgxAJONqFet0RBErlrqsQ=;
        b=WSozX+U7WSL0RTutmWOr6gUn5UXA61+gXMqIXnM4dNrmeVQhGsjj08yEvryaBhj8nG
         xm2+1+UYerFCCvl6UybH+doHleprLVptTjWZmFBdz2ZFwXAA8hgwhlwkFezN06xj8iCk
         7Itmc55e96Hr8y9WEOfcliIpdU/2N222ajwszPT9BJ1HRYKFbMj3GVTGhGXJmQ6L0OD8
         KtAH9wWHa8Na049nhltd5SiV3Yp61qLDFS22Oi9zyB/38MV/WgefkCdawKcEfiBwMlYT
         wYjHsZp8jMqC3mXv/jb/B1hfKVvjhpdnNlMmhTNRw/R3gvgrHOWBMQLXf3QKcAIo2JkN
         6bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ng4BE5kXBR6M7iRnLhtVmJwgxAJONqFet0RBErlrqsQ=;
        b=dIyMoixWnqzOFB+MwNeyfmByp1lRy75ZFynKqqtvUkGUA8CSBmgV7QxkWnkmlI6NQE
         IjAaidsOpOm6qR3awM05SF47J422v/ogaLefMiihECyuKIuTjvOiqGmL1+a2GomON24n
         Ty8ZgXmKzPWUQXNvVlNIIJPdmRuWwuKYvDSx6HQIlsc6jNZ4Xi/f7vFI5KFv6hyOKRXT
         OsC9VpRQxfqfuGfR3MIeYIMu8YcD5BIOtxR3ODIUIW21Qg8omTCAm4gbFs+CLaKgtO6/
         kMEr+nwqzQi+5VMJKbh4eTq04cTcA5M6re0rgA1+P3MBwFETlrmV24008CNRvFcXNPIe
         R7Rg==
X-Gm-Message-State: AOAM532iT59unTn5/h1AY6wookM9aSEIZESNXYaxcJGkrQNmcSlYZzLH
        UijaKoTeL1cttiuUWXKOVr4=
X-Google-Smtp-Source: ABdhPJwuBcYfD+AebBRlac9DlFXI/yLKxGjWym7CpjNLUBocZhEWDeDLAuZZ7vDv7fhTgLYQZqCArQ==
X-Received: by 2002:a05:6402:274e:b0:419:81a1:ed9b with SMTP id z14-20020a056402274e00b0041981a1ed9bmr11335557edd.9.1649286279727;
        Wed, 06 Apr 2022 16:04:39 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id ga5-20020a1709070c0500b006de43e9605asm6997655ejc.181.2022.04.06.16.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:04:39 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:04:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] ptp: Support hardware clocks with
 additional free running cycle counter
Message-ID: <20220406230437.GB78819@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403175544.26556-1-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 07:55:39PM +0200, Gerhard Engleder wrote:
> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with TAPRIO hardware support
> is not possible anymore.

I'm travelling this week, but I will review this as soon as I can.

Thanks,
Richard
