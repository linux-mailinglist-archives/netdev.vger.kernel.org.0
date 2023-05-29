Return-Path: <netdev+bounces-6135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB73714DD0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A33681C20A8E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CE9947D;
	Mon, 29 May 2023 16:05:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EDF8C0A
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:05:30 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA55CF;
	Mon, 29 May 2023 09:05:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-307d20548adso2049720f8f.0;
        Mon, 29 May 2023 09:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376326; x=1687968326;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqrT0cgKL+eTI7AtEwKrhJSvMNAsrRxJWGcKWQXPBu4=;
        b=Xtj7nSZ0bL//BEkT1R694cRnA9+YVFieofBZxbqEJ6pF8ciKn9Ufl0ch2xvdhd//Ne
         b5ameEn0fKzufZURbWkv/F5px1k0dw1R6KPmMY1j0iIP9/kdUgBDJznRNiOnzpivbI76
         SbZT0y2RDnXKEXFEwQBsE2PRQuR4jw2DsLAeRyMO+P/GzC/yabbJQhNR8RRiJUNaiRJX
         TlEGa8/6ZuR1vEh830TkmT9xO6Fh7VtRtGMAVe+9wMYzWA8msno1yCopzcRPdQVaKgdA
         gKdjoacEeLZ/bOVjMDTG5IqSbb3DmVgNnwE+dQ+P1yi0HgFDtF3Duu1PtsJtNdgtKpKP
         4V7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376326; x=1687968326;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OqrT0cgKL+eTI7AtEwKrhJSvMNAsrRxJWGcKWQXPBu4=;
        b=VXO8W33XLaDkUREGkwFY3D/cEfJARGoEANU0CeQSEsNkLyFJrmF1qjUgFv+Gwk/5EG
         sCgBwaFyREf33w0oAmvdHf4jR9QE9Nk/+XHexg7qbuou8w1PY7FdUBG06sjslcNECy3p
         UufWd6vQoWd3s1uZxXL04pf2Hx3WrFeWJIvspetU2TI/noaVsiGAv/+DiqItnSIQRnIr
         xbBg7X39CTr+2IHL8STcHf3d89AXZvy3inKiWzjYcXQnaJDCw8UcY64urfAAcAOUKjHD
         iy1RkzMW3MpPfCNLqD+ZnSsoiiV+nhWYkMcMTF1m40DDZoMRZJAJf+ZYqTZRqJjbl9Z+
         Fy/g==
X-Gm-Message-State: AC+VfDydM/rWHyqdzWw/L3WtshTY+eRUa21V0if7SIwMKiUJ/cr5Xp6u
	6hh6J0j38fe9ndySj+ogwp8=
X-Google-Smtp-Source: ACHHUZ7Y+LuDO8HzlcOFDZhOFL2uoyTVcayo/LvNPltDiNTggzVfz07qzj8HhudtbzflVWZyd1AiaQ==
X-Received: by 2002:adf:de03:0:b0:309:32d1:59d3 with SMTP id b3-20020adfde03000000b0030932d159d3mr9199340wrm.48.1685376325951;
        Mon, 29 May 2023 09:05:25 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b003062ad45243sm408368wrw.14.2023.05.29.09.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:05:25 -0700 (PDT)
Date: Mon, 29 May 2023 18:05:10 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, richardbgobert@gmail.com,
	alexanderduyck@fb.com, linyunsheng@huawei.com, lucien.xin@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] gro: decrease size of CB
Message-ID: <20230529160503.GA3884@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch frees up space in the GRO CB, which is currently at its maximum
size. This patch was submitted and reviewed previously in a patch series,
but is now reposted as a standalone patch, as suggested by Paolo.
(https://lore.kernel.org/netdev/889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com/)

Richard Gobert (1):
  gro: decrease size of CB

 include/net/gro.h | 26 ++++++++++++++++----------
 net/core/gro.c    | 18 +++++++++++-------
 2 files changed, 27 insertions(+), 17 deletions(-)

-- 
2.36.1


