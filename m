Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657621ECBA1
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgFCIeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:34:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF36AC05BD43
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 01:34:06 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b6so1665416ljj.1
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 01:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqkugSyvn7uDkkJ4CNwiEX+0q7DhIhB9TOpatQyMMrM=;
        b=bnA4a26iW3R7E2NMkvvZwjLVoEoF1guFTv4LP91pPI+gYNlVF6tQx5W8N4ZSRutP6r
         9uVBDk7511J/ZTpbmxg1I5mKENBC0EWZphJY6zrwFM9j76pksBK4HGLNY4RCJed9zq2j
         5FE5MOa76HxTSHcs6G40520gMsCU2DIFN9kTUzW2NeyAU62FfzyLoBa3nmXqb8DvhZmN
         85WkhjdH1jGylY0D6yzWnMILXb0mv04f5btSKzD7AfnrUoAOX1kDNMItSpT/H4Jo0d8K
         +MoBjeeuVKDK4XtSCiKQ3K3VJ6hgnakoHFTjC8HojoVRgrqMB7SXOOsXwMD6E994GIyQ
         VeKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqkugSyvn7uDkkJ4CNwiEX+0q7DhIhB9TOpatQyMMrM=;
        b=fLavkqHQaISfPv7kHt7itlGJMFmczsFUbn9jYjbgwxkD6Do4UDSxGt+ijNlZd18WgJ
         htj+DNkI5+D4kVqv4WkIt55ZhA8l1h3B9q+B1lhPoghFdbLHK6J660WeRCRuP1XDTYHU
         o3dJj1z+JC6QpcS9/BnUlI/I9iiIr+Kw7y2ae6Pv4qJgunTxz/WoUjhQrdCiK1bC+w7w
         6gxcJE9symUk3dMm3qFpQKFitObudLy/Rb2sydIOVkkggH4tN3A1pKPDDAarKJiZxDTf
         tklbvCwsR3ZLcuoE19fLXmENG6QJSZIysK127tl6dHlG8A1Geb2uypQQuFbwmuabcs40
         K3lg==
X-Gm-Message-State: AOAM533Ngrf/WzxmmnLccEHjWv0UXVXQfTA+FYya74cdb4TeP8o5lxuS
        MCc96qGetEFgSkpTskUB+SsU8r4nj95CXNicKTB8qA==
X-Google-Smtp-Source: ABdhPJwz3DTeKmzh5WgZSttGoW7UIBQhO5pturhiP8xi/wDFDSn/h7GSYYMIgFUqw6I13W1tlnzjItvykGtrAmOXm1k=
X-Received: by 2002:a05:651c:112e:: with SMTP id e14mr1417274ljo.338.1591173245209;
 Wed, 03 Jun 2020 01:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200602205456.2392024-5-linus.walleij@linaro.org> <CALW65jZT+_qoAtJx4ABKcWGS2V7CQvhwMGF1=acQZHhzHMzhbg@mail.gmail.com>
In-Reply-To: <CALW65jZT+_qoAtJx4ABKcWGS2V7CQvhwMGF1=acQZHhzHMzhbg@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 3 Jun 2020 10:33:54 +0200
Message-ID: <CACRpkdaJjDRJ7gqfrbcJoKDOhO=Pgw0K8j8qDUveGJsukzRfuA@mail.gmail.com>
Subject: Re: [net-next PATCH 5/5] net: dsa: rtl8366: Use top VLANs for default
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 4:19 AM DENG Qingfang <dqfext@gmail.com> wrote:

> RTL8366RB has full 4K vlan entry but you have to enable it manually.
> https://github.com/openwrt/openwrt/blob/e73c61a978c56d41a2cdae4b5a2ca660aec4931b/target/linux/generic/files/drivers/net/phy/rtl8366rb.c#L43

Yep fixing up the 4K VLAN support is on my (slowly processed) TODO.
I will do that with a separate series later.

Thanks!
Linus Walleij
