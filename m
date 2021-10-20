Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83843435158
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhJTRgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhJTRgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:36:07 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B99C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:33:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 34-20020a9d0325000000b00552cae0decbso7443097otv.0
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fdaRz+/HIqoZ+D6ASe4LTEi6mTmOeWkSvY06s8Isgz0=;
        b=dxr9ZT1SPRYkdpGZIuvRMH2pBK3dL8EwUNYym6mFO4Zteaqbxx45lA4PG5/RqNnACG
         aqlkFhP6xgZ8zOz9Hw+Rg1pIdSF7d41jbaI+QJzqSgtDqI0lz3L+8cS3Vou1Q9ah4Qyt
         BJxnV7DRjHZvXSXYNOuhPXGh4Bnp17F2LUU2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fdaRz+/HIqoZ+D6ASe4LTEi6mTmOeWkSvY06s8Isgz0=;
        b=6OiKXIItHAtb12nNc/oAZfN0XQgavezwZmY3IQawsDpQWomXv/Maz76eMUY/kg42Dg
         gHn1EGZ09Jne4yALf78X9q/ajyXBtt67HnYUNDCQkuaW58wO8YxS5+k4pGk/FJ61lTyY
         ZOf9uKEBZJ5W6yWbsM57xYO6b82VP7f2ulPwu9qjTfcHI9vBW06JQ3FQIDIe+QKG5fsO
         sUclNq/NKMR2y9jflviHZcQWTbPMBumTTmv8QlWdJWS7CJcrCly9v/+zUAbsGUc49ZJI
         9X46zg2YYGKFwftxzFnzJ8XzNLxQaFo1/XrIWFDQwxyV5M2ek+IKSuZLpWGjahJxOraC
         yErQ==
X-Gm-Message-State: AOAM5323Am2HPAMqi4ZT3v4kV1oppwp8J6zUZTp1SL6ydbdcqv8bLUM7
        ao/wjQiLFHcPY7yH3ZpuzSFmOkhQ6EsrCg==
X-Google-Smtp-Source: ABdhPJxsZLn0p+dwTKBZbuvfZqDIWd8Y8dYbt5UPYr91F0OiZpto6MpD2+oObxk+PM1fLTqr12nQzQ==
X-Received: by 2002:a9d:67d8:: with SMTP id c24mr506511otn.308.1634751231469;
        Wed, 20 Oct 2021 10:33:51 -0700 (PDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id bg16sm612222oib.14.2021.10.20.10.33.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 10:33:49 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id t4so10525391oie.5
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:33:48 -0700 (PDT)
X-Received: by 2002:a05:6808:1892:: with SMTP id bi18mr621637oib.105.1634751228418;
 Wed, 20 Oct 2021 10:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211020120345.2016045-1-wanghai38@huawei.com>
In-Reply-To: <20211020120345.2016045-1-wanghai38@huawei.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 20 Oct 2021 10:33:37 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNUY_HevQm12Q0MZrYzcbb7br94xO6fkuFi0EuzdV_LjQ@mail.gmail.com>
Message-ID: <CA+ASDXNUY_HevQm12Q0MZrYzcbb7br94xO6fkuFi0EuzdV_LjQ@mail.gmail.com>
Subject: Re: [PATCH v2 wireless-drivers 0/2] libertas: Fix some memory leak bugs
To:     Wang Hai <wanghai38@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, shenyang39@huawei.com,
        marcelo@kvack.org, linville@tuxdriver.com, luisca@cozybit.com,
        libertas-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 5:04 AM Wang Hai <wanghai38@huawei.com> wrote:
> This patchset fixes some memory leak bugs by adding the missing kfree().

You could probably just as well switch the kzalloc()'s to be
devm_kzalloc()'s, but either way works I guess.

Reviewed-by: Brian Norris <briannorris@chromium.org>
