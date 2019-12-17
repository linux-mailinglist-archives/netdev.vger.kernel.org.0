Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8057123299
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfLQQfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:35:13 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35730 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfLQQfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:35:13 -0500
Received: by mail-qk1-f195.google.com with SMTP id z76so5757906qka.2
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 08:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4hsK/0s8PL+6nEueLAF8iMvcACpG5LyaCfMthRe24CU=;
        b=ouip0pnwFVPH0Z08TmBjHyZZPW45gYU0h9zI4PfRLa+kARjS4p0/k3MlzyCwmXOEqU
         K+u9j/F5sbhzmcFQyoVPJ9hMWE0VA2VuRzY+mSPvCG/OGF8OIgg+zWVTh30jbnu3PnJG
         lWsLTtBNRswFNcdsrSo6Sz+JezKh9pK5LUKYw6S4bJpECI12WjbX/AJn0uSZnWHjDatd
         oxdtHBhKyYBHNihRadxtgVJq9WMJrj376Nx2WauIKRxMnheRnMwx7ZFe/B6vbTZCmscD
         vpe+TnEF13riSESO3r577s0NKYsH1C5K68biieREi398h4gOxR1YL8ZmVxLFq0vc1psY
         pY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4hsK/0s8PL+6nEueLAF8iMvcACpG5LyaCfMthRe24CU=;
        b=LrpOD0KuphA6ISau2IN2T5Hds36gLRqmKsho4Alnrf6hDj6JTb/AYzafZhTgf1OZYN
         s7+1tonr1g/t3zv1K6I4+RMabAq6jbxNu2Mna5oRudBDMEkGN/lNLar/511ns88mvvzB
         imYJuPruznEGH9NQl1DsS5G2Grb/DTAaLFgJZPBaDm9VN+LQLuiL3PKtmCoL4lp7jL2P
         fWYt8aShKpueJtLCcC26D1KuYf659bSfwSqGtvHNviyqmvlQtqhWQ3Ke07FwXW8H6IkH
         0J3510G86CSBUlBjorEJMlyeRRied+DZ5/OQkr/dN4hdXOK8MFe3POHkspq+t0xhyRsn
         8Rgg==
X-Gm-Message-State: APjAAAWDYOrvRSL+oW5oa7FLBFlvOzquUo5JRDuECQGKoHFwA4yGwKY5
        5/fyudFWO/sksOXtKDYpl4PJxsEqtFs=
X-Google-Smtp-Source: APXvYqzvgGGYyqLn2m7eFzYVW2GQtEDmoMc9Wo0bZPBPc3g3WGLxAeXQBGhzK6t9MjswPCRmDfM97w==
X-Received: by 2002:a37:89c7:: with SMTP id l190mr5999223qkd.498.1576600511974;
        Tue, 17 Dec 2019 08:35:11 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:b136:c627:c416:750? ([2601:284:8202:10b0:b136:c627:c416:750])
        by smtp.googlemail.com with ESMTPSA id r44sm1288273qta.26.2019.12.17.08.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:35:11 -0800 (PST)
Subject: Re: [PATCH iproute2 v4] iplink: add support for STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
References: <20191212010711.1664000-1-vivien.didelot@gmail.com>
 <20191212010711.1664000-2-vivien.didelot@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2166597e-b5d2-ee1e-3dc3-bfacdf3cc8b8@gmail.com>
Date:   Tue, 17 Dec 2019 09:35:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191212010711.1664000-2-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 6:07 PM, Vivien Didelot wrote:
> Add support for the BRIDGE_XSTATS_STP xstats, as follow:
> 
>     # ip link xstats type bridge_slave dev lan4 stp
>     lan4
>                         STP BPDU:  RX: 0 TX: 61
>                         STP TCN:   RX: 0 TX: 0
>                         STP Transitions: Blocked: 2 Forwarding: 1
> 
> Or below as JSON:
> 
>     # ip -j -p link xstats type bridge_slave dev lan0 stp
>     [ {
>             "ifname": "lan0",
>             "stp": {
>                 "rx_bpdu": 0,
>                 "tx_bpdu": 500,
>                 "rx_tcn": 0,
>                 "tx_tcn": 0,
>                 "transition_blk": 0,
>                 "transition_fwd": 0
>             }
>         } ]
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  include/uapi/linux/if_bridge.h | 10 ++++++++++
>  ip/iplink_bridge.c             | 26 ++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 

applied to iproute2-next. Thanks


