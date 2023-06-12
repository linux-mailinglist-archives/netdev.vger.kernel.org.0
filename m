Return-Path: <netdev+bounces-10125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C9F872C5C5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA47028109D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42C91992E;
	Mon, 12 Jun 2023 13:22:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959E1951B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:22:28 +0000 (UTC)
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B4DE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:22:24 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1a5229df1f2so2502931fac.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686576144; x=1689168144;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rvhM9d6mOYCHQazf1vKI8MGmhgHYnTaI8MfqKcTK034=;
        b=2mt7XiqtCYv/Ttu9YkvcBsTplBSxyu5SjVyFZaxqqQqvJC2Evvs6S0J1/NOSxE17zL
         aZ9eUUkKyliioHnz29hZ97iN8UnSicKl7NOOVMTLi8hPTzOpxO/hxunfy6g6N44zhz23
         xTfYFOheYFw9zdJCUEwQDm2pnF6l6+VZe+d/Z7lQIiNRhasmGyJ1J3gOJCLzjpV90t4P
         m8FP93W93/aFVY0TXotA9AyK55Gp7FM+qoQRAU4iqlX/lWz7WOjLVFH3/snjMFDA6Y5z
         m5DWtNd0EET0mJa1mDCQLGwA9VPf5WQQSJgQO6seYo+Gai1qd/gqPmYunQUX4Y+NEpGt
         /q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686576144; x=1689168144;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rvhM9d6mOYCHQazf1vKI8MGmhgHYnTaI8MfqKcTK034=;
        b=GhVk5yZpfnggTG3w1Nx6honldI6v+pMxE6qti6nUv2Grwp6SwrJmiqMnIUbiai87m6
         e86yYcTkHvo8L9x7mNsA0grNk+t4APpzTmOtqSXJl8tQMaziPoCEWDgOLoqMIx7k5qpt
         jpitYX3y/mVqQ/g8V/JkDtAvf8HF3yeu6l6PXixk97z5TavgMjcickvkOAhEL/Ub09/0
         ICF++c3gTfVf0FGgwu1Ccgjd0+Z4cM2Mp/d6et4iyMq2R2wB+DFcj88AXiyRSBJ0hXQG
         SDWthrnqk45Uhc6UBYT+E8tqvKgfsSMbt+TpAQ2Oa2zQYNbvYJY7kULNX696vn3tJj2y
         qlTg==
X-Gm-Message-State: AC+VfDxbC5+UM/L+mDdiT4waazkphPpkCAXknzzKIW7kCmfaK8A1nckv
	SzkBwVVJB/v2pfWZP7wO9bEB9w==
X-Google-Smtp-Source: ACHHUZ4LBEDzFG7hErN6+dPMJ8zhBhYdKh3pQ/+dRQQ5CchWiCLWmuut9JFO0GhP6b4pt802WK+bOA==
X-Received: by 2002:a05:6870:e14b:b0:19d:6f68:c3f with SMTP id z11-20020a056870e14b00b0019d6f680c3fmr5816114oaa.33.1686576144085;
        Mon, 12 Jun 2023 06:22:24 -0700 (PDT)
Received: from smtpclient.apple ([2804:18:585e:983a:b1a1:8934:1b31:606f])
        by smtp.gmail.com with ESMTPSA id c20-20020a056870479400b0018e96ef6e93sm5841306oaq.54.2023.06.12.06.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 06:22:23 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Victor Nogueira <victor@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net 1/4] selftests/tc-testing: Fix Error: Specified qdisc kind is unknown.
Date: Mon, 12 Jun 2023 10:22:10 -0300
Message-Id: <E38D09CB-AAC9-41D3-975A-4D4DA1B7E783@mojatatu.com>
References: <20230612075712.2861848-2-vladbu@nvidia.com>
Cc: pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 marcelo.leitner@gmail.com, shaozhengchao@huawei.com
In-Reply-To: <20230612075712.2861848-2-vladbu@nvidia.com>
To: Vlad Buslov <vladbu@nvidia.com>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> On Jun 12, 2023, at 04:57, Vlad Buslov <vladbu@nvidia.com> wrote:
>=20
> =EF=BB=BFAll TEQL tests assume that sch_teql module is loaded. Load module=
 in tdc.sh
> before running qdisc tests.
>=20
> Fixes following example error when running tests via tdc.sh for all TEQL
> tests:
>=20
> # $ sudo ./tdc.py -d eth2 -e 84a0
> #  -- ns/SubPlugin.__init__
> # Test 84a0: Create TEQL with default setting
> # exit: 2
> # exit: 0
> # Error: Specified qdisc kind is unknown.
> #
> # -----> teardown stage *** Could not execute: "$TC qdisc del dev $DUMMY h=
andle 1: root"
> #
> # -----> teardown stage *** Error message: "Error: Invalid handle.
> # "
> # returncode 2; expected [0]
> #
> # -----> teardown stage *** Aborting test run.
> #
> # <_io.BufferedReader name=3D3> *** stdout ***
> #
> # <_io.BufferedReader name=3D5> *** stderr ***
> # "-----> teardown stage" did not complete successfully
> # Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'Error: Spec=
ified qdisc kind is unknown.\n', '"-----> teardown stage" did not complete s=
uccessfully') (caught in test_runner, running test 2 84a0 Create TEQL with d=
efault setting stage teardown)
> # ---------------
> # traceback
> #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", l=
ine 495, in test_runner
> #     res =3D run_one_test(pm, args, index, tidx)
> #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", l=
ine 434, in run_one_test
> #     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['tea=
rdown'], procout)
> #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", l=
ine 245, in prepare_env
> #     raise PluginMgrTestFail(
> # ---------------
> # accumulated output for this test:
> # Error: Specified qdisc kind is unknown.
> #
> # ---------------
> #
> # All test results:
> #
> # 1..1
> # ok 1 84a0 - Create TEQL with default setting # skipped - "-----> teardow=
n stage" did not complete successfully
>=20
> Fixes: cc62fbe114c9 ("selftests/tc-testing: add selftests for teql qdisc")=

> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Victor Nogueira <victor@mojatatu.com>

