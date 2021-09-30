Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3241DCD7
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352043AbhI3PBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:01:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47800 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352029AbhI3PBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:01:35 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:36624)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mVxXL-002HN0-LV; Thu, 30 Sep 2021 08:59:51 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:34814 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mVxXK-00CIbw-Ja; Thu, 30 Sep 2021 08:59:51 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexander Kuznetsov <wwfq@yandex-team.ru>
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@gmail.com>
References: <20210921062204.16571-1-wwfq@yandex-team.ru>
Date:   Thu, 30 Sep 2021 09:59:33 -0500
In-Reply-To: <20210921062204.16571-1-wwfq@yandex-team.ru> (Alexander
        Kuznetsov's message of "Tue, 21 Sep 2021 09:22:04 +0300")
Message-ID: <87pmsqyuqy.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mVxXK-00CIbw-Ja;;;mid=<87pmsqyuqy.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Y2FMoU6pJPZyH9vISMLbEd/Bux+65HCo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4080]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Kuznetsov <wwfq@yandex-team.ru>
X-Spam-Relay-Country: 
X-Spam-Timing: total 393 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 10 (2.6%), b_tie_ro: 9 (2.3%), parse: 0.89 (0.2%),
         extract_message_metadata: 12 (3.1%), get_uri_detail_list: 1.96 (0.5%),
         tests_pri_-1000: 9 (2.2%), tests_pri_-950: 1.27 (0.3%),
        tests_pri_-900: 0.99 (0.3%), tests_pri_-90: 79 (20.1%), check_bayes:
        77 (19.7%), b_tokenize: 8 (2.0%), b_tok_get_all: 8 (2.0%),
        b_comp_prob: 2.3 (0.6%), b_tok_touch_all: 56 (14.3%), b_finish: 0.85
        (0.2%), tests_pri_0: 268 (68.3%), check_dkim_signature: 0.52 (0.1%),
        check_dkim_adsp: 3.0 (0.8%), poll_dns_idle: 0.02 (0.0%), tests_pri_10:
        1.96 (0.5%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kuznetsov <wwfq@yandex-team.ru> writes:

> We want to increase route cache size in network namespace
> created with user namespace. Currently ipv6 route settings
> are disabled for non-initial network namespaces.
> Since routes are per network namespace it is safe
> to enable these sysctls.

The case where this matters is when the network namespaces is created by
by the root user in a user namespace.  AKA this is something we allow
any user to do.

These were disabled because out of an abundance of caution rather than
any particular policy when the kernel started allowing non-root users
to create network namespaces.

That said it would really help if your commit message listed the
sysctls you are enabling and listed why it was safe to enable them.

That is it would really help if you performed the review that says
the sysctls are safe for ordinary users to use and that they won't
enable DOS attacks or the like.

If you just care about the route cache size you can only enable
that sysctl.

These are the 10 sysctls you are enabling.  All you talk about
in your commit message is route cache size which I believe is
the 3rd entry in the table net->ipv6.sysctl.ip6_rt_max_size.
It certainly is not all of them.

		table[0].data = &net->ipv6.sysctl.flush_delay;
		table[1].data = &net->ipv6.ip6_dst_ops.gc_thresh;
		table[2].data = &net->ipv6.sysctl.ip6_rt_max_size;
		table[3].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
		table[4].data = &net->ipv6.sysctl.ip6_rt_gc_timeout;
		table[5].data = &net->ipv6.sysctl.ip6_rt_gc_interval;
		table[6].data = &net->ipv6.sysctl.ip6_rt_gc_elasticity;
		table[7].data = &net->ipv6.sysctl.ip6_rt_mtu_expires;
		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;


I took a quick look and we don't enable any of these for ipv4 either.

I suspect it is probably reasonable to enable these sysctls for
all users of the system to use, but can we please show the reason
for each sysctl why it is safe?

Thank you.

Eric



> Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  net/ipv6/route.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index b6ddf23..de85e3b 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6415,10 +6415,6 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
>  		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
>  		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
>  		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
> -
> -		/* Don't export sysctls to unprivileged users */
> -		if (net->user_ns != &init_user_ns)
> -			table[0].procname = NULL;
>  	}
>  
>  	return table;
