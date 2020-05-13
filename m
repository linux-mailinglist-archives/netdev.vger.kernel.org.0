Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5391D1E79
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390418AbgEMTDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390399AbgEMTDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:03:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA0AC061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:03:05 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u15so808176ljd.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Chzp3tbyXEmpa9DZODCBT8j/RcyA+WHDHn8SKIYvqlo=;
        b=JugjIFo8e41xcj1mBh50Kv4JJdwWswQdosSkw2SGo25NkR8diJgzxmSmAimUoPFy0g
         UqtufzWVyYpztDyGgk4HCi22Aw09xlnezrYm4PHhCJi+H8Ei8/tmkqX+byilYh/qSlsZ
         kQ2oFBqHEcL+58tiDWHOiXYpFBIpD7JYaeHj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Chzp3tbyXEmpa9DZODCBT8j/RcyA+WHDHn8SKIYvqlo=;
        b=dzsoFyYs35YtEJ1GmZp4OefCMQhOV+kVmsRqPXbQIIQMCIjtM6aFGpvqVPwjh1+naX
         XsgSjidXSC5ePv8bcYDoBaxwETBJY7A4Oilq97slSLRNJlfZSfU5H56pIby4oDpGq7jk
         fQjJA6VBxbQ1YtYO2IsiNkyNhC3rD3HA0f6UMjT98F97In/UVHWHRXaKCK3w0+ze84Gs
         MOXizbaLYfGeOLvWsjez1GGCmNh9imkSreW5NnlkZ7wmpncjFLmYZw0qKsIxo5BxGdWK
         SZf6H3hpSIcctQhZnWrMVJsV4lfdX9df28fSnAFp+x9INdr4v8hJTuW7uREZGT8/tcCv
         NZgA==
X-Gm-Message-State: AOAM532dy3ECjfFKeoREWbdVtgwW2GGNz3bQsSxoK11ySYrsLig4UGGV
        5HdYqN9p3JBr4ex5bywVZIT2jS8IFY0=
X-Google-Smtp-Source: ABdhPJx6Jgmg+1ak2gjQTxJZpMxmSOFFMIs5vfPpWgqELOkybZebM+fRlfOjWC+v7awvMHlu3ArKxA==
X-Received: by 2002:a05:651c:549:: with SMTP id q9mr336268ljp.236.1589396583777;
        Wed, 13 May 2020 12:03:03 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id c19sm274087lfh.42.2020.05.13.12.03.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:03:01 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id x73so469905lfa.2
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:03:00 -0700 (PDT)
X-Received: by 2002:a19:ccce:: with SMTP id c197mr619201lfg.59.1589396579890;
 Wed, 13 May 2020 12:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
 <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com> <878shwtiw3.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878shwtiw3.fsf@kamboji.qca.qualcomm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 13 May 2020 12:02:48 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOgechejxzN4-xPcuTW-Ra7z9Z6EeiQ4wMrEowZc-p+uA@mail.gmail.com>
Message-ID: <CA+ASDXOgechejxzN4-xPcuTW-Ra7z9Z6EeiQ4wMrEowZc-p+uA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:05 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Actually it's already reverted in -next, nobody just realised that it's
> a regression from commit 728c1e2a05e4:
>
> ced21a4c726b ath9k: Fix use-after-free Read in htc_connect_service

Nice.

> v5.8-rc1 should be the first release having the fix.

So I guess we have to wait until 5.8-rc1 (when this lands in mainline)
to send this manually to stable@vger.kernel.org?

Brian
