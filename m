Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0368B4C0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 05:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBFEAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 23:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBFEAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 23:00:08 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C411814A;
        Sun,  5 Feb 2023 20:00:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lu11so30679895ejb.3;
        Sun, 05 Feb 2023 20:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mh5rF1NdPROcFJEX7mOyYt3nLe0Q/3bymCiO18MNNHE=;
        b=FoO88OKkh5IlcanxjJVkms1oUoNVsV315rdDSaBBcK62EZcK7Dbs1vg8FvLEkhqm2r
         9ZQfcAhJjRq1NwHrNnHosLbrpfoX1XrNlklGtU6Khg3cqxblm2jNARAqImeQI1xLcbND
         wHCZAnhlIB0vlwH4W1HWowZAfT7NVacY+nOlsvb9VMk6lV7eXeoByaiwTcCR1vQ2e8re
         LfZNra5cpZMNLeF0JJFEWgxcQGc7lZd5aCgRpwPQdrrxHnw62ZtOP4/kC4Q7t1t6m1Wy
         5ArVlpx3APWPQRoIYCsJn/aiBuWfZlSHv8i8SN9DxoIiKu8mDWfhAJmbrn1NPs+orRh5
         f3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mh5rF1NdPROcFJEX7mOyYt3nLe0Q/3bymCiO18MNNHE=;
        b=4YFTmZRq8F6IDJtkgJc3NGOyDs6f1JeWAhw6sS0s3kfdg4y1I8X2kWCxtDREHPg+lZ
         2gpbTv/vivUUQ48ZzH3lKTaVSGiyhuz/iSbhQwaXwJiLlFuW8m4KVucimKKoMDkllJTC
         29bbGV1z6pdzxcllYgBxSgUzrMlLGvR6Sf9pueX5MQSDlkPmU+/CZgiDPHGjug9GU24C
         PT6FchLd4lhag00kpZV3qXWHWF87WXhcW95ZprFqf5rCIns628zQQ8nnhM2egvaQ54ci
         aS8GXzBqjsKPx0rLuiVV8/Ci8uI6GOg6IVl0ZwHXxIowcsmRP/MTRU3B/596Ec8iOmUE
         vuyw==
X-Gm-Message-State: AO0yUKUGZITWkbtH+YJbDI7lJpUBObGfAE2u9IyhdhkOeZU24ytSoY6C
        GW8JBNEhBuihbJSbE2qpJktCKhLV2lItUSxOGsanINy6tBBUdA==
X-Google-Smtp-Source: AK7set+WQXpvxRKEXbBvfnNovCt8RMwMVEvl2w38ftAKKBiQOlpMyyX4Sux3UQr5wk4yca57N7PVZrBTu0uVU0SOb4A=
X-Received: by 2002:a17:906:6d13:b0:878:786e:8c39 with SMTP id
 m19-20020a1709066d1300b00878786e8c39mr5250608ejr.105.1675656004800; Sun, 05
 Feb 2023 20:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20230206145442.15f85e1d@canb.auug.org.au>
In-Reply-To: <20230206145442.15f85e1d@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 5 Feb 2023 19:59:53 -0800
Message-ID: <CAADnVQLrJyzJDzBxPk9s7ba41WHftrHXbWObJxF+4awp_yB_7w@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majtyka <alardam@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
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

On Sun, Feb 5, 2023 at 7:54 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the bpf-next tree, today's linux-next build (htmldocs)
> produced this warning:
>
> include/linux/netdevice.h:2381: warning: Function parameter or member 'xdp_features' not described in 'net_device'
>
> Introduced by commit
>
>   d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")

Lorenzo,
please take a look.
