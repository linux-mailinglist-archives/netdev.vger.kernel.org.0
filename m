Return-Path: <netdev+bounces-3951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF818709C34
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DE642818A3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8259711C81;
	Fri, 19 May 2023 16:14:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700425679
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:14:49 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B29F1987
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:14:18 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f435658d23so33382755e9.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684512856; x=1687104856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLNmNbMfOEFya0NXiVqmdM46U5iwXVuWu3Bo5/6qSKs=;
        b=W6emMQZp60IJdrYM9nYVdezN30gej+RqqqI6uAn6l8ZbDIXi1cmKAHSxNW6EdpnnOB
         iCqto7vNMb2L8BjOd/FjPKnu9Tn5ieiVYyukoK0HQQSleL4nq0yLr779PZFMVvSlF1Ah
         GA4BTgtLticao7X/V1H9KyB16edBeUeb/Xj7EkeDvkto9LSqW7kYbphcvxoq/QWKjBXa
         S5WQioPgay8yIhWiGXOWTaVquahxUgFOQfUHX99V/onAaS2gvD6InA32ArKGxdnHKlQl
         moAetMYZJzIxUykNBeTQt5g175HuoDl6M6RKK6esiaoClM1SIimg7eTwprITu5Y6sW8H
         TXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684512856; x=1687104856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLNmNbMfOEFya0NXiVqmdM46U5iwXVuWu3Bo5/6qSKs=;
        b=V4cE3RbkJ5IvF7HBMfJqO7VcOKxy/Hjrcpp8w0dQCBg4VN4sFGrplNUwvSjkFcsnej
         WUO0BL4LBhi7Yb44X3jl+IOUbcrm30hy1iJqbBZ9nMjUfy29zCFbiVc3lepgyNx3tf6U
         cZymFeBo/k2vyxRxDJOujIGMDp7Jg83m2q6niNtxt9t2PFqPDliMSPWIpQLYEWMoZuGl
         tCYfSoQ/Y6sQpBB0F8FhrFGc0Uzc1mTmgdZo93oS24YFTX1lhaahmRTr/WUyCHFeJvbu
         LQHXc5UNfIIbHpBPcUZP77sw7Xfbe/PvJUyi3VN55zOQgxcRjxRwNnVRdO+D0gxHpj0d
         1xqg==
X-Gm-Message-State: AC+VfDzgIRU590tMokVZoOEIW9G9HV1jWBxakoUF5VSPfRuxCFhtQyo3
	UGHHs01k40X2qxEPL2UspC+C3g==
X-Google-Smtp-Source: ACHHUZ6+kr+rk2ikjTPVoGRtPwEq2a5sxFt99083Jfvx4xtTxEv8fbxTifXP/vvWbNUAwCPyP195Zg==
X-Received: by 2002:a05:600c:2057:b0:3f4:27ff:7d52 with SMTP id p23-20020a05600c205700b003f427ff7d52mr1903670wmg.2.1684512856381;
        Fri, 19 May 2023 09:14:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g17-20020a7bc4d1000000b003f423a04016sm2848205wmk.18.2023.05.19.09.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 09:14:14 -0700 (PDT)
Date: Fri, 19 May 2023 19:14:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux-Next Mailing List <linux-next@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"frederic@kernel.org" <frederic@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Jakub Kacinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Netdev <netdev@vger.kernel.org>
Subject: Re: next: qemu-arm64: kernel BUG at fs/inode.c:1763!
Message-ID: <5d48dd9a-1822-4917-a77e-193a48ed3bd8@kili.mountain>
References: <CA+G9fYszs5wPp+TWJeVZsdRjnBTXTa8i3YY3qV9SHbB1+R2+4Q@mail.gmail.com>
 <20680bb5-71c0-4945-a058-05f43bbd03f4@kili.mountain>
 <CA+G9fYvY8HZ=F0hQueeX2x2RvP-fJgrDF_7y-Q_yhpVE_8Y9Xg@mail.gmail.com>
 <3C4B5AC6-275E-4176-BD1A-AB1FBD319C5B@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C4B5AC6-275E-4176-BD1A-AB1FBD319C5B@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Btw, Smatch doesn't like that file at all...

	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
        ^^^^                         ^^^^

sock_alloc_file() calls release_sock() on error but the left hand
side of the assignment dereferences "sock".  This isn't the bug and I
didn't report this earlier because there is an assert that it doesn't
fail.

net/handshake/handshake-test.c:221 handshake_req_submit_test4() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:233 handshake_req_submit_test4() warn: 'req' was already freed.
net/handshake/handshake-test.c:254 handshake_req_submit_test5() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:290 handshake_req_submit_test6() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:321 handshake_req_cancel_test1() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:355 handshake_req_cancel_test2() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:367 handshake_req_cancel_test2() warn: 'req' was already freed.
net/handshake/handshake-test.c:395 handshake_req_cancel_test3() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:407 handshake_req_cancel_test3() warn: 'req' was already freed.
net/handshake/handshake-test.c:451 handshake_req_destroy_test1() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:463 handshake_req_destroy_test1() warn: 'req' was already freed.

regards,
dan carpenter


