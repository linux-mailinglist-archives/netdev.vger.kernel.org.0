Return-Path: <netdev+bounces-12222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A9C736C87
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD1311C20C46
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2128E154B5;
	Tue, 20 Jun 2023 12:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109611FA1;
	Tue, 20 Jun 2023 12:59:22 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2810FF;
	Tue, 20 Jun 2023 05:59:20 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-7624e8ceef7so346133885a.2;
        Tue, 20 Jun 2023 05:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687265960; x=1689857960;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4RvNVFujZzQ9FH/nRDQhxgK8HOnuVe0ilksjI7/FigQ=;
        b=V7CBqsvwa7HO9941Gx9rU48fbSNnkTARJq3hU0s4FJKqNq7uyQJvuWMi48BFYirjd9
         Z+CSYTenkWtjPExrbuK55Lr4LajYIvMVcZS1i2H4hkmnnVf92/3eU5+256AdSIU7TTh1
         xwVepNxy0+wSCXEIn2FLnq5fwolgWObqyrXGJD4a4dArZIDrRTCCQbOXeliLMdRNukOE
         bfBqEL3D5v18ty2Fda4DTUDINVko/+/f9bRuKWlc9As/MXSXKCsqRSAvjLHgGSN+PYBz
         OhKP930iRzIK8HICV0ZdtEG/GKM89Wb5av0m6K808diQPwrVMMP/ZUSrK2PjzRbzzuKs
         Xiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687265960; x=1689857960;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4RvNVFujZzQ9FH/nRDQhxgK8HOnuVe0ilksjI7/FigQ=;
        b=TXgc61V4R/4/uHY2QZsPXgAX2Rf37It/aP8tEzZXkexa1Utxq2r8RE3sBLePmzTuoD
         Dg/24MZVRUWEeB9qLSuWh9TxnBk3C9xAbLBjodnoCNHP4jSZs14NOCFeN5e5O5/OJJyU
         9GE1yCOApc5CfQJxBmFnXVMD61xCjgHWd9RJT1do3WkwFPH0npMZTU3gKqWofrJdDGgu
         qXndaATjAJrGxzyM2onxl5nsbdIT81r60FXCvnzC0rq/1EPneitwbOnIpJbj3rrubQw5
         xJcJHr54Exltplonli1SVVhaeuevVfouQJAGylb1lVkNVADLArf5jY1csDryORRiJq3/
         w1pg==
X-Gm-Message-State: AC+VfDw+AvcpB+kzcrU2tO8dary8v4OzIEJ2EVlGXjUryXMHJcwWKhEV
	ljMDIV+uw0uRJ28AUUbBK2o=
X-Google-Smtp-Source: ACHHUZ5DO7ilI0HCjRl4Lbeq4UH3F7W+AS3gn0PcL1py6Hb93MUCpM1EgmXOFtEL5TVj5cEqHyVw6w==
X-Received: by 2002:a05:6214:1306:b0:628:2e08:78b7 with SMTP id pn6-20020a056214130600b006282e0878b7mr5517848qvb.31.1687265959785;
        Tue, 20 Jun 2023 05:59:19 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id m17-20020a0cf191000000b00631ecb1052esm1216204qvl.74.2023.06.20.05.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 05:59:19 -0700 (PDT)
Date: Tue, 20 Jun 2023 08:59:18 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: David Howells <dhowells@redhat.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: dhowells@redhat.com, 
 netdev@vger.kernel.org, 
 Alexander Duyck <alexander.duyck@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 David Ahern <dsahern@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 Jens Axboe <axboe@kernel.dk>, 
 linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, 
 dccp@vger.kernel.org, 
 linux-afs@lists.infradead.org, 
 linux-arm-msm@vger.kernel.org, 
 linux-can@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 linux-hams@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, 
 linux-rdma@vger.kernel.org, 
 linux-sctp@vger.kernel.org, 
 linux-wpan@vger.kernel.org, 
 linux-x25@vger.kernel.org, 
 mptcp@lists.linux.dev, 
 rds-devel@oss.oracle.com, 
 tipc-discussion@lists.sourceforge.net, 
 virtualization@lists.linux-foundation.org
Message-ID: <6491a2a6f1488_3bcfec294d7@willemb.c.googlers.com.notmuch>
In-Reply-To: <784658.1687176327@warthog.procyon.org.uk>
References: <648f36d02fe6e_33cfbc2944f@willemb.c.googlers.com.notmuch>
 <20230617121146.716077-1-dhowells@redhat.com>
 <20230617121146.716077-18-dhowells@redhat.com>
 <784658.1687176327@warthog.procyon.org.uk>
Subject: Re: [PATCH net-next v2 17/17] net: Kill MSG_SENDPAGE_NOTLAST
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

David Howells wrote:
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> 
> > Is it intentional to add MSG_MORE here in this patch?
> > 
> > I do see that patch 3 removes this branch:
> 
> Yeah.  I think I may have tcp_bpf a bit wrong with regard to handling
> MSG_MORE.
> 
> How about the attached version of tcp_bpf_push()?
> 
> I wonder if it's save to move the setting of MSG_SENDPAGE_NOPOLICY out of the
> loop as I've done here.  The caller holds the socket lock.
> 
> Also, I'm not sure whether to take account of apply/apply_bytes when setting
> MSG_MORE mid-message, or whether to just go on whether we've reached
> sge->length yet.  (I'm not sure exactly how tcp_bpf works).

I'm not very familiar with it either.

Instead of inferring whether MSG_MORE is safe to set, as below, sufficient to
rely on the caller to pass it when appropriate?

size = min(apply_bytes, sge->length). I doubt that size < apply_bytes is
ever intended.

And instead of this former branch

                if (flags & MSG_SENDPAGE_NOTLAST)
                        msghdr.msg_flags |= MSG_MORE;

update any caller to pass MSG_MORE instead of MSG_SENDPAGE_NOTLAST, if not yet
done so.

> 		msghdr.msg_flags = flags;
> 
> 		/* Determine if we need to set MSG_MORE. */
> 		if (!(msghdr.msg_flags & MSG_MORE)) {
> 			if (apply && size < apply_bytes)
> 				msghdr.msg_flags |= MSG_MORE;
> 			else if (!apply && size < sge->length &&
> 				 msg->sg.start != msg->sg.end)
> 				msghdr.msg_flags |= MSG_MORE;
> 		}

