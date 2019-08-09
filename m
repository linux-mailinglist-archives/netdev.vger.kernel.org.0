Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9687586EC0
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404989AbfHIAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:20:45 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33710 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403901AbfHIAUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:20:45 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so1792988qtb.0
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SrXlbID68lhPKrJjkmbTtajZDQHFU0j/ynkOO+lAohM=;
        b=Yr5u2Vmo96zfWo39ki7h7j7HCO1EXUDceAcYfoQtM5RXkFFvJypKjsEjKiv8bUFEWd
         ndb3UqgQdVG5d7QyqSo97A3i3BPmPoiVELQKMA1Y2j3qmge4ZhPji+1S0lPqrtEUxiaC
         MbJEyrANZe7MemMD0mDcPUlws7G4xTK/eXmUhFky1OS2l8RttkA2unobufRTaXikM86m
         JjgluiH74qu/c0dBiWmCgueiRclbh5xeau3N0NtY+U7uiSmXweWXVGnCuN+OF9hJPCKc
         eD4NnaKttNVkM6x4t06CaMZP0P0/iCI3pMHsvmGwzS1YFDZ6jZEsfV2a11ncE5Ojd1jU
         fVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SrXlbID68lhPKrJjkmbTtajZDQHFU0j/ynkOO+lAohM=;
        b=Zy/5ssgEfOv+8noBisLrw1U3drIlJ5wfwQULGMR7h1LdVoBu+adMSJz530vEXwdTKm
         S6RRRBO6DJmFKr87z99/yvkK4nnoqCRr9yBEy9PJF3vp9VPjyi6mcIkXCIWklg6HqQvS
         YbwOdD1g9vmQOU8X+XiYxanJzdz0QIwN1CWoNSBvN/AWDvRkUCR2Ufg3Cn6qkDaM0aSu
         JZwKPdBveMSeyWi7YlbsVx7/fqAW9jD3K9pJlmao0QHv4NGA8VZh4SqSJ05wvlZNP95o
         kHtZFtRUEhI0j+w/PH2uhmswLMB1Fbn+x+aNUyaKgvdxQGAHSRIVvoQ0sCAUauKXyaL1
         3X9g==
X-Gm-Message-State: APjAAAWoPfeNVY1uY7hfFuCBycSrBs0uIOERkgPI3IcymXR85lsn4YsV
        t3+SDZP8IvyBOd2Y9tSVpB7Z1Q==
X-Google-Smtp-Source: APXvYqxXRpoNHsJzyfCUQYdj2V8c2KZTPv3rU9ocRemD+2B0qsEHSJiuOKcias/L0ujb0D4xLA65Pw==
X-Received: by 2002:a0c:8602:: with SMTP id p2mr15734769qva.111.1565310044622;
        Thu, 08 Aug 2019 17:20:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q17sm37509666qtl.13.2019.08.08.17.20.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:20:44 -0700 (PDT)
Date:   Thu, 8 Aug 2019 17:20:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+30c791a76814a3c6c9f9@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: KASAN: use-after-free Read in tls_wait_data
Message-ID: <20190808172041.282a755d@cakuba.netronome.com>
In-Reply-To: <000000000000262820058f9dc474@google.com>
References: <000000000000262820058f9dc474@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Aug 2019 09:44:07 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7b4980e0 Add linux-next specific files for 20190802
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a749b4600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e1348afd44b5e02
> dashboard link: https://syzkaller.appspot.com/bug?extid=30c791a76814a3c6c9f9
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+30c791a76814a3c6c9f9@syzkaller.appspotmail.com

Also old tree, pretty confidently I can say:

#syz fix: net/tls: partially revert fix transition through disconnect with close
