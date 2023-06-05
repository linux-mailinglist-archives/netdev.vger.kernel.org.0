Return-Path: <netdev+bounces-7927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6AA72223C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD0A281173
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409D413ADA;
	Mon,  5 Jun 2023 09:31:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEF9134BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:31:58 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A14AA7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:31:55 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75ca95cd9b1so442651585a.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 02:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685957513; x=1688549513;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwZ0Z/T0sFnRR5EmVG78/Pfv2keXVguAKEZ6Vl6IYFU=;
        b=okREgiHHLdwmfpUaOyF4Dw05nGgdtKoBJmEfRQWqXFEv7aCkzrzuQb6T19K8C2eDHx
         o9IamyADrR9F667Y24h3hTlnwAgg5qfJI5sXL7NzEp0I1Aronudbi8gmlvjSoBaDA+Lx
         bL1dZd7gDpBrjgpVFRJg6KLsGBPcgqwJeuNCyvEPStUWpyjLgU+gBXAfptyp+ljZRLZK
         tmUyBdpYvJE71XDq62KCrnxQ7Wg3JS5TxNc1OCiOn25Bof1DspP4p4Uptug7vmoG/Qyf
         Gk9syDtmvBWHUkG4AUa71TDLvK+LPhcJjuC5V59oJrQUEtBHmAS2gH1MdIETC+IPD4JL
         OxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685957513; x=1688549513;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cwZ0Z/T0sFnRR5EmVG78/Pfv2keXVguAKEZ6Vl6IYFU=;
        b=Y3iKXOEyDxNV7hcgrqe0GGCx00798VmYPRXhISyvgycP9hV4eHZO/oArHe+orTHjCP
         Zw3levRTitws4oj44wBAT44RfyzD2GWGIPAZpD9G2Zwv3Iak79UPchBmWQOeoVX8idtt
         TXn6+hwT3RBIXwkYGyCxQOJ2j5QGSujg7byoc8WAh+epMwAsIZvxcmg0tjvDTGRso/Tb
         W+5XQxthKnAqspVRreFDBlPtfrV8KzGttTmZAq6IJ3EpImPqyVZJqRvdtnMBe9AbtJq9
         0j+rO+Bpr2ITA5ghpzYQJ4/3+vdgbJ8Z5akGB7g8hF966pJXrDSjwn0n5r/80NLj3YWT
         sxzg==
X-Gm-Message-State: AC+VfDy0qtTnw9gFRK/BOirUu+fr05M942S348O9LQNcmHRQj/KsljgX
	H2kYWjgdfg3uw3DaLVReKeE=
X-Google-Smtp-Source: ACHHUZ7Bw2Xbn6u1PmjmIiSIk5PlSGBZRrEE/QRKoptQJyEWPevWFiQYisqbR3rEt4g2QrwZ47gFhg==
X-Received: by 2002:a05:620a:4608:b0:75b:23a1:365e with SMTP id br8-20020a05620a460800b0075b23a1365emr23161028qkb.31.1685957513223;
        Mon, 05 Jun 2023 02:31:53 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id o9-20020a05620a130900b0074a6c29df4dsm4051855qkj.119.2023.06.05.02.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 02:31:52 -0700 (PDT)
Date: Mon, 05 Jun 2023 05:31:52 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, 
 davem@davemloft.net
Cc: netdev@vger.kernel.org, 
 edumazet@google.com, 
 pabeni@redhat.com, 
 simon.horman@corigine.com, 
 Jakub Kicinski <kuba@kernel.org>
Message-ID: <647dab8865654_d27b6294f8@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230604175843.662084-5-kuba@kernel.org>
References: <20230604175843.662084-1-kuba@kernel.org>
 <20230604175843.662084-5-kuba@kernel.org>
Subject: RE: [PATCH net-next v2 4/4] tools: ynl: add sample for netdev
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

Jakub Kicinski wrote:
> Add a sample application using the C library.
> My main goal is to make writing selftests easier but until
> I have some of those ready I think it's useful to show off
> the functionality and let people poke and tinker.
> 
> Sample outputs - dump:
> 
> $ ./netdev
> Select ifc ($ifindex; or 0 = dump; or -2 ntf check): 0
>       lo[1]	0:
>   enp1s0[2]	23: basic redirect rx-sg
> 
> Notifications (watching veth pair getting added and deleted):
> 
> $ ./netdev
> Select ifc ($ifindex; or 0 = dump; or -2 ntf check): -2
> [53]	0: (ntf: dev-add-ntf)
> [54]	0: (ntf: dev-add-ntf)
> [54]	23: basic redirect rx-sg (ntf: dev-change-ntf)
> [53]	23: basic redirect rx-sg (ntf: dev-change-ntf)
> [53]	23: basic redirect rx-sg (ntf: dev-del-ntf)
> [54]	23: basic redirect rx-sg (ntf: dev-del-ntf)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/net/ynl/samples/.gitignore |   1 +
>  tools/net/ynl/samples/Makefile   |  28 ++++++++
>  tools/net/ynl/samples/netdev.c   | 108 +++++++++++++++++++++++++++++++
>  3 files changed, 137 insertions(+)
>  create mode 100644 tools/net/ynl/samples/.gitignore
>  create mode 100644 tools/net/ynl/samples/Makefile
>  create mode 100644 tools/net/ynl/samples/netdev.c
> 
> diff --git a/tools/net/ynl/samples/.gitignore b/tools/net/ynl/samples/.gitignore
> new file mode 100644
> index 000000000000..7b1f5179cb54
> --- /dev/null
> +++ b/tools/net/ynl/samples/.gitignore
> @@ -0,0 +1 @@
> +netdev
> diff --git a/tools/net/ynl/samples/Makefile b/tools/net/ynl/samples/Makefile
> new file mode 100644
> index 000000000000..54eb5e3b9ab4
> --- /dev/null
> +++ b/tools/net/ynl/samples/Makefile
> @@ -0,0 +1,28 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +CC=gcc
> +CFLAGS=-std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
> +	-I../lib/ -I../generated/

Should new userspace code also use gnu11?

> +ifeq ("$(DEBUG)","1")
> +  CFLAGS += -g -fsanitize=address -fsanitize=leak -static-libasan
> +endif
> +
> +LDLIBS=-lmnl ../lib/ynl.a ../generated/protos.a
> +
> +SRCS=$(wildcard *.c)
> +BINS=$(patsubst %.c,%,${SRCS})
> +
> +include $(wildcard *.d)
> +
> +all: $(BINS)
> +
> +$(BINS): ../lib/ynl.a ../generated/protos.a
> +
> +clean:
> +	rm -f *.o *.d *~
> +
> +hardclean: clean
> +	rm -f $(BINS)
> +
> +.PHONY: all clean
> +.DEFAULT_GOAL=all

