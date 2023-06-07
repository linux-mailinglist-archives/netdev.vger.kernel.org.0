Return-Path: <netdev+bounces-8773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFE0725B19
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B217028127B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F6B34D9C;
	Wed,  7 Jun 2023 09:54:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F58F74
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:54:39 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBF41715
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:54:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-256a41d3e81so6064968a91.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 02:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686131678; x=1688723678;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z89rwptI1Sf7G0x+5yZHCUqOjIwmf/viJVlzJ4YQ1k0=;
        b=Rt4iGKgHYzoehqs3pJ7kM7zRCxGPcQ87JPWEK/64ozAC1TJ3yDWgvNzmVq4dUiJiRf
         3u1fFVbO2aLcKSpwgN5o8WYfsjZKOmNt+N76ZS8NKCEPqc1inC8twVfnMwO3/ezNkHgj
         HMAxJILXBMTTxAcHCBY8iRiL4tUQ4P9oh3jXj7vNzUDkh3PSSn6QMxuk8fFwUc/StzhB
         xyv57Y7cREDXDk8EAPcyoNkULE8paLwYzuOUOLVZgn+ImsqO+j6/SbHAr1jfvyAC7Gv2
         olo8w6aaslF3rmhaXL1Rzo6HG00/OKtaeEjUJelm23v7QN5Ss1alxu4jxFEd7tpjkHGJ
         kT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686131678; x=1688723678;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z89rwptI1Sf7G0x+5yZHCUqOjIwmf/viJVlzJ4YQ1k0=;
        b=j/RgGCT348Nff6PxXjBy5p/wUtx+VU3eiquvWhLCha+F7H0V4mynoRWQPfoBAFrias
         aag8PgIodV34QEpaVRMxGgoQPRkz6u9O/TsndEwM+I29Qd+ij/vgJvCaCkcyuyEbHJQh
         jAywX+nt1/nhId5lUS+UYeiiC5Ff1DMVhLi/jtDNAxhrs1wKqTnTLem4WCi9+xfdtiyB
         4fPxjQHLdDbX+TQ0gpe4ArDiXDcrkL0QOwdNpYBLpA8sRVnkE8zpqTg+0DUxyK6DQv9D
         Cr1Vgw2J1Ie2iM2UAYSiRZ607OhCxabdQlDzxKaEvrpSjjwqf3UioJergiez+eTLQM3e
         IUBA==
X-Gm-Message-State: AC+VfDxNUAknZTJqC7Q8NifpROl6O19P6+rCCYXFZyWiAr8bjpeauzfh
	3C/irRNxROW1sUPUYsLcLkKBOW/ampHIcg==
X-Google-Smtp-Source: ACHHUZ512oNmLkyxs0ZH0FlKZmOtSAzTWUgwD0nW3WNxqvBkRV2VtheeTAxzyOGxip2Kll5tuBidvw==
X-Received: by 2002:a17:90a:b002:b0:259:3cf1:6188 with SMTP id x2-20020a17090ab00200b002593cf16188mr4190070pjq.40.1686131677788;
        Wed, 07 Jun 2023 02:54:37 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lk8-20020a17090b33c800b0024de5227d1fsm995499pjb.40.2023.06.07.02.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 02:54:37 -0700 (PDT)
Date: Wed, 7 Jun 2023 17:54:33 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org
Subject: selftests/tc-testings cgroup.json test failed
Message-ID: <ZIBT2d9U9/pdR/gc@Laptop-X1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Zhengchao,

I tried run cgroup.json (and flow.json) with linux 6.3 and iproute 6.3.
But almost test failed. e.g.

All test results:

1..56
not ok 1 6273 - Add cgroup filter with cmp ematch u8/link layer and drop action
        Could not match regex pattern. Verify command output:
filter protocol ip pref 1 cgroup chain 0
filter protocol ip pref 1 cgroup chain 0 handle 0x1
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1


not ok 2 4721 - Add cgroup filter with cmp ematch u8/link layer with trans flag and pass action
        Could not match regex pattern. Verify command output:
filter protocol ip pref 1 cgroup chain 0
filter protocol ip pref 1 cgroup chain 0 handle 0x1
        action order 1: gact action pass
         random type none pass val 0
         index 1 ref 1 bind 1


I saw the matchPattern checks ".*cmp..." which is not exist with my tc output.

"matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",

So which tc version are you using? Am I missed something?

Thanks
Hangbin

