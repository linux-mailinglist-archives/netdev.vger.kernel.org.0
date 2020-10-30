Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2D29F967
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgJ3AEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3AEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:04:32 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D05C0613CF;
        Thu, 29 Oct 2020 17:04:31 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n11so4084220ota.2;
        Thu, 29 Oct 2020 17:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6u0rxoMW5EgguiQ1BaRLL9TYUXH249yr9CJfUjtzD94=;
        b=Xw6j/s9cIdzpnn1yfTS9n2GAwVVoIxCPXzD7SVtNNx7d7Izi1qA4ao0++Vo+eQEHfN
         dOJxPn8vyDcTC3+ogjmO2uAGqcUAvfQaCzoBt9fzGVlF0WDG2DrBzEcx0FbBrdmZjvtu
         uuxkquQ0IsBfGA8OGlYaTlXQ5Gs323CxBQG1N/sC0zcN/qJ2DqUXEJjW7G0dN+PWRqYJ
         Ph0MdiXwDdHz9Ycq0ZrSnbiQkp4hJhrsao3v/no2cZJVB8Y5Sv539uFeYdzrzAklMarf
         FUwAkLvBBxsmPcN6eigiW8+Vg3n97EIw/R0wWy2gKLuiZ0EbMJGzGZgsu4zAZA+JBbCj
         XCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6u0rxoMW5EgguiQ1BaRLL9TYUXH249yr9CJfUjtzD94=;
        b=pGNx+J04S1fzxGxjJehW6FjiPROYisnrU/kYkyXiL6+7WA17NrHsswEExsFvXIye/S
         BzLpKGJDUHv7GWIjdXtUoexPuyIWyveumQA/Tgi2qICyXTt/qr+6s9vlCH/JkcMUdyKG
         vxKVO5MoBNpCgn4T/8T8/jYZjOpeGrK4Gul8lYMDRx1G2QrF9bf/5zCbBN462YYmcee+
         VvKRro0QxS4lB4JHd/WNqMkAnu28HHTzSGoLM1Gk6TZNNRfHtGmX1PSiB+ADhPLj5Lvi
         y96CoIQf1gJrn6eSudjxmEes6WqvkoZA7Ur8P/c0lgm7sqyVou7Bbm1h+/3df3IOrd0m
         SgmQ==
X-Gm-Message-State: AOAM532Sn8bYsASi4ZyVDEvFROmtcels5xgRGq3FDNaQscledelVE/60
        Ex92741y3KIU8zPx03FaMdsbBPjNbKtJtHd35/Q=
X-Google-Smtp-Source: ABdhPJy674YLL3RLhCFMc9BBY9y/+nTgTZTAGU+qhGrdlTG6Zi+XRuQpC13GUd7wn+9akVH8B4bnOK3gY6QcO9Hl0+k=
X-Received: by 2002:a05:6830:134c:: with SMTP id r12mr4975499otq.240.1604016269969;
 Thu, 29 Oct 2020 17:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com>
 <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
 <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com> <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com>
In-Reply-To: <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 29 Oct 2020 17:04:18 -0700
Message-ID: <CABBYNZ+0LW0sOPPe+QHWLn7XXdAjqKB3Prm21SyUQLeQqW=StA@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Daniel Winkler <danielwinkler@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, Oct 29, 2020 at 3:25 PM Daniel Winkler <danielwinkler@google.com> wrote:
>
> Hi Luiz,
>
> Thank you for the feedback regarding mgmt-tester. I intended to use
> the tool, but found that it had a very high rate of test failure even
> before I started adding new tests. If you have a strong preference for
> its use, I can look into it again but it may take some time. These
> changes were tested with manual and automated functional testing on
> our end.
>
> Please let me know your thoughts.

Total: 406, Passed: 358 (88.2%), Failed: 43, Not Run: 5

Looks like there are some 43 tests failing, we will need to fix these
but it should prevent us to add new ones as well, you can use -p to
filter what tests to run if you want to avoid these for now.
