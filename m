Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D597F416F2C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245275AbhIXJlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbhIXJlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:41:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E64C061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:40:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id me1so6566674pjb.4
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SxOrYOhQ+43oI0MOUE9uw1bduXrRmDk5xsliXsieeFE=;
        b=gHVKSZdDSM2RYY1MSLfkIsAUnq1y0uUqk9h6Xog90gJNTsj/qYLRayOeC8eZEw8Pzf
         22yP4U+CVaZG5PuhyDDn9yQLRpVaKJ8nuJP3DQ1WObvkNFEVXM+R7SI24xrXZTX1vtM+
         qiw4Xd9m3q6WvU5nJ+ZLEPdXx990JTuYwFPYBa6fX/YKoYsRI6Vt41Pgfbj+jZGiNhmo
         9N2H0trjRFS86v4hBHdkitlIVDhJ4obbSk9lih/emL16v1SegjK6kiLhcqGDYBr8h705
         /wymjz0xoR3IweUpRBDo6XnSrHgrbS+vp9/3KPH9I6twwIo6I7l+PoPWKG7IhIWWVsnM
         TRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SxOrYOhQ+43oI0MOUE9uw1bduXrRmDk5xsliXsieeFE=;
        b=ZC29ZxLdCHJijeH7e3QyODAQI+vVwXVMKhdV0Y8j+682dFXYa/IZS0G/7dkEkKhdU1
         F3J3vKJ3IRayQ4TSjqQIEk3nxGqf0HiA76MHi5Y5wHbhKanaCsyVL/KQ0TTPX6/tqjt0
         tLSuyoYFG+boSQrl/pj0g/zn8w5v3874mWOTwX7iZnuQVEtpQm2LiJBEvHaRUqav1UXh
         IXrAeXoOgTQHNTcyFR2K/wJZTWqD3qcuEZnBzu6HAUluounUKVBOVNZU7dDfx3tJFZc/
         Hsyg/zeSj7nnbVt6y5+C9HKnWkRW9yDL1p27bJqaLBbPcPxwGhhJCs2Gd8q7daUKa6oR
         PHZw==
X-Gm-Message-State: AOAM5306mwYkccHvKvTPZPVW8/cG0UU2+FI+BoiWmeWgOvNHqg6qCqU2
        9NTkyW26uQdSpeJ2O5aMruBfMkAsy5GFuaP7CbsKLLmFAINvwg==
X-Google-Smtp-Source: ABdhPJzXzZwU9McR2iWjPieCbcoQfG5O4pq5zy76cgEWrfoGWnEK4h5NsCi1yBPLrECTtQrcTIKnkdG0ovI5MZjhbak=
X-Received: by 2002:a17:903:1208:b0:13a:8c8:8a33 with SMTP id
 l8-20020a170903120800b0013a08c88a33mr8134682plh.89.1632476420610; Fri, 24 Sep
 2021 02:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210924092652.3707-1-dnlplm@gmail.com>
In-Reply-To: <20210924092652.3707-1-dnlplm@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 24 Sep 2021 11:50:31 +0200
Message-ID: <CAMZdPi9FznpSJRn61JK-Qjr03hThbP_=F2hdob9NsbwsYRPY3w@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sept 2021 at 11:27, Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Fix double free_netdev when mhi_prepare_for_transfer fails.
>
> Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
