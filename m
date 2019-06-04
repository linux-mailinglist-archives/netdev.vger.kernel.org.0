Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA57435410
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfFDXaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:30:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45477 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfFDXai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 19:30:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id s11so13632221pfm.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 16:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kok+2ExJE3lrSQbKneSABeGL6ccrlQqra2bTnD6KA4s=;
        b=LrIX7lxpEbA5mg54lfSOJBu1PKzEemDRlsV/bNDBatd6TvvdlNHXwIBy/9Q319DdGb
         KztlVwLsgy2rdDSAkjpnZjsY/UkOLg6m5ikixf/VyKX/61DgMIkLtOmeywxrRD5gZ4Im
         J0r80mLR+3vuyp87/RLv8YuV8xUmiR+FXJ5ViibhzejPG4aooaZXZiqwBSNPzCSq1CiP
         KaHqslkm4R6MXxh5TpXKZiWibbdyV83eW0XG6C6qgd2+vqMw6w+/oXtpBsabolhMCc6K
         NI2IiKeSHGS6hfQStvCaw0XYoY+K01TDAKnSmYPUv/9GAkViQdd2xg+uh8f+NZ6QfeJk
         2sYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kok+2ExJE3lrSQbKneSABeGL6ccrlQqra2bTnD6KA4s=;
        b=eVso3F0VWq+OkSOhJQhb8rNLkEfpAIq38mSshpYHddDwqjlFylWE0bp7smC2w3ZeMp
         Bj71gVXp24IeMojLskFurEPEmhsUBGEut/Rx2zcwZlVJu1Vvg/KFCPX6Oe4iN8O+7N7n
         +xO20TeHs+Rc77+BKknKJ/ndnRrhXUNqBOpE+8rbqOGhx38/CFqrdrxFwdlZt+8+sFyn
         r4vuVmiCNFxc1Xw5rbe/o5+ygzA5DJRMbjduHrY5CftMOuXLIwKjuBWXF6n1kEs2zjOR
         OFRZWlBcZJpDWaFQIZXzhRbZ4dOWs53KADHAcIJ92tbum/dO3RmqOKFyh9iGuvHzvtok
         vqGA==
X-Gm-Message-State: APjAAAVjLLoedCMIX+0/nb5OGUFBT2ZtFZDbILVM7xmNPzNp8xHmmCoV
        W9DsTzSbDxxoAoPm/kIgG3hXUtoBhyc=
X-Google-Smtp-Source: APXvYqzRtGAIMOYya4dR3G3517k3hyCE4ilhVAhPwEmc3S7MC8Qh9HCJJiSWIQtVdVymzYySUe6x/Q==
X-Received: by 2002:a65:5ccb:: with SMTP id b11mr397730pgt.172.1559691037649;
        Tue, 04 Jun 2019 16:30:37 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id m5sm17477785pgc.84.2019.06.04.16.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 16:30:36 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Wei Wang <weiwan@google.com>
Cc:     Martin Lau <kafai@fb.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
 <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2e8d7a07-d350-9d12-189b-d3a1be8cc69d@gmail.com>
Date:   Tue, 4 Jun 2019 17:30:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 3:36 PM, Wei Wang wrote:
> instead of trying to convert ip6_create_rt_rcu() to use the pcpu_dst
> logic, completely get rid of the calling to ip6_create_rt_rcu(), and
> directly return f6i in those cases to the caller. Is that correct?

yes
