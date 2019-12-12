Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31711C61E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 07:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfLLGzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 01:55:35 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41999 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfLLGzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 01:55:35 -0500
Received: by mail-lj1-f193.google.com with SMTP id e28so975115ljo.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ag166LO41mmIdH93hcAzJxPUu6DQ+iUSSg9O8F3Mz+8=;
        b=bOiADHgew3Ea4mYbibX0J/zHUQu24msSSDM1WwGDDvtHFiRtPwzVvTlAznwc5T8Usd
         /0NaheD+OFNIMT07YicGgnBkfBcqlnixQYJ8SUcl2sFpDaZ98qChoqfsIpUnD8dW3fSt
         FXg1lZcDeIK4fBamc7bQ3xx+ZdnAasH906KQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ag166LO41mmIdH93hcAzJxPUu6DQ+iUSSg9O8F3Mz+8=;
        b=EV2scFEmkbTignRFeQvgVmIHwWusySHQQM+exs580niEo0WyobiZdgoIHpwvIr7o6E
         4QWdTtjrLHm0LqtB/Nm2pW7gDuWSJaVJ/LVDQ9lWMCG6PEDdvEMuGeVTCsnAjQvX1djX
         M/NWRkiHcTo+PE+85v3sVb/wANiRS8pu+d3DkZxqI8mfBbL6WPzBssnSA0mAM+BLYm1h
         K9Lp1uLrptMbxM0KOd4m6f//3ahFr5NYdvmKEzQx5B2HpFntZf4fijyPyghOfV81lZ3/
         lTMBACCCDu+d4HjCJRgpVGaJoB49pN9FjDfUuuHcBEJv5kNcyl6ZqwDTYmmLv78dpkzQ
         SYRQ==
X-Gm-Message-State: APjAAAV9gPNIAAtjiAukr8OdoYg47TG+pV6oI5EXJ26dywsq7yoSjIQM
        gAnEGBgrTx9cd68vK4zaRkktzQ==
X-Google-Smtp-Source: APXvYqxfmn1yC+2iKxoENGwinteXcKfYcMJw6Ta1Md7l2HIh9+ngK2JufWxhXRmcIjvZOX7CAViBHQ==
X-Received: by 2002:a2e:8505:: with SMTP id j5mr4286573lji.235.1576133733488;
        Wed, 11 Dec 2019 22:55:33 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x12sm2401731ljd.92.2019.12.11.22.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 22:55:32 -0800 (PST)
Subject: Re: [PATCH net-next v3] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
References: <20191212010711.1664000-1-vivien.didelot@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <15115a6a-b95f-8de0-12ac-c3c98301ae25@cumulusnetworks.com>
Date:   Thu, 12 Dec 2019 08:55:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212010711.1664000-1-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/2019 03:07, Vivien Didelot wrote:
> This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
> transition_fwd xstats counters to the bridge ports copied over via
> netlink, providing useful information for STP.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  include/uapi/linux/if_bridge.h | 10 ++++++++++
>  net/bridge/br_netlink.c        | 13 +++++++++++++
>  net/bridge/br_private.h        |  2 ++
>  net/bridge/br_stp.c            | 15 +++++++++++++++
>  net/bridge/br_stp_bpdu.c       |  4 ++++
>  5 files changed, 44 insertions(+)
> 

Looks good to me, thanks!

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


