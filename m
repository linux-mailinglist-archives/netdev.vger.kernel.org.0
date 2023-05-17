Return-Path: <netdev+bounces-3142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 197CC705C0D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C86BE281350
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D035817C9;
	Wed, 17 May 2023 00:41:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6517C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:41:16 +0000 (UTC)
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB9EE7D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:41:14 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3940f546923so216759b6e.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684284074; x=1686876074;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NJTQotoBd9r7ATsVLOAVIdDmO+k56uh7UKco4z/s+Zw=;
        b=JgMFu7GwhhPIsagW6TFgb+S/ZTzqE67vg6Ei2Zi7c9F8PZFFFyIpeJ37/3+8OJ8y4R
         0nmoocb7A8upVZllDJsTSv3uLukAl/Ne0ARIST8YhWW2bGneOevp7tyYPqOSiiF0insE
         jtFCCAAXLnTrQJVtbbNStq+Pz5E4mEeQv93Kjdzzky43WmIJHl29QeJdVxPt8HCBofKy
         pnX2Wcj8TWCWrj2njaMHG+ih48VEvGHor/4c1lUYIoP02Lp++hvI2Qk22SyR31UMzl7j
         98/i4TJRj74zryhQXz/YtLoBqsiTgTeAEQwJGo44pjAVKhZU8S3PUMKO3c/ilQnBOsNf
         dSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684284074; x=1686876074;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJTQotoBd9r7ATsVLOAVIdDmO+k56uh7UKco4z/s+Zw=;
        b=XHlNS/TInv+0FDBJ9gRrt/CQRhXxy6UHCCmuvjEQ7Uv+nES6etphJhuNTZkP6L9U6L
         J27/A9PzDZnLCVOV+7/i3eGGxAZXX6aiZFqQaMCHBrFVa6LPEmZwTYIeqiexrfIF5Mr4
         GMlbABp/k+l9SUGCDzHJ1Qwlu/yQ7dxIigv3MeysLSiZ+P/FSh1sZn+Wx3v4hWp2bezb
         WqK1dYbch+UJdHaLDt5Z0kKjLg75XJHTcJRhGfydNJMj8AZgIgFWstTsAV/K7W2sz8+W
         tAkgaaqGb0XiIff+i6WmVqvc2W0WfslewwjLKCfFTmOomwrL77YD6ztp32vgZ7CW94EG
         8zbA==
X-Gm-Message-State: AC+VfDxNFSFhtaGqATF2DfHbZ9W8/BKy0TN9igjGcYro3kXOIw4tze2d
	PtZkf0ZObwWwjo02WJNFiOnXBlPAVEPSPPEbHLAZL02+o6C12w==
X-Google-Smtp-Source: ACHHUZ7AwLVMbBF73fsGDRCU8tqdjJB55B+PJMJcDyLhtN7IuFhuPGHIfX+GuQN7Y7hfv/47wHGHTX0ojkmjpESYj9Y=
X-Received: by 2002:a05:6808:1a16:b0:396:3b9d:7ee0 with SMTP id
 bk22-20020a0568081a1600b003963b9d7ee0mr470462oib.41.1684284074194; Tue, 16
 May 2023 17:41:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a05:6839:f88:b0:727:b26a:20ef with HTTP; Tue, 16 May 2023
 17:41:13 -0700 (PDT)
From: omnia abdallah <omnya.abdallah16@gmail.com>
Date: Wed, 17 May 2023 03:41:13 +0300
Message-ID: <CANbu=LD0VqfZuy9APsbTdhGMWg2z28gc463EpLcMtFjAXfGufg@mail.gmail.com>
Subject: facixbooka@yahoo.com
To: Facix Booka <facixbooka@yahoo.com>, netdev <netdev@vger.kernel.org>, 
	Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.5 required=5.0 tests=BAYES_40,BODY_SINGLE_URI,
	BODY_SINGLE_WORD,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,
	RCVD_IN_DNSWL_NONE,SCC_BODY_SINGLE_WORD,SHORT_SHORTNER,SPF_HELO_NONE,
	SPF_PASS,TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

https://bit.ly/3W2jt4W

