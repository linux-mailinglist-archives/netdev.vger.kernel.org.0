Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1550E253FF6
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgH0H6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgH0H6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:58:09 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8E5C061264;
        Thu, 27 Aug 2020 00:58:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f26so5340447ljc.8;
        Thu, 27 Aug 2020 00:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lEBPqYLj1Sfpoe7PvHoeVpAVjO6ud5dnyjMuhp7FHVU=;
        b=UdpN9e9+xHs/VTWHW2V0XUZN9Egd4mwnCmlizNY/AIPcvPFUdBqRvFNQU8vo2kolFY
         7y2T/O/r2Ov/tzGqMTcdLnb7fmAI3MyewZNKhgF/msyQT7ep+SBJ9MJYrVL3ZFSf8/lg
         fgpStsnUu58uIXrIb6sZBB73as3h9JlklSIHZwdaI5fVlpeBSVoP3GSxdwAKRIuGJ0G3
         uheR2DVPPCDmJOgNe4rZtOHN3FRLjX6JrxavbkinDgK7QGTDkzOPEKPBJSpozg1JeTNn
         SVy2dKblpo1tKuycek1vObQRq14/QN8FwJFtMEbbj5T1J/lC/ZObD/EoVv5j9sc/krMV
         mzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lEBPqYLj1Sfpoe7PvHoeVpAVjO6ud5dnyjMuhp7FHVU=;
        b=GFSiPWO5CJh5RhvONpAtEqiyWLJ+ZAdW+3V27joBwBS4hlS8OesAcbieWJYG0PPviX
         yq236/4jg/kQrdyVwhb6H1ldAnKH2xTB9p/hOfiyxU2HkUKe0tU4rKCtjV8CJBeQSEZA
         W1IsAPkCTYzH8UhmrCVDq0rAfFSJKkwNHVCUzukIRoepVrVOjvqJhZ5C0Znt06gR0YN/
         SerhNeqvgoadgNXAlyt/3nGzNwmChLNSlnK/dun6Lb2ZSukQuxoPq5nIa/VRhPywjRtg
         CrFtIfV6eD9g1ncoCiubdqcPulW7+UJa7AEfNsenopA5leBr6in+EdVQwSJ/tOodA0fJ
         pZ1Q==
X-Gm-Message-State: AOAM5331J1dGNIESZwf11TK4h/Aph3zdKQ00E574etiUDcNlQ9nHuw7R
        ssUId5J19zwHX/P5RsB0qCA=
X-Google-Smtp-Source: ABdhPJwUG34ZG5RWvvEl84Os0y3M8D8sLpjg17s0tEPZza0pvwK+RE1G6cGDx9RKlYZrA7Z7NkQMOQ==
X-Received: by 2002:a2e:a370:: with SMTP id i16mr9544469ljn.22.1598515087168;
        Thu, 27 Aug 2020 00:58:07 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4853:a15:71d2:9e85:be1:5e21? ([2a00:1fa0:4853:a15:71d2:9e85:be1:5e21])
        by smtp.gmail.com with ESMTPSA id j6sm297282lja.23.2020.08.27.00.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 00:58:06 -0700 (PDT)
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in
 asix_read_phy_addr()
To:     Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
References: <20200827065355.15177-1-himadrispandya@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <5dd266df-33cf-f351-7253-33a7f589cd56@gmail.com>
Date:   Thu, 27 Aug 2020 10:57:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827065355.15177-1-himadrispandya@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 27.08.2020 9:53, Himadri Pandya wrote:

> The buffer size is 2 Bytes and we expect to receive the same amount of
> data. But sometimes we receive less data and run into uninit-was-stored
> issue upon read. Hence modify the error check on the return value to match
> with the buffer size as a prevention.
> 
> Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> ---
>   drivers/net/usb/asix_common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index e39f41efda3e..7bc6e8f856fe 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -296,7 +296,7 @@ int asix_read_phy_addr(struct usbnet *dev, int internal)
>   
>   	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
>   
> -	if (ret < 0) {
> +	if (ret < 2) {
>   		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);

    Hm... printing possibly negative values as hex?

[...]

MBR, Sergei
