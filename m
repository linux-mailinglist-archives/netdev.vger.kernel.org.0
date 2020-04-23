Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A6B1B5224
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgDWBuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgDWBuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:50:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F373AC03C1AA;
        Wed, 22 Apr 2020 18:50:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o15so2085768pgi.1;
        Wed, 22 Apr 2020 18:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z7gWbuAnr8CK6KNx2ejzTsMEdH7Upetnyr+8IByZM84=;
        b=bgzbAfscPUAF9vCwGPvYCa44qFv7Bl70Nl5BLgqJnYOKy7ikPQz/0Z7QoR6DqsROKd
         fB+eRLie89f/baKLTnhg3hjlqttSBa5J2RgecIOM8b/LSZVn8p7CeUkBTfM9KWls8vAC
         GtiWjmrvZUIugTQHYJJGXzOcEi6NYgoWx1Fhy6v42l2IOfO57WMxxJEMD783xYbSf76v
         s1bKZEMCW9WctfEsLym/NIoAuvAF7Fm7qE4T4G9nu/LGUBIDnq/Zo2dKV0rXrlMv6RZa
         R68IbHc+P09WlhTYvSUItTR9G5Nr4cug1D3RUy3Jk/EPjUQGBDxmhV8E9ZqRpIQpXx+M
         3iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z7gWbuAnr8CK6KNx2ejzTsMEdH7Upetnyr+8IByZM84=;
        b=ZEluFXdKtk7KeQT3AW6MX+DuDCNmYgS+cJ1j2qlfqyM1EEOjOII4pcYxEA8zbjbiiU
         8QWElBLGkRk7Y0o3tzOvDOWivBW7HZj/1Lbp+4t6dDEfzt6qZK8KZvO40Kz23NCBymwe
         Np+osCAf6yH+RbdQTUHwTyLaFxwB65RXD7ggDqbns4MBHKAnVvruKSC7y4zYL69bgi5l
         P8jydY/coWWDCzgEHpkASUDkYWtKlqD7CgFydDB0AYSd8CdTl1Z8eb/0cB3WiiaTHe6y
         sbM8f5PngWKzbJYjjAoqE4VfIdVKvgnq1sWzEnj5RjW6ZQMwbERGxPaUmky8rNAaEhtW
         CcEA==
X-Gm-Message-State: AGi0PuaOeyVJxJRQji1RrDp5QTTVOZl4pnybRSEAu1YC9AsStJQqY+lm
        zx9KaF5w4VS+46n5oz2eFSs=
X-Google-Smtp-Source: APiQypJKsmu9hDA6l2N4TR1Hxu+bStcaQDcXy36MyqvZOoju1yfHa4mJdaAmx3ZY3iBx+RTsvZXqQg==
X-Received: by 2002:a63:5112:: with SMTP id f18mr1790082pgb.356.1587606611346;
        Wed, 22 Apr 2020 18:50:11 -0700 (PDT)
Received: from localhost (146.85.30.125.dy.iij4u.or.jp. [125.30.85.146])
        by smtp.gmail.com with ESMTPSA id q201sm850299pfq.40.2020.04.22.18.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:50:10 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Thu, 23 Apr 2020 10:50:08 +0900
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+1c36440b364ea3774701@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        James Chapman <jchapman@katalix.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: WARNING: locking bug in tomoyo_supervisor
Message-ID: <20200423015008.GA246741@jagdpanzerIV.localdomain>
References: <000000000000a475ac05a36fa01e@google.com>
 <5b71a079-54bb-57a0-360d-33fce141504f@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b71a079-54bb-57a0-360d-33fce141504f@i-love.sakura.ne.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/04/17 13:37), Tetsuo Handa wrote:
> On 2020/04/17 7:05, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1599027de00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
> > dashboard link: https://syzkaller.appspot.com/bug?extid=1c36440b364ea3774701
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150733cde00000
> 
> This seems to be a misattributed report explained at https://lkml.kernel.org/r/20190924140241.be77u2jne3melzte@pathway.suse.cz .
> Petr and Sergey, how is the progress of making printk() asynchronous? When can we expect that work to be merged?

I'd say that lockless logbuf probably will land sometime around 5.8+.
Async printk() - unknown.

	-ss
