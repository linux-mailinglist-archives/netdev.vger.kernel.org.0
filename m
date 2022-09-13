Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3077E5B78E4
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiIMRye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiIMRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:54:11 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1DF136
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 09:53:50 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p3so275465iof.13
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ob0njUs0ZDOxEpUcY9OqJfdPDSGFD4pwrd8yeJjvCho=;
        b=fhxPQGsczs8DRATrW0v3yuEzor3UYTy7ELfOcyV71hhcDQxxx0NY7TVDcsLTn0puIj
         RpI4TIEVkQ8sycSf4fg2be7mRQHUKWWC+hOUdCjTNUdfx82bBOxUDUgzoWbGNlD/KQ3b
         CbZFzi1gEepXzWR+Ez/xAPo+eB+iEoFhRu8jLj52aZquhPmaosKhOSsU61JJWXv5YB0q
         3NfX2IchMhhIJtfgma1aQiVOXWDpk/pIc86NMonBpbVOZZAc/SlwUN35dY8YTKCyj+xL
         ofzgczSujaDMyI9858ExSa2eNnUWjan/1TY6VsXTBPYXSIrXK5h+rvYmOWpKWA+t27T4
         AxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ob0njUs0ZDOxEpUcY9OqJfdPDSGFD4pwrd8yeJjvCho=;
        b=zzH6OjV9caZMPlnCYygOtE0krZMfbpb9ZWkpulzDpllidq3k4I/HZGTwfsTw8t5x6S
         iXHDLI8E7d4q5AFHpuh3l6W6J4xnGFao4k5ITZEF3D9XAspHjj2gIm9gf4s3u0Di01CJ
         a6L26ztHgl+T5/dHQL9ZKhOd5fmXUpDAWKkDq6ONWtLnJnMONs1fnBMZou68MjSldfAe
         KUCv5Q68QANEmTxAYqnu9SWGRsrNaYD3TX/bBBKA/oZhR34QS9H3GWC6NYYCKS22AXoX
         jIOI0/DaylKmUiXZMhv1cM5W3fqqR7LkiJJLvEj/qOqUdM3O3Cl6NIKe5z91yqGLKqNH
         6q0Q==
X-Gm-Message-State: ACgBeo1xhiOjcIsvnb1ehYykrCP9Sm/nN/m1ZMc0AE/4k0dtsy+cZCQT
        Ob8QaO+bN/QlzGHeO5773X10ZL7vsfMx/gez5P0klUYky6M=
X-Google-Smtp-Source: AA6agR4Ti+e3odUqIUSn4H6qK3iu5nZPhFyE9FPdB1NNNq6aGc/PcLRuKStZKO8XfDcomZx6kXiHiNDjQzUtYvohgZA=
X-Received: by 2002:a05:6638:202:b0:357:25d:8e3d with SMTP id
 e2-20020a056638020200b00357025d8e3dmr15529050jaq.315.1663088029531; Tue, 13
 Sep 2022 09:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
In-Reply-To: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 13 Sep 2022 19:53:40 +0300
Message-ID: <CAHNKnsSpxZmSgg72=gH=tocb2YsxOR4Y=d1Lj=BGb2O6k=KEeA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: wwan: t7xx: Use needed_headroom instead
 of hard_header_len
To:     Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 7:39 PM Sreehari Kancharla
<sreehari.kancharla@linux.intel.com> wrote:
> From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>
> hard_header_len is used by gro_list_prepare() but on Rx, there
> is no header so use needed_headroom instead.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
