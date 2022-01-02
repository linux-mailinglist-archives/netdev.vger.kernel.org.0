Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6787D4829F9
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiABGMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiABGMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:12:41 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310F6C061401
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:12:41 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id x7so68557079lfu.8
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sr+ER9IX2/B4nV8iN0lne0ja+h9XjRKALDUv4gsdEq8=;
        b=a0zrYiQe6oy2feBrswwh0622limRL8L7ivluVKKkAvSCnDKBrEMA2KHZDIplyDo3nH
         HVjqzGWU6UiBa45tcD0T0SRbXUGfVlkWgBX/7nNRCJuifEMonhYV77ifpVDUQdzQ5FY7
         0RuHKAj2o1/K9YjPc7uF8EL5RNzUcIk9vB5PHwbyZ7jWSvcB6VrjZCrbluAy5O8m85uX
         /HRcWgfkOSSzaiazBY5p91VfB2ZjbvRjKfcsdk6vfq983l8DQJ4vej1FO1ZuA+85uXOE
         0hO0ZZEzvBwWkPPyXClhLDWUzl5bLw9pbTnvYI87iUmL9M/crRFNAwrEFcv23zRPBsJZ
         j+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sr+ER9IX2/B4nV8iN0lne0ja+h9XjRKALDUv4gsdEq8=;
        b=YlZskULX4GjIERdbw7U2eSKuWBK0COH4TSUft16W+DOvZyg9q+RQknFEyu6BxsV0Ws
         koCbNme4AUYbVOxCcE5B5HBfck20a+A/ORyfjKHjBCPZv0NcH5h2xRSim5xnp/WxCtzd
         oNv7dNOPUuVFE8iB0fkEMDlX58Ag1RPmopV7Y9cTCfIemajfkMAToe9xtSImwHjj4EdU
         nj9Kw7SRsr1UQMZU8S2LeE+0xYfSiHWxSbMbuRrdarCkVARHYxYkpM+zrYGuVCIeEtZU
         wvVmTx9bwj8yjK2y59rvLdTqDvTgGRPXHTZj1XH6q5bxoW5Wf0a20vxbC9OPjV51DCje
         ZYGA==
X-Gm-Message-State: AOAM530oUuwwm97MP7lxrUkou+jIqoBhHAb5p2VgkR3H8iXYpZKdW1FD
        +ttOgo2WcvMR5EWK4Hr4EsUXLTwOwoHcdMXStixUNA==
X-Google-Smtp-Source: ABdhPJzvbEB90BzJsMRsT8Mkiyxl66oHOHfkYlf+Fq2EUSQOhlCFCxWcoOsHAFCvQkLP/uzBaJhFhCLO79HXhJE06ms=
X-Received: by 2002:ac2:5445:: with SMTP id d5mr37492687lfn.349.1641103959525;
 Sat, 01 Jan 2022 22:12:39 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-26-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-26-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:12:27 +0100
Message-ID: <CACRpkdaNcQD64-zvV1kcDk97mBP8Ys+eVERi0Ozzj0_6r3M7MQ@mail.gmail.com>
Subject: Re: [PATCH 25/34] brcmfmac: cfg80211: Add support for PMKID_V3 operations
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 4:39 PM Hector Martin <marcan@marcan.st> wrote:

> Add support for the new PMKID_V3 API, which allows performing PMKID
> mutations individually, instead of requiring the driver to keep track of
> the full list. This new API is required by at least BCM4387.
>
> Note that PMKID_V2 is not implemented yet.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
