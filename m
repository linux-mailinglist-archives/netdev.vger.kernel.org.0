Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6232187B8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgGHMhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgGHMhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:37:33 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39DFC08C5DC;
        Wed,  8 Jul 2020 05:37:32 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r19so2993906ljn.12;
        Wed, 08 Jul 2020 05:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=LDeWTEvkuS1/QhAV7zh4F+ok/kij8xM7tE+g5IT2QsA=;
        b=rwMrtEAdih6Ym82MQBl7+Gc4CndgHIxLSbra1TY8UCiscntDudMdupm+1E5sGNWnzv
         Idg0gptRmGK72ge6eT/uykFuVjKm4PKrvBO3jbhRQ5rmfC+sWXg8JudiN/lKO37CJiwm
         lKXkki6274fYAeYPGIz421SR8RJOnL1RuQLmAmyrsH6O93kFr+Wz1nWJAV+VBp8szz5u
         u1Tyd16X+ksS5seUz9qNkiQGNXf4klZDO462rKSZp52XWB7gBu2xUxewLDRWaPRSdL+L
         oX9GsouxeM4XoIv8lp3qEauFjpzKTJ0tJS2T4tlCf6dhAhxo6JHsJbKMye4oeV+vo0jx
         3Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=LDeWTEvkuS1/QhAV7zh4F+ok/kij8xM7tE+g5IT2QsA=;
        b=UIU52V1+ImND23EMaHjXldiYandSi6dDMM31Fxu9AC1aOh3IsrW8v3OoXFTIvDA07b
         3tyDUsMUD6OmOS9Zp8oQK0MxGwHgW0tRU+uhMR45HITNDlkcoZITWTyFzvWLIYOi+Z9W
         lWbzG6uk8wMd6s1tFxVvdDacqhOSfCLH7XPB7d+mT4W8vvz+VVWNoYMV4f5g76sBqzdh
         1p3v5g9JdNymmDK+zAQ48R386e2sf0+J4h4YlNXpF+I+r13T7z5M1GGPi7uA1QjmweUH
         4OAtvq32y5cgt448+nHchPvxMSFJKJwt5axq8tnMQyMBqtE2vRgpQrqUcwI9RTFWmBHO
         zCiw==
X-Gm-Message-State: AOAM5302d6lu9WRUF2tEt6+8koNQ15AOzcZMYoC1jTkajw/h3R25c+IZ
        ESENQrA83w2k92uGMcrNArQN3ipd
X-Google-Smtp-Source: ABdhPJzE/jSq7zp7eBoTaHTEEqiSaP986/SMtXBvEttSuHbEQayU/ql4SPwWt3FVs22VqwSaoCVMuA==
X-Received: by 2002:a2e:8954:: with SMTP id b20mr31637166ljk.262.1594211851205;
        Wed, 08 Jul 2020 05:37:31 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id v24sm10344753lfo.4.2020.07.08.05.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:37:30 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf> <20200708110444.GD9080@hoboy>
Date:   Wed, 08 Jul 2020 15:37:29 +0300
In-Reply-To: <20200708110444.GD9080@hoboy> (Richard Cochran's message of "Wed,
        8 Jul 2020 04:04:44 -0700")
Message-ID: <87mu4a9o8m.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Mon, Jul 06, 2020 at 06:27:21PM +0300, Vladimir Oltean wrote:
>> There's no correct answer, I'm afraid. Whatever the default value of the
>> clock may be, it's bound to be confusing for some reason, _if_ the
>> reason why you're investigating it in the first place is a driver bug.
>> Also, I don't really see how your change to use Jan 1st 1970 makes it
>> any less confusing.
>
> +1
>
> For a PHC, the user of the clock must check the PTP stack's
> synchronization flags via the management interface to know the status
> of the time signal.

Actually, as I just realized, the right solution for my original problem
would rather be adding PTP clock ID that time stamped Ethernet packet to
the Ethernet hardware time stamp (see my previous reply as well).

Thanks,
-- Sergey
