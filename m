Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A22B26DC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgKMVcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgKMVbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:31:53 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F220AC061A52;
        Fri, 13 Nov 2020 13:25:42 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id e5so5387688qvs.1;
        Fri, 13 Nov 2020 13:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TdnY99F9lb58bh9jAVmDJPNTy58Y1xlClOHjyC7GswE=;
        b=B4iMnoybje6QkXcPIbLnFFS42V9OzA72mbKDN83dmNEeTLxUupiQ0y8dtCzQWSHPZG
         Fu0ymwYgbpAcGsucftoHzqo/8Tl2WHxEdpnEQxMDN8xAAPdNj9YkoVUds6y1r+y/fnJC
         o9V/k3Q7bne0+B4AxJIYDTf/ZnVTPL0QEMpnqBG0/hYFAKncAU5ZKEPuk1pbp3et2P0q
         5B7lQi/KRMYOTjhUIKe7M5BDCvjEvEmf13H/J0e+bWP8iurJhrxSVrYuA3qHvn2ulcBw
         3wiZ9ie6E+CLOYArXylG5MIcedWf2DfUYSt6HR3YMZMffo5GUnj7mPjzAO1J45adamiR
         ipFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TdnY99F9lb58bh9jAVmDJPNTy58Y1xlClOHjyC7GswE=;
        b=RKNd6bXQaY4bYTiKGrFXixEXQp1+45HUz48MlFaIVSMHyCBNx1OlGng3bKO46JGPyU
         UNwfYQ20sKv6XV8hAXIKu88i2lqET0lY4qR2571lf+05zJYRdDCAtYFWvLz2WAmkVT/Q
         Ku4Rkh4whp8z+fNnOOyw0JHqP0rdZjh9H4Hc8p0hoyg0gptDoWlm+mMMK27m66HQugDl
         Ly+aYip4Ug9fzDu0YYuF1uhydnOlTC/dg+N9f+6HWm7hgiXFn2loJTQDGxuAgkCrYkIN
         UI5uimUjD7lmNicTejUIBdhjxGEWaUNIGInSX312BbnX9DORJZ7TXpHZUzxeDZ1fLr8P
         vG+Q==
X-Gm-Message-State: AOAM530sY3Cma03UIOHX0L8cpR/TD/yk0RGN+GC4cF1hTm3AhO6auZ+v
        bHwsInL1HYaXn4CqP6TnHVwKGFg3t1welnz5/7Y=
X-Google-Smtp-Source: ABdhPJzETwy8FEM80LqNE0/UHC+bwYQaVFvbbEcw0buakJj3ZrQ2MS9AUs7lc/Y95OoEEQ8jmqm6L3+kLweAOH732ME=
X-Received: by 2002:a0c:9021:: with SMTP id o30mr4318564qvo.1.1605302742125;
 Fri, 13 Nov 2020 13:25:42 -0800 (PST)
MIME-Version: 1.0
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
 <20201113085804.115806-1-lev@openvpn.net> <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
 <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com> <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lev Stipakov <lstipakov@gmail.com>
Date:   Fri, 13 Nov 2020 23:25:31 +0200
Message-ID: <CAGyAFMVpjwJWMaWp-tQuXCf9WPpsdzNhV0AYOX4iuDQef5jnHA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Lev, please either post the patches separately (non-series) or make
> them a proper series which has a cover letter etc. and CC folks on all
> the patches.

Understood, thanks.

> Since there are no dependencies between the patches here you could have
> gone for separate patches here.

Shall I re-send those 3 patches separately or can we proceed with those
in the (sub-optimal) form they've been already sent?

-- 
-Lev
