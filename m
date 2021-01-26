Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66B5304D9D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbhAZXMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbhAZVJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:09:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD63C0613D6;
        Tue, 26 Jan 2021 13:08:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b21so21448669edy.6;
        Tue, 26 Jan 2021 13:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkQGMfW0HUkSImcIx518mXAmDUU0Hd1WL2a+H31ftRg=;
        b=PpyTlZd+Ef4Gu7Bp4Am1vQF4eeVc/awahdqAxKxH2iMKuuJkmjsXRmGIJOmX6xSI69
         Mfl7egAYjP9lHK+VDIn+bGz19+zWhSA279fyLnarL70DKdgAQxqMFqWIuCrt/UYX3GqW
         AxIydyxaVdfWh2Mbi3rjNby8hAtuHgOMul9MmbiExU9Ruxs5hpZfd1NjyMIUtFLqQDu2
         RxsNLCueEU7vyU3F2jtzuRxm5B4otTRmRK/0I61hjgrL3RIS+E5XZniZNgr/eDRAtFJF
         gffhR8ZfF+P57ZPuMlcUU0BSjTW7r1s1jyGnejhLnAe25SZ6W5N6vbyXHZfcaFxGgjoo
         IU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RkQGMfW0HUkSImcIx518mXAmDUU0Hd1WL2a+H31ftRg=;
        b=LQmMJnF28l9D+Xa4uKC3b/qUEfoqBZxLNzKlN/l9k+OpSxn/iC3wdaJGywfgaRu6Sl
         3FmgOcaYs5B1xMIf4YoVdPmoIEu2ZrD4kzwi0JWu6MpGOev436Jb7rFBINxZ5vsUuF5a
         ukquiNz5syxzbo7zlpJ05iZofqMHhcEHWfc/ILW0x195a7IKtLMHIyB5FhekOmIofIu+
         q+fb2+VGH+MtOvJHgMpZEi4qhS+sxh+9d/4McYXeJ2ihxjliGgfcV3vUBA8bE5uWmX4J
         TjgzDZorXaa/IB9ZJs+8IX3Mmw8/NyZpv5qOjQN7zRL4XPdBw5PGhE6vpeO+qoLkCn4L
         RCfw==
X-Gm-Message-State: AOAM530KfGRUsFceo76KYxwaSpkeNbLv844QYfTa4bt6a/X1HVcXNFzY
        Ldp1LlURgq76FTZ/Xvka7Qc=
X-Google-Smtp-Source: ABdhPJx4uyfwj6Lo/tPMl28u/y4Ewdr5M/XNw5xDzn1TW5suxsclcJCQg23pIxqux4atTjGO/2h7VA==
X-Received: by 2002:a05:6402:2289:: with SMTP id cw9mr5972388edb.319.1611695321034;
        Tue, 26 Jan 2021 13:08:41 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m26sm10253782ejr.54.2021.01.26.13.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:08:39 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:08:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210126210837.7mfzkjqsc3aui3fn@skbuf>
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Mon, Jan 25, 2021 at 05:56:31AM +0100, Lorenzo Carletti wrote:
> In the rtl8366rb driver there are some jam tables which contain
> undocumented values.
> While trying to understand what these tables actually do,
> I noticed a discrepancy in how one of those was treated.

And did you manage to find out what these tables actually do?

> Most of them were plain u16 arrays, while the ethernet one was
> an u16 matrix.
> By looking at the vendor's droplets of source code these tables came from,
> I found out that they were all originally u16 matrixes.
> 
> This commit standardizes the jam tables, turning them all into
> u16 matrixes.

Why? What difference does it make?

> This change makes it easier to understand how the jam tables are used

No it doesn't?

> and also makes it possible for a single function to handle all of them,
> removing some duplicated code.

On which RTL8366RB chip revisions did you test for regressions?

On another note, the patch doesn't apply cleanly to net-next/master.
