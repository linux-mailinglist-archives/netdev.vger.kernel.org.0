Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E92120F99
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfLPQei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:34:38 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35734 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfLPQei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:34:38 -0500
Received: by mail-io1-f68.google.com with SMTP id v18so6603824iol.2
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sV6W5tgBoNXLBezFP+Oz1ItZHovaRvRLc8sTy7setI0=;
        b=rDT3yirSk0G9E9jwCL0SQNJb9YhgxdsQP/W2vMD32CfI+lPxpa/+OZjs9hmqLitHoe
         INm001cisC3rQwTdxrIyVkU4xO5oJXc2d2BVYSOrA8C1uHne3p+VhUtpRI/wLlvwzeDJ
         BgopjFv/1jaDyVnA5LsM46fI9LSbkiv7qW4ejlKfGWPaUpw8IrJ9smIzy1jjAmxz3pXt
         40d7+TGJZ+TgVleWJqBnOfz75EsPcQe2GNMLHd6Oiq2F9BoahMp7mabN2ezv0bWVrYi8
         X42S5+InPddEiJYumtDTj+PlKHwnzymL4KMV2xnjbgj8WG5gkAfuHa41mVtPLSD0adhw
         SyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sV6W5tgBoNXLBezFP+Oz1ItZHovaRvRLc8sTy7setI0=;
        b=j350ZO90bn+XunaY9bdcFeumKb78dgYfBENQUTk7NjJct0hnixUjjpMpFV6REG+DlG
         pjNSFRyoFnS577754sa2OofyHlGPJOiH9zqupn+XWHD9GxNS1ss66sGVJzxqDYBxyR8i
         +cfUd1oWYfp2hZTVs8GFjsi+rEYlRMJCztIOrLyV2LWmNGwDrzhLwkw1glBdgj7P4CU4
         pIA0v5/Y4o7HYHa8S7YsbNN8L2s/rJmOIfkTEGI/JH2dnKjl41FJzwhEPTpGg8+HOMV4
         v85EjclyBqfUD45gM45ps2opvWUkgqSvoWaeTEaqquz+5J16SXj6o7EPplsghLYkpM+/
         Ysgw==
X-Gm-Message-State: APjAAAVaL5MB4yNJq4eOB1GxpvomxyTGRufZbNrnttMUYFfGLPy6iScH
        NQsR/VtXPCqdOEVgmzTC4TUsEs3hHII=
X-Google-Smtp-Source: APXvYqwUlRSPf0nVZuEy2p97WYh/bL9zlT5+0J5yFlqQjqosHVJ+3E1N9JZPMhZBgQOByu9BZsuXOw==
X-Received: by 2002:a02:966a:: with SMTP id c97mr12968210jai.7.1576514077649;
        Mon, 16 Dec 2019 08:34:37 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:c48d:b570:ebb:18d9? ([2601:284:8202:10b0:c48d:b570:ebb:18d9])
        by smtp.googlemail.com with ESMTPSA id l9sm4496669ioh.77.2019.12.16.08.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:34:36 -0800 (PST)
Subject: Re: [PATCH net-next v2 04/10] ipv4: Notify route if replacing
 currently offloaded one
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191214155315.613186-1-idosch@idosch.org>
 <20191214155315.613186-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fdbd8faf-8e01-3605-5925-7b9ec9d1035e@gmail.com>
Date:   Mon, 16 Dec 2019 09:34:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214155315.613186-5-idosch@idosch.org>
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
> When replacing a route, its replacement should only be notified in case
> the replaced route is of any interest to listeners. In other words, if
> the replaced route is currently used in the data path, which means it is
> the first route in the FIB alias list with the given {prefix, prefix
> length, table ID}.
> 
> v2:
> * Convert to use fib_find_alias() instead of fib_find_first_alias()
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

