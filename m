Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7CD33838
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFCShw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:37:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44188 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFCShv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:37:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so2281437pfe.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9CsumWRKo8endDXdqOri9lOV+pY+j4oT74Qo66P8Jwk=;
        b=h7MyZpUecW74U00Js1xj4QeYIEOeBwhuRatWUPwDxDH9zRx5vjFneTXVe/ALEVXbiM
         nirdU46HuThaKR2csEDuj0KlNBtfK0PAKeOQRHLd2gn6lGc/5wWMY7zsEbw1SCb+rIJj
         gRMyKvEEQLarbP8op+saNvREaZfqZKynqZMn3de7to/mQiIAyfHhqvKIIwLYXRZXD1Pd
         6JVPFBoOv3NUkKpwGl5vEhLNvwnbGI83YS6xayUY5AMBZdyl5FZWEHxreBDqp3+qX5dn
         qKT0p4h5pasBdDhwF3yKsfNyMX5OrBAkstJJ3pcPus735E3TT+73/177TkjAJKUuRtH3
         HgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9CsumWRKo8endDXdqOri9lOV+pY+j4oT74Qo66P8Jwk=;
        b=Pfo9iUwmt6dI3hBNAGsadH22x/bvx7kiyPYEH8cX5MJoi//9JLKIRTKjJJp8hpfaa2
         4SOA4YZVsot6VqGJf8HU+UxNnnn5VmeakgVRbDvkCKo+XxOBunzTrqnFWBlvf5mVjtcZ
         1jd7wSSs1jAL7BD/EPrJuzESOfKChNRJ5hk43O6pPFI1nDanpaTqqssUhC5ogVzl7E3D
         zpe1IxVLHcF5ukHIaXhbFPFwXpzdOzY6hzx62N0vxRSb4SGfUX5hado9c0/Wt19noE7k
         qxqHN1DYns7oyeSz3J4h3AwTdkDQ87L0tkc0mvmRw6DZEOg+IbliB8+3FJPH2ZF81gLQ
         qSWA==
X-Gm-Message-State: APjAAAWoBqNHHJJZxJ2rbZGbrXBsrC6Q2DHkrhnaUWN4pJazrh1g2oby
        wRYhSl74JToHbXr+ZXIuWIUPeXibcm0=
X-Google-Smtp-Source: APXvYqwBkai/x6lqOkmJQKTZbM9djImr4PhwvgW6wyQkA98y3IvcbzWX1I/m7rT4IMY+1gdiC8ErXw==
X-Received: by 2002:a63:d949:: with SMTP id e9mr30107446pgj.437.1559587071239;
        Mon, 03 Jun 2019 11:37:51 -0700 (PDT)
Received: from [172.27.227.197] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k1sm50812pjp.2.2019.06.03.11.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:37:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <de758bfa-4c20-9d40-58d8-c5ae07b40ff3@gmail.com>
Date:   Mon, 3 Jun 2019 12:37:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 12:09 PM, Wei Wang wrote:
>> @@ -667,6 +704,13 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
>>         }
>>         if (do_flush)
>>                 fib_flush(net);
>> +
>> +       /* ip6_del_rt removes the entry from this list hence the _safe */
>> +       list_for_each_entry_safe(f6i, tmp, &nh->f6i_list, nh_list) {
>> +               /* __ip6_del_rt does a release, so do a hold here */
>> +               fib6_info_hold(f6i);
> Do we need fib6_info_hold_safe() here?
> 

I do not think so.

If it is on the f6i_list, then fib6_purge_rt has not been called.
fib6_purge_rt and this function are both called with rtnl held, so there
is no race with the removal from the list.
