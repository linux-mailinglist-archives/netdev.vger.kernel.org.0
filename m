Return-Path: <netdev+bounces-1446-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C97146FDCBE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91DE52810C9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3508C1B;
	Wed, 10 May 2023 11:33:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945D46AB3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:33:59 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61689E7E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:33:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so102045e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718437; x=1686310437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8TqPijoG+MxohAqkzIioM/CR4vn+XT8c956xT8vIV8=;
        b=z3X65/BCK6jObOZd2f9RgPL34mRbF6vEzvB4ucUFUXDGGiSrZ0EFl54DMRFKhEy5Lo
         zstiZ9PvGLyXm895IOZpK43f+v7RbMDhe7dQBHXP2MdBC9O7kwfTwkypRzNcO42kby84
         fcml3wvbdvWqCvm/raQ+Da/H2qmEbpCA2YOcR+ow7zd3xVNEgpw7K3amtKEhGHf0CjaF
         VmUomiedARBCDaRzhAZ6ZiWLL0BIdUE6ZvHCNJGz/2p2GeMJ/1lM3ZQqGmaLQCvpQphx
         WrUDI7ewMcPFITwv5QLM6K8nWw9R/eTh5AZ9+cpvs1zC7516p3TndjVctqDsiKbTiuou
         +t3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718437; x=1686310437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8TqPijoG+MxohAqkzIioM/CR4vn+XT8c956xT8vIV8=;
        b=EP6p50GyNL3s6OcilKp8jkdNtbgebBmvKVixXzy+/UZu2cx7hcWXQiGlwQ8UumD6jJ
         eFf342TPaLH7MBIly8qEi1lsDuEI/ZI/DG7BFH7Lu+IJJbqozyCtvcDcS0SgvBnLBpDd
         4S5fpXOt8kNra9GIYfQXjf9IeAOrpIRdHyCjjnMHz/dX+QyRkRRBBkZrG0U8D7EHp0wv
         jaYBnMyYIyhHzC8yPph0UdAGfABekBA/CpO8zSqCJQv7acNkVnxwJZhurcJgQxb3W+jg
         Lue+W3w/Xms/hWswg0yJIQD6dEF79TG0/QnOFViZqmlFCEisSzd+A4bQ7UX+MyhmIHBS
         k+3Q==
X-Gm-Message-State: AC+VfDyUTRLse4GrSOPydUKEXgbOxeV/u5TzZkGu/PZBavnqmN2EirzW
	FW/uKgc83/VsB419RYmbZ0nJVovJtkpq1VLmal1hqw==
X-Google-Smtp-Source: ACHHUZ7e6FuFayljQRBjhJpZhtPDfHra0YWReDbnMngwiVh2zLIKUYI23Qbmcmi+yF5KsA+qkWSNyR9kixqc10xe+H4=
X-Received: by 2002:a05:600c:3d98:b0:3f1:9396:6fbf with SMTP id
 bi24-20020a05600c3d9800b003f193966fbfmr178740wmb.4.1683718436749; Wed, 10 May
 2023 04:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk> <E1pwgrG-001XDm-VF@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwgrG-001XDm-VF@rmk-PC.armlinux.org.uk>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:33:45 +0200
Message-ID: <CANn89iLn4Q_Uw69zDPVCgQtcpUQH0Obaw1BQ9xFvRc60J=rmsQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: mvneta: fix transmit path dma-unmapping
 on error
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
> The transmit code assumes that the transmit descriptors that are used
> begin with the first descriptor in the ring, but this may not be the
> case. Fix this by providing a new function that dma-unmaps a range of
> numbered descriptor entries, and use that to do the unmapping.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

