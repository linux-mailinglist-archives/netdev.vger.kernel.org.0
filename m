Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC8210120B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfKSDPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:15:23 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:35723 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfKSDPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:15:23 -0500
Received: by mail-pg1-f172.google.com with SMTP id k32so4913702pgl.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 19:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bH6OLsChq8B4WKZCYOfbbfHHWXx5dkcLTpl8Z48ELMU=;
        b=obijPTVfPqbQjXb8wUyaih7dcb6kS+xNNWHqdnXMjVNeT1lcYOCBOpyxgxorkDBHvn
         52yXfwMHEdrjKBQqD/PZpLZf89S6PrZF8AKptIXTtlkjVMwLRRwa/rB2wlILsWAZrmJU
         VqcGRPjmMU7IChjMma2IJNz7RsrozxK95g+XHnPhyi1qPT+D/RbOlahyxJ9g+6eNoDKQ
         APbpkdpBCxg52Ud5pnv/6IwqPJcEr/X4ZNk4IliqiSxFFjLhkuML1heqKWIztz0UYeq6
         WepOivB5v6/3HSHNnc5M/LLE/HCZtlkFdR7SDsX3Lpz6x7YORZ0d2WK56btNP7gUHvpS
         L7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bH6OLsChq8B4WKZCYOfbbfHHWXx5dkcLTpl8Z48ELMU=;
        b=ikkZYDG4XiEKdlqb5tGMqvIvSuiPPZqJCa9ivX3HOvbuQtKEya2/IWuEL/9kpRmIRi
         gzmL1lXOWZ1pkLPv9UK9dIXF+Jml2hJiRznAKj/VDs2TssnI4pHxiNb/QENZrK5nOl4R
         xEn+MS2eOEE8/UMd5MKooX9vEewOEwzEH0rrQVVFWWhMfRwvb7g5GOiElUnwdWfhesuE
         AtK1mSWQ8bMzhEWsgIuGaIbl/IGoG64ljLZ1Zcxd1opnaQfEsCTJw7+VycAAT3+RV4rt
         zPATOhILFMILMbs1eDDbVigDn9T3CBKVdmGoWIuvhL8fjwWqiLcSCcdFIPk+cy1UBDEV
         /T1w==
X-Gm-Message-State: APjAAAWS3lEKlGlF8yfHrKu35cYaVGdx8CA3nMzhTfJD4gTkxbmSeGl9
        sWhubv/m3sjStDESCNEjReWxBw==
X-Google-Smtp-Source: APXvYqyiN/c0l7XM+isQKPQTt9x2vwfNw9PIhgFIu/fFIV1jIOFt0Uko/Pd18EjD1a52tcohw6pFSg==
X-Received: by 2002:a63:f716:: with SMTP id x22mr2927463pgh.351.1574133322366;
        Mon, 18 Nov 2019 19:15:22 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id 23sm21319175pgw.8.2019.11.18.19.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 19:15:21 -0800 (PST)
Subject: Re: INFO: task hung in io_wq_destroy
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        idosch@mellanox.com, kimbrownkd@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, petrm@mellanox.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wanghai26@huawei.com,
        yuehaibing@huawei.com
References: <000000000000f86a4f0595fdb152@google.com>
 <f1a79e81-b41f-ba48-9bf3-aeae708f73ba@kernel.dk>
 <20191119022330.GC3147@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bc52115c-3951-54c6-7810-86797d8c4644@kernel.dk>
Date:   Mon, 18 Nov 2019 20:15:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119022330.GC3147@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 7:23 PM, Eric Biggers wrote:
> Hi Jens,
> 
> On Mon, Oct 28, 2019 at 03:00:08PM -0600, Jens Axboe wrote:
>> This is fixed in my for-next branch for a few days at least, unfortunately
>> linux-next is still on the old one. Next version should be better.
> 
> This is still occurring on linux-next.  Here's a report on next-20191115 from
> https://syzkaller.appspot.com/text?tag=CrashReport&x=16fa3d1ce00000

Hmm, I'll take a look. Looking at the reproducer, it's got a massive
sleep at the end. I take it this triggers before that time actually
passes? Because that's around 11.5 days of sleep.

No luck reproducing this so far, I'll try on linux-next.

-- 
Jens Axboe

