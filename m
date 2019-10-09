Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7049D138A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbfJIQFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:05:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36577 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfJIQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:05:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so3213160wmc.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OcoDswvcpgORUe+MjF3j+myWKBr/y/JxVMKqWxIZdns=;
        b=PlMwn9qd6erojZKwrGuwRQoT3mBFtPJPdxKkIoi+g/d953cHVVQVDyFhTmkAOHq9HS
         VH6Kz+ynJOta/5jpwjQNaOKkCz8EqFOd8eFpwMkcdLBa/lGr9vFX4ZH9Odb0ZasRfZfg
         hL4ixrbd5H9Gn9ce4slb2XkurFpkRA99mVhAJRq0EpElm5jcHAq+hLY5NEFSOcYi8T5c
         XDGKEmdJaOWe6vEv1mdkMetvYaOe5w19Ke0Q6x3RRBcLXohUpsQ+H+tsU7xqCcKjV69C
         oJPkEMkoDqtuEHAJMbrD0RUQcVb80wtCimLZE2tavU+7cfhJGR2bsMlGyBuIYnXcbGRM
         T4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcoDswvcpgORUe+MjF3j+myWKBr/y/JxVMKqWxIZdns=;
        b=Bhv8iMaYRXnZy0CwOWAIpeGsl+5DzzF5U476P5eQ5z9cYtkjbYTmPoO5YSOQ9Mo406
         TsJYhlJTNU8xri64HM0TfRePqoQQm2TXC5rm3DqPhrfC6Wm0oLSIymLEbJ9H4pjbA+BH
         ZVyh6spj4QfM3pikn0TxHJKCLg/voxBqr/itUE6Ze22p5fF+c05vimrJld913nUT9N5B
         VHXqdTzME07QY0kOj9NAO4El2ySUXIszkyJKVnfLUARi3pWHGh6vg3TxkoCrqGcTSt1Z
         e9zPrnug31zqb2bxRjMWfhoE/Y0gH3rwTjrdU750QEeB8NhuLuYooS0ukTaqc1KSh9wP
         SCxQ==
X-Gm-Message-State: APjAAAVUYoMhlAeJpExBXDUYOY41zjoL1P5clLQGrgA75BSr3oy927m5
        NZN3W5nMBmqZeE/EIaAL2Jow7rymsttL/0u0lXUQmQ==
X-Google-Smtp-Source: APXvYqwf2k+wes8U4KHH/Mq/y7m8PrdEQhLEFToIcu4WDfCk10VCZnURO4OVa/kXncgoav9k+nk3ezXxb9qFfCb0MU8=
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr3238811wme.152.1570637140793;
 Wed, 09 Oct 2019 09:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190918080716.64242-1-jianyong.wu@arm.com> <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com> <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com> <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com> <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com> <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com> <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
In-Reply-To: <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Wed, 9 Oct 2019 09:05:29 -0700
Message-ID: <CALAqxLVa-BSY0i007GfzKEVU1uak4=eY=TJ3wj6JL_Y-EfY3ng@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 2:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 09/10/19 10:18, Jianyong Wu (Arm Technology China) wrote:
> >
> > We must ensure both of the host and guest using the same clocksource.
> > get_device_system_crosststamp will check the clocksource of guest and we also need check
> > the clocksource in host, and struct type can't be transferred from host to guest using arm hypercall.
> > now we lack of a mechanism to check the current clocksource. I think this will be useful if we add one.
>
> Got it---yes, I think adding a struct clocksource to struct
> system_time_snapshot would make sense.  Then the hypercall can just use
> ktime_get_snapshot and fail if the clocksource is not the ARM arch counter.
>
> John (Stultz), does that sound good to you?  The context is that
> Jianyong would like to add a hypercall that returns a (cycles,
> nanoseconds) pair to the guest.  On x86 we're relying on the vclock_mode
> field that is already there for the vDSO, but being able to just use
> ktime_get_snapshot would be much nicer.

I've not really looked at the code closely in awhile, so I'm not sure
my suggestions will be too useful.

My only instinct is maybe to not include the clocksource pointer in
the system_time_snapshot, as I worry that structure will then be
abused by the interface users.  If you're just wanting to make sure
the clocksource is what you're expecting, would instead putting only
the clocksource name in the structure suffice?

thanks
-john
