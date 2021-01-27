Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86303051E1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhA0FTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhA0FJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 00:09:24 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9755AC06178B
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:08:42 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id e70so543461ote.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DXmWT/wwD5Zyj+UXEZs44c+VTqRax5B3T6jJJNdDLKA=;
        b=kmbaeQcIBx3A7kFGGtSccqHURyDkL/DPUH9Sm+635toxoZU07fl93IVAmFVFHaGLme
         Gg1GHPWt5IZCb4X7oBikQwyYkoB7wLDCJfPaQO55+m5H+wPuEo25wTiK9na5tLLVFWab
         yYPcpZ4hVl5HM5H9xpCcUzt7MnzZaX3xKDr27ErM7ciJjqboGAIcWkDOFDwXu247eKkr
         5VehVNN1i3f/temiTyTR6KBeJxQNTtHY3XUexZmQ76ltOgp136Q82Hbq58hStucvKP1G
         IlMCZtBZmFW0D0UL7VwiZCaobuPpZ2K8fqOumqOoBNQqHCmKZ13GwHRJxsf4g1ZrMBpb
         YMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DXmWT/wwD5Zyj+UXEZs44c+VTqRax5B3T6jJJNdDLKA=;
        b=oc93mnfqQRchVEr3Mq2eP0XaxUB0OfzeovD3c1r6zBOh2fFMnjG3TftdH86xNI/Qh/
         TknvIYDfQD61aB4dfWN+3jD05Vb8uw4ywapecdooHRH5gmI/9NhsNGUcJvONh4mDMSSh
         lMRKNTdcAwlx+2XWhbRokQzn1sFzWm19xGwaFjNLXveivoAtSQQ22YolsVuLMiMLWz0I
         X653Ggb+nSy+lhPuhgja3Z2UC9eVfN2rWC24LhNwRMyvfW0X8+vr9HhaJxVrHuobJ8sw
         n+fbUqg3ZjnRtScd9RefrRKD7GcIHhVIB/XtVTsL5AkY5ZJIXXb6mK8gnQqhv4MjahXH
         rTBg==
X-Gm-Message-State: AOAM53030SjhOjt9qxNxp9bK0aOct+LPPVsZxF6BsHQCTwEBB4kU7ADy
        TgSEchXjAe7Gj2LgPDdIOQA=
X-Google-Smtp-Source: ABdhPJwb3VlDoR8JoP5t53eLgYzjFt/bGOgDtVoKZB5ul/oGHk36rjaf1hwpLPMpqcHxyz4733Db/g==
X-Received: by 2002:a05:6830:154d:: with SMTP id l13mr6550855otp.72.1611724122105;
        Tue, 26 Jan 2021 21:08:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id u7sm249137oib.22.2021.01.26.21.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 21:08:41 -0800 (PST)
Subject: Re: [PATCH net-next 06/10] net: Pass 'net' struct as first argument
 to fib6_info_hw_flags_set()
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a079f7db-a811-de7f-077f-c1d3057735de@gmail.com>
Date:   Tue, 26 Jan 2021 22:08:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> The next patch will emit notification when hardware flags are changed,
> in case that fib_notify_on_flag_change sysctl is set to 1.
> 
> To know sysctl values, net struct is needed.
> This change is consistent with the IPv4 version, which gets 'net' struct
> as its first argument.
> 
> Currently, the only callers of this function are mlxsw and netdevsim.
> Patch the callers to pass net.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  7 ++++---
>  drivers/net/netdevsim/fib.c                        | 14 ++++++++------
>  include/net/ip6_fib.h                              |  5 +++--
>  3 files changed, 15 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


