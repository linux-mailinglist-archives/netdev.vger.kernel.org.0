Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2E13608A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfFEPtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:49:02 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33374 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfFEPtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:49:02 -0400
Received: by mail-pf1-f181.google.com with SMTP id x15so5275917pfq.0;
        Wed, 05 Jun 2019 08:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wb+jj/thnorcdyL/QFDbCuhhmimyl2lyoNTzHydU1U4=;
        b=XbjPzh7yTvVSKLVy2O38IyLCkryVQxqPByZTLRHG0NpWcBVzok2y8VX2wjMpoy+C9S
         bHUBNcSQHSkLURY/jtnNtyjXuFtlOvldgWpUAuvbZbRYcg3Ete+el5c10zD3Xzm8DguV
         DPPekh2iF0Lv3wpb0xWgBUDLvPq1ICd3GbmP7AeEfXk/qlVzc3I8VVs73h1maZLyIVcC
         YiJPIXA9/auNoU1kx83TCeuQr5GXgq4c02O+k8BLPRZotcaSveeVg+D05Q0agK9ku2S3
         6juYAK8/HehaBKoKm7qsQWqaAyBcz9DmhNu+xrtNyLS92SyuGAqUEq71fsSV6Qh39Epc
         BRXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wb+jj/thnorcdyL/QFDbCuhhmimyl2lyoNTzHydU1U4=;
        b=pewx77i2wRxe4l4lCZQ0849fC3DtXAX0VrlbinXsHsgm2uROtfSSTs4dlZLtEW+QC5
         YyToVCD/R6q4gN6FO5Y3bK8yhVVRjpk3kxzEORKAx3dVjpge2G0lzQY9CMroICjbzS9o
         I/RsPgdT0Uxmv3xHqL3pLEKB0dMHP058NUeK0LjvWYEoXoOOgRZDin4+oNo1fLsP9jYU
         Y3dYv7q9UgMxYQRct4jUPqjlERH5tFOWsTPT09j8TUOEbiyOrCwm3e+iQy2sNnfc2/Gl
         ihPmU6sU6L4mnFoxnFNWFBFbT5SUpGY+5ibvluceG8spsJsAjWeAQd/UmbAzxYYi97b4
         pmqg==
X-Gm-Message-State: APjAAAXAbqOOdleOoBV5pC2Xdm4H5EtC71cwXC5QzYPlwTPGqFXkKvdp
        sSBQGEMQ8qHGHiG3TOmRHCQ=
X-Google-Smtp-Source: APXvYqy9IvXux9Zh7VEVq36XWON6hyMBGuSz194eUWoJr9GhJE7pvxBasgOhoWb6XSB25DBEnp+yQA==
X-Received: by 2002:aa7:8292:: with SMTP id s18mr16034016pfm.111.1559749741871;
        Wed, 05 Jun 2019 08:49:01 -0700 (PDT)
Received: from [172.27.227.204] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id f11sm23067144pfd.27.2019.06.05.08.48.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 08:49:01 -0700 (PDT)
Subject: Re: KASAN: slab-out-of-bounds Read in rt_cache_valid
To:     syzbot <syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000008ab73d058a787e2c@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dddafeb7-95a2-52e3-57fa-62c6e4c5b832@gmail.com>
Date:   Wed, 5 Jun 2019 09:48:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <0000000000008ab73d058a787e2c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 11:10 PM, syzbot wrote:
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in rt_cache_valid+0x158/0x190
> net/ipv4/route.c:1556
> Read of size 2 at addr ffff8880654f3ac7 by task syz-executor.0/26603
> 
> CPU: 0 PID: 26603 Comm: syz-executor.0 Not tainted 5.2.0-rc2+ #9
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
>  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
>  kasan_report+0x12/0x20 mm/kasan/common.c:614
>  __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
>  rt_cache_valid+0x158/0x190 net/ipv4/route.c:1556
>  __mkroute_output net/ipv4/route.c:2332 [inline]

This one appears to be a use after free. The fib entry is still live (in
the FIB) and the cached entry is still attached. Perhaps one too many
puts on the dst_entry.

