Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6403E131F63
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgAGFgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:36:32 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:46680 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgAGFgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:36:32 -0500
Received: by mail-ot1-f50.google.com with SMTP id r9so1521480otp.13
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 21:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g4G2+9KohDaOObSuO5Pc+lXm4AZk8YwByEWZoUANwxQ=;
        b=Z7rTzJfvdK7dCntaSmKfJjkfsN49nq8CUHqBFFMGnIxurFpvDDIBhpPwHAUTxu9BWv
         HPCTq3ZiVJzHDMZT+uL/699tUZK5mJEtWpFuyIJxhTADrk7HtEFN9EWuEAnXQgsTvkrk
         uWq2LeKEceAlj7DbmVX2SyVJ+xxyBl9wIvosRamnOdEHuu8DqWB/9nC0w+ASG6JmOcpl
         508jkxGv71wIk/xqOl/8ZslycUrobTTu0t6V25+g5QtWqIOaHhT2Kix2LJRUNegHQTgm
         Tp9EuxcG+aU9W1GmK0y3pt8nQ6FpqzK+X/0jiVJUgFTChEL4Z8bKev0OYqg+961u0T82
         vomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4G2+9KohDaOObSuO5Pc+lXm4AZk8YwByEWZoUANwxQ=;
        b=Hffv05mDOSXOKlZZ0gm8Rsm9ddrc66eqoSfRfzscD0GyVDI3HDAo8OCURPyQcfApbv
         jEPgzkv2Fq+faAZ73KBSkFiAnFjHsHN8F/Eck60AKi2tXsFf8GkQ3o9SbpX/6rV+GVLQ
         f8YUS3SsmeleoHPgvEP+/VnfHYhPfTMAwjeAon+uDDn0CYgsjhWEyRKZgCn5P0XFar9O
         ZNeHiePldppQ4UrI1mLwhrB8Sk+0v8ijpetq/y7q0cN4LblEft0dcme3UBugEwuPwx9I
         Q18DRoiHwtd7+4XmPXMPwRs3y7jCTRy8/HZlBiv28A7p9DHIZhMG1OI3DXY4nFqQ0GDN
         znLA==
X-Gm-Message-State: APjAAAUYEUtiWwQ6hlfkAuaSWNajmUELx0XSsc/M/wh0hTm1i814dljc
        JpOyMdPs9V434P/Wsyp3lADrKKAi3uVYADy9of4=
X-Google-Smtp-Source: APXvYqxjd194P2jcATC2gFY4q+3SdDY/bUNdPLajogCf6QTeXkpesgZHyi32DsGKwV+YTQoUdJxpgWnO2+FGfAnLKoo=
X-Received: by 2002:a9d:62c7:: with SMTP id z7mr110171752otk.189.1578375391425;
 Mon, 06 Jan 2020 21:36:31 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
In-Reply-To: <000000000000802598059b6c7989@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 Jan 2020 21:36:20 -0800
Message-ID: <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Taehee

On Sun, Jan 5, 2020 at 2:59 PM syzbot
<syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit ab92d68fc22f9afab480153bd82a20f6e2533769
> Author: Taehee Yoo <ap420073@gmail.com>
> Date:   Mon Oct 21 18:47:51 2019 +0000
>
>      net: core: add generic lockdep keys

Why netdev_update_lockdep_key() is needed?

It causes the bug here because the unregister and register are not
atomic although under RTNL, fast path could still lock with one key
and unlock with another key after the previous got unregistered.

From my understand of lockdep here, as long as the device itself
is not changed, it doesn't need to update those keys.

Thanks.
