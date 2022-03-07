Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB04D0C01
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbiCGX3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiCGX3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:29:30 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C1550E33
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 15:28:33 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id bc10so14742590qtb.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 15:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=csQ+GPOclCXQ3pU1PuTrUt8p8sL259wWZ7Rnzk5mnCU=;
        b=noo0jaS/K7u8+2GPbiawML/hW3YeiL1uGecEST0JeVyYVJWJaKUcOBSPq8pq2cuI91
         mgzcBCP930JQWsZbI3qOqvNnx9DQAFxJhnTBtmollG+IlxyVlP+kUmtbIEXem0+v1sC+
         89xKsCCW4Dma/LcytR+mwZ0WqkC3d2OEi0HqfCPEXy2PEm1HSo1VOZ9GUYOKbOaO0vIC
         NSGY9/8vjiB4GlrpKM5VnD64HR8oxJWP00wWWHlCpybl7DPlZvxzBXKSden4FD3Gd2D2
         48r5x52wDfh+ddLcmscSf6FHM+4oGj9SpJUsXVWBOW2LyTtuQGWeF5lE5UjOW3ezQkFC
         7edQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=csQ+GPOclCXQ3pU1PuTrUt8p8sL259wWZ7Rnzk5mnCU=;
        b=c1w9pGsWyYz/jb7owQrMRmSwTGOOGa3T0+9bIGv6lWQHQjCGRTfqpQLQJ0I6jP7rfF
         CEpQ3sdjtflRe85V4LQqv+Ellf9O9aa42oAM4RlZ9eE/V/SBhNZKmTaHbEwaeKz6kRX6
         UkAYZ8olwEs00pgaikErmvCMFKP+Luuzhg8zRptj7OfD0FeHT6qNMm9Z4jQu9s+zTWrk
         S9ttqOfjI31H8Rbe3GT0F6w4CS2ej3S2apfBs/EaVQnOt7hjaRiQnUkDlafA/YSSpIsO
         sZffjaNU2h+2iJ0LhKd23Nw2q1Dig7F1Ji/wzsVVLo2gne3m+tC2YBRNW+WSyz8cIcom
         /zvw==
X-Gm-Message-State: AOAM532P6Nl6b7d5RxtcpRBZ8gE1qE5GPjzoRpmgOlWQt8wG8VaQ5bdW
        j6pgyOs30x54gsHUfKsyALEyCbir4fA=
X-Google-Smtp-Source: ABdhPJycNLI/UIKh+Ad29JexWwbf33yLyPG2x0rm7AUYLgkAygJf0no8/hzdu+KbF+Sctb5voZZRew==
X-Received: by 2002:a05:622a:50e:b0:2df:f30e:3fd2 with SMTP id l14-20020a05622a050e00b002dff30e3fd2mr11263321qtx.558.1646695713055;
        Mon, 07 Mar 2022 15:28:33 -0800 (PST)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id w145-20020a376297000000b00648c6da33d9sm6809969qkb.63.2022.03.07.15.28.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 15:28:32 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2dc242a79beso172768797b3.8
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 15:28:32 -0800 (PST)
X-Received: by 2002:a0d:e288:0:b0:2db:f50a:9d10 with SMTP id
 l130-20020a0de288000000b002dbf50a9d10mr10600121ywe.419.1646695711609; Mon, 07
 Mar 2022 15:28:31 -0800 (PST)
MIME-Version: 1.0
References: <20220307223126.djzvg44v2o2jkjsx@begin>
In-Reply-To: <20220307223126.djzvg44v2o2jkjsx@begin>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Mar 2022 18:27:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTSewYr+dXBzUVSMuwo3p39TvwozUAJ0MHMnxPUozxxwcnA@mail.gmail.com>
Message-ID: <CA+FuTSewYr+dXBzUVSMuwo3p39TvwozUAJ0MHMnxPUozxxwcnA@mail.gmail.com>
Subject: Re: [PATCHv2] SO_ZEROCOPY should return -EOPNOTSUPP rather than -ENOTSUPP
To:     Samuel Thibault <samuel.thibault@labri.fr>, davem@davemloft.net,
        kuba@kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
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

On Mon, Mar 7, 2022 at 5:31 PM Samuel Thibault <samuel.thibault@labri.fr> wrote:
>
> ENOTSUPP is documented as "should never be seen by user programs",
> and thus not exposed in <errno.h>, and thus applications cannot safely
> check against it (they get "Unknown error 524" as strerror). We should
> rather return the well-known -EOPNOTSUPP.
>
> This is similar to 2230a7ef5198 ("drop_monitor: Use correct error
> code") and 4a5cdc604b9c ("net/tls: Fix return values to avoid
> ENOTSUPP"), which did not seem to cause problems.
>
> Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>

Acked-by: Willem de Bruijn <willemb@google.com>

From what I can tell, the first of the two referenced patches went to
net-next, the second one to net and stable. I would suggest only
net-next for this. Else, we should also add a Fixes tag.

Small nit, for future patches: preferred syntax is commit $SHA1
("subject"), including the commit keyword.
