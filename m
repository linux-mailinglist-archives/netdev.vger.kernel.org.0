Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779F6698E68
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBPIOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPIOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:14:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527662449A;
        Thu, 16 Feb 2023 00:14:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id pg6-20020a17090b1e0600b002349579949aso975537pjb.5;
        Thu, 16 Feb 2023 00:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2mCrBq3yYB5VRgm94eU6RWKPMWlaum/MNTQSyHr5w8=;
        b=XeurRTEV5AurvBUcVVg0Nvnt98jp+Y+ncNvpC3XbqGgcYdJCtU93rdfmrnFf/NLBsi
         8UbrWt8rLm2rBpwvQJPhVNfLs2Z+f/po572C/FIRZkIdkcT8lx11zzqxpgs603d2T4cc
         ds980WmJx8H8NNxlqkDOS7xs5DSI40jcnrMYI1lY8UQSisBLXJW7TU3cSbEI8BB08fzY
         nz/pAYiv0igDVdcxMGolj89eVETbobAj3IbuVD1ZIay37JrjQ33mMxzEz/k10EtpO5A8
         6+ZKu7HAd1JixxHbnKJifCLG5DZZqECopFebrw5A5STMW4/Fq57npx9dI5EpkCXN13l0
         C5qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2mCrBq3yYB5VRgm94eU6RWKPMWlaum/MNTQSyHr5w8=;
        b=dcziqlGA5aB4Pd9G4mv62EjENEH7DWBmBVAxpaV18pNpBdFH6P6SIc4v2UO9bulVmi
         CFSrwwbHM2tSovbiF8QuTW3nAM8qm+GYpPFJ0uYDIteU0LokU5P6tu1HSVt8TUTnK4/f
         YaKwVN2o8zYpAbWgRtw07GZOkUFSYWIuNULfOM7XC5QFVM7bkeOGiRYtRjH61M0wnVkF
         ejJQGGnUlub6YD/x1CCG31NRBqQn4eEP009rw5EiocwVn+6StKPRPLK2PrCjyOLH2o6K
         1deC0Vcs3CgdklWgWUrgh5hkfP/FcwpKTVh0HBTLohzqroQAvqyzl5/O+Q0CdsZ+cq8a
         XDJQ==
X-Gm-Message-State: AO0yUKX7IOamZ0dUQCtOp/MxpF1THUq+Z+qGC7OitMnDhufdZJnOIyo2
        L8vQsEypKcHrZk5TD0Pj73Y=
X-Google-Smtp-Source: AK7set/1Dalh7ATEkDCsP+YKNT2GmKU2W/dc2EItt02AoZ+3CIyzO1iwPqN8mdEQRpXMnkcQGeZIKQ==
X-Received: by 2002:a17:90b:3a89:b0:233:cffb:1cc9 with SMTP id om9-20020a17090b3a8900b00233cffb1cc9mr6262231pjb.46.1676535243840;
        Thu, 16 Feb 2023 00:14:03 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b24-20020a17090ae39800b002349fcf17f8sm496555pjz.15.2023.02.16.00.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 00:14:02 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:13:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Message-ID: <Y+3lwZChsI0Trok8@Laptop-X1>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1>
 <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
 <Y+xU8i7BCwXJuqlw@Laptop-X1>
 <a7331a33-fc1f-f74b-4df6-df9483c81125@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7331a33-fc1f-f74b-4df6-df9483c81125@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 10:58:20AM +0100, Matthieu Baerts wrote:
> Hi Hangbin, Martin,
>
> Thank you both for your replies!
> 
> Yes, that would be good to have this test running in a dedicated NS.
> 
> Then mptcp.enabled can be forced using write_sysctl() or SYS("sysctl (...)".
> 

Hi Matt, Martin,

I tried to set make mptcp test in netns, like decap_sanity.c does. But I got
error when delete the netns. e.g.

# ./test_progs -t mptcp
Cannot remove namespace file "/var/run/netns/mptcp_ns": Device or resource busy
#127/1   mptcp/base:OK
#127     mptcp:OK
Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

Do you have any idea why I can't remove the netns? Here is the draft patch:

diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 59f08d6d1d53..5ad10a860994 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -7,6 +7,16 @@
 #include "network_helpers.h"
 #include "mptcp_sock.skel.h"
 
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto fail;				\
+	})
+
+#define NS_TEST "mptcp_ns"
+
 #ifndef TCP_CA_NAME_MAX
 #define TCP_CA_NAME_MAX	16
 #endif
@@ -169,6 +179,22 @@ static void test_base(void)
 
 void test_mptcp(void)
 {
+	struct nstoken *nstoken = NULL;
+
+	SYS("ip netns add %s", NS_TEST);
+	SYS("ip -net %s link set dev lo up", NS_TEST);
+
+	nstoken = open_netns(NS_TEST);
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto fail;
+
 	if (test__start_subtest("base"))
 		test_base();
+
+fail:
+	if (nstoken)
+		close_netns(nstoken);
+
+	//system("ip netns del " NS_TEST " >& /dev/null");
+	system("ip netns del " NS_TEST);
 }
