Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F01656647
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfFZKJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:09:41 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34998 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZKJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:09:41 -0400
Received: by mail-yb1-f194.google.com with SMTP id i203so1053864ybg.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RjO9lROge7N4aJI0S7rMOhDLEhgxpJrQyuPzqs7EX10=;
        b=AL1L6pm8QfXLn2q96YUxGKsdHA2t1RmK8jshyG96RV1fUNYiK+o3acmXnLntnJFAxX
         aKVxsfno6jpPJVqOiA2knhrMRnYisv4mWAeStbeQeLHd0xy3584/cWKuCKFqUgn68q28
         rGlozCdBykHtiKnYLuAjfKJpy1nyTXIceRyHVRTj96TrO3cDqukAtGiOikoDK3UKO2EG
         i4gMQt6VNvqay7oKsPgqWksn79PBl2yXyJlVvnEYqmW8oiYhu2V3Keew04rcM3xqsn7M
         296VZutVPkw+H0Dk0VkcWFpW04IokP29RWNi1W65zDZw0ONcIn8EGUrDvfuEnWCRvLOS
         yfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RjO9lROge7N4aJI0S7rMOhDLEhgxpJrQyuPzqs7EX10=;
        b=qUFSO5QImGpe2XEzNjRpcriGIIJX+f+Fcc5/zxBdTKSAaxDrolKxbrT1UwuZ8WVwn/
         Nynh7fkHLcuAFpFc1kNExP5jas9EaP4CnymW5mfXsizfWqCqtiiBMz6a+zADhSW57Qvs
         beKRLzSnkLhaUh3TxG3uLFPFusmBe+h8YL/3xcG2Hdk2JoWyK3iyyNe9CzsN+mEKwImc
         gWq5AkPlywGnuB0JCzoW2onGYVCid1qJvH7Rq/BFgW8GksP3Nm08FA5rUcyKbk3bm4XC
         CNQ9BfUSmFgKbYr4JrUGNBVnhvnYhEOhDJ/BM+8aOPMbYvOByGOryUZ06OYlqmoz4h17
         k/Lg==
X-Gm-Message-State: APjAAAX4md2x0Ep8XfaOlx1vbbVlILBxtwsR7RAvMo4BDyccxVVwTAcr
        b0lBveSpaLbFccw1SCRxRXHXrigy1mtd85cWtVDbIg==
X-Google-Smtp-Source: APXvYqz7XCjiW9ZO+ILTG09xMDIH34GvZSwC+KvrH3iGOmQUi91B2El0VfKB82VzWTGRoKxEyT5xBZM4VE6xspDqp4A=
X-Received: by 2002:a25:7057:: with SMTP id l84mr2058882ybc.518.1561543780454;
 Wed, 26 Jun 2019 03:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190626100450.217106-1-edumazet@google.com>
In-Reply-To: <20190626100450.217106-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Jun 2019 12:09:29 +0200
Message-ID: <CANn89iJMvKH8h=S5na2tCDYcfqtzCa-SgveWuQoBOeq397iZ+w@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: fix suspicious RCU usage in fib_dump_info_fnhe()
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:04 PM Eric Dumazet <edumazet@google.com> wrote:
>
> sysbot reported that we lack appropriate rcu_read_lock()
> protection in fib_dump_info_fnhe()

This is for net-next tree, sorry for the confusion.
