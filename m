Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8976D4CA85F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbiCBOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbiCBOpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:45:04 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4680366AD5;
        Wed,  2 Mar 2022 06:44:20 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:50778)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nPQDA-00GF8C-Sd; Wed, 02 Mar 2022 07:44:17 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:55716 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nPQD8-005Eiy-SW; Wed, 02 Mar 2022 07:44:16 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
        <YhzeCkXEvga7+o/A@bombadil.infradead.org>
        <20220301180917.tkibx7zpcz2faoxy@google.com>
        <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
        <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
        <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org>
Date:   Wed, 02 Mar 2022 08:43:54 -0600
In-Reply-To: <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org> (Luis Chamberlain's
        message of "Tue, 1 Mar 2022 13:25:16 -0800")
Message-ID: <87ilswwh1x.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nPQD8-005Eiy-SW;;;mid=<87ilswwh1x.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19DnP/IlE2D3X8Ono4RyFyPR6RjJvwkeTc=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Luis Chamberlain <mcgrof@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1409 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (0.8%), b_tie_ro: 9 (0.7%), parse: 1.04 (0.1%),
         extract_message_metadata: 3.4 (0.2%), get_uri_detail_list: 1.23
        (0.1%), tests_pri_-1000: 4.5 (0.3%), tests_pri_-950: 1.12 (0.1%),
        tests_pri_-900: 0.89 (0.1%), tests_pri_-90: 61 (4.4%), check_bayes: 60
        (4.3%), b_tokenize: 8 (0.5%), b_tok_get_all: 9 (0.6%), b_comp_prob:
        2.2 (0.2%), b_tok_touch_all: 39 (2.8%), b_finish: 0.67 (0.0%),
        tests_pri_0: 1299 (92.2%), check_dkim_signature: 0.59 (0.0%),
        check_dkim_adsp: 2.3 (0.2%), poll_dns_idle: 0.65 (0.0%), tests_pri_10:
        3.6 (0.3%), tests_pri_500: 16 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Tue, Mar 01, 2022 at 02:50:06PM -0600, Eric W. Biederman wrote:
>> I really have not looked at this pids controller.
>> 
>> So I am not certain I understand your example here but I hope I have
>> answered your question.
>
> During experimentation with the above stress-ng test case, I saw tons
> of thread just waiting to do exit:

You increment the count of concurrent threads after a no return function
in do_exit.  Since the increment is never reached the count always goes
down and eventually the warning prints.

> diff --git a/kernel/exit.c b/kernel/exit.c
> index 80c4a67d2770..653ca7ebfb58 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -730,11 +730,24 @@ static void check_stack_usage(void)
>  static inline void check_stack_usage(void) {}
>  #endif
>  
> +/* Approx more than twice max_threads */
> +#define MAX_EXIT_CONCURRENT (1<<17)
> +static atomic_t exit_concurrent_max = ATOMIC_INIT(MAX_EXIT_CONCURRENT);
> +static DECLARE_WAIT_QUEUE_HEAD(exit_wq);
> +
>  void __noreturn do_exit(long code)
>  {
>  	struct task_struct *tsk = current;
>  	int group_dead;
>  
> +	if (atomic_dec_if_positive(&exit_concurrent_max) < 0) {
> +		pr_warn_ratelimited("exit: exit_concurrent_max (%u) close to 0 (max : %u), throttling...",
> +				    atomic_read(&exit_concurrent_max),
> +				    MAX_EXIT_CONCURRENT);
> +		wait_event(exit_wq,
> +			   atomic_dec_if_positive(&exit_concurrent_max) >= 0);
> +	}
> +
>  	/*
>  	 * We can get here from a kernel oops, sometimes with preemption off.
>  	 * Start by checking for critical errors.
> @@ -881,6 +894,9 @@ void __noreturn do_exit(long code)
>  
>  	lockdep_free_task(tsk);
>  	do_task_dead();

The function do_task_dead never returns.

> +
> +	atomic_inc(&exit_concurrent_max);
> +	wake_up(&exit_wq);
>  }
>  EXPORT_SYMBOL_GPL(do_exit);
>  
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 4f5613dac227..980ffaba1ac5 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -238,6 +238,8 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
>  		long max;
>  		tns = iter->ns;
>  		max = READ_ONCE(tns->ucount_max[type]);
> +		if (atomic_long_read(&iter->ucount[type]) > max/16)
> +			cond_resched();
>  		if (!atomic_long_inc_below(&iter->ucount[type], max))
>  			goto fail;
>  	}

Eric
