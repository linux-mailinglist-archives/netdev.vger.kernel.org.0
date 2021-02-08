Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA6312E8B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhBHKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232165AbhBHJ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612778249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RvZB2MDYfZF1qZTLhRJJTQFx3HJrD/c9ga0gap1r0Iw=;
        b=fTGy6Z9A1F9FKSLFD3+jG/9Pw3YXJrkTB8lPU7zq8NqZMNdxA2QUZb9J+/87Z5wvtIyZ5/
        FqU6jzEBcSPZT2u/VJbp3xQHMZNIMIsuUcLKI0JNUINCOHRbZoLjJd2J36H/EkXeqQJ9a7
        XE/+X0sPsM2xvD3wo7HH4xYg7OM7G48=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-In99Wbf1Pt-khWk0ZwMKbg-1; Mon, 08 Feb 2021 04:57:25 -0500
X-MC-Unique: In99Wbf1Pt-khWk0ZwMKbg-1
Received: by mail-ed1-f70.google.com with SMTP id b1so12983535edt.22
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 01:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RvZB2MDYfZF1qZTLhRJJTQFx3HJrD/c9ga0gap1r0Iw=;
        b=sEVtGwmMv9vddngW8H9vQe6M+HHxwyG3hRhnvhHTzcnSwVbw27It7bL9M7sJQdd2YS
         rcZxk8WwbsYBcsP7XzGs+sOkvD1sRkMlqtJe11vWEnrwff5aGg6MrKzWMfit5mybWSG9
         JVn1d4cYfqBlgbHUA9X5AJY6QUN7VDQSe8R8xxX+oDD5vNXrMj3favTXsC/9Imu2fsjm
         rpYJQYqY+vPWXljv0BMJ3X22RKgekunfYBEJVpSqvjiCF5yvKHSTerJX/KRMWR/5fOGj
         V+OX4RHJZsre8M+Eg9O2LXVvF0WblViPIDWlMXH1xoEsHjNZTj5LLesILdJewwPooPWw
         Zx2w==
X-Gm-Message-State: AOAM533PC4vl/D4ERNCQxtutMrH2gOU7voNhXOREb3CO4UgiiYeyp0fq
        g+tANILU0JtggiSCdWd+W+XrH+w5eYmKqoMfPUoTaJfAp1i9yRhTgu+wxy6r5N5D/xqMdTX5Vqg
        B2xMyLigxiFcKKmS1
X-Received: by 2002:a17:906:69c2:: with SMTP id g2mr15591528ejs.249.1612778244679;
        Mon, 08 Feb 2021 01:57:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuMkDMU86Gua486YyYkyE3So25auj8KdRwJTxDrTGf27Ev7G+jbzxJNKOribW4cbFKzGSizw==
X-Received: by 2002:a17:906:69c2:: with SMTP id g2mr15591508ejs.249.1612778244420;
        Mon, 08 Feb 2021 01:57:24 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id mh4sm5533387ejb.122.2021.02.08.01.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:57:23 -0800 (PST)
Date:   Mon, 8 Feb 2021 04:57:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com, parav@nvidia.com
Subject: Re: [vdpa_sim_net] 79991caf52:
 net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section
Message-ID: <20210208045641-mutt-send-email-mst@kernel.org>
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
 <20210207030330.GB17282@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207030330.GB17282@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 11:03:30AM +0800, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 79991caf5202c7989928be534727805f8f68bb8d ("vdpa_sim_net: Add support for user supported devices")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git Dongli-Zhang/vhost-scsi-alloc-vhost_scsi-with-kvzalloc-to-avoid-delay/20210129-191605
> 
> 
> in testcase: trinity
> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
> with following parameters:
> 
> 	runtime: 300s
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 

Parav want to take a look?

-- 
MST

