Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688DF3A9B15
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhFPMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232870AbhFPMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623847915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RFxE6z1dzCcFZAdTltB4JFa0p4EHIH2iYLpgasa9Ms=;
        b=UXB+XGEblsBxQAE7v893bAKnD9pDT9EATswjxV8Eenie6hFdaayPeFa0bteOtjwzuQVCSB
        0kViPpHb0ygaGkG/I4Ezzhwoe9p52gecnqlWBS1Y43Ka3FUfK13ZS+Zzzki22gJCvg4YDh
        ju9Ho2XhmhUwotgdlLJz7aQwi+7bTTU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-ogC4RsW7Phyu0N8hNseW9A-1; Wed, 16 Jun 2021 08:51:54 -0400
X-MC-Unique: ogC4RsW7Phyu0N8hNseW9A-1
Received: by mail-pl1-f199.google.com with SMTP id x15-20020a170902e04fb02900f5295925dbso503071plx.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 05:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/RFxE6z1dzCcFZAdTltB4JFa0p4EHIH2iYLpgasa9Ms=;
        b=PeXw0qPUgr1ggVgeyBXz4d/ru5OgmSd947MbsdQa2Elz1ER7ihMAoGsrNygHxG/qSs
         UwKjQEjYPVrLSj94eVaHtU/NOKBs7PhlLf+PpUxCbK2kctV3uAb820Aq0FneptVEHpbF
         Z3wm2/WnedmWPTk5V8a/IbwKmwLDYmbhyeGLW4+gk4DGAUCudiF7mxPI7V7/8VuZQljB
         Juiy59eq0A4KbpEpJ6GL21TNuzn9OHN4AY5qUXAWoumPa9eK9xAxctb77wzQfKujO0hA
         eUBqPUPdZvOsphjK8HX2RIO4TsCP/VkRlrdwLnHbrb2tOtFCtL7dFPHoqE9LAqyQ4W76
         bOKw==
X-Gm-Message-State: AOAM532ebkIsgbznn+pax8Mz+maD4v/DGrJsANrfdt3gladCWHi4NCYO
        19xcVrIacjqrarOESySUcMtsdTdvH+9DM5Ylutwnv1A4Ibf0z/ssxlRyuxpiaoEVJxtCj0jpW+7
        JnX6t7zv+7GfReTCbrValiXVXX/hCHV6hUPa6SpaBBKtMdmZBh6sQ28r2u0/0K+h6pGEI
X-Received: by 2002:a17:90a:a43:: with SMTP id o61mr4841194pjo.233.1623847913152;
        Wed, 16 Jun 2021 05:51:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEtQw3VHh/1raIr4efqQ1l6TQ6mc8FlgoD9W6nl440ZvzySLwZ0gwqXUUn2hGSN0wmzQnz5Q==
X-Received: by 2002:a17:90a:a43:: with SMTP id o61mr4841149pjo.233.1623847912829;
        Wed, 16 Jun 2021 05:51:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ca6sm2345017pjb.21.2021.06.16.05.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 05:51:52 -0700 (PDT)
Subject: Re: [PATCH net-next v5 12/15] virtio-net: support AF_XDP zc tx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust.li" <dust.li@linux.alibaba.com>, netdev@vger.kernel.org
References: <1623838784.446967-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f81775f8-7df9-5ca0-0bd2-99c86786fe78@redhat.com>
Date:   Wed, 16 Jun 2021 20:51:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623838784.446967-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/16 下午6:19, Xuan Zhuo 写道:
>>> + * In this way, even if xsk has been unbundled with rq/sq, or a new xsk and
>>> + * rq/sq  are bound, and a new virtnet_xsk_ctx_head is created. It will not
>>> + * affect the old virtnet_xsk_ctx to be recycled. And free all head and ctx when
>>> + * ref is 0.
>> This looks complicated and it will increase the footprint. Consider the
>> performance penalty and the complexity, I would suggest to use reset
>> instead.
>>
>> Then we don't need to introduce such context.
> I don't like this either. It is best if we can reset the queue, but then,
> according to my understanding, the backend should also be supported
> synchronously, so if you don't update the backend synchronously, you can't use
> xsk.


Yes, actually, vhost-net support per vq suspending. The problem is that 
we're lacking a proper API at virtio level.

Virtio-pci has queue_enable but it forbids writing zero to that.


>
> I don’t think resetting the entire dev is a good solution. If you want to bind
> xsk to 10 queues, you may have to reset the entire device 10 times. I don’t
> think this is a good way. But the current spec does not support reset single
> queue, so I chose the current solution.
>
> Jason, what do you think we are going to do? Realize the reset function of a
> single queue?


Yes, it's the best way. Do you want to work on that?

We can start from the spec patch, and introduce it as basic facility and 
implement it in the PCI transport first.

Thanks


>
> Looking forward to your reply!!!
>
> Thanks
>

