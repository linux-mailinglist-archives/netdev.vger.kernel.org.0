Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005A751F6DC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiEIIMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiEIIIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:08:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED37E1C12D8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 01:04:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d22so13110494plr.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 01:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zd4aF0rovRZTBGwlOQmd71JhMoJJjwfPdWdSeArtrCs=;
        b=PucSv8ePVvdl/sJWlBjiSxE6R2FPWfQqAhV85oW1QOk0RHwKb31a69TSXFwuf4831f
         RE+oWZBkU/GNX8suYkVdboCM09YzpQ/REWjgLM/xnHo5PY0s8G0Sz+f+Y4zWfCRfP856
         XwghDUzXsjSPvVe2Trl7migiRp6aHlBFrL/1LmuVzSwQClbqUwXI+KPxuLE7zntFpohr
         xRqyNk0Og2M5lZqF9Mwyom5arT9ZO0pGhgGE7Sz6/OuoRZVjrL/dhPDGpcxoVx/EGdwq
         hbm40SYrh3IwPQ1v5FA8V+Bji6LywI3Ua+az5eLfPSKJXRMkTb658JhQcZEXWoAyS/hG
         /jtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zd4aF0rovRZTBGwlOQmd71JhMoJJjwfPdWdSeArtrCs=;
        b=1HwCgCGQY7gy7KmU30sxxcc77Q3HNV+gO92Xjb8SO0W7hrKaLGhbwKIq3O4CJv/+ci
         eInSIla5LAUOK0uq+/M0u7zHWko9URfE7AuI8mvuZ0t3eqYcsMHVBYUw3GhmpKdd5VNT
         F7O5zJRUrKMQmI8uS1MZhD8ZG5Xitbv7HB9ETExTBF3O2ObPbHGnNl/kq4kYI0Oiod+0
         0F1tZBBajlQJe1E2rvUSVxCZn/R7MbEJFkKN2Xheh33ImjQxGQzLXPIagHxztnEuxKkg
         fE0oexKk+4bDx06SHchOF2vOqWtVKaNCNG7JD/PIv94fxzvNpS8XjIjMxc5B2tJt5iGN
         Vwcw==
X-Gm-Message-State: AOAM532GkKYHyILnb+XvLE0lPs/FwJicGo9eq/TLwLBhY+NqAFIMGL0Z
        S2bj30P3N/dL+4HS0A5Vbq2XMggriE/5jYNvkO0=
X-Google-Smtp-Source: ABdhPJwaoPLmGySJqu6Xx+FNfmCueT5XmhB9QtPDH2oUtVak2pzJcSvpYuQfYuio9AS4FzazLQhBDbY1qMCBSgSP1qA=
X-Received: by 2002:a17:902:d145:b0:15e:d1a8:7f33 with SMTP id
 t5-20020a170902d14500b0015ed1a87f33mr15320256plt.66.1652083450518; Mon, 09
 May 2022 01:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220508224848.2384723-1-hauke@hauke-m.de> <20220508224848.2384723-3-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-3-hauke@hauke-m.de>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 9 May 2022 05:03:59 -0300
Message-ID: <CAJq09z5GSQzhVZip56itiOgW_LAyEEkXhzy=3AdryAT33hAv4g@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: dsa: realtek: rtl8365mb: Get chip option
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
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

> Read the option register in addition to the other registers to identify
> the chip. The SGMII initialization is different for the different chip
> options.

Is it possible to have two different chip models that share the same
chip ip and version but differ only in the option?
If that is true and the driver still wishes to print the correct model
name, we should keep track of each option value for each supported
chip, just like we already do with id/version.
If not, I don't believe we need to print that out during probe because
it would be just a derived property from chip id/model.

Regards,

Luiz
