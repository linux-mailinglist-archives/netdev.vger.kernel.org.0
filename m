Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2143E5AF3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbhHJNUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbhHJNUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:20:05 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC4FC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:19:43 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so5312362ooa.11
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8MKgAV3kZhkvYRnrj21h52f/VrcDvj7Cx0QoPmBMVcs=;
        b=n56CD6a3qlTT80gC5UK4sUmbXtiYSzMGpesaFRfRAQ9u+7kaNEUQYsfWUvA0tIk8Jz
         MZ9ofwiUi1U1Eos9mzmpymbmRK1wMlWmpaXU7gb42OlTu/69UU20+WH0DN8Vo3mGia4d
         QOZhp17/0N4/rMSvwQMIxayDvzwBvIDOItFMA/4HakfsykeiNT9QteMHmg1KTh6pHnlq
         Nmh84hUTTUxPa5u5nfMAmPjmOsXRV3Msiq1r7aYO0aGM3QgFwDnKedKEYm8BoXsy2Szn
         IH1FenFDn4BHuba9ZSzHLWObyRPpBsaMNjiaOPMAUpGqz2UsAwvozGP8kK3uYsIqzZc8
         8CPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8MKgAV3kZhkvYRnrj21h52f/VrcDvj7Cx0QoPmBMVcs=;
        b=j8PwoFlZHpBcV4Dzx7lLSGUwTYVqTNGitc5KiOBLnLiKTy9QmS+gTgibgBFEq/jnw/
         9avXIhiJxofDJZ85/Jxb6DI8fiw9ZjhoMMb7XDDJ3vE8OnDcWORsKjeGL7hYT43xYgX9
         gYA2a6aNr78InYJbMBOYzepMRT375fdONgG+nZpdy9Tq/3OR2F0evf1K+P/vKhCTSk7R
         bK30cZw61i/ijc/Q9QjW7gnZQZ0U1s7aVuriVmeYyE9SmHk9n6RDyI33P0uVJLpPrfDT
         Q22uFank3smixzcjRFP5YccJ0dl1+9rbCzHLq8jJIg1WPoU5a/wfWZcghIkzLfEyJ2OF
         nzhQ==
X-Gm-Message-State: AOAM5321bSm7MgYEPwrtPtXMXL8akj5yHPAMhBwJlJ+KWQ09ftHorvwK
        fnYfJArAv/11bTXTU3cNL5w=
X-Google-Smtp-Source: ABdhPJwJym+0ygO58BqDx50YnlyNKk34fdELnKYglKj6G856r1ZC5NKorLQCufjEaO3pbn1aEVLXuw==
X-Received: by 2002:a4a:d634:: with SMTP id n20mr4735638oon.27.1628601582973;
        Tue, 10 Aug 2021 06:19:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id x14sm3901656oiv.4.2021.08.10.06.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:19:42 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: Support filtering interfaces on no
 master
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210810090658.2778960-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1bdd4d76-5448-42a4-6f24-16a6b2134b4a@gmail.com>
Date:   Tue, 10 Aug 2021 07:19:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810090658.2778960-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 3:06 AM, Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
> v2 -> v3
>  - Change the way 'master' is checked for being non NULL
> v1 -> v2
>  - Change from filtering just for non VRF slaves to non slaves at all
> 
>  net/core/neighbour.c | 7 +++++++
>  net/core/rtnetlink.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

