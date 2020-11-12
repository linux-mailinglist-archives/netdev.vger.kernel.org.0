Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B632AFDEC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgKLFcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgKLCgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 21:36:37 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4314C0613D1;
        Wed, 11 Nov 2020 18:36:36 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r9so6082510lfn.11;
        Wed, 11 Nov 2020 18:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0pkfRKs9jxitkTd7x9shbHG4IOI7k9nwLP4ujmMO868=;
        b=CsGfb5MunrKY47a3CNrkC6ze0n/imOb/cdyBzdrAY65ohpdEswjbZ/rAwdFZsoNUjd
         XMK8XjHIF99V9k2GtV7UvpOf7FnwjMVVyJL9kpO0dGG6uJ4K+Nhtaa31T1Ryys6pIZwV
         WZM/bsNyq8fJEYefeYEbNeyQaLZR6NyCFSpXfmsQq3D/WWG+mUHBVWS28lBFHB1Wo4/5
         n7jhGMCi5UhU8+uSxq+7xmo2NPl4mjeI+rMhBcfs+oLBeRCUfj9VRFhTCCJwFftLTP0h
         L4rdjOSx71IMwjbeH4WL+suzUA4sDTSj470idXaiRz8P5XpghDD5D+Lg6FfPqtsJTbK7
         gMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0pkfRKs9jxitkTd7x9shbHG4IOI7k9nwLP4ujmMO868=;
        b=WslOvH9HunGDBbZu025bXZfGnd+6C9ypJvbhEZN44p9mGJloGuU3GaDjOAa8etmrqn
         /YYTFEd5rDupAzj5UiOleQ/L8K0zAQrHgdRWV+WJG36R3cTEgTSdi99aXshLed8Em3dq
         wqm/7hNZ16YeNNrY68CLGOmE9xM/iE43xlHUQvlbl9c1HHYK4g6g+U+EGo3OSXxU+qGQ
         BDFn6BSOIoCySlNYwCGYXfBOj+rH/PG8XtwMgC+Ge6HZHtvFMcJQ00YQEfrSYVjjW8av
         W4LECsHftVDyVRSKbqDygMdmUcHyTIjj2/Kiq08V0x/bx+JpCLblp1DIK1xQgyi5e3Mg
         yIxA==
X-Gm-Message-State: AOAM533wQ0plM0HsMyqncqGSqqET7ovdnNBfzMXKbvb+/gy3BjW8sV0n
        59mMbD7lxhq/l1PJ7ApCOfO3rRQaJFkJLgd44Bo=
X-Google-Smtp-Source: ABdhPJwzspWD4JbbnDjEp7R7vgpEh9bTH+OghpLvlBfcilRzCgbXj5XHtD2ngplmE6lRXJ2035zUSaOrISY1wXP236s=
X-Received: by 2002:a05:6512:1186:: with SMTP id g6mr5953790lfr.523.1605148595027;
 Wed, 11 Nov 2020 18:36:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1604930005.git.geliangtang@gmail.com> <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
 <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net> <20201109125703.7d82a34a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <62ab8297-41fc-446b-a09e-0b93118a478c@tessares.net> <20201109142051.39f1cfaa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109142051.39f1cfaa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Thu, 12 Nov 2020 10:36:23 +0800
Message-ID: <CA+WQbwsAHXoFsO0ow6zasSpW96u8dsLusvJvE1iiAQC3KmQBAQ@mail.gmail.com>
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in mptcp_pm_add_timer
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp <mptcp@lists.01.org>,
        "To: Phillip Lougher <phillip@squashfs.org.uk>, Andrew Morton
        <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Coly Li
        <colyli@suse.de>, linux-fsdevel@vger.kernel.org," 
        <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Matt,

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2020=E5=B9=B411=E6=9C=8810=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=886:20=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 9 Nov 2020 21:23:33 +0000 (UTC) Matthieu Baerts wrote:
> > 09 Nov 2020 21:57:05 Jakub Kicinski <kuba@kernel.org>:
> > > On Mon, 9 Nov 2020 17:28:54 +0100 Matthieu Baerts wrote:
> > >> A small detail (I think): the Signed-off-by of the sender (Geliang)
> > >> should be the last one in the list if I am not mistaken.
> > >> But I guess this is not blocking.
> > >>
> > >> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > >
> > > I take it you'd like me to apply patch 1 directly to net?
> >
> > Sorry, I didn't know it was OK to apply only one patch of the series.
> > Then yes, if you don't mind, please apply this patch :)
>
> Not really, I was just establishing ownership ;)
>
> Geliang Tang, please rebase on net and repost just the first patch.
> It does not apply to net as is.

v2 of this patch had been sent out.

http://patchwork.ozlabs.org/project/netdev/patch/078a2ef5bdc4e3b2c25ef85246=
1692001f426495.1604976945.git.geliangtang@gmail.com/

This patch should be applied to net-next, not -net. Since commit "mptcp:
add a new sysctl add_addr_timeout" is not applied to -net yet.

-Geliang
