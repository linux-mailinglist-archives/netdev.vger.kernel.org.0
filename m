Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ECD3609DC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhDOMyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhDOMyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:54:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9463C061574;
        Thu, 15 Apr 2021 05:54:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y2so12002072plg.5;
        Thu, 15 Apr 2021 05:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nFBhJEMWSCHQ9ckRhICUqHp2tzOkLKl41yxYxmXNW8k=;
        b=hoY2qyhaWOmcHAUhxLhqdl2UUYQFP2mZvbngLFNzsYmVwketTssI/OEzMrR5vrSYcz
         bB1MpB5zVdkmSDk927+vAXQSP+0TkGL2CkD2Iz/SuAgoYQ8jb4Jx3FeGHZm0dL/1pLUR
         IacekCQbE4Ohc/0K1F8WUD5gcpaslZovW66owGnAmKU7W13oJtUNjHOJHB3Em8jD3BAD
         E7+lJL7tX79QdZ6BdhmHx9s05DEbvXfVc8/ZCXEYV43UxyAMj6uJu7EDF1XP1ExWTc2G
         vhQ5Nl/ZMybAB50qIqEc8UzgfsZAwuUYFBxAA0SRZr1gsyX7QYfAT1dj+b000dxnu9ot
         aGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nFBhJEMWSCHQ9ckRhICUqHp2tzOkLKl41yxYxmXNW8k=;
        b=ane4kd3ClwTQ4O5T2gYDr+TKrdRxyqp4oiGdATTdpI+Yj6VpZWQbsaXojd9JYtxHxT
         2/bxW1TBbg84HWBFdnByX5pThF9wY+ZyQETfvFE1ZFehswtMZsEHlXmYSTLmJ3UABKa/
         +Jfbbmdq7satdgXBpBAS4zJ2Luv79Gnwiip5Xamvj72qWxWNmkb7i0sK8Eqq29WPgGsN
         H4+Wsj9Ekxgx/VoUE+zezPXsmwUUhhz78t4qOk8KRQxDnNXaskL+AT0GmHgRd9hM27I0
         OwlxWzI4nxf2RF9iU0R4u7b0CN5IyMA5qNWJyUzbtdWFhcCTcfI3tVDTNC/AxijbCFO0
         VekQ==
X-Gm-Message-State: AOAM530RJa96+7yDvTDmSv2OUK7sPBPFIP2ssPt5DuUySXuD0zIyitpt
        e7y24NzbrqkXXzV+vHA3RaQ=
X-Google-Smtp-Source: ABdhPJwMxGoxf76RvLc0tJT4UxlfrSX+Msz1jyTk5WaW6qqtbrg+lXaAsPVl/Z3ij+VVeCxsB22jnQ==
X-Received: by 2002:a17:90a:2c4b:: with SMTP id p11mr3951409pjm.75.1618491254408;
        Thu, 15 Apr 2021 05:54:14 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id h68sm2136897pfe.111.2021.04.15.05.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 05:54:13 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 08/12] UIO/Hyper-V: Not load UIO HV driver
 in the isolation VM.
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-9-ltykernel@gmail.com> <YHcOL+HlEoh5jPb8@kroah.com>
 <20210414091738.3df4bed5@hermes.local>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <ce231753-2946-6b07-4b52-9ca07e9120ee@gmail.com>
Date:   Thu, 15 Apr 2021 20:54:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414091738.3df4bed5@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen:
	Thanks for your review.


On 4/15/2021 12:17 AM, Stephen Hemminger wrote:
> On Wed, 14 Apr 2021 17:45:51 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> On Wed, Apr 14, 2021 at 10:49:41AM -0400, Tianyu Lan wrote:
>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> UIO HV driver should not load in the isolation VM for security reason.
>>> Return ENOTSUPP in the hv_uio_probe() in the isolation VM.
>>>
>>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> This is debatable, in isolation VM's shouldn't userspace take responsibility
> to validate host communication. If that is an issue please participate with
> the DPDK community (main user of this) to make sure netvsc userspace driver
> has the required checks.
> 

Agree. Will report back to secure team and apply request to add change 
in userspace netvsc driver. Thanks for advise.
