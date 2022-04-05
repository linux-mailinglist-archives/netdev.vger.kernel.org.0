Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7C4F447F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382749AbiDEUE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457463AbiDEQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:03:16 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCAC2BB1E;
        Tue,  5 Apr 2022 08:48:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bg10so27636517ejb.4;
        Tue, 05 Apr 2022 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E38QQr9nB24NNJ/G023H8O4a3cKJ/it1AOTVqPnX8RM=;
        b=ObhWCkRvhGXHpHM1/u3+NcCWx0zRTx4n4Uf08i4OVwf9xI5K+LJ5Fe6890riVKnBGl
         tPmzVz/gU/wwqQGB0f6JVomn6DCYvTCIzDAgrx8R+ZVtEcMECNzDBO00vPsXWBZ4qnKQ
         0E8C7uiKMuxlGLcBevgJXGU/sMjQFMWfYgD3c5xXOoql5+d5Mj9GmC1jpBFmTbxgILpb
         ZEMukTT8CV8nWTKfDorwwFaKDYT5y5J7OOfyaP/9k/bLp82kXs93xLdCqeOWTJPyVoEw
         s496oTHL8RF5qtTo7cVT3McogR+YVnXb/qSIhY14zbhvs8W5gKolIDBuQPcqD1908Oaf
         apMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E38QQr9nB24NNJ/G023H8O4a3cKJ/it1AOTVqPnX8RM=;
        b=TzceWJpYs6mHNPc5KoHyJoc3TDPls0j/KdJ0qikA5zzmoCYnggNEO5Wfbf9nPclml/
         BgZsxi+fSXTB/88QWMR9JzuiaoMmAe58Z2PuTvywdvRqpGPb8VVgT/KOPizq0b+Ee+Sg
         Fy9z+RwD49ZnE5vxKBIfssEuSYTMe6+RBDTZrR3lNaq+21IO8fHCoPdyywMMpof4RUsk
         vFDy2y9udqa1WQZrI4jsUQx0fxzYZgwWvx/QOacFRCNrPLYsLS6NHxqf/xm/41BHoCkr
         OHKaX6Oj7VQIZAUiErZLY05sJYmr3Y5p7R4snkkvxRoBhwzTyGoAea5QZFkf8rVeqXFT
         kC6g==
X-Gm-Message-State: AOAM533ETG66DGbTMjdJsxt2uj5x1RtaIrGfZhdJq6vthpoUvcZkjxc5
        NllnOPzAOf3CWibkxtMUTH0=
X-Google-Smtp-Source: ABdhPJws3/NJQNCVTCpwHhViuOuVlqiE7qYkyjOT+rPOleHN9ZpBsf4BIJpwcFf8r6GIYIrvLqvLsQ==
X-Received: by 2002:a17:907:6096:b0:6e7:cc3f:c33d with SMTP id ht22-20020a170907609600b006e7cc3fc33dmr4354432ejc.570.1649173704674;
        Tue, 05 Apr 2022 08:48:24 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id g2-20020aa7dc42000000b00418ef55eabcsm6761822edu.83.2022.04.05.08.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:48:24 -0700 (PDT)
Date:   Tue, 5 Apr 2022 08:48:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Michael Walle <michael@walle.cc>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220405154821.GB6509@hoboy.vegasvil.org>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc>
 <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
 <877d83rjjc.fsf@kurt>
 <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc>
 <87wng3pyjl.fsf@kurt>
 <defe77d9-1a41-7112-0ef6-a12aa2b725ab@ti.com>
 <YkxEIZfA0H8yvrzn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkxEIZfA0H8yvrzn@lunn.ch>
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

On Tue, Apr 05, 2022 at 03:29:05PM +0200, Andrew Lunn wrote:

> Maybe. Device tree is supposed to describe the hardware, not how you
> configure the hardware. Which PTP you using is a configuration choice,
> so i expect some people will argue it should not be in DT.

+1

Pure DT means no configuration choices.

(but you find many examples that break the rules!)

Thanks,
Richard
