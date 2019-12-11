Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFA11BAA7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfLKRwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:52:35 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41876 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbfLKRwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:52:35 -0500
Received: by mail-qv1-f67.google.com with SMTP id b18so6099177qvo.8
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FwmpzTi6RdlpMktZS9J8gXSszVfk8pW6XMKMrgazgys=;
        b=uWyNM5T2ks64tN2oy9ia94cileO6Ns+cuejTH+Zg9CDUznKeqG1FQeFfLpGPk7iIsf
         yyWm+bjOxRiJ+p+Q2f+m6OMWipKqsJe+Qn8w31FD/OnL+ZWViELVFpjM2TylfzwNbS6o
         Sohdbpm7Q9NsUbyKBeM7g+L84hqFEThDmh65IDW5cBSFurg5w1fldV3CKqnbyK6JSut2
         8phl0zSrfkyTiJq2bxuqImwy1J54nyX0lExWwHRCQQRXXBrZ8pk3VMkkxYyi+6a7R75r
         ysr6/pZsZ+jxhE39K32Kfc45rn37ae2DPxVIUVS5IwGK+1HFLrJp/NhzckyLeYeUxvIf
         AaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FwmpzTi6RdlpMktZS9J8gXSszVfk8pW6XMKMrgazgys=;
        b=gqwX6isGJE8yJDjGD0f/jFFQ5u0BftpYqQT32ho/xz5aZxO+w1q3RhqtywFbJpIh/J
         jVdOZm7dJDj6VFhQaC5Wdjt5muCP190Aze1BHUkj3nAOr0hzDWDA+iTjwxBgZlZ11NiS
         7spvKJlWpF0VeE6ZZ29Qz8MG6ZvE0CHqeKvMQm8jw+JLCPh2swI48b/gKDA+CpcwpMFT
         HXOjD/Q1bAfkJkovCKo/+QcLvnxQlSJqX7nk97QzDX+Ozgo+BVCinuWRdu3eyX2bi7S5
         IthK9rPm+/mQ1hhrMUQ11KW4tne8GOui3Xqpm+HqS0AhIiorP87IUidlVN8SPRAo7T2O
         I+kQ==
X-Gm-Message-State: APjAAAXKq5xsc/7mgN3YGCam/5SGOO6EUPxbwF6pohxKmJdxPKLm4qvN
        0/f6Q4Itz+Pt0HDQAuvMdjI=
X-Google-Smtp-Source: APXvYqzGEe3vS94PgloG4VmZeQO3lhJOaKopZIO+nNvCX47RPE9Bl+ie3cEQWUKfS8RxVOvwVC0kxw==
X-Received: by 2002:a05:6214:13a3:: with SMTP id h3mr4270393qvz.212.1576086754938;
        Wed, 11 Dec 2019 09:52:34 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id k31sm1088588qtd.64.2019.12.11.09.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:52:34 -0800 (PST)
Subject: Re: [PATCH net-next 6/9] ipv4: Handle route deletion notification
 during flush
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0becb113-01c2-6342-b162-095664c89e9d@gmail.com>
Date:   Wed, 11 Dec 2019 10:52:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-7-idosch@idosch.org>
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
> In a similar fashion to previous patch, when a route is deleted as part
> of table flushing, promote the next route in the list, if exists.
> Otherwise, simply emit a delete notification.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


