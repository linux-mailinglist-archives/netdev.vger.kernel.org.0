Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF60031A7F3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhBLWn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhBLWkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 17:40:21 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88266C061797;
        Fri, 12 Feb 2021 14:38:59 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u14so1119207wri.3;
        Fri, 12 Feb 2021 14:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4XhE9nbvZZEvqp+VBT2ONDgBP5HJs5gEj+RiWZgZ+YE=;
        b=iqP14VcsBlhmEwk0zYi5+KCmrq9K2xA5Kyap60gFraEfU6hSbAKYWE6aTARzh6+EnV
         BrXZh1n8wfJIoOvRJrxHIICZf/4coYzinleNIgN2+GK8Dp7XKrfkNb0LDAzTKSFBhZaf
         GPm4FOlxrEV0yuqZYz9dbeIGYz1aDJgt0gTgyECDkfHBEqQVfogGiRr2mCR97LRrw4ze
         FaUkxBc6PGjjvx+ie6dap1M+VcQZB+0nskKMmY3XqZkM8GXA+gUhI6ZzsRMzHf/2gBwR
         X9eY/A9A4Wx5SBDHT32a1fERXfOjKWZu6ofSySFWzeZAO2BOBUMh0S1EpHO0T3VhIrNM
         jn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4XhE9nbvZZEvqp+VBT2ONDgBP5HJs5gEj+RiWZgZ+YE=;
        b=lpANLXyrfHM+PsO0Qpc/03TH2kL5PSx2sy6Iagb02cLNjYDBwdLNJk1ghQs4R4V8PB
         aC+5N30ibieIySpfIpz5LONPc/vptbpnEiDsUvhxhVMem95/uOvzRTMt0Vx1bqSV2nyJ
         equqLHJbbG1CKc311vj2Sd8vnAAVSGNXPUV4yluG6Er3mZDZYdATK3he19Ik1ObTPMos
         4uDOv+fE3KsRkEde9MI2CbWqhAtciZgC2Hid4etgIY3eMjMgxfQkH9nANH3zZzK8fIDY
         Z8aVhnm4Wc7PjvJqbuFeKETphQVq3DHDrEhmlOo5v9nll11Uzan3q/I4OpIfWZKTHbCp
         uiSg==
X-Gm-Message-State: AOAM5306eB3RaubuSB+ebx5bNQ2RzM5kcU7tsXmA/ELmgyyYQJmJz+B9
        TkI68tXvYUlhzNnTk8r+jpOGy56CruUjGh1J2+s=
X-Google-Smtp-Source: ABdhPJw+7VngcfuMrCOOkwo1E6yiHYWr5atjpHih5X6Wxr08jB0drHoleEoBHN8aUsy6wMEdaeWt+rqeGnNdV/JdsSk=
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr5897713wrw.166.1613169538231;
 Fri, 12 Feb 2021 14:38:58 -0800 (PST)
MIME-Version: 1.0
References: <20210211161830.17366-1-TheSven73@gmail.com> <20210211161830.17366-3-TheSven73@gmail.com>
 <MN2PR11MB36628F31F7478FED5885FB92FA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB36628F31F7478FED5885FB92FA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 12 Feb 2021 17:38:47 -0500
Message-ID: <CAGngYiXE1pajamOKhtMN8y243Gh8ByWA=AHP80jM=uDsYxTmsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] lan743x: sync only the received area of
 an rx ring buffer
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bryan,

On Fri, Feb 12, 2021 at 3:45 PM <Bryan.Whitehead@microchip.com> wrote:
>
> According to the document I have, FRAME_LENGTH is only valid when LS bit is set, and reserved otherwise.
> Therefore, I'm not sure you can rely on it being zero when LS is not set, even if your experiments say it is.
> Future chip revisions might use those bits differently.

That's good to know. I didn't find any documentation related to
multi-buffer frames, so I had to go with what I saw the chip do
experimentally. It's great that you were able to double-check against
the official docs.

>
> Can you change this so the LS bit is checked.
>         If set you can use the smaller of FRAME_LENGTH or buffer length.
>         If clear you can just use buffer length.

Will do. Are you planning to hold off your tests until v3? It
shouldn't take too long.
