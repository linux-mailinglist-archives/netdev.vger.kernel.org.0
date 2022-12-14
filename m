Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1595064C59D
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiLNJLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLNJLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:11:33 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74061DDFF
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:11:31 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso10046548wme.5
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeychOEoq7Zx2fAKmiJJqkfIh0+9mZMjXMwWbS//l/Q=;
        b=OXFVZCylX/4bT+jsLBPms7oXz7QPabkjEgubvKA5voELoHfDi00peMTghNLCzd8eaq
         nP2ibgokYJBj2KWiBZjEhKQ+zdmJm+v6RlifmQdsO8suBtWGnxKbf4CZsTyvWffB4Xzk
         CP3ibLqZDT/ds1dpodM9ahZo2PdJUUORzc2JLPe003BODyIMy6Euf0GauL3sERFOo6Tk
         ocbUZXufRgpRSvXRXJdlr5yjxhhP7goz0joVE3Ti48T/ApcY1JbsyFQe1viina/MkBUX
         uu6xSSyMCQBH1l6fEHWCCwz0qhfylUeTZSHlVGhgvKIfvrRA8OZeVMdqZHiZgovSOzJV
         hByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZeychOEoq7Zx2fAKmiJJqkfIh0+9mZMjXMwWbS//l/Q=;
        b=JLTj3tpB3WiVzIY2rBX/YNZdYqEvqiYM4zH/GsuOB5aKikojBLKxv7SHAE4RcUUcth
         /TVYiSrs6rHzIpINbXtrwQvDWIbxawICz8choiA+aH6KwLQo295LrIgyhsqOKvArGfES
         y9++kX4MaZwwSvyGKmYM+kEN9/UfsT594aeE5Ge+823H9cMRFmtdd/I8YCmTpY6BOPDf
         VTKwSW/IVV8+3mhBO1c3+VwT4ngYmBBusjTNNP1YA4923rFjAvAHbqNIlKhRDAyG2Ll/
         VsSgu0gApjjB5j+5h27GqPaSS9f3kOYrCW9NEkyZU+hMrFfUz1MxmnruPe7TJpQqnLI1
         r5nQ==
X-Gm-Message-State: ANoB5pky8PIXAutMry9/jyYnuiFvDv103YCB87VGxDF0zdPBu3D+VvhT
        R5tM0XevoWrXOzgLwJkQCQcjcgMdIUlNaPYJ8V2hPw==
X-Google-Smtp-Source: AA0mqf7lFwCf3f1u4ql2QYub40j2Jn+xpyaWCbFrBIxrz+GPM5OrSo5cjZ+bxnr0nuG4jOrNfiMuxCV5PCxKqjmsLpU=
X-Received: by 2002:a05:600c:3b91:b0:3d0:3d33:a629 with SMTP id
 n17-20020a05600c3b9100b003d03d33a629mr73994wms.126.1671009090250; Wed, 14 Dec
 2022 01:11:30 -0800 (PST)
MIME-Version: 1.0
References: <20221124074725.74325-1-haozhe.chang@mediatek.com>
 <CAMZdPi9JOQpmhQepBMeG5jzncP8t5mp68O2nfSOFUUZ9e_fDsQ@mail.gmail.com> <54c37c8f8eb7f35e4bb983b9104bd232758bae7b.camel@mediatek.com>
In-Reply-To: <54c37c8f8eb7f35e4bb983b9104bd232758bae7b.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 14 Dec 2022 10:10:54 +0100
Message-ID: <CAMZdPi8NOfMn99yy043oYGrO1=UrnhhRvpZq-zWe4BfiU_08NA@mail.gmail.com>
Subject: Re: [PATCH v5] wwan: core: Support slicing in port TX flow of WWAN subsystem
To:     =?UTF-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
Cc:     "stephan@gerhold.net" <stephan@gerhold.net>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "shangxiaojing@huawei.com" <shangxiaojing@huawei.com>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 2022-12-01 at 10:56 +0100, Loic Poulain wrote:
> > On Thu, 24 Nov 2022 at 08:47, <haozhe.chang@mediatek.com> wrote:
> > >
> > > From: haozhe chang <haozhe.chang@mediatek.com>
> > >
> > > wwan_port_fops_write inputs the SKB parameter to the TX callback of
> > > the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> > > have an MTU less than the size of SKB, causing the TX buffer to be
> > > sliced and copied once more in the WWAN device driver.
> > >
> > > This patch implements the slicing in the WWAN subsystem and gives
> > > the WWAN devices driver the option to slice(by frag_len) or not. By
> > > doing so, the additional memory copy is reduced.
> > >
> > > Meanwhile, this patch gives WWAN devices driver the option to
> > > reserve
> > > headroom in fragments for the device-specific metadata.
> > >
> > > Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
> >
> > Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> I have submitted patch V6 to add a reviewer, do you have any other
> suggestions about the patch?

You normally don't need to resubmit a version just for adding review
tags, as it is well tracked. You can see status of netdev changes from
patchwork:
https://patchwork.kernel.org/project/netdevbpf/list/?series=&submitter=207580&state=*&q=&archive=both&delegate=

Regarding this change you should however resubmit for the net-next
tree with appropriate subject since it is not a bug fix:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html?highlight=netdev#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

Then it should be picked by netdev maintainer(s). But note that we're
currently in the Linux 6.2 merge window, so merging for net-next can
be delayed until the mainline merge window is closed (and net-next
open):
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html?highlight=netdev#how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree

Regards,
Loic
