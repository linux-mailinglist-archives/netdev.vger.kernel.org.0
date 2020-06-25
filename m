Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EDA2098E3
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 06:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgFYEF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 00:05:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33085 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgFYEF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 00:05:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id f9so2434019pfn.0;
        Wed, 24 Jun 2020 21:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Th1ySPu0Vm274TN6hS4pYdPss9aQtC2GIfpH8g+Qzs=;
        b=RxkC8utxMw6EqGOS2bPtf8wyREkELqj91izZXOqlHjEn18eIEolo5j5CrJyq89ccNg
         7b1e66bfYU4+i7T77VgH2D4W8GGWavUpPOe5HUhpruAnG6ql82G9wZbbBCOL4hO1zl94
         1PkW92Oxz7/lgiswQJnhS8JXy97Wwfj4EMQYbNDu31uP+qfyIpxdA3VD0d0CwEjaiRm4
         MeghExZCVhKHKA9wB1Y65+n2BtoPhBbQDLq3f9pgtao7soUGL3ji6mwTpJ9fVdMLQeB7
         moQHSCM9y9bqNFZH91SceYW4YVg9ZRpL6rXwJJ1smskYIVVy81aQqzBOGh5UIirj9yzu
         HRGw==
X-Gm-Message-State: AOAM530dX9fTmXx92oEGhGn+1yLr8LeAXU3mJkVmUYbtBczBiseS6kGO
        nLfLV0vwxp0GPY3kcHyvIzFtdX4z
X-Google-Smtp-Source: ABdhPJxbOHJBWsjgXqqQU6Bl8VHVLy3W1i7Ax0RG7BuEn+J/+kc6Pv3a7NobvWQt0Scp8ScAE0lFXg==
X-Received: by 2002:a63:1312:: with SMTP id i18mr24938054pgl.142.1593057955042;
        Wed, 24 Jun 2020 21:05:55 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g140sm11384273pfb.48.2020.06.24.21.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 21:05:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: KASAN: null-ptr-deref Write in blk_mq_map_swqueue
To:     syzbot <syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com>,
        a@unstable.cc, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dongli.zhang@oracle.com, hdanton@sina.com,
        jianchao.w.wang@oracle.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000006e0ff05a8dfce2d@google.com>
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
Message-ID: <b30f9b35-1504-a8f6-91cd-828e56c59eef@acm.org>
Date:   Wed, 24 Jun 2020 21:05:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <00000000000006e0ff05a8dfce2d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-24 20:01, syzbot wrote:
> This bug is marked as fixed by commit:
> blk-mq: Fix a recently introduced regression in
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.

#syz fix: blk-mq: Fix a recently introduced regression in blk_mq_realloc_hw_ctxs()


