Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB054CEC46
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 17:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiCFQuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 11:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiCFQug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 11:50:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8055D1707C
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 08:49:44 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o26so11654611pgb.8
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 08:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UifAvvgVuErFQwkVAvsUbkcz0u3uiG8py7zC40/Btc4=;
        b=ZDhKC0Hla9+UGTjHRdwrbgdaP2TWrRh27yqJDl773H+4z3ORzTT03MqbFehaMZhCrx
         eQFQYN07MMDuPBKVm+E6NRSmvyZ+jEV6iEbMzIvPsnKpBh6yl4Wg5GUiNGgpcg+9hZs2
         JgiT6YvvlhktU/OkzPIqs4qzPFtD9KR4Wd8SSNu+n5DCrs6Ry55226yT5K1weZAvPi3f
         O1Ak4bukSLDUMnW146r4GQ5ZZrFB/dVDzg7Ok4ELoZmz9nbPEWhxDgphwJRQoM9n+aMn
         gTqkM+vo8F3ZH3Lao+vvBE89qSlWqGgkW1OrhWhtSDDvoi+x0aOiJ0oIfDtiMHPEdNX4
         fMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UifAvvgVuErFQwkVAvsUbkcz0u3uiG8py7zC40/Btc4=;
        b=dghA8uqS8IFR8EKJDmVidrVJtLD3DWW+bGLBPDlJPXPZ4wbb/X4/2phl1WUWyCZcM1
         ExsnB1mdtq2J9p/fCMSKFQgxw8h6zl0TvNi9DyGd+4N0bw8HtJDxlMdADamt2rb8PGLH
         23m8hrkkNzVgijkY49WWhUYQ9O0NEJ1NDsy4GVDolEhEEZifvLqhtqAnESIEdRRo5tT9
         Lepcd2SyzLv3k7RpzFpsnUuqyHMY3wY/7DghmlT+R3t6ITkqOqgVl4ASR45mKWeuYa8+
         165Mpi5QNfiilcAjVk/FmCxF3KBiOpNNOIdCgJvM9D9cQlReoJq5Jzt8Nxf2/s/SICnV
         zTTw==
X-Gm-Message-State: AOAM531aBtePn5vSwTTwdRnRuR9U2GyLxhI5aQuXGRH6IHB4RSLCDzNJ
        +Od0PlbQM5TEsnU1RC9L37E=
X-Google-Smtp-Source: ABdhPJx8sYEHtiQBDbsXgm96EeqGbtNI3SqgfzIVQtu0HGjeRbm8PLeP14SAvs2UyTJLHBqrfNBM6g==
X-Received: by 2002:a63:e958:0:b0:380:132:5da8 with SMTP id q24-20020a63e958000000b0038001325da8mr5350322pgj.114.1646585383910;
        Sun, 06 Mar 2022 08:49:43 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z35-20020a631923000000b00373520fddd5sm9680242pgl.83.2022.03.06.08.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 08:49:43 -0800 (PST)
Date:   Sun, 6 Mar 2022 08:49:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220306164941.GC6290@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
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

On Sun, Mar 06, 2022 at 09:56:52AM +0100, Gerhard Engleder wrote:

> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized while
> vclocks are in use.

So... the HW must provide frame time stamps using the one clock and
ancillary operations using the other, right?

Thanks,
Richard
