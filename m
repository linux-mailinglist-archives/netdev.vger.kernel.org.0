Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4893F5AA9C4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiIBISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbiIBISs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:18:48 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49A6BFC5F;
        Fri,  2 Sep 2022 01:18:47 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3321c2a8d4cso9620427b3.5;
        Fri, 02 Sep 2022 01:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gmZKFJ5DMpy2RtHQdvY/1Lz7MZcgCDE8xgXM76Z0hg8=;
        b=TQwul/xynxOeTE2Cigzd4d5AD9wMsm82TCSafmjN5d97B24VX3phFt2JMEa8SzJcGU
         9nzB2lMX1CVCOhvDaA8xcGtq9XM4BeBtLI3/H0run1TeiRUbgRZkhCv1tOpRvBjCv9Q+
         tB3hEaHVF9AKaMd1fm3LeEpeld5sP44RfJAQ83Qma+k+GyLvckpk/1xNdjgIGYgRV3yv
         y1+DXG317UaAjpk9gx6aUm4f/60MF1YMtqSLpjVNWKIzI5myTAUB9HXIkiOPJO34J+Se
         z2Yu/OoKQKRORWd14m5Mkpa1kDWUy1VukWJjetL9Sra3ljpWjc5yH+WfkhZzaA9lUJZS
         IZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gmZKFJ5DMpy2RtHQdvY/1Lz7MZcgCDE8xgXM76Z0hg8=;
        b=pvj21ddtV641gYop4os407gxJE1mzmyqUkV1cAuuLOZy+i5AdHzuYcqmQSoLOae2HG
         tdYb7dWlLGsmCsxfzFdAYiyhpxdjvlhEkR10KPHHbu/mojHvicyQQXlAKFbegT1do664
         TUz6yOf5lJUh81Pa9NTXrST+4fx7qMdzSJ4rWejPJNt1FBRD/yklgjinHHah2aDx+Lba
         WxOmQ5fbvhbvZGmzzOk5zD9ctFV5ZgLtJRgUehhEzkVWiIM1mmHDubG5tzdoD26nagH3
         N9ab8yFqhh/mHzKZCObx3PIxyeZ4jP4+W0wLkepbN7WQRA4EpOWjctyB3GmoGaLSzmeh
         fQ+g==
X-Gm-Message-State: ACgBeo0koBuIoW+iULgxIcF1NsBNTHrCFvQpGoWrYclgbTHRLQKmGMf1
        Wr6+UaF9W41i33740I/SK5NAbQkWqy5i0olyQWA=
X-Google-Smtp-Source: AA6agR675WB/EvALDcNCZ4yiWt5M/LckeJaBM1B3dqzAOKYYKlAo9ZjTJhtz5VZWhl0rGHc6NlXGSDHvFAohyp8Ed6o=
X-Received: by 2002:a0d:c942:0:b0:337:5cf9:1c04 with SMTP id
 l63-20020a0dc942000000b003375cf91c04mr26790287ywd.39.1662106726933; Fri, 02
 Sep 2022 01:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220902030620.2737091-1-kuba@kernel.org>
In-Reply-To: <20220902030620.2737091-1-kuba@kernel.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 2 Sep 2022 09:18:11 +0100
Message-ID: <CADVatmOcuzx7RZHDG+7P31hfscpsVOc2wNS6DvEZifCpntRCsw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        paul@paul-moore.com, linux-wpan@vger.kernel.org
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

On Fri, Sep 2, 2022 at 4:06 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> From: Gal Pressman <gal@nvidia.com>
>
> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
> error:
> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>  2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                   NL802154_CMD_SET_CCA_ED_LEVEL
>
> Unhide the experimental commands, having them defined in an enum
> makes no difference.
>
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Fixes the build for me.

Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>


-- 
Regards
Sudip
