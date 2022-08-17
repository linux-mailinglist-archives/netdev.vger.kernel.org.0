Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6D596AB6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiHQH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiHQH54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:57:56 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608D97A771
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:57:55 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso8968305otb.6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Oz6JGs7zr60q+iUmh8gpuXk3oQqnqVuU/QutvNd1BAY=;
        b=hrb4btUpf9lfM+zpukK/JX0Yp6wLKVwobFc+A2xNUqw16qY7zTDJMxII7r4XNA/sQS
         OkB9Iqrybe9R0P7ovHFbckfYUINc9xFr3gm7WIM5KHRFVZqaaesatF3thpUNY/PKPlVq
         8FLawS4wQqxudnlY/IHYrIn/wlxNey0eg+HzizXUELeV2udeVCWTD4lRLw7jELgTx4Xg
         yWkZcp8ZqY0ZLdvU3RP0v4fuELOrpiq29yjr4fidV3DkOqgwL2oYhKTrkx8dI6wPNznM
         b+JuJ/dewlEcRnk0ZP2vcitxCvmD+VGuexjiLu/aaZKNzaMucNYZgVoxThClbm+mSxO9
         Sw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Oz6JGs7zr60q+iUmh8gpuXk3oQqnqVuU/QutvNd1BAY=;
        b=eau6eeGXVqC7B10nUP7HUyFFiEf7HZySUgtRv0IwAOg4y/asX8ocI2fgZXzCKekBpr
         AKpGezX7LMyvJ3TGopsPLHMY11pVxltRVTq0nWIqn+POZAVgTRGl3lhQQhqSrvBlSIGl
         MvHriDTbts6hxIRtTD+Ji1C3KoiDjZrsZEi4Qvj3C/oFAMEtvYEcEiYLGIBxHjG7ADqL
         UovIN3QquWO8UE87xiBFpzoh5M6aK3RPDU+u97+CbjjuJ+7O1SvXBLaXajpAycenDryh
         U+yx4COtVnJZFuRg2KFvZryRbVbwvE9dohX4b1o6cfI0lS60r30NjYMTl6H3WCykNIFe
         9xgA==
X-Gm-Message-State: ACgBeo2i4OaKGl20o+qc0xd4tP3kTW1xCVZJPNdXVl6oslPhYW0Zdfs3
        XkzF3O5RMgeOHoH1LuJLH+HidKqET6/Ixp9jTORSovKwbe6K4XrF
X-Google-Smtp-Source: AA6agR6ZgudGvFVzdEPpQjpapagktkgd1OCjvihC7eKs2FnIkrRAgXKNbSO1QJPrfWTq2OIAMELjqmtYjBdfJ9YQQXw=
X-Received: by 2002:a05:6830:6986:b0:61c:fd55:5b64 with SMTP id
 cy6-20020a056830698600b0061cfd555b64mr8847196otb.92.1660723074747; Wed, 17
 Aug 2022 00:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220816201445.1809483-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220816201445.1809483-1-vladimir.oltean@nxp.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 17 Aug 2022 10:57:43 +0300
Message-ID: <CABikg9waS7B4en3QXyY5F6g03iBgxVjRCnhgs4EF9mGjv2bpqw@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: don't warn in dsa_port_set_state_now() when
 driver doesn't support it
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 at 23:14, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> ds->ops->port_stp_state_set() is, like most DSA methods, optional, and
> if absent, the port is supposed to remain in the forwarding state (as
> standalone). Such is the case with the mv88e6060 driver, which does not
> offload the bridge layer. DSA warns that the STP state can't be changed
> to FORWARDING as part of dsa_port_enable_rt(), when in fact it should not.
>
> The error message is also not up to modern standards, so take the
> opportunity to make it more descriptive.
>
> Fixes: fd3645413197 ("net: dsa: change scope of STP state setter")
> Reported-by: Sergei Antonov <saproj@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Sergei Antonov <saproj@gmail.com>
