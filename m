Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A2E2E82C6
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 02:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAABjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 20:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbhAABjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 20:39:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0AAC061575;
        Thu, 31 Dec 2020 17:38:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id lb18so5595575pjb.5;
        Thu, 31 Dec 2020 17:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jq908JEA6FJmQvAL4fJ2h5ZQ8LT4JDgfWpaEXTfjrgk=;
        b=ILwlOgDbm1Ty8COhZrZF2/yLoEQSlNnphDtiHd1SKlImeKPzDXWUopeSADfhznPgUQ
         8zvbUKtoUGSuZ03T4sKszsUWeNSSk36E2YSNU7XjpJ8S7cRfYadecw4grpXecM4gCloR
         YQPq/j7KkhbYU+hhLq+S22LAQQM2aMsiNQk4H76QqFEoL991HLb0mrygUKxZUG/LYZeI
         BXrhPUjd4x5RmZybcONpqJ8/4WUA1BfJli3I2cPkf3foLlAHhxvZmGtwEuWmUih5uLQT
         IhUjUtE5VEYXDYvHETdhxFfsHo7P80qM/qBnT4ghxQqcKTPYUvkqrmSYVnrr+gDEAwum
         p4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jq908JEA6FJmQvAL4fJ2h5ZQ8LT4JDgfWpaEXTfjrgk=;
        b=o9Hin34Wvb+jzJ+ipFnlo16JGti3zh+ySATWJvuZg0G5HWNOoBonbZdhhugolM4Eo0
         2YKlzRDQoaJQXIPrsgrmFEwNPCp+qhtB1M/lua9IcI2hSJeqQdut7I1ALlLqkW/9wWPi
         Y06pjNjVLYboc8a/zk0rlqen5mowqrPeHI7+NYywUdYxihPsB/DgfZtwzY6g0A9e1wh4
         o1I5KiXqZQ+VnDlAk8RSTRmCxxHBmcq2mlDb57Zq6X6YA85dBC47tE5mqPemXllKP61C
         APt+PtAL5IIgFDjiG1C4gg7Kalwe8sVOpgzHJ6647ZWDq27Cu0sIlwAFE01k30+rBdwQ
         o7MA==
X-Gm-Message-State: AOAM531wpd62v5BV/OWTNWwcGqEDKViC4blXmZXNVH+NXwqR0TIwd3Oj
        fWBQwSkXPbfRmokfms9HN2s=
X-Google-Smtp-Source: ABdhPJwDaMKpQ8tVVkYqah4YyKSOYEfJUgIZSwTzaFLVsU/1nbDC78p9K8oiO5VCOT5rpf33QE+ljA==
X-Received: by 2002:a17:90a:470b:: with SMTP id h11mr15438318pjg.186.1609465106406;
        Thu, 31 Dec 2020 17:38:26 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:d2c3:2203:46f1:3e3e])
        by smtp.gmail.com with ESMTPSA id z11sm11836055pjn.5.2020.12.31.17.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 17:38:25 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Gao Yan <gao.yanB@h3c.com>
Cc:     paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove disc_data_lock in ppp line discipline
Date:   Thu, 31 Dec 2020 17:37:44 -0800
Message-Id: <20210101013744.72562-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201228071550.15745-1-gao.yanB@h3c.com>
References: <20201228071550.15745-1-gao.yanB@h3c.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In tty layer, it use tty->ldisc_sem to proect tty_ldisc_ops.
> So I think tty->ldisc_sem can also protect tty->disc_data;

It might help by CC'ing TTY people, so that we could get this reviewed by
people who are familiar with TTY code.

Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:TTY LAYER)
Jiri Slaby <jirislaby@kernel.org> (supporter:TTY LAYER)

Thanks!

> For examlpe,
> When cpu A is running ppp_synctty_ioctl that hold the tty->ldisc_sem,
> at the same time  if cpu B calls ppp_synctty_close, it will wait until
> cpu A release tty->ldisc_sem. So I think it is unnecessary to have the
> disc_data_lock;
> 
> cpu A                           cpu B
> tty_ioctl                       tty_reopen
>  ->hold tty->ldisc_sem            ->hold tty->ldisc_sem(write), failed
>  ->ld->ops->ioctl                 ->wait...
>  ->release tty->ldisc_sem         ->wait...OK,hold tty->ldisc_sem
>                                     ->tty_ldisc_reinit
>                                       ->tty_ldisc_close
>                                         ->ld->ops->close

IMHO an example might not be necessary. Examples are useful to show
incorrectness. But we cannot show correctness by examples because
examples are not exhaustive.

BTW, there're some typos:
"proect" -> "protect"
"examlpe" -> "example"
"that hold ..." -> "that holds ..."
"cpu A release ..." -> "cpu A releases ..."

>   * FIXME: this is no longer true. The _close path for the ldisc is
>   * now guaranteed to be sane.
>   */

>   *
>   * FIXME: Fixed in tty_io nowadays.
>   */

Since you are removing "disc_data_lock", please update (or remove) these
two comments. Thanks!
