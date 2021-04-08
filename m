Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E305358E07
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhDHUGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhDHUGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 16:06:16 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BAAC061762
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 13:06:01 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id s16-20020a0568301490b02901b83efc84a0so3502797otq.10
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 13:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMNaMbTulZVWFzBX43p/fXwF2BC09PvT07FCozD76VU=;
        b=wTQsR+4POzo16nXanctMMf2DY1pekJQorxnW8aa+rOq7fwPpmiyovyCeKhrHO0vpX/
         7DQdwXurJvdQj+IkuBbgJAbDaLZV/QKWsUWQLYRsShywUzf1cY0J7fqpXZL0lmoJzRAG
         tbW5zQC/IzJzksdHFL7gl5QH+uB4UrDJGlFfH9z3PrCQJb0hfA//fONntwDGLDc0NDME
         +KGGwqrXbKmD0LFcYRYXWe/AwPsCTGSRRLTLQLwM/w8gfkMwZPOSp0MYxcDObVc7nPUu
         ZazRA3CZOPqVHZOsfZH6IEC24WNXoOk60V7nBxRc1BJ6j2aKmAcbDBN4615xdM/jetri
         c8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMNaMbTulZVWFzBX43p/fXwF2BC09PvT07FCozD76VU=;
        b=UOTgoUKJJzjPl5r6GCpvwQrdUD/5u4usrrtHlO8Qmq9eTmwYCB8DlRfXbGljTbh3qP
         Hrt7zf6OFQ3MbSrCvPKekYqlXnfE+FT8nizKM7ZBqwCyk6aCnWJVOmiOuDuNtJz0xzJZ
         BCXNwAzD41/uOQcw5ruT5j7FyTFdlv6og3UUj4b0GM/yu6oVgZAt+i4sCNY5O1bbyqNX
         nGfP/4EFoW1hljznDXXUmgpd6xKJP5WQEu7W+w9+4yXz9tZxKOzkz+RG/SG9y3TWpU9q
         QIZO7RnLmlK+Jw4kutji7m4oydRuvkJ8ERhzEsJVUSzKqxpc0xbzpMUEpym/71SAWCcI
         Xiug==
X-Gm-Message-State: AOAM533vSBgRHIrBcOdOprHYDeOGie8Zf98fD8f2hZQspKCGCr7UUzBz
        um6m4Xa/H9W8um9kJFlu0kTFcLS/a2WyCzc4bzHQTg==
X-Google-Smtp-Source: ABdhPJyRKoCsX4sQ1CWsl/fOPRNr5iqIQ90bMlXwepNyYKYjPrwT0TgnjRxObEps047wJcjvKBb30Zd/x9HMMK+beJM=
X-Received: by 2002:a05:6830:210e:: with SMTP id i14mr9235389otc.229.1617912360590;
 Thu, 08 Apr 2021 13:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <1617616369-27305-1-git-send-email-loic.poulain@linaro.org>
 <ddc8cd0fd3212ccbba399b03a059bcf40abbc117.camel@redhat.com> <CAMZdPi_6hCYpiyf4=x1FdA2KHnVg6LFWnfEhCd8PMQP_yFXqCw@mail.gmail.com>
In-Reply-To: <CAMZdPi_6hCYpiyf4=x1FdA2KHnVg6LFWnfEhCd8PMQP_yFXqCw@mail.gmail.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 8 Apr 2021 22:05:49 +0200
Message-ID: <CAAP7ucL8Gc_w=BxFFY50XStJWghmdTWo2W2fdzdJjD3cfuWRRg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/2] net: Add a WWAN subsystem
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

>
> * Note: Userspace tools like ModemManager are able to link control
> ports and netdev by looking at the sysfs hierarchy, it's fine for
> simple connection management, but probably not enough for 'multi PDN'
> support for which devices may have multiple netdev and ports
> targetting different 'PDN contexts'...
>

ModemManager is happy with those devices exposing multiple netdevs
(even connecting different net ports to different contexts/bearers and
such), as long as we can bind all those ports together to the same
"modem device". The sysfs hierarchy has been enough for now for that
purpose; or better said, without the sysfs hierarchy it would not have
worked properly. E.g. there are some drivers out there allowing to
instantiate virtual net ports from a master net port; without proper
links in sysfs to link those virtual net ports to the master net port,
the setup would be extremely unstable.

-- 
Aleksander
https://aleksander.es
