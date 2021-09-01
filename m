Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1B83FD3D5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhIAGcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242137AbhIAGcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 02:32:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00498C061764
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 23:31:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mj9-20020a17090b368900b001965618d019so3846417pjb.4
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 23:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bpafk1X41xGK7MXDbJ4VMxRCE4Mzuv5uYTag/1eQibs=;
        b=E4pSGWJ/pCQWOPy/QHPIVscmiPk7GDQnP8Ckbq4SEJS3kYCdoDp/GzKpzTwPQP/lse
         LrpKqoqSyM2OpkcoSxmvISKxyhKrbt9a0eIF+jrjgtqFSgKnYySy6qjpxb64ufkvhSXo
         WLaCLbuQC0EQQq/Lb84kToLsnPRw+32XzUuuhJgzo+x9ho7MBAfFY8shcFqa0S53cuF/
         7+6lNDZ03P0VuQh4BNtQKq/sLsPhUkzytxcudzH//w8Lx6xbleCcHtS+5g6SfJcikmhF
         2rlGg5vKWfepZK39qtS+oVNaDr/HlYYwnXrXY9s2s4LTx1zBrI+vX5vmB6rFhOa2XgP+
         GbfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bpafk1X41xGK7MXDbJ4VMxRCE4Mzuv5uYTag/1eQibs=;
        b=HFfEcm45sHKCV4faYT8vCH0/D+v1d3MlegrVtHl2f6lxN2PFM/MvA6YXMZ74kIH01g
         +tg/h8MwG4xTLxiVhb+ci67OZezGtuPBhgdsTYtp9Hq6JTTmooTphZUUa0PBFLkn6uZT
         sv3BCmX8P3nmph+xfrwA67VDdI3PgDQFXrsl+MOXOvW9Y/rLwnGZ30h6Ko9qumyazzL9
         THcDjhmPiwMvi0rReQRBprs5cQm/GVcm2w34InHjTfbydDVvKxlOMdkTMeT1wkQ19oAg
         NreKWB7nYqpoweQWbXpTB2aloAl9jzyYj6X1AaWQ7cKz1xzX9+BAcwl2s/82AszDQjcM
         AZNA==
X-Gm-Message-State: AOAM530Ripxiv+I7Bq7r2I+JdRQHHeeUp2PRphfBzEqDnYW7ohg5n8d1
        qbbAid5b6KBc6uw0BsHQnKun6yzY8GKyI+CO3if5Bw==
X-Google-Smtp-Source: ABdhPJxprnOJMY4UIu5n1XDKPKNGr9RV+zGkMFTEI22fw+hJGHUzBjxZ7RvaQyjWpEoorsORfRskSTs3bbt3V9WssXA=
X-Received: by 2002:a17:90b:238b:: with SMTP id mr11mr10076478pjb.18.1630477885388;
 Tue, 31 Aug 2021 23:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210901030542.17257-1-benl@squareup.com>
In-Reply-To: <20210901030542.17257-1-benl@squareup.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 1 Sep 2021 08:41:48 +0200
Message-ID: <CAMZdPi8QdLwrWM5ghDNYTT2nxNJm=NgNkZGxYvbRGsYQFHGxXA@mail.gmail.com>
Subject: Re: [PATCH] wcn36xx: handle connection loss indication
To:     Benjamin Li <benl@squareup.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

On Wed, 1 Sept 2021 at 05:05, Benjamin Li <benl@squareup.com> wrote:
>
> Firmware sends delete_sta_context_ind when it detects the AP has gone
> away in STA mode. Right now the handler for that indication only handles
> AP mode; fix it to also handle STA mode.
>
> Cc: stable@vger.kernel.org
> Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")

I think it's good to have but does it really fix the link monitoring issue?
Is the connection loss detected in this scenario:
- Connect to AP
- Force active mode (iw wlan0 set power_save off)
- Wait for no data activity
- HW shutdown the AP (AP leave)

Do you get any indication?

In this scenario, DB410C (wcn3620) does not report anything.

Regards,
Loic
