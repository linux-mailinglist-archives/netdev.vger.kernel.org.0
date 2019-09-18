Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1331B615C
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfIRKXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:23:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30922 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728507AbfIRKXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568802233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PzJJIzaT+H0i65urk/DowU+Nu1kZ2zWoYZTl/vMnWsA=;
        b=NBkUq176kVQSB9vtvsFK2KbuEdUGO/D6ecCpIunhu82G0jzJrck64DsaduzznUKbWzDhwU
        8eAFdHBni7jK1MVlmentoyiTGEslp4iHuc+R8VZoGy42x6OdjNifUK7+5D2JHjoFjpQwhK
        Ny9T2LxyAXpzD/wAGi6RkHcLm50mRVo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-fuF-A7hJN4q1N9JbOwlmPA-1; Wed, 18 Sep 2019 06:23:50 -0400
Received: by mail-wr1-f70.google.com with SMTP id a4so2183648wrg.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 03:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/BXfx7jonw/Kdws8cuIdF1uOWxKnVxEGGX2roqyV5/g=;
        b=ITYB5/MYMxh9d2itU50zljNCYKBHCbuXe4iUVd7DwWz6329P2apL5U3BBNdm3dUtwK
         P5+ZpK+ZzL4mHm7F9HOLYEGd9jH58CRCij1fKH8vydgniw1jLzutfoVQkpYzAWiu9GDN
         fMWZDUXwlddvi5sJJWUL5gnVOSpuWJst8thBS9RjvqhrcRUWNuvqtn4wHNXFf62M2SK4
         6AYM114LwV9ltVCy7i/sihL2zHCF300akSESVdFaWWUZu8L9UWWeezLZD2oCK7y4IGCU
         RoTGdQxMFXiwx0j5R6M9phMtiSs3K3LEwtKz8LyLODF0Kly9jZ8RvIq4E+3a5Uc4K0U6
         5zwg==
X-Gm-Message-State: APjAAAX8Ws58voGKRUvSycwMgNWlFRJohoittoXIAehHswHdxYjoCXxR
        jOa4F1a2Gu5h/IPw3trCww7KA3bRgR9psdkbxYxvG95pd+i7LFnPelBiGRBwVnHfBJud/DzOHwv
        KWjB1C7j3j8Vi9HMj
X-Received: by 2002:adf:e443:: with SMTP id t3mr2384763wrm.181.1568802229667;
        Wed, 18 Sep 2019 03:23:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwfxmTc5Fm4ZBlmRxUIGfYmFyau7KO9p53RPlq/ZJeTwvrFxtmEzKYq4y8POaEPkTSmkwUKyg==
X-Received: by 2002:adf:e443:: with SMTP id t3mr2384734wrm.181.1568802229356;
        Wed, 18 Sep 2019 03:23:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id h125sm2260481wmf.31.2019.09.18.03.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 03:23:48 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
Date:   Wed, 18 Sep 2019 12:23:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: fuF-A7hJN4q1N9JbOwlmPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/19 11:57, Jianyong Wu (Arm Technology China) wrote:
> Hi Paolo,
>=20
>> On 18/09/19 10:07, Jianyong Wu wrote:
>>> +=09case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>>> +=09=09getnstimeofday(ts);
>>
>> This is not Y2038-safe.  Please use ktime_get_real_ts64 instead, and spl=
it the
>> 64-bit seconds value between val[0] and val[1].
>>
> As far as I know, y2038-safe will only affect signed 32-bit integer,
> how does it affect 64-bit integer?
> And why split 64-bit number into two blocks is necessary?

val is an u32, not an u64.  (And val[0], where you store the seconds, is
best treated as signed, since val[0] =3D=3D -1 is returned for
SMCCC_RET_NOT_SUPPORTED).

>> However, it seems to me that the new function is not needed and you can
>> just use ktime_get_snapshot.  You'll get the time in systime_snapshot->r=
eal
>> and the cycles value in systime_snapshot->cycles.
>=20
> See patch 5/6, I need both counter cycle and clocksource, ktime_get_snaps=
hot seems only offer cycles.

No, patch 5/6 only needs the current clock (ptp_sc.cycles is never
accessed).  So you could just use READ_ONCE(tk->tkr_mono.clock).

However, even then I don't think it is correct to use ptp_sc.cs blindly
in patch 5.  I think there is a misunderstanding on the meaning of
system_counterval.cs as passed to get_device_system_crosststamp.
system_counterval.cs is not the active clocksource; it's the clocksource
on which system_counterval.cycles is based.

Hypothetically, the clocksource could be one for which ptp_sc.cycles is
_not_ a cycle value.  If you set system_counterval.cs to the system
clocksource, get_device_system_crosststamp will return a bogus value.
So system_counterval.cs should be set to something like
&clocksource_counter (from drivers/clocksource/arm_arch_timer.c).
Perhaps the right place to define kvm_arch_ptp_get_clock_fn is in that file=
?

>>> +=09=09get_current_counterval(&sc);
>>> +=09=09val[0] =3D ts->tv_sec;
>>> +=09=09val[1] =3D ts->tv_nsec;
>>> +=09=09val[2] =3D sc.cycles;
>>> +=09=09val[3] =3D 0;
>>> +=09=09break;
>>
>> This should return a guest-cycles value.  If the cycles values always th=
e same
>> between the host and the guest on ARM, then okay.  If not, you have to
>> apply whatever offset exists.
>>
> In my opinion, when use ptp_kvm as clock sources to sync time
> between host and guest, user should promise the guest and host has no
> clock offset.

What would be the adverse effect of having a fixed offset between guest
and host?  If there were one, you'd have to check that and fail the
hypercall if there is an offset.  But again, I think it's enough to
subtract vcpu_vtimer(vcpu)->cntvoff or something like that.

You also have to check here that the clocksource is based on the ARM
architectural timer.  Again, maybe you could place the implementation in
drivers/clocksource/arm_arch_timer.c, and make it return -ENODEV if the
active clocksource is not clocksource_counter.  Then KVM can look for
errors and return SMCCC_RET_NOT_SUPPORTED in that case.

Thanks,

Paolo

> So we can be sure that the cycle between guest and
> host should be keep consistent. But I need check it.
> I think host cycle should be returned to guest as we should promise
> we get clock and counter in the same time.

