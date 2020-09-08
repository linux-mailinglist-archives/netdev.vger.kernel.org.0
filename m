Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBAD261F70
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgIHUC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbgIHPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:34:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC59C08E826
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:34:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q6so15541463ild.12
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FubCRxUQOSL1Vu5kICRZAzmRwuTQdv9sXq51B7zYU6o=;
        b=exmwMdxhK4kwnWCVf3LRBCIFKZE+P+xTh778CFSsHfjkNUMl5tYNEQMjR7X1ZVpAfL
         lC0VkApnn5lqjvJaS+J1mQ8BgOBzMcWxIzplLPm54Ot4rKLIh9Bk+XZUYx5f3E3VfY+n
         N3CaDSKRfi2FmilpFqpv6jHKeOgyvWEH55qfWBe/shQxprvCROaWaGGsCZ6tIETfcnbV
         fIEXeEyxoMUQt2oez4Vpb90rGAPVFuKyAtebnIoCki7Zt3VjVi+jsYI+8mkH2MBd2S1p
         iqV9TNdK5c7E0mrLxThAzU2//15yHW18mFMmk7hqyEoMDAHdrkxc4mAOZkk3xKH4abvq
         5Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FubCRxUQOSL1Vu5kICRZAzmRwuTQdv9sXq51B7zYU6o=;
        b=oG2MT2SUcae3f+3Jqmpto/q9V4lhykKKD+4Tech9v7HBauvbVoqLNQwBL6P4HaK92S
         PYkUZDdhcbkuTqOO0FqzUqCLM4m0FWSdqQq8A4l1VVFG/w0fVs0OiHBi9xjfZDzoE4pb
         jJxhFMc9vt+1qCycWzkZNLa1Ky7+gMQecLkgDFWLJU4UguT4YGoDQhJtSeBjnNBf0h5V
         k8ilHPyUt+Sr4ojS0lhIXRdHDUh2/gtBRgBMf5jxtkNVSwDceDMOWl2x+t2/9uHuc7/O
         oWMmm0+dkK/80xxpHdxDFj5OHqEuYi0yh2UQUPXt8rBIFdLS6r8XDk7ykFSLiz6Vj5U6
         aO1g==
X-Gm-Message-State: AOAM531wIcnPIdRoO8P1vr7wMv37QWr/EaCjy9QhWEFLs31HfJ4t0LVw
        01V2WVpW6GQXq6U4acSfPcQ=
X-Google-Smtp-Source: ABdhPJy+Dp5WdcDrgQVj2gWUYBdDEVrgex9Z15JOdmrLb2qfcytq1lHWse929DwhhrlzymHPbuGqXQ==
X-Received: by 2002:a92:c009:: with SMTP id q9mr23948613ild.73.1599575686428;
        Tue, 08 Sep 2020 07:34:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id r5sm4104710ilc.2.2020.09.08.07.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:34:45 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 03/22] nexthop: Only emit a notification when
 nexthop is actually deleted
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b0168f8b-8a45-680b-80d8-ed58294774a5@gmail.com>
Date:   Tue, 8 Sep 2020 08:34:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, the delete notification is emitted from the error path of
> nexthop_add() and replace_nexthop(), which can be confusing to listeners
> as they are not familiar with the nexthop.
> 
> Instead, only emit the notification when the nexthop is actually
> deleted. The following sub-cases are covered:
> 
> 1. User space deletes the nexthop
> 2. The nexthop is deleted by the kernel due to a netdev event (e.g.,
>    nexthop device going down)
> 3. A group is deleted because its last nexthop is being deleted
> 4. The network namespace of the nexthop device is deleted
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


