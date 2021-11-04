Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67A4459F7
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhKDSt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhKDStY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 14:49:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE54C06120A
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 11:46:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p18so8688059plf.13
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 11:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PorSLppZT3IedQU0Aiir1xp4SHeSb1PGuZKovfWyfMo=;
        b=C6AYOPXp7GDQstXKhfY+qqe7bihiJvlo46H/bBrDRr5nb2tlWh1oLFYNUaUXAySyQI
         MQ2Mb+ynV83Kl5cwf5b42/IzSP+02VBbsrN4e0K4G7L5A5b2JDxoAP0noBYBjWHlyuaJ
         4mIf7A/jxmo15PFNXR/Gv7eDzmpnRBdsp9Xm4lo8fUx1gm8eg2PZ/4ho/zMa0WLdZYxP
         6RfJMV2kWKj5kbtsqm7txzYlJU1v8HQLboR7DWx7zmr8uX7LfiKT+5cWcBS+ViGhjgH/
         0wrSRn2HE1tnIbq9taGm+kFwx2u/3ZCt5ERDrsOLq1IvB3/iXodMRbHoKldR2olwjuRG
         Pf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PorSLppZT3IedQU0Aiir1xp4SHeSb1PGuZKovfWyfMo=;
        b=RHLmrsbffcIzqAdXFo+B4TuagVNNoxx9fLriIEDJD9vG+79OYIkonZ12AyZhJdYmkm
         Zs/Rbzlg3PzfehXI6xXjt+AhFgj9mpyPp0NDNqXOa/rfTrMZQuvxv99fMf5zFsWiTKQ7
         16B0Lxc5jqb6oV0oN+//9od7XraslLO8IIhq51Z9ILpFy4dNFODHqy7BNBGiVT3npN0f
         V6Fs1cnzRhqZCLeL9KCm7Y1QSuF+k6pY8o781cBW/gE3Pke/hn8ksIjvKYr6IayWXiIU
         4epvBZEnRnUcX6GvlyZsFrsqloJ1KYBPTxprrgUz1xNCVc37/uiqmWZtehijYAUkEQs8
         xnAg==
X-Gm-Message-State: AOAM532d1Na1YcaTtYHYJ0GBmQSuL6TPnPhLrm4s/SqJfEF9kO+E8DYI
        NZzBEnmW6hUsa80qtSPutMIRrY/gOMD9Uxsk2ho8Zw==
X-Google-Smtp-Source: ABdhPJwVT/QSowoDtWEN2jsATxofev3CtcyomsTIjU0EabHehx7QAl/wAGopkNPrEbIm1a3otSFjmLDNu8h0dJBepJ8=
X-Received: by 2002:a17:90a:3b02:: with SMTP id d2mr23648066pjc.159.1636051605807;
 Thu, 04 Nov 2021 11:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211104010548.1107405-1-benl@squareup.com> <20211104010548.1107405-3-benl@squareup.com>
In-Reply-To: <20211104010548.1107405-3-benl@squareup.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 4 Nov 2021 19:57:27 +0100
Message-ID: <CAMZdPi_piZp8nTP+TwxTw8_AE7F53st3X3d-gY2rvnN9-81D5Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] wcn36xx: fix RX BD rate mapping for 5GHz legacy rates
To:     Benjamin Li <benl@squareup.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Nov 2021 at 02:06, Benjamin Li <benl@squareup.com> wrote:
>
> The linear mapping between the BD rate field and the driver's 5GHz
> legacy rates table (wcn_5ghz_rates) does not only apply for the latter
> four rates -- it applies to all eight rates.
>
> Fixes: 6ea131acea98 ("wcn36xx: Fix warning due to bad rate_idx")
> Signed-off-by: Benjamin Li <benl@squareup.com>

Tested-by: Loic Poulain <loic.poulain@linaro.org>
