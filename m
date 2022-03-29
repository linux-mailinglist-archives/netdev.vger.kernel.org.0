Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFD54EB4CA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiC2Unu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 16:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiC2Unt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 16:43:49 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676B9B7C4D;
        Tue, 29 Mar 2022 13:42:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p15so32350637lfk.8;
        Tue, 29 Mar 2022 13:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzi1FzomdAULOyBXwNP7g2Uh52fOnO3V72+UwxY5uuQ=;
        b=S+Goxo4lVfLQQ3lRg3nm/Y6v/WqihXvE9F4OUYyggVB9j3uTMS5917y17hUsgAiw5e
         xjj8GPg2AONq5x7Yd/SeXn30SkpCczKlVRU74Zm/VrKXyKdluHa0woq/ausGBEDJ6mCc
         WK0AF0jxb/JIa9XYZ5pzCEf8LWwFEPXTMRlSDkzPUKgP1E8dckVn3jwypN+cGydQ2eAQ
         TdMPR66XL2SJ/4WgHHpLrS5i6mPp/BXXFrz3k8qEhoeKpnGKXDv1c8FA8q8uLg2yRDMn
         ppH1vs293L3s4rHfUNYc6WyCrLZ0EtKsGs+C8WtzoHeOPzaOoLsHksdL+YU/Q5msJyOW
         Xzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzi1FzomdAULOyBXwNP7g2Uh52fOnO3V72+UwxY5uuQ=;
        b=SG5Sy/Mm+jcHSyJer6sDM4gI5Lb1BCkGAh/UeXbBJrlUZnjRDbLcdMSb8WaRI3nBsN
         AsJt6Xgc3+Ag3lFRhmt9R03ycHIZu2+cTGUzUP/enMRcHY6K8qy71gstaKvWDnEzm6zG
         LuMjXEaKLzoRvdLGX/SeME8S8ORrnQe8wEfwurxMHQPbimSOWcS+KRoxDsOlxOStvW3M
         JIFsZ23L+TKFWia3C/Nu4YiekLNIGQvYqNle8w4hCbCgS2FOz5j3fT6McMRTgL8n219c
         BO35O1jJ4KUQjtJPH/VMiUAQA50XK6r0uVvCkjfH1Bl1DPho76tNCGLenMK0PX07I4mi
         Fa4Q==
X-Gm-Message-State: AOAM533qsSzr52Aj0md1V5tWpwWpytWJ36DKgITp6iGR76mwfa3aexJ1
        jH0hedVxc7Fbf+eyu+KIH0DtkhXDvFj4IDAVN8Y0B+Vgztk=
X-Google-Smtp-Source: ABdhPJzKvY5cYdCxPyZTEjlIBgt7Om3njHWwsRUI/2LXZgcsshdilH2GnQVgIu6UUMQwHOZvU3MFXgrOr3IlRmP6tek=
X-Received: by 2002:a05:6512:3f99:b0:447:1ef5:408a with SMTP id
 x25-20020a0565123f9900b004471ef5408amr4438505lfa.490.1648586524613; Tue, 29
 Mar 2022 13:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220325074141.17446-1-tangmeng@uniontech.com>
In-Reply-To: <20220325074141.17446-1-tangmeng@uniontech.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Tue, 29 Mar 2022 16:41:51 -0400
Message-ID: <CA++WF2NXLL4WjwyUYcBTJ9ogNAZnqZkU8KHqkvUbvE3k=RYroA@mail.gmail.com>
Subject: Re: [PATCH] ipw2200: Fix permissions setted by DEVICE_ATTR
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     kvalo@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 25 Mar 2022 at 03:42, Meng Tang <tangmeng@uniontech.com> wrote:
>
> Because xcode_version and rtc only implement the show function
> and do not provide the store function, so ucode_version and rtc
> only need the read permission, not need the write permission more.
>
> So, remove the write permission from xcode_version and rtc.
>
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Looks fine, thanks!

Stanislav.
