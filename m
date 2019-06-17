Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28E548379
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFQNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:06:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38923 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQNGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:06:21 -0400
Received: by mail-io1-f65.google.com with SMTP id r185so14983591iod.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VSYhfVHQih+M4629Cya7JjEf6OR4ILXJD3sjGw7DdoE=;
        b=SkLCDnIrCeVuWKnbjBCcE04BCi/veP5JEy/tLTerTEbi7XB/6wKKHGoSIGDe/BuL5W
         TNgcV0gELa6hetSEhrO/SC98VZCGwTpMcExuhbGolHVszaZTeE1vZ/gGpAozrGoy/cn7
         99GFOz/ynsb26v84D8a8GTPfOMOqj5Ydtj1biqUgc6uhIcE7n7U1vMQwqJE1qhGVl+55
         KeO6xGg6t2wRrwQ0WJaVN8//H0ALqjNOk08uURSd4Nj3v1YdBL85S4bHk002jTAi/oCc
         iK1y74BbGM6bUHFyqUz5ezNKk6Cli3a+Y7tS7R1nA+KFExg7R0b/VrrdEvageW1XfqBV
         oohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSYhfVHQih+M4629Cya7JjEf6OR4ILXJD3sjGw7DdoE=;
        b=SO7Nw2Vxj70XAD7b6Mbag6LOzRgpZFBLQPuK0TLCdws2PTL6VTG+8UIL1TVJVPyAJi
         6eU/5avXVc9suI6gxhwpKA7ig1szwAR+9xSayJcumaKxKHx4Xn43OqWPJuUS7JPMqhh+
         PoahJLgBSfJLpqhLNgyyv5T04Ca4psKi1GW/l1rHVFM9nHGouu6Zn22ztJ9BdPRR0jQC
         GVkSSZOCUDS3pTHrD3y+i2LGemsjnOFowIy2hidzE2pTcfgDYyzQKi/cVow5alqhpNrX
         TlDdiUhcVhcwwWFwSJfFyLwkxti/q/0JmZZiugn3dTBfewuBmjNtomKEiBLbl/W7tTx2
         woyA==
X-Gm-Message-State: APjAAAV5OYDdPaH59qpAYE1zbUJfSnUXzZml2/iv2rzMPr8f0nROEs+e
        QQmemEIOjOlfYHskaK54cXQ=
X-Google-Smtp-Source: APXvYqwKT2Au9o8HD550ni0N9AqFWvGIbdQnDB1Z3UGWGWMYRn2DkRoMFIiHq4P7EQMsf2CzCusyuQ==
X-Received: by 2002:a6b:b987:: with SMTP id j129mr19323522iof.166.1560776780312;
        Mon, 17 Jun 2019 06:06:20 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id a1sm9165146ioo.5.2019.06.17.06.06.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:06:19 -0700 (PDT)
Subject: Re: [PATCH net-next 16/17] ipv6: Stop sending in-kernel notifications
 for each nexthop
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-17-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4f7ef3ac-d3f8-60bf-dc92-e405d2a1770b@gmail.com>
Date:   Mon, 17 Jun 2019 07:06:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-17-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Both listeners - mlxsw and netdevsim - of IPv6 FIB notifications are now
> ready to handle IPv6 multipath notifications.
> 
> Therefore, stop ignoring such notifications in both drivers and stop
> sending notification for each added / deleted nexthop.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 --
>  drivers/net/netdevsim/fib.c                   |  7 -----
>  net/ipv6/ip6_fib.c                            | 28 +++++++++++--------
>  3 files changed, 17 insertions(+), 20 deletions(-)

Reviewed-by: David Ahern <dsahern@gmail.com>
