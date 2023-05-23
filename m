Return-Path: <netdev+bounces-4798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 562E070E637
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF24281468
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A78621CFA;
	Tue, 23 May 2023 20:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6802069A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:06:30 +0000 (UTC)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C203129;
	Tue, 23 May 2023 13:06:28 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-75b2a2bf757so18941185a.2;
        Tue, 23 May 2023 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684872387; x=1687464387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSW6rXyGbQGmEN3ktoptl4ak25Rdgx7VmobuefrY3YY=;
        b=aJEi+7FrI3UOyZ7DbnigoJO6CoihKNoxOGkQzE2nhOrhmVaSalsssq1715aEqkQoaa
         IS815EgmFiaUcPC1HMZ7EhxZSsPOUocHKxNOHDXRoe6+PsTOqt3VX9fCz0FHi3u9gnSt
         dfdOAa+wlsPs1Qqv4jHwU6Fl/p22DaoS30zit/hjfMp9oICsxmeMDPpDhxduJZAZ8Ze5
         13x436B/m0WtPi4bfuSm7YHer8wydH0/W+PR3p0NJC6I7wVRWt76y5mp/XbtUTI8J83u
         mbHNVDo+mSPGbVOZE5TfWwAauFfjUyrsWDQkRFicxFZfYxMqwcpVS+XNaebJHNUUl3HU
         1TUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684872387; x=1687464387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSW6rXyGbQGmEN3ktoptl4ak25Rdgx7VmobuefrY3YY=;
        b=ZYL1lzM7AzMs9VJJ0ilS/xRmC9LciCqlTI5pzGvLsiKF/UHe+7YiU7F1YXhhxVVWbL
         fRxAInHHg2zPTjaQ/pdsrYfIgTLGTbLjxaK71LNIoFZwSEAttkXeDsMQJquNmOT2tS2S
         P+bxw2+NTzfh/EPAMDWzdkb5KDAk3sjYF8G/536KVEFpqq5RUWZcXWvYOU7eqsm2KBke
         xPfs5+133KfSR9blrNT6IuAex0PrxH2Gw47DWf8wINFmGK/sgq0mzAYSOqpvsx4l+j6K
         HxiOcrP0beCXP3ndf8tZyKqYiqAnWyaZMPBVZyxhh7omMsTVeY/U2vhFsfQMN/5S6pf2
         Z7fA==
X-Gm-Message-State: AC+VfDyX5Xe7gaGPX2JcBWq8DApiDGDB2H85zmVhXoxVOo22d1Vxbdn5
	jWpptCo80UeHtl8ivRqiwQ==
X-Google-Smtp-Source: ACHHUZ7B3IUuwCKszv5APiktFZhDjNZsHNfvFxrXDzxHR5FhVHSeoU5KBwP4KdDGQVCgfr6ksMnWNg==
X-Received: by 2002:a05:620a:2b2e:b0:75b:23a1:3649 with SMTP id do46-20020a05620a2b2e00b0075b23a13649mr5464137qkb.10.1684872387249;
        Tue, 23 May 2023 13:06:27 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id p5-20020a05620a15e500b0074def53eca5sm2724975qkm.53.2023.05.23.13.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 13:06:26 -0700 (PDT)
Date: Tue, 23 May 2023 13:06:22 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH v2 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZG0cvurl/jqU4DdE@C02FL77VMD6R.googleapis.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
 <5b28cd6f-d921-b095-1190-474bcce89e53@mojatatu.com>
 <ZGxD1U4fI8SNSNOW@C02FL77VMD6R.googleapis.com>
 <e462a91e-8bea-8b72-481c-4a36699e4149@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e462a91e-8bea-8b72-481c-4a36699e4149@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 08:36:35AM -0300, Pedro Tammela wrote:
> > Thanks for testing this, but the syzbot reproducer creates ingress Qdiscs
> > under TC_H_ROOT, which isn't covered by [6/6] i.e. it exercises the
> > "!ingress" path in qdisc_graft().  I think that's why you are still seeing
> > the oops.  Adding sch_{ingress,clsact} to TC_H_ROOT is no longer possible
> > after [1,2/6], and I think we'll need a different reproducer for [5,6/6].
> 
> I was still able to trigger an oops with the full patchset:
> 
> [  104.944353][ T6588] ------------[ cut here ]------------
> [  104.944896][ T6588] jump label: negative count!
> [  104.945780][ T6588] WARNING: CPU: 0 PID: 6588 at kernel/jump_label.c:263
> static_key_slow_try_dec+0xf2/0x110
> [  104.946795][ T6588] Modules linked in:
> [  104.947111][ T6588] CPU: 0 PID: 6588 Comm: repro Not tainted
> 6.4.0-rc2-00191-g4a3f9100193d #3
> [  104.947765][ T6588] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
> [  104.948557][ T6588] RIP: 0010:static_key_slow_try_dec+0xf2/0x110
> [  104.949064][ T6588] Code: d5 ff e8 c1 33 d5 ff 44 89 e8 5b 5d 41 5c 41 5d
> c3 44 89 e5 e9 66 ff ff ff e8 aa 33 d5 ff 48 c7 c7 00 9c 56 8a e8 4e ce 9c
> ff <0f> 0b eb ae 48 89 df e8 02 4b 28 00 e9 42 ff ff ff 66 66 2e 0f 1f
> [  104.951134][ T6588] RSP: 0018:ffffc900079cf2c0 EFLAGS: 00010286
> [  104.951646][ T6588] RAX: 0000000000000000 RBX: ffffffff9213a160 RCX:
> 0000000000000000
> [  104.952269][ T6588] RDX: ffff888112f83b80 RSI: ffffffff814c7747 RDI:
> 0000000000000001
> [  104.952901][ T6588] RBP: 00000000ffffffff R08: 0000000000000001 R09:
> 0000000000000000
> [  104.953523][ T6588] R10: 0000000000000001 R11: 0000000000000001 R12:
> 00000000ffffffff
> [  104.954133][ T6588] R13: ffff88816a514001 R14: 0000000000000001 R15:
> ffffffff8e7b0680
> [  104.954746][ T6588] FS:  00007f76c65d56c0(0000) GS:ffff8881f5a00000(0000)
> knlGS:0000000000000000
> [  104.955430][ T6588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  104.955941][ T6588] CR2: 00007f9a40357a50 CR3: 000000011461e000 CR4:
> 0000000000350ef0
> [  104.956559][ T6588] Call Trace:
> [  104.956829][ T6588]  <TASK>
> [  104.957062][ T6588]  ? clsact_egress_block_get+0x40/0x40
> [  104.957507][ T6588]  static_key_slow_dec+0x60/0xc0
> [  104.957906][ T6588]  qdisc_create+0xa45/0x1090
> [  104.958274][ T6588]  ? tc_get_qdisc+0xb70/0xb70
> [  104.958646][ T6588]  tc_modify_qdisc+0x491/0x1b70
> [  104.959031][ T6588]  ? qdisc_create+0x1090/0x1090
> [  104.959420][ T6588]  ? bpf_lsm_capable+0x9/0x10
> [  104.959797][ T6588]  ? qdisc_create+0x1090/0x1090

Ah, qdisc_create() calls ->destroy() even "if ops->init() failed".  We
should check sch->parent in {ingress,clsact}_destroy() too.  I'll update
[1,2/6] in v5.

Thanks for reporting this!  Seems like I should've run the reproducer
nevertheless.  I'll run it before posting v5.

Thanks,
Peilin Ye


