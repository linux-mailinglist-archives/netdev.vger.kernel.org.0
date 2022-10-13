Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0305FE0CE
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiJMSPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiJMSMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:12:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8318A4DB0B;
        Thu, 13 Oct 2022 11:08:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so2567929pjl.3;
        Thu, 13 Oct 2022 11:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eg/F5GQr7kLj5OgnGhnCri7y548zIFtiHsw90JMrvRI=;
        b=ZaJTZ+0JKI/fN8Q3sS6lyGzFzxvqwq4PFzfu5opiB62O095/RwOk8DhHgnwoEGc/3O
         Rk2qJZHApobUN5JXSttpCFLuKEKbqPhhxRJye+4dovWI78ssqBnioDUZxjsbDrE+G/Pe
         +FCjxIhwcJFqByll/Ej4Ol9G9f5jDDw7yBav49sbnauiis5ggDXIvMvsAKupui2nuFtE
         rVrAdGCRojV6mIPelm4NaC6Tlz8cc6/Z7uCf481MnUBtbDpNraeZcV0CI+lpshamDrI7
         U9wPcioqm6WtYFQq5YG3jlnnmEhm0X5uZxZ9vvp4yDVPAEckXEBakeJt66IntJmSrR6n
         +e1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eg/F5GQr7kLj5OgnGhnCri7y548zIFtiHsw90JMrvRI=;
        b=rogm6WBHYpiMwTik53dOmcCI5j0DVqb7og+OjkfAojgaj7/CT8CIUQsG7aX2LjCYFZ
         jbypLDlvQ6p1DSH34DKp5CEo13Hav2+PMvwI/2bftNPGg0unapG8FD4tAWKmJdZTDJGd
         w+1l1CjWH4KdNTDgm+u6XF7uw89Lsdf9hJKvEWMzfX8KxBHin/VbNPeCmCgx2qaP6y7q
         aT6BsK+oUxj98K2iXqOsOhhReBUNKjR8HDj9TeGTDs7Qzb8DueR7qW+iRotPe6d7NSRX
         cdoP08H1ZOUmx/ADyDT5ZzL6DcWF16P5sbkGMLt0zLSFCQeYqqmZkxrJ5Lu9h7Y1ZOcw
         0U3A==
X-Gm-Message-State: ACrzQf24qEvF7r0bzwUTRao/2n00oNxGZVQqmyFVK9rwAQ9FaDCR07FJ
        slU+P01+tzsew6+2Jvj831Wyhdjn83ZKeOOfCtzM1xLF5Uk=
X-Google-Smtp-Source: AMsMyM4Cws5OIwOAhD6dYa9EMZvHvUDm9AfOUDIbT6tlsR9FMqM+DY3DbGUDx4Z/H42gVTZpClRo75IviWihBbyWbjE=
X-Received: by 2002:a05:6102:3351:b0:3a7:9d3c:496e with SMTP id
 j17-20020a056102335100b003a79d3c496emr889921vse.56.1665683851407; Thu, 13 Oct
 2022 10:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221013163857.3086718-1-guoren@kernel.org> <CAJF2gTSu_SDGEYZxW7nfY8B=k_hkdxKy2TsK7C5v7cqM7qrKRA@mail.gmail.com>
In-Reply-To: <CAJF2gTSu_SDGEYZxW7nfY8B=k_hkdxKy2TsK7C5v7cqM7qrKRA@mail.gmail.com>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Thu, 13 Oct 2022 10:57:20 -0700
Message-ID: <CAAH8bW8FArQL=cVex=ZFOFhBC-9JvKNtdwCwjVYexe3qWehLKw@mail.gmail.com>
Subject: Re: [PATCH] net: Fixup netif_attrmask_next_and warning
To:     Guo Ren <guoren@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
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

> > Fixes: 944c417daeb6 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
>
> Sorry, the Fixes commit is 854701ba4c39.

1. it doesn't fix my commit. There's nothing to fix. It fixes net code.
2. https://lore.kernel.org/all/YznDSKbiDI99Om23@yury-laptop/t/#mf3a04206802c50ee7f5900e968aa03abdeb49c68
