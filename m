Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FCE120F9E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfLPQhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:37:02 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33705 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLPQhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:37:02 -0500
Received: by mail-il1-f196.google.com with SMTP id r81so5961674ilk.0
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TLVvADpUiK9S9VrQpz6XhCNMCS85FOwGIF7LYfdAWag=;
        b=PE/SVpqRkU000SUNY2yQXp6At+6Z8DWarW1cXj2ZI8W5k78qPrtjXluwLcESphE7xc
         10av04deY6t4J5TSCBLZwBQ39a3a6Mv/PUTCaVrSooBqr9abDHczjh6EJIyKxIqSBXrv
         f6JlZrigP9BOZZ5sqV7V6wew+915yd4M6+AoCCAyBu6uAVbi2PWoSL1kpQYgnlnVmTI9
         TjLv31BVzIDvnjnnFrnczW3w7us08gP3xpcbksHFUjpg7/WEcpp8lG9czu+Edx5swBlg
         9o+xPazHo5Iw8cjFmBfaY5A1fhxpMcTQhWCWLM9yXOp3l2I8kx8Fzprxk+N2PCFBHL9x
         1XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TLVvADpUiK9S9VrQpz6XhCNMCS85FOwGIF7LYfdAWag=;
        b=MsTjVmrdjlPs1jNiZ3NWt5fBALGdOrKsY858OZkbdRt1dGbZ7ZdPhwnDjLSfKdKIbR
         FA8lBMVaUrRcg5g2Y732t3ZOsEA+nEz1Cgcb4w5UxTzqLhaNFTwWCsX3ryH6TpxCGDbr
         Mn7mk3KUuyQ6B08rigK6/zqezaas+vnUJ6C3w9eqYsGrfB0A1uFXR/bYnaeO520f38ko
         tfd5oc8IsbTw81kHDYr0zooqKq54glPP3ZRPbVo455HzziwHzzheuJCP1b3b0QAQvn84
         udrxEm+fyAjy3T6rXPRj2/TWc04biStVfs+86/p9T83Ud+VujtvAzWfDcdocIRIDVs/X
         XN5g==
X-Gm-Message-State: APjAAAWFvjlwnAdrVtnYPFeu+zjh1TUuZkK7UyZYZlx6xbFeKSZL8pnZ
        gO1uPD05Zs/Y4kKayeAwCTw=
X-Google-Smtp-Source: APXvYqyZcUHzszqLtbtlfg7raBtKSXogcdFA0gVPuxBgAvCgjs2unApQsHbKxXj2zwj3hwXYgsRlMw==
X-Received: by 2002:a92:4e:: with SMTP id 75mr12539312ila.276.1576514222055;
        Mon, 16 Dec 2019 08:37:02 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:c48d:b570:ebb:18d9? ([2601:284:8202:10b0:c48d:b570:ebb:18d9])
        by smtp.googlemail.com with ESMTPSA id h71sm5975812ila.30.2019.12.16.08.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:37:01 -0800 (PST)
Subject: Re: [PATCH net-next v2 05/10] ipv4: Notify newly added route if
 should be offloaded
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191214155315.613186-1-idosch@idosch.org>
 <20191214155315.613186-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2ac0cbee-8bd7-c89c-e6a7-a71e0973e7d9@gmail.com>
Date:   Mon, 16 Dec 2019 09:37:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214155315.613186-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/19 8:53 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a route is added, it should only be notified in case it is the
> first route in the FIB alias list with the given {prefix, prefix length,
> table ID}. Otherwise, it is not used in the data path and should not be
> considered by switch drivers.
> 
> v2:
> * Convert to use fib_find_alias() instead of fib_find_first_alias()
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


