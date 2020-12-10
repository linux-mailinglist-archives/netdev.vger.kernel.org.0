Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2C52D5188
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgLJDkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730272AbgLJDkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:40:13 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B90C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 19:39:33 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id j12so3633789ota.7
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 19:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lQ9NU7IKIzuslZygyQniKWMKQh+unhXV+76k9m1SeJg=;
        b=n7pOezeuq9Qs+2j2lF1yQhEHTyxFKC6JZxAlMWKE9GJiXSrQZo2cIvwTo4a+pR6Pvv
         tvw2S3Uq+fA1BBX0NI590Y6PGcBZoFSZOHbeb1NweEQ4iJKuLbubH+srXuFSueHXTvn4
         F+yv+3eMd5tF4+PiwDNhM5A2MHKJ5NHTVGhPPqBL39PVW2LXrnG5jW459yclzKatycZM
         8xt1G/YMeB40dJqNOWHp1IByYL0B8v/5M+vDqeUMyf1ZnytHbk5qVrddEvc/tuYzcqHC
         hS01avdLWqTg0ME44437duJbjasmLGdhehjCo/DEugsKbzg3fDiIJ/g+0tJ8iGyBsoo+
         UcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lQ9NU7IKIzuslZygyQniKWMKQh+unhXV+76k9m1SeJg=;
        b=VSQJAQqRUhOSpyyUO2nUn9TebD3pqqHfFpry+K3k6wOCzoDq+A02gJyAB9o6hxy5Nv
         DJN4MzavoeFld4AHnAuSV0+nk8hEBbrgPN02ejzDPNwAm78haY+0GtSFdGBCfGkdEsX8
         JWm/saS872jBZOCKssZmcJ/DSD1CcFKcmCaC6NpvFCi7zwRBAcZVtqT7DHvE/HRFTgfh
         eTN/h3Xtq9GbzZCrGFQ7+HTacY+NagUxQtmDUNQVbKGOfZAflgrZS5eg7QaSSzzmaHs7
         OKDKj2Y02siQF4x0UTu5v/2W22A8vOO/ZzQdRAD2IsP28cLrXUXZFSgCfv7UDNp6PR4O
         g8tw==
X-Gm-Message-State: AOAM531mdVgD4bX0yhjGrljNZ/QF2d2SmrD1xxRuTvVXEN9QNaId1iwX
        TW6uT/J18JlPEuMXhLSrmmE=
X-Google-Smtp-Source: ABdhPJxebimeQo9FIKsTb4/qoxFN/i7Q4yZjabT4k1BX6P5eTHFd8QrtNe7n+CXj7RGo9rIE4LfWDQ==
X-Received: by 2002:a9d:6199:: with SMTP id g25mr4422363otk.17.1607571573088;
        Wed, 09 Dec 2020 19:39:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id p28sm589649ota.14.2020.12.09.19.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 19:39:30 -0800 (PST)
Subject: Re: [PATCH v1 net-next 04/15] net/tls: expose get_netdev_for_sock
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-5-borisp@mellanox.com>
 <f38e30af-f4c0-9adc-259a-5e54214e16b1@gmail.com>
 <104d25c4-d0d3-234d-4d15-8e5d6ef1ce28@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ae89bba7-2541-e994-41da-fb791ced7aa7@gmail.com>
Date:   Wed, 9 Dec 2020 20:39:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <104d25c4-d0d3-234d-4d15-8e5d6ef1ce28@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 12:41 AM, Boris Pismenny wrote:
> 
> You are correct, and bond support is currently under review for TLS,
> i.e., search for "TLS TX HW offload for Bond". The same approach that

ok, missed that.

> is applied there is relevant here. More generally, this offload is
> very similar in concept to TLS offload (tls_device).
> 

I disagree with the TLS comparison. As an example, AIUI the TLS offload
works with userspace sockets, and it is a protocol offload.
