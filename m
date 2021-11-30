Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB52463256
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbhK3L3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240763AbhK3L3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638271552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nW4v0Dmvu3ppM84D0W/9hq/3S9zMfrsXcIrV1YMd8MM=;
        b=Noewhn56UFCnPRg8dbtCVxXqV6I3+wStSrsRzYYNkZrNLmaeA8LUE7RpIuYmL8rHidR6ZZ
        /nKjK7LrGE+DWoVFN/Ezf4uLhr5PWfF/9IBSxdg8UJocgro8uRC0pIhEv50A2WMen1sLYf
        ILZd6DHhZ1dVsxJhTxZmRwdTNFl751w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-C7j0gHcQP-ujpTX52FLaIw-1; Tue, 30 Nov 2021 06:25:50 -0500
X-MC-Unique: C7j0gHcQP-ujpTX52FLaIw-1
Received: by mail-ed1-f69.google.com with SMTP id n11-20020aa7c68b000000b003e7d68e9874so16656348edq.8
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 03:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=nW4v0Dmvu3ppM84D0W/9hq/3S9zMfrsXcIrV1YMd8MM=;
        b=hs9mRDVXBZ3EJxOgA7OsLsMPzz075yvZ7RliFSaZxrcrDVFq/uWEs/A6c3WVN6j0os
         SqVADcFQ6BrXz9eziBDlNNbahmPtcC0O0qDtn2CR4/tv5CGRgF+mmBJirC9Y7BuvK5s7
         kFoxkgFbKENHUXpxMvxdm56Zj5qUS90Fgqte3Yli0S509FHZeoSjlt3RknAgJlTMxr/8
         SWj2gO5WUnxVyaOcfIE4AxiSCzExex2M7ZnREELj/l/lYQCbWdnvr7lREVI5xxWRRzik
         pzJlMKyLXzUjW/CFjaFmjNnnoj9iP3Bu6KVl9FJH8riXmSphWOtoqncAl6lGCogTYu5V
         g7qg==
X-Gm-Message-State: AOAM530lTLoUbji4L7GoF7m14ODlnPX+A5Eqaa4MC9YxbhLA80AK1qmc
        RX3YiIc7tGhOtMRGxMfGyVXmS75KY5T/oRVLAy4LxfTR5dcGNOgmqOu1/OE+u8XZTTl3BugxVKB
        EK0VJ9MhVPmZhBn+r
X-Received: by 2002:a17:907:608f:: with SMTP id ht15mr31223499ejc.300.1638271549444;
        Tue, 30 Nov 2021 03:25:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbSaZ41fs8nEN31mLbWTtd1uwJu8NTP/2exa47vh3cgbBRaxniN1rAzmjNptegFE9pWOwHVQ==
X-Received: by 2002:a17:907:608f:: with SMTP id ht15mr31223478ejc.300.1638271549268;
        Tue, 30 Nov 2021 03:25:49 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id mp9sm9230930ejc.106.2021.11.30.03.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:25:48 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e462ac19-0598-5b68-eab9-93358b7e7a57@redhat.com>
Date:   Tue, 30 Nov 2021 12:25:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Content-Language: en-US
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700859087.565980.3578855072170209153.stgit@firesoul>
 <20211126161649.151100-1-alexandr.lobakin@intel.com>
 <6de05aea-9cf4-c938-eff2-9e3b138512a4@redhat.com>
 <20211129145303.10507-1-alexandr.lobakin@intel.com>
 <20211129181320.579477-1-alexandr.lobakin@intel.com>
 <9948428f33d013105108872d51f7e6ebec21203c.camel@intel.com>
In-Reply-To: <9948428f33d013105108872d51f7e6ebec21203c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/11/2021 20.03, Nguyen, Anthony L wrote:
> On Mon, 2021-11-29 at 19:13 +0100, Alexander Lobakin wrote:
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Date: Mon, 29 Nov 2021 15:53:03 +0100
>>
>>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>>> Date: Mon, 29 Nov 2021 15:39:04 +0100
>>>
>>>> On 26/11/2021 17.16, Alexander Lobakin wrote:
>>>>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>> Date: Mon, 15 Nov 2021 21:36:30 +0100
>>>>>
>>>>>> Enabling the XDP bpf_prog access to data_meta area is a very
>>>>>> small
>>>>>> change. Hint passing 'true' to xdp_prepare_buff().
>>
>> [ snip ]
[ snip ]
>>
>>>
>>>> Tony is it worth resending a V2 of this patch?
>>>
>>> Tony, you can take it as it is if you want, I'll correct it later
>>> in
>>> mine. Up to you.
>>
>> My "fixup" looks like (in case of v2 needed or so):
> 
> Thanks Al. If Jesper is ok with this, I'll incorporate it in before
> sending the pull request to netdev. Otherwise, you can do it as follow
> on in the other series you previously referenced.

I'm fine with you incorporating this change. Thanks! :-)
--Jesper

