Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9955B2E5
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 18:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiFZQnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 12:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiFZQnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 12:43:55 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0C6BE2C
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 09:43:52 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:35486)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o5VMU-00CexQ-3l; Sun, 26 Jun 2022 10:43:50 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:57694 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o5VMT-008MK1-1s; Sun, 26 Jun 2022 10:43:49 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
References: <20220626082331.36119-1-kuniyu@amazon.com>
Date:   Sun, 26 Jun 2022 11:43:27 -0500
In-Reply-To: <20220626082331.36119-1-kuniyu@amazon.com> (Kuniyuki Iwashima's
        message of "Sun, 26 Jun 2022 01:23:31 -0700")
Message-ID: <871qvbwf2o.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1o5VMT-008MK1-1s;;;mid=<871qvbwf2o.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19yP3gzbiyZQZgVvq8CUuFEy5NpK/3MGaQ=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Kuniyuki Iwashima <kuniyu@amazon.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 485 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.5 (0.9%), b_tie_ro: 3.1 (0.6%), parse: 1.09
        (0.2%), extract_message_metadata: 14 (2.8%), get_uri_detail_list: 2.2
        (0.5%), tests_pri_-1000: 12 (2.4%), tests_pri_-950: 1.09 (0.2%),
        tests_pri_-900: 0.80 (0.2%), tests_pri_-90: 73 (15.0%), check_bayes:
        72 (14.8%), b_tokenize: 5 (1.1%), b_tok_get_all: 7 (1.4%),
        b_comp_prob: 1.67 (0.3%), b_tok_touch_all: 55 (11.3%), b_finish: 0.72
        (0.1%), tests_pri_0: 224 (46.1%), check_dkim_signature: 0.38 (0.1%),
        check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 136 (28.1%), tests_pri_10:
        2.5 (0.5%), tests_pri_500: 150 (31.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima <kuniyu@amazon.com> writes:

> While setting up init_net's sysctl table, we need not duplicate the global
> table and can use it directly.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I am not quite certain the savings of a single entry table justivies
the complexity.  But the looks correct.

Eric


>
> Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v2:
>   * Fix NULL comparison style by checkpatch.pl
>
> v1: https://lore.kernel.org/all/20220626074454.28944-1-kuniyu@amazon.com/
> ---
> ---
>  net/unix/sysctl_net_unix.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
> index 01d44e2598e2..4bd856d05135 100644
> --- a/net/unix/sysctl_net_unix.c
> +++ b/net/unix/sysctl_net_unix.c
> @@ -26,11 +26,16 @@ int __net_init unix_sysctl_register(struct net *net)
>  {
>  	struct ctl_table *table;
>  
> -	table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
> -	if (table == NULL)
> -		goto err_alloc;
> +	if (net_eq(net, &init_net)) {
> +		table = unix_table;
> +	} else {
> +		table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
> +		if (!table)
> +			goto err_alloc;
> +
> +		table[0].data = &net->unx.sysctl_max_dgram_qlen;
> +	}
>  
> -	table[0].data = &net->unx.sysctl_max_dgram_qlen;
>  	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
>  	if (net->unx.ctl == NULL)
>  		goto err_reg;
> @@ -38,7 +43,8 @@ int __net_init unix_sysctl_register(struct net *net)
>  	return 0;
>  
>  err_reg:
> -	kfree(table);
> +	if (net_eq(net, &init_net))
> +		kfree(table);
>  err_alloc:
>  	return -ENOMEM;
>  }
