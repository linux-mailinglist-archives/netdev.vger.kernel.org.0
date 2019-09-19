Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38640B7910
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403761AbfISMNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:13:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390225AbfISMNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568895200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8upZbcqH4fXkVaLOW2dy/iZBybRVQ5oETpjiRcdE6KE=;
        b=Uoos2eUmdiKzuQlXofjnhJ3p1Nwl4lVhuWcraNySJQ9Fpnp7iV8TrTcjMxZgrhJ8FW/iQg
        qmCr1g3ZwdqZfsKwbbFuIGoPYSZ73Vw1mUsR0mc+m+79Y9uqU76+/hg6BlyRPz+qY1gC8Z
        IFTWZqCdNGHCbFXvTreHZvd6SyWyY9o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-jKnGtD1qNg22weKAE_ixyA-1; Thu, 19 Sep 2019 08:13:18 -0400
Received: by mail-wm1-f71.google.com with SMTP id t185so1494333wmg.4
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8upZbcqH4fXkVaLOW2dy/iZBybRVQ5oETpjiRcdE6KE=;
        b=CgcptYOEaK9ojgIg4NpP3ollvaHGuMzl3jYYXpjliFfQO1thmWsuXlXieiFfTrLXcO
         f1218Ja4/sGXrmI/sgPrqkpCc80HVa2gxsOw/M1t7iJ9YsJZXwxTeP0YA4LfTQ79O3vC
         r+uSez1L8ty+zPotR5v7S9Tsy1esXY64jO02GzuARKMEI6W2x9h2YRTSjsM0Eg3IfC9e
         i/uBib0jloP1dcBFMMm1YSztidTTiWZ7kA6E16Xn4mLga6Ut2ZfYudzCoz7K7Xq2eZk7
         dDE6jbkih2O7jtoMcmiANuoDu4O+JfP2HkqduHAvkt/QWedF83KSFu+BeecGVfVdMtez
         ko8A==
X-Gm-Message-State: APjAAAUKC7Qzt2eWcj/iZEa3bn6CtqaIZNCLkeEP0li6vOrShyEXI51e
        pelnHAY58xQIp/ibYuJNvmvZwQlYQlyae1FsCUvkp1+W3rIRISFUZAF7SCsGmUKFFnvOrZBllTZ
        zOezqwU3wueS/n6To
X-Received: by 2002:a5d:6088:: with SMTP id w8mr6995249wrt.31.1568895197143;
        Thu, 19 Sep 2019 05:13:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyoqc728vUxzk+PlHiWZtsz6cgGkTTAs+KWHYRvgq+doGCowWOVSB7hkXrBEQJmElppYJsNwA==
X-Received: by 2002:a5d:6088:: with SMTP id w8mr6995221wrt.31.1568895196846;
        Thu, 19 Sep 2019 05:13:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id x6sm7878924wmf.38.2019.09.19.05.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:13:16 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     Marc Zyngier <maz@kernel.org>,
        "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
Date:   Thu, 19 Sep 2019 14:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
Content-Language: en-US
X-MC-Unique: jKnGtD1qNg22weKAE_ixyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/19 13:39, Marc Zyngier wrote:
>> I don't think it's ugly but more important, using tk->tkr_mono.clock is
>> incorrect.  See how the x86 code hardcodes &kvm_clock, it's the same for
>> ARM.
> Not really. The guest kernel is free to use any clocksource it wishes.

Understood, in fact it's the same on x86.

However, for PTP to work, the cycles value returned by the clocksource
must match the one returned by the hypercall.  So for ARM
get_device_system_crosststamp must receive the arch timer clocksource,
so that it will return -ENODEV if the active clocksource is anything else.

Paolo

> In some cases, it is actually desirable (like these broken systems that
> cannot use an in-kernel irqchip...). Maybe it is that on x86 the guest
> only uses the kvm_clock, but that's a much harder sell on ARM. The fact
> that ptp_kvm assumes that the clocksource is fixed doesn't seem correct
> in that case.

