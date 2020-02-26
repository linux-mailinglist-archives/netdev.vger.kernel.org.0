Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630DC16FB46
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBZJsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:48:30 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:35233 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgBZJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:48:30 -0500
Received: by mail-lj1-f181.google.com with SMTP id q8so2336849ljb.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fMqomt3au4mw3rs+cfmiekqfa2JRktsB+lFu7iDOZLo=;
        b=SuSQnD3fwI+d+3Pl9Fe/vO8O+Orp2gdJcU9QogT2ewWvj0hA2nPoTK4QQtd4QNxYVV
         1175e70cfa9ufg/UEU7n0D8Naz6bzHg7zpSw3PWqbWXbq/JKwT2o5qGYBOdxytdY+z1Q
         V1uGShdASBaAA6gveyQbZoXq7Xh4XF7yvUm//v9xBM1E/f0DMjge3i4ZP3fslxAMqUwy
         qh1RLTMqZ4DXtMNfIwo7ekbyJOW7XslwdWmzCNr/CVd88vGHots9JFze0EfZvsUHeijX
         WnojPosrAUcAhnsw543qPlf4FLb0Tw8gXfhnOKsmKnJzSCXgRwwINSFpSNIkj21q4n/u
         4o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fMqomt3au4mw3rs+cfmiekqfa2JRktsB+lFu7iDOZLo=;
        b=kPSRGUWozEdp8uqW16OAPR/cBxzzGrY1dNoFEI7iDYAkt9BVYfSzitT5e+/uDmuOYd
         o5kmj79FKqBV0YLE86md9sUlAf1AAV4RrvI2hDx13BJ7FLpYByZfJthzBXjWjsrnFMlg
         jDmd6uCXCl3dQOWl5bmDP7oAKcjxtEiMQOcjwk/GQXMFh/hQkznmOYOq1IK/rCuOFzLT
         B0kTp7kSnJ2Z6C4XU83L/4mTWFyHaJ8127BCm+TQZAXDbSw6EBVYPel5gaJWqiO/lafE
         2Zh3yBBg9fpQCS+/DGcvVaP6qj7UKP5dnELsVLCEh+K8KfFVP9rBmQBhqHxXgoNgSzoS
         u6gA==
X-Gm-Message-State: ANhLgQ2nUhT3eJq8XKXDLIV09MD5PvMRyTYu5Ghl6pJYVaWdTXKExHik
        fZw0c9FNXn0iG9YlECFoyK2fDFF2AmWecxRXmOx5PA==
X-Google-Smtp-Source: APXvYqxtqmfaB85GL7bWrq5ebCXZx5SS6EurjoExEzjh7n5AUy6x0Zwy/tGRvM1zoeqC5slgqusKzwJfg28DAfbvdtU=
X-Received: by 2002:a2e:808a:: with SMTP id i10mr2374462ljg.151.1582710508236;
 Wed, 26 Feb 2020 01:48:28 -0800 (PST)
MIME-Version: 1.0
References: <C7D5F99D-B8DB-462B-B665-AE268CDE90D2@vmware.com>
In-Reply-To: <C7D5F99D-B8DB-462B-B665-AE268CDE90D2@vmware.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 26 Feb 2020 10:48:16 +0100
Message-ID: <CAKfTPtA9275amW4wAnCZpW3bVRv0HssgMJ_YgPzZDRZ3A1rbVg@mail.gmail.com>
Subject: Re: Performance impact in networking data path tests in Linux 5.5 Kernel
To:     Rajender M <manir@vmware.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rajender,

On Tue, 25 Feb 2020 at 06:46, Rajender M <manir@vmware.com> wrote:
>
> As part of VMware's performance regression testing for Linux Kernel upstr=
eam
>  releases, when comparing Linux 5.5 kernel against Linux 5.4 kernel, we n=
oticed
> 20% improvement in networking throughput performance at the cost of a 30%
> increase in the CPU utilization.

Thanks for testing and sharing results with us. It's always
interesting to get feedbacks from various tests cases

>
> After performing the bisect between 5.4 and 5.5, we identified the root c=
ause
> of this behaviour to be a scheduling change from Vincent Guittot's
> 2ab4092fc82d ("sched/fair: Spread out tasks evenly when not overloaded").
>
> The impacted testcases are TCP_STREAM SEND & RECV =E2=80=93 on both small
> (8K socket & 256B message) & large (64K socket & 16K message) packet size=
s.
>
> We backed out Vincent's commit & reran our networking tests and found tha=
t
> the performance were similar to 5.4 kernel - improvements in networking t=
ests
> were no more.
>
> In our current network performance testing, we use Intel 10G NIC to evalu=
ate
> all Linux Kernel releases. In order to confirm that the impact is also se=
en in
> higher bandwidth NIC, we repeated the same test cases with Intel 40G and
> we were able to reproduce the same behaviour - 25% improvements in
> throughput with 10% more CPU consumption.
>
> The overall results indicate that the new scheduler change has introduced
> much better network throughput performance at the cost of incremental
> CPU usage. This can be seen as expected behavior because now the
> TCP streams are evenly spread across all the CPUs and eventually drives
> more network packets, with additional CPU consumption.
>
>
> We have also confirmed this theory by parsing the ESX stats for 5.4 and 5=
.5
> kernels in a 4vCPU VM running 8 TCP streams - as shown below;
>
> 5.4 kernel:
>   "2132149": {"id": 2132149, "used": 94.37, "ready": 0.01, "cstp": 0.00, =
"name": "vmx-vcpu-0:rhel7x64-0",
>   "2132151": {"id": 2132151, "used": 0.13, "ready": 0.00, "cstp": 0.00, "=
name": "vmx-vcpu-1:rhel7x64-0",
>   "2132152": {"id": 2132152, "used": 9.07, "ready": 0.03, "cstp": 0.00, "=
name": "vmx-vcpu-2:rhel7x64-0",
>   "2132153": {"id": 2132153, "used": 34.77, "ready": 0.01, "cstp": 0.00, =
"name": "vmx-vcpu-3:rhel7x64-0",
>
> 5.5 kernel:
>   "2132041": {"id": 2132041, "used": 55.70, "ready": 0.01, "cstp": 0.00, =
"name": "vmx-vcpu-0:rhel7x64-0",
>   "2132043": {"id": 2132043, "used": 47.53, "ready": 0.01, "cstp": 0.00, =
"name": "vmx-vcpu-1:rhel7x64-0",
>   "2132044": {"id": 2132044, "used": 77.81, "ready": 0.00, "cstp": 0.00, =
"name": "vmx-vcpu-2:rhel7x64-0",
>   "2132045": {"id": 2132045, "used": 57.11, "ready": 0.02, "cstp": 0.00, =
"name": "vmx-vcpu-3:rhel7x64-0",
>
> Note, "used %" in above stats for 5.5 kernel is evenly distributed across=
 all vCPUs.
>
> On the whole, this change should be seen as a significant improvement for
> most customers.
>
> Rajender M
> Performance Engineering
> VMware, Inc.
>
