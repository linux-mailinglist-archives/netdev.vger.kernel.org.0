Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42AD891F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfJPHNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:13:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26373 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726527AbfJPHNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:13:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571210032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+nkQRyeopKoQt4du7dFN9BRIgBaHV958j8ZBKBE5e0=;
        b=MoJkiRSZ7ZlIet1eXCiP4e23f+gbzTA/xv0TA2kzvrEm6Vw4pYbXEXQVQailc8swqM7Of0
        7B3dtyzh8sEylU2e3LD+zdFyEjevBzLD+OAWxTvc+g1A/BQHnvgD7itwFr5ovWwqm1QcP6
        j036n+wHSrM0p46brF0msc+pvC7BzWI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-FBV0T7n5NpCGlCWI8Z4qGg-1; Wed, 16 Oct 2019 03:13:51 -0400
Received: by mail-wr1-f72.google.com with SMTP id m14so11277887wru.17
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 00:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Puk2gzKjg2U5mW3uARabrgwbGmI43WYHISWUlwSLVQ=;
        b=ukJ8TDzc0Nsr7LacNKPDP7k1T/e6k7pS73MzNLOu2kxLaQxwFgBenzGwI7fyFQUWFG
         +8TyhqvG1tkAAOS+VD443ccTDGCW6tW9tB13dIwdKRP/4q3zS14zJhkMFBqHaSMwNAfu
         RL2qkkr5TRv39bFJQVFooT7CYFzxNdBJzGyRLc1KVZPZmpkdYJVVgu5HSpYNbDDaH5x4
         JLkZcJ6RW4X18JCRvDCLMNqy2Bpvvst1WV/kzqoaziRHUruOeysLTp0/28GUCHb3uNbF
         bmTJ69EYHTZoYlme7jgUuHopBilLMYzAaH5uL6ciU8eh/DkXn+VsWhAwCcRDqGRUXSO3
         R4ng==
X-Gm-Message-State: APjAAAWVrKuOEWYAKZyr2rASGo9sJxLx4uZL2aSjEZJAB5R6YQ0fGfT2
        6x6qVhLZaCfrCZbPaSr+3TqMaVterwwLLYHB0C2FWBO5ctyhDuXdvAVpBeB1UYeu9oYHyiDbjlq
        187HRnWMRMHBph3Fu
X-Received: by 2002:a1c:6709:: with SMTP id b9mr2164255wmc.14.1571210029964;
        Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzil7ngX2+rV1FuqUIzc7TJZOMSmcjqUkdazl9Cfq2UEQrrOgM1lpUEgLCAkoYOX3c/5g590A==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr2164227wmc.14.1571210029679;
        Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id b15sm1429843wmb.28.2019.10.16.00.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
Subject: Re: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
 <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Message-ID: <140551c1-b56d-0942-58b3-61a1f5331e83@redhat.com>
Date:   Wed, 16 Oct 2019 09:13:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Content-Language: en-US
X-MC-Unique: FBV0T7n5NpCGlCWI8Z4qGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/10/19 09:10, Paolo Bonzini wrote:
> On 16/10/19 05:52, Jianyong Wu (Arm Technology China) wrote:
>> This func used only by kvm_arch_ptp_get_clock and nothing to do with
>> kvm_arch_ptp_get_clock_fn. Also it can be merged into
>> kvm_arch_ptp_get_clock.
>>
>=20
> Your patches also have no user for kvm_arch_ptp_get_clock, so you can
> remove it.

Nevermind.  I misread patch 2.  However, to remove the confusion, can
you rename kvm_arch_ptp_get_clock_fn to kvm_arch_ptp_get_crosststamp?

Paolo

