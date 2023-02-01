Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FFB686D50
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjBARpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjBARpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:45:20 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADF66F98
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:45:12 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id q8so13263288wmo.5
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 09:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hxqqSUt4pDBOd5S9aVcPhigYviRtY2svTGyTVozV7bI=;
        b=Q2X+MhnSF6j2SKG2ciq6UVo6uWKhLST+rC1EwS9tSi1dz09Wueii+sItZpJMCNTlF2
         gtdzUwWfVFjFQKlPgcejvX2AqGinTd60X6AaqKv+d4S8aXUfghJO16hFZp3gA21brzp0
         AX2qnCe55AlE98ooJ295rAMT1YRn6kKQNH+aSh0L4eMzohLghmTPKj2DYwRO9J1yxqyc
         0k38i2KOQ8dpT8GwziPy3mlmCZPX7gGGxlRMNCipf3iyUKDhgG7bzkmq1kzYlGYTIR2c
         v2fDyM0Wa1G1tdsNG2OXPgNve69vGcr3y5o5caZ1mC2cmrUKVbyfR62Vp0CGKeZBm/h0
         r86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxqqSUt4pDBOd5S9aVcPhigYviRtY2svTGyTVozV7bI=;
        b=vndoONyYMHYBA4+cFrbtFBT34mZ6uFyklJKQKs1XljN901V5+y+z7Ko4W6d4TOBjpL
         tPQ3S+W35U7AJDSvAHIL1QceQ2aGeUKFTLhAmN1eeWF0cNf63UbVgN9KX4g1rqH+OLdq
         rZngun9u4xaAesSQv7upiqmBG/2d2m6v7LUn1oTaRKRS6vWWZiv3Eivhzyg0OTWuxzJx
         zwEqKLW2dLFlYUNR1VfDtvN3pyuL7GSsRNEZQ/VkNp39MYK3mTKWbiR8Ch7Bt3Bp2Tlk
         Jh+MH7yg071T9KRXl/l4bgg2kap/Vets9EtlzlxXY1d/HBFORSAwat2sE9qCSQzYbv50
         l9Qg==
X-Gm-Message-State: AO0yUKVS/LVFvqMn6DIsIcrCjZCHtlBixjXsM/KmP/qjF65BP54ISZBF
        TyHHdD9JlPzcdnN45c9ZroErMFe6SH6U77XsN6Vu6YCFAWsdzqfC
X-Google-Smtp-Source: AK7set8kxSV9QUXc5Kg/QgSCA84NoTTurhAUEFjhhgN6G/Bxz6vzQs8LLanBm+cPoa34tT/KpaGZfYqWr3GKfb3rfHA=
X-Received: by 2002:a05:600c:4141:b0:3dc:8dfe:c672 with SMTP id
 h1-20020a05600c414100b003dc8dfec672mr207114wmm.66.1675273511273; Wed, 01 Feb
 2023 09:45:11 -0800 (PST)
MIME-Version: 1.0
References: <20230131163329.213361-1-jeroendb@google.com> <20230131215253.0d480afe@kernel.org>
In-Reply-To: <20230131215253.0d480afe@kernel.org>
From:   Jeroen de Borst <jeroendb@google.com>
Date:   Wed, 1 Feb 2023 09:44:59 -0800
Message-ID: <CAErkTsTYVb4ea_BDjpLxW_FBrjjn33cHG4j5fgbMDf59Yk_4mw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] gve: Introduce a way to disable queue formats.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, I mis-interpreted your comment. Will document it there in v4.


On Tue, Jan 31, 2023 at 9:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 Jan 2023 08:33:29 -0800 Jeroen de Borst wrote:
> > Changed in v2:
> > - Documented queue formats and addressed nits.
>
> You did? I don't see... I was expecting changes to:
>
> Documentation/networking/device_drivers/ethernet/google/gve.rst
>
> Also clang with W=1 now says:
>
> include/linux/fortify-string.h:522:4: warning: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>                         __read_overflow2_field(q_size_field, size);
>                         ^
>
> dunno if that's legit.
