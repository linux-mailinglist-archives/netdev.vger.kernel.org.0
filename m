Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06928455794
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245067AbhKRJEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244972AbhKRJD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:03:27 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888B5C061570;
        Thu, 18 Nov 2021 01:00:25 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id b40so22556266lfv.10;
        Thu, 18 Nov 2021 01:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G27YXSER0dL2xbw6ocbzN4KLUhffd2ytCL7vYepxLzQ=;
        b=DaSp/3BbRNe4OzvN71UWlGcQ7tazW/+flxn4NmwK8LsDJDQxkUpOxM0PIukahVOmnV
         nNg0cYv/ypwZXdMS/uzmcI/mXX8ogO0vjNrgH921bOsLpplp6utWDLGbUpZtOrcNtBVR
         LRiwBftbOUVwVOUQHDjMj51IzoR5aVOu8O5i+6luh5VYNTPFiMlzcVFVxyvWNUwLYJlF
         z9E8rf1EtdfAwWvbHNWHmGk3XbU3IVT6GwUivtb/kxNrKpCahFTzKhkUXPgdJ+WUlftP
         IHPt9nlDPiFrInO6c9Gud+Q5PPESyh2J7n+Iioolhw/7bE7w/I/fAQjpEfMLL2KARddA
         TN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G27YXSER0dL2xbw6ocbzN4KLUhffd2ytCL7vYepxLzQ=;
        b=m1Ce2N2gVMzOOQkOQj9VeC6MTUAzYpgfiqKdVZLi7A7Eoosk3d5exf2bfCY5BXx4UB
         dc4gbvgnhExpH7emBAr3eQTehpToYW6/ngpa3zUdFDDyjbeNsaALh+ONOSUk5+Fb3cZK
         e274mAPMtQ2aa0QyuuJpngPj8fQgF6ni3q3OHXjqEIPTeb2mJB0QGDfv1IambM7yDogl
         mfYtOGe4r3FoZGKpBCu7vLGMztasZFHS7rtKgIB7NlBKnv7rrm5XgaRuy5yQKIziwPnH
         jUqVTbkTGTqxusFXpfYt+g9Ry7hd/MwfC+qF/s8CtdM05lrnGhk2mr9lAZoJc7yZv9aq
         67Zg==
X-Gm-Message-State: AOAM5321PSle5x5xqk80aRT++0YRirAPCWITBrzRjKfJVY9dRsjjr7zM
        TgzDcv9iSr9z/8QgJFqYXf0=
X-Google-Smtp-Source: ABdhPJziFAWTi66Q6JLiFDlf2F5623Cb+gphUPFq1reuEs4jYW3mOjks4xhyHREDQP1ye/+oXXMY7w==
X-Received: by 2002:a05:6512:e91:: with SMTP id bi17mr22424116lfb.14.1637226023900;
        Thu, 18 Nov 2021 01:00:23 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.43])
        by smtp.gmail.com with ESMTPSA id y11sm250477ljh.54.2021.11.18.01.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 01:00:23 -0800 (PST)
Message-ID: <018ada52-3e9b-8909-2346-ea2ce1d817fa@gmail.com>
Date:   Thu, 18 Nov 2021 12:00:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211113223636.11446-1-paskripkin@gmail.com>
 <YZYULWjK34xL6BeW@hovoldconsulting.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YZYULWjK34xL6BeW@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 11:51, Johan Hovold wrote:
> [ Adding Dan. ]
> 
> On Sun, Nov 14, 2021 at 01:36:36AM +0300, Pavel Skripkin wrote:
>> Smatch says:
>> 	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
>> 	warn: variable dereferenced before check 'ilt' (see line 638)
>> 
>> Move ilt_cli variable initialization _after_ ilt validation, because
>> it's unsafe to deref the pointer before validation check.
> 
> It seems smatch is confused here. There is no dereference happening
> until after the check, we're just determining the address when
> initialising ilt_cli.
> 
> I know this has been applied, and the change itself is fine, but the
> patch description is wrong and the Fixes tag is unwarranted.
>   

I agree. I came up with same thing after the patch has been applied. I 
thought about a revert, but seems it's not necessary, since there is no 
function change.

I should check smatch warnings more carefully next time, can't say why I 
didn't notice it before sending :(

thanks



With regards,
Pavel Skripkin
