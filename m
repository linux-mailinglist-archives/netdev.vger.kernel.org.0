Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C89F460AF3
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbhK1XDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359464AbhK1XBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 18:01:02 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9368CC061758
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 14:57:18 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id o1so30166249uap.4
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 14:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nVVh9m1fFQO/bUl5tsnq8P/yGfz4AKv82pqevKrnx6Q=;
        b=d5Dw8nnTi0HPoVDKixY6SAn7/AwPdahi2VkAogPPC8mWBIUSoENSEFPTN9spT07QO4
         N9KDqrzifJUj6hkDiJxQKZOuyRpGIkElf6oxpQqAGFfamVIxGyl2HoYZI7yWJsW948sr
         gnkFVAYhvnMHbVsic8Jchj8uv1pW/GMlwoaoR4XoQX1cCqOrju8acxxzp6LUNYP9r3DR
         ZFlv3aqP4yuU9m86f50aHKXf+etigT9DtytZiZMY/WgS4+ryBTfnSwu9eRRw68/oAMpX
         7bTcehHfxvGBN3E8bJIGi5BG0d7M7ZZn5EwmY4uIE6JyUpMz4RgLNbjqA6KTzguuDOI2
         1iRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nVVh9m1fFQO/bUl5tsnq8P/yGfz4AKv82pqevKrnx6Q=;
        b=DoixrZwuEHyqQ8GvUiFrElFHcPEb30mwWcFSTgShLxZziob8TZZgPIPEtQ7gWQ85T5
         AtmJB4yysX5/3EoXu95PVBM2jzg0XVB7Bm45soq4KHRFjQHoD8JnoE15DuKmPEPz7kbv
         s2EXry9OP6DQFJu4uHfTsm/qdM2LzC+T44pTxW1DbiWKs2S+nfI+4Y+9qUIaU5AsDPyL
         pBsAMRtzOaFX7gjnZgNndOhQLdYj65GlaPcXjXtfqEt/EYYNjcGZJYXU0mqmmr8B5+Rl
         UD4XcOF5B6Cebq+IVeZXvgjkCgeAzFyoc7aahLo0EwHJrNXaJLVLyeKxL/3BQTnkSIpA
         aXDg==
X-Gm-Message-State: AOAM530C3dG/dJHpMpIdAD+exFSG2uTyZ8x+MYZ97vW4Et6jEhBp1QAI
        Xqvt0Set0w7WzcuFnAGjnEgulg6DJg91ps3b+VGdCZDLY6LoDw==
X-Google-Smtp-Source: ABdhPJxalGf+Fumu/WYLuvUoA+k+PomS3NTsuNLAhWG1dn8NQuxvE7mVpdJ87lRSAhyz71MvNfZLkZ0t0ELTka2PB6E=
X-Received: by 2002:a05:6130:305:: with SMTP id ay5mr47667479uab.73.1638140237839;
 Sun, 28 Nov 2021 14:57:17 -0800 (PST)
MIME-Version: 1.0
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com> <dff6b112e225993b113ec04f3205d837352b8961.camel@sipsolutions.net>
In-Reply-To: <dff6b112e225993b113ec04f3205d837352b8961.camel@sipsolutions.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 29 Nov 2021 01:57:07 +0300
Message-ID: <CAHNKnsQuiJ9rVt+f1=P6+_0BT5ro5EohnNWWoDu0p8apeDfrKA@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs optional
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 8:05 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
>> +#ifdef CONFIG_WWAN_DEBUGFS
>>  struct dentry *wwan_get_debugfs_dir(struct device *parent);
>> +#else
>> +static inline struct dentry *wwan_get_debugfs_dir(struct device *parent)
>> +{
>> +     return NULL;
>> +}
>> +#endif
>
> Now I have to send another email anyway ... but this one probably should
> be ERR_PTR(-ENODEV) or something, a la debugfs_create_dir() if debugfs
> is disabled, because then a trivial user of wwan's debugfs doesn't even
> have to care about whether it's enabled or not, it can just
> debugfs_create_dir() for its own and the debugfs core code will check
> and return immediately. Yes that's a bit more code space, but if you
> just have a debugfs file or two, having an extra Kconfig option is
> possibly overkill too. Especially if we get into this path because
> DEBUG_FS is disabled *entirely*, and thus all the functions will be
> empty inlines (but it might not be, so it should be consistent with
> debugfs always returning non-NULL).

Nice catch, thank you! Will rework in V2 to return ERR_PTR(-ENODEV).

-- 
Sergey
