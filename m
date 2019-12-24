Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18B212A351
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfLXRMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:12:08 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34606 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLXRMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:12:07 -0500
Received: by mail-il1-f194.google.com with SMTP id s15so17011653iln.1
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AAkSjQJ/GOkHLMCJXJNgni0MmVZ6WpkxUSazvz9elLg=;
        b=Eby0UJIG+1HExirgHxhAuCASYwA2sKI84z16Qf4Ul3dTrYL5wPDnF7glh7w9n5zk68
         WNQDZ2JxJgZxtGJtUaRONoBRQDmu251junU+cBSstzFQlha+VNkRf3eCbpBqXQXhO9rc
         WKBw4Dsm40qNhx7qgr26VmUq8UXi7+r8X3gCJ8tisYHfc7sKtyN1Z8xKTbtdqsf9iRmI
         Pd2oCdMmPNrxrWGqPCIP2aw2HMGLcVdjXKPk47ETCnSRarzhjdHSr1RZ5ECNQ+xa9oOy
         KRX1s8xqwx0R2BlRh/orCylkFm/6pvTRIzCDaYz9sxSBYU8u0ct+LifO7v93ZlkFA6Wm
         7vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AAkSjQJ/GOkHLMCJXJNgni0MmVZ6WpkxUSazvz9elLg=;
        b=Snk3h0eEj/uTfzS3Bch+Vyt4xV6S39RhyOojbA2u9jtes86wAe4/qjoNJ3S34P2bUv
         zdWQq4seTVbEu7OOHzuB5p0WnkIorIABdvlmyfau59L9eC+fvCErcb7rQR+xJ6OPjKP+
         aRF+uEZ17wZIvTPQCw4MMEr3n6vJjJ8RY5NhzZZqfsNQ6BPygEaI/PhxlSmhsyowUjyT
         xXSDXukz7U9U9FVE0wdj8bYKLjSeRchWZomu/kOslByXV2nlmPNNqiPDrR8Ih7uPuZIQ
         QXSvUlWbZNv96o1WFanHFJ69mp0UH62wRVyUJrzzvkJLTJE9Av3Z9iax0s1FsqTPkRiI
         Rsng==
X-Gm-Message-State: APjAAAVEq8RxSkQVM23jnMAdoZAoaEid4gv5sPtC4mgr3ru05HELHBVZ
        Y2rX26tEVbRLG+wT91KUkLs=
X-Google-Smtp-Source: APXvYqynqKBv4jxJ+xc5ObnbuKIDl/SUYv5rvc3jPWAjAxPbaATV/fKas7EgwgUPpednuJsS6L8r6A==
X-Received: by 2002:a92:3b98:: with SMTP id n24mr29920468ilh.189.1577207527146;
        Tue, 24 Dec 2019 09:12:07 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id k7sm4616316iol.15.2019.12.24.09.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 09:12:06 -0800 (PST)
Subject: Re: [PATCH net-next 9/9] ipv6: Remove old route notifications and
 convert listeners
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-10-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <85b38a98-ee09-a87f-41e2-00ca0f22ebbe@gmail.com>
Date:   Tue, 24 Dec 2019 10:12:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-10-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Now that mlxsw is converted to use the new FIB notifications it is
> possible to delete the old ones and use the new replace / append /
> delete notifications.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  .../ethernet/mellanox/mlxsw/spectrum_router.c |  9 ++-
>  drivers/net/netdevsim/fib.c                   |  1 -
>  include/net/fib_notifier.h                    |  2 -
>  net/ipv6/ip6_fib.c                            | 61 +++++--------------
>  net/ipv6/route.c                              | 18 +-----
>  5 files changed, 21 insertions(+), 70 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


