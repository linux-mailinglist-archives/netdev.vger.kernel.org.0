Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23DA4741F6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhLNMDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhLNMDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:03:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A8BC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:03:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r7-20020a17090a560700b001b0e876e140so1106742pjf.5
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vNqe1efUBK48EgDxsn+Eoqxs516g1+G3RrbJ4QjvhwQ=;
        b=GLHrDLPjntGBwZwIx/Kw+i2HjKqV/MtEXVFaBJf2n693rzhaW2k9xvBlc6pxA/Dluz
         m5wnnogXXNe2m/PVuarB++Bvx611ITld6Tko1e9H04Rsya4wjhkoyw1RCVZWz2eqxQPD
         d7zzRsC2xnnWJeIToNROZWGettDrBQ4SjgZ/vGXinBKQoodrcSQj6qtHgsmHnManzE6t
         LkpQNi9BqOJxDW3so6GoA/Q/psdPPAUBKF24Gd61vlWJfQGq/o0FPMX1Vs9nyztiYGrh
         AqaDYmnaG8ey2dG/Wg8L3DUQ2mUohjLERO0EZedf6gGMwLQHO+Mt81cYLJUs+H64KzwU
         lnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vNqe1efUBK48EgDxsn+Eoqxs516g1+G3RrbJ4QjvhwQ=;
        b=tE/U4lNorqVttRyfM227QLdzPACjzOSwgr9tZ+Qxu2c+QwUvGPhCuULx+AHibaqJF1
         szV1Q9cMSssqzgtTLclRNtCr/gR4kjl3057XujiuelUU+whwCaK69px50iadF+K7Z9FS
         6qlkSKa/DbgtY5r8BhOGlPbCuZBZYbh3bfUlHboPDQWSjBLinnSn/NbRTEtEztjSXF38
         x/Ov2Jt+0FI1ZFTM63fAyDvRc9UOsH8Vz9t3nxdMakfIz3bmdTwPm+mD8WSo0nZi2hWU
         VU0VT6oipWseXQ7bViaHKSlI+KqKVuPXuR5YoJbGFMrlwj2ZUxiREJ+psqSDyIAbaFuJ
         9dlQ==
X-Gm-Message-State: AOAM531apyVh5j8hiritx8ONZ3WdOkEERx7VgZxc+BKqG0nSNMtpTUTQ
        pUTmnZ7RNHdWr+dtyZaDzPkr2v1DUCWg2GWY
X-Google-Smtp-Source: ABdhPJzalRgASKsMZRSwI09IonU5uDwWaarrP6W8aVW9rawoRpFu5iIy4i5FV2W6iWkWOK2ZNtG7lA==
X-Received: by 2002:a17:90b:190f:: with SMTP id mp15mr5134805pjb.210.1639483421563;
        Tue, 14 Dec 2021 04:03:41 -0800 (PST)
Received: from [192.168.10.3] ([59.97.117.114])
        by smtp.gmail.com with ESMTPSA id t38sm16409377pfg.218.2021.12.14.04.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:03:41 -0800 (PST)
Message-ID: <797d729c-093c-4317-c371-5f64c8a3a2f3@gmail.com>
Date:   Tue, 14 Dec 2021 17:33:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: Fragment large datagrams even when IP_HDRINCL is
 set.
Content-Language: en-US
To:     David Miller <davem@davemloft.net>, Alan.Davey@metaswitch.com
Cc:     paul@jakma.org, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
References: <alpine.LFD.2.20.1607081340430.26593@stoner.jakma.org>
 <20160708.184129.1545084362199727100.davem@davemloft.net>
 <SN1PR0201MB1807CF3E6A28E344EE2E41F0F9300@SN1PR0201MB1807.namprd02.prod.outlook.com>
 <20160712.111116.1765805486132601360.davem@davemloft.net>
From:   Senthil Kumar Nagappan <nagappanksenthil@gmail.com>
In-Reply-To: <20160712.111116.1765805486132601360.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/12/2016 11:41 PM, David Miller wrote:
> From: Alan Davey <Alan.Davey@metaswitch.com>
> Date: Tue, 12 Jul 2016 12:34:07 +0000
>
>> -  all future applications have to continue to implement their own fragmentation code, duplicating that which already exists in the kernel
> They have to do this anyways, don't you see this?
>
> Otherwise they don't support %99 of the kernels out there.
>
> Even if I put this change in now, it would take years for it to
> propagate to even a moderate percentage of Linux machines out there.
>
> And applications doing a "we only support kernels > version x.y.z" is
> a situation I don't want to promote if you think that's a reasonable
> way to handle this.
>
> Dave patch functionality is good to have in the kernel.
> The reason David says it not convincing,  since its there for decades and "we only support kernels > version x.y.z", As Paul suggested we could have a socket option to avoid compatibility issues.
>
> Dave patch has minimal changes, but i see some downsides to it and suggestion to do this differently.
> 1. We will not be able to support MSG_MORE if we take this path.
> 2. we will try to allocate one big skb based on the user data size and kmalloc might fail to allocate a big contiguous buffer, which is not better as compared to the path taken using ip_append_data where we will take care allocating skb's based on the mtu.
> 3. other suggestion is, may be we can take the ip_append_data path, some were down the line we can use the user provided header.
