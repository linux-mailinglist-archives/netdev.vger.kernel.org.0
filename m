Return-Path: <netdev+bounces-8111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA10722BB6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C45E028131D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1404A21088;
	Mon,  5 Jun 2023 15:45:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026356FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:45:50 +0000 (UTC)
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9536D1733
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:45:32 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b166023d47so1260910a34.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685979869; x=1688571869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A90Mk0zhGtoGmxJxaQafKo6YzBEDqEFCob4w8O1kVaw=;
        b=zuuikebe6licttv8Tse/5e+gzZZ4D4z2gmA3z8mMAX2SdXkArSL4TUDb45v6l9IvZm
         b6obQZQle3xp/hYInx2KWqpyQimwN/Zvin1udaN/o69/8313VKYotWXdbfUbz35UEKSz
         2l+BkCjqdSvM9Sw+7OpfSR7iaJ8L+gpE///pmBMS5iX82JUaP0KajO2hFaFAD5BAA0fm
         CKO4vHpAzRbeqfq+FhBbKhFOfcmIyCPYp33PFMGhgmoB60APrXrx/XIPVWVTRWZTnwEi
         n78sZ3QHSwLwLTkFCoHIC7aqzfCR99mAzaU+vvCvm5LfLGdxzZIRWJUFMo+8EV4w/Ae6
         Q/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979869; x=1688571869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A90Mk0zhGtoGmxJxaQafKo6YzBEDqEFCob4w8O1kVaw=;
        b=g3Ff38iDDPfDhQXq8N2KlmMufdEvmA8Mt3+NOqa2ZlTjE2dTQbZNgCnM9UehBOmfQK
         w5gZghiYvnQaf0kV2RNlnlskp3doj30BejvQjEtFjcqL90Pod8s43zv11nBUjCYPvr25
         YeAZlD4m6rfmKQ8SzyI60OSaaOk9ovQs7QCca671+rLNTbJMnI2wpruvCswq3OLJqbr+
         RlRSeViU1/mmZlFEsWNTtLiRefzJD1wE0UwYTnBrJdXoQU8DQMs+iFwYvTUuOqrBDXN6
         aDDiyh+tLG9JCggwFjnD9uWtH7HCYNmREUAda5E9py4VZ+P44mgwbQr1zGBb38o6McuD
         2SFg==
X-Gm-Message-State: AC+VfDw7HInvOKwQzPWtSPjesbwMsojYD2vsPi8EXPuHjRfcBf9YFVId
	HAk7EHuPpy0+KcdQwr2QVuGiybEpc3LeJL2J14f21A==
X-Google-Smtp-Source: ACHHUZ4Tfjk8gbHFmBO99ECiDhiiGggbXGg15OtrRRxs+VRwIA/aSz9fY0Br9IG0xAYSxlcMfU2eCUAgu9MaGurWj+k=
X-Received: by 2002:a05:6358:c4a9:b0:129:d026:e9f2 with SMTP id
 fg41-20020a056358c4a900b00129d026e9f2mr188619rwb.11.1685979868907; Mon, 05
 Jun 2023 08:44:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 5 Jun 2023 11:44:17 -0400
Message-ID: <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's
 relationship with its children
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, linux-kernel@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, 
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>, Peilin Ye <yepeilin.cs@gmail.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 6:38=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> [ Original patch set was lost due to an apparent transient problem with
> kernel.org's DNSBL setup. This is an identical resend. ]
>
> Prompted by Vinicius' request to consolidate some child Qdisc
> dereferences in taprio:
> https://lore.kernel.org/netdev/87edmxv7x2.fsf@intel.com/
>
> I remembered that I had left some unfinished work in this Qdisc, namely
> commit af7b29b1deaa ("Revert "net/sched: taprio: make qdisc_leaf() see
> the per-netdev-queue pfifo child qdiscs"").
>
> This patch set represents another stab at, essentially, what's in the
> title. Not only does taprio not properly detect when it's grafted as a
> non-root qdisc, but it also returns incorrect per-class stats.
> Eventually, Vinicius' request is addressed too, although in a different
> form than the one he requested (which was purely cosmetic).
>
> Review from people more experienced with Qdiscs than me would be
> appreciated. I tried my best to explain what I consider to be problems.

I havent been following - but if you show me sample intended tc
configs for both s/w and hardware offloads i can comment.

In my cursory look i assumed you wanted to go along the path of mqprio
where nothing much happens in the s/w datapath other than requeues
when the tx hardware path is busy (notice it is missing an
enqueue/deque ops). In that case the hardware selection is essentially
of a DMA ring based on skb tags. It seems you took it up a notch by
infact having a choice of whether to have pure s/w or offload path.

cheers,
jamal
> I am deliberately targeting net-next because the changes are too
> invasive for net - they were reverted from stable once already.
>
> Vladimir Oltean (5):
>   net/sched: taprio: don't access q->qdiscs[] in unoffloaded mode during
>     attach()
>   net/sched: taprio: keep child Qdisc refcount elevated at 2 in offload
>     mode
>   net/sched: taprio: try again to report q->qdiscs[] to qdisc_leaf()
>   net/sched: taprio: delete misleading comment about preallocating child
>     qdiscs
>   net/sched: taprio: dump class stats for the actual q->qdiscs[]
>
>  net/sched/sch_taprio.c | 60 ++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 25 deletions(-)
>
> --
> 2.34.1
>

