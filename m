Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB3117E593
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgCIRU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:20:26 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37041 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgCIRU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:20:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id y126so10008524qke.4
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/ltngBYRTq01VJ1mavtyfY7YquNSfQ240OOdDMNjEPw=;
        b=lkN3y01M+jRbyXcB2PTb34TCdZkzqNCpr3kKRGVsbTTkmQCpclvMil0PXwAnoS7hXJ
         IHgdcbnWhm53FlGQg+nw2uV+Uv8AN36EuGK2iJ2reiBH2vBPtIYTShFayJ/hGx6U1LR2
         nsxMOTTqqYuosJEz6PJ/49jXPJ/EtVbUp1IBJo1y0BWpDSMGvwGHvMIQcYtc1Iiz71K7
         cEvrkldGv792Wd+HiWmspFBhqY2pMPueB54emrTEyyDmQfgjxjrn21aEG/z5/tdiQ+5o
         xSyBwtLHD3ajRg8UVKDvavghCUhfG9ljykYwmIoITTQABBWIc6DRgHqHa/DPRqWX54vu
         68kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/ltngBYRTq01VJ1mavtyfY7YquNSfQ240OOdDMNjEPw=;
        b=PskeMsOKyyr6BesRo2mPA+b2bCI92jUjQEaDmQ/LXKQDuCZSxApTWCAzbfeEhRyhsA
         WZVhlyYP5UkR3cia+5GoDaB9CzYXH3VB9byRIENuCC+/bNY2CVGz/XnhBehimSUR20rN
         qMlGoc+QsUQauet/CPI8FbQLXG9m/TRRT3ovxstCyNG6zcTRaewTgmQkQok9vatW8VXg
         3bgo16+JX1DcddHTcARdUzRJZRkzM3Yowqoz+CWjmVnmYp8yG1eosvoqWu8nPi+jwP2M
         jowAdLQGEz1HnrHN6sniLlLDQnNvFJVGxy41VA60nIqGs9IEGEGVC6PMzqa3uFGlpLVB
         lGEA==
X-Gm-Message-State: ANhLgQ3pjY48GeWxaXFWJ2y0IGrOPaHDRImTTwv8GE4tpFfUeCP9FAhg
        gXoY77s0NPmUxqyBcfmLyHnadA==
X-Google-Smtp-Source: ADFU+vuon4UvVQ0IcBAxERt2kYVbP0L54kTICvX/0VCM97k+xQUtNluXnTuD0CRyl2AanS/HYCF5Pg==
X-Received: by 2002:a37:7744:: with SMTP id s65mr14967669qkc.405.1583774424715;
        Mon, 09 Mar 2020 10:20:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d1sm22308790qkj.29.2020.03.09.10.20.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Mar 2020 10:20:24 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jBM4l-0003gE-Je; Mon, 09 Mar 2020 14:20:23 -0300
Date:   Mon, 9 Mar 2020 14:20:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     syzbot <syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com>
Cc:     bmt@zurich.ibm.com, dledford@redhat.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: possible deadlock in siw_create_listen
Message-ID: <20200309172023.GS31668@ziepe.ca>
References: <000000000000161ee805a039a49e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000161ee805a039a49e@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 05:25:10PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    68e2c376 Merge branch 'hsr-several-code-cleanup-for-hsr-mo..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c92e91e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e519c35f474a428
> dashboard link: https://syzkaller.appspot.com/bug?extid=3fbea977bd382a4e6140
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com

#syz dup: possible deadlock in cma_netdev_callback
