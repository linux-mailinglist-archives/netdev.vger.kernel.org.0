Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5A2DA662
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLOCpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgLOCpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 21:45:18 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC73C061793;
        Mon, 14 Dec 2020 18:44:37 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id j20so13482338otq.5;
        Mon, 14 Dec 2020 18:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x72vug8cN99PaOJ8x7vMuDWxLkm4VsBuMNR8n9DiKS4=;
        b=Yb5rLt5rgh4o9RMWpdRF/Zup/mpecAr8rtLHcQI22UMrJnizmrU5wfwbbkxC/kNeTm
         hW15p5wcJDakSjXx+vWBMSHjdgKzBmu7vMRFnevbiu8V0fAN7MOJkjVorwAAYWKp3WKk
         bQfI8LOkmEM2q2dxdS7f2GzQWukHkrhTL3WdHG1xlE8Dd0LemcN/lQh82C3MAGev5Ngy
         +m6LJYU6Wltd6s/oWw5shiOv5FfC6jiaJGoEb+LA5LsG0w5OwC0PwPlT2zubAxg8QNDB
         bZuEoscn06v4l6q0AvoxdST+f54SA/YS+Yxol2fPYIu7C2OveNZ5LXEw7Ucnnh7uhbXJ
         yhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x72vug8cN99PaOJ8x7vMuDWxLkm4VsBuMNR8n9DiKS4=;
        b=AZyKVTFAxvWW/GwdN0isRcrzPp/tuUdQhjxNAVoWxhVQU4VLRLfRARq1+U81VPa5A2
         bxzhypfyfQlhhFOmjnQn+CTgmJRWRZqSN/NLHXXpYw+tLudEEmDDVsbaptrBbIZ1IS1G
         rQ1nlCOZ3CXjAnJhctiApn5VR6Dw3l3Ep8M+Wc1oiTx+qKeG9ubqkYltB53xcxM3fe6s
         7cX1cY9Fj39PZolZ4qEDcuYFsPyRt2PvoCEQk6xS0u+E6kL7WRf698xCB3F2Vmsv1lCw
         2UnchzPkaOvWPS2S4M+AGu6ouH92x+04Sv0LKRW0P52a1e/6JEjufa4VA5KpacCSyUIL
         gGxg==
X-Gm-Message-State: AOAM532FbIToZZQaGCvikF5so9+2+C6dTM0naTRGhMkJNt824Nijht83
        Sde0JBff1hdlB/t8xAAHapkP6DUFwJ0=
X-Google-Smtp-Source: ABdhPJy47kkIs/k+sZGmUNcCZSAXYal0PodIX/cfQQf1sUSINN4qqSdvbIWoeQte/9gVaNvF9ctkow==
X-Received: by 2002:a9d:d52:: with SMTP id 76mr13048273oti.67.1608000277341;
        Mon, 14 Dec 2020 18:44:37 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id t203sm4795225oib.34.2020.12.14.18.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 18:44:36 -0800 (PST)
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0af4731d-0ccb-d986-d1f7-64e269c4d3ec@gmail.com>
Date:   Mon, 14 Dec 2020 19:44:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/20 6:53 PM, Alexander Duyck wrote:
>> example subfunction usage sequence:
>> -----------------------------------
>> Change device to switchdev mode:
>> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
>>
>> Add a devlink port of subfunction flaovur:
>> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> 
> Typo in your description. Also I don't know if you want to stick with
> "flavour" or just shorten it to the U.S. spelling which is "flavor".

The term exists in devlink today (since 2018). When support was added to
iproute2 I decided there was no reason to require the US spelling over
the British spelling, so I accepted the patch.
