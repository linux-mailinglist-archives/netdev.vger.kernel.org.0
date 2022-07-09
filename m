Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB09B56CB02
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 20:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGISHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 14:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGISH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 14:07:29 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A9F15FDF;
        Sat,  9 Jul 2022 11:07:25 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-fe023ab520so2351980fac.10;
        Sat, 09 Jul 2022 11:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fZ2DlAja/+2nCGSdIH4+cPZNDYwaZSWAPaICbiz9AYM=;
        b=CYPf091AKymWbb5KHYTb7xPPniLdyUxg/MdmhVb2t6cSo5t502Py5cw8HMWXEBjLH1
         vILDxtLKyCK80TFXiWp571x0dk2oGF/cA1xd+bT117FzNkwLX6S9NdPjCyU0LjYSoxBf
         eM2kOZ/HqHBUd9EAyd0i39WUQ5t+0t5qE6e0K2P8LxvTNv3QjtgAGUEKzAr9EdBOvMjV
         I6gsREeYeKWZJZEs0WDRlz/nRvKp8R6LB3SXfoMu4H5AiAdQJFTPSVVGrkI4GXFw3WrY
         E1AXdtJk/yvwJXT+h30IAWIfMFQRDX6roX6bfBpyXbaa2G2eex0eOqjh2kwF1MsqznH2
         xogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZ2DlAja/+2nCGSdIH4+cPZNDYwaZSWAPaICbiz9AYM=;
        b=qZbUQ37u0smfy+0seVTeeZE463z68DDolNDsbZFci/bGkrgDJBQhWO6p/WKwNsM+RE
         jYlGFNWKmMmolDwZFFP6g6mmI1oYG66vFnt8lIJPbhzhl8yamVTvamTJ17VttSOdeE23
         BNqOeF5TYXmb5lkAs+wCf+veE17uLTTFjPxP/Qakr9iJtzhRpri+kkV/umpJZAYmDbMa
         crzDcnBvTBGIiSNikeVENE3G1bovWVwfPNs8M/GqgkdZyyXeuIFmgbXnGC9qcnHM9eCF
         uLzhGMd1QLLgNc5ywIXgW5dxFKNnGNLAi8chKRCVhesV/Urv1B1BndynQp+ilVx1hKbm
         r2cg==
X-Gm-Message-State: AJIora8komt8R2kg2WFUe5hDrksTrzbcpzQksZj2I70/R1zBPvvORh1C
        XgpTvM7myxZN1aj4q7Jo5KsNfHz0ucIyklo6NeFeVrppDic=
X-Google-Smtp-Source: AGRyM1t02SzdumzFSQRTSRQJ9Jw3RvXoHXRAYYz+j/aYwo7aVDO0Q+6PAbUTzb+Nmvpl8VuNBKo4bUA/7jnhFPAx1x4=
X-Received: by 2002:a05:6870:5896:b0:e6:6c21:3584 with SMTP id
 be22-20020a056870589600b000e66c213584mr3398536oab.220.1657390045027; Sat, 09
 Jul 2022 11:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220708020223.4234-1-liubo03@inspur.com>
In-Reply-To: <20220708020223.4234-1-liubo03@inspur.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 9 Jul 2022 21:07:14 +0300
Message-ID: <CAHNKnsQRCNowC+MSfGYNi4bmVhg5O305+hwmrWjgbesoWp8UgA@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: call ida_free when device_register fails
To:     Bo Liu <liubo03@inspur.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 5:03 AM Bo Liu <liubo03@inspur.com> wrote:
> when device_register() fails, we should call ida_free().
>
> Signed-off-by: Bo Liu <liubo03@inspur.com>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
