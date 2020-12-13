Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579562D8F23
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgLMRgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 12:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgLMRgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 12:36:33 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF5C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 09:35:53 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id r127so13275881yba.10
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 09:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UyLSAqjPcXy1gmCGB0gyqo6TQJowR9P0YCFSiywMISY=;
        b=DZlvffhbtt3ZOXxYmrOOM+m9QTz8qbgZk0w3lMPKrYgVdDT/cBLYTSN0o7tO430F2h
         E/EyN1pEdleJnNp4143GMpdwS3TC2rd3yfpcr5UbE0QZaVMa0S0DN92Vjdo8Moo5YNpY
         S4OARbY/kVeSsRRA7lWnr76tI+xcZU7oDnIzU0zSM5RTW6KAvEHkHqDWr0wMY+DmmYzz
         i4Al8bWPj9qGNqDhVLkkA9+tz+RseIngqfFdWyrnQa8WfiLcCIR41aumT8wonDQTpbnH
         FvooN/Fruc++ERerSGpbCrlg5ea99iXE4oa2coQlerXjimS1Y3RRiYxoJCe/AlkQPIJq
         hizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UyLSAqjPcXy1gmCGB0gyqo6TQJowR9P0YCFSiywMISY=;
        b=I4/II5iiigVtoeDRmP7CYU2hWohdFxxXP+2sqUW/uQkxv7RTXtVZaZikPBZAn9aAD5
         hwVRfP0HsAu/0MCkwzY4oPUT65wTn6syRNNZLN5FsvV7MuzZgmmj8bCGdEaqrxnK85Om
         rBVyi8uIOhHJP+O8WzOWx5F3QcJwejQBt91/E4rqrcTwQ+G1DkwolCLe+VbcQurv9Yfl
         sjLsSizSbmCkz9pZOaWPgqaM8mA9mmAi3SPxW2nuT6WVU5CU1jbmateenfOT0Ig6BqQx
         gyEDGrX2iIy+rU0K40uCafEdeSMXZjqylOKGNBwFSBeTJvGh7KG6BWICQLcHLMEvfeJ/
         MI4Q==
X-Gm-Message-State: AOAM531oThhvyUKdkYCf5zO6F7Gvmai54e+taQKGbWI9S/vJBS8sSm9u
        KizH/eCeAP/Rf792AMhDLjlt21H+C8D1eXJ4yzpExZ25
X-Google-Smtp-Source: ABdhPJzap55z9Bj84PY3KXKaBx8DjDUXOmMSngmPnjx3mDWQVOuA3OUPnsQNp1tPTXSFxJI1VLg5mPZ5wJhiHrhoGGQ=
X-Received: by 2002:a25:2643:: with SMTP id m64mr33473115ybm.221.1607880952764;
 Sun, 13 Dec 2020 09:35:52 -0800 (PST)
MIME-Version: 1.0
References: <20201212044017.55865-1-pbshelar@fb.com> <20201212141133.63874784@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212141133.63874784@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 13 Dec 2020 09:35:42 -0800
Message-ID: <CAOrHB_CHQB_KX4tAFQabbuZ_iUs=QaYb6LzWC_L-4w2Rak_HjA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 2:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 11 Dec 2020 20:40:17 -0800 Pravin B Shelar wrote:
> > Following patch add support for flow based tunneling API
> > to send and recv GTP tunnel packet over tunnel metadata API.
> > This would allow this device integration with OVS or eBPF using
> > flow based tunneling APIs.
> >
> > Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> > ---
> > Fixed according to comments from Jonas Bonn
>
> This adds a sparse warning:
>
> drivers/net/gtp.c:218:39: warning: incorrect type in assignment (different base types)
> drivers/net/gtp.c:218:39:    expected restricted __be16 [usertype] protocol
> drivers/net/gtp.c:218:39:    got int
>
> Coding nits below.
>
Thanks, I have updated the patch.
