Return-Path: <netdev+bounces-8159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DFF9722EF0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3280C2813E3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C44200D9;
	Mon,  5 Jun 2023 18:49:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EB820EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:49:22 +0000 (UTC)
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A31CEC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:49:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-258aad18260so3138206a91.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 11:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685990961; x=1688582961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNURCuU/TWWUgFkJWwd0cU4ntQ+v6FuRzvr7x2M2668=;
        b=WWCMF+ZN/EZwmSDeJDz7U3PJdwNFDqnto0fOUPM8NixIfPZa6v6OMWmuBOee2fjr+b
         pfhxi0dbVOO4fo7+GeP3wnvoLhdvivLpk4ybXLRG/l0Rr/erw1Ynn1ug6xRElVemvRQq
         34YO+qpeXxHG1HdAJRTHFc3mnfnI0g3ftLDCN1HeuDlXq+I77s6QA9XiBmjZp5i5rmP8
         a4g+Fob7p+TWDEiVlZLtKGfTlK8i34a4wuS6Ctw9vEZvvLDdzsu3Y/Ye9g7xqd/t/erw
         kOE/rSaQmGIa01beneYltpT9+qrk7BMrAb3Eq+veUalFo6I8MaVKW+XL3+ROsMNruL+Y
         T/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685990961; x=1688582961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNURCuU/TWWUgFkJWwd0cU4ntQ+v6FuRzvr7x2M2668=;
        b=Cmm1CO1g509I9HauGhi8Hjjwqxiq06B45I6TYYi2bBDP6mgl7MDtu53hBvzeBO/GW0
         XNH5BVIGVSBRygtZwg0N06DOAsm/oNeq3v/Wb8P1TKo90gP3yRY0mwOLCHlzAkQBQef+
         qGmrrRknLlkPov23dbitvCrsul5PQ/lkCpJmDRx2A24Q3GbDEvZV7/BPpcD0arvKOFEv
         CDBvR13QGtOyb0UWuBNVT5w1zdy10GKpTZtaCro5jqAKMLtb5gYO6INZVBDQdGTeSMw6
         E/mZhAUn0Og3reUrJQxCnjJ9XMbB8+5jYhcpy4djP1UdbpERj3FYZadEDWG5o9br/tfN
         FIgg==
X-Gm-Message-State: AC+VfDyrEbm2ihx+FFy3yOUaO4JrZCpj+QF3ZbqsAuikwFP/N+6KtHSs
	PvBGS5GU2zbwNuxnrg7t2Xd5kmg=
X-Google-Smtp-Source: ACHHUZ4DtnoIWWTbbxSe1HfJbbCA3aWt8Yib5w3jF0VucYFuTH5Nt2h0nA91F6AUwv2S+17ndaXgEXA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:1181:b0:256:ce20:93fb with SMTP id
 gk1-20020a17090b118100b00256ce2093fbmr1825978pjb.1.1685990961015; Mon, 05 Jun
 2023 11:49:21 -0700 (PDT)
Date: Mon, 5 Jun 2023 11:49:19 -0700
In-Reply-To: <ZH4gW5WIzMZe4oF5@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230604175843.662084-1-kuba@kernel.org> <20230604175843.662084-3-kuba@kernel.org>
 <ZH4gW5WIzMZe4oF5@google.com>
