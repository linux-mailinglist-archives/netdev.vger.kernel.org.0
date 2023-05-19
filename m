Return-Path: <netdev+bounces-3914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 893E9709861
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72D151C2121A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20B0DDC1;
	Fri, 19 May 2023 13:34:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F307C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:34:21 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE36BB
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96f850b32caso6049466b.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684503258; x=1687095258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kX9wOsWYWdx6AFsBhQqja3MimQHPnJbJexoUCu/sBHs=;
        b=UGFO5mCKtqZrWZqj5tgVgh1VVxKc4XldzxhGvLCOWkYGPRoKOjzD0kqy11pZJBElY/
         T/AAdPTcAdI5iWrWlUXmksHxlK986jmEKkV9ybWAuu9ychmWyLMhaxloOvXUL9zYrqo6
         gshrJ/2p4pUiVWY10eoPXbWvdR0+t0xUoOLoN6TQQ0+3v70iRu6jCoGZEhGbeWPNBp8s
         chWp/4WlIgr14ZaKClw8Vvke2CGXvZKJ8J0EZhWjs2DYMX2BUfsIVWHH9Cgkrd+c1UhY
         wBZYtAu/UjEj7k0XlkIEm+XeKLrakuUPX8ux5nEWlbyPlWn2Fs+eGg877so5q5JF+v/J
         +fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684503258; x=1687095258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kX9wOsWYWdx6AFsBhQqja3MimQHPnJbJexoUCu/sBHs=;
        b=WjFvTiiAR6sHgbaZ9tM/cY2D+wYSburuZ8GQ3qEMW97w9cqiWr6eXeLX+fEOXtU0Qb
         bPgRLWc+zuijhXgX0gpU1I84miguP8TbNU0qPKixY0S01F9Ax/JHi/zdTdFUJKU8wQ2o
         3m+J6UYpiaXAmhADZPKFNcSWKU3GFLV95JdG7R3eMVDhojN0lsGauD4IleWYquvdPv6l
         7D2dpXLpGfQDj0i7AllfFwiGk7Xr7yoc6rJ6xi38jJEm+TG4yZo+GPrSWs9QkFF7StK4
         1IDCJMcqo+IWfa4x2GIB98GdCtvk0USWIwAAYk3h08FZmDTqpPPBx00Pjy96g4TeguBj
         4ZKA==
X-Gm-Message-State: AC+VfDxNFFosr5xCwZrSt3cswHzq21MCXQbx57T4243tj3kYx/FXUJ9Y
	Ptiu0X/7mIc+8Cp6ubAx3ycl2DyxLrU=
X-Google-Smtp-Source: ACHHUZ4fKEMI5fVqSQnqX3auy6BaOmsBHVJelTVZ2jXxGLKNGwqPjgp1NqrWlXhShau8TvYhFvtMKQ==
X-Received: by 2002:a17:906:a143:b0:960:f1a6:6a12 with SMTP id bu3-20020a170906a14300b00960f1a66a12mr1607961ejb.55.1684503257978;
        Fri, 19 May 2023 06:34:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a04d])
        by smtp.gmail.com with ESMTPSA id l7-20020a170906938700b00947ed087a2csm2279270ejx.154.2023.05.19.06.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:34:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 0/2] TCP splice improvements
Date: Fri, 19 May 2023 14:33:03 +0100
Message-Id: <cover.1684501922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The main part is in Patch 1, which optimises locking for successful
blocking TCP splice read, following with a clean up in Patch 2.

Pavel Begunkov (2):
  net/tcp: optimise locking for blocking splice
  net/tcp: optimise non error splice paths

 net/ipv4/tcp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.40.0


