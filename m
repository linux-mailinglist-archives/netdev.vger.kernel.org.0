Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D785529F413
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgJ2S0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJ2S0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:26:12 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B947CC0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:26:11 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y16so4214956ljk.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qrar9dmRm4zwdoSrcFwY/wHsTikC9FDxVpd6kfA/rMU=;
        b=nC2+zmQ8BbqhTLDDWr43qkKPAGZIIiM2rE/6dNa6mi0K1d6OQl1UMc7FfPoJwxy6ps
         x6jtM8eI+8jRP2aq0Xv4xlQhGD5c3KvTJS3AkuzG/MBnjWIK7DrpieObKzkmYp5W8vby
         DspwpJHFYhIGvSsF6tpHBWFC3HDR93XfkClwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qrar9dmRm4zwdoSrcFwY/wHsTikC9FDxVpd6kfA/rMU=;
        b=mSaCQAXh0VOwmLvY1sSoue1/dWbLBlot4KEC928L0LMGZ6EtVWm2bMCb3ONrM36g9G
         CNWhZbJQ1ogPVXq/NPe2SGA1jLQEWBczmguUujX3fqF+xSCpa12OQGC4F5TEKSm/51g7
         aaa1REWrJk/182uMBs0D0HcL9qKumrHQGVm1tLR+iI/SR0uYAlxGyuBut9PspezKFiFH
         bYRCK1CQlUfdkxng4YVWfoyxU3TJbQCbuN4BUsw2/YG5zBZQR8UAcviBOL2Y9kooIZJ1
         1arSJOBKx1tZ0URmh+x6wLh5pimfYD+2RYtKV3aH6rdUW9YykRhiai2Z703UrKI5VV6c
         x6sA==
X-Gm-Message-State: AOAM5303WVNLvpZh84kY58/FUz2o/MitaCJqIJRPewOv9Qfjxl2hdMFx
        MZG4CrmlgPFVcV68xmYqsZhwqB/9Oep00w==
X-Google-Smtp-Source: ABdhPJxKZyzsyX1obsMWmv4uTrnw4exg6Ipuzlj1EqZiSxJAGv8RLlqAtjB6X8KIsMYyqjmIUzUoYg==
X-Received: by 2002:a2e:7a11:: with SMTP id v17mr2265326ljc.291.1603995969370;
        Thu, 29 Oct 2020 11:26:09 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id j2sm412612lja.125.2020.10.29.11.26.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 11:26:08 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id a7so4528815lfk.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:26:08 -0700 (PDT)
X-Received: by 2002:a19:41d7:: with SMTP id o206mr645895lfa.396.1603995967726;
 Thu, 29 Oct 2020 11:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201028142433.18501-1-kitakar@gmail.com> <20201028142433.18501-2-kitakar@gmail.com>
In-Reply-To: <20201028142433.18501-2-kitakar@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 29 Oct 2020 11:25:54 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
Message-ID: <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mwifiex: disable ps_mode explicitly by default instead
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
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

On Wed, Oct 28, 2020 at 7:04 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
>
> On Microsoft Surface devices (PCIe-88W8897), the ps_mode causes
> connection unstable, especially with 5GHz APs. Then, it eventually causes
> fw crash.
>
> This commit disables ps_mode by default instead of enabling it.
>
> Required code is extracted from mwifiex_drv_set_power().
>
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>

You should read up on WIPHY_FLAG_PS_ON_BY_DEFAULT and
CONFIG_CFG80211_DEFAULT_PS, and set/respect those appropriately (hint:
mwifiex sets WIPHY_FLAG_PS_ON_BY_DEFAULT, and your patch makes this a
lie). Also, this seems like a quirk that you haven't properly worked
out -- if you're working on a quirk framework in your other series,
you should just key into that.

For the record, Chrome OS supports plenty of mwifiex systems with 8897
(SDIO only) and 8997 (PCIe), with PS enabled, and you're hurting
those. Your problem sounds to be exclusively a problem with the PCIe
8897 firmware.

As-is, NAK.

Brian
