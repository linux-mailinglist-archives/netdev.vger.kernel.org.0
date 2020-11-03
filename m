Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A472A3A00
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCBpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgKCBpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:45:15 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F8C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 17:45:15 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m9so3238341iox.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 17:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vn1gEQhva8Z70OIaJq2gyZBLe2R4uui+uikjVY+uZFM=;
        b=K3jFRnr1DVaGjSm2s2QV36OCl6f00bY3YfNGNHQrT8RgIQrWSsMPSiTTMvweBw6+mo
         a9YQfdfNfedwT8epEpTVu5Gx2RdGoQo/6fSTfbwNYEYHg7Rva2FQl8Fz75c89D7OsUke
         UIuo+HAIpC7R9XkXFynlx+nnXiUtEC0UafoLVAWib7C/sikCMJmlYmsbjIqfhOKUmvKx
         17WtfAyrA8Y8En+oa4CEegbOgZ1UyQnQoYzby8CeILMPS7JDX/HB+s2sPoiE/ZN9q9Z0
         OZTLQgTj0qQ5bN0CnFnvuzAf0aQyZDaXK7q4p97lawD42gmWa485N4pAsXbeX4I9oAOe
         hCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vn1gEQhva8Z70OIaJq2gyZBLe2R4uui+uikjVY+uZFM=;
        b=Asg6Or2n7dkD29vSvc6Pmwrgo836VIZZOzqkNlsOU5G8WVLDMSWQ/K6JocY5/DJpwX
         nDFhpsEb1IcltYcY0ZglVTTHqIils4bpV3ePHDKFFQ9pgdNoYx1GydaOV0IljuAVBl5L
         wbreSVkv4hKKFsJsWeWFnZkDmiaCc2cd5PrIk0GNr08AelkUxyhsYlYHJtKLM/k3yAIY
         3EiO2GXRnFuZ2Hg9Ujmt3VXSSi/aNXOnoC7okkOCDxfaKLMBu8vDmvBsDois+cmZRWTD
         S0oEm1YymSNG6tTVrSJJFyvq/tgSUeqx29w08p5e7R1RijVoXf9lNNmLMHNXOBSSGuLy
         v1yA==
X-Gm-Message-State: AOAM5338PLqSTbZzsDRzF9905ewQ22U/Czh2pYmu+CzsLFxVq8kSWS0D
        rkXg8d6N3dtepsUOk5Fcugs=
X-Google-Smtp-Source: ABdhPJxoHDFx2Uke1+ZmvaCWMdueTrRGGukVllFDgYyTbJ3WFZkTT6q7/wdtPBdiyaT+n6np/U2YKQ==
X-Received: by 2002:a02:bb93:: with SMTP id g19mr14614943jan.142.1604367914879;
        Mon, 02 Nov 2020 17:45:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id d14sm11240248ila.42.2020.11.02.17.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 17:45:14 -0800 (PST)
Subject: Re: [PATCH net-next] vxlan: Use a per-namespace nexthop listener
 instead of a global one
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20201101113926.705630-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ca51f883-736e-f862-a3b2-5f6f34b99d4d@gmail.com>
Date:   Mon, 2 Nov 2020 18:45:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201101113926.705630-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/20 4:39 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The nexthop notification chain is a per-namespace chain and not a global
> one like the netdev notification chain.
> 
> Therefore, a single (global) listener cannot be registered to all these
> chains simultaneously as it will result in list corruptions whenever
> listeners are registered / unregistered.
> 
> Instead, register a different listener in each namespace.
> 
> Currently this is not an issue because only the VXLAN driver registers a
> listener to this chain, but this is going to change with netdevsim and
> mlxsw also registering their own listeners.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

