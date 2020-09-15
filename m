Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CD26A4AA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgIOMHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIOMGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:06:51 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028B2C061797;
        Tue, 15 Sep 2020 05:06:50 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id ay8so2749075edb.8;
        Tue, 15 Sep 2020 05:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NmVDpJdigpjIPbGElj6CdKUWLmHIIbTZhWfFEbQeewo=;
        b=BuvQKhiWj+3hbhvV0VVSPjWSe8kCnsGwqhkEN+C0rwJErOXkb5dwaGF8lrTMDJTTCe
         qAL22p1C3W+4im5GDM7M5h5sODxXm+TBq2H+IG22ynm7ONRtq070BPQuwni3oVQ7DKyK
         WNnVWqmhwtP1Dia0MBrm1fFQex6DCFsEZfTQukOo2GMn0kxEW1lawgNrTl+VduwjCM6U
         RJL/4hJ8zQEyFzhU8edD1iSdZr8IY8I08PPfDTl95VHQ/81rzRQeClOGMFjD4JB3xdoG
         Voft3UxL3+VNmTaglbYJT0kzLE6MsMv4y4ZmCPiFLAneFWcYg4ALTV+As57z4v3XlXGW
         gIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NmVDpJdigpjIPbGElj6CdKUWLmHIIbTZhWfFEbQeewo=;
        b=Rxwzefqk5t9sDVzssDpXFFQD8u1zlehH91kosmZMIKlPi/m0K83U0DX1NktkdKNwww
         xGS9axB1sNqSSW7SQtG1E0mgQXMI727f6/UoaEwofTd+qlZ6ylUwemCJhjbvGb7Q3X9q
         k2CkFZL7gmvQgMpnEEF7CSxFEV+NX47mHaXx+90DYej6FJop02Ar3EgE4KUmaBhADS6c
         I50ZmyAYuev4FctT67qTUAHKGz8UpXKf+UBV8S+fwS70MsJ9xsqlKZY7F4mV1hFVCYKF
         +znV/oJTvtZMGli0IEZWZaTxZp7sr9KL1Y8Fc01M7vmIe1PZhlkpR7GqyVDtp8yclyW8
         h3Ww==
X-Gm-Message-State: AOAM530k1LQj0JTiew2cXCjzez+aaQXynYYA6WMUu1b7uVUI0az31YwI
        0TXj9jjNJjjEQDW0AUsTUJY=
X-Google-Smtp-Source: ABdhPJwWgfIdyXmGY8qKT75hbTyNfAB2jWyQ8CRZQJRBoTiL/Ib/I7g4KqVdxe+18sIDrfLKX5ykrQ==
X-Received: by 2002:a50:bb26:: with SMTP id y35mr22847033ede.234.1600171609579;
        Tue, 15 Sep 2020 05:06:49 -0700 (PDT)
Received: from [192.168.0.105] ([77.124.39.109])
        by smtp.gmail.com with ESMTPSA id u23sm9932339ejc.108.2020.09.15.05.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 05:06:48 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value to
 ring_cons but not used it anymore in mlx4_en_xmit()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, luojiaxing@huawei.com,
        idos@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
References: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
 <20200912.182219.1013721666435098048.davem@davemloft.net>
 <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
 <20200914130259.6b0e2ec6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <d2ba619c-5d56-243b-7527-4c2efb6859ff@gmail.com>
Date:   Tue, 15 Sep 2020 15:06:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914130259.6b0e2ec6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2020 11:02 PM, Jakub Kicinski wrote:
> On Sun, 13 Sep 2020 13:12:05 +0300 Tariq Toukan wrote:
>> 2. When MLX4_EN_PERF_STAT is not defined, we should totally remove the
>> local variable declaration, not only its usage.
> 
> I was actually wondering about this when working on the pause stat
> patch. Where is MLX4_EN_PERF_STAT ever defined?
> 
> $ git grep MLX4_EN_PERF_STAT
> drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:#ifdef MLX4_EN_PERF_STAT
> drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:#endif /* MLX4_EN_PERF_STAT */
> drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h:#ifdef MLX4_EN_PERF_STAT
> 

Good point.

This was introduced long ago, since day 1 of mlx4 driver.
I believe it had off-tree usage back then, not sure though...

Anyway, I don't find it useful anymore.
Should be removed. I'll prepare a cleanup patch for net-next.

Thanks,
Tariq
