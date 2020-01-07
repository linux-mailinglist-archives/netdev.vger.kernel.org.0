Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03A132124
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 09:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgAGIPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 03:15:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbgAGIPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 03:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578384942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQRGzBqBQsXxOuL/NbiqXr/q4VMtf5bvXfYxY/rMILs=;
        b=Q4wvNto8Dwg1jnPgTBCRlDLnhkT720tVpC6ekbTSBoD2ZKkN2BKE5yYVxDRhj68QJmNoOV
        vblObCp9/oH6EjpNnKNXCM8ruIn5wq3kGIHEJ5WRdWh08yY0FkB49g7RnkOHhxyORTeysr
        +H/r0DzkNtLkrgyDk+gaT6wRJ8GC21g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-dOQ3U5PfOt2tHoS4qu-15A-1; Tue, 07 Jan 2020 03:15:41 -0500
X-MC-Unique: dOQ3U5PfOt2tHoS4qu-15A-1
Received: by mail-wr1-f70.google.com with SMTP id f15so14029824wrr.2
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 00:15:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQRGzBqBQsXxOuL/NbiqXr/q4VMtf5bvXfYxY/rMILs=;
        b=Oy+iUBcbq1WR6t+/YHpfq+jpS/+vXJ+TGN9cruJ4CSaq0uxBOtTksI7uxUmCrPppN+
         cPLh7E7x91NqBwQ4nSyaP/Rz2sQVxbuyTzMGetMeEpQHfNvmIQnKh8Y6/Fo4aRWk63s3
         Jg5DN1sPxH1522zDKN+bwpjApfpMiImk8CMV2Nv+XgVNfygmxl2Bx/jqzkx3bXl+9sui
         8MZDrX0To7m3gxmUs9NMuuTyCtXWUO5HrSauA272TsV1Cd9qriTuf++aoPPyGQGaS5pN
         CM+QeJD/CYuVhdssV7ebxRROpEIpZRUIOXq1wQ+G4uWFPdYYfUMJzE6x/CKt/6dvSnbW
         RKbA==
X-Gm-Message-State: APjAAAXIdNV3fyqXyndEVX0CHUqIp5RCJKEKPtlf26Q8TDA4TTL4cwsN
        F5mYpznYG5L7IpwtJqzGWAqTusuGFvuiv4VlfWrYsqpzglFuVjpS7sA8OKYlIdVaJen5JFbOn4y
        XVDHPBH5i0AUzZ5ZD
X-Received: by 2002:a5d:5267:: with SMTP id l7mr114892516wrc.84.1578384940078;
        Tue, 07 Jan 2020 00:15:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqy9DHrTW+DUcTH1LaiheNkopWqanGcM3GMd4Lf0wM/9aq/WXTFlIAO5KdOmvRM+5ycJvQu6rQ==
X-Received: by 2002:a5d:5267:: with SMTP id l7mr114892476wrc.84.1578384939771;
        Tue, 07 Jan 2020 00:15:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id k16sm78641877wru.0.2020.01.07.00.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 00:15:38 -0800 (PST)
Subject: Re: [RFC PATCH v9 0/8] Enable ptp_kvm for arm64
To:     Jianyong Wu <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <HE1PR0801MB1676CFC9A06B6CE800052A99F43C0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf333cdc-3455-7c64-89c2-014639614904@redhat.com>
Date:   Tue, 7 Jan 2020 09:15:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676CFC9A06B6CE800052A99F43C0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/20 10:38, Jianyong Wu wrote:
> Ping ...
> Any comments to this patch set?

Marc, Will, can you ack it?  Since the sticky point was the detection of
the clocksource and it was solved by Thomas's patch, I don't have any
more problems including it.

Thanks,

Paolo

