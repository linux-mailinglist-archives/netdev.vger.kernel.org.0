Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9460033B6F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFCWfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:35:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37844 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCWfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:35:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id a23so11434688pff.4
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OxJz1a2HUUSeqReJzDVwSrXCYR33/qxswFE1bl3PA1A=;
        b=ng9sUqVIZqbL2jszoxups7hzwYjtJhOkmCSga3PLouA3kudvynx0mKjHAFxBez3m28
         CLoCuIOw1ruI4KTKqA4EFnYYUCWaXegh07St7F8EGexO3WARDKJFH65gFlNQlKdywSEj
         rYhwfMs/CzxxISjAskh0K83O+UqE3AVZdtrl+/lWQIAM8x1u3q5bc7Fq3BoN1+UtFM0t
         a8OdiFQrGQ6MTVfAno6OYke+xUYPy3+sqHLcMttedN4YRPZh2zdmtHSbgrTuvRMsdlNg
         c9upbGuKMg7lxSlBy6Q/6BlO0ZyD6+yhVdbn8SFoawU93ujjIPIiWorVQqbNQpJVJOF4
         /yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OxJz1a2HUUSeqReJzDVwSrXCYR33/qxswFE1bl3PA1A=;
        b=lhHYVrIsFkM1T75bRA+h0mTErk4aSzDK/i+Kt3vquzccmJVQJZzDVshSudZX6buJG+
         xSGMkRxwRomZPNhwMGecI/JyCs3dZv+LTMmqPQsKwCAT69aE6L1jrP2v23MzU19/u6OV
         BySPHblKh2199H5t65glf+qwmcL7a73IsixaqQgUprZEPyf0b/RrDAJILvsZTcGG7jRU
         35z2r7cLpHfnoFC7GHF3XdsHzN/jU+PNLYyv8fkTnhTmsV4M9kUsnrIq4pucEsFpcg0x
         UOi7N7KGD6BY663+fHsutjzRkQZzb0B42dqc4eH9iVgUTV5P+xUNwjJ8xorMJeGXm0aB
         04yA==
X-Gm-Message-State: APjAAAV3a/YFR3KCzP420TDhO8//i0H6pSN9R9ATia+mwLRus2smZ+ZF
        uiXfChZ341iPN5wdQMsglQk=
X-Google-Smtp-Source: APXvYqxh0rqKqsaUMxgsbgW5BqvL2xfprP4/zLmjwpMJus1ZnLqibor+gw5O/DRk2lRJoG+iOGgHbg==
X-Received: by 2002:aa7:8d85:: with SMTP id i5mr33585187pfr.242.1559601352905;
        Mon, 03 Jun 2019 15:35:52 -0700 (PDT)
Received: from [172.27.227.197] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d7sm12737044pfn.89.2019.06.03.15.35.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:35:52 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Wei Wang <weiwan@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
Date:   Mon, 3 Jun 2019 16:35:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 3:58 PM, Wei Wang wrote:
> Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
> If we have a blackholed nexthop, the lookup code here always tries to
> create an rt cache entry for every lookup.
> Maybe we could reuse the pcpu cache logic for this? So we only create
> new dst cache on the CPU if there is no cache created before.

I'll take a look.

Long term, I would like to see IPv6 separate FIB lookups from dst's -
like IPv4 does. In that case reject routes would not use a dst_entry;
rather the fib lookups return an error code.
