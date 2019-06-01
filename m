Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD43200E
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 19:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFARPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 13:15:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39953 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFARPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 13:15:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so8108823pfn.7;
        Sat, 01 Jun 2019 10:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MaeGnnu+LwIT7dIVF39aAxoy1OwHrQNYuo7RxgaVTjQ=;
        b=gp2miNk+sV9zve1Qb/a9ZeG/1gcf4PLmuQGszm6cOYE7H1B6IdNlLyUTLiQLHNfi9o
         56DX9+eRzseOc7m6ZgXwL2skvNZ7DMnzIqeOt+Mo1D9gd3eE1pTZsSd2VMAcgmpw+DDh
         NvfJyQ1b8xzliUGVy0/Fb5p2pn1GKfx3/6prbWqHBmHBCPqxTg84NnLbZwY+HFm+Y23A
         kprnJt4BjrjtYrBgiqVvyVW5zxKltHnE/N7D9sO92/C/dmOt1SuwCPM46l0Ml0GFsdWw
         3KSRVdNHSIley7Ce3Fn6GJKCLh6BwPZjg9xbQLXbGOlfRfX7VxJWdYmHqfeaZ2VYN+Ou
         nFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MaeGnnu+LwIT7dIVF39aAxoy1OwHrQNYuo7RxgaVTjQ=;
        b=ODKXnEY5EZ5Ff7eleA7+wyUUWi4HdlkNBR3gRnW3q7LujpjobamzoVSuBS7QoxTvsB
         eBmEA52PI1jUhneOPwcbSMg6I3SEp9norAlECJH2RbooivVZxVSo3NjRQ9VTpjJD37Si
         UC2JpC5agdk1HL8zyzeu9XXG1PHCeCpE3RPZ6EDI1uRu0z5c0xAYELjSypwQq8SN39E0
         1yAC20MQcPL+EbIwetbuqAEfXDf3bwZPw7hgqAbf+RNZTBzCyfka74r9DmkGh//MUtQN
         CAII1bzAB2D051H2L/2JKkw9SarPtbRp2SPxN3pl1ktQg9+7VnN+4Zaknogz1G/A2/Ja
         Ithw==
X-Gm-Message-State: APjAAAWQiqPsKvrLHURPzV4HqDPzaHS+ayiU+iYxqZ1HSYRQJCdRcpri
        cy2C9yh47+uFK6xjOs/y908=
X-Google-Smtp-Source: APXvYqz7XXeNdzCz/ZCHL7/zjTH9yoyX7XjU53lgzzYBDwyefm3nWjGT0hfgqI8+Rz6pQRUcjsgFJg==
X-Received: by 2002:aa7:80d9:: with SMTP id a25mr18637915pfn.50.1559409308633;
        Sat, 01 Jun 2019 10:15:08 -0700 (PDT)
Received: from [172.27.227.228] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d19sm8361120pjs.22.2019.06.01.10.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 10:15:07 -0700 (PDT)
Subject: Re: KASAN: user-memory-access Read in ip6_hold_safe (3)
To:     syzbot <syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <000000000000a7776f058a3ce9db@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <178c7ee0-46b7-8334-ef98-e530eb60a2cf@gmail.com>
Date:   Sat, 1 Jun 2019 11:15:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000a7776f058a3ce9db@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/19 12:05 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    dfb569f2 net: ll_temac: Fix compile error
> git tree:       net-next
syzbot team:

Is there any way to know the history of syzbot runs to determine that
crash X did not happen at commit Y but does happen at commit Z? That
narrows the window when trying to find where a regression occurs.

Thanks,
