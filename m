Return-Path: <netdev+bounces-3460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E5F7073F3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 832F81C2093E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BD61078A;
	Wed, 17 May 2023 21:19:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6418BAD28
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:19:15 +0000 (UTC)
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D54AD2D9;
	Wed, 17 May 2023 14:18:56 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6ab113d8589so1133922a34.3;
        Wed, 17 May 2023 14:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684358312; x=1686950312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N6vL2fsfxq6/38TDdxu0CBw8vPRGY2/MXlHJiOSzTok=;
        b=Y17VeasKT/R0ZHCm8xlJ33mSiSE2pBG+Pzej6dc7OpxPh/vJYpVoNsa1ejlkrZMJ2N
         yUFR5J2olLz4pc1XvXxgxmKPOLbopDaqydk9E30DjUIJmxJj05NcE89mAITWk3B7L9EO
         sP59s6IfUdxhBnmy7ghAIVBtWPCzkYF5XSmmG7FoU6M1M+1qGapJCDCXmqvcXN99EB+Y
         GgbPG+7Z3h1VCiv8JD4uLehwl2ONHCKwS2K3FCjVZaHDom6uOMIgE4AEzfCM9h9cnOpt
         7PrgK5Xue9xOEdgLDbWJnLcCsMmXl8UnNF9yFZktt+NQ4RReFy+Z8TtlKP6Jcaxah4qH
         wsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684358312; x=1686950312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6vL2fsfxq6/38TDdxu0CBw8vPRGY2/MXlHJiOSzTok=;
        b=K6/mcUlGZR07f/TxN/E2ZUplhwMhnEVsyED1RlvHDBC4VmM0ac00R8O8XhrsQINHCk
         Rf4KB/ZrMJSp+mDjVhaMqLgqvJCQTB1X+SZsSp4Bfac/GK1dSocn/Dv8wYY3OiZCmfaH
         /RkUwJ1Op0DlGUUPl58l8KVjLEnpZaJGrGyfYKaj9/7r2bsqjsNVOqswm6+zJ/qEU4qG
         5tOzLHXDXkAEiL4753k03SUd1IVIswZouaGoWzicg/RHx24rMntkaqV6Zy3X8pIDpEFN
         DLFOEAwZTwuhK7gkvDQWZTIUWA7o2ildbb2tCax3kFR9ezqbM1zAAKhQHsnCOWuQJA8e
         c08Q==
X-Gm-Message-State: AC+VfDykTxqSiEXVgMJzO/ak5j271KNhAWJEkBNykOWjHiJyDEIqhjdM
	vln1+NPcO2hS1YEMzEtBQQ==
X-Google-Smtp-Source: ACHHUZ7AbL6ppLXitT2ot9B7QQumEOQTXwgSdkGmZx5UgJBDcuWyvJP9GvkN7ysF2NCBRu85Uus5RQ==
X-Received: by 2002:a05:6830:1659:b0:6ab:31ed:85ef with SMTP id h25-20020a056830165900b006ab31ed85efmr89568otr.27.1684358312444;
        Wed, 17 May 2023 14:18:32 -0700 (PDT)
Received: from C02FL77VMD6R ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id dj15-20020a0568303a8f00b006a65be836acsm46300otb.16.2023.05.17.14.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 14:18:32 -0700 (PDT)
Date: Wed, 17 May 2023 14:18:28 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZGVEpHMkerjA2+0V@C02FL77VMD6R>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230517114825.5d7c85a4@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517114825.5d7c85a4@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 11:48:25AM -0700, Jakub Kicinski wrote:
> >             } else {
> > -                   dev_queue = dev_ingress_queue(dev);
> > -                   old = dev_graft_qdisc(dev_queue, new);
> > +                   old = dev_graft_qdisc(dev_queue, NULL);
> > +
> > +                   /* {ingress,clsact}_destroy() "old" before grafting "new" to avoid
> > +                    * unprotected concurrent accesses to net_device::miniq_{in,e}gress
> > +                    * pointer(s) in mini_qdisc_pair_swap().
> > +                    */
> > +                   qdisc_notify(net, skb, n, classid, old, new, extack);
> > +                   qdisc_destroy(old);
> > +
> > +                   dev_graft_qdisc(dev_queue, new);
>
> BTW can't @old be NULL here?

ingress_queue->qdisc_sleeping is initialized to &noop_qdisc (placeholder)
in dev_ingress_queue_create(), and dev_graft_qdisc() also grafts
&noop_qdisc to represent "there's no Qdisc":

	/* ... and graft new one */
	if (qdisc == NULL)
		qdisc = &noop_qdisc;
	dev_queue->qdisc_sleeping = qdisc;

So @old can't be NULL here.

Thanks,
Peilin Ye


