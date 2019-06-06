Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE038122
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfFFWou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:44:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42675 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfFFWou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:44:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so2376684pff.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+d1pJHfJs+t51OU7J9ImEssJBxALOUSTjDaDO9iwaBU=;
        b=mSNLw+lTqqpy83QSiV6RZXasest+CpTDLrPxL3oBa2qp9ISXHIBoP49p/s8+LkdAWR
         K2Im8QAlVzBAQ2JsAqatTVP3BTQ3W6/p3NeTS8iODuyWoE4RvWoCW1Rzz7trPBsh+PME
         HOioS4TLusBA0OdIcNLk7sOtJIL7UJfngE0oP9l/K3yGhdCXhxMjCIYH9ss+e7LVVhYl
         TGgZNH2QK3+UJIJEsEUFtLuukBpvFpr2nkU82EJqHVTNlPZji+77h1i1J80EL/2470JG
         zufy7gHJYcqrT477XZGY48GkW+u5SVC9RFBpwPgFHn6bcNn2RhvbdJlNzGaUYVeTQHAN
         jsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+d1pJHfJs+t51OU7J9ImEssJBxALOUSTjDaDO9iwaBU=;
        b=tTmHsYHk0/wEOCckdxgc3BHmKggyN2RIZ6f6F942vZQ+P0M9d7qdRbGScvCnuJXf8z
         QSgOsYQ6DSbBK2FOVt2hCsAV6xToBEUYI0QdcztXNJJmnzgZ/7nz4YVNjNA/0XqYiJjl
         6C586M8pPy/IjND5BRTaq9d0vu+W8KA+dquFGqwlenNTR4FiuTwe4KVyuVjYetNy0IeL
         QJPLNFNq7NzdcXEwXJRJ253Kopl+SJdaxGqw664pClIpwO6zBSm2Se1ienNFMNCSIfPm
         PVGQneEa3r2vKHDwSeHzRH1KhnAtAUQGPbXdgbbr8+ddiwdyWrE0gDanKG3iUR/bKZf2
         Dbiw==
X-Gm-Message-State: APjAAAXu55Gwk2ME0314oXP4i2gGV6DztqvBuklgOZEz4+yKPj7A1A7U
        ADN5CtWPA1W15BMzYg+nFUg=
X-Google-Smtp-Source: APXvYqx+c/W/1KsYFWfdvO027+HijKu0xPOxjoajg2rLkw33hkUQ71irWLkHKwMTDZLPcG50Q7c8JA==
X-Received: by 2002:a63:4419:: with SMTP id r25mr129999pga.247.1559861089705;
        Thu, 06 Jun 2019 15:44:49 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u123sm181966pfu.67.2019.06.06.15.44.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 15:44:48 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix the check before getting the cookie in
 rt6_get_cookie
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>
References: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
 <ea598247-5f96-2455-063a-dc23d7313f85@gmail.com>
 <CADvbK_e4szaBKY6bJ3d-aE9XvSvCqtAJftCa=g0HpRpB6a9hqA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <29c20dfb-3428-32ea-43d1-eae2def70365@gmail.com>
Date:   Thu, 6 Jun 2019 16:44:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CADvbK_e4szaBKY6bJ3d-aE9XvSvCqtAJftCa=g0HpRpB6a9hqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 10:10 AM, Xin Long wrote:
> On Thu, Jun 6, 2019 at 11:35 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 6/2/19 5:10 AM, Xin Long wrote:
>>> In Jianlin's testing, netperf was broken with 'Connection reset by peer',
>>> as the cookie check failed in rt6_check() and ip6_dst_check() always
>>> returned NULL.
>>
>> Any particular test or setup that is causing the reset? I do not see
>> that problem in general.
>>
> by running the script below, netperf ends up with:
> 
> Connection reset by peer
> netperf: remote error 104
> 

No luck reproducing on 5.1 or 5.2. I get the theory though - resetting
the mtu to change exceptions. Interesting test case to add under selftests
