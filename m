Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B42F91CD
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 11:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbhAQK4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 05:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbhAQK4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 05:56:09 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EB1C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 02:55:27 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id r12so8273592ejb.9
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 02:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z8v4H9ZVRIUbMImkzSRDKKVg+9jH+t4mr+lc2FiV6Ks=;
        b=WHVFt7PwIhB+xOh8ovAxAokKnFElb5g+LOD4zqm+/SvpxsA6weCupdQ55Yna/0nXCb
         afnEMPmFjjtRIi2cKns8hlpLt7OguqAiLYrEN0DKHwGmqEZFzaJfOZk0DDm2F+fF29sK
         GtX5hK7BfsHEAMeMI3wo3mkjtEkXhYrveo/23Ntiwk3Bpu2V0bEdfR1PoUu8C9D+1ZCF
         rI5QZ1vqY96qorcs7FaIfRHDlCcY31NbkDmJyLuuufWN6OV2otqfp3e5wig9VzrU70zx
         PdZ66W0YfF8yN1DRQUZOa9TaXgH5Afdd+poKf/os0d1V011ucrgO9Iex4YjLLgdUS+eC
         84rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z8v4H9ZVRIUbMImkzSRDKKVg+9jH+t4mr+lc2FiV6Ks=;
        b=CMRc0VqMFtMNasfzBzFiJ5O1d5vmDhTMCLJMH6uOvFBTIpWP37ByVBT2SToBhH4jZc
         Dja8kvS+KdxClLFcGJCmO7k7/Zjs7kDUJmYucJcIZwQpnhkhWaQS4r3WeQrta0hnb5GS
         N8ryPLFGlNStT1ate1DrWJZb6/Cjdxvdsk59UYbNGNwgBt+mIW/p8mxMlKjvdet6+/K5
         DevEAmB1Fn3CRJ/8wgLxUEc+hHV3aR1MeT7ZyRmPCnTPb1SJf07/+UTrEm8lvTgunZAe
         t7qpOeeDTrKAz7mBfD6LkTjYEqmjsNKWGtLOWMitcEUs402j/XdXDOh9M0IPOSrJF00Y
         90Tg==
X-Gm-Message-State: AOAM531P7gmbzjevbIMPk/z9mc89tyk+3JY9ObsCE84+k+pBH/BhMshd
        JFqxk5Ok/J78Qcii3DCbIzsQSoinDIo=
X-Google-Smtp-Source: ABdhPJzolyhUMpFVpqDUN/WfHjambS6CA+LJqMDHn+9boJi5jNr5eg9eZP634mMgD6QG8YWJx/kQ4A==
X-Received: by 2002:a17:906:c295:: with SMTP id r21mr5596751ejz.235.1610880926422;
        Sun, 17 Jan 2021 02:55:26 -0800 (PST)
Received: from [192.168.0.112] ([77.126.22.168])
        by smtp.gmail.com with ESMTPSA id i22sm3019718ejx.77.2021.01.17.02.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 02:55:25 -0800 (PST)
Subject: Re: [PATCH net-next V2 1/8] net: netdevice: Add operation
 ndo_sk_get_slave
To:     Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
 <20210114180135.11556-2-tariqt@nvidia.com>
 <20210116185121.7f6c4c83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <35a09bbd-e9e6-7b56-2469-cb046b6b5fa5@gmail.com>
Date:   Sun, 17 Jan 2021 12:55:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116185121.7f6c4c83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2021 4:51 AM, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 20:01:28 +0200 Tariq Toukan wrote:
>> ndo_sk_get_slave returns the slave that corresponds to a given socket.
>> Additionally, we implement a helper netdev_sk_get_lowest_dev() to get
>> the lowest slave netdevice.
> 
> Please don't add new uses of the word "slave" outside of the bond,
> and preferably even there.
> 

I'll fix this.