Message-ID: <ZH4uL2cnQwPpEztO@google.com>
Subject: Re: [PATCH net-next v2 2/4] tools: ynl: user space helpers
From: Stanislav Fomichev <sdf@google.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/05, Stanislav Fomichev wrote:
> On 06/04, Jakub Kicinski wrote:
> > Add "fixed" part of the user space Netlink Spec-based library.
> > This will get linked with the protocol implementations to form
> > a full API.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > v2: fix up kdoc
> > ---
> >  .../userspace-api/netlink/intro-specs.rst     |  79 ++
> >  tools/net/ynl/Makefile                        |  19 +
> >  tools/net/ynl/generated/Makefile              |  45 +
> >  tools/net/ynl/lib/Makefile                    |  28 +
> >  tools/net/ynl/lib/ynl.c                       | 901 ++++++++++++++++++
> >  tools/net/ynl/lib/ynl.h                       | 237 +++++
> >  tools/net/ynl/ynl-regen.sh                    |   2 +-
> >  7 files changed, 1310 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/net/ynl/Makefile
> >  create mode 100644 tools/net/ynl/generated/Makefile
> >  create mode 100644 tools/net/ynl/lib/Makefile
> >  create mode 100644 tools/net/ynl/lib/ynl.c
> >  create mode 100644 tools/net/ynl/lib/ynl.h
> > 
> > diff --git a/Documentation/userspace-api/netlink/intro-specs.rst b/Documentation/userspace-api/netlink/intro-specs.rst
> > index a3b847eafff7..bada89699455 100644
> > --- a/Documentation/userspace-api/netlink/intro-specs.rst
> > +++ b/Documentation/userspace-api/netlink/intro-specs.rst
> > @@ -78,3 +78,82 @@ to see other examples.
> >  The code generation itself is performed by ``tools/net/ynl/ynl-gen-c.py``
> >  but it takes a few arguments so calling it directly for each file
> >  quickly becomes tedious.
> > +
> > +YNL lib
> > +=======
> > +
> > +``tools/net/ynl/lib/`` contains an implementation of a C library
> > +(based on libmnl) which integrates with code generated by
> > +``tools/net/ynl/ynl-gen-c.py`` to create easy to use netlink wrappers.
> > +
> > +YNL basics
> > +----------
> > +
> > +The YNL library consists of two parts - the generic code (functions
> > +prefix by ``ynl_``) and per-family auto-generated code (prefixed
> > +with the name of the family).
> > +
> > +To create a YNL socket call ynl_sock_create() passing the family
> > +struct (family structs are exported by the auto-generated code).
> > +ynl_sock_destroy() closes the socket.
> > +
> > +YNL requests
> > +------------
> > +
> > +Steps for issuing YNL requests are best explained on an example.
> > +All the functions and types in this example come from the auto-generated
> > +code (for the netdev family in this case):
> > +
> > +.. code-block:: c
> > +
> > +   // 0. Request and response pointers
> > +   struct netdev_dev_get_req *req;
> > +   struct netdev_dev_get_rsp *d;
> > +
> > +   // 1. Allocate a request
> > +   req = netdev_dev_get_req_alloc();
> > +   // 2. Set request parameters (as needed)
> > +   netdev_dev_get_req_set_ifindex(req, ifindex);
> > +
> > +   // 3. Issues the request
> > +   d = netdev_dev_get(ys, req);
> > +   // 4. Free the request arguments
> > +   netdev_dev_get_req_free(req);
> > +   // 5. Error check (the return value from step 3)
> > +   if (!d) {
> > +	// 6. Print the YNL-generated error
> > +	fprintf(stderr, "YNL: %s\n", ys->err.msg);
> > +        return -1;
> > +   }
> > +
> > +   // ... do stuff with the response @d
> > +
> > +   // 7. Free response
> > +   netdev_dev_get_rsp_free(d);
> 
> General API question: do we have to have all those alloc/free calls?
> Why not have the following instead?
> 
> 	struct netdev_dev_get_req req;
> 	struct netdev_dev_get_rsp rsp;
> 	
> 	netdev_dev_get_req_set_ifindex(&req, ifindex);
> 	netdev_dev_get(ys, &req, &rsp);
> 
> You seem to be doing malloc(*rsp) anyway in netdev_dev_get, so
> why not push that choice (heap/stack) on the users?
> 
> (haven't looked too closely at the series, so maybe a stupid question)

Answering to myself: netdev_dev_get_rsp is a simple case. With more
involved responses, we might have variable data and pointers to
different sub-chunks. So having netdev_dev_get-like getters do the
allocations seems like a sensible option..

