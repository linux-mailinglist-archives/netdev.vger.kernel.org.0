Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83D92B1032
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgKLVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgKLVY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:24:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD114C0613D4;
        Thu, 12 Nov 2020 13:24:58 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id u12so305326wrt.0;
        Thu, 12 Nov 2020 13:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=1CWwujJZqqh6YW5x9VQu7ZRZ6d85e5wQCIk4LQH6i+g=;
        b=W0Cn6k01a9a9Hao/j+ziEji3UyE6nUwBZ3VlT+t9S0joadopbkcBviVlrQOkwrrQl6
         OahlhujILhqVyXSopLhnlKJ09YI75MGINXPTjJQjJd9GpavqkHDMNmxxm+v84cwpjtzZ
         LWECvF+BeDADT+cMqmPsAZJYJ0ZYCxTc7o/aNFzPXZ9fgt2j1rQgIAQ3/HgszVn9cYb1
         nNN4rborV/zxNWMYtFBYyCkMQiSApcvAoS0n0boAbqEK9EGOAItefOcS877xbIhpw9kr
         BVdK++EIeDxUqYecwPDiazshVwuuj5Bsx5IeyCmjqxCocCGbTFeHbllBf4NR2SACKPCK
         X5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=1CWwujJZqqh6YW5x9VQu7ZRZ6d85e5wQCIk4LQH6i+g=;
        b=qQiGAAvBZPe63sVa6N1S1KbscD34uLuvEC+HnYrBruiVUa5xtOBT9Fx2OraZdf9YOo
         Y9prSrjjwqWnb8EFALQAz/enebrc1kxX+gMS9sl1/WM2ewcfRfICVy6gVYxPk+K2oHrd
         A5R+lVeUa7uCjU8kFBNWrK02pxjo7e9XfWhCPpHTjB00yAla3/4w7d1JRXDUWD2M2Iag
         Ef/pjA5VBphIX94QcPS1nCbdOteNeRszbUohIxcYLlcbHWWZ/jfP0FIE4wjNmr06LmL2
         6FfpG5wSBOYI9QnGruCTP5A64F0Vt3YZv5PRIpGUxO1CH6L3GcrwgyxhVmuxB36I1FLx
         rNpQ==
X-Gm-Message-State: AOAM531cS3dfYaJJ/UleOJqfRQNBuHJNDFnluaj38tMsSn1sX9oB7gbq
        kbLQe7LskwGqprCGbLSS9EJZE7c/i+0K6g==
X-Google-Smtp-Source: ABdhPJxTzeCysFV4b5OFRgA5s7WW3xnpjCBDWXwCoDVEQQLlTuLcvXlRY6iHWlTOqOTDZp5j712PhQ==
X-Received: by 2002:a5d:5689:: with SMTP id f9mr1644996wrv.181.1605216297369;
        Thu, 12 Nov 2020 13:24:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:c66:2555:ef54:fee? (p200300ea8f2328000c662555ef540fee.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c66:2555:ef54:fee])
        by smtp.googlemail.com with ESMTPSA id c6sm8903530wrh.74.2020.11.12.13.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 13:24:56 -0800 (PST)
Subject: Re: [PATCH net-next 1/5] IB/hfi1: switch to core handling of rx/tx
 byte/packet counters
To:     Jason Gunthorpe <jgg@ziepe.ca>, Jakub Kicinski <kuba@kernel.org>
Cc:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
 <5093239e-2d3b-a716-3039-790abdb7a5ba@gmail.com>
 <20201111090355.63fe3898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201112134952.GS244516@ziepe.ca>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <826436c4-056e-2c7b-bf69-e22cad68fc53@gmail.com>
Date:   Thu, 12 Nov 2020 22:24:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112134952.GS244516@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12.11.2020 um 14:49 schrieb Jason Gunthorpe:
> On Wed, Nov 11, 2020 at 09:03:55AM -0800, Jakub Kicinski wrote:
>> On Tue, 10 Nov 2020 20:47:34 +0100 Heiner Kallweit wrote:
>>> Use netdev->tstats instead of a member of hfi1_ipoib_dev_priv for storing
>>> a pointer to the per-cpu counters. This allows us to use core
>>> functionality for statistics handling.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>
>> RDMA folks, ack for merging via net-next?
> 
> Yes OK
> 
> Ack-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
> 
Thanks. It just should have been Acked-by, patchwork doesn't understand Ack-by.
