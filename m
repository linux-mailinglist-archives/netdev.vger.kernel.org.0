Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5830846D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhA2DwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhA2DwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:52:08 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B02DC061574;
        Thu, 28 Jan 2021 19:51:27 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id w8so8534693oie.2;
        Thu, 28 Jan 2021 19:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Vw+qMwlmTzF/zojJ72bFGqMB/HdDLc9w77FVa0Qgyo=;
        b=qNewQyw6pwfnCBUXYBN32ljHR6q5CvTG3O+QrFQHF2rPX9Km+dDFV8tyOuQx9tRs1x
         otDvnso9xHnYOV1Or8uP/PBlEFrtkujjFQfxCvVUhDYjIm+1r+02t6oyCClm85I+8QVe
         9TfEGd8ap5rc45rrHO3leDkGNORbQXYcSttdH9pi+mYPKV7sqiEpUSwheUa6nLj9hayb
         hHSn0iCUZhkz16E5LpWZ2+5Tms/yznxGMBJQDVgh9xqug+l7ov2LbEgV8kehwZp1kZ14
         SMKdQeW+BFsdvVo3rlSwDZD7pVXuJZN6zPe0GSsRBAo/1bPuyWSZLU4+/zKLyolwfjzD
         FCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Vw+qMwlmTzF/zojJ72bFGqMB/HdDLc9w77FVa0Qgyo=;
        b=R9dzVXKpxFhsOAOYdfa2tloIQsEOKOmgEZuyZudEH8PMdUejsaR2uf452LS4Gqfhlv
         Xb1Ue9MhL8FZ/qkIq2RJNbLCA3cEivsEaEI2bvIzPZL7JKeimRg+bfRtZmpourvVem3g
         daYYXAfl3Ls9MX33LIam6OKoDuMNht/v51/uATCDW6fQ0nvj+8Vijyfqx3rDZgUNOGNh
         E7AgJDUdTN73Kj7kVG9CjWJQ80k4D/jminBx/V5CR/84CoFXkOxP53kkxG42GHKPTkp7
         0G6cQ0Vt5bx+AvYP83Hp8cP7GdbNkFBBkWk4DJYlWAmIkVENrSAeGvw4EGbMss8c+TgW
         bGng==
X-Gm-Message-State: AOAM530BxqGZgbqJZrYmRwaN7t0Eg0XQFeOHt4xfuHFjiy3ujTIM8duK
        ugKGm3N+8X7eQzzpJCaIALBQc0AzElY=
X-Google-Smtp-Source: ABdhPJze9OlH7OGwWjnArhrP3iLXF8xOP58J5JnyBl+bv3NYVqiRHHdJxrIYYNv0RBw9H+aNLFdxWQ==
X-Received: by 2002:aca:ebd8:: with SMTP id j207mr1614762oih.11.1611892286967;
        Thu, 28 Jan 2021 19:51:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id c189sm1889528oib.53.2021.01.28.19.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:51:26 -0800 (PST)
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bpf@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
Date:   Thu, 28 Jan 2021 20:51:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <161168277983.410784.12401225493601624417.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 10:39 AM, Jesper Dangaard Brouer wrote:
> The current layout of net_device is not optimal for cacheline usage.
> 
> The member adj_list.lower linked list is split between cacheline 2 and 3.
> The ifindex is placed together with stats (struct net_device_stats),
> although most modern drivers don't update this stats member.
> 
> The members netdev_ops, mtu and hard_header_len are placed on three
> different cachelines. These members are accessed for XDP redirect into
> devmap, which were noticeably with perf tool. When not using the map
> redirect variant (like TC-BPF does), then ifindex is also used, which is
> placed on a separate fourth cacheline. These members are also accessed
> during forwarding with regular network stack. The members priv_flags and
> flags are on fast-path for network stack transmit path in __dev_queue_xmit
> (currently located together with mtu cacheline).
> 
> This patch creates a read mostly cacheline, with the purpose of keeping the
> above mentioned members on the same cacheline.
> 
> Some netdev_features_t members also becomes part of this cacheline, which is
> on purpose, as function netif_skb_features() is on fast-path via
> validate_xmit_skb().

A long over due look at the organization of this struct. Do you have
performance numbers for the XDP case?

