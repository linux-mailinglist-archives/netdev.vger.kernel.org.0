Return-Path: <netdev+bounces-6644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B697172A9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C67361C20DEF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4531AA5A;
	Wed, 31 May 2023 00:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399A02113
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:36:39 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE1610A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:36:03 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3f7f864525fso57074731cf.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685493361; x=1688085361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YbzX3yCvs2RMDjdg9a5gWEbN1YLtOqnTsBttqA/f5sc=;
        b=fGuTdifHwV/a29aNH2QB0Xg9wXBpOHl90aj6cwuJrPKVgRHOxOC2hQ3i81zMbc/7us
         UXJc5xjv3EiwruktRFU6KoAD5PgpVjsKcPvMJsWZ0//BBQLecX/6Lqw0VXIsQQdvA41W
         k0j3CGzRDERujOvrn5dPymRBKG0wLvhLOgyrHqA/g+w/ZKJM0+wbyjJ7Io7SypHEMOtJ
         ZPei0eNsSP7P4kE8EiWpH0kMhX0PmQ4HBePCai+Od34379urjikpEet1vMg6s3dFBmKw
         csYOa053MCEfzKLXgMNACVtMjmez3bIgUNDcum84Q2sSHUdm0y8c6X4MNe1dl4B1H4LQ
         zLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493361; x=1688085361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbzX3yCvs2RMDjdg9a5gWEbN1YLtOqnTsBttqA/f5sc=;
        b=CF+PpDnLPLxHpSVEeX/UzEpev72dXvOEHI8HyqEouDxh4oZNI7yQ9U8VfwHgN2yhDD
         uZ7W76j2JI0KBc3pbLWV9apypDJog5etQw9lm/TuWQ4K4+5LU+WnG+5Otg6ZWWMuMVcQ
         biUY4x861Y804R6AX0/koT2ZHDN+Y7gnpvL7tJFyPAnPOdt4BUuu37FWDS8CWZkCiUUh
         7gn4oqRNUxeOvqQynSp1nD3gCBqQzCEW1xkvc10P5Qoxm5P+ldXpHI9q1OzsHhSEqbas
         tbF/LBCb0FAsB4ST1ejJkp2VpCAACsCBKvSabd7GTFKIgVW0XJbOnFrl3bZoK8GgqiLf
         b8rw==
X-Gm-Message-State: AC+VfDwDj9rxcae0YHW0Ep5yIj40exdxw5vnHENM7G/4T5gFFoqAdo9H
	UhIdH8i3QX1x9s2MQKBsdw==
X-Google-Smtp-Source: ACHHUZ53iZHL3fGjeHIRftu4QWTY7+kWLKe4qYmAX8tfD4yU+v/aIG2zPdd23deP2evgsrOy53iHMQ==
X-Received: by 2002:ac8:4e88:0:b0:3f8:3d7:449f with SMTP id 8-20020ac84e88000000b003f803d7449fmr4990361qtp.39.1685493361578;
        Tue, 30 May 2023 17:36:01 -0700 (PDT)
Received: from C02FL77VMD6R.usts.net (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id w18-20020ac843d2000000b003ee08d3e073sm5246399qtn.42.2023.05.30.17.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:36:01 -0700 (PDT)
Date: Tue, 30 May 2023 17:35:55 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>,
	shaozhengchao <shaozhengchao@huawei.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	shaozhengchao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, weiyongjun1@huawei.com,
	yuehaibing@huawei.com, wanghai38@huawei.com,
	peilin.ye@bytedance.com, cong.wang@bytedance.com
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
Message-ID: <ZHaWa/k/XZ+Jn8s7@C02FL77VMD6R.usts.net>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
 <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
 <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 12:16:10PM +0200, Paolo Abeni wrote:
> Perhaps it would be worthy to add a specific test-case under tc-testing
> for this issue?

FYI I've started creating ingress.json tests for the issues fixed in this
series [1].  Zhengchao, I noticed that you've added a lot of tc-tests
before, would you like to add another one for this issue you fixed?  Or I
can do it if you're not going to.

[1] https://lore.kernel.org/r/cover.1685388545.git.peilin.ye@bytedance.com/

Thanks,
Peilin Ye


