Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854222DFF5A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgLUSJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgLUSJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:09:05 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3601EC0613D3;
        Mon, 21 Dec 2020 10:08:25 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id b24so9628917otj.0;
        Mon, 21 Dec 2020 10:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHgLaGHkyXcabO8xIkwlWJDr0MLBnIf8/qlkiv3QkXo=;
        b=F1s3IZItQhZW8oKY8yQAFhMb+5YpQSaWkdzriG2F1JWsUb8om7K0UcjMwvEToL3a8X
         vPB/icFWCy3T7WJ2+UaDJlBHkeU8xx3cwO/ZQdZ+XhfiGCcRjnlwavdFlACH+szE6Xdr
         2J/YXkVXHD1ghNJm7VBM0OZf+4J6O4Scu5uPRxvV4hzEiD8fKqP7E1hidDSO8MMpn5jX
         GhZhDq0dYQcIjJOjXs1eSktSFHugLxz9zJM3KlIupNe2UY1m6L5AErmaW1KaWIaVv+dP
         oFfmbitNFCQ1KQH0muFAqoRKjTt35L5jRMwlLBMv3emwPuhHmwmHgUgGx7sB5IvW3uz1
         xHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHgLaGHkyXcabO8xIkwlWJDr0MLBnIf8/qlkiv3QkXo=;
        b=Bu3MOtwdYJz4E0locNmI5M2A8RaDNR7Op6pCiLoFe2umTReBX9lXtLy6xeRoR6PdrV
         i979fmNQ4edfQOBn28zmwMsNcQazBv/bVoYCp7ZGOaanBU5Aou+7RZshXUPT0wx9VOov
         ecxbV2wTvcJBRi+I5KI02/7eGMLL6y6gMYtySRF1810Bjc7ph0vsp9OrUBUMMJIwEQ3C
         EY6IAkinKqS7Ytk8mUqQ/ClTf+x43LwWuZFVoZq9YC1xfVNG4E07cvgzoledBHVtbeiF
         BZZwuXC6xIJB4BVVYS4NtEk23b+V2d6O0Tau7yfPkP49dCqvSPwMtr14ihPAreFZ+mFk
         DAJg==
X-Gm-Message-State: AOAM53211WRgRAblV/9e+SZOkUpzLIOsrCYZQ9YZJvONpp9QMuR2D3ND
        AFCbfnv0akNSfN/mKLdhCxlgj84blBfaBIft/d8qPFjN
X-Google-Smtp-Source: ABdhPJyHPXD2WoRee0gLQTCh8E0/Ceo8vhSHe7ZKLTkLXezBU+vPi6psE0EHYE1zYhtBw5l7l2aL3OvVEYweBA+zdHM=
X-Received: by 2002:a25:40d:: with SMTP id 13mr23258507ybe.422.1608558675780;
 Mon, 21 Dec 2020 05:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net> <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
 <X9YwXZvjSWANm4wR@kroah.com> <CANiq72=UzRTkh6bcNSjE-kSgBJYX12+zQUYphZ1GcY-7kNxaLA@mail.gmail.com>
 <CAK7LNARXa1CQSFJjcqN7Y_8dZ1CSGqjoeox3oGAS_3=4QrHs9g@mail.gmail.com>
In-Reply-To: <CAK7LNARXa1CQSFJjcqN7Y_8dZ1CSGqjoeox3oGAS_3=4QrHs9g@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 21 Dec 2020 14:51:05 +0100
Message-ID: <CANiq72m5_mc=Cq1gkMtO6UTo+x91aE7+UBDYJQLazmTh4RbntA@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:20 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Sorry for the delay.

No problem!

> Now I sent out the fix for lantiq_etop.c
>
> https://lore.kernel.org/patchwork/patch/1355595/

I saw it, thanks for the Cc!

> The reason of the complication was
> I was trying to merge the following patch in the same development cycle:
> https://patchwork.kernel.org/project/linux-kbuild/patch/20201117104736.24997-1-olaf@aepfle.de/

Ah, then that explains why Guenter's had an error instead of a warning.

> Tomorrow's linux-next should be OK
> and, you can send my patch in this merge window.

Thanks!

Cheers,
Miguel
