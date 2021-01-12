Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8763F2F243B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405498AbhALAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404259AbhALARz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 19:17:55 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227D0C061575;
        Mon, 11 Jan 2021 16:17:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id q20so285078pfu.8;
        Mon, 11 Jan 2021 16:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eMOGjx4X1G85YpVaLNWlXD4JxAjkbXS4+mOr5OYo8sI=;
        b=Ie1Q5gDrHumtlGRP7Ula133n91VU8nJcDCw79dJgUxoeRc1a+Dh6C53LngnDM7NDlL
         RqQv9nQ+BQU1a7X0h1f7F9f2IRBCZ2zpIwiYAuSYOZSQziDRuQR/8fDKW16zQOmFYdET
         +Wuqt2VXw6fN7WfnYOc4QXN5um42TIb/K6xEAbHNJVsJFyGjTTS19wqf+dgvNQVkDMEU
         beS7VJ7MTzF2cG3ISIiuR7gUPTFi12TqokwkboM7btsl/qTZxaiZcc0DVorX8yrauAwE
         Vle1QlUvtAoSKYZHNWFicaFlLlumHY3Od+z2jAN2sFKB7pRpy6hL7+xlcIL6U02KDV1Y
         H1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eMOGjx4X1G85YpVaLNWlXD4JxAjkbXS4+mOr5OYo8sI=;
        b=PaROZQC/cWOYS8txtBNOvvJpB+L70zrN+MXtWZ5vxEzvn/JmGNzBOKFio2Hzdoper6
         AmtTCJFUFLR8kCAXGayzFtHGE1rEjxnXmuBf2ksjCE1D8eVx9irjR24c82vuXzL78Oyt
         C4ok5Wl9Nywk0P+uM7wB0oo4n66OMNdmZwVwtiesfQ5cZG1VgK5eNjLuYEVKVTUF48FJ
         vHLc55IhnyoM0Z37C0onhulS2K7b5PDsdBJDqTDZDQQoE1HLVbIA/YWoYCKmcEVT3Llf
         UDghlj+KXF9oAuVqqXYw08nwVLg/vLNKsDdnPYMhJIFEa3UR96Ba/SuXQnMxrwb/w7gC
         Uk1g==
X-Gm-Message-State: AOAM532QPvH7gQa7ZSkyfkDaXQV0TWJ4sj+TUPX8Y9Y79BeaWcPJlH/4
        rjpKj+EBK9ln+1wxohTOAQM9pUOAtPHamrnXqVo=
X-Google-Smtp-Source: ABdhPJzUpY3jMAx5iegF3WyYbaQBMHOy/tXVFcIxoYLTA1mDgn+AAvvsNB7b1iBngqOrnpfKH2KrRR1i7EuVDUA7f+o=
X-Received: by 2002:a62:808d:0:b029:19e:b084:d5b0 with SMTP id
 j135-20020a62808d0000b029019eb084d5b0mr1862142pfd.80.1610410634548; Mon, 11
 Jan 2021 16:17:14 -0800 (PST)
MIME-Version: 1.0
References: <00000000000019908405b8891f9d@google.com> <20210111113059.42de599d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111113059.42de599d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 11 Jan 2021 16:17:03 -0800
Message-ID: <CAM_iQpXbARpYRxFv4g2gC1+oPfdpKx8mMD_7d6BjWr5mPn3nrg@mail.gmail.com>
Subject: Re: KMSAN: kernel-infoleak in move_addr_to_user (4)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, David Miller <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Looks like a AF_CAN socket:
>
> r0 = socket(0x1d, 0x2, 0x6)
> getsockname$packet(r0, &(0x7f0000000100)={0x11, 0x0, 0x0, 0x1, 0x0, 0x6, @broadcast}, &(0x7f0000000000)=0x14)
>

Right, it seems we need a memset(0) in isotp_getname().

Thanks.
