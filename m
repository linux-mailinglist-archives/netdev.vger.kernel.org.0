Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4535B2337CA
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgG3Riz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgG3Riy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:38:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49512C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:38:54 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l1so29043546ioh.5
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uaQfZsf2JsrSMctqL8aKwl7LHQS3s9FYDI5Q1DNgwlk=;
        b=hE8AY1fje36SkohkSvJMMiyiwzzt667kkDC3+ygrRhb0s/MlthVdGPZ4oKZ0YpkmJu
         yoYbP9fhhQOxsovSL6yJuPbNcIbUxw28VH6nivZUzzH6DOn1CzhCC7/pBYqDHlLGi8Mj
         Df/e0QtYzndqPTV1vfAshicnxYkqzEUiEz+xp1w41YNM5dRTp1VexPS+7yZHpdMphov1
         cbX8TMmgK/Gq9lglua3KEKX5rXv3hZeAgcMfHCVtO1k6EfRDfNGBK8rpJs9J4YaA8ITb
         CqCUqm7sirOAefF6SuhYOu+2f98DPDhggbmG3/VFJ0usXuZnRJjVj+Uz1Mcxc1it27EI
         QD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uaQfZsf2JsrSMctqL8aKwl7LHQS3s9FYDI5Q1DNgwlk=;
        b=mth6BpIG/k7NLvHOsMDX1PF8t+tMXZghWHR7LbtDFuLHrBO9032ggWtYt6YHTTq3qj
         ic9vRhmr5WvCfu9MYwjuG5W11CuffTm3rdGLXcmD3kBS+PUKXjll5/M3HIGpJQC5yiSP
         4dTGWxpSaRelWPNEW99N//5DktU0Y5AxcBYgJZxP4I/jCbguNeFBqNozdKx7DIAIcMsa
         Xjnbykh1jm533QlKTv+Oeck9SMNkMqq5WOcrk+z/LU1EfgLNR8bJZQyFLdHVyM++/Sf/
         hE2fFu1paAyvonrSc0K9MADq/C+hfxzyRGUpKUMZqtH7dxmUdAsX1+qXJ9WweE8xheBt
         XlpQ==
X-Gm-Message-State: AOAM533Hu+UfdOZUqVOZP4WVOyG9JEvfjivzCft7FU12JiwtXzKGNae9
        n9GX8Da6Q0yhDcf4hGz6QFYcyzo5keHdAm8wRcT6RQ==
X-Google-Smtp-Source: ABdhPJwh2WZ/wjPlU9JHdP26pp53/Mu59axVq+V/w/1Z3rn+kTO3b52Cm7vw+zI3wLTifjho8YGmK1et0e1g9IBZ4rI=
X-Received: by 2002:a05:6638:2653:: with SMTP id n19mr374603jat.34.1596130733388;
 Thu, 30 Jul 2020 10:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200730171529.22582-1-fw@strlen.de> <20200730171529.22582-6-fw@strlen.de>
In-Reply-To: <20200730171529.22582-6-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jul 2020 10:38:42 -0700
Message-ID: <CANn89iKK1Fk7q8dM-s-Pt74D_s7J5UCwA-dTUMbimpEuXj2PSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/10] tcp: pass want_cookie down to req_init function
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        mathew.j.martineau@linux.intel.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:15 AM Florian Westphal <fw@strlen.de> wrote:
>
> In MPTCP case, we want to know if we should store a new token id or if we
> should try best-effort only (cookie case).
>
> This allows the MPTCP core to detect when it should elide the storage
> of the generated MPTCP token.
>

It seems you add later another patch, introducing cookie_tcp_reqsk_alloc()

We could rename req->cookie_ts  bit to req->syncookie  in order to not
change function signatures.
