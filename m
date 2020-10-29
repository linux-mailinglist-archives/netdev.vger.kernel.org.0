Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C5F29F42D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgJ2ShG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgJ2ShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:37:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824E4C0613CF;
        Thu, 29 Oct 2020 11:37:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i26so3062739pgl.5;
        Thu, 29 Oct 2020 11:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0+QUp5estCwSbEP+dyAOoylqJ98ytC6E0wr9TdO3E1o=;
        b=f0XBik8NWXMc9mmMNlwYBCxAJ8dK2XqMOHQG2y6XoFvEG9SvZj12+VSS/0wZt1Zcqf
         bMPsHPN5HtWBI252MEquWcaVTXJMq4wLmglpFaguXhKvPdKpqVshs4jWrH2XMQ5i5fDx
         RGHnfONL6LszCuJhc4ec2Ipzz9Ll3UOAINSkVvphJ2TbqNKvt9tL2Yb0mtSGFT7lUTkG
         s5RfodRbGK0/wFTb5lCD/HC+uy6V1J8vQHG4MkmAUq6G9nq/w0qrxwyKnEqxp8RuvSsc
         /VvkMd1CHCbIqANed6nsayZ3kiGpAXaA9LxKOHaJCJLVvm4TJ/2SLOI6m8kWy7IrkqU4
         vKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0+QUp5estCwSbEP+dyAOoylqJ98ytC6E0wr9TdO3E1o=;
        b=GY7ZUgoh76Tqon1IYqLJXyp6zeXfRoC0/YTftmm4QxPyGhIjkup4ZgvogYi3LaP3HV
         z7FUgV8biNKAb1E8nNAtWrbHowQ4Xrr4JV6i9P6HZw7RKTYCEiqE8qywXnyjiIP7G0LD
         i7YSkTJloxNo1P6F6XRGxmIcnTxSQgGRi2IGU6mD8ji3RaeUUOg0ZE2nJhN9L4dYeJyK
         h0+DwZIjP30ikou5Nq8uWbE2qEjKrJTycTq6ZOBAKEdUFLZf4Oep9G0+2JKje5P07JrV
         39ZmxzC3Lg6L8qek6zaEbTnNh/7TF1l9T39pr66qGL1L1/E0nLLMJlpOdoskbyJUFUtp
         fZsg==
X-Gm-Message-State: AOAM533nXxnHNJ+anRdYbY6bZvO0b2+Zh9dmoVHocJkEbyXsHaUPLOOP
        J/6pgOWXE3FQFW47UmPnGT9ZDkLCDT98aiIaOtk=
X-Google-Smtp-Source: ABdhPJwaXuakqX62nMfSb/ByNLV62IST4kysb7WDh0gadhnvXIukwLVo9FZy3TV8THBK2Ve7clXVkQ24yrw5c5WHLKY=
X-Received: by 2002:a17:90b:305:: with SMTP id ay5mr466697pjb.129.1603996625112;
 Thu, 29 Oct 2020 11:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201028142433.18501-1-kitakar@gmail.com> <20201028142433.18501-2-kitakar@gmail.com>
 <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
In-Reply-To: <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 29 Oct 2020 20:36:48 +0200
Message-ID: <CAHp75VfUv6cD8BKxircd7dU-5p7Q6JL1dVz5X=0SC-Y4pqYhjA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mwifiex: disable ps_mode explicitly by default instead
To:     Brian Norris <briannorris@chromium.org>
Cc:     Tsuchiya Yuto <kitakar@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 8:29 PM Brian Norris <briannorris@chromium.org> wrote:
> On Wed, Oct 28, 2020 at 7:04 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:

...

> For the record, Chrome OS supports plenty of mwifiex systems with 8897
> (SDIO only) and 8997 (PCIe), with PS enabled, and you're hurting
> those. Your problem sounds to be exclusively a problem with the PCIe
> 8897 firmware.

And this feeling (that it's a FW issue) what I have. But the problem
here, that Marvell didn't fix and probably won't fix their FW...

Just wondering if Google (and MS in their turn) use different
firmwares to what we have available in Linux.

-- 
With Best Regards,
Andy Shevchenko
