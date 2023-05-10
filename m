Return-Path: <netdev+bounces-1449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1AD56FDCC7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7B041C20D17
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F44D8F4A;
	Wed, 10 May 2023 11:34:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810753D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:34:55 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B0270E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso110745e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718490; x=1686310490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3aUD05zq5IOuNz2PSpQomKUtP5Ez/x3nFmGe3EknZw=;
        b=I94sYZ4QuwCXiyIeFG3Is6UvmxVe8uh5DWvaqDTugGGJfE9LbYxm6UHGiAK1Y14TgQ
         N2VyeVry5wlJI1IA2KqtkpscNThQgWPNFAYEOHNnUQpxerlXbaP/O9lTdgVbSdl9Tz6S
         B4FAELpMwGa1lbzHYQrCykm0ps+/RHR0DFpKBsZBB5wvjwZeNm8PzCHq/mNGN4yqj9Tk
         BKY5At/+iiIk5r9X1nnGe3EMsnlnsnGFRmYUHUH0HWqmZuqxvzcdwWZCKyuDB3w4ZZFJ
         ZtDyulnx3jChg7Vv6Sg0lBk/ufKYFSgr9SDaqBxcWO/tiWN7wyJY7+GZXhYPjl2F8Rdr
         gVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718490; x=1686310490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3aUD05zq5IOuNz2PSpQomKUtP5Ez/x3nFmGe3EknZw=;
        b=LA+tLjXwch+qIvOMriIHqwjJVuceMYUEg89GEWuE3O/3tQbINJgGhrs2l5M1HxDBax
         ggjnebr/27U4Avgpk55L7ErrxoTZMxPxb6WkCK+JbzpjU485yq+Rn4LU/sa4PbhrhtPM
         5EB+paKqSEfVLvDVR0O3Qi15OZ5lsNZLc9Jvwglr+G+ZfMSC6UbNipGWz5E/rqq7FETE
         kDKJoAZcODakvuvATThtP0igzhGdd/l6Os0eNqwF+1v1BDQ4fzQqKne8hn9THN3v57sF
         z7QRqDEMXF82t7gunhyPXTRRMl8W5p3gCpNaAiJRE9aLRvZBdhqwmX0eNqdc+YU33OS7
         HKtw==
X-Gm-Message-State: AC+VfDxXilbtosuXqUCJZiDVXGyo5cz9eLaHA3QmvLtLGbI3+//wPXdB
	hnkwfU5n7bQweAWHg+kEjoMgQazkyHxsBtV1/d9ivA==
X-Google-Smtp-Source: ACHHUZ4bIRDp7Ft1phuwdOyrD19WIGTNU/FaUu0w/c8XguKUBkYria6MyEf9kSarGlftJAO909AFmBWJ0IOsAlnXgl0=
X-Received: by 2002:a05:600c:4f42:b0:3f4:2594:118a with SMTP id
 m2-20020a05600c4f4200b003f42594118amr180653wmq.2.1683718490356; Wed, 10 May
 2023 04:34:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk> <E1pwgrW-001XE4-DB@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwgrW-001XE4-DB@rmk-PC.armlinux.org.uk>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:34:38 +0200
Message-ID: <CANn89iL4OWrhoTM8h-=UAz_UrCk1M64rJ2w02GEF91Swr_7khg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: mvneta: move tso_build_hdr() into mvneta_tso_put_hdr()
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:15=E2=80=AFPM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:
>
> Move tso_build_hdr() into mvneta_tso_put_hdr() so that all the TSO
> header building code is in one place.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

