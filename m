Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A701305E9D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhA0OtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhA0OsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:48:25 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE97C061573;
        Wed, 27 Jan 2021 06:47:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ke15so2977910ejc.12;
        Wed, 27 Jan 2021 06:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aNp3Htm/mthgfBxdo7SAS+BKT5IjCTT35idqtR5P8KU=;
        b=j4i6ufaQC0o+2TEixYwLXlhC1Rn1Nl1H5Hz+M8z0TstK6sU62SiTsFt72Ie4SsfZAg
         BqbUuooYRez7vUadLxSn1WDX6SqILkb3UUmz+pgEDDAAYGATDnfl7AH9xLoX8OwzoZtC
         YlpRItDPgy900MxFpfFhUPwyscFI50PpOT/TCtIc2FRW9a2dLYLKL26hxIB9UHIjt27W
         8ZhwaXpnRjxMRiQQZjvKR7q67Bx6+wSevHet7aMU1bNUR/oLPScl/raFz0mxb7KyYMJn
         dM321TiRm/x2vGmyvzwuL4jBuKHOiZIRL+ytZsuLNupir01XkVzFmu4XmtEJZ+EUcc1m
         AU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aNp3Htm/mthgfBxdo7SAS+BKT5IjCTT35idqtR5P8KU=;
        b=an24CHwJjW0c/acuv8Ve1zk8Yz6Mnm9GocDuL4ItcGrj5RydD3nWEPkcPlOrSCgnuK
         hMd6UFAiZbZ4BJdf7lBDRb3hxgQQ+Sfbk+pxLo5ppFip1e/ByhTyS0lDGH50Li0WggfX
         tfckHcWWaxj1z2iTB4bhYaNyoSidVTTZJW516hGVfKPBXY5WWRUzeUtrnu6l6Tcu8cQM
         fr4MZ6p3ptRzfhqGt7OSxNcPj2tfLzW2Tp2bAffWu7OqXRv2Pc3A2hq2TZL0dvdL0SKh
         s+eiOVITjqZMvOM9po6FBYMNT4Tpa9w4GUF+sMExvta73AHYISgc4xJF1Yi/IU6oP91q
         3VVg==
X-Gm-Message-State: AOAM531Fr03hsEgLeYzqGr1nE63WfHILNCSDZtHkQXm92yZqmuRc2ly0
        vsdlcSR7iFP1M9jhyP3D4p5rkBwr4qlPHDkJ0KFBbQcc
X-Google-Smtp-Source: ABdhPJzhIQSZtqdhi01xZM/zJm1LH9dY0dYZ3Puz5+1d8Tz5sDuaaegtGh3qb5xrOoRPwplcvOqltdnWkYOJfJZQOoY=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr6855124ejk.538.1611758864039;
 Wed, 27 Jan 2021 06:47:44 -0800 (PST)
MIME-Version: 1.0
References: <20210126171550.3066-1-kernel@esmil.dk>
In-Reply-To: <20210126171550.3066-1-kernel@esmil.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 09:47:08 -0500
Message-ID: <CAF=yD-LGoVkf5ARHPsGAMbsruDq7iQ=X8c3cZRp5XaZC936EMw@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: use tasklet_setup to initialize rx_work_tasklet
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 5:23 AM Emil Renner Berthing <kernel@esmil.dk> wrote:
>
> In commit d3ccc14dfe95 most of the tasklets in this driver was
> updated to the new API. However for the rx_work_tasklet only the
> type of the callback was changed from
>   void _rtl_rx_work(unsigned long data)
> to
>   void _rtl_rx_work(struct tasklet_struct *t).
>
> The initialization of rx_work_tasklet was still open-coded and the
> function pointer just cast into the old type, and hence nothing sets
> rx_work_tasklet.use_callback = true and the callback was still called as
>
>   t->func(t->data);
>
> with uninitialized/zero t->data.
>
> Commit 6b8c7574a5f8 changed the casting of _rtl_rx_work a bit and
> initialized t->data to a pointer to the tasklet cast to an unsigned
> long.
>
> This way calling t->func(t->data) might actually work through all the
> casting, but it still doesn't update the code to use the new tasklet
> API.
>
> Let's use the new tasklet_setup to initialize rx_work_tasklet properly
> and set rx_work_tasklet.use_callback = true so that the callback is
> called as
>
>   t->callback(t);
>
> without all the casting.
>
> Fixes: 6b8c7574a5f8 ("rtlwifi: fix build warning")
> Fixes: d3ccc14dfe95 ("rtlwifi/rtw88: convert tasklets to use new tasklet_setup() API")
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>

Since the current code works, this could target net-next without Fixes tags.

Acked-by: Willem de Bruijn <willemb@google.com>
