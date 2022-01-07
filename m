Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A387487556
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 11:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346668AbiAGKSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 05:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiAGKSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 05:18:30 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC7C061245;
        Fri,  7 Jan 2022 02:18:30 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id u13so13778504lff.12;
        Fri, 07 Jan 2022 02:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZD7YhhDKTDEuWPGK6mctDTK0jWtVv9tGPVcti2ncc5k=;
        b=J9hM2S2W//7Renbd6GkL5qPXmt079elMM0GXqfrQB8bkHfwRlLhzkhO33KtQAwdKmv
         tQpd2Pg4yD4DDRJwYQY+SHXw59VYRK+hXqt2CIcnVnghmK5YRpKHm9Z/Xk70UCZLHnFG
         2im7UDTxZAvArod99nAiyiWYuO0Lfey/HvFyeBjX5Ma1QmJQXnoGU2AmlPD6ULLnmCEr
         HLyWwM7ag0F/dC6wmcq+UKl1Hna/W/vZ8hT3rzIOhbKq/5kLDx4Joaps4etoJcR3JhOo
         4lSC7mBnVnuuiyQjkggLJrZmrgB33XFQYj/AjE0Zfc6DPcqDDVdXufjr8ubyIs7mL/cg
         8eZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZD7YhhDKTDEuWPGK6mctDTK0jWtVv9tGPVcti2ncc5k=;
        b=v9niW2LguHB9rXmKO42cibvFBZEE3EXKBBT7P2tD/6ZYAXAfuGeC5ac1j8RHPNmnKk
         le88eDGEZ/FdOymhZbvAJqaRxG5LbV4tIWtLCM3Cw1avSRy7FutBjm71X/AvIEeEXR9U
         mVR7m1O8YDzyp2ybpaJ6kNxknp0JfmIoi2Qy/6ky5RyU5FK0AmWGJEoplPkODFvg/KNQ
         GK9w6rJ37LlOHEqCNUCHAJSLOk/q6cDjTTAjqOF+Ul9ZPiyL6bPuQFNyNSZLtzdTwQHG
         69JCb+WKLJeg7ksLNyyPfyDOP54WhSnqCa+QZBKZwvgi3Iqfh7kANPdoH/Z9qWooSEaX
         zH8g==
X-Gm-Message-State: AOAM533Abrb7Lo20H26Tg5ob3KlOpWOooASkdeDQDmtJtoPyzAjDXFe2
        ICSI9v0VjmjTALQtD6o4VOM=
X-Google-Smtp-Source: ABdhPJyuWvpSKaSsRhcrqKuWxrCcZuzzF3OOvIJNaqgof+I90OpfyqhaN3mQRxgBjjEhpik+HnjtTA==
X-Received: by 2002:ac2:4c51:: with SMTP id o17mr50588944lfk.558.1641550708531;
        Fri, 07 Jan 2022 02:18:28 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.67])
        by smtp.gmail.com with ESMTPSA id by6sm551536ljb.78.2022.01.07.02.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 02:18:28 -0800 (PST)
Message-ID: <d36007da-58a3-da8d-dcad-e41b1c5cffa8@gmail.com>
Date:   Fri, 7 Jan 2022 13:18:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] net: mcs7830: handle usb read errors properly
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        andrew@lunn.ch, oneukum@suse.com, arnd@arndb.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
References: <20220106225716.7425-1-paskripkin@gmail.com>
 <YdgQuavHA/T8tlHi@kroah.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YdgQuavHA/T8tlHi@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On 1/7/22 13:06, Greg KH wrote:
> 
> We have a usb core function that handles these "short reads are an
> error" issue.  Perhaps usbnet_read_cmd() should be converted to use it
> instead?
> 

I thought about it. I am not sure, that there are no callers, that 
expect various length data. I remember, that I met such problem in atusb 
driver, but it uses plain usb API.

I believe, we can provide new usbnet API, that will use 
usb_control_msg_{recv,send} and сarefully convert drivers to use it. 
When there won't be any callers of the old one we can just rename it.

I might be missing something about usbnet, so, please, correct me if I 
am wrong here :)




With regards,
Pavel Skripkin
