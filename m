Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6631D33A5
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgENOyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:54:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35134 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727099AbgENOyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:54:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EEpneU022552;
        Thu, 14 May 2020 07:53:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=x8IBUREuUDXo4FtIk04O7Hcn5Vr/q9rC9/eF3dAW9nk=;
 b=xTZ9ZgYOa+dXgk6XERZ3kqEuKm0pnGxc0SzbyedYihgXLYtLsf9HbU/2MTKDD95ow/up
 lUrd38xeGDDXOpEBRunttACRYKhuw8X5tDiSwMm3kFr9S0qtLH3hBU5ZJu1wVWxQ6CKf
 BLi6wfcaHR71sywLaBpu79Ix+bbWXFsmO5Ht0LxRKEwsdMNxqo5Hia41cPB0G8IDPpBp
 hUFPx8qsMLEGJeEVzBwkKw50QUTT/iDDwZBFI4QOnG9z4CNeh4Y2gXYBWBKzQytO+wzd
 F/bEQ16VG/6XtNuAnGXEinM+m7YWv1aE11aQNIEaL9JNcZ+Li9bpRjaEkiRjuQJGW2zH yg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3100xajx64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 07:53:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 07:53:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 07:53:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 07:53:50 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id D79AA3F703F;
        Thu, 14 May 2020 07:53:42 -0700 (PDT)
Subject: Re: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     <jeyu@kernel.org>, <akpm@linux-foundation.org>, <arnd@arndb.de>,
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
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
 <20200509164229.GJ11244@42.do-not-panic.com>
 <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
 <20200512173431.GD11244@42.do-not-panic.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <9badaaa7-ca79-9b6d-aa83-b1c28310ec4d@marvell.com>
Date:   Thu, 14 May 2020 17:53:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200512173431.GD11244@42.do-not-panic.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> So do you mean like the changes below?
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index f4eebaabb6d0..95cb7da2542e 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -7906,6 +7906,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> *buffer)
>  		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
>  				 REGDUMP_HEADER_SIZE, &feature_size);
>  		if (!rc) {
> +			module_firmware_crashed();
>  			*(u32 *)((u8 *)buffer + offset) =
>  			    qed_calc_regdump_header(cdev, GRC_DUMP,
>  						    cur_engine,

Please remove this invocation. Its not a place where FW crash is happening.


>  		DP_NOTICE(p_hwfn,
>  			  "The MFW failed to respond to command 0x%08x
> [param 0x%08x].\n",
>  			  p_mb_params->cmd, p_mb_params->param);
> +		module_firmware_crashed();
>  		qed_mcp_print_cpu_info(p_hwfn, p_ptt);

This one is perfect, thanks!

Regards
  Igor
