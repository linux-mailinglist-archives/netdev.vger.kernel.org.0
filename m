Return-Path: <netdev+bounces-1985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5769D6FFDAD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A7D71C210A6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CAE64A;
	Fri, 12 May 2023 00:11:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CC6628
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 00:11:30 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063F1FEB;
	Thu, 11 May 2023 17:11:29 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f4de077aaaso22506721cf.1;
        Thu, 11 May 2023 17:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683850288; x=1686442288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAhrsdsfHuWNLZ+EDCW5kgxhkxTw8oftjQzitGQyt1o=;
        b=KQX4+5F16DPv+Xwar3ioHwB7+1rHKkv1+Ld3hHyLG8nmJjBStqzheDZQfV5bb/DdNo
         RDEA4KpEvrpCfAlvLS1stjVEmnjkeYLADIuh4MPMgSULVFXu39CwL+EbSJCd+oMAtcum
         KfW96M9ik14xxIY+pMy+CAFF2hZH3IZahl3qZyTzlSg8Nnd8NKOexfZu4ITw2XvIp9Y2
         GPgL5A9XPOywxpJkoyzMeQ8V1orpiDmVslSB61JASslZSdKX22Kxc3juOy4FbJvWDQRL
         Je0vlHHGdVwJKAyFT/sfWsIoqXn6kb4h3pIFl2yvm+9v4YxZchCdXpTFR8qcFfsmY7n7
         iKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683850288; x=1686442288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAhrsdsfHuWNLZ+EDCW5kgxhkxTw8oftjQzitGQyt1o=;
        b=TcuwxMrcwX7DvR0LA0NBbhy3nvbTT89gjwWxdGBcZ47Xoayb3/Ir/4GAdJ31Ak22N3
         b4RA9XcXZMPqEDXlGP1uGKQAeV3lsQH06gBGpdBjeRnsm+Mn3CoBiBX5gVr65DztfCJZ
         sV+ECNCY4CTzl2T6LUqO4py1k61arpu2gdaLVssh9qAjNMYPfNGcoUkYGZSYEjbZfaQj
         N0mi//D7Wd2FQFZEcQmJeQz3nzDXoq53MTlAA2bV5mpeWtotdc3FVNabGt/hoc7Cab4D
         F2KAUYc5e+HAVZMHUab+aEtgaFSfgZoVnYsjKlbaKKxlo9SjZ0CAkJaJydLtZZKYjua/
         8m3A==
X-Gm-Message-State: AC+VfDxca41IxdEJ9+4Ls6AJtlwI2vyShAR1pu34D42kSXQaNpFqkZhb
	Kuh8BudZ4CnYV4cbTk72Gg==
X-Google-Smtp-Source: ACHHUZ6sWGN7h27F/dhnj1tNOuiDXqvHV7ysNicGCWRSWdtkQ3mjrAVDxwrNjgnouEBe9UkOIUkH8g==
X-Received: by 2002:ac8:7d42:0:b0:3f3:8819:67ec with SMTP id h2-20020ac87d42000000b003f3881967ecmr30535137qtb.15.1683850288526;
        Thu, 11 May 2023 17:11:28 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:8d4a:f604:7849:d619])
        by smtp.gmail.com with ESMTPSA id x14-20020a05620a14ae00b007591cc41ed6sm152731qkj.25.2023.05.11.17.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 17:11:28 -0700 (PDT)
Date: Thu, 11 May 2023 17:11:23 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230508183324.020f3ec7@kernel.org>
 <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
 <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 04:46:33PM -0700, Peilin Ye wrote:
> On Thu, May 11, 2023 at 04:20:23PM -0700, Jakub Kicinski wrote:
> > > But I see your point, thanks for the suggestion!  I'll try ->init() and
> > > create v2.
> >
> > ->init() may be too early, aren't there any error points which could
> > prevent the Qdisc from binding after ->init() was called?
>
> You're right, it's in qdisc_create(), argh...

->destroy() is called for all error points between ->init() and
dev_graft_qdisc().  I'll try handling it in ->destroy().

Thanks,
Peilin Ye


