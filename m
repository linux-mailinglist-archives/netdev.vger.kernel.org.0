Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07EDE754C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbfJ1Pgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:36:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39815 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfJ1Pgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:36:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id t8so15174376qtc.6;
        Mon, 28 Oct 2019 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X/AyUl2apR1iCfwj2kG9abOusf6OXMfXucKK4+wE+uQ=;
        b=KsoHc9+W6GrxaU4WH0NzZ7G6kzBg0b0z8dTYFiJ4Wg3ccWBwvIqmsbRc48h8ZesB7j
         GpiB1D67APHsIL5nBr4bq1cywQUmlPqkfGUh5p5ilesffsd+dYKo2qdrSyjRtLqiKZX2
         tm8TISpGQdaGd7p7iKWBYNq+ksjvRS0kmrOFmQ40RMBTjyAsUJwr178a3JgtJ/KY+Don
         piZK/q99/KgWT3WCe6O4zcoastXxdlTkeaxN5HPIRzCRv6a0jgtfYW23ibGIGozBNkU8
         nH53xNYApd8jZeUifEm2vNdG4HJ/EgT6aI2IMte5HbK1Yj2pRxY6XziFLN9YxiZXDnQs
         +15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X/AyUl2apR1iCfwj2kG9abOusf6OXMfXucKK4+wE+uQ=;
        b=sh0gCUpto9CUSDSh8ccehb7QvX3Z+ZPCezkrsHRoCY9KARz/ucV2Vr1uCHkUqKXZm6
         GNhydT1hYIe2ua5QDIy1zTc/84UwwjVWgWKvjjDY1UIvzf3GtRTrRUBsDd/QR2UuP8lQ
         Gh5dsnxjmHvWWibZ2Ts2INwIFpj9FjpAVqxtcCD8WLe+DCUvCL48qKtEPw56zUpFxxb3
         IeJxFWGdGIHRAMVLT0ayQiI7c65+5ixyp8tpSnjG1yXkl8n9jtM6QNUjhfZfK04Fkz+9
         CZC5KR7CI9C2ICG7qIV84ZltUCQZ7o4I+oyVKcjkUQOcxoF1Ntz+Dyb/seR/+R6O6JAX
         f/zA==
X-Gm-Message-State: APjAAAXfVHEsviHQMaTpaRBQmkN2vApyBoPZqr9aE6Pwi2J9fPltnHUV
        fxiaAoAUgryZ7Mt2Hrqd+oQ=
X-Google-Smtp-Source: APXvYqymZABOv21SsYV9D8JTRdSkOnK9lkbnddolPIkUK1UpDSlv+qwInskpJwT/9VwSwKc/EEJcUA==
X-Received: by 2002:a0c:f851:: with SMTP id g17mr16291522qvo.157.1572277011591;
        Mon, 28 Oct 2019 08:36:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:326e:3cb7:46e:7f5e:cff5])
        by smtp.gmail.com with ESMTPSA id y186sm6327995qkd.71.2019.10.28.08.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 08:36:50 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6FE69C0AD9; Mon, 28 Oct 2019 12:36:48 -0300 (-03)
Date:   Mon, 28 Oct 2019 12:36:48 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+e5b57b8780297657b25b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, roid@mellanox.com,
        saeedm@mellanox.com, syzkaller-bugs@googlegroups.com,
        vladbu@mellanox.com, vyasevich@gmail.com
Subject: Re: KASAN: use-after-free Read in sctp_sock_dump
Message-ID: <20191028153648.GF4250@localhost.localdomain>
References: <000000000000e68ee20595fa33be@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e68ee20595fa33be@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:32:08AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    d6d5df1d Linux 5.4-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef5a70e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2bcb64e504d04eff
> dashboard link: https://syzkaller.appspot.com/bug?extid=e5b57b8780297657b25b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cd8800e00000
> 
> The bug was bisected to:
> 
> commit 61086f391044fd587af9d70a9b8f6f800dd474ba
> Author: Vlad Buslov <vladbu@mellanox.com>
> Date:   Fri Aug 2 19:21:56 2019 +0000
> 
>     net/mlx5e: Protect encap hash table with mutex
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135960af600000

This is weird. This mlx5e commit has nothing to do with SCTP diag
dump.

  Marcelo