>> -----Original Message-----
>> From: Jianyong Wu <jianyong.wu@arm.com>
>> Sent: Tuesday, December 10, 2019 11:40 AM
>> To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
>> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
>> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
>> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
>> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>
>> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
>> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
>> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
>> <Justin.He@arm.com>; Jianyong Wu (Arm Technology China)
>> <Jianyong.Wu@arm.com>; nd <nd@arm.com>
>> Subject: [RFC PATCH v9 0/8] Enable ptp_kvm for arm64
>>
>> kvm ptp targets to provide high precision time sync between guest and host
>> in virtualization environment. Here, we enable kvm ptp for arm64.
>> This patch set base on [1][2][3]
>>
>> change log:
>>
>> from v8 to v9:
>> 	(1) move ptp_kvm.h to driver/ptp/
>> 	(2) replace license declaration of ptp_kvm.h the same with other
>> header files in the same directory.
>>
>> from v7 to v8:
>>         (1) separate adding clocksource id for arm_arch_counter as a single patch.
>>         (2) update commit message for patch 4/8.
>>         (3) refine patch 7/8 and patch 8/8 to make them more independent.
>>
>> from v6 to v7:
>>         (1) include the omitted clocksource_id.h in last version.
>>         (2) reorder the header file in patch.
>>         (3) refine some words in commit message to make it more impersonal.
>>
>> from v5 to v6:
>>         (1) apply Mark's patch[4] to get SMCCC conduit.
>>         (2) add mechanism to recognize current clocksource by add
>> clocksouce_id value into struct clocksource instead of method in patch-v5.
>>         (3) rename kvm_arch_ptp_get_clock_fn into
>> kvm_arch_ptp_get_crosststamp.
>>
>> from v4 to v5:
>>         (1) remove hvc delay compensasion as it should leave to userspace.
>>         (2) check current clocksource in hvc call service.
>>         (3) expose current clocksource by adding it to system_time_snapshot.
>>         (4) add helper to check if clocksource is arm_arch_counter.
>>         (5) rename kvm_ptp.c to ptp_kvm_common.c
>>
>> from v3 to v4:
>>         (1) fix clocksource of ptp_kvm to arch_sys_counter.
>>         (2) move kvm_arch_ptp_get_clock_fn into arm_arch_timer.c
>>         (3) subtract cntvoff before return cycles from host.
>>         (4) use ktime_get_snapshot instead of getnstimeofday and
>> get_current_counterval to return time and counter value.
>>         (5) split ktime and counter into two 32-bit block respectively to avoid
>> Y2038-safe issue.
>>         (6) set time compensation to device time as half of the delay of hvc call.
>>         (7) add ARM_ARCH_TIMER as dependency of ptp_kvm for arm64.
>>
>> from v2 to v3:
>>         (1) fix some issues in commit log.
>>         (2) add some receivers in send list.
>>
>> from v1 to v2:
>>         (1) move arch-specific code from arch/ to driver/ptp/
>>         (2) offer mechanism to inform userspace if ptp_kvm service is available.
>>         (3) separate ptp_kvm code for arm64 into hypervisor part and guest part.
>>         (4) add API to expose monotonic clock and counter value.
>>         (5) refine code: remove no necessary part and reconsitution.
>>
>> [1]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
>> commit/?h=kvm/hvc&id=125ea89e4a21e2fc5235410f966a996a1a7148bf
>> [2]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
>> commit/?h=kvm/hvc&id=464f5a1741e5959c3e4d2be1966ae0093b4dce06
>> [3]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
>> commit/?h=kvm/hvc&id=6597490e005d0eeca8ed8c1c1d7b4318ee014681
>> [4]https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/
>> commit/?h=for-next/smccc-conduit-
>> cleanup&id=6b7fe77c334ae59fed9500140e08f4f896b36871
>>
>> Jianyong Wu (6):
>>   psci: let arm_smccc_1_1_invoke available by modules
>>   ptp: Reorganize ptp_kvm modules to make it arch-independent.
>>   clocksource: Add clocksource id for arm arch counter
>>   psci: Add hvc call service for ptp_kvm.
>>   ptp: arm64: Enable ptp_kvm for arm64
>>   kvm: arm64: Add capability check extension for ptp_kvm
>>
>> Mark Rutland (1):
>>   arm/arm64: smccc/psci: add arm_smccc_1_1_get_conduit()
>>
>> Thomas Gleixner (1):
>>   time: Add mechanism to recognize clocksource in time_get_snapshot
>>
>>  drivers/clocksource/arm_arch_timer.c        | 24 ++++++
>>  drivers/firmware/psci/psci.c                | 16 ++++
>>  drivers/ptp/Kconfig                         |  2 +-
>>  drivers/ptp/Makefile                        |  1 +
>>  drivers/ptp/ptp_kvm.h                       | 11 +++
>>  drivers/ptp/ptp_kvm_arm64.c                 | 53 +++++++++++++
>>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
>>  drivers/ptp/ptp_kvm_x86.c                   | 87 +++++++++++++++++++++
>>  include/linux/arm-smccc.h                   | 30 ++++++-
>>  include/linux/clocksource.h                 |  6 ++
>>  include/linux/clocksource_ids.h             | 13 +++
>>  include/linux/timekeeping.h                 | 12 +--
>>  include/uapi/linux/kvm.h                    |  1 +
>>  kernel/time/clocksource.c                   |  3 +
>>  kernel/time/timekeeping.c                   |  1 +
>>  virt/kvm/arm/arm.c                          |  1 +
>>  virt/kvm/arm/psci.c                         | 22 ++++++
>>  17 files changed, 294 insertions(+), 66 deletions(-)  create mode 100644
>> drivers/ptp/ptp_kvm.h  create mode 100644 drivers/ptp/ptp_kvm_arm64.c
>> rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)  create
>> mode 100644 drivers/ptp/ptp_kvm_x86.c  create mode 100644
>> include/linux/clocksource_ids.h
>>
>> --
>> 2.17.1
> 

