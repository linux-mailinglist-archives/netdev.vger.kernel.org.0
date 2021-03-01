Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CF1328029
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 15:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhCAN7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbhCAN7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:59:53 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15593C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:59:13 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 2so14960130ljr.5
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XcR/dzHVgKkCRGIsBLxsPv1g4tIUIXKwFlYY1CUcxQw=;
        b=mcd+5Ms0K5O8lJfp+Hg3iiZK5GFnAcw5smpc5fYLfIDm2zwAkiBkL9cqO6YvU+Aaj9
         knpvZIeLv0NImoj/9CH6n7VLCasnSF7P6PiA2+OPqoGicmxFpv96j4WwVpG5r6V8erqi
         NDNBjlPg1TAG8NLVBP6F41NcwCH/HiW/88sWLxF/1mKWmQSH337Z5QDul2fQ1AvAGzow
         j1YRFNWiehgRJvlzc/03LGn3wL3smM5UTuMN/TiU6BA23c7L3yD3D7fRT2O7XHfibsSw
         jYFmq749oEuVU34DmDpez0xplb9IRHwVaSI3N2QvWz3Zjjmx5ERO8fCzrHGhn8rN7ICw
         HGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcR/dzHVgKkCRGIsBLxsPv1g4tIUIXKwFlYY1CUcxQw=;
        b=ZQLuf90BZnh/KwzAhY/XB2NttBdsLEugIZ/iUvvqemwUrxql59UpwVY/YPyW7DEbDX
         24UVaMgfgO22/6tvRqHqZ4k2Jb5luPY4IaI7BROnsCzIk6XXuL/YA3d10ApzQbO2tHP7
         hoWvM0lRN1AZn7EKyZAQtgRSes4rTR9BY5utq4vEDfpsAf0FtgiXgtoO5HkQh5YAzUvD
         gOiszUL3CJ/hLb+5dRuJvr+zD8Yk0Q5ZLOI3jBpzoHsoB8phgBZLFtpdKPkGhokQR4ud
         MxSkQPvNWCWH0xk5rTLcGdp41E4PCwyJavIj7ex8ZZhtISE9RoDByOXtGHut91Vu3rX4
         38Yg==
X-Gm-Message-State: AOAM531/8FIzQanWB9BzNk5RD6lLWbfv3VJ/SJFeO1PnjDxDyEGNThbE
        bksEbCVl3w5mVhNSeQ/DJgw6u2nbH/Unr4/caOHFOA==
X-Google-Smtp-Source: ABdhPJzJxMEWzzKTbRFbxSW4JSBPEDQHkV4eW75ZmlMLtfAi4mE1xdnnyaCGl/I5JiWt40FY5leZnjHaCzDmvkU5m4E=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr7052483ljj.200.1614607150550;
 Mon, 01 Mar 2021 05:59:10 -0800 (PST)
MIME-Version: 1.0
References: <20210228170823.1488-1-dqfext@gmail.com>
In-Reply-To: <20210228170823.1488-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 1 Mar 2021 14:58:59 +0100
Message-ID: <CACRpkdYpO6xXkswSO_wRLJNeeO6LZtT_W+KN-ECRyCc+ybU7VA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: fix egress tags
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 6:08 PM DENG Qingfang <dqfext@gmail.com> wrote:

> Commit 86dd9868b878 has several issues, but was accepted too soon
> before anyone could take a look.
>
> - Double free. dsa_slave_xmit() will free the skb if the xmit function
>   returns NULL, but the skb is already freed by eth_skb_pad(). Use
>   __skb_put_padto() to avoid that.
> - Unnecessary allocation. It has been done by DSA core since commit
>   a3b0b6479700.
> - A u16 pointer points to skb data. It should be __be16 for network
>   byte order.
> - Typo in comments. "numer" -> "number".
>
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Ooops I send patches before properly going through the mailbox.
Oh well things like that happen.

David: ignore my patches to the same tagger and apply this instead!

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
