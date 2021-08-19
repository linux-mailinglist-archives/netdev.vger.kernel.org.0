Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8BC3F123B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 06:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhHSELx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 00:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhHSELw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 00:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629346277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VBYriaxQXLlAIO2jBLfdlJqsXE4thEUkTkWuNBb3xSE=;
        b=NSL0AM6FQGjjzKycsdRyVzBEizk/PXOVwzv9wBu6nggNcF/UWT5jGrPyfN5ZilYYNWlw+g
        Osy3nn7Zg92ujgOOxroB0uGgm9PCSqdBLmlVvpcIaZLRE6TKh23S8xFPr0XzipBU+Es1CO
        i0FiIWOE4we/mhTUPUvQqZaW3WBZHIE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-YfBJpFzFOFyAKbVTXRdZRA-1; Thu, 19 Aug 2021 00:11:14 -0400
X-MC-Unique: YfBJpFzFOFyAKbVTXRdZRA-1
Received: by mail-pl1-f197.google.com with SMTP id p7-20020a170902b087b029012c2879a885so1142524plr.6
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 21:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VBYriaxQXLlAIO2jBLfdlJqsXE4thEUkTkWuNBb3xSE=;
        b=gUC0Obf7FK6MWLH2u4dgsCEvZBQGNrLB2miF9UqTd0VGCzgie21UWDA+Wr3AGSj2u/
         +wOGOWhL8ln76rwa4hI7l7B4IDRySZAnbBlaVHt8bXBFMLuBfaBSf4ujOO6LCyN8q2og
         Q/XRVH06pgQbecrEpGQxfQ9klkozx9gix+/8YrugeLuEkuWJDpztTlPwB5A9qn+0VV2U
         HHAwKAa4Ok9aTIBLjiw02ePRg6xifNKvJQemLw2SKwvMo95jU54TZbgQP3lsfJTLCANI
         67o3JXtkJxPkCPomMOxL7kBEfHtiZm5xG4E9BmrPXJlveqzzKSk9i3+TPlZFTSXFnCVB
         KQ/g==
X-Gm-Message-State: AOAM533gpUGCTQZcElzjKrZyMC/zMAA+BfLfp30l3uAXpS0fIvEBkxaj
        dPL1YpDBNBRebT4iZnsWD3jVwfwQ48ln3XUF61d4NmOEwID13HxZ2Hd6IzAMTf6keKFMedbuBXu
        HESuaP3h6NLtLa4UH
X-Received: by 2002:a05:6a00:1ace:b0:3e2:2a73:e0a4 with SMTP id f14-20020a056a001ace00b003e22a73e0a4mr12939446pfv.73.1629346273951;
        Wed, 18 Aug 2021 21:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLQPUem25xDlLQ3uF4CA7Dea+zPxgfi0RExMgvKM2TveGCChyP8g6txlY/nWsye2RZ0v3/9w==
X-Received: by 2002:a05:6a00:1ace:b0:3e2:2a73:e0a4 with SMTP id f14-20020a056a001ace00b003e22a73e0a4mr12939432pfv.73.1629346273757;
        Wed, 18 Aug 2021 21:11:13 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nv11sm6500567pjb.48.2021.08.18.21.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 21:11:13 -0700 (PDT)
Subject: Re: [PATCH 0/2] vDPA/ifcvf: enable multiqueue and control vq
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e3ec8ed7-84ac-73cc-0b74-4de1bb6c0030@redhat.com>
Date:   Thu, 19 Aug 2021 12:11:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818095714.3220-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç5:57, Zhu Lingshan Ð´µÀ:
> This series enables multi-queue and control vq features
> for ifcvf.
>
> These patches are based on my previous vDPA/ifcvf management link
> implementation series:
> https://lore.kernel.org/kvm/20210812032454.24486-2-lingshan.zhu@intel.com/T/
>
> Thanks!
>
> Zhu Lingshan (2):
>    vDPA/ifcvf: detect and use the onboard number of queues directly
>    vDPA/ifcvf: enable multiqueue and control vq
>
>   drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 19 ++++---------------
>   drivers/vdpa/ifcvf/ifcvf_main.c | 32 +++++++++++++++-----------------
>   3 files changed, 24 insertions(+), 35 deletions(-)
>

Patch looks good.

I wonder the compatibility. E.g does it work on the qemu master without 
cvq support? (mq=off or not specified)

Thanks

