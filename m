Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8657FF5BAF
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKHXPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:15:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35280 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHXPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:15:11 -0500
Received: by mail-pg1-f194.google.com with SMTP id q22so5013218pgk.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 15:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1UFUQtPGpOcHDFyF2zPQsZ9sIpfqx00NAdOZ3xZlOxs=;
        b=YAalXGhfyUuP026WtqK0ECEPkSVFhUqViFg2eJiVkMBvVRC5vO2xWQC5J5hBfT9WOq
         IXTM1JLeKTPW8FmnIIRZh4ScR09ABPcrWWsm5wmm4MUS0FUXJOXZz9y/TxHVX0zq+Xg+
         h5PWblQrn57MpSgAUzkVStTunex6/NmUwptlIbJ3vqy6/tgiuq131bULbAqpI2Qcd59Q
         SobwUuIW8y+iej/R9gy3fThWBuS62sIxLy1DR8oh24bIp0nG7yMH12iRRVMr/wfzNnMT
         K6tUeOsNDnuRap/7QW7G2c7fv+gu5kNO8hhR2cA9HFvoSU2jkIPiRO6+X96YxWZSY+WT
         T1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1UFUQtPGpOcHDFyF2zPQsZ9sIpfqx00NAdOZ3xZlOxs=;
        b=mEZ1xdrIhgf7ttRRonVP3CiuHPpgnx0H6ROZsoGvPNTYDKijt6ZHknwGZDWcMyIGcY
         B+lQ5v+dmfRjlLJ0ZaM54gZ3SNkDv3awK+itKoydVyi/wpemL3Q0v6jxR1cHRssQwhGE
         ulaJk/NltZP+TGnimj5KTtc6HomfjR/mXac0ToMv6j9x90NEmF9qIVU03XriVFeHkOeO
         T4pYlaaeITp2ydgl6H6aOn70G+VpqQhjExbEMknZpKncoQu14bSGgWoAU/6owYhSwE5x
         Kq2yz1N1A31zFlmm0Pk+U6YEEKtMlaFTZGDlLoZAlruIqhvdGAFgPheTrVXCa++wUWDO
         td2w==
X-Gm-Message-State: APjAAAVn074UhmDLijNHyr8dE0BJtQAnREQ8drv8V3T3EBXXCBE68b4i
        qD/uDmbyBVizoDdjULCBQHCJT5ingm8=
X-Google-Smtp-Source: APXvYqw7K+TimCD5jO8FnQM6zntNn2MadqOalz0dJC89dwACBF0aZtrC03fMyhQwwMJE71RsGG/Y0w==
X-Received: by 2002:aa7:963c:: with SMTP id r28mr15082440pfg.91.1573254910370;
        Fri, 08 Nov 2019 15:15:10 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id r20sm13103343pgo.74.2019.11.08.15.15.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:15:09 -0800 (PST)
Subject: Re: [PATCH 0/2] unix: Show number of scm files in fdinfo
To:     David Miller <davem@davemloft.net>, ktkhai@virtuozzo.com
Cc:     pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de, netdev@vger.kernel.org
References: <157312863230.4594.18421480718399996953.stgit@localhost.localdomain>
 <20191108.113003.601469804110215285.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb70753a-5bd7-2c94-a381-71e02ba112f6@kernel.dk>
Date:   Fri, 8 Nov 2019 16:15:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108.113003.601469804110215285.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-7
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/19 12:30 PM, David Miller wrote:
> From: Kirill Tkhai <ktkhai@virtuozzo.com>
> Date: Thu, 07 Nov 2019 15:14:15 +0300
> 
>> Unix sockets like a block box. You never know what is pending there:
>> there may be a file descriptor holding a mount or a block device,
>> or there may be whole universes with namespaces, sockets with receive
>> queues full of sockets etc.
>>
>> The patchset makes number of pending scm files be visible in fdinfo.
>> This may be useful to determine, that socket should be investigated
>> or which task should be killed to put reference counter on a resourse.
> 
> This doesn't even compile:
> 
> net/unix/af_unix.c: In function ¡scm_stat_add¢:
> ./include/linux/lockdep.h:365:52: error: invalid type argument of ¡->¢ (have ¡spinlock_t¢ {aka ¡struct spinlock¢})
>   #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)

Quick guess is a missing & on those locks...

But in any case, the feature looks really useful, also for io_uring which
puts all its registered files in the skb. I'll give it a tester here.

-- 
Jens Axboe

