Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC53F6DA8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 05:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhHYDWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 23:22:08 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:40464
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237766AbhHYDWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 23:22:07 -0400
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 64E393F322
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629861674;
        bh=bubKe1V2wVnyhV9MMzcO3LsuU+2HkzzeQ/usUihXRL4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=pNK5/VUbe8Zo5NVmRDNXnLvbxS6+TDoeocuhytiPuOPSTnH+EtAC+l4dMQ+6uBahA
         d6mgRGg6g0KzUhJsmyXt/+mi07hDCvElqnSYRgcuDDe/0F18G4jUKYeQxzHACrS0nm
         ItwPsP+cyOXbAJhd5bn22PB4mYrVwmO9gdW8wr3zpBmiWsNI0dX/oieLFDCeQonKoZ
         HZ17s66ylUNCu4JUbjdlRMQA+Mong1/e69m4IRUFhEpEsk0+dOm6KiEEA4AP8xPwgK
         2e2TBROrye5c+F8TyYROZ7sIB8PtXrpzdxT+o061zpps6MIpHU0vIziYp3Pny9VHBh
         dGuoRmTCHy7Bw==
Received: by mail-pj1-f69.google.com with SMTP id c2-20020a17090a558200b001873dcb7f09so3416621pji.7
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 20:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bubKe1V2wVnyhV9MMzcO3LsuU+2HkzzeQ/usUihXRL4=;
        b=R/axo3+KAal4vluhZI/hROp+ocdRNW2ENGzEcwraTyQaobDd1s613jVtL/PUauc+Mv
         HfYFris/LEIw9j6hFdlLcTlS06jw//NK4gsJQWzkYZdbQMgQGKKv3DF9/WGW2PeYxwlw
         6BcscJnkjftJByyL/tj4EZ0gppzYUzTdgymEab9U7Jz1UMdvRuLJvS6uAAKpIQOD6r4R
         WDHQAfCGhvnO2o+7UIDEycoNpUz5IfwHIb4K17qiawnUyFfP7dmAJcLzqxvuAaY7Y4eI
         t1bdaM1kIsyM/Unzs2exB0u0lh1hth0m1C3utDp4ogMdCRMmj9DYy2WGuha/6CL1j9rn
         R3jg==
X-Gm-Message-State: AOAM531jj69/o9OYe8+OLF81+47TGg+PRKI36wMbzodLB5lbEbgeoJkX
        BYpOqT8wpmxwrw6IqJoxOW5rGWsyteDwnYzgk7Zg1GutiFgEv0B3kdFi8Tq5BvOebd8UJUibLWT
        G/LjJ9hBNa3214nan5QIQpUXs1XK4GJ/SBrfNSCcpT3ADODur
X-Received: by 2002:a65:494e:: with SMTP id q14mr40030658pgs.314.1629861672698;
        Tue, 24 Aug 2021 20:21:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhWn0jS2YhuUhIxgZx+PjfbGWTVTBIIjMe7EFktPXwyVRjO7xHttqYBJgkFKlGl1VfvTS2JVhsyO4eOepp7Jw=
X-Received: by 2002:a65:494e:: with SMTP id q14mr40030623pgs.314.1629861672376;
 Tue, 24 Aug 2021 20:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210823085854.40216-1-po-hsu.lin@canonical.com> <YSSemxg1JQRdqxsP@shredder>
In-Reply-To: <YSSemxg1JQRdqxsP@shredder>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 25 Aug 2021 11:21:13 +0800
Message-ID: <CAMy_GT9xMGsX2dqDRhq=2LPf4OZLc3j1YLCYKOVZACKhPyTu8Q@mail.gmail.com>
Subject: Re: [PATCH] selftests/net: Use kselftest skip code for skipped tests
To:     Ido Schimmel <idosch@idosch.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, petrm@nvidia.co,
        oleksandr.mazur@plvision.eu, idosch@nvidia.com, jiri@nvidia.com,
        nikolay@nvidia.com, gnault@redhat.com, simon.horman@netronome.com,
        baowen.zheng@corigine.com, danieller@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 3:24 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Aug 23, 2021 at 04:58:54PM +0800, Po-Hsu Lin wrote:
> > There are several test cases in the net directory are still using
> > exit 0 or exit 1 when they need to be skipped. Use kselftest
> > framework skip code instead so it can help us to distinguish the
> > return status.
> >
> > Criterion to filter out what should be fixed in net directory:
> >   grep -r "exit [01]" -B1 | grep -i skip
> >
> > This change might cause some false-positives if people are running
> > these test scripts directly and only checking their return codes,
> > which will change from 0 to 4. However I think the impact should be
> > small as most of our scripts here are already using this skip code.
> > And there will be no such issue if running them with the kselftest
> > framework.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

Thank you for the test and the review!
PHLin
