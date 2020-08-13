Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A32243993
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHMMEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:04:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726542AbgHML4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 07:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597319770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EZlOhHYV75r7YTUyN5H+sCzjVVAp8wKOhPwk4M3cflE=;
        b=ZXCH/R3Ni1eLV7dh7vzaWHGjOMKRNhwACQOoiCd+i4FjZMhLKHszWpT8E7sFKDVPYEsv8C
        7lUYNG4QKGJEMw+l7tvXQjKg+8/uPz14dolDTHVM4GZGsp8oLzhibKnc6qcxqLWV1xQvyM
        zGbaLkQ9WbbMgyxovQLlZ563/Fj9GCU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-8zstYj_hPYK_-u6PggjzWQ-1; Thu, 13 Aug 2020 07:48:01 -0400
X-MC-Unique: 8zstYj_hPYK_-u6PggjzWQ-1
Received: by mail-wr1-f71.google.com with SMTP id r14so1997937wrq.3
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 04:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZlOhHYV75r7YTUyN5H+sCzjVVAp8wKOhPwk4M3cflE=;
        b=cyT9pppIapIQdmENJxMBpwuerxiIGh/q/emHWsBbn8bY7jpS6nVa5mLvSQMVo8tmVM
         UekYrhke4i1x08pdcyWx3PnIWvWC07/Reb+OpMKMmeOdAKUTz9ZHG9FKVE4Ljppk9Qml
         q+PTaPyncdQmJR4D411d/DZHJskQLSuQee7pDV3Ah6p8FvG2mV2MlwMOK4QOqbjbAi+S
         hHnRKRd2SQE2pwkrfnsPVd9bIpeyqcaU0BEgNXxxUnPCvqscPW32XOpVxmkKQQoQMnlj
         W3OsqoSTlS1nm3R+/wFSAIJUPaMs03DjuDo8X+VwH1xUHIo1wstKoGZw4NnUCtg9eGc9
         k/ww==
X-Gm-Message-State: AOAM532vng9/CW6VjmBUU8X2Zm8mFVaW4EIiOo9zr20qmkwaMG0PXoZc
        LNG/8qzmbJucomIvu13lYk6X2LspKIpmgfbVh7KoY+5I/+E/Dhb2mCxJtF0AviI0s/HpNVIrDyp
        RTL99KkfFzW388dmD
X-Received: by 2002:adf:f511:: with SMTP id q17mr3637052wro.414.1597319280148;
        Thu, 13 Aug 2020 04:48:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8RW5csMCCrSiBHobEDZMj9QmiDMAx1geqH7u8cSNLCG6KlEWPnnMnrhh1csceZBt9Jv8I0Q==
X-Received: by 2002:adf:f511:: with SMTP id q17mr3637032wro.414.1597319279937;
        Thu, 13 Aug 2020 04:47:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51ad:9349:1ff0:923e? ([2001:b07:6468:f312:51ad:9349:1ff0:923e])
        by smtp.gmail.com with ESMTPSA id b14sm10751480wrj.93.2020.08.13.04.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 04:47:59 -0700 (PDT)
Subject: Re: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq
 information through metricfs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Adams <jwadams@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-7-jwadams@google.com>
 <87mu2yluso.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2500b04e-a890-2621-2f19-be08dfe2e862@redhat.com>
Date:   Thu, 13 Aug 2020 13:47:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87mu2yluso.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/08/20 12:11, Thomas Gleixner wrote:
>> Add metricfs support for displaying percpu irq counters for x86.
>> The top directory is /sys/kernel/debug/metricfs/irq_x86.
>> Then there is a subdirectory for each x86-specific irq counter.
>> For example:
>>
>>    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values
> What is 'TLB'? I'm not aware of any vector which is named TLB.

There's a "TLB" entry in /proc/interrupts.

Paolo

