Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CF86C0CF6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCTJTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjCTJSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:18:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF1E18A92
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:18:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id iw3so11740274plb.6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679303929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWd/vKOEIIM9qgmux+EdXSe/RPor39oWZQ05FdnrT1M=;
        b=iUPdNaT9u8qJCvU7ILPzvFhHH+iMNw/Pfop3l491bKx1xjKYpoQJeOIi2PtUDgKs+I
         LrZpw1TJkoa99bWdodAj1k30DNIM8cwvJ0h5WH37UlsUudAIE3yv6+tlKsxi0qT3LEy0
         KUggmLTXJW/qEDAKggiE5hsG7+Caw29oDOiSl6Sd/qBbmhJaK/9/HtI5WxuecH/BQTSw
         UaJzQSwnS0dv7SVjejIwn8GroaLFnjy++d6GdAdVhNxLlWyTAdO0RCC31cgasCRcFt61
         Nv2fLLRtKO1O3UhuBfk709aI+nU4Ag55kOArRw8v0MSZ2M1C8GHzjJ6Sd8HdmtSLjhOd
         c4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679303929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWd/vKOEIIM9qgmux+EdXSe/RPor39oWZQ05FdnrT1M=;
        b=LdNEh7za3+h1Qz0EFoCUbV54433Lm8CU/nDx17pLYUc1NUDnsKzkqsA8lE0LIBuzoY
         L+n3nGiDZrZQlndTL7cqc/gD4q4w1UXKuqcghOx3koppgY2RKJ0pevBswy8zfMWm1wWp
         mm30bB5kdU097V5OKlQ1OIrhYNUjlf+blU1cxGO4YfUqKQW8tcfqkkvqViey+eT1HXjw
         +meFV01JX9qwtWTbeLZ2BAZ5Mg1Cd+BEqbFpaNjLuUw0+uQEaRAcQk7+HEdhZgZ0SzdV
         BBe65baBBdPnvbXd52E1K4yickGXhhnFbM47I17IGIMoay6WQ16Zjms2Ux9atIzoMDM1
         KCXw==
X-Gm-Message-State: AO0yUKVIDDNjBOOHv+k7rSbKAasYmQDanuTLbhjTX6lYZWp+eIG90AhL
        Ab/u2Mt3CKSY8XU3iU3+9bc=
X-Google-Smtp-Source: AK7set/aISsDMVqlEcsk22fzdA5r7SFHol8p73Gm9JvIitRx/S+eX5ovGzrfQxt+nX/3Yner6feyhw==
X-Received: by 2002:a05:6a20:3d88:b0:cd:1808:87c7 with SMTP id s8-20020a056a203d8800b000cd180887c7mr19269420pzi.15.1679303929641;
        Mon, 20 Mar 2023 02:18:49 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79117000000b005a8173829d5sm3902727pfh.66.2023.03.20.02.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 02:18:48 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:18:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: Re: [PATCHv2 iproute2 2/2] tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG by using different enum
Message-ID: <ZBgk8F1EXTZYoqZX@Laptop-X1>
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
 <20230316035242.2321915-3-liuhangbin@gmail.com>
 <20230318192651.254ecb9f@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318192651.254ecb9f@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 07:26:51PM -0700, Stephen Hemminger wrote:
> Applied but all headers files get done separately by a script
> that uses sanitized kernel headers.

Got it, I will drop the header file changes in future.

Thanks
Hangbin
