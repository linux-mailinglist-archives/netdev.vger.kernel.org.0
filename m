Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9419C30E2EC
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhBCSyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBCSyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:54:13 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD06C0613D6;
        Wed,  3 Feb 2021 10:53:33 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q7so385824wre.13;
        Wed, 03 Feb 2021 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hCI6ZiNImno66RrVehBGLrYLxtapcVm5zzLIRSnM/WU=;
        b=VCJ3330ilMlz+QT2OkDv5eR7bQwxwP0yJ4r1r8eJsgHMjJ4mxac6onJBjDTVewEAfM
         diCPP7S02OhDsvmYqjgXAQNgAT6ONwiqutI/wpFQJwODGEkQi8Rpxx3+aMu/v5rkwQ1K
         45o2B+snceo73W6d6J014W8pBSQ0p7DLFKxbtZT9EEQzRft4f0AVfA5sBCmfgTlpCJJV
         y9/CGdMTWRA1Og+Lu/BYKrPGAgFBPZ0X3T8CBXUugd26gfroT2zpWJXg44RjxtBBjLb5
         pkDo417TWzy3ABdFkyjkU/vjhEVXOGC5GYv3cR8DdEBN4pkGA9LFw7qMilUoL4B+V9nr
         Hpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hCI6ZiNImno66RrVehBGLrYLxtapcVm5zzLIRSnM/WU=;
        b=e3kLRVaGmec4HfwTywG5bNHz+YR3NTBGoerezmXKov5evIYZAWmYaZiizCkinhUn+O
         4FWXFSh60jxO8gS0LBg6kT9OqCNQ30viS3NhlQfoBmThwzixvZC2pBNpcQCSXRmDiOOd
         yg0Q02vLnnAuESujjGfk82gSowjzDjpHV/EEEj9YZi+66RLu80yk8doaBSAuhwJjjbzn
         SdkHegV3avhFnKcRUydXXbQ3/6D0r/OwymiaZIqQCvwZgQUHPTO2DO+2369dbu/+1NFS
         kdXwZfPklFcZGlkIk0wOZGI4NmzPfKNK33uPRt/QHa6hIC29ApT1iWanJyqnSDfctwzU
         Qt7w==
X-Gm-Message-State: AOAM5300CAEzvXCM6NQrd9ETjvolljHzGG9MuuAMdppMThmeYWnVp7Cm
        D0YyqtYuqoTI5+XKP6WSyHUmMPaPnBcfhoX+pYs=
X-Google-Smtp-Source: ABdhPJyHLzSa0ru1ema9q6kVyMifJqigYStPu+h+0FBA1tpzSHcRislqBSWzhsMgmuJKF7sU+drOE/JpGjgTQCLonYE=
X-Received: by 2002:adf:ed02:: with SMTP id a2mr5098155wro.197.1612378411971;
 Wed, 03 Feb 2021 10:53:31 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com> <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 3 Feb 2021 13:53:21 -0500
Message-ID: <CAGngYiVK5=vggym5LiqvjiRVTSWscc=CgX6UPOBkZpknuLC62Q@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Bryan. I will prepare a v2 early next week.

Would Microchip be able to donate some time to test v2? My own tests
are certainly not perfect. Various stress tests across architectures
(intel/arm) would help create confidence in the multi-buffer frame
implementation. Perhaps Microchip has various test rigs already set
up?

After all, absence of bugs is more important than speed improvements.
