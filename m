Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA88BCA10
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441306AbfIXOUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:20:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21856 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394099AbfIXOUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569334819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4qybsnzerq1m1MESjNMamZC3PQ0Zg5C9AXa25MzaeU=;
        b=DyqGlg0HsbDGgR9DEYIEf8cr8hlg1OrTikl1oIBAXk51IvoEv3wx4K4LhgVOjhxK7Gvtvq
        EQWP+v3TnWLWi/JZDJMzoJ/zrzofqUiiFQmEN7rH8RjLRPi9ys/xOkcPfuxWwX6hFtpX0R
        zA3sdi4QZrIifB+Bjfd7lpL1jKeHqQg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-E4g3GkuRO9uuAYYpqLDhWQ-1; Tue, 24 Sep 2019 10:20:18 -0400
Received: by mail-wm1-f70.google.com with SMTP id k67so94011wmf.3
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 07:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sEyk6USuWuluG4dEpZivpllBkGUrYY+s2EB287d40EY=;
        b=kmf3SyD4wMZ5GpN2yO5MbRH5cTroepN6+6q2e/5NXv0ikK7n2ItihiNtRmNVCjc3J+
         7lAIQn95rxnnkFDvBfYvjJ/XX2lYxCRscT0GKJK9B0MTQf+C82CSL78hIb5eBg4P2X1X
         gqd7VqkH0C2sNUNUglGoRsHHm0U9mwpczr9UgfktteNbWm27lSQoFTExPEUfDCkS33cW
         FNLJPOBMmhM/Bf2qVHfisiq2t2ZWLqGADHnZCbYEyUuugKcCx0/r1wXHiFHrWMaeUzyb
         PdDa1ioD/S4NR/IBWs/ps3t/R1LyVdXwJTGamvI5rCwaz9zFXviz3uHUHPsD/sUHTHNP
         ZS4Q==
X-Gm-Message-State: APjAAAUUd3V0SQPdx7gJtIL1ObDj+zdVMWwLV53VFL9X7+Uxx1+0rz8k
        8gr5i+XuijDuky+8HfZwDwi2SL5I1rhe7vZ6zkM4f0f/XZq9GzGdRVGG3SwKY86Dvman+JTFS3Z
        MhNr7kiPiMJoy3mVY
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr2469146wrw.295.1569334817102;
        Tue, 24 Sep 2019 07:20:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4LF7gV2lQhhn+yrMAt/0oOF5J6XmW/oOSZQJqYKd8ZZoV90deJE9Ub18ZwCF1a3Rr5w2N/g==
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr2469108wrw.295.1569334816822;
        Tue, 24 Sep 2019 07:20:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h125sm183749wmf.31.2019.09.24.07.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:20:15 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
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
 <HE1PR0801MB1676A9D4A58118144F5C7B54F4850@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <06264d8a-b9c0-5f19-db2c-6190976a2a05@redhat.com>
Date:   Tue, 24 Sep 2019 16:20:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676A9D4A58118144F5C7B54F4850@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: E4g3GkuRO9uuAYYpqLDhWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/19 06:57, Jianyong Wu (Arm Technology China) wrote:
>> On 19/09/19 11:46, Jianyong Wu (Arm Technology China) wrote:
>>>> On 18/09/19 11:57, Jianyong Wu (Arm Technology China) wrote:
>>>>> Paolo Bonzini wrote:
>>>>>> This is not Y2038-safe.  Please use ktime_get_real_ts64 instead,
>>>>>> and split the 64-bit seconds value between val[0] and val[1].
>>>
>>> Val[] should be long not u32 I think, so in arm64 I can avoid that
>>> Y2038_safe, but also need rewrite for arm32.
>>
>> I don't think there's anything inherently wrong with u32 val[], and as y=
ou
>> notice it lets you reuse code between arm and arm64.  It's up to you and
>> Marc to decide.
>>
> To compatible 32-bit, Integrates second value and nanosecond value as a n=
anosecond value then split it into val[0] and val[1] and split cycle value =
into val[2] and val[3],
>  In this way, time will overflow at Y2262.
> WDYT?

So if I understand correctly you'd multiply by 10^9 (or better shift by
30) the nanoseconds.

That works, but why not provide 5 output registers?  Alternatively, take
an address as input and write there.

Finally, on x86 we added an argument for the CLOCK_* that is being read
(currently only CLOCK_REALTIME, but having room for extensibility in the
API is always nice).

Paolo

