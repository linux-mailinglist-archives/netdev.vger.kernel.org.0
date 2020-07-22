Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8851422A103
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgGVVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVVAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:00:11 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B92C0619DC;
        Wed, 22 Jul 2020 14:00:11 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q74so4081278iod.1;
        Wed, 22 Jul 2020 14:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=QahUCP+j7EUAcgH4srGReyLkFNQVTTAj/WrG0sh9JETuQSJbufd9Z4xT5vMAMgy1FR
         m6PX4/oiwrW4oLUwqTLaasVa3/vBJNYnj/7VR4n6TvXBvddB+wQVxwLzCoAyqZ1KUQfv
         vd3C71YXD3N3p7eWTwYQjeillKnZjCZx2lePtscfHSE7pcK4a0+Rr5gD+bEBmCf7+o0E
         vvqqnI2NSBrkWA4ZjicF8cDuSghOOQtSNj8/6fSA3KKoQQL5RRMFeyqOzr8gGHHLhhwU
         6TILQSeJjhKaeQ+VMj3ZZGzxJoB4lUFlLzsvp1LYB73igsEMXN4j8ysSCibz9N2HVHdz
         PKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=nyEXzTtVU/h3L2scR59QAHYfxKdimhOL2DPlOn2dWYHrlYzaKaqPX9nmMerQJ5SsZQ
         JsVruFcoubGSp7t4fW1GIbz40+Gk+DkuSd+UfeqxGGunATpADDXoPhKuot1irxehHBnE
         7AXh0b5ciPxByNwUKSgvF9RP5JmSKlER3iVONNvOCJlFpygc5XeMoJ1yVDMdYrdrCLdz
         Rub1IhzxSjnNIOpkMW7lvGB7bOVh242EcK4VzNAJq4KRfFiR4r4I2q9c888H4JUyOwJW
         nSOFnPqbRz1fOr84U7Zo1mLYq8JcqInlhN/XWu9Exa5r9brSWp8SOQhZmZ3OPkN4bQMG
         plTw==
X-Gm-Message-State: AOAM532Oo3q3TH1RBuFtVeDEnz8X7yVpsEcJfKFYxGnxz5ckOHrX3zjA
        gxJMKcKW4ibDrcpC9i4EjAleHLa+CFootMp3JmI=
X-Google-Smtp-Source: ABdhPJwvbBhgaHJ6DjWBIdyivMK6mTkMiRFyuf7X5P+CKQh7hpPm+UO6syklaC6CzdQLWGNP/O0AaYJQVepjb3EQiN8=
X-Received: by 2002:a05:6638:d8b:: with SMTP id l11mr1160295jaj.124.1595451610293;
 Wed, 22 Jul 2020 14:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000fa7b205ab0dc778@google.com>
In-Reply-To: <0000000000000fa7b205ab0dc778@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 22 Jul 2020 13:59:59 -0700
Message-ID: <CAM_iQpXKJ2SA=pRFEjwAwLkR_bw-y7ZqnSoe3zPqJc-CKv09Xw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in __linkwatch_run_queue
To:     syzbot <syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git net
