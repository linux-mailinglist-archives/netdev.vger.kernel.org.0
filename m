Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0A71CE2D2
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgEKSbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729825AbgEKSbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:31:33 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E723EC061A0C;
        Mon, 11 May 2020 11:31:32 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g16so8075734qtp.11;
        Mon, 11 May 2020 11:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W9v2pHHx1D7eBpE4o9IR/Rkokec9q6VQtmrv8BGwFy4=;
        b=lFOPBOSgjwrfiEYsJxmcOzBtU3TsnFrsX0SanpVq7AKWi2aS5+Bo/6BGkHZpI0IMZ7
         3fAUoCSbaSTRT536jeiyZv/QsHiRJGHOyCi3o1u9AP2ju+gebzBz/3MXLDDmKtwWm8kQ
         C0I/4Z7fZg8cqqhwNoaVehtMaIqGEMPuiix89bMdfM7iK00GHOt0tPje0IzEsn6LXLmz
         /f4+qc5JJiZ/xI5HFJ+io+Thzm8ykSFwGfmhdFi/LL+JcFfFRQLnuh3uAd2rkpFpAqEk
         DZ/IE2VVS/80XerfS4EgEL0cQgsCY+RTrUJSNJwl4TiuJbW35v5/vyd/Y6nooFDCi2Tq
         0V/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W9v2pHHx1D7eBpE4o9IR/Rkokec9q6VQtmrv8BGwFy4=;
        b=MgTUPd2PALVYqnJ+uA7F3tKImpPqXgo4+R4r1fsfEUzzZO26Ok2fHSoW+tWSBcXF38
         8YpXLwp7VClhTig/sqCbZKp4DuNTWRahGgmLoiwG1h6X+MTzsrXEq/B6rLD/z0CnEXVC
         ZNKuhv1J8KzEbJnjH/iodhnr8YsH5fAIGjFVEwmV60GEg25LxcJEqyiu83eM9QKttvVE
         KR+BzKlfilwciqR4xVUtNVO5amWM3tiCTdkNLDyix2lnqxOPBG8nGwU9l7S0WzZMQXcO
         KaeGmYa3Pk4olm38js3XOUmRcOCUYP3YojdSYtVI4cQkAKB1iQgR9+30iCoukLGw9yI0
         2RMA==
X-Gm-Message-State: AGi0Pubvi7YdV5hTXDp8rXJ6uMhPl+W0dXJuZAyWVn17ysPm0IdskvFV
        McPCDTLKxAPc5BA88ZcySPw=
X-Google-Smtp-Source: APiQypLP6T/eno4QX23rLXt0O50+Eml+eh12wQ9eWizX4D5Zl+JIy3avs3yOTjCuVQQHSSRstqsHqg==
X-Received: by 2002:aed:3f92:: with SMTP id s18mr17838902qth.145.1589221891984;
        Mon, 11 May 2020 11:31:31 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.228])
        by smtp.gmail.com with ESMTPSA id x55sm10035452qtk.3.2020.05.11.11.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:31:30 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C9D02C5A09; Mon, 11 May 2020 15:31:27 -0300 (-03)
Date:   Mon, 11 May 2020 15:31:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lizefan@huawei.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nhorman@tuxdriver.com,
        pablo@netfilter.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        vyasevich@gmail.com, yhs@fb.com
Subject: Re: WARNING in cgroup_finalize_control
Message-ID: <20200511183127.GI2688@localhost.localdomain>
References: <000000000000e79ab005a56292f5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e79ab005a56292f5@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:21:13AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    a811c1fa Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ad1d70100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=43badbd0e7e1137e
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3c588100000
> 
> The bug was bisected to:
> 
> commit eab59075d3cd7f3535aa2dbbc19a198dfee58892
> Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date:   Wed Dec 28 11:26:31 2016 +0000
> 
>     sctp: reduce indent level at sctp_sf_tabort_8_4_8

The reproducer is not touching any sctp code and the commit above
didn't have any functional change. Not sure how the bisect ended up on
it, but this isn't triggered by sctp.
