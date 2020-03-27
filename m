Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1875B194F52
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgC0DAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:00:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36702 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0DAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:00:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id j29so3912118pgl.3;
        Thu, 26 Mar 2020 20:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A8L7pOMKHT1Fvn5n/xgz4DQpKiNCVTukpmYePSYE6CA=;
        b=jdziiDbOCRXE/h3X1N2+SYeOkyOd1+KTWjqMa2AAHQTHsjs+KoftS9aj3xlXb6pS6V
         bWPW/wxneFZ72Y6kohjVpzXIFTvGqIsa89E9Eqd0nmhKUhBIx/FCFOGFZ+3AGdNcXbP5
         zLy0BBZBJ2HVIIuVWjQc3cteOn0OXEHcCcrtcfHKvcMPK3EPrBHgpFAkvocEGkhfEL6c
         0onFQCYH0bY3DxyYIoikAymiLVNxoJoMKkq+GqHACZ9/tDZ6azla5gVCXH2LtBfPUi74
         lSeMGHXHZ5b6nXL4rdImITz/57+4OUucv5+rkgsv6wXVC/Mfpo8tOo95LaixJtSTbQBx
         Ld8Q==
X-Gm-Message-State: ANhLgQ1iO1J7MZyn10JjPyPNN14fuBdJiZWNgq5MfO0ymM5ntV9mXF38
        wkZhxOdCg2viEC0Wq4GXubc=
X-Google-Smtp-Source: ADFU+vsvK0eP4Uqeyd1/ByCifUDiaGERpiXtrwFTIu/opIyVLOq497xPOF0F6FhTPWo15KgCVy2gKQ==
X-Received: by 2002:a63:f454:: with SMTP id p20mr11997394pgk.149.1585278017059;
        Thu, 26 Mar 2020 20:00:17 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f4c2:6961:f3fb:2dca? ([2601:647:4000:d7:f4c2:6961:f3fb:2dca])
        by smtp.gmail.com with ESMTPSA id f22sm2727805pgl.20.2020.03.26.20.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 20:00:16 -0700 (PDT)
Subject: Re: KASAN: null-ptr-deref Write in blk_mq_map_swqueue
To:     syzbot <syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com>,
        a@unstable.cc, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dongli.zhang@oracle.com,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000004760b805a1cc03fc@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <60bb3266-03fb-acfc-d285-b0249bb5e57d@acm.org>
Date:   Thu, 26 Mar 2020 20:00:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0000000000004760b805a1cc03fc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-26 18:28, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 768134d4f48109b90f4248feecbeeb7d684e410c
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Nov 11 03:30:53 2019 +0000
> 
>     io_uring: don't do flush cancel under inflight_lock
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14233ef5e00000
> start commit:   1b649e0b Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=16233ef5e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12233ef5e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=27392dd2975fd692
> dashboard link: https://syzkaller.appspot.com/bug?extid=313d95e8a7a49263f88d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13850447e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119a26f5e00000
> 
> Reported-by: syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com
> Fixes: 768134d4f481 ("io_uring: don't do flush cancel under inflight_lock")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


#syz fix: blk-mq: Fix a recently introduced regression in
blk_mq_realloc_hw_ctxs()
