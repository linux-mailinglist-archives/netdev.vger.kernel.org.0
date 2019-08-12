Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBABF8A431
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHLRXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:23:42 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45187 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHLRXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:23:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id m24so8757772otp.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 10:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QEd19naA7Lac6lLabh5sakuOjFBxlQXqpe5RPnzJ/JQ=;
        b=K1WuBJf9TKSrg5hA8590GkVUwrsJ/2o3YZjg5XF2sP3vsEbsNTgB2thvpqllDOcwtG
         tq18jlwbCuWzQ4E3NN0Ib4KiWMZnJ/FKp1ixUSel3I0owCNx+a+6zUiXDNbK7EKbVsal
         TYJTXsINUQlq8ivZzNKmRei6i+0WhF6zWkvJMHunCBeQcniYt+Q4dsu6Ltk05Ap+8RhO
         4C60J27Y1vpA8cdwlkkymgDcWOFeWB24KEwnx/mFnvGDUcavr7ns8GDVS0vbGcuKLAIM
         09EGiIq6EmI8fxG9uDk98ZZctxUY9F0oWXEbib58CkSh50XACqZGw7XM6zg3oU+/qy9o
         Eelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QEd19naA7Lac6lLabh5sakuOjFBxlQXqpe5RPnzJ/JQ=;
        b=pbKy+iVaF+z7AbczolffKDRLfcHiVwvNRWOaZ+RofpDSphSmkjkNlckBY7nvxyB4O0
         hwI0s9a3I1I12zZ2QKVyeskKLMLP6ULYwHCvJDlh2SNPeNf4odauhjNQG+lu3S6l68RT
         +6TVKTFrTpgNjtXEhqlTeYZ3rflqm/Mt3ZX/ebCyPOTLWuLgAQGQGAvTzSN0tWuIcPeS
         zAgt7GeoR8+RNVl7Iz9UVKrMTqGdZQmUlrpwSQiVgBYQD4kY1KuCdB7UuNiOgUL++h2f
         zt1Lmg4SalVYLMuZpg/LZ0zXLYAhUq23HjJEndX+SAn/iR1XmmrHbclxkGMhy1FlAXBJ
         5dGw==
X-Gm-Message-State: APjAAAXk6E1D4zQQ+MFHYOi37wyruYGxYGDnUobpfxpAfDUWO6oRGNGr
        /UcGd11LzoGx1rr3iPEOF4Y=
X-Google-Smtp-Source: APXvYqyriEirIpVROSgoZk/0qHmC/nng1tbKbeZwrqG/pu6Q0EgzLPpbcB8QdxXWLQKQTod8Mg540w==
X-Received: by 2002:a5d:9dcb:: with SMTP id 11mr11203594ioo.116.1565630620878;
        Mon, 12 Aug 2019 10:23:40 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:1567:1802:ced3:a7f1? ([2601:282:800:fd80:1567:1802:ced3:a7f1])
        by smtp.googlemail.com with ESMTPSA id p13sm18241145ioo.72.2019.08.12.10.23.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 10:23:40 -0700 (PDT)
Subject: Re: [PATCH net] nexthop: use nlmsg_parse_deprecated()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20190812113616.51725-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2edcb987-73df-f78a-62c0-61e59df19c74@gmail.com>
Date:   Mon, 12 Aug 2019 11:23:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812113616.51725-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 5:36 AM, Eric Dumazet wrote:
> David missed that commit 8cb081746c03 ("netlink: make validation
> more configurable for future strictness") has renamed nlmsg_parse()

I think the root cause is nlmsg_parse() calling __nla_parse and not
__nlmsg_parse. Users of nlmsg_parse are missing the header validation.
