Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE4644F136
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhKMEcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhKMEcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 23:32:42 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6FFC061766;
        Fri, 12 Nov 2021 20:29:50 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id d128so6196178vkf.11;
        Fri, 12 Nov 2021 20:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=t9ihXgREX3InFvx1Wn5SZtm/TKfO4gpL5pKxnsJrr+Y=;
        b=Q0fFGdVgO6Xy6yLtVUlFqZ9a+FUZ7t9zoo9c6CTrZIcBRKgvtb28d8KQlHnDQfPJ2Y
         MTpiyX3lA4JnMglKD3YpTbqkjg+5WULGWOQFJHMCUIfWz+YNFxizRWiRv6Kk3SlEuJ4c
         MWbnVtalGyniKlWgBPPWSOTz5ZWP2yuMntPHN2XgIhc8HO36OsnFICLFixrEs6D3ha5A
         CBBL9CCGG7bqCK2kVHTEArrqLyR7l+D3/qtPaupywpUOdquDFRGqw5uP1zSjStKwRc3g
         Q7NAh+vD4kAmt0TsnWKzEhqgpQwwQSC+Sq0iGeRGmM4WucT+hw4bg/taP68DA9m8T4dP
         uCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=t9ihXgREX3InFvx1Wn5SZtm/TKfO4gpL5pKxnsJrr+Y=;
        b=AKACtYlCW2QiNRDa5e+hAGj8lMha2kEGNmVcGDfw0v2LA7c2cHxOUNcrlN7N1p87Fy
         psxkx/qNIpo3w9e/n9kEGxIni7qkT8G2XyFHZY+ZryWW0SNJ87XTZx2NLct6VsEqujPL
         PU0jCpHGsdIwDf2OBCG6mR0WA+NRt+5MrfYZYax1/lGtOX6qvDj8RnpQ9CAUFhikRH8/
         J/bK4+8vgs2YNRYX3nol6Rlsa5WmWwVT4UEtn6yzAfW9QjUJB1RZmktIkwrWz7BF1L+K
         gzP0BoBjLzTUUHMIQzIO4aoHVyHmh9N1OG229WbyI7s9QdV11NbvJzjRDa95c1jc5B1T
         Y8vw==
X-Gm-Message-State: AOAM531TSrtQBY8rl5166MfkphW5crC+zM6rujJ15Cmh+HDAdQ1uNzE2
        q8FFZC1UXxcmi4/0gy2eTy0yM4OtpQd0puu+nHcsINpv
X-Google-Smtp-Source: ABdhPJwpIwZulrijaJ+GTvy2HomLLz9P0P7tNQ/aVLgUxVJmb+VPMHHHA97IPFK/JyT7RLDUIEWzDBBzwEaNbqame2U=
X-Received: by 2002:a1f:18cb:: with SMTP id 194mr30964756vky.16.1636777789386;
 Fri, 12 Nov 2021 20:29:49 -0800 (PST)
MIME-Version: 1.0
From:   Jupiter <jupiter.hce@gmail.com>
Date:   Sat, 13 Nov 2021 15:29:13 +1100
Message-ID: <CAA=hcWSRO7Khj8XZbq6fzA6sEN0urR4SeJZh2YcrGe6g8d9ZdA@mail.gmail.com>
Subject: mwifiex_sdio and mwifiex failure
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     netdev@vger.kernel.org, Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am work on a Linux embedded IoT device including both 4G LTE and
WiFi modems, I use linux-firmware-sd8801 and Marvell driver
mwifiex_sdio.ko and mwifiex.ko drivers, it works well for a couple of
days, then the WiFi failed which could be caused by low WiFi signal
strength level, but that should not cause the mwifiex_sdio errors.
While the connman was able to switch from WiFi connection to 4G LTE
connection automatically, following error messages popped up in
console and kernel logs every second to consume lots of resources
despite the 4G LTE being connected and worked perfectly.
...............
[924785.415505] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
[924807.818102] mwifiex_sdio mmc0:0001:1: Ignore scan. Card removed or
firmware in bad state
[924808.406775] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
...........

I am not quite sure if the error message indicated the mwifiex_sdio or
kernel crash or not, but given the 4G LTE was connected fine, the
device was still in good operation, I don't think it is a kernel crash
sign.

My questions are:

(a) Is there any way to recover the mwifiex_sdio or reset
mwifiex_sdio? I tried modprobe -r mwifiex_sdio, modprobe mwifiex_sdio
and modprobe mwifiex, but that crashed my debug console despite the
device was still in good operation. I could only make it recover by
rebooting the device which was not a good solution as it was operated
24 / 7.

(b) If there is no way to recover or reset mwifiex_sdio, are there any
methods to suppress mwifiex_sdio endless error messages to both debug
console and to kernel logs?

Thank you.

Kind regards,

- jh
