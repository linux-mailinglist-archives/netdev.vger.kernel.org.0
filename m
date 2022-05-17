Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C3052AE42
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiEQWoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiEQWoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:44:24 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC3D45AFF
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 15:44:23 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j21so304658pga.13
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 15:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8U1UMJO6lMuPvxVoVzvgi2MLyng4q5uGVH6c9a5w1Bw=;
        b=gOnMTaEdFttEm6/q8XtGmPklahi2Ik82IJeay691COcljHc/LzBEOEZ+QVt5k3HkLF
         UnL/oGGGW2/VFzZgtbsSAur2VSqGY+QcnetKELX4zENMxP2HF4AD0pYpvRUUnfx5QxJJ
         /NYylHnGAula72P6fk/YTbEvjagUiN1WY+5HPfUadvcw/S7lMRuvf3B/RrMmhU6ZgDHg
         0rBZ2xIkZ3i89x5tTMwUXfLT9vrslj1/p4kUQ4Lkfb9kV57oIL17dphdh2ka/Dw05b6q
         qUrM6QxLItmWu8bqC4Z9casbE/DLbJUeElEtqSO36fYxetMDZr4cbiCjhETywSexSnUx
         v8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8U1UMJO6lMuPvxVoVzvgi2MLyng4q5uGVH6c9a5w1Bw=;
        b=YeG9vG3lEtZQQyQ2qdA3sViY0HXpMiMtz1L5eYg0UDAZm1jUDYaTHCt7Tk2DNnh7ze
         UWo3akWUf+oer/SFrVHd09RnPxS0fmFzOXO6CBJP5y3dZBCi4mbH9G+i0ySyLv1ILiez
         3A9QQA/7GpsFodzlYCTDMHvBZ07sJf4evt1DLqSzf7oUMnJjIR0poTg9HFACdj0b6mya
         z7TOvzvyjbgd2TbuRiWgGRt+DQUegpVR303W8xh0rWgQoX1cFRQhdOTuCNbeJSco3mg5
         fjgvOMqas/ybp7pJjJl9usxRgJQ3ZdYGE8ll0zBgTnz3nAjkKkgI7Y0RNXZ/vb9S9pmC
         j/Xg==
X-Gm-Message-State: AOAM5306oi8n+34r1jq3lRVe1h0Dj7I4TiKeRHgOjHiebJcUB7PvNNtu
        1QZrvnnGXgG72h+BNA4SuwlK3w==
X-Google-Smtp-Source: ABdhPJzLuFFNqxfqGKiJ0TkzxI3fsKb53qCzXi0B6fJhZIeZBQremcpXYRvvdsFyH6ad2jVYDhxf+A==
X-Received: by 2002:a63:1645:0:b0:3c2:4706:f62b with SMTP id 5-20020a631645000000b003c24706f62bmr21634955pgw.11.1652827462116;
        Tue, 17 May 2022 15:44:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b0050dc7628168sm257134pfu.66.2022.05.17.15.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 15:44:21 -0700 (PDT)
Date:   Tue, 17 May 2022 15:44:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] bonding: netlink error message support for
 options
Message-ID: <20220517154419.44a1cb6a@hermes.local>
In-Reply-To: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
References: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 16:31:19 -0400
Jonathan Toppins <jtoppins@redhat.com> wrote:

>     This is an RFC because the current NL_SET_ERR_MSG() macros do not support
>     printf like semantics so I rolled my own buffer setting in __bond_opt_set().
>     The issue is I could not quite figure out the life-cycle of the buffer, if
>     rtnl lock is held until after the text buffer is copied into the packet
>     then we are ok, otherwise, some other type of buffer management scheme will
>     be needed as this could result in corrupted error messages when modifying
>     multiple bonds.

Might be better for others in long term if NL_SET_ERR_MSG() had printf like
semantics. Surely this isn't going to be first or last case.

Then internally, it could print right to the netlink message.
