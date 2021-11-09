Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FA344B26E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241943AbhKISJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241779AbhKISJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:09:21 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C979C06127A
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 10:06:35 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso10725591ots.6
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 10:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O+fhYkcqhMQ8k14bNZcPRV6UkOwVHbARh5DBR4w4Kpg=;
        b=CPnbviPehHndJcufAKnxvmQCz4mp4bEQpdeHccnDuhigP6kyJib/gphfqJKMBD9sYN
         oez1oJmgZmzZ9XoEAsKiegEc6B939nNhVcBQpeUfDIlRCKzPMyNeltxhWg23GOET6xug
         ceiQT9g16XrsJlHxHY1H3O2rBE2zM0ITmzCjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O+fhYkcqhMQ8k14bNZcPRV6UkOwVHbARh5DBR4w4Kpg=;
        b=zPsfzV2sE02tX2XgS4IkeqKAI9M6ixcEf9g4j0tMJnfKaU0bM2oC2OFPL59jBOu5dC
         yx4FC7a8zo6W4GPRKQnmbNYS5fTd+UZ36jwCHZ84yQvA9VUvQNjlSDqiXQ/Ei4UffoMl
         djYKfxUrHycRZ0UnnB4Mdi/9ugy3yK9Xi5ZQJv9D7bfq9BmtZ0GQSvYcyLOwsFe38XSU
         II+ZbXfJc2mqnGn9vMkoq4dtq0RFFNSb2OlbFMYEko+Bs8hkQW+jGZNgzALKFMUs/QdA
         VP+4x/yEKf5LYJvRSMs0aEJ+txZKBxm+wQU/uFf7u9z6Ii+JTV1m/ZeGogp2N6qGz43r
         iY8Q==
X-Gm-Message-State: AOAM5332JixzQhlp3OrHy4I7DE6k+dIfsmfBNJ4mx3szx2i8Chz45Y90
        xK8/8TKrokOvXVykoxYVEd4pBaTpKPgY1g==
X-Google-Smtp-Source: ABdhPJxc4OIlOhsx8D/RPPuVcNJB8t4jq3thkePMO7uYA2V+4xhm1PvaZwv2yGF5l7/44kZz6dDC0w==
X-Received: by 2002:a9d:2f42:: with SMTP id h60mr7144863otb.159.1636481194145;
        Tue, 09 Nov 2021 10:06:34 -0800 (PST)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id j99sm6427179otj.19.2021.11.09.10.06.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:06:32 -0800 (PST)
Received: by mail-ot1-f45.google.com with SMTP id h16-20020a9d7990000000b0055c7ae44dd2so16076603otm.10
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 10:06:32 -0800 (PST)
X-Received: by 2002:a9d:734a:: with SMTP id l10mr7706868otk.3.1636481191553;
 Tue, 09 Nov 2021 10:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20211109010649.1191041-1-sashal@kernel.org> <20211109010649.1191041-10-sashal@kernel.org>
In-Reply-To: <20211109010649.1191041-10-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 9 Nov 2021 10:06:19 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
Message-ID: <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 10/39] mwifiex: Run SET_BSS_MODE when
 changing from P2P to STATION vif-type
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 5:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jonas Dre=C3=9Fler <verdre@v0yd.nl>
>
> [ Upstream commit c2e9666cdffd347460a2b17988db4cfaf2a68fb9 ]
...
> This does not fix any particular bug and just "looked right", so there's
> a small chance it might be a regression.

I won't insist on rejecting this one, but especially given this
sentence, this doesn't really pass the smell test for -stable
candidates. It's stuff like this that pushes me a bit toward the camp
of those who despise the ML-based selection methods here, even though
it occasionally (or even often) may produce some good.

Brian
