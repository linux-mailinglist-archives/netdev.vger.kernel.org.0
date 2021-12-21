Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E87747C9C3
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhLUXfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbhLUXfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:35:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7879FC06173F
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 15:35:01 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso718532pjl.3
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 15:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pOFga3csMzqxlQmjAN5qzbbbVuYOWHf63es+b6CDNAc=;
        b=AWem4FFWepHI4GiG1vYWPraJqQUiTomICNrapdxKgXw5RiWlc2qnmWxmfYwryjrz9H
         ry7VY7ErAoRwxYa+v/F7++t1ymF8xTqaHJqwBwvPOmdTqwicW2GLbpWt9tAFPpvVo9ZC
         itkkdLosZknu7CUrfzqdhVonTuzJaRTCtexVNvlSQ57BTut71N+ikFJQhkcnm/iYRzFf
         m5DDP1CS8Pr+PjWDEubKWtXpeuwIeKMriGQViKqK6jQwG/yIrK99W4YP9JmADxKFkFR/
         RMqEhCYMyii5RsjVK/Zxce07N447Wr2PkWL7kQdJ87omhEQJtFAsxPGD540Fjb7SWbSi
         r+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pOFga3csMzqxlQmjAN5qzbbbVuYOWHf63es+b6CDNAc=;
        b=SZVt6+8dNtWxCn+VNgg+qqKCWfLy0hJfeT4cvjjG/mPN+J77mxex5gkwfuV0BC4G6L
         ErbP/TTYKHWpXSdvC9HY51yG2KTGqUDz9lgv3FgTJvOblNgR4xYhn+tBVExA/ntEb03X
         r2Zblhz85w2yzNf05R2yAyHTrRUIAB48hvV3GCHn96MX5L7mM7tO1MGi6/Sp9wkN63yF
         Sn1Ua05ypES1+ICS29AeTgQWHZVO8fJCH3xD3VpD4k+Z05KdzVvs0nvvcvoN6ejFrkfo
         YO/dWO9PGakfr8fJ+xRJTRjLFE96FRIyMA0QF7LJiO1ZhGyLyfRRiFiNchRD9qDH0Hgq
         1lAw==
X-Gm-Message-State: AOAM53001RZT4mcAKHT+ASTf9vXj0T7A+pTn5EGJRZlOKle9ibR2gbD9
        Qkyc1BQXFkJzcq/TCGuwo0ZBvEEISn7Mfg==
X-Google-Smtp-Source: ABdhPJwE8pf9uY9sS7o5GbRV0wFt25q+iILI8BQPj/jnVtmFK5YsySB0BCDIR5vGr62+1SGA0r60ZA==
X-Received: by 2002:a17:902:d2d2:b0:148:f7d1:6315 with SMTP id n18-20020a170902d2d200b00148f7d16315mr628476plc.10.1640129700992;
        Tue, 21 Dec 2021 15:35:00 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u2sm126412pjc.23.2021.12.21.15.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:35:00 -0800 (PST)
Date:   Tue, 21 Dec 2021 15:34:58 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Message-ID: <20211221153458.51710479@hermes.local>
In-Reply-To: <20211221065047.290182-18-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
        <20211221065047.290182-18-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 00:50:47 -0600
Mike Ximing Chen <mike.ximing.chen@intel.com> wrote:

> The dlb sysfs interfaces include files for reading the total and
> available device resources, and reading the device ID and version. The
> interfaces are used for device level configurations and resource
> inquiries.
> 
> Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-dlb | 116 ++++++++++++
>  drivers/misc/dlb/dlb_args.h                |  34 ++++
>  drivers/misc/dlb/dlb_main.c                |   5 +
>  drivers/misc/dlb/dlb_main.h                |   3 +
>  drivers/misc/dlb/dlb_pf_ops.c              | 195 +++++++++++++++++++++
>  drivers/misc/dlb/dlb_resource.c            |  50 ++++++
>  6 files changed, 403 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-dlb
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-dlb b/Documentation/ABI/testing/sysfs-driver-dlb
> new file mode 100644
> index 000000000000..bf09ef6f8a3a
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-dlb
> @@ -0,0 +1,116 @@
> +What:		/sys/bus/pci/devices/.../total_resources/num_atomic_inflights
> +What:		/sys/bus/pci/devices/.../total_resources/num_dir_credits
> +What:		/sys/bus/pci/devices/.../total_resources/num_dir_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_hist_list_entries
> +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_credits
> +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_cos0_ldb_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_cos1_ldb_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_cos2_ldb_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_cos3_ldb_ports
> +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_queues
> +What:		/sys/bus/pci/devices/.../total_resources/num_sched_domains
> +Date:		Oct 15, 2021
> +KernelVersion:	5.15
> +Contact:	mike.ximing.chen@intel.com
> +Description:
> +		The total_resources subdirectory contains read-only files that
> +		indicate the total number of resources in the device.
> +
> +		num_atomic_inflights:  Total number of atomic inflights in the
> +				       device. Atomic inflights refers to the
> +				       on-device storage used by the atomic
> +				       scheduler.
> +
> +		num_dir_credits:       Total number of directed credits in the
> +				       device.
> +
> +		num_dir_ports:	       Total number of directed ports (and
> +				       queues) in the device.
> +
> +		num_hist_list_entries: Total number of history list entries in
> +				       the device.
> +
> +		num_ldb_credits:       Total number of load-balanced credits in
> +				       the device.
> +
> +		num_ldb_ports:	       Total number of load-balanced ports in
> +				       the device.
> +
> +		num_cos<M>_ldb_ports:  Total number of load-balanced ports
> +				       belonging to class-of-service M in the
> +				       device.
> +
> +		num_ldb_queues:	       Total number of load-balanced queues in
> +				       the device.
> +
> +		num_sched_domains:     Total number of scheduling domains in the
> +				       device.
> +

Sysfs is only slightly better than /proc as an API.
If it is just for testing than debugfs might be better.

Could this be done with a real netlink interface?
Maybe as part of devlink?

