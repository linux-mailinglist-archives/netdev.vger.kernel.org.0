Return-Path: <netdev+bounces-5130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E9570FBFB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2B2328134E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158F719525;
	Wed, 24 May 2023 16:53:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4AD19517
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:53:07 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EE6FC
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:53:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6044a4cf1so2377845e9.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684947183; x=1687539183;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=budghZXlYdYqbnwlSq2PNlgb8OG5roBx3+eMs6r5TnU=;
        b=ZZaxuIn1hW3VG5MbfxYXOsCyUTByN/BYq3KzLbtpE+gzxXdu5HrQA9wZ6/V8VU1w1l
         YWx+JUzaeZRjAyK5EU84hmHaN6tV81ue3QWtCdHJ/uDN3oBBpK3c73uWEpDsUKk3WuPN
         683NFdo4ed7kzmll7smvyFW3zhnCOR1eENW1zVQZi1Pnye9bl3Hc23TAJNqTLTyXBC78
         2hnehKbsYS5oSQYI/e9FSy/cJHHZCYOM4uaRQDA5WZwyk79QjeN46vhJZGpJscbziqv1
         sunsv7tTVLJoc+D6sPtKiPM6VmejtsdPs0w2OIwpbG6Yx8FgWhc09ZCmmWElrwgHX972
         qhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684947183; x=1687539183;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=budghZXlYdYqbnwlSq2PNlgb8OG5roBx3+eMs6r5TnU=;
        b=jKt/GH2RzSP9NPTZnZq5rz1eKe1kfA5XmOciGHtHSUNWaSKFcncMY7ZUvWdpq9g7id
         2U9lQPxAtdC/zXNrU5UMkgM8s8zRsxzkERPqr1l7f6Hcwz1JgPcJwqxLFSNn0AK1E7uK
         uhE4wtEx0aY1MlXl8uL5t2quQLvDxRkAAZo2q1LJkn2T2MhxvHu4dE318WFNGunYaUt8
         FIZ79WzLF0+oHFWPJwX+cVPGqSzJPIYMHos31cJw8mnMF6oCMWDzyfg8ufQIRYk7pH56
         gtiUXbiPFdpdIcHzA8c2Dffg88/JUKaZRUNCZqMMRkYmPsjl7ImUhBOvZVRbImI492UM
         J55w==
X-Gm-Message-State: AC+VfDx/Be7tpWacvEYO0m5/AlyXrPvh8SBxnMShgwB34jsoE8zM6R2Y
	E9QYET4zWWDEJVpxAm0VmeNUCZdHBODVUhoBNpI=
X-Google-Smtp-Source: ACHHUZ6aismf/8QfL7hrrVW0Ekpxifko+YR7buql/8+nxd02td4vJb9NDQWgDBES0sFtRu6kMR339kvmORyJfZrC0DI=
X-Received: by 2002:a05:600c:1caa:b0:3f6:44d:3d15 with SMTP id
 k42-20020a05600c1caa00b003f6044d3d15mr8279786wms.3.1684947183202; Wed, 24 May
 2023 09:53:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a05:6020:1436:b0:284:6b35:2ac9 with HTTP; Wed, 24 May 2023
 09:53:02 -0700 (PDT)
From: MUTIARA LAZUARDIN <filemutiara1@gmail.com>
Date: Wed, 24 May 2023 16:53:02 +0000
Message-ID: <CAD-_+Yaw5zs+ehAtURoBLijiYw=gnyh9-W6PrzthQcm9RLq=bg@mail.gmail.com>
Subject: facixbooka@yahoo.com
To: Facix Booka <facixbooka@yahoo.com>, netdev <netdev@vger.kernel.org>, 
	Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,BODY_SINGLE_URI,
	BODY_SINGLE_WORD,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,
	RCVD_IN_DNSWL_NONE,SCC_BODY_SINGLE_WORD,SCC_BODY_URI_ONLY,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE,
	URIBL_SBL_A autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

https://1drv.ms/b/s!AuUNcVCn1NCOcmjSw2lD8ux2mB0

