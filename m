Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5E20F8FF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbgF3QBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgF3QBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:01:19 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8946C061755;
        Tue, 30 Jun 2020 09:01:18 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id r7so4681034vkf.0;
        Tue, 30 Jun 2020 09:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IW7S+HDCp7B0Ek61OydG5Z6g/ROgWTAggp3+J+Law08=;
        b=JgT/qC1EPb348NcHOxxcFkMaZthCEoisS79dWr0Kr6P8PapHQy0RWxPxraRWWj+fM9
         P4JDlKUq+fRUCygFl8cJZa0Jfopry7aqt+5lqZta3gXWjRp1SEFIOVRHBjgral0h9XWT
         FeZUwElCap7gIUAXRcmXrjVyGNaY2GsNbqLKZ9uQtztDqjrNrKgcZQ+i91NdBJLUlLgb
         pFuxVQqdkBt43OqEQ8bG6tpIiH+8oZPXR2JdTZO7nE5b9rLXM1rMDFJQ2w+OgR/58gfs
         wTG76UYEFI03zw7LRE1oAIiSYuPUnVCj1kKCH7NvY4VY13P3YBmWqFhkj0+mjsIJPVhC
         Z9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IW7S+HDCp7B0Ek61OydG5Z6g/ROgWTAggp3+J+Law08=;
        b=OrQR5PV25PByEX+CgJ1Iz1n1wfKL8HB4F6mOj2dttH5v/bQ5q0lpl3V7SWzLeuNX+d
         yZh8rHxW/+3Gs4kjo6diX2e2vGIwhPd4zY3i4kpPtYhq3Mf06PiD5kFqEE8nyb/ypomV
         0mvHpke557C6l1HVjC60X+vN73uB94KVh60wKSdWhtuLMpI5XEJXkF2goC3XQdeBByAc
         HmtNBd1jRunHwdQXpR1zCprORLX1ErjHp+1fDiz1jF38I4h2jdy64JGoEkQpizO71Gul
         NQei9M4SRDEXMi2IqzFWa59s0ZLUCpsG1ff9hI3aAIczc06zCr10hhdVWE0PVTVPGeBS
         si8w==
X-Gm-Message-State: AOAM532RUgu/JFkbFtHtgmCNuBhzi8UjL3CLHlbjzznSGJfhBQtyWjCg
        nQGrfuKVJJR3371TVUzuIzzgcamCMNXtZ9rKvTs=
X-Google-Smtp-Source: ABdhPJxgpBwp7SLfHhtmOXQng4CIxyB+mnTVugkIZvO3UlRMg8zEfMYz5P+Rz4uQbijCoX8HFf2xiPhV3ca8pqMhR78=
X-Received: by 2002:a1f:9e8a:: with SMTP id h132mr14995446vke.14.1593532877997;
 Tue, 30 Jun 2020 09:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200528032134.13752-1-hexie3605@gmail.com> <20200601.113206.2297277969426428314.davem@davemloft.net>
In-Reply-To: <20200601.113206.2297277969426428314.davem@davemloft.net>
From:   Xie He <hexie3605@gmail.com>
Date:   Tue, 30 Jun 2020 09:01:07 -0700
Message-ID: <CANJFnSS3XQqa4_Tnur+OhsF-sbCQyP7QBdaikDuUFmuF1ti3rw@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether.c: Fixed kernel panic when used
 with AF_PACKET sockets
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, Jun 1, 2020 at 11:32 AM -0700
>
> From: Xie He <hexie3605@gmail.com>
> Date: Wed, 27 May 2020 20:21:33 -0700
>
> > When we use "AF_PACKET" sockets to send data directly over LAPB over
> > Ethernet using this driver, the kernel will panic because of
> > insufficient header space allocated in the "sk_buff" struct.
> >
> > The header space needs 18 bytes because:
> >   the lapbether driver will remove a pseudo header of 1 byte;
> >   the lapb module will prepend the LAPB header of 2 or 3 bytes;
> >   the lapbether driver will prepend a length field of 2 bytes and the
> > Ethernet header of 14 bytes.
> >
> > So -1 + 3 + 16 = 18.
> >
> > Signed-off-by: Xie He <hexie3605@gmail.com>
>
> This is not the real problem.
>
> The real problem is that this is a stacked, layered, device and the
> lapbether driver does not take the inner device's header length into
> consideration.  It should take this from the child device's netdev
> structure rather than use constants.
>
> Your test case will still fail when lapbether is stacked on top of a
> VLAN device or similar, even with your changes.

Thank you for your email! I'm sorry I didn't see your email previously
because of problems with my mailbox.

Yes, you are right. I'll use better ways to improve this and re-submit
my patch. Thanks for pointing this out.
