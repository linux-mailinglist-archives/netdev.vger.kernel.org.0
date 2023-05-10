Return-Path: <netdev+bounces-1448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E296FDCC5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472C11C20D47
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDD68F47;
	Wed, 10 May 2023 11:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EF03D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:34:39 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D275173D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so102115e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718475; x=1686310475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KiirlAVwrwMzGSV72BHzl7bx0D8ntoB74WT/RnsQRlE=;
        b=G5TJlkIe4u4AFij/hPDKHW3PHSjfLQPWJfExndo3eJxDdVUs4EyzpWQGa2zWLsS/xA
         NHRgBIbFCV/7l1xRlftMZKNlia8yE14fALhNfz8Bi/9IePxz9T1q4dnXKD7w0YpE80PE
         0vI4Axg//+5sPX2jHc++ubSVt8t7LBgTdUl50Giau5PMbcQZJ79qGRI6ow38BPi1anNt
         7xpfXw1YhOz95seWhtM/ZM9XNOsQKd+KXO6IQc8zHZWkCX3jIDCgUWvX3NK5X4bX921W
         5Q9vgAQky1pz1RIvDhoXaFz5RsTGjPKbxM5Ou4eUsS1sv/F+nkpLSW+8wrT2d9AdUuLr
         G5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718475; x=1686310475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KiirlAVwrwMzGSV72BHzl7bx0D8ntoB74WT/RnsQRlE=;
        b=D4+SgyzLqWUqoXAjHEWngyIwUOjLP1DYba2zg8u19MHoDf+dy8WEs0FSB+MH/3w8LI
         03fu40/joOFy4gx3FEL+8a7ydoD9og3dF4JlUTpouahMWPuplqHPQJbq3rRAx2+fZyX/
         S92/LK3HbSKtAf5UrNg9ufvifxZivj/uPkxjhYuVwZHkxSbAEcdlTCdZP6oqFIJePNla
         HbiHdGltKQcxK9CA4DdWJQbtRYq5BjNDEwQga/3e5VNKv55vQ+CpxBSDfIUTCA5edH/J
         A0ma08Rlklbh1eVqAwxFu/D9LD2anEpoMbBV2LgV+QKwWvbvCHzp3wWgsFzst5Mglm4V
         NPMA==
X-Gm-Message-State: AC+VfDzyhNppkIInmuYCblD2HUZhPtbFHCL4AVli7rN/521cEFCok/wp
	nDh+wxECEl0qy+kfmAYDyQhRLF8gR4VgGVwJtpsH7w==
X-Google-Smtp-Source: ACHHUZ5unIH9hrHNOIWV0MGnbJf4hMplWluJvdwFuHGNSRbeXA0KNBt3WHdL/p8zUdsREC0yuLwe2gAmTkJeRw2kMg0=
X-Received: by 2002:a05:600c:600f:b0:3f1:6fe9:4a98 with SMTP id
 az15-20020a05600c600f00b003f16fe94a98mr127034wmb.5.1683718475019; Wed, 10 May
 2023 04:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk> <E1pwgrR-001XDy-8S@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwgrR-001XDy-8S@rmk-PC.armlinux.org.uk>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:34:23 +0200
Message-ID: <CANn89iKWwFLv3jCVzOVDVy0eT35koZ_iPyAJM-ofiExVVV5cKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: mvneta: use buf->type to determine
 whether to dma-unmap
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
> Now that we use a different buffer type for TSO headers, we can use
> buf->type to determine whether the original buffer was DMA-mapped or
> not. The rules are:
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

