Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC78358709
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 16:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhDHOVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 10:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhDHOVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 10:21:05 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2359C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 07:20:54 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso517580otb.13
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 07:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wU2+tpWIloggFrxL5x8nb728jOdIxEZhw5INUq9tXc8=;
        b=rdBj1q5zYA1XeUOkGfyGa+Cq3l9nNzOOK+6f1oIrl3u9K4RtMyp9S1BUOD4hah9RrO
         Q9C0zmyGTS+IUCW39YL1lawTC4+g8R4DhlhYOTAUul6DxUnCJMji9aoCEQUwXbTiiTCK
         IFlbzguVcvxeCMATdEgwKm9C7wfAW3aituigY6gBg2MS3t5r7E/IhXphCgDjkJSH26wx
         oWG3myYbYy5E+fqq0bvSOT5trNBcqu4ctIvdSjkcCCzr4PZ3qLnO/snEoRMDs6WkRa4L
         8EkwSSsaGfGYSNcoqvWV1Fyv9YN35oThWuSict68aP97idI7dYChAXvAgzh6mGiMpdyo
         nqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wU2+tpWIloggFrxL5x8nb728jOdIxEZhw5INUq9tXc8=;
        b=eXWEUJf1t7/Xre0NSn3affvTaYgDg1QDnvLLy3SQlgsusAaCgLd6nQ21DqvNa9qqpG
         TULTE1NzCFazdoGaoUU24DBRdF9lKPiQWjmb7Uin25Gc6T4uyAS8Un48F1WUtpq2YhMI
         Iz3UOLnlOfirlsxMGV9yq2ePynWx/AyNZWAshIrNxvzcclrEMrVwO9Pnk87vCHYB5J4K
         W1radjRuwEZBfJMda3ghhsxugFUe1OUGXeCa3QWWM8+OmWwZh9qwgHBWYWuINadEaT0b
         X3Ulu6jKouTY0sxlasea9Szbyf5mwHgofmO/Ie+CRby4i1rEYX9lo37WFjb4Y5y/heUr
         Ws3w==
X-Gm-Message-State: AOAM530aixIUj/dkUEg755I3RxHDS077h26Jq+KdmVsbK0hQRNIZ7vay
        XSVq5GdDRgM457MaiCLOTGWYVIGzibw=
X-Google-Smtp-Source: ABdhPJzPF+hxTH+lE+QKuS2ava+W8JVdbgyywZm6OXRH4mEaDrdUZKiC5aORFliejhdP/bNISmF5Rg==
X-Received: by 2002:a9d:5f15:: with SMTP id f21mr7911081oti.226.1617891654266;
        Thu, 08 Apr 2021 07:20:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id q67sm4994232oic.55.2021.04.08.07.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 07:20:54 -0700 (PDT)
Subject: Re: [PATCH v2] ipv6: report errors for iftoken via netlink extack
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Hongren Zheng <li@zenithal.me>
References: <20210407155912.19602-1-sthemmin@microsoft.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ca823e42-1b33-1ab0-ec48-45cbd9772677@gmail.com>
Date:   Thu, 8 Apr 2021 08:20:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407155912.19602-1-sthemmin@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/21 9:59 AM, Stephen Hemminger wrote:
> From: Stephen Hemminger <stephen@networkplumber.org>
> 
> Setting iftoken can fail for several different reasons but there
> and there was no report to user as to the cause. Add netlink
> extended errors to the processing of the request.
> 
> This requires adding additional argument through rtnl_af_ops
> set_link_af callback.
> 
> Reported-by: Hongren Zheng <li@zenithal.me>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
> v2 - fix typo that broke build
> 
>  include/net/rtnetlink.h |  4 ++--
>  net/core/rtnetlink.c    |  2 +-
>  net/ipv4/devinet.c      |  3 ++-
>  net/ipv6/addrconf.c     | 32 ++++++++++++++++++++++++++------
>  4 files changed, 31 insertions(+), 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
