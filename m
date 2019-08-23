Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A5E9AFCD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391109AbfHWMlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 08:41:20 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:45420 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731848AbfHWMlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 08:41:19 -0400
Received: by mail-qk1-f182.google.com with SMTP id m2so7994645qki.12
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9cXO5Akq6QajfbKm7LvC7u+R8YZG1OW7y2sQ0ctQpKg=;
        b=IlDyXIdRc8coAnxGS75X2ZQ4O4h2nFV1AQK+ZMIjrJnVuuf5ptepXJtjj++799Tzb/
         OvE+XGjF37pkIEQJlF+t4cVJ5bSFkMt5q6JK0+QmsGS2Dh3mIgqyJanvLqdYWbweg212
         anCWfVDJJ4yYZb0uQ6r+e00iyCsLH53WYCXbEOUch3QeeM22+afyA0R2NT1Tb21DSYQh
         1YRsXatQBMA5THlXJH8CoDdE9J+VxDmBx5/5J32SOTJGAcnLFtmq0yOup80CXkwicjLv
         afL3k7tuWpl0NtCRpVWyErhJy3jrE+CaSKoDZuzLplcmVNEfY8QYabvzFHntT/Xw6KPd
         JCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cXO5Akq6QajfbKm7LvC7u+R8YZG1OW7y2sQ0ctQpKg=;
        b=fth8+Qqua9octD2SZ4HqEl0MXKqyu4AQFMaSRC5/YYIfyHBI7ZryximpIZf9ZOgjt0
         PGPMlRXbAjqQ7ActNwI+2U+y7GveMbw0b7i/fK6+NGyS6TQpC6+86WUd3EljGKqaDaw2
         XsGX6qKj/Bupx6IA4rYMzTvAr/PHcMXPcCCZexzZRw9Nu6CYBTU6AfGvRJWv5iZ48/pk
         VVWoBO5OoF6vkRxepfEPeDbGwtJJdJ8NpyDGI+TMuN/uJjkQ5ZMVdh9e6h3ZflXKYizz
         jpNJYnU50VtU6/7gY0naRuKL9xxe9urZh7vXoYYbo+uyU1UwwHLS3UWWq1v/abkAuNmf
         7BRg==
X-Gm-Message-State: APjAAAV2bK1U/HH20AbARQ14n83qTDoGBDC/nIzawEsbCNDXuNwUsFl2
        GVObI3crfh7LsVFsBxzhvxRfkJlJ
X-Google-Smtp-Source: APXvYqzDEsW7XFzOSC+RPjC5DsN4nAGs8VFD9r/7VY1jxS4ejqDPTtrAC7gjN3teNT0zLvY+Xw7YzQ==
X-Received: by 2002:a37:6007:: with SMTP id u7mr3804192qkb.92.1566564078938;
        Fri, 23 Aug 2019 05:41:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2604:2000:e8c5:d400:644e:9781:3c50:40ec])
        by smtp.googlemail.com with ESMTPSA id 145sm1410471qkm.1.2019.08.23.05.41.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 05:41:17 -0700 (PDT)
Subject: Re: [PATCHv2 net] ipv6/addrconf: allow adding multicast addr if
 IFA_F_MCAUTOJOIN is set
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Madhu Challa <challa@noironetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
 <20190820021947.22718-1-liuhangbin@gmail.com>
 <4306235d-db31-bf06-9d26-ce19319feae3@gmail.com>
 <20190822082012.GE18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <174e57e3-664c-e355-91f5-eea4997b6de9@gmail.com>
Date:   Fri, 23 Aug 2019 08:41:16 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190822082012.GE18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 4:20 AM, Hangbin Liu wrote:
> On Mon, Aug 19, 2019 at 10:33:58PM -0400, David Ahern wrote:
>> On 8/19/19 10:19 PM, Hangbin Liu wrote:
>>> But in ipv6_add_addr() it will check the address type and reject multicast
>>> address directly. So this feature is never worked for IPv6.
>>
>> If true, that is really disappointing.
>>
>> We need to get a functional test script started for various address cases.
> 
> Do you mean an `ip addr add` testing for all kinds of address types?
> 
yes.

