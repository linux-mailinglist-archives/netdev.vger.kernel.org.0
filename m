Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114EB989DA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfHVDcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:32:01 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:35898 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbfHVDcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:32:01 -0400
Received: by mail-qk1-f171.google.com with SMTP id d23so3912181qko.3;
        Wed, 21 Aug 2019 20:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UIoftVC7LBAw37MnDnt/TcuIgjHWo/AAuAOTs4kPi64=;
        b=T4ozXsYlsqg+FqmlDhDACxtha3DXnmhopkQrh8TtP2IQHmxukmzjU2IorUOb6WnKpc
         AqCdfYwKkpD+qm7ZT5mG/IcCzh3rw09DiBscZf3aadk7wdzswevNs7cHhUZwTHaW9FTi
         5n1wkxRH8gCp4PbiAtJx8VUnS3kukeW64Tp7TzZMsQaSdakAUUDAORBBQ5mqmKaR4vLC
         uQXG1yCQ25WTRnNxusVgFx+CYfhFd85TsFq2DhYc7Ugc8wn/a/rJGZDhCRHtTBh1/K1v
         bfcxNhkbJIVovZtYY/2GBhkKgac28H5DFBINg1OC2BysRXQ8etTtD6A6JvoyMSfXlhTu
         85bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UIoftVC7LBAw37MnDnt/TcuIgjHWo/AAuAOTs4kPi64=;
        b=o4oaetGs3g/rAakKSLXa48Tvvnmmw0OBiBzzN9856KaSlnMgBgQ6hZe5bfMttsI6kg
         qEleUTw/WLF0m8akt+9zbUx4thDhMfDGkPTHLZsHWaxcB04M28Czn1roe4EjqmMxIgtH
         fup5G6H9pxCIA53dDB1gM2b187OttRGM1NUMPnIIsAYDab6ZrmTomQo3Va9ZlwkROWQk
         11gTm6yfM6uTzIMuy74eh4t4vhrYa5zh1cbJdC4g7+lpijJYkPmnKQ6gooHkFJ4wciCh
         Y02auNoEzHDJp/WIbWduAgEJZ647boVPFStVZF2hKWCcDyNoJrvZL06h1wzuVrbtM3+K
         HdCw==
X-Gm-Message-State: APjAAAWpmjW7S2K7WthHQaqU94bkhSdGHN6eVESEwcLzcqpiIvsMS4q2
        nBbeNA1cEjDpRVGPFbpe3LU=
X-Google-Smtp-Source: APXvYqweYGEq09uXOhH+BQCSSJUCYM+eYQ8nwj9/pPcLK7kpk9M0Gz+m8Q1CkjOzDgP+tLuEX2kNqw==
X-Received: by 2002:a37:a10:: with SMTP id 16mr33425377qkk.335.1566444720358;
        Wed, 21 Aug 2019 20:32:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2604:2000:e8c5:d400:18a2:a8d5:6394:8e1f])
        by smtp.googlemail.com with ESMTPSA id h66sm11118817qke.61.2019.08.21.20.31.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 20:31:59 -0700 (PDT)
Subject: Re: KMSAN: uninit-value in rtm_new_nexthop
To:     syzbot <syzbot+4f3abbb335d1bed2287c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <000000000000276f580590a83ac2@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6b5081d-0abe-2c39-27ee-c957996d4fc4@gmail.com>
Date:   Wed, 21 Aug 2019 23:31:57 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000276f580590a83ac2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 6:38 PM, syzbot wrote:
> ==================================================================
> BUG: KMSAN: uninit-value in rtm_to_nh_config net/ipv4/nexthop.c:1317
> [inline]
> BUG: KMSAN: uninit-value in rtm_new_nexthop+0x447/0x98e0
> net/ipv4/nexthop.c:1474

I believed this is fixed in net by commit:

Author: David Ahern <dsahern@gmail.com>
Date:   Mon Aug 12 13:07:07 2019 -0700

    netlink: Fix nlmsg_parse as a wrapper for strict message parsing

