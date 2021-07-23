Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58253D3E4D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhGWQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:34:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23884C061575;
        Fri, 23 Jul 2021 10:15:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mt6so3207955pjb.1;
        Fri, 23 Jul 2021 10:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1JRQTcX3mMh1waCjD0i+OlhIQ+cqEnYe3rn2a3l5PHM=;
        b=fuyiDiQjakWS2nH4pRbhmN0vOH7iHesdh4D0ObiX/uzKRN2NGR36bRa2dK3XV5MoCB
         MF2oe1U9kR27iEcDG04IxZgok7Fl/zd/c/dd5N+NWdc+/FP8qErhBWQgFVxV/kacXjtR
         MW97Lzdlillv+7K1LoQJ0cF1Fsa/SpLtv4nLdMvwGWjtKMGwD5LG5wH/mn/3Xi0n32kC
         c0vWuSpHvKoI/lxg7aonDUu5M4Of5KBg/EIlg2IdY8DeaRsIoKlWMEyCsi+JsNs4aiuE
         3RKapUFqYN+qrfiH5r+peINoRzEVVMSuk5Z4MzafvYrrZjXGxeLRGzxA0RPx8VHr1CYo
         OsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1JRQTcX3mMh1waCjD0i+OlhIQ+cqEnYe3rn2a3l5PHM=;
        b=YZD+bZRA3YIq7W+czPCw6ojBlrs7Qs/1kpW4WNWvgjE6DY0z3lLqOJRaxXY5ZbuVk7
         KRlGTCrVZ2iYOCSMLqD3Ziz9tila1tWVmP6AOLKwd72kjQ67Rq7fKupZKiWwdRoxi9mA
         TBAhwuVj2tUfgXNnvIZWyOfjhWIA9fjykJfr8yUvaiyhmvEA3OAFZaE0mo+802lwmkIv
         o9lhMdvV8Bjtrabm6w9xUDfhIppzYbheSsHshAeHPocQO356pIZlRg+Bnq7hkydUkW87
         5QYRRVrSPAMlGzBT7thEzbnXT9gYQjiXQMfc+x0zMz0zulRE0Ubgjsen3CX/YhnEpwyk
         66pw==
X-Gm-Message-State: AOAM530X+tWuVLo2556gh66AMCy1SOfVv8NwPDooQVHIEOUY5P5+oXDE
        Z6mUe3RPfuop+8KzicHyZII=
X-Google-Smtp-Source: ABdhPJwN1doRO2qvePYhlCrAXf76ZIjgkkW/wHSr9Esk/6YIZFVgz0Xh5Y/B/+lplVHFrsi8hABTrw==
X-Received: by 2002:a62:30c5:0:b029:31e:fa6d:1738 with SMTP id w188-20020a6230c50000b029031efa6d1738mr5326632pfw.55.1627060516543;
        Fri, 23 Jul 2021 10:15:16 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k198sm36382052pfd.148.2021.07.23.10.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 10:15:16 -0700 (PDT)
Subject: Re: [PATCH v5 11/14] scsi: lpfc: Use irq_set_affinity
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        _govind@gmx.com, kabel@kernel.org, viresh.kumar@linaro.org,
        Tushar.Khandelwal@arm.com, kuba@kernel.org
References: <20210720232624.1493424-1-nitesh@redhat.com>
 <20210720232624.1493424-12-nitesh@redhat.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <f1512e42-f2fa-b4e7-4133-4a6066b7ea0d@gmail.com>
Date:   Fri, 23 Jul 2021 10:15:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720232624.1493424-12-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/2021 4:26 PM, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint to set the affinity for the lpfc
> interrupts to a mask corresponding to the local NUMA node to avoid
> performance overhead on AMD architectures.
> 
> However, irq_set_affinity_hint() setting the affinity is an undocumented
> side effect that this function also sets the affinity under the hood.
> To remove this side effect irq_set_affinity_hint() has been marked as
> deprecated and new interfaces have been introduced.
> 
> Also, as per the commit dcaa21367938 ("scsi: lpfc: Change default IRQ model
> on AMD architectures"):
> "On AMD architecture, revert the irq allocation to the normal style
> (non-managed) and then use irq_set_affinity_hint() to set the cpu affinity
> and disable user-space rebalancing."
> we don't really need to set the affinity_hint as user-space rebalancing for
> the lpfc interrupts is not desired.
> 
> Hence, replace the irq_set_affinity_hint() with irq_set_affinity() which
> only applies the affinity for the interrupts.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 

Looks good. Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

