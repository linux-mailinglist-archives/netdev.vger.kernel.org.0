Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96B62F3D5A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406850AbhALViB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437076AbhALU4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:56:52 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C6C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:56:37 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u17so7074855iow.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Krjh9lVeZWNYJN+bXJRoJwmZMVTWcGbRGwUcYeeaLwI=;
        b=Eo6kIHoP9JZ4gYq3uHFx0atwR11q4byjWciO78vyoZREdw4wSdOGCIGzIvRmOxZObU
         x+Fu7zX03wdIdtQfOi7yTGWbA9wcbYp7a6DeGVYyXqEsAG5mup0K/4GmuZiUfdCGqnmA
         0uG3Slk6TFKYt0cNetxkMD7R7Rwl2Iw3dJrco6DBeG9kLqjvI8Vj/hSul5XUBTDJNK5n
         eQIODP/+Nx8osuk0gHfjXi8B0t2Ij7QPgvrtS4VtYFwpBnQ4pKo06opd7zgpOZbT+od0
         1qJ6rwSwSKnvZbcfbbsrRoZVsnALo7W9E0wCTLmEdyh5F0YeUOPrBdMoZFjghuOoLnxH
         m9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Krjh9lVeZWNYJN+bXJRoJwmZMVTWcGbRGwUcYeeaLwI=;
        b=ac97oxjgjXQYtFapUXw1rud4LlqXrQN4oMczwpP3OM5/2rCA9iDJMNn329HcLUWTIZ
         8P3PvUclWx0ICwethXch1USvhLtV8wTZQp1/bA6OEXn/BR0qt+Na9A4EsmdxChIRb8hQ
         oabeLq/0MHkVkj5DC5BkCU01Gv6E4sTl2MeWJgQ1razGymEZ1F1ErkrrAp+o5BMYVwJ9
         B7yF37xoDzo3ioy797wOMR1/x8PeuVsx0nytAya4UE/cPeZNBTL/jVAOmgXoWE2hfMbd
         dvTIFj8WVa4tG02tSabLZYzTkuBkG4EtKZYVmC+Jp4X7/XTaUDaHDWyWupTPZ9MZVBG3
         VJIg==
X-Gm-Message-State: AOAM533MrYt5ozS//CBQSsdDlkAZcSNOUAomTd8dwEU5L5aph1bgYQCa
        MiB5//+AdTDuMZ6zWv9NqcAWB3tjQVT0VImCEAVMRA==
X-Google-Smtp-Source: ABdhPJyEx2pwHbYdDZsmyeJ6RQ7X0Sjf8JDN+Wz0LneREa6dXWUN0jMCK26TxNK5jjK0DFY3ofIzsbXDhevXSMdT/TI=
X-Received: by 2002:a92:9153:: with SMTP id t80mr963586ild.216.1610484996432;
 Tue, 12 Jan 2021 12:56:36 -0800 (PST)
MIME-Version: 1.0
References: <20210111222411.232916-1-hcaldwel@akamai.com> <20210111222411.232916-5-hcaldwel@akamai.com>
 <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
 <24573.51244.563087.333291@gargle.gargle.HOWL> <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
 <24573.63409.26608.321427@gargle.gargle.HOWL> <CANn89iJWkgkF+kKDFnqAO9oMMziZGPe_QYMJvx80AbbTfQFQmQ@mail.gmail.com>
 <24574.2537.621032.690850@gargle.gargle.HOWL>
In-Reply-To: <24574.2537.621032.690850@gargle.gargle.HOWL>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 21:56:25 +0100
Message-ID: <CANn89iJYh3F+1u8ZVGkhk6nQrN07ub0mkuc8sEzQx9Ta3kbsGQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
To:     Heath Caldwell <hcaldwel@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:43 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
>
> On 2021-01-12 21:26 (+0100), Eric Dumazet <edumazet@google.com> wrote:

> > This is fine. This has been done forever. Your change might break applications.
>
> In what way might applications be broken?
>
> It seems to be a very strange position to allow a configured maximum to
> be violated because of obscure precedent.
>

Welcome to the real world

Some applications use setsockopt(), followed by getsockopt() to make
sure their change has been recorded.

Some setups might break, you can be sure of this.

I doubt this issue is serious enough, the code has been there forever.

Please fix the documentation (if any)
