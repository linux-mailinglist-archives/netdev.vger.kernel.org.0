Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6411544F5A7
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 23:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhKMWoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 17:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhKMWoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 17:44:55 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D66C061766;
        Sat, 13 Nov 2021 14:42:02 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id c32so32166113lfv.4;
        Sat, 13 Nov 2021 14:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=36izzyIF76QglA+4uY44TduvmjedGPYh2aW443jQ/6M=;
        b=Ur58Y8Cgwn0Mvb7e5C18L37sSlfq4+rxJ/nAi/hWXaDNDa/fn/rNaP93wmHZMPZhmg
         sr3gF4GM/M6tSobleNDdgJO67gIFzKE/0UR21iupMPgtIy/olhmZsIb2mP8Go3TVpyH7
         oV2JYlw6YezRI12eT+LvMiu8sbLo5nl3LufkNspJOnm5gMqKKN6OqaKyySImDN4wFGZT
         B/4iPaDtoetVa6Z7a/Ka/tebHDJu8ulLyqBN7sfVUQ+YpRK2MlasHL3n7ZJsnDfL1YsL
         ZSqwj7C0GRyN/Ut2vVQFVTcAobkf1ArsmdhcRrD0oz/imyLVeaEZ12BZulVvrI9miQ2l
         RJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=36izzyIF76QglA+4uY44TduvmjedGPYh2aW443jQ/6M=;
        b=j4RoZIV+RO72odXmh52AqrmJDQvuk9+3MsLSBlxSAt1Pu+v0QnSl61agyVX/gIH1Xk
         eeJzHkczwXyQcO/0xbRftV0j4Z8JZ7JtE5qtz1Zeysaa5n3hdHg0/0byit/sWRpOENxg
         Y9zL0FCYDlPVeqtCwDyOSXUytNzyOYuO0T4gjuzzfiJGTxYLmKdT6grpitVlWiagpUh3
         uzfKPBvWZC6MhVWcLaBI0P2APNzJqg0TWHE4KEeljTmff2Ph5FtM/dtCibzYuCFn2n2H
         EZEjFTifNT4UMADsTWd5ZWqRGkPDH9PIbTnjkUMP3l6dghzrpCZu9E1Hb9eqV4/bLS6A
         L0hw==
X-Gm-Message-State: AOAM531yWdTeGjtHgWA0mNaR1LTMNGxShVn3JZ3DhlRRr5q+gR0Z904/
        GKxCya75P4yqA1WaEuMMu9feX9hQbUU=
X-Google-Smtp-Source: ABdhPJz5ZaVlBwrOteLkOgNZYWD9O+dgnIwEsl8mRTOl+JGVVOS0nuyi3F3hB/oDOjRiKMbcrJ7UVQ==
X-Received: by 2002:a05:6512:2202:: with SMTP id h2mr8166558lfu.576.1636843320509;
        Sat, 13 Nov 2021 14:42:00 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id c21sm976189lfv.29.2021.11.13.14.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 14:41:59 -0800 (PST)
Message-ID: <b99360be-feea-c33f-40ab-e7301307a794@gmail.com>
Date:   Sun, 14 Nov 2021 01:41:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
Content-Language: en-US
To:     aelior@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211113223636.11446-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20211113223636.11446-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/21 01:36, Pavel Skripkin wrote:
> Smatch says:
> 	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
> 	warn: variable dereferenced before check 'ilt' (see line 638)
> 
> Move ilt_cli variable initialization _after_ ilt validation, because
> it's unsafe to deref the pointer before validation check.
> 
> Fixes: 523224a3b3cd ("bnx2x, cnic, bnx2i: use new FW/HSI")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 

Btw, looks like GR-everest-linux-l2@marvell.com doesn't exist anymore. 
It's listed in 2 MAINTAINERS entries. Should it be removed from 
MAINTAINERS file?


Quoting private email from postmaster@marvel.com:

> Delivery has failed to these recipients or groups:
> 
> gr-everest-linux-l2@marvell.com<mailto:gr-everest-linux-l2@marvell.com>
> The email address you entered couldn't be found. Please check the recipient's email address and try to resend the message. If the problem continues, please contact your helpdesk.





With regards,
Pavel Skripkin
