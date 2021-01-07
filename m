Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC82ED4F1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbhAGRCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbhAGRCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:02:24 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21706C0612F8;
        Thu,  7 Jan 2021 09:01:44 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b2so8460264edm.3;
        Thu, 07 Jan 2021 09:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6QzQXBlWfecJhgtXdVXCWBkESw5K/fN23w2JVJbfkQ=;
        b=I/I8LHm/F9D2H9UNGPQ/ArnEaifDJkI5QyPBuyZo9G1t2BdinCsFbQBvRYaamRRMii
         ayz7yIPZzgUgp0fOdcWtBC73Si8E4ky3c1dytTvzziyxJnIG0Vw2DRK0XRgN3mf9tVqf
         6wc8L/QiQeHBeOeEB+wsQdIXGLrOkTHu6lFwXqpnol3WLckROsFaMc9jMDYFW32T1qiU
         LD2OS0vs7HYIQCszVqhbnOHW35HR3fdAqcUoXXNU+X3pP0yfH4atVGje2cU++PSsQWY4
         CdOA9+DzAJlN+j8rs/oEVQ4wezZjrNYsXTOpPVExhyqcMJLMlxd9wDZF10S4dUxf+KcB
         FA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6QzQXBlWfecJhgtXdVXCWBkESw5K/fN23w2JVJbfkQ=;
        b=aiC5EVv4hoSxLeX/sBtHeBajySio0IojIFcr3cOEuBOiLuDC5Lmpq8hrUydOwzPQe2
         NY9T43i1wOcyc2i2CylkTj20sRSUcBFtTeEqkjBrBh+661KHpLvpCxEmvCr3s2L0xjZu
         PHWtnOkDZxDQDZ49dc+a1bLUWjihgDDrjH+0lPb/26+L7SDd+mbJqjSC0PsrmyNzly8+
         NUGmDNzcJjdq1HYu/LcEpGTAmEGNJPgOsRMlDHeUujnKbXdodgj3vMwfYEEKNXiBOQMU
         4osijlgA46dkfQjYolMotMSeIjrlpZp5CAYxMzKIQZpjKYzzgYZBLDIaQ4Knktjs167k
         KjWg==
X-Gm-Message-State: AOAM533AkLgZifPk+J/0B5oOCVRWihe9T7Cf42Rnm7TM/iWWW4m5Ea2B
        HZc9iWoFqu8u1d3x/WNIMvyM66Kw5lMFZrNRqAI=
X-Google-Smtp-Source: ABdhPJwuAC5wMYKkyhGUW9GlV/rS6710r8LDpwxU8ycrOTK0Jkk98gHnOuZ2G3Tvv7ARvij9uNvc+yrTjpu5j3VfbH8=
X-Received: by 2002:aa7:ce94:: with SMTP id y20mr2305433edv.361.1610038902892;
 Thu, 07 Jan 2021 09:01:42 -0800 (PST)
MIME-Version: 1.0
References: <20210107123916.189748-1-colin.king@canonical.com>
In-Reply-To: <20210107123916.189748-1-colin.king@canonical.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 7 Jan 2021 22:31:30 +0530
Message-ID: <CA+sq2CcPRuQijfOFA74KrNF9E5tj-QqH_0nNC21fT=rqkuuCcw@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-af: fix memory leak of lmac and lmac->name
To:     Colin King <colin.king@canonical.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nithya Mani <nmani@marvell.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 6:11 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the error return paths don't kfree lmac and lmac->name
> leading to some memory leaks.  Fix this by adding two error return
> paths that kfree these objects
>
> Addresses-Coverity: ("Resource leak")
> Fixes: 1463f382f58d ("octeontx2-af: Add support for CGX link management")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Thanks for the fix, looks good to me.

Sunil.
