Return-Path: <netdev+bounces-8457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D47B724270
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 074F52816C0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4129137B69;
	Tue,  6 Jun 2023 12:41:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AA37B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:41:17 +0000 (UTC)
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4EA10CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:41:11 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-786e783a748so1776097241.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686055271; x=1688647271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=co4FTYHPRmPgfq+WYmL6L5BwOgeNdocViTBwXo5MnM0=;
        b=lwL66P3Nom/zAMnDg+XJZWeO7/zZ2xmBBcxUolhP3A6AaLhCY38V6C6YwpX0zIDHc+
         h1GqTWBReQ/ZBhRGnGZRSg477taNPwQCU3Z17bZMWZLucqtjrgVMhDs6/twzkFdgArDi
         /E1U7VdVe3EDSjzP4M8N3QvkG5hK4IZ99aQW9/LXRUiGxo+kZwtWu/LFHbLw8y8uxSYn
         DfMgocetDtl/95K1SD1pcxAPZ+7aD3O1glWN4cjgdp+V8oMkGeqawm6SZRX5RYaL4SnL
         ATkOijyigSi72gZf5CtCmtR879x4gcpRxAwC/EsMxDWfC/ucP/WKuAJSn/WM7W5dazoo
         abaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686055271; x=1688647271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=co4FTYHPRmPgfq+WYmL6L5BwOgeNdocViTBwXo5MnM0=;
        b=fv6eZd4R6CvC/+i+dTN4bjdr2TpNyNkNEsC1vtvQGt+fuY5jqB7IRuYyktYWfFb/Ev
         PFVQTRZmrNRred+bDJ9Te1J8GnOMfd01KVmQ7ztxSstD3beMvy5XD0rxOSY9or4QJOCR
         4/SJBYSqiqUi6h5oySf5fdKNpdBLx2GFxU2IZCyx0W1LBrEH8LVoe60VXGvOS8B8Xnok
         jUZft808J3MqYYe8fL1U5AinH0iSKkv0F/M335rF1H6vohhwvI0ZCKYQwMDwxTSsFPWR
         3WlCFWuRa0pHS/xbUkYUfzUojBycLLEBDL92EMTF0FCsrzhhoLsIa3PMpGPuhYaKR6Ai
         +t9w==
X-Gm-Message-State: AC+VfDyTIoxKhaL2y5zVZHEi56Sz1S+V2XJJ/xUB3xfBdaS2aidbFGAk
	k2xihoWaNvFZ67nepkXGxpJ+rw5pdmVaPge8Bx8=
X-Google-Smtp-Source: ACHHUZ5Od8PHN4N96/gs+0PZFH6QPMKfYyFhRgelwBRcRZJKGSIHMcIAGmDrJHJvE81tjAEC7dLKqzQ5aOHnIIoMbLs=
X-Received: by 2002:a05:6102:3a78:b0:43b:4d39:2087 with SMTP id
 bf24-20020a0561023a7800b0043b4d392087mr1079996vsb.8.1686055270733; Tue, 06
 Jun 2023 05:41:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605190108.809439-1-kuba@kernel.org> <20230605190108.809439-3-kuba@kernel.org>
In-Reply-To: <20230605190108.809439-3-kuba@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 6 Jun 2023 14:40:33 +0200
Message-ID: <CAF=yD-LYHnUt9ePiJx+WS14b0cBGGQS2iHAKVNTzFKf2ws8NYw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] tools: ynl: user space helpers
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 9:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Add "fixed" part of the user space Netlink Spec-based library.
> This will get linked with the protocol implementations to form
> a full API.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Willem de Bruijn <willemb@google.com>

(not super familiar with the code, but with that caveat all lgtm)

