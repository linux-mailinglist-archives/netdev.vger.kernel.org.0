Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CD35A812B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiHaP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiHaP0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:26:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96261D83C8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:26:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so18893279edc.1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tNF8cE4tubUhJi8auONGPM7bGbogIilKTUH38WvfphE=;
        b=nfMgf3OAE/0ucFsaBgM37cQAzf51rk1npc+p0/I3g6VY//fQo+VoJB77U44GwE+DTj
         1s+56xDs9qZlKxK/FjaUL76/E9O3pxHHME+T+D/aaLAuzZaDWJcxFi0PB/dYHhrxc6Ot
         d6NgCDb1T2tIdqi7wd9uZJvuqE/fSm2noB1e2rCpdWjLa0rEtUIGIpnKMovCVjWV5JRl
         u5/6ZyGajPJt0YUdERdceCzRnchU6Mwn6f2yneI2L9YSPb8aWojNAZ4N7sGLHr8SMJKb
         tFyTsmrCusIqh7H11Dd9m957YrPThqVQcwsfur8GiEl6BzmvJ2m9kovk/QJieCX/cxRA
         rbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tNF8cE4tubUhJi8auONGPM7bGbogIilKTUH38WvfphE=;
        b=epjXb/BKaKqSOFbHjve67KwI5matlIDchylXoahaCB+nWFo4BJNeYCmaTZHFO0H+C7
         QWziApXMBux1nQEzI1PSnUN8etqDoW60XQTHIadYjkUqgh90qAZmoClPPfIBDxLUufif
         5iuFKuPde9I9Sth57w0wSeZ6zC8+A6G9MRazzkoatLLq8TpTLUsxKpYHVlFkAsGR3cg3
         19HsIl5S05xjSIcBcKh50ZctgODPqJD+a2xNq4BMcdZQCzeNOroRjEVseYIOdlg9aC4b
         mZX2t9IcPhoEotUQYLKZ/WfEO3PHJ/hG73Bl1jWM+hBDjXMJoRwkXq0mReRfPwBzW3Vm
         +gUg==
X-Gm-Message-State: ACgBeo3OaddQjFw/xqszUCMdHryLtiH/j9qhmvruzG+KZuyzkz03B1zS
        Zz7lX53043YYdvxUwNF6OJg=
X-Google-Smtp-Source: AA6agR4jDh+MRTQ+7fpmfHtih3rfrdmyjQ2Awz3udo5N06j0vWOTOEOaZGIXaRSrjtCwIu+FOSdSDA==
X-Received: by 2002:aa7:cb13:0:b0:448:3759:8c57 with SMTP id s19-20020aa7cb13000000b0044837598c57mr15986310edt.8.1661959591066;
        Wed, 31 Aug 2022 08:26:31 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7ca45000000b0044629b54b00sm9250833edt.46.2022.08.31.08.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:26:30 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:26:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Message-ID: <20220831152628.um4ktfj4upcz7zwq@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830163448.8921-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 06:34:48PM +0200, Kurt Kanzenbach wrote:
> In case the source port cannot be decoded, print the warning only once. This
> still brings attention to the user and does not spam the logs at the same time.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Out of curiosity, how did this happen?
