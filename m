Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDE35785C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhDGXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDGXQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:16:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08B5C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:16:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso336635pje.0
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kmaSLK7yXae8Ac4uArBCjM2Q/PDIVGMpN3/bVpCiRw=;
        b=VR1Z5iSGT13RXyQunwH3Qn2B/I8Ss9BwLNVx2ktLr2LupQBswGQekbo+NP9kBVVK/o
         4YgEw49AWTOfbdZioJNlogg6huwXJ+JFNQSJSYTOLGwaBhD2saI4/iRSfawM3ooHWLjx
         iX2QX6crh2rYqU2n37t0Rr2Q689CGLesu/CL6cQt9kt1F89ZO+nJ4WbbZOWJrqGFCNfG
         ahiqRgsDr0sOnDRatUWfX9cz+9jrn1LqcT/ZA/JLPGFNESFPxRTT0C2z/oDM1CUwn+Yc
         qrc778ls23p9IeB99Jn+zMR6kSxdyXMXQoRJRB2jaa5EE4pn73hhMgxcuKnGSiITmsy2
         EwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kmaSLK7yXae8Ac4uArBCjM2Q/PDIVGMpN3/bVpCiRw=;
        b=M+AZfZxWM8rVjri9pcsFaJTwiSFJeit70O+9V/04KrJ+uZw25ekvVG8mz5qZUpEuHM
         OAYh1qcbpAvWxhid7Pu3XB2Ibv3U5Eeeltcy3hh96DzJZMJRAiOhB4o7dH2VoCra8YVU
         0RgaDahtxeaDXAzLrei84HUkhWViMsuZgzYx1OwVAej/HmXA7ur4qejfVf53iGrUdMpc
         dFE94XhDX7UeLGVlJFUACxs7SjAzrdiENV0cWQKQeT6XYTEGPf4QlRttfSWbutqjVsdk
         3V7igLZu/ir4jmicH4pNMcaeASDb31804ru0NI6qBYs5jbQWLGTv1KIilETJcu6//usI
         f/xg==
X-Gm-Message-State: AOAM530FvR881J81EwYGhul3iHvP7vHB6g+WwhavDUzU9bzDWidUY+ed
        HW53Sh6SpCZj5vzqA/gS6XBVbKTJwXwBSht+0E8=
X-Google-Smtp-Source: ABdhPJxYg5d7i28h9O5DqyVW+EL9T4HxiCIuf8CDELqa8/ObKiX9iQH2brrjyCCZBd7al/WYXnoGc2rGo3G1Hx2nbSU=
X-Received: by 2002:a17:902:c407:b029:e7:3568:9604 with SMTP id
 k7-20020a170902c407b02900e735689604mr4964814plk.31.1617837399604; Wed, 07 Apr
 2021 16:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210407154643.1690050-1-vladbu@nvidia.com>
In-Reply-To: <20210407154643.1690050-1-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 7 Apr 2021 16:16:28 -0700
Message-ID: <CAM_iQpXPBa+BZPXVaNJ98vEZwBiMLVZuqWupDXO6PyBCp5mNJA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Additional tests for action API
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 8:46 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Add two new tests for action create/change code.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
