Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C878F102D98
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfKSUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:30:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46387 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:30:56 -0500
Received: by mail-lf1-f68.google.com with SMTP id a17so2090393lfi.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 12:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wCWUP4nsPFpz4ebNMTaxnSeR5azYfKwgQEC7LGtc9Ro=;
        b=sZDxSTw/eubFaof40y4LEdQUweSWV1azNAtrOfKs3XT+lxuGKRp+g6ygnYXejcaw1s
         qd+c4UeupGW1cGhdaiFgcNcVVHO+pTSyLxUrdH5OIpkxC+lOKyx8BuRxX3Bp3dVliUOu
         UViXkdw9gHrFgany18DhzKm3puYOT50gzUSQR1oEXkBLiycbdUK1aC/NlMxXXCSSW/qp
         6E2jwMbq9NuPNZZYrWYPMVqbscMqY40xzqrGNS/Imn93if5GtlNAYL934CDJG1eRj05J
         LKKhaIBGPIfgfwS16MWko5Gw7n7JVjCzbOD1ZqKnu8buV4xC76oFjUxYT5JsEImxCzEd
         Ba9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wCWUP4nsPFpz4ebNMTaxnSeR5azYfKwgQEC7LGtc9Ro=;
        b=hmD4N5VLgQAUpJkTKurF5Y0BTmLqeyX53a68Ji80twUCHxhb7iP7Msf3TehnJouxD7
         6OW0JFW4Y1tdBTnbnjSzM3kTk9DIYYw53dbdBTkd1WTa0Nj7G7jOeGd28Uzp/sXFKdQT
         X7pnQFTZ1QCM6gj3CJnFeoE6onxHIL8PWhZz5i4d8yqhPoKHL+r1ERjapdZQw88dD6Zf
         gJRHXT6fBYsMhbOt71yTUK45E+PwWzmMviuws39GAwQ+TMqAD7xBD1I0ekZQtgXoQg6Q
         qesvlgDg3HwcYb2gLFAvFKZZAStJjbp2EeBsoYsBsK4SpsaD2j2ktXQ7MPoRMv9Vpfso
         1ktA==
X-Gm-Message-State: APjAAAU7y/x/w3SC+ANyCSosln7DB4xpi+nGplNK4szH82BDHeMsLgId
        nnnSX6u2SjlAN2fxszWuu8cO4Q==
X-Google-Smtp-Source: APXvYqzDcSfLLPaK9+X5fFpIdELQY5X63VgL22V4nzOQwVLKN4mV6uRSB/eF5Ne/6ncsDa1nqRxCdA==
X-Received: by 2002:a19:6d19:: with SMTP id i25mr5499270lfc.178.1574195453931;
        Tue, 19 Nov 2019 12:30:53 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o26sm11014983lfi.57.2019.11.19.12.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 12:30:53 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:30:39 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [net/tls] kernel BUG at include/linux/scatterlist.h:LINE!
Message-ID: <20191119123039.64dca58d@cakuba.netronome.com>
In-Reply-To: <20191119045707.GI163020@sol.localdomain>
References: <000000000000f41cd905897c075e@google.com>
        <20191119045707.GI163020@sol.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 20:57:07 -0800, Eric Biggers wrote:
> On Wed, May 22, 2019 at 08:58:05AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    af8f3fb7 net: stmmac: dma channel control register need to..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17c2d418a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=df0d4ec12332661dd1f9
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b53ce4a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b0aa52a00000
> 
> This looks like a TLS bug that is still valid.  Can you please look into it?
> Here's the same crash from net-next today (commit 19b7e21c55c8):
> https://syzkaller.appspot.com/text?tag=CrashReport&x=16380c6ae00000

Thanks for brining it up, I should be able to get to it in the next
two days.
