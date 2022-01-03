Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315C6483599
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiACR3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiACR3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:29:05 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB2C061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:29:05 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id b73so21825336wmd.0
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0A8BHjkgCfIkWc+2lQcMczHEzJvePax1izJu0k3TidE=;
        b=eLmCDCgbSpEBP/sA17Z9jet6DGd8/tCirS4zFk5h8KfTk7cRPKUhRCyN5N3NEv7dIh
         h37AalMVfikzqYa1QpLBhJLoWEA1zQg3o9X0FKFWamnW7lLSBQduW3aOcmBVhOcOG9WR
         5zNcdxsLcyEcLN3UaQMWGA8MjZNTrj+OuE3nXpGnYXoKbSl5qa+tAXKs40EM13hR6itb
         rngU2wzYAQsLxQ1MO7gwETifjYWx+vLy4QZiDgdZ/cbL3ytFoJJt2WTKPqQXoPq2Ld8p
         q6+rcFrLyNbsJGGHW2AqG6qv/tkHsukx9RGcj+PFZPlRKHW7ap9kbnn9BI2hmCdT+SbT
         HLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0A8BHjkgCfIkWc+2lQcMczHEzJvePax1izJu0k3TidE=;
        b=ekPvzAgQF4/xn/yi8zbJVCfG2uDLX2v4gcgvFY8J5JgUwtM5tLEIUVXeO/9jN1zNRG
         kqeI6eMpVrIQERHXkRg4LSLWu1K389R7Y8yuPuM1n3AvnEI6enqKiupFyY3xWz5QSMuG
         IAGK1N/yJguCUqDAeujhYB7pqqvrfN/7NzwnMoIVJgAjAey1ejngYUB1xQ7JknzOiF7s
         /cXwbFX/uygeWlaSu4UeIx1Cbys4sQUqcsBXX8gZ+qiQvJ6DglCwX3EYneyhL9jw6Pd1
         py1uqibFei6cY08SIbbwCKFtAQnJicy6WrrAqZcyQ6NKDfPPCUrVgT3fhpJRR5Deuwd5
         FXFQ==
X-Gm-Message-State: AOAM5330Yg/kugciyis/8Sd1kXHNn+xItPbh1CqZrYwyU8UdVbQcaYKa
        hV6w/pbi8thBnivYIS9AsFoBg4ZMTVAalQ==
X-Google-Smtp-Source: ABdhPJw54C7R+vPJlq7AGwMBf2GVfzutuXoZMUTA7yPMX2qvOmy6kB8USK30e7FfE8q5Q/TTCN+/Mw==
X-Received: by 2002:a1c:a54e:: with SMTP id o75mr39146520wme.121.1641230944075;
        Mon, 03 Jan 2022 09:29:04 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:b97a:ae5f:e798:c587? ([2a01:e0a:b41:c160:b97a:ae5f:e798:c587])
        by smtp.gmail.com with ESMTPSA id u10sm37074003wrs.28.2022.01.03.09.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:29:03 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ipv6: Do cleanup if attribute validation fails in
 multipath route
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <20220103170555.94638-1-dsahern@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b90df133-61c0-aeae-1e6b-595eac1a33e3@6wind.com>
Date:   Mon, 3 Jan 2022 18:29:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103170555.94638-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/01/2022 à 18:05, David Ahern a écrit :
> As Nicolas noted, if gateway validation fails walking the multipath
> attribute the code should jump to the cleanup to free previously
> allocated memory.
> 
> Fixes: 23fb261977fd ("ipv6: Check attribute length for RTA_GATEWAY in multipath route")
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
