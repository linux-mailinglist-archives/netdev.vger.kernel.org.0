Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08C96EF6B9
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241049AbjDZOqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbjDZOqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:46:54 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA71C1985
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:46:53 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-505934ccc35so12492175a12.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682520412; x=1685112412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wP4YkW4+Q28Wowc/HJqep62dglAu2r1j2Rt7AAAkV7U=;
        b=e1qyP6ka4AIXfr8a7DbqgmzLqqc/aChAfXPxz9oiXGi/nuenBYSYopmhuLch+Gkmzn
         r2+GIbeyuSipdkdLLBpABERxSj0EbWKygsSwwEjyop7hRWwWVRaa6BxxAlIQtkyPZH3N
         Gn/uX3HXkGWRDzVNjmNmVJUPrvD1576WHYIs7kWK1bIqduyBeZAiuEHsa8lcdcz3LM15
         NEN0+08MPu5X3VK1AAterRm/83Jtug8ixz/vk+mE+Yo3cIFHo8w3+O0tew4Z3gT1oNSP
         7tMN8BtzriXZ96qMnwYeQyaQHoI74PaHl+kRtJa8bI5rgVSgCH0Hj4kHdPeorecJnN7C
         /tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682520412; x=1685112412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wP4YkW4+Q28Wowc/HJqep62dglAu2r1j2Rt7AAAkV7U=;
        b=aA5Il5P/lK5jtDzCDaMJqr3cxF0QZDrArsF8R0n9hWPSXHOe2R6GxXETspVkO6CUqq
         1s4MZAsHydxC4Cinj84KhrghI2J46HGdjugyDGtF5jLNGMFHTfznienwzx6dSf7IT62S
         gE0H4hJYtTmsFtHFDNQ2VaC6k/66r6gLJ/zWEZ6T8rpwmIxsCtG6BwdN/rDcC9rviFy8
         FZ89hzvHWlr+nTy1eqnuO05oaiaPTCEBR/tpS78Wqjc3NOXWwL9Ki5loYy0g+0Q7GVxe
         D0wre69teEM3Vao3e3kOxgCE09yElZs7ZPWiWd0irAxoLfaHCq2t0l2XyIXb1KmgQXk1
         b/Yw==
X-Gm-Message-State: AAQBX9efCpVRML2trkGoGcxe0ttC/vGYsXN0oPewvPjF/MA9+h07LkUu
        +5CdviDkchTgJPSa6SFXTv6yIU0sbr+NqA4a
X-Google-Smtp-Source: AKy350av+30v5Iet+l+t/DQfdQBOBDkpKrzEJL9m1cZYUNKdl3x4ik7+tbO2HKd/A5LYvGGPnyBEpQ==
X-Received: by 2002:a17:906:970c:b0:94a:474a:4dd5 with SMTP id k12-20020a170906970c00b0094a474a4dd5mr18626747ejx.9.1682520412084;
        Wed, 26 Apr 2023 07:46:52 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w27-20020a17090633db00b0094ed0370f8fsm8431158eja.147.2023.04.26.07.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:46:51 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:46:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: dsa: mv88e6xxx: mv88e6321 rsvd2cpu
Message-ID: <20230426144650.vrg7d37scu2yemrs@skbuf>
References: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
 <5056756b-5371-4e7c-9016-8234352f9033@lunn.ch>
 <141aebfc-46a3-7ac3-c984-dcd549124c05@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <141aebfc-46a3-7ac3-c984-dcd549124c05@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:59:39PM +0200, Angelo Dureghello wrote:
> will test that too, and will send patch v2.

did you send v1?
