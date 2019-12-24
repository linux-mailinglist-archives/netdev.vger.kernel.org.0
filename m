Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CF112A342
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfLXQtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:49:12 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42786 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:49:11 -0500
Received: by mail-il1-f193.google.com with SMTP id t2so1578542ilq.9
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 08:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+cyeCw+YNEw1aovcphJo4N3qhj9QuMOw7HgY+5g6+B8=;
        b=IHUOKN27PFy4O8BXycQyx4cdFjg1eVfAKYuU7fbQMarUbJqIrmTrqGLwyiYqyHWC1g
         Ph1zLFBvOUZQSJdLwkPKxky5dHuDWoT9ocNHzdk/UCdk/Ng9GbveE2lMQDgUkKuOoN3c
         /DY24aXwYOZcypr9HUS9LPxHrwe4WRbOXbhRhabWlbYuDlGDnfMmgmZvX8fn9XSzn8J7
         6M/VDwJ98NPiN9aJSHJBto1x1vYqrlE2/NKAkODkx719+45ZtGZUFOc40uINsbpso/lG
         aEpLGaNchQ2E8wkWWyyt5Pk/yZqSBT56n+I634HX6YnpwyJYRBgDyhYXRAvg5J9+cqBA
         kzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+cyeCw+YNEw1aovcphJo4N3qhj9QuMOw7HgY+5g6+B8=;
        b=tPShFgNO5qAupjum/Q/9g8b2MUFT6u7cLNeSV+W1DaXviVCJzO7useQtbWE1yv5vze
         AIHH2E7+kgxxi2JyYMoqoIWWVkEZFP30fb4yTn5V0t6UuOvlYm+zI44bq20A36QmtX7A
         WjBksoY/YGLmkIKMDZWE/B0XoWvMYzgGtiF5rjN09doPMofLgRoKB2vHgL1mc9UI+3Ae
         u2MAzy0BOMtbqSYvPHMHqNKXbEUHRG8yABQswMXdUV77cbmMr/QU7bX0iYRi2kb+D7H0
         LwsdzlHKzCCmvI28OMd11n2G2Znp1NWqZZzt+d98TPwYE44ycNE8zxEIfGxJdmWsQgS8
         fgPQ==
X-Gm-Message-State: APjAAAVafiEEzj7CSym5rfOtjVOF454wxPu97E2HE6wkkgkkU7fPJVkJ
        0uJjXB7htRJF1ubdiAkVotk=
X-Google-Smtp-Source: APXvYqwKmBl3Gq2ZDl5DlBO27okzpmtbY4NHXTP+xx5IBbwlSUga2gqNRzZDovC7EAp+8YNY2SsRZA==
X-Received: by 2002:a92:d30d:: with SMTP id x13mr32912058ila.170.1577206151259;
        Tue, 24 Dec 2019 08:49:11 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id t15sm10263143ili.50.2019.12.24.08.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:49:10 -0800 (PST)
Subject: Re: [PATCH net-next 4/9] ipv6: Notify multipath route if should be
 offloaded
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dc6116ae-f25c-8469-d55b-64beb02b783a@gmail.com>
Date:   Tue, 24 Dec 2019 09:49:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-5-idosch@idosch.org>
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
> In a similar fashion to previous patches, only notify the new multipath
> route if it is the first route in the node or if it was appended to such
> route.
> 
> The type of the notification (replace vs. append) is determined based on
> the number of routes added ('nhn') and the number of sibling routes. If
> the two do not match, then an append notification should be sent.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/route.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


