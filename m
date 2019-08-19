Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA81794FCD
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfHSVWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:22:36 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39480 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfHSVWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:22:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id 125so2740098qkl.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JZfnugbxFKCTAgX+SjmyKnBq8tPs87PzkM/zsjKaKXs=;
        b=t2etDunKLVvaysLK/TNub3QpKwtT4cFCQCfHd9vvxIgKfDZjKWYMbSiYsYRH35RRfl
         9uxiUc/gwWrsfQyYaXM0u1JhKO11aHk26NcGcm/b7yMKH73hCOI6buoqxBYWuLhNtoHk
         Zf9TN0GxNnumlUwakWO8Z1FldAuHyvCGu2BrVuGilsAlMAIzuolQUoiqZjgTp/fjaNAm
         lLmftRN7ITeNtX3tx8eEaJ48n++74EzDq0rwORG3/BuUQd60rG2zCaOFQO+fbUaQvxfV
         8oVldt8aJB+e0PLlkSR51RzhqVnXMLB1GJbRAZjgpemE4gOTc39am6EVgMAaTKjuXSmI
         nTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JZfnugbxFKCTAgX+SjmyKnBq8tPs87PzkM/zsjKaKXs=;
        b=q84Bw2QpxXBngnVVTqFj0wrSMM1fFNm+chfQYyueqU3uOy8XiewtQZY2PjVtfmfC8u
         9eMpRMF1wuT1mSZqqnat25eWY8G6tLz4zyqwkqzSE558NaLBXC4dTw31N9YWAzGX2aq0
         68cqaB/HfA2QWqHKE6NY6tOmqfqHv+Lo3CkJWJllO8/gWkj0wBj09de9sTGW6tRTiNWN
         Xsq9u8evb9a3Zp7ISvqMdqsBQLGtiTsVC8san1dyaMILwYeAH1Je82AvTOl3WyreyyB8
         L6Z1eyq4AGdk25yqstEKb7Xeq67UYJLKlsXBxfgL5zOTAX7s5iBCzlPhOAR3tZhHY9CM
         75fA==
X-Gm-Message-State: APjAAAUoE6dTZyc9pCVBm8DA0SltIaaEEUvExfX1l3pli5CxqZwOxBpY
        rkTnLgTTDHZYZ1yRgg+WAmJC1g==
X-Google-Smtp-Source: APXvYqyaNmv5f50iHHb4AgzgUkp5/W7VElduaBFjLTRBrB81HRfAVa2X0I3FLvhENFGsEqGFoRSBAg==
X-Received: by 2002:a37:624b:: with SMTP id w72mr23962001qkb.368.1566249755012;
        Mon, 19 Aug 2019 14:22:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j78sm7480621qke.102.2019.08.19.14.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:22:34 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:22:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+12638b747fd208f6cff0@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, davejwatson@fb.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in tls_write_space
Message-ID: <20190819142228.7f37bfcf@cakuba.netronome.com>
In-Reply-To: <0000000000000a5b840576bad225@google.com>
References: <0000000000000a5b840576bad225@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Sep 2018 16:54:03 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    bd4d08daeb95 Merge branch 'net-dsa-b53-SGMII-modes-fixes'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=110b6a1a400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e79b9299baeb2298
> dashboard link: https://syzkaller.appspot.com/bug?extid=12638b747fd208f6cff0
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167d9b9e400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c4003a400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+12638b747fd208f6cff0@syzkaller.appspotmail.com

#syz dup: general protection fault in tls_write_space
