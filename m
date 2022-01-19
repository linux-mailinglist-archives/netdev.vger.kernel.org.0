Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F9C4931B5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347584AbiASAPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350405AbiASAPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:15:44 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE48C06173F
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:15:44 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c6so2063292ybk.3
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TMWqlx2cCYdrrE3kZzF77Bk7FJkowp62u6UrDTFX/ac=;
        b=fCQ5nj7Z2UW8bLulnQuVPd9BjRR6xWiCP/WMljnpAiPEzXVuQmU43vwJibEYfHbuhQ
         MXkSLsQ++9h7C+O3aewGIBxepM36EofxVS2O7EYQmcKnwqCLQtOK3GYdbSb5HrMZl+iG
         l/czkVlRx/oYuc1rQx+I2tSMqezBo7ITAdCys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TMWqlx2cCYdrrE3kZzF77Bk7FJkowp62u6UrDTFX/ac=;
        b=p0V5Xx4+jucM2aeZhRrtREEWOGdJZDUAlUK+jUXoF4b8nXIiR1F7P5tP6c+3CrYndw
         iy90vyb1lL1gxTKs/tyeyjsqBzyW56srbXVBkpeHebyqcKfEr4PDnBWoXpkrSVT237GV
         72djIpTOpQSe3iNFlbnEb9zHGd8ImL+1lk3ZIwQQ3UOWJ9lCzuOAiuR3Dyvx55Jt7uD4
         uFsPV1YSncqt8+KRVcsOpcsL6LBUmIdHiWMcJiQFssAQgflFd2zsVGhk1ttMPq4g6pv2
         IU+C8WIeY0htJIbSwzm/K3CP+IHQx29rFPw0P5ox0nDYlZNfQ15mNYJ0e52cz/Z2Hl4x
         h5EA==
X-Gm-Message-State: AOAM530terF6SZoYAU7mQuLGffdA8kQ8cYmgczkFlDerGQz5iLy0iJ2e
        FUDNoniAEPRwWEkbXPBMvIzaZ2POL/PCMgDhd39jZA==
X-Google-Smtp-Source: ABdhPJyqmrtvVXWeZmIXNXaB41OIGzaCd5bf39BNoH4TlnCzWeNJZ60mFXpIwh72nl5eMSruN9Ah5YH/H3TvNg5Pqlw=
X-Received: by 2002:a25:be13:: with SMTP id h19mr38003995ybk.217.1642551343630;
 Tue, 18 Jan 2022 16:15:43 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1a7MKxM8XX9_1zRkp_h8AHGWT_GQTwAbJdz0iKEfrsEA@mail.gmail.com>
 <3776.1642550885@famine>
In-Reply-To: <3776.1642550885@famine>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 18 Jan 2022 16:15:33 -0800
Message-ID: <CABWYdi3rg+=GCNqPZ2ss=WRQtZ-onQFOqqTwkLxC-HGesZTiLA@mail.gmail.com>
Subject: Re: Empty return from bond_eth_hash in 5.15
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 4:08 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >On Linux 5.10 I get fewer lines, mostly zeros for hash and one actual hash:
>
>         Presumably you mean 5.15 here.

Yes, sorry about the confusion.

>         This sounds similar to the issue resolved by:
>
> commit 429e3d123d9a50cc9882402e40e0ac912d88cfcf (HEAD -> master, origin/master, origin/HEAD)
> Author: Moshe Tal <moshet@nvidia.com>
> Date:   Sun Jan 16 19:39:29 2022 +0200
>
>     bonding: Fix extraction of ports from the packet headers
>
>     Wrong hash sends single stream to multiple output interfaces.
>
>         which was just committed to net a few days ago; are you in a
> position that you'd be able to test this change?

Absolutely, I'll give it a try and report back.
