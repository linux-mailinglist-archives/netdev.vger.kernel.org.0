Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C2B3E9CDC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 05:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhHLDXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 23:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233506AbhHLDXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 23:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628738596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2m2roWrvbYZeRqtABbQ37PaOQOhXAkNprJbXopZhFmQ=;
        b=I1YRj/qgLA33z+HD0LRttf6Ln1A82T0C4frepbqrCbHrZAOP2XEQ/0Wt2y8wfnqFQmZ2fj
        6kGtNSIOTDB+Mme377ZWNtvTWbyLCpybyqAzY+nqipIKWnlBRlr44i/q15vIlHI4PDksIA
        HmwfKXhqbp9gwRaj+VmbjZdd1/giOzM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-d6_8b5HvP_qaFlTapBdQKA-1; Wed, 11 Aug 2021 23:23:14 -0400
X-MC-Unique: d6_8b5HvP_qaFlTapBdQKA-1
Received: by mail-pl1-f198.google.com with SMTP id s3-20020a1709029883b029012b41197000so2775937plp.16
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 20:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2m2roWrvbYZeRqtABbQ37PaOQOhXAkNprJbXopZhFmQ=;
        b=UgIBrCw59VOd6WpW2qHat6AZjXxaO93xvyoy8pt3J5lwLUm9UR9y1yc7ttpWBqvtgj
         cX/1+dQWHUUGWHdFr1zJIL81OA+cwsgzjaFBUisA+Fuaanx4CNPkhNhoQ6gPjOuFve7v
         HJ4hrKIQxW3MHIADQ4/ws+eWb63uHlgdkV4iN+42uykx7OEE9AmzOftRS4amHzkDqiKt
         L8JJwxLqgprC8XFg756INqXyvNPJma5SROhyBVjwlptbAIxmfEia3Zd8TBgCWD5aBBtS
         ofas/O661TgEd1oljeBrRmTWuiHmg36kNAOmt0jKQtF6xpv+avjTfzG4y4Ru+0UhxS+/
         ReSQ==
X-Gm-Message-State: AOAM531aAax45FmVkyViycm1x4m9TqB24LFaTAtAfZxbnihJfUdthKhR
        A8oyjcn4/tq7QlESAJsZYSKLL2sxx3hWiTwwXAfAvPCDSQ46mVEay2BhSSaFfwSDFu9QFmJSQf5
        kCIX2Gi57n7zncTLh
X-Received: by 2002:a63:4b20:: with SMTP id y32mr1859076pga.382.1628738593898;
        Wed, 11 Aug 2021 20:23:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxri0vz1C8dFRUmJIUTNidwykg+eDk8Nwx4EwLANMh4kFarSI6fxHbBC1+cB14MM5x9vm7Uww==
X-Received: by 2002:a63:4b20:: with SMTP id y32mr1859066pga.382.1628738593676;
        Wed, 11 Aug 2021 20:23:13 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m16sm8395422pjz.30.2021.08.11.20.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 20:23:13 -0700 (PDT)
Subject: Re: [RFC PATCH] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivan@prestigetransportation.com,
        xiangxia.m.yue@gmail.com, willemb@google.com, edumazet@google.com
References: <20210811081623.9832-1-jasowang@redhat.com>
 <20210811151754.030a22a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aa3e2aca-05a9-aed7-59ec-eb4bd32d8f76@redhat.com>
Date:   Thu, 12 Aug 2021 11:23:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811151754.030a22a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/8/12 ÉÏÎç6:17, Jakub Kicinski Ð´µÀ:
> On Wed, 11 Aug 2021 16:16:23 +0800 Jason Wang wrote:
>> Try to fix this by using NETIF_F_GRO_HW instead so we're not
>> guaranteed to be re-segmented as original.
> This sentence may need rephrasing.


Right, actually, I meant:


Try to fix this by using NETIF_F_GRO_HW instead. But we're not sure the 
packet could be re-segmented to the exact original packet stream. Since 
it's really depends on the bakcend implementation.


>
>> Or we may want a new netdev
>> feature like RX_GSO since the guest offloads for virtio-net is
>> actually to receive GSO packet.
>>
>> Or we can try not advertise LRO is control guest offloads is not
>> enabled. This solves the warning but will still slow down the traffic.
> IMO gro-hw fits pretty well, patch looks good.


If the re-segmentation is not a issue. I will post a formal patch.

Thanks


>

