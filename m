Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F983E271E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbhHFJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244076AbhHFJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:20:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C67C061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 02:19:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so7428940pjy.0
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 02:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygoR1r2IFRYwDwdfhf1sP9OP+NDnxs619rIUX49u2gQ=;
        b=dR9/17hohzESs+XXHIXIUHUSbpB1dvL5YxWxEVcBo/Mo/QNHMmXZKj2ngnD+5456fo
         yiU+tPJba+GEHK0mIbiCvUTI8HZQlA1I/aNIdW26rp9ijU+BjyCpjEA1hTGkzl4wYnkM
         XNSK39RR84QRQynh0i+OGIhb3PhVtvpY34RbP6f4/M5zWYuoOd9N6OClsnMrhEqO6pdk
         i6pxK4dvKVkahaB3R79D4mSRb9X95nT4ShW3Sy86BWy1BEwpvdLKujfJWUWcNWrS1SG+
         lINJdaomQWETHSsP7TyaL9tzOg0gxn8VAZK1GAum/wG/vfHh/0X37T8mNH8WftC58Xwb
         g3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygoR1r2IFRYwDwdfhf1sP9OP+NDnxs619rIUX49u2gQ=;
        b=JK2R6HmqSAEzmMr/mQAvCZ/ETbtTcMuSwuL9/5lURqq0So8gT4/MEjSPWAi4K8VF7q
         yLKnwSRn2ty12cMsn9ays8XcCXBC+p6m/i3ZY0tzyXKiBqUCfORdqZiDSXQO1RFCrpaz
         ob9e4sac7U5P768mfxHDkN2wNSXbaxnlDD5+wVQtU29aoj7Kky7wNzRd4eegzHAS+F5K
         wBxAJq4YFxhfkCpLKvi64fFQsSRjQFtuJImaAZwVMlYshFHLvxD4s36jdODu1Kpet5ky
         tCRAu7+7Zi4gRX7OZNhiVZzcdYrhPXEcmevmUpTIpDkNSc93ZVPGlcFsdUPB334fy6gV
         uojg==
X-Gm-Message-State: AOAM531h3XT6AIYEVCbqcikyXkdAvJRS26sowGem8i/octDlfqZ5ZUqo
        Qo6I4DpYTRQ5exDeJNzjZOq/pv3MglpvehfSe0hnUw==
X-Google-Smtp-Source: ABdhPJxr8NrRjjuY9UnDxc8gz+M6TK1vUWssuA+uR8qnEHC2x8bVaPnR6YaXqfIOrKrt8N3O3BqKVAoMDbmvA9pWohw=
X-Received: by 2002:a05:6a00:1245:b029:30f:2098:fcf4 with SMTP id
 u5-20020a056a001245b029030f2098fcf4mr9681880pfi.66.1628241598355; Fri, 06 Aug
 2021 02:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 6 Aug 2021 11:29:38 +0200
Message-ID: <CAMZdPi_-mxR6u0+nyn3fYGuQraHstg_0ZNjyQY=w0zXUjdOJjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] wwan: core: Avoid returning NULL from wwan_create_dev()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 at 11:00, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> Make wwan_create_dev() to return either valid or error pointer,
> In some cases it may return NULL. Prevent this by converting
> it to the respective error pointer.
>
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
