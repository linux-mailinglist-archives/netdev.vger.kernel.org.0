Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1104CE16
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbfFTM5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:57:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43905 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfFTM5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:57:31 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so104924ios.10
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 05:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UarnFX96jGG7nNVTWqvZbu4SCmdGFt0BvAoQSuDDlKo=;
        b=q6B9ac7o2XxLHCch+kZKLTxB88JT0aPelckOCsOM6WxwXWxFxqLb64QSpkHxr6/dY+
         eXvJzhGEwWImg537TjjvzCZLm4pIaq6H2oxXCwVxnPKrSwnoHyhFrxG6HerfgJ/l1b9d
         xIRmOTmIc4k718weKgiQuJmI0lVkRWntUf7OzQfNjUK0DAywsfn+bRnmSD+HWdMpQN/w
         CL62A8VmRyvD7MbCHEZlRv4MS4nxvtJnaxKzG12PXUHZDdCnfZxijwWL70cVPf4v6WqA
         KuhhPYrwS3uCeRZDp0jX4/1/PVjNXAfAB9Vy5ueC+x3ELhQAEYYq61HrtS9BT/nntek+
         YRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UarnFX96jGG7nNVTWqvZbu4SCmdGFt0BvAoQSuDDlKo=;
        b=HgKKlQaTIzrKrSc71tG7+Takg4tz6bDyXfbz/mGzIEMqvwD4HJ/A6oRRACUWiDhOYf
         VUcuH5B9TaVxJj3qyBPgKx4KU+DGzHaBvqbWISxO+bh4EWX1ycQ2AQfMvoWjFFBKgFxG
         1NXIxGfml5LBNJaXuH3cfc/uzF7Ylb+AI/EsuUJkbn5bsZ9Bn7w/YlwYP4OJ7yNF1AS6
         vYWaRVD1PdM4Fpvp74VVWbf1DKfO5CSGoBnqpYqFUx8ZcjEZX3tydol9KrtOvLlRXgph
         VhNBF1YPvFLSfpKcDr4VAFMM3pIA61qbj0QxMJHZT23IhYL8MFv76H64is4z/Fl6kcKF
         Ur4A==
X-Gm-Message-State: APjAAAVaF5F7LERVcWS71TxSMaLjLdkc7RflWbNenRAqxEXoMoSOT/MW
        qRDCFnsFpdeeqon8DE2Qxun7OT/X
X-Google-Smtp-Source: APXvYqztq3FQSRTI8X9n/2G5I6z3OvSXaBjgQ2RWBWIfPYi6he8Eb20MUKeVXat32prxszEbNrw2Uw==
X-Received: by 2002:a6b:b987:: with SMTP id j129mr39538897iof.166.1561035450209;
        Thu, 20 Jun 2019 05:57:30 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id a1sm15775464ioo.5.2019.06.20.05.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:57:29 -0700 (PDT)
Subject: Re: [PATCH net-next v2] ipv6: Error when route does not have any
 valid nexthops
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190620091021.18210-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33fa3e48-bd8b-abe5-ee9e-32ecaeca65b0@gmail.com>
Date:   Thu, 20 Jun 2019 06:57:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620091021.18210-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When user space sends invalid information in RTA_MULTIPATH, the nexthop
> list in ip6_route_multipath_add() is empty and 'rt_notif' is set to
> NULL.
> 
> The code that emits the in-kernel notifications does not check for this
> condition, which results in a NULL pointer dereference [1].
> 
> Fix this by bailing earlier in the function if the parsed nexthop list
> is empty. This is consistent with the corresponding IPv4 code.
> 
> v2:
> * Check if parsed nexthop list is empty and bail with extack set
> 
...
> 
> Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
> Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv6/route.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Reviewed-by: David Ahern <dsahern@gmail.com>
