Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E66416AD
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiLCM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 07:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLCM2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 07:28:30 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE481CFC4;
        Sat,  3 Dec 2022 04:28:29 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id fu10so46397qtb.0;
        Sat, 03 Dec 2022 04:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RF3ZWqhHQIklzTK83GUliMYJndHCzHZBEbNUYH/QgQE=;
        b=hXpUXQQIEnDwmKjz3tn/JHSgz9IxaQRjLHzgFXT0CJsFCLVMYd3+R8kNQ/zbyPTS5G
         LDL9Mw/ubGH77oMPRB3MEqRx5Ko3h5rCR5frnAi0YJlSI7Klaf1W4hgMV+emkjkDIbjR
         5W76Y4k9iRPf/R9dciePhRz7cJu7Er9BAhvIBqXXWxyBisQlPNqxEqWTI6olcaIx8DT1
         yA3E49Ed5Lf16JHp/uZcV9uK42YX52xZavAF3oBWBpoDJgfRyLONhXHYTAlEjWG1g+CB
         /toIwLRmi6iXJ9jhKSL5qVtA5S7h0En6l8oTzIjVQE4ZhVqsOg8nqDr/UDYSTHCILwT8
         l0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RF3ZWqhHQIklzTK83GUliMYJndHCzHZBEbNUYH/QgQE=;
        b=diXc6PauNn1FzFYz3NG2bTIQSyUN2ZusA1SuTajXikUisTTfCsXbQLpoa9gIg1f3Zf
         +QiTTIALSEHDgbWttjN56xAOdK5pTW9wBD9mNWJuLzXKvTI0jyeZHOzVQ8OUyrYhrmNL
         PPSfYYmxKkKaqINWKE+FUPqcI45y7IISQ8zg9NynSPqpiySvhTxiipvFActTCBaBgoP3
         7V1jd789XZSnj7DS2gW/0G7kdGt7W2Z8NIrza7bpVN4RZJTeJ64fX96osT+aUIgt2ZUj
         q1UqW4002f3VjFp39eJR3yyYLas3a2VVCYjgjmwfKnEjuH+ub2ggGyzPzUMH0JHp+cDb
         k8ew==
X-Gm-Message-State: ANoB5pmUFvIfLgmk8DKn53UhRt8ePJY6VVU6fVG2Y4fyn8N5268yMgZ4
        wCHflvUqYjQtV7fxFynnW9T8EDzkXXtgnBzmfxg=
X-Google-Smtp-Source: AA0mqf4NPt/Spc1Ig8VW/MvuvVBQJCyzbU+MANuMhxBDD67944mizuF34t8xOE9ttNR5NEvEEc01WnQFWRBR3NJFkMg=
X-Received: by 2002:a05:622a:2489:b0:3a6:8c87:e15e with SMTP id
 cn9-20020a05622a248900b003a68c87e15emr14943702qtb.481.1670070508755; Sat, 03
 Dec 2022 04:28:28 -0800 (PST)
MIME-Version: 1.0
References: <20211015164809.22009-1-asmaa@nvidia.com> <20211015164809.22009-3-asmaa@nvidia.com>
 <CACRpkdagKTDgUYBkF3hdE69Zew22uOpN9Ojsqwc=BrKpFOehNA@mail.gmail.com>
In-Reply-To: <CACRpkdagKTDgUYBkF3hdE69Zew22uOpN9Ojsqwc=BrKpFOehNA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Dec 2022 14:27:52 +0200
Message-ID: <CAHp75VeQTPsVbEfYe6FHzE=5QKRGQuEQSbnLrTKV+Sbssm3JeQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] net: mellanox: mlxbf_gige: Replace non-standard
 interrupt handling
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        bgolaszewski@baylibre.com, davem@davemloft.net, rjw@rjwysocki.net,
        davthompson@nvidia.com
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

On Sat, Dec 3, 2022 at 12:13 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Fri, Oct 15, 2021 at 6:48 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:
>
> > Since the GPIO driver (gpio-mlxbf2.c) supports interrupt handling,
> > replace the custom routine with simple IRQ request.
> >
> > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
>
> Should this also be merged into the GPIO tree with patch 1?

Blast from the past?

-- 
With Best Regards,
Andy Shevchenko
