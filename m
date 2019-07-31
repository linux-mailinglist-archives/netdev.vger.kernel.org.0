Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AFC7D180
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfGaWrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:47:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45318 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfGaWrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:47:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so63293345qtp.12
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mvHjIX1uETmKrf65GxFOMFRsSWX5lIF6LRU3P8/k6+A=;
        b=Anx9+7HbDTku25fwvipty5007KkvXfUfQ99I/9ymi8/C+5tgq0+fqH+ESHDJa5LQQn
         Nhb+HRDiuzm2jlaQUbug3kbBnW9oIiEy+Tdh8Xo5p93buxuOqTJpQBRTiS6NW7NBed4e
         7uEm/qD6l15bMXpx+3emqeF2MIEDiCDCIKIb1jLOwU521e6QthwKGaQym1C9uSI2aYkc
         QIjLgDhmvm2g0T1BQpEcdKlGbyUmoD0Kv9arJfgiYt8RAUvnYP4E1oq805xDVJ65h7ow
         /WY0AqlB0L+dcY4QewRIJhBf0aDlTm6gDdM00CbZyeGURz+EIlY2oYQlzznig4HOlRAO
         J6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mvHjIX1uETmKrf65GxFOMFRsSWX5lIF6LRU3P8/k6+A=;
        b=ZFfGJFEqFMFlk77x2ItJbltlocahGV2omsZKJz1OpL50mOpu1XfOSRCgnVdAi163+H
         pR4WsO7uizvUmLuqIuEnfXHzF4LveQDWbQLo8ai52SJlZJ6MDl4frqZ6tXyN/wxtBLPB
         PlCDkgfFz8v3WTjoHXA2sri7YdPcmG7Ve1mWedSRCjxx2l94iHhBDgDoW2TJNPziW3ee
         1V9w02Z21ufYpXDL0zMk1gW8XBc3s/KW8H5vyQgQ4twU60u+9x1F26Xos1FJg0zmmj9T
         cA80S/jm7KU4OYDTaOA+cXPJVX5X/Z80XSQZzL0MDOsQaIdXYG5TGrG8MKJnp0FjDEaK
         HUJA==
X-Gm-Message-State: APjAAAWkNMspaZ+yCalTpyJ4duMNw220LJH5YCj9Yz+LpLa0NwIN2Xnb
        4/eDFmRb5UPeFS4N1JqBFCA3pQ==
X-Google-Smtp-Source: APXvYqwv6haSpTRkt0688fF5HFjqhLzpi63KUyext499GmsFPsTqU/DaoI5/SvZ2OI6nb8Y+Z/XmDg==
X-Received: by 2002:ac8:6b50:: with SMTP id x16mr89322591qts.246.1564613225939;
        Wed, 31 Jul 2019 15:47:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n93sm32201850qte.1.2019.07.31.15.47.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:47:05 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:46:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+f5731e2256eb5130dbd6@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: invalid-free in tls_sk_proto_cleanup
Message-ID: <20190731154650.3766622f@cakuba.netronome.com>
In-Reply-To: <00000000000010fb45058ef5eb52@google.com>
References: <00000000000010fb45058ef5eb52@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 01:29:05 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    fde50b96 Add linux-next specific files for 20190726
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ea7f3fa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4b58274564b354c1
> dashboard link: https://syzkaller.appspot.com/bug?extid=f5731e2256eb5130dbd6
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f5731e2256eb5130dbd6@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: double-free or invalid-free in tls_sk_proto_cleanup+0x216/0x3e0  
> net/tls/tls_main.c:300

FWIW there is a fix in the works for this and all new TLS issues.
I think John and Eric didn't have time yet to look at my theories,
so I'd like to keep it in QA for one extra day before posting.
