Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6E4DD16
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfFTVxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:53:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40207 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFTVxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 17:53:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so1934300pla.7;
        Thu, 20 Jun 2019 14:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=DLHGGUukVhqeiY5qE6jFUZPvsSTNd+ZgYiZGFb2Z2ps=;
        b=VfkJrOPNjSmC6BMgX4inVlnZBs2ZblhtFiPbHtj9edoT3tsjbspAk9E38qh2Z1iOUg
         8dtqUIh0/Jm90du50h+EJ72M9i8VyfMg+KHV5UA8KrtCbCV1JQpP17nJTVt87QKgjTNl
         fLTc52KAQl4DoqpkiFjCMgfotxB/empkq4M/KJToia9lO0gV5hogRwsSux5lH9NxUW1h
         iwIc1xkoVyFYnohaJSQ6OyUI8Q3MRN4M+8eRMAc2Hgz5InYno0m9WqwtkwuDhAtMsubC
         HFdPG1iqgEUR8g9sGRUFZ9svpt0k7N340zG2ECwScylrJtEbc5839vf3WtyjinvRN1Xx
         8uxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=DLHGGUukVhqeiY5qE6jFUZPvsSTNd+ZgYiZGFb2Z2ps=;
        b=R6i2vuTo1rJYP90dDo0Ak9LPTOPuAqUPD9RQgEjqKHKmk7TOGZ7IZP4U+mNcUeX53c
         PcsIvnkLFyjpXTPnChXMDnoQ9f5UX/GX7u92l+jbabzOoIc8OA4wqPvH90WAPpPNEH4l
         +8/SefvNhfxAdqDavFlALS5tfJRBgfGsmhg0uWFK5a7jxEoQqfGslcghi8CYafzUUTfl
         I7CM/CGrZhtdKmCym8d0BOnBa0iILUn9YvbLbs6a71hap2+gkr4Yv8F5543c3JjhSSEj
         0RD7DNOaOAUJftnJ+6b14EWft8RytaHO9CbLxdxezSFkir3+9dYzueUEhLsr0PsxbPNs
         TlTg==
X-Gm-Message-State: APjAAAVvmiImgSqekbySMDg5rrUkKISjPvcIBYM/QGj+5yStkRV2d6LV
        zpn4psav/Nuuw0cRVAdfeIw=
X-Google-Smtp-Source: APXvYqxkWMlc0z1pudI8uuMKEo3o6IwaJb0YwvWlR/93SU7f5z5GZUOSl/6eENrZhK9lh7NXXUAaPQ==
X-Received: by 2002:a17:902:848c:: with SMTP id c12mr125045177plo.17.1561067627464;
        Thu, 20 Jun 2019 14:53:47 -0700 (PDT)
Received: from localhost ([208.185.168.138])
        by smtp.gmail.com with ESMTPSA id g17sm447179pfb.56.2019.06.20.14.53.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 14:53:46 -0700 (PDT)
Date:   Thu, 20 Jun 2019 14:53:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+b764c7ca388222ddfb17@syzkaller.appspotmail.com>,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d0c006a1bdb8_1b912ac9b699a5c011@john-XPS-13-9370.notmuch>
In-Reply-To: <00000000000097ca41058bc129cc@google.com>
References: <00000000000097ca41058bc129cc@google.com>
Subject: RE: kernel panic: corrupted stack end in corrupted
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    29f785ff Merge branch 'fixes' of git://git.kernel.org/pub/..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1158d411a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
> dashboard link: https://syzkaller.appspot.com/bug?extid=b764c7ca388222ddfb17
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=100ca932a00000
> 
> The bug was bisected to:
> 
> commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Sat Jun 30 13:17:47 2018 +0000
> 
>      bpf: sockhash fix omitted bucket lock in sock_close
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135e8a3aa00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10de8a3aa00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=175e8a3aa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b764c7ca388222ddfb17@syzkaller.appspotmail.com
> Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")
> 
> Kernel panic - not syncing: corrupted stack end detected inside scheduler
> CPU: 0 PID: 8770 Comm: syz-executor.4 Not tainted 5.2.0-rc5+ #57
> Hardware name: Google GooglSeaBIOS (version 1.8.2-20190503_170316-google)
> 

I believe this is the same or similar bug to the others found with
sockmap + ulp running. Will have fixes shortly.

Thanks,
John
