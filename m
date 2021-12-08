Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7D946D0EF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhLHK2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:28:43 -0500
Received: from foss.arm.com ([217.140.110.172]:56224 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbhLHK2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 05:28:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1AD3ED1;
        Wed,  8 Dec 2021 02:25:10 -0800 (PST)
Received: from [10.57.82.128] (unknown [10.57.82.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C0C33F5A1;
        Wed,  8 Dec 2021 02:25:08 -0800 (PST)
Message-ID: <6915e143-cdfd-ed1b-79db-d01490c3f361@arm.com>
Date:   Wed, 8 Dec 2021 10:25:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/7] pid: Introduce helper task_is_in_init_pid_ns()
To:     Leo Yan <leo.yan@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-2-leo.yan@linaro.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20211208083320.472503-2-leo.yan@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2021 08:33, Leo Yan wrote:
> Currently the kernel uses open code in multiple places to check if a
> task is in the root PID namespace with the kind of format:
> 
>    if (task_active_pid_ns(current) == &init_pid_ns)
>        do_something();
> 
> This patch creates a new helper function, task_is_in_init_pid_ns(), it
> returns true if a passed task is in the root PID namespace, otherwise
> returns false.  So it will be used to replace open codes.
> 
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>   include/linux/pid_namespace.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 7c7e627503d2..07481bb87d4e 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -86,4 +86,9 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
>   void pidhash_init(void);
>   void pid_idr_init(void);
>   
> +static inline bool task_is_in_init_pid_ns(struct task_struct *tsk)
> +{
> +	return task_active_pid_ns(tsk) == &init_pid_ns;
> +}
> +

Looks good to me,

Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
