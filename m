Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A462BA537
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgKTIzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTIzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:55:40 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A36C0613CF;
        Fri, 20 Nov 2020 00:55:40 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u19so12368618lfr.7;
        Fri, 20 Nov 2020 00:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eCE5S3AtPfjPlYA0YjZN8U5ZXZvn/LY2xX90AL/N/n4=;
        b=k2cWikdNzhvRX1o1rxZQ/r3PGgWpEY+B7ESKW2u8t1R8t6f9mVujNibnb0xM6ing7A
         KfwsHX+X6R14I3BFEZYAn2U7cIM6uOP4q9b31bn1BIYmLL7YkACHogP7alLylVznwrXp
         BPAn6eXWw7S6VzXwesvbnJDVcNih5Yjsbj8bvdMWMFLvdh/L6RTLse/hcRaYliYD7n9b
         2XaTSQKoJu7iUAzDApDSnX1PIvTJO5bd0jYPXkLkakYkB5bXMdNe+GiPa25QZqpWJJ9Q
         WrGRsKc/OarUCS+WnMWlQxNUU9Puo5bdGbrV+FrGgFJIseSpXYTdgvJvH7jp82hq3rJ3
         Vj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eCE5S3AtPfjPlYA0YjZN8U5ZXZvn/LY2xX90AL/N/n4=;
        b=hiXSAIl6GON8ioS+qTAGDJUkDZCvNkfeuSpruLXsZtf0HF5JrgsPX0KVJIzqQh7JRT
         eeHCKWF/g8LINcL+7LyQFN3d12mtydouxBgMWR+ijs6jRxe/ST87BIBkeaQNfheH7WCb
         MPgV6K71pOQGL6gWqo1gXj6xpMy0ItxxXg89fjpY53MM1sy53O/TusG9PemizW/Xv8wa
         IRso2X7KUEGZDiVXmWScmxuVV0Ol85Kmmlk16WHatSSMnURq5NHccumElC58F0er8nM8
         vBWHBpgE+S6yluSn7tkChhRziV+J7ZvGm3a3zIugXBZSGCVQsjZyeYTHLwqygH0Iz2O+
         SnnA==
X-Gm-Message-State: AOAM533/26bmWBL2NWikCYZnjZE6W89pGNNgVDB2C1F3GBsXPE9hyUtl
        iFyi9DnJcRuhpJNnldb5zLFhFHunXGHEpa+/mEc=
X-Google-Smtp-Source: ABdhPJyhgrajddGaPcfQLxvzIx4y0UvcooH+ce7MoDObk9cBX4B6NGc1idbwywPDrlRxQWjGIn5r/eswg6fHVuWIx00=
X-Received: by 2002:a05:6512:20c:: with SMTP id a12mr7496565lfo.219.1605862538701;
 Fri, 20 Nov 2020 00:55:38 -0800 (PST)
MIME-Version: 1.0
References: <CANL0fFQqsGU01Z8iEhznDLQjw5huayarNoqbJ8Nikujs0r+ecQ@mail.gmail.com>
 <6b71718c405541d681f4d8b045a66a79ade0dd4f.camel@intel.com>
In-Reply-To: <6b71718c405541d681f4d8b045a66a79ade0dd4f.camel@intel.com>
From:   Gonsolo <gonsolo@gmail.com>
Date:   Fri, 20 Nov 2020 09:55:27 +0100
Message-ID: <CANL0fFQeh0SdUd_v98X-YJewZRAOmiaKaCLO+7FsoZBO=SENvQ@mail.gmail.com>
Subject: Kernel warning "TX on unused queue" for iwlwifi on 7260 with kernel 5.10-rc2
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
Cc:     "Damary, Guy" <guy.damary@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "longman@redhat.com" <longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output of lspci -nn:

02:00.0 Network controller [0280]: Intel Corporation Wireless 7260
[8086:08b1] (rev 73)

> Guy, can you help with this one? I believe there is a bugzilla issue
> for this already...

I'd like to know this too.

-- 
g
