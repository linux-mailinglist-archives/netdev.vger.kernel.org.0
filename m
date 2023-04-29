Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA7F6F25EB
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjD2S5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 14:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjD2S5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 14:57:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728FB1FCA
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 11:57:02 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so5445945e9.3
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 11:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682794621; x=1685386621;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wy+kTeC5tSO3tm1FDeHr9ykYNPdkDWOpPGsx6vF3QqI=;
        b=fnn+H52MahkVlF6UgaH/2k8H2aG73H6/OQX0k+FrMCIuXh/lGuV/jbNVpEQDwk2tdR
         lZLt/hpHJcOJt7+Zn6scLmzCCwQ2QUbrHDJPMMqrTmQdSXoFwGqyCRSM0qsSZbwEbx1H
         Kei1Ex3npfMwNZbELruPY2Z76sf+FO4ymlNyjl53RiQq/8faX9WI6vbAGwUVRd7jhu1L
         R6Nrxjj+ouFTlmLjip7ut268YlH4rXM2/8I6VHSSWQ9Lgi4W7peau9h7p/eh+yJKLJww
         uaUS3dZV/tVTLPTVQajIqvDUc/j0/5XPry16HemkvXKH+8Y5tMr4aw5eLfxGZuZ7XfU6
         cJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682794621; x=1685386621;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wy+kTeC5tSO3tm1FDeHr9ykYNPdkDWOpPGsx6vF3QqI=;
        b=iSgEq0ncjzfOLMyR26241R8dcbPxL3EdMLhKqwZJET46W051x41gNcE9StTK0AQwl5
         RNoC8UmNF7OCpz9aicW8NyprrLJ/A27i6mVpjccTMRHdnghNzfsb/tbPzfH6yV9hqmCA
         iEsGFfbLyX/I4i/ThhxWhV/NpfmlZajhYnFv9wPn+zYrrqq4rsvLYayLu4WEzcuCSAiS
         VC0yx3aHfr20BXCEIMBXJ2hTO0ZMnWSQs9Km2XJaigoPi/b1ICAqrZSy3845x/3SrWhn
         eERVsmLBTXkxXgZYSrJ7EvnN7v0uzs1wU2hV+LM9BzRwJE+5YBAuRv2QK97moXdjaw18
         SpIw==
X-Gm-Message-State: AC+VfDzlJU60SsATcdV2lfpEtZrKWUlaYQ5R/XhdixDfJZ0uVZR/Ah4S
        RqjGu3O5KQIfjb3V173WEyk=
X-Google-Smtp-Source: ACHHUZ5s9f7itBzOkUpeNeOR8mNeZGoGQeSPxJ1oTDYyjGqDOjCKd60/5RipaknSjaXFsZNC8qlauA==
X-Received: by 2002:a1c:7718:0:b0:3f1:8430:523 with SMTP id t24-20020a1c7718000000b003f184300523mr6988255wmi.14.1682794620553;
        Sat, 29 Apr 2023 11:57:00 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j5-20020a5d6045000000b0030626f69ee7sm1222332wrt.38.2023.04.29.11.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 11:57:00 -0700 (PDT)
Date:   Sat, 29 Apr 2023 21:56:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230429185657.jrpcxoqwr5tcyt54@skbuf>
References: <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
> Are you fine with the preferred port patch now that I mentioned port 6
> would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
> got 1G? Would you like to submit it or leave it to me to send the diff
> above and this?

No, please tell me: what real life difference would it make to a user
who doesn't care to analyze which CPU port is used?
