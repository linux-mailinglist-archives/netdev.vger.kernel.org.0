Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8860162953B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiKOKEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKOKEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:04:44 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B7AE0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:04:43 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id l127so14380139oia.8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=14wh9fO6TVg0vKgRl3BQkvbrhVtpIEacYDli7ORPhns=;
        b=d8xLyYxgnwcefVvzS+W378EORzn7gyNujcQPtGVcxsG/eU5SQrJYtaU54OxuDWauu5
         KLuwsm3HJU3ZISHhTN3cCEdmhqi5QaM0h+RkjIo32sjTL+xTPIObQoV+xc01CJfm9whe
         7UdtIzl2PvTnod01MRpcNp8POArbK/drolfpFWEje4jQhwm51tUSRTgEV2CVIEWlB3l/
         yt6RLI8kFyx/bd+RLNE+h6hZ+xKq0MOgNJ+E4yXgBhRPWZQk8llngXR6Df/7kcy/c7dj
         vmlHnOQPr4g0ftvoItA/vHdjfTO2b/mP4QZGYxu4C3LHRc8Umdkw/osf6Trij42UG191
         VYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14wh9fO6TVg0vKgRl3BQkvbrhVtpIEacYDli7ORPhns=;
        b=3Eigq1eyhz7/vgWsuoBcfWk8P+9uxleGpO+CqGsItVAU8zROFb2NdaCelIXRF2WOCr
         J/N5hARigS5PUO8wKFGfKONhDGnTt1nUgHf3plZPxgLA+7nYkDcN85DsxLMjlJXrxsWp
         Bz6tS4cSff4T8IVn5vDi+IISsAx1hJ4lux1pNA0it22K69SaVaGl2WQsBnT/LkOUjf/H
         paOi+dRFqfvn56U8PjhVRS8XYJOXKKE2IzM4yjzLkOLpjEpFonJwaPr264UiwlbXDscj
         DIpfrA6H6EA1xK4xtXH9D/v/Is8uSsDb84SwJLJSYKhXeB5mvGAAhxfu+L8rUjRh9uVq
         WwmQ==
X-Gm-Message-State: ANoB5plLcnOVkpheSU1zL7/x+8SJivB6lRubRISKy8VQXCjRn3kE1mXT
        jSBRIvjdbeNju9Scg/Kj5OjQeAxoTIcozgT4lIE8EmJ7JPjCCQ==
X-Google-Smtp-Source: AA0mqf6RDfoKeNbgPVjzgInaFil71dYssU0qMBhdKwGqLUlk8MG4a77KHsbv+4vsgaW/erLCbD5waXHSS8QFHBAOuVc=
X-Received: by 2002:aca:6156:0:b0:359:cb71:328b with SMTP id
 v83-20020aca6156000000b00359cb71328bmr487185oib.282.1668506682712; Tue, 15
 Nov 2022 02:04:42 -0800 (PST)
MIME-Version: 1.0
References: <20221104170422.979558-1-dvyukov@google.com> <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p7>
 <20221114102729epcms2p75b469f77cdd41abab4148ffd438e8bd6@epcms2p7> <20221114163604.1b310e51@kernel.org>
In-Reply-To: <20221114163604.1b310e51@kernel.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 15 Nov 2022 11:04:31 +0100
Message-ID: <CACT4Y+bBvvZgkAYoaUwaxx+XqW-+vgYUAshtSFBX13BHAMVLTw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 at 01:36, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Nov 2022 19:27:29 +0900 Bongsu Jeon wrote:
> > Reviewed-by: Bongsu Jeon
>
> Dmitry if the patch is good after all - would you mind reposting with
> the review tag added (and corrected)? Thanks!

Done:
https://lore.kernel.org/all/20221115100017.787929-1-dvyukov@google.com/

Also sent a patch that adds "send after close" case:
https://lore.kernel.org/all/20221115095941.787250-1-dvyukov@google.com/

(these patches can be merged independently)
