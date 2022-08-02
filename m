Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4D5878A2
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 10:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiHBIEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 04:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiHBIEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 04:04:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C8DF237D5
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 01:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659427470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PnAgHb+qwkYr0eoeRI+miU3649J+IzbjO84fBGvUAWw=;
        b=ep/F+MZJgno/g4KEO/PavR5Zz8NweHNiutfkARlrXbMorBdcM3f+Coq3MPazmXeRb70fD6
        2CeqrtNeEfHJlPtWAGQe5cPAEc5PYED7hKyOVTgec39YGbLU3vxDAZYy15AEZtWbFwB/F6
        JeoCtUKLSkA7szepzyTe7lEl1MQEdTw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-cN5omHYIOWq86cDkfu4wOw-1; Tue, 02 Aug 2022 04:04:29 -0400
X-MC-Unique: cN5omHYIOWq86cDkfu4wOw-1
Received: by mail-qv1-f69.google.com with SMTP id l16-20020ad44250000000b0047676a29dd9so2988006qvq.1
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 01:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=PnAgHb+qwkYr0eoeRI+miU3649J+IzbjO84fBGvUAWw=;
        b=NCqjwHT+5X1iyIKz2z4k90KXDltcz0WNCwKihFzE3GAk5T9GoV+A1zJQLyUy5e7Mip
         lY4+HvoScE7PiWlR0LxA4+RYRXvHN8cNO7kSquzOtvw5N/86K9Sctl/b0Y7P9hdtZSkd
         7bVimkdGuRhPC4bRvd9se3RvHD+hpJ5OoO3Kf8ZLDg/5wWCJIgJYp1V0kBFTIO5A9Q0W
         TFv7UDoPmSWFFDUZyz6OD8Yi/xM4pk6uxB8dm1KgJ08LUAMeFaasSb6s3uNLrSOhW6pQ
         UpxiR3iRVz96Z5fORqmEzPDdsxCVKv0nYCOk7ypCkrkkFWsKIFJNr7juBH31M5fNb6Si
         a4tQ==
X-Gm-Message-State: AJIora9q4uowHppSRzBxelQiP+TuoNh9//kb1Aqi/+0vLL4Vnk+2zqwC
        d0BQ0HQaJ9bgJORTCdSwK6oLW/S8NuUtxvAvkMszMAmlpcJIFWrLEcFuj3U7zLo4rd19aHMFXvZ
        YeSTl26fsooO0sm/J
X-Received: by 2002:ac8:5b96:0:b0:31f:1931:b2b1 with SMTP id a22-20020ac85b96000000b0031f1931b2b1mr17183313qta.17.1659427468871;
        Tue, 02 Aug 2022 01:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t8d3getE7v6ehQxa40+uRjwcWSGfnrWrzaZU1/gX3jMXiALvanlrDyYV5QWSN3xAJSiT9vUw==
X-Received: by 2002:ac8:5b96:0:b0:31f:1931:b2b1 with SMTP id a22-20020ac85b96000000b0031f1931b2b1mr17183303qta.17.1659427468660;
        Tue, 02 Aug 2022 01:04:28 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id g18-20020a05620a40d200b006b8d1914504sm636431qko.22.2022.08.02.01.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 01:04:28 -0700 (PDT)
Date:   Tue, 2 Aug 2022 10:04:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Vishnu Dasa <vdasa@vmware.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220802080417.xyfwdidlirklr4oj@sgarzare-redhat>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
 <D7315A7C-D288-4BDC-A8BF-B8631D8664BA@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <D7315A7C-D288-4BDC-A8BF-B8631D8664BA@vmware.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vishnu,

On Tue, Aug 02, 2022 at 05:35:22AM +0000, Vishnu Dasa wrote:
>> On Jul 27, 2022, at 5:37 AM, Stefano Garzarella <sgarzare@redhat.com> 
>> wrote:
>> Hi Arseniy,
>>
>> On Mon, Jul 25, 2022 at 07:54:05AM +0000, Arseniy Krasnov wrote:

[...]

>>>
>>> 3) vmci/vsock:
>>>  Same as 2), but i'm not sure about this changes. Will be very good,
>>>  to get comments from someone who knows this code.
>>
>> I CCed VMCI maintainers to the patch and also to this cover, maybe
>> better to keep them in the loop for next versions.
>>
>> (Jorgen's and Rajesh's emails bounced back, so I'm CCing here only
>> Bryan, Vishnu, and pv-drivers@vmware.com)
>
>Hi Stefano,
>Jorgen and Rajesh are no longer with VMware.  There's a patch in
>flight to remove Rajesh from the MAINTAINERS file (Jorgen is already
>removed).

Thanks for the update! I will contact you and Bryan for any questions 
with VMCI in the future :-)

Stefano

