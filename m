Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947BF1B135F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgDTRnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgDTRnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:43:17 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460B2C061A0C;
        Mon, 20 Apr 2020 10:43:17 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z90so9214115qtd.10;
        Mon, 20 Apr 2020 10:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HzvPqF+/00tNhJs84jwMPWSAXtl4fvOmIpjWVPdE/Bk=;
        b=mSTFNrZELvfJBq570dhtxfqYqVz+LbMFEcYlTy03WGjOynpbJ7SWv/XXNqIrcL9Kow
         9Lcc71lJ1hGz8IAKRVA2L56n3RYKgm8rtOhQUJw6TluQXFv4+vhpaCAKqltlCOO9US5J
         addS+E2gaK1jBhcvCW/sPJ44bb1tCe7tuZ3jWnlAWME3CtlkswXxRSO4a6E0WGeFHE0M
         fvGlx5l+BFBF8ZQkjkpReXoT5VkyQ45XMFiX9hcyRaG/WOGMowZW326Suwm2ZqI2hEF4
         +Ff+9cA+qY1pUaUezGjoHnHq9EGhE7dmI62MmrZvacOJDJ5DA4KVBt2hPnyz8WT/lCeU
         bBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HzvPqF+/00tNhJs84jwMPWSAXtl4fvOmIpjWVPdE/Bk=;
        b=BeXlZ0CnrTYeZjyq4TCoi1jk3g+5yXH1Xh3/Dbkbvavk1wwcmXEzVrLia1JRnqEsYq
         oFi5e3Gw3mVUp0gEYX1hr/9qkNaxgR+4/j9kwYzBfaI9/2vpCSCzgbiuCw494d1VapxA
         +jhtznhZGBp5rIhBTd4m8IvhcTgvFRGZHr1tEcEW/SpibiEZVHom2pAwSkIgWa5GpvmI
         Jm+P0hIoMPOhTsBFM0fGmDTfRCqylrxs/EcTBJrLeV2zP8ZozlVBeBpy37wxMi8mqTVd
         W5inKIuMT47h6mYYgRSaonInlpFvUftDPCPCKca556x3P32EvebVyqVD5pQyXqcR1HW+
         U+WA==
X-Gm-Message-State: AGi0PuYuzHFJuMkiC8iPDh3TanaishsFUE+Oe7opKY5/m/DBFNzkhjmr
        5E4V/ArMhvSGzJTi0oiBjMo=
X-Google-Smtp-Source: APiQypIshmhHqXBgxo6g9jJwpoGYSMooEoOYNuv6EM+zhvTmuSurm1cEyHQcLc6dYRrL5MLFf8bWWg==
X-Received: by 2002:ac8:4f0d:: with SMTP id b13mr7773085qte.5.1587404596565;
        Mon, 20 Apr 2020 10:43:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id x8sm936283qti.51.2020.04.20.10.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:43:16 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420174124.GS6581@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c1c0bed3-3841-8e08-f4bb-297d4420cbf4@gmail.com>
Date:   Mon, 20 Apr 2020 11:43:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420174124.GS6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 11:41 AM, Jiri Pirko wrote:
>>
>> I disagree. There are multiple master devices and no reason to have a
>> LAG specific get_slave.
> 
> Do you have usecase for any other non-lag master type device?
> Note the ndo name can change whenever needed. I think the name should
> reflect the usage.
> 

right now, no. But nothing about the current need is LAG specific, so
don't make it seem like it is LAG specific with the name.
