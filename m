Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF57F1CBE12
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgEIGee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:34:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgEIGee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:34:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496VNPO013928;
        Fri, 8 May 2020 23:33:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=r3/icDCoeCmjAYD8L9yr4pNwgvgXAZPIbBZGcN9ONZk=;
 b=k+rPI3tKtvXk4oJeZLJJiFo/0oGrocGPIxBTTZbOWZRcZpHXfo/f7/gkIC01+F7p7CeN
 dBpzrfi5bIN6/c2D51u43axCfCVR+kqEZcUlQwwAFmNPvJmPzP3cniAZ7aC7qEPlqirG
 osoMunv9PP/jsnO6YW0/QLtNSAUQ2jSw/G2uGyB3SRvLW/ywhnFF2edmURAhrySG7U1H
 gHo+z0uGs+AUfu1cVYfpdxE0tQmXSXPUkNMVQAa8x1xeKLVLXd1el7tIYYVF5h30EYWm
 NJOnXsg54rpdfMiQyM+F71LxhQIodvjd4a/XCvIipfyn+vydr8TovPZSbJjUHJLOCgWA VQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wjj7gubg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:33:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:33:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:33:32 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id DE8483F703F;
        Fri,  8 May 2020 23:32:56 -0700 (PDT)
Subject: Re: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>, <jeyu@kernel.org>
CC:     <akpm@linux-foundation.org>, <arnd@arndb.de>,
        <rostedt@goodmis.org>, <mingo@redhat.com>, <aquini@redhat.com>,
        <cai@lca.pw>, <dyoung@redhat.com>, <bhe@redhat.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <gpiccoli@canonical.com>, <pmladek@suse.com>, <tiwai@suse.de>,
        <schlad@suse.de>, <andriy.shevchenko@linux.intel.com>,
        <keescook@chromium.org>, <daniel.vetter@ffwll.ch>,
        <will@kernel.org>, <mchehab+samsung@kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
Date:   Sat, 9 May 2020 09:32:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200509043552.8745-10-mcgrof@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_01:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index f4eebaabb6d0..9cc6287b889b 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -7854,6 +7854,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> *buffer)
>  						 REGDUMP_HEADER_SIZE,
>  						 &feature_size);
>  		if (!rc) {
> +			module_firmware_crashed();
>  			*(u32 *)((u8 *)buffer + offset) =
>  			    qed_calc_regdump_header(cdev,
> PROTECTION_OVERRIDE,
>  						    cur_engine,
> @@ -7869,6 +7870,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> *buffer)
>  		rc = qed_dbg_fw_asserts(cdev, (u8 *)buffer + offset +
>  					REGDUMP_HEADER_SIZE,
> &feature_size);
>  		if (!rc) {
> +			module_firmware_crashed();
>  			*(u32 *)((u8 *)buffer + offset) =
>  			    qed_calc_regdump_header(cdev, FW_ASSERTS,
>  						    cur_engine,
> feature_size,
> @@ -7906,6 +7908,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> *buffer)
>  		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
>  				 REGDUMP_HEADER_SIZE, &feature_size);
>  		if (!rc) {
> +			module_firmware_crashed();
>  			*(u32 *)((u8 *)buffer + offset) =
>  			    qed_calc_regdump_header(cdev, GRC_DUMP,
>  						    cur_engine,


Hi Luis,

qed_dbg_all_data is being used to gather debug dump from device. Failures
inside it may happen due to various reasons, but they normally do not indicate
FW failure.

So I think its not a good place to insert this call.

Its hard to find exact good place to insert it in qed.

One more thing is that AFAIU taint flag gets permanent on kernel, but for
example our device can recover itself from some FW crashes, thus it'd be
transparent for user.

Whats the logical purpose of module_firmware_crashed? Does it mean fatal
unrecoverable error on device?

Thanks,
  Igor

