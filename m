Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A3D895C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfJPHZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:25:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbfJPHZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571210708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5d0V9S8ommJVGUrWAIephbxJ0dHyW1i5xgUqQkwiWw=;
        b=IurGQPY/DDJckpPhhp/KyIOGe67lTXdS6RXwRUrm1yjL82w567CHs5fWFVbCiyHCKfU9Hu
        HgvLsXktijDzZrIdhuTic1v5776pfxOB6WJBpimwWz1cwYsWrwS/IKjKfQSZ+ei2LaHAm2
        zXUwIh+Mi9D4FD99kM7kfte3PdzVR7s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-UfS-nfxxOKiUVeINHC_SPA-1; Wed, 16 Oct 2019 03:25:00 -0400
Received: by mail-wr1-f71.google.com with SMTP id k2so11305346wrn.7
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 00:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7pVDKMRb0iY8vtAwjOLtISUgtFuBYzCTEpSdAuatOfE=;
        b=VrDBN2Xdeku4VHMIvpu3wyIzSCeZQuiDFEJ41PoWaMtDIPXaV4CbpeDc6T0QLeyBc7
         o7d2re+5ix66L3AbmBcUKR3Ab5//Zz9tKeGR58jGG0gMsYtcg3uem++NBFCZOYHXqcN6
         NANNJDpOn61M4BN1eq+xYWhC+HUK/Yenb+ELNYn3u/4KU08KED2RK8Q6RjadUXCtAKQX
         Uu3Tdo+7uEL/Wr6h9aK1/vLaYag0fsgpvZdalpiseSJQoG527W7gtP687V9zRbs8PfNe
         kMm7yGBfuCo+ZjBfJ2Aig8teBNByMJuAp7WEnl6Cu4kQ6KbcWxIycW0bD3LMUdNgftuO
         VHhw==
X-Gm-Message-State: APjAAAX5d3dnTaPiOwSpsQ72Q68u6bK+oXgJYLBoUTKJG6M4a9o2oKKQ
        Wch4WtmeHok8q2+K3C6BHozqiWORq8xT4lh4ZeBO+hN4MtYTXwh9OJsyrq5AR0d8f37/voFdWbP
        3hJbqMRlQLu5T5xId
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925354wmt.108.1571210699183;
        Wed, 16 Oct 2019 00:24:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw5Hnm/FlYZhsbogxc96HRPT50pfLfmeGENB2+vf8pJDNEMgxSNXlDgdpTAAP/g6kRKVCeDyw==
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925322wmt.108.1571210698895;
        Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id f20sm1474636wmb.6.2019.10.16.00.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Date:   Wed, 16 Oct 2019 09:24:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-5-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: UfS-nfxxOKiUVeINHC_SPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/19 12:48, Jianyong Wu wrote:
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/a=
rm_arch_timer.c
> index 07e57a49d1e8..3597f1f27b10 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct acpi_=
table_header *table)
>  }
>  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
>  #endif
> +
> +bool is_arm_arch_counter(void *cs)
> +{
> +=09return (struct clocksource *)cs =3D=3D &clocksource_counter;
> +}

As Thomas pointed out, any reason to have a void * here?

However, since he didn't like modifying the struct, here is an
alternative idea:

1) add a "struct clocksource*" argument to ktime_get_snapshot

2) return -ENODEV if the argument is not NULL and is not the current
clocksource

3) move the implementation of the hypercall to
drivers/clocksource/arm_arch_timer.c, so that it can call
ktime_get_snapshot(&systime_snapshot, &clocksource_counter);

Paolo

