Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C892CF1F6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgLDQcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgLDQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:32:46 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB4C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 08:32:06 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id l207so3852841oib.4
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 08:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6V6ugaSMwHvUugy2/G8rXllUlG+uEehtkhroZYeS8dU=;
        b=UV+YSeNR4zf5O3ZAVa49X+zOSRnzFs+fDL2Qkgvyda9FUeawKccjtWxlVp0sWqUY9J
         7awPuoLQK38Shl1JqcUl3uXual1jw/ub9joDXrfyQWQt2m+qn+k16Q1+XZTAFnTnJHvM
         L4785sOorSpmd4FVLyMtkTNl98d9vCrqPScvkSev2EKNGlpHQss/8hpsJzmJIqwbcA/b
         BAS/BEYUERlHjlDWy+OdkIQBnmfrbQdLCIlrwwtochvD4nZb0IHdsJwd2O+tOfVRXUVq
         YDEYcTM2I7a7tOR+1w5wMNyaEUwJRT3xXuXJhjz0fWj1yGDHkI3kwkr8F3rfB5kVZizT
         Vkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6V6ugaSMwHvUugy2/G8rXllUlG+uEehtkhroZYeS8dU=;
        b=Lj9J6jy1567pkuDcmVImMGMTf2Z7K5uhh85obmRgaPdLwwkVOFUSqgMOaHIVU5lpjc
         OoyZOK+jFkptxHSkw/x7o7Fl2bx3jcqI6CzcSJeEic+huGgF9DCXqorcBK4QjVZtmWyy
         7+/n3Z5vX22ROs2YmbnWaiVUxp3S0rArjYDvtGA8m/6pUvRYgr6bN6vm3E+C5WTvKqXp
         I3DQhsn0mNspD/P1sm6c9vKGtjPOFJf6EVZOArfPqRh8K4c1ZC4d3GeAjIePc/XROjqU
         zo2zymUXl/h53qUkcGWuQLxPQFKYN8CAM4csx2JZxdRu/kmnp/L2mSwgb6Rwzo8P5Mhe
         Rbxw==
X-Gm-Message-State: AOAM53068f8pB9i8M2pnDM5DQ4GLTfnTbIZi/TYwzXDIx/5WGAdLHQzY
        21PwaSCxMUjKqZRLTUlVWHwtQwoxtcQ=
X-Google-Smtp-Source: ABdhPJyQ3R5ZeQPy0k3zJua3LHVsBSfM84h8JT172v4hCsrjsoOY5g+YbPtfpdQZC4VEGlLP8UGv1A==
X-Received: by 2002:aca:5114:: with SMTP id f20mr3601909oib.107.1607099526016;
        Fri, 04 Dec 2020 08:32:06 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id y18sm729989ooj.20.2020.12.04.08.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:32:05 -0800 (PST)
Subject: Re: [PATCH net] vrf: packets with lladdr src needs dst at input with
 orig_iif when needs strict
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20201204030604.18828-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6199335a-c50f-6f04-48e2-e71129372a35@gmail.com>
Date:   Fri, 4 Dec 2020 09:32:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204030604.18828-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 8:06 PM, Stephen Suryaputra wrote:
> Depending on the order of the routes to fe80::/64 are installed on the
> VRF table, the NS for the source link-local address of the originator
> might be sent to the wrong interface.
> 
> This patch ensures that packets with link-local addr source is doing a
> lookup with the orig_iif when the destination addr indicates that it
> is strict.
> 
> Add the reproducer as a use case in self test script fcnal-test.sh.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  drivers/net/vrf.c                         | 10 ++-
>  tools/testing/selftests/net/fcnal-test.sh | 95 +++++++++++++++++++++++
>  2 files changed, 103 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
