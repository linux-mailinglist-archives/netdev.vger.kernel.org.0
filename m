Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B075D5BC3
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfJNG67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:58:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbfJNG67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571036337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fTMccw4yJmRrZCZ9gNo4nMTzO7ADWuT1mX49M7Icnho=;
        b=Z6E2eVOOLBl/hs/JLfDLsLdK2UTxZo5xJu5dr0VqVRCo+Qy/5lXMoSc7PzEOl0hUtXHMyw
        Bg0Qsd5GB1K8i53sJTnGMcAi0jz/Mk40jIuFI0ybxOH+jZy1+L670mddDoptQq1KZhRmjx
        EN74q1IlkLuSzHVm8t0WvcHkHfMONp8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-0Tj78bB8MZ-JjCCyEopS9A-1; Mon, 14 Oct 2019 02:58:54 -0400
Received: by mail-wm1-f71.google.com with SMTP id m6so3919528wmf.2
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 23:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qg9GPSpE2649WBDEVbobtu+jtSwl5swPTKuvxOPA1Ww=;
        b=DJG2SYYKqEmTJSNbkwrvojiartcR3qIXDLEd2dWn4UM67ZYUaq2dn8++CKR9qFrJ3T
         FZ5i07ETE+oaPK1pQ2NuyccZNKzqHKx29UDhDp+insRQh5KR5wtCvLclkdyifK7VQBrT
         tR/4KtFJPaeReVqhCOPHa3ibFAYUpsp2bEpyS1xuefo1dV7C7xL53Jc3Wlu7SS+xjFI9
         do5HI65m0HQVDkptyuBWiC2Eg4nefxvoycKyQ3Xux/NltaqkFdkxZKR4J0AZsC9TiObj
         nS1A5VIE/R5IdkCChxciSOf4KdKJL8wBB60GaRtcXQyWWY0tl2lMCkFb9DPSOkC7ppuK
         p9PQ==
X-Gm-Message-State: APjAAAWy7MhKAz9b/g1mjH+VLaLhxPdJLpcI7gc4wk3C4nOC0X9BuCVJ
        FGj53OvEhyjx/ZGT1EOhbfByuhv8XDJDUwr0PWVmpBa9rVPEuCrWL4hCFo991sqCVYcb3eTe7yD
        H6cPb/Cwn080Ckvee
X-Received: by 2002:a1c:106:: with SMTP id 6mr12661930wmb.134.1571036333212;
        Sun, 13 Oct 2019 23:58:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx2OUyyPpyXE9W0ygYy2lBrXHn8KLvNfyvMNxm3vCpYPWzXJRiYFSSA6PpWL9tHhL0NCFDn6Q==
X-Received: by 2002:a1c:106:: with SMTP id 6mr12661909wmb.134.1571036332956;
        Sun, 13 Oct 2019 23:58:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id q19sm35151293wra.89.2019.10.13.23.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:58:52 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        Marc Zyngier <maz@kernel.org>,
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
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
 <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
 <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
 <HE1PR0801MB167635A4AA59FD93C45872E4F4900@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fc847a82-49cb-c931-617c-82ef5531963e@redhat.com>
Date:   Mon, 14 Oct 2019 08:58:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB167635A4AA59FD93C45872E4F4900@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: 0Tj78bB8MZ-JjCCyEopS9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/19 07:50, Jianyong Wu (Arm Technology China) wrote:
>>
>> John (Stultz), does that sound good to you?  The context is that Jianyon=
g
>> would like to add a hypercall that returns a (cycles,
>> nanoseconds) pair to the guest.  On x86 we're relying on the vclock_mode
>> field that is already there for the vDSO, but being able to just use
>> ktime_get_snapshot would be much nicer.
>>
> Could I add struct clocksource to system_time_snapshot struct in next ver=
sion of my patch set?

Yes, I say go ahead.  At least it will get closer to a final design.

Paolo

