Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E895246ED
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351007AbiELH2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351018AbiELH15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:27:57 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20FF13C1F0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:27:56 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m62so2464477wme.5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H9VXncE+DRnUhXlSN0UZUREZ/aLnoqDFeoFK5grlT8s=;
        b=bL+CTsqaTjYlxSq0nJtEbHVQZ4uCnHEcZIVe13dQNJ77OQFSRMVKXEHr+JfAopQD8Z
         SaUNRkPz15p0rMKmfWN5Y5sqf4kJ3hvI1PIY9JH7/nn5QsZynDomKcGNGK1pJJMjCtZp
         diqfjXhzCxMyiYzP1Xq9Z2A0w8ZnGebKXy7cSvZ1fsTSvlpokOlxNHgHYO3o9lq+MnSK
         +Jt82uTchTU5s0h2lgow9mQKpgJqnru4ShVYlSEEA51u+/j70IWAeU/XxIZErCkq35jF
         ycWq5f92J1NmHv6llR8a2JBvf0HCtLuKqo5J5BRtdGhyA68H0XZePKX7Iq2cCCDxGeMZ
         giag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=H9VXncE+DRnUhXlSN0UZUREZ/aLnoqDFeoFK5grlT8s=;
        b=F06o9E+NxINDEhS7cuSWNRyxiHaNeOiV1zwKTakeKmAXl71Mpas8mP/NL4dyQqsMQY
         DLiZ+Vu/xD9S//rcbK7FJ4EKVaxzyeVA6gAEYz2pzZ6gRMR+VzZG3pPHpNyPS0XqIlG0
         rAvafpv31Xe86on1UJiUVysnlOYp4xr9POKeQb2o3yp9jdZiBrxFtdOav8ksL45bIi/T
         2Rt5Kvjl49VGK76gsVTYA9WULav+psqjSqc750il+eI2UycmnLjBQHn7KJdrQ5nT+0I8
         OIK5lmvs4VFY/bQHyTxFzpnAUWwru3wbolIfOmOAdGwJGmsHyEbMUaXfO7EX5lS3sKxS
         qucg==
X-Gm-Message-State: AOAM530kjC5eJ8OBKM+Wt0e5sCMNK0nAXfGfLHbWVqnpnAI2/KfyoFmz
        Cw404A4zerfIadk84I7mYfY=
X-Google-Smtp-Source: ABdhPJwODapeVfLkcgJGNzaE5AOte8UsQjyA4DBae9z8mwy/hizN2zPQ+MEqxkL7TFzuJHe6fmoDWg==
X-Received: by 2002:a7b:c095:0:b0:393:fd2e:9191 with SMTP id r21-20020a7bc095000000b00393fd2e9191mr8579665wmh.137.1652340475010;
        Thu, 12 May 2022 00:27:55 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id o42-20020a05600c512a00b003942a244f49sm1944477wms.34.2022.05.12.00.27.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 May 2022 00:27:54 -0700 (PDT)
Date:   Thu, 12 May 2022 08:27:52 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 3/6] eth: switch to netif_napi_add_weight()
Message-ID: <20220512072752.wb5rgtlkar4oyni6@gmail.com>
Mail-Followup-To: Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-4-kuba@kernel.org>
 <d61cf1ea-94bc-6f71-77b6-939ba9e115c4@gmail.com>
 <20220511124551.1766aa66@kernel.org>
 <86183449-cb7f-2804-89ad-5c714d99ff5b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86183449-cb7f-2804-89ad-5c714d99ff5b@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 10:02:44PM +0100, Edward Cree wrote:
> On 11/05/2022 20:45, Jakub Kicinski wrote:
> > On Wed, 11 May 2022 18:57:53 +0100 Edward Cree wrote:
> >> This isn't really a custom weight; napi_weight is initialised to
> >>  64 and never changed, so probably we ought to be just using
> >>  NAPI_POLL_WEIGHT here and end up on the non-_weight API.
> >> Same goes for Falcon.
> > 
> > Ack, I wanted to be nice. I figured this must be a stub for a module
> > param in your our of tree driver.
> 
> I mean, it *is*... but there's almost certainly a better way.  Configuring
>  NAPI weight for tuning purposes (as opposed to some kind of correctness
>  limitation in a driver) probably ought to be left to generic infrastructure
>  rather than vendor-specific modparams in driver code.
> 
> > Should I send a patch to remove
> > the non-const static napi_weight globals and switch back to non-_weight?
> 
> Yes please, unless Martin has any objections...?

Fine for me.

Martin
