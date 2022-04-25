Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC38A50E07B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 14:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbiDYMkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 08:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiDYMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 08:40:23 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B88C7523A;
        Mon, 25 Apr 2022 05:37:20 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x17so25909053lfa.10;
        Mon, 25 Apr 2022 05:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5olLS3ZJ99CLe4NAf+jzCADAttCs9uSn/beSzLiCEm0=;
        b=kICmZBJ0a+2D4Ariynhu2BaTDqRMGB5pOeYi8EAOznoJokZ4e2HGRZj0gzzTTWJ3G5
         mCtt0EkbIX9SPcggnqs/OdvAX6di3z/jBfLxPExt4O8R80JuHjdN4+EDkx7dpndMYite
         1XKueOHi7tzuXYcUPB+BStPEO8FzlQI1Nm2VirHM1WkMHB8K8eAa6uXDJkEpLTOTpukB
         aFWEYTegV88CyOAXpPw4iC/tPT6JEMoSyWTa9Py6q+TGHFHseOZ2O6zvEMEjEdyLJ3bq
         iU4HtpWAETj3PNiYY0UGDilaEWzXWdBQBbZCp2Q7RVHWdL1OmaHzxuCloAdiAncwFVuq
         iV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5olLS3ZJ99CLe4NAf+jzCADAttCs9uSn/beSzLiCEm0=;
        b=ID047I+qsSqn16TIAPkxUe8Tia1kvY21fnxZbByVJObvVeRHnYOLRYFJ8QXufmPY7t
         6Y3TO/hB5AbxEgN54DP+VUFhinZoR3UPRfmJhuSBHrbnsGSpHEakbb0k2qMLCWP1+3ii
         qXQsArkXbBKvoP3Er5RfKRseOR3BqJBpBnpaDVSuOWpT5b6iYlsgtjNMVdlmVo0k1uBI
         ZVy+eVdI724r8+Bdnl1VAAzcoxdeTX5NmXlh27hm/lq92xa1PN6FSHq5FQgjrPa3AZY7
         jIYhYfn95koBT6x7otWEcRgeEzDaIp3GDyoBEqsgfRu3JxnVsqhhklVOb6TJP1ylIOMb
         IvdA==
X-Gm-Message-State: AOAM530i6Z6iO/BwuT7LxRk8HoOqrwZj1BFaMb/IIC9uTrryge3RZS3G
        SFxaLrrA/xQ9QmLuxR9NyPGYVqX04WxpMogwD4g=
X-Google-Smtp-Source: ABdhPJy1MDsXwtESZTScv4F2HnxLQR/mVRHFKH1qUojnvhT8PWVewsxF0Wq4pERM2CFcQzeRIg58f09iaZETLZS4rgI=
X-Received: by 2002:a05:6512:1085:b0:472:1013:aac7 with SMTP id
 j5-20020a056512108500b004721013aac7mr844201lfg.463.1650890238444; Mon, 25 Apr
 2022 05:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 25 Apr 2022 08:37:07 -0400
Message-ID: <CAB_54W4_oDrfNFLrRMnOBqE=yxTGh97OK94Fiip1FovbHNaKBQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] ieee802154: Better Tx error handling
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Apr 7, 2022 at 6:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The idea here is to provide a fully synchronous Tx API and also be able
> to be sure that a transfer has finished. This will be used later by
> another series. However, while working on this task, it appeared
> necessary to first rework the way MLME errors were (not) propagated to
> the upper layers. This small series tries to tackle exactly that, before
> introducing the synchronous API.
>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks!

- Alex
