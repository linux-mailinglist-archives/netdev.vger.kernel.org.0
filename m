Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B94965C8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiAUThJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiAUTgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:36:54 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92630C061749;
        Fri, 21 Jan 2022 11:36:48 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id u6so4219674lfm.10;
        Fri, 21 Jan 2022 11:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yWQRw+9myUJERoCWU8cKt3zBqGh8K1JdfKd6Yv9H6iw=;
        b=g8lPO+Ver5WayaHmKoe+WMYVRUKrxEOGEYTvl6bnqTrKeMA6mODc3PhoacZy4YPoug
         3SRTkkeNjJnzc+76tdwyqSkN30VUmB7cWRou503RvYaBMIvWcv/Nyt8+nOwWFrY6GKxr
         80rWO/hipWLcEW2Ttpruszvf33EVjaEks0eCjnsGfTKSdhx6KGN2LZVStUz4x4OeVJy6
         j2esl7SmliqdmKyxU0f4UJpDjRAodOmygrtnnJt4u8e8kGIdb0xSfwq856h2Rn9EGFuh
         ZeLcAifdCzFibwNu/uZLJFwpoYpVc64PnGYkQfucMGxU8HWd6goRuNrraZt8VMOBqRRq
         US8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yWQRw+9myUJERoCWU8cKt3zBqGh8K1JdfKd6Yv9H6iw=;
        b=1l+HiL49eMbWqNBZAizUVCNGytRuqTD3GXPUfNADOFfMdArJevtuCxuORvj6wYnUDU
         70rXUN42lJzhmA45hk6mSywnYIuHFGEAU8OxLRvEBeG9psl9WIW5aoWpYVvEDnkbdZmy
         POAZpZoZtVK3jzsTo+13Yspx2xaThMim++2Iw3SdAnMSIrq7b0dpnAKZhPdW4tc8Okg0
         PiuvDN6GbWuSMosdWFhpYsFKTUPlom3d7CC8Gf0Ti8bfz2YUB0f3QGaqxNQmd6KL/dHe
         0oErjet/6xgslyZmHPG09ca7ytl1a+K3s/+rnKG2FtbWA3xEBiPTIP4IL6ShjxVCg4Ch
         uxzQ==
X-Gm-Message-State: AOAM531vc5Zins4eOYhn95ybvf3DxH6J9qlYaRHUojOwCpPPiaEy9knK
        bB5a0D4YlkT8RkJRgIQsuHg=
X-Google-Smtp-Source: ABdhPJy5q3FcsbCox7Ny7uElmyq4AThFqH2Jsl8c+ySR3rXqyN+VuY68ZkDVoU5xkBHTYst4laiVaw==
X-Received: by 2002:a05:6512:32ca:: with SMTP id f10mr4873822lfg.384.1642793806730;
        Fri, 21 Jan 2022 11:36:46 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id t12sm345280lfr.197.2022.01.21.11.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 11:36:46 -0800 (PST)
Message-ID: <8d4b0822-4e94-d124-e191-bec3effaf97c@gmail.com>
Date:   Fri, 21 Jan 2022 22:36:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in
 peak_usb_create_dev
Content-Language: en-US
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220120130605.55741-1-dzm91@hust.edu.cn>
 <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
 <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
 <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

On 1/21/22 08:58, Dongliang Mu wrote:
[...]>> BTW, as you mentioned, dev->next_siblings is used in struct
>> peak_usb_adapter::dev_free() (i.e., pcan_usb_fd_free or
>> pcan_usb_pro_free), how about the following path?
>>
>> peak_usb_probe
>> -> peak_usb_create_dev (goto adap_dev_free;)
>>    -> dev->adapter->dev_free()
>>       -> pcan_usb_fd_free or pcan_usb_pro_free (This function uses
>> next_siblings as condition elements)
>>
>> static void pcan_usb_fd_free(struct peak_usb_device *dev)
>> {
>>         /* last device: can free shared objects now */
>>         if (!dev->prev_siblings && !dev->next_siblings) {
>>                 struct pcan_usb_fd_device *pdev =
>>                         container_of(dev, struct pcan_usb_fd_device, dev);
>>
>>                 /* free commands buffer */
>>                 kfree(pdev->cmd_buffer_addr);
>>
>>                 /* free usb interface object */
>>                 kfree(pdev->usb_if);
>>         }
>> }
>>
>> If next_siblings is not NULL, will it lead to the missing free of
>> cmd_buffer_addr and usb_if?
> 
> The answer is No. Forget my silly thought.
> 

Yeah, it seems like (at least based on code), that this dangling pointer 
is not dangerous, since nothing accesses it. And next_siblings 
_guaranteed_ to be NULL, since dev->next_siblings is set NULL in 
disconnect()




With regards,
Pavel Skripkin
