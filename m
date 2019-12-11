Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAD411BA89
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfLKRo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:44:26 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37533 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfLKRo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:44:26 -0500
Received: by mail-qt1-f193.google.com with SMTP id w47so7022133qtk.4
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6u/Ktun7HqOnufnJkjntXmo2WfoStmXSGJV/nEk7sU=;
        b=ptIlHwSnY5bq6IRw0tpeajvOZuar0slUxAT5pzHDpv06ak4FpSf+xvljDtgN6g6lG9
         7deTHRPO18LOiTF5hG4abm/pK9WwPEmz5tdR7zOX49SYk7ZX/veUetOQic973hSnZbpI
         5HozBoIQmAJmDl3sAwtUdJ/6bgLvaCwA6rvxR1mBl3TpdPpsjoUTRTs+dd8yB318TS91
         f6fhBfxTWmduDGsx/sGbFgYoezCpkpR0j0wNN/OpnQqb8rTO4mW4w5tBt3k/Scp1aCX5
         GaqkdHCwd2fziiHXBWvd6BwEQoVjQngspKMkwMOYfXfy9rA7vk3SaWs7VwY4DqfR6yyK
         7t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6u/Ktun7HqOnufnJkjntXmo2WfoStmXSGJV/nEk7sU=;
        b=NXBVE7B5gardzxDU5HkWNKKegI1kX0XTDDbOghXVZKPQIE2KN+KEO64YBpBpYnd+IW
         mcvD2mHYdZEkR9FMfOA0JLNlS8XXPJ4DB6aKbS5FsQXOomHnDO2kUv6m9iLkWD8Spqj1
         s6NjaapJOfYkKxW28aA5v195UavPnTeevhUrPiDlPUfqNQsKOYhbqB7P1M/rZv/hrN58
         4h7QUQ9HoeA9nc1Er5x7c6l9uZWmG0l36GjrOyt5Beb0HEsyv6QSHf8jTNk+F8DE4cGi
         WhkrimANuLHUJf5ceqb+NtUugxV0Ni4LVF0hLeUQQuNwKQRvJYOs0SZIe6dBAau8XwB8
         3GdQ==
X-Gm-Message-State: APjAAAV9i1FEkW01pmRz9iFMet2ngbhTK9OKRF+jRk9oStog01z2lmca
        i9GRSPZVfGMAOZgWjgpGD0Y=
X-Google-Smtp-Source: APXvYqzX7naY6WMdfUJEdXC/GacrVnHrpjZEGbHMbPYIYuO4juh6NyZmakXBkT451rrS5d2qQaOFZg==
X-Received: by 2002:ac8:4782:: with SMTP id k2mr3841532qtq.342.1576086265219;
        Wed, 11 Dec 2019 09:44:25 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id x1sm857363qke.125.2019.12.11.09.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:44:24 -0800 (PST)
Subject: Re: [PATCH net-next 5/9] ipv4: Handle route deletion notification
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5c7ab817-0c56-3ce6-c0a3-a14da8b85260@gmail.com>
Date:   Wed, 11 Dec 2019 10:44:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a route is deleted we potentially need to promote the next route in
> the FIB alias list (e.g., with an higher metric). In case we find such a
> route, a replace notification is emitted. Otherwise, a delete
> notification for the deleted route.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


