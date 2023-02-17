Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1756769AD32
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBQNxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjBQNxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:53:50 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2B013512
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:53:32 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cn2so4545276edb.4
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ce2IYx1cxWdvUXB7PnSnCuxsADdC+K6046BpmKOpG94=;
        b=seBIsagoJ8tPlbwarL6IK7dTQ8bdIeAtcb8sVl/PqajH2Usgrfz4nH7bUA3OfMITzF
         opHBUl49CBhVpcaeTOa09ORmHIYXXi7eGSgGAZxRycw9GbI+rdmp5CP5Iz6irxs7VbLv
         RzFe94uKqQ4my1/g3ZSduvegrQw+yMyiTYKx4G1Yv/MR7fHCD+GOYm4sI7F20vjB52he
         VS1jzBdQ9qJTwOcTnROdeSqxFMa/JUdf4jfzc1Imza7Dy5XjFUlv7LwRCF+i/NGX80ZE
         bEYoZ8+SisfnQWJPDuKAP11p3jFhjTTcbRoyTbkjHL5pjh/ROU8vzVvMk6/yDss3W/AA
         lO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce2IYx1cxWdvUXB7PnSnCuxsADdC+K6046BpmKOpG94=;
        b=UzJfTeEB0uRkcPPBvhS/g13vW69DbfesJStoAvUcygcgKvkDyt4STFR3xQM1mOF/F+
         4HFcm5bU/XvJswn8vm1FJpNR3z9GnATy2ccj5BOty0OhWYiEkumTGY1QGo2df3cZQsq+
         pgJ9igpU2dJpAiE2uvEwDrK2fykuCScVqJ+b/wudyj0HTTBSHdlJgNRhKZeHMPzcchFD
         ByU/T7moVtz5gHk6rz/uN/R0crlCQUOoCmREC+XhlcuAJanD9bo9g5r/UGUsY1q68aeC
         2UNaB6lc7lKzwaTuyhicfs8LqI/T6xbMjA9NupPxyUa5GU1Xqnqax/PJCyE3KnY7VBiL
         w5VQ==
X-Gm-Message-State: AO0yUKVU8bkVm/oOH/bm8j7d54YxEY8QiJrXSM147nva8mPOCzKW7FmN
        iIhoMWZbISQXYBJrXSKGetW2XN/YM7JcjYx56Og=
X-Google-Smtp-Source: AK7set9tVfirY8bLk7/aMJ57J1i/x8s+zHF7SSjuGKrnf+v9zNwFHqGTNqjzxDP+LL3yeu6ogQso+A==
X-Received: by 2002:a17:906:f2d5:b0:8b2:7564:dfd5 with SMTP id gz21-20020a170906f2d500b008b27564dfd5mr1822108ejb.60.1676642005900;
        Fri, 17 Feb 2023 05:53:25 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:e048:140f:ea30:d130? ([2a02:578:8593:1200:e048:140f:ea30:d130])
        by smtp.gmail.com with ESMTPSA id m18-20020a170906849200b0087bd4e34eb8sm2131010ejx.203.2023.02.17.05.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 05:53:25 -0800 (PST)
Message-ID: <eb7bc302-8661-229b-f8b9-d5045bffbd19@tessares.net>
Date:   Fri, 17 Feb 2023 14:53:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next] selftests/bpf: run mptcp in a dedicated netns
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20230217082607.3309391-1-liuhangbin@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230217082607.3309391-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

(+cc MPTCP ML)

On 17/02/2023 09:26, Hangbin Liu wrote:
> The current mptcp test is run in init netns. If the user or default
> system config disabled mptcp, the test will fail. Let's run the mptcp
> test in a dedicated netns to avoid none kernel default mptcp setting.

Thank you for the patch!

I just have one request below if you don't mind:

(...)

> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> index 59f08d6d1d53..8a4ed9510ec7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c

(...)

> @@ -138,12 +148,20 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
>  
>  static void test_base(void)
>  {
> +	struct nstoken *nstoken = NULL;
>  	int server_fd, cgroup_fd;
>  
>  	cgroup_fd = test__join_cgroup("/mptcp");
>  	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
>  		return;
>  
> +	SYS("ip netns add %s", NS_TEST);
> +	SYS("ip -net %s link set dev lo up", NS_TEST);
> +
> +	nstoken = open_netns(NS_TEST);
> +	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
> +		goto cmd_fail;
> +
>  	/* without MPTCP */
>  	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
>  	if (!ASSERT_GE(server_fd, 0, "start_server"))
> @@ -163,6 +181,12 @@ static void test_base(void)
>  
>  	close(server_fd);
>  
> +cmd_fail:
> +	if (nstoken)
> +		close_netns(nstoken);
> +
> +	system("ip netns del " NS_TEST " >& /dev/null");
> +
>  close_cgroup_fd:

If I'm not mistaken, this label should no longer be needed: after the
modification you did, the only 'goto close_cgroup_fd' used above should
be replaced by 'goto cmd_fail', no?

Apart from that, the rest looks good to me.

Cheers,
Matt

>  	close(cgroup_fd);
>  }

-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
