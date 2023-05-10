Return-Path: <netdev+bounces-1451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6C56FDCE7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 443281C20D47
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37367F9D9;
	Wed, 10 May 2023 11:38:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B520612B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:38:43 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A64F30FE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:38:31 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso110955e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718710; x=1686310710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uo1yKORMYSO1OUKpuL8y50tHhI1Yxp7i2VNwQyY/Tg4=;
        b=lJ0oHEz0aNAmCXMLl1SLoPLJT/sASTXHTbfoF4mYr7qFftFBXC7upQ1dpOQ2Qr34it
         PkWnOgBTdiEHXWpkMr5s7ndvdQ+vgohuhTGReRBJEfjoK3pPU8hHPzzomWu5H/F+qHOr
         vVhEB/WJA+kpnTKTbcTLtzNQsKn6FKbqzY4ClhB+hOU6+tSbOD51OKKTw6BTjNgqKCYn
         Kwj3ogigHOai8gVJJowjJ+XoR0VzBIB0oQWfJfG9rcvA+Qzc1LAFu/ncHxRnv07EypQx
         jRFMXeEB61A0pxlaMpxVe3SuWat4nl6Mh+IE2BpXPl5/I93rgZm1OF0yJG/c0A2tyMwL
         Ai1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718710; x=1686310710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uo1yKORMYSO1OUKpuL8y50tHhI1Yxp7i2VNwQyY/Tg4=;
        b=A7qXdgQRjGl8xyvRmTHBh0eSoJZPURNL3BkQ9Ma+1Ksahg8p/oD/VSEziT1WddFcZn
         WxUgN8OL6SfpaL9B3OI5zXjHLtosyisY66yBvv9wkUJHXHX2fe0V4HYtMoZI8Ok1GKWQ
         e4XAnL+ZEn4xTXLV5PHWdpxTUbD7YD4ZaZj8qBTKG98XrafSEEfQpBYI/CItVAukX4Os
         rw7wXGHy8iKtMWyR+m6EXPF4FvrJOI5AMSAbHyH8LtMhhQZ+AMXpbvQWBgwvNLaBxHRN
         VqSbmzrsJ3u7VeiICKg4+lADA4B9eOf5OtILsiSxj/N15jk7bHILxiQLQuKjhj4RGsgb
         OG8w==
X-Gm-Message-State: AC+VfDwakJ9I0bGKl+3zvvY2L8LOq5jaFkWQ1SLzo8mKg1sOmMFPpgJ3
	+0VkBZtBx0HhpmewJ64Xl1i9vusqou77A5JjM4QnWg==
X-Google-Smtp-Source: ACHHUZ6lXCn0ZxxsLzAPzdBDl/9Ppa9vPTUSW9LdX20Uc+3NhNoDnfa8QhZoT56BBUCvLOvlMuHtv/ZCk1S/LLxj7cc=
X-Received: by 2002:a05:600c:500f:b0:3f4:2736:b5eb with SMTP id
 n15-20020a05600c500f00b003f42736b5ebmr128643wmr.1.1683718709590; Wed, 10 May
 2023 04:38:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk> <E1pwgrb-001XEA-HB@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwgrb-001XEA-HB@rmk-PC.armlinux.org.uk>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:38:17 +0200
Message-ID: <CANn89iKrhFWgbqxDU2RY62PmCrhfV+OpvGUAy9uDCJ8KGw9qZw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: mvneta: allocate TSO header DMA memory
 in chunks
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

On Wed, May 10, 2023 at 12:16=E2=80=AFPM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:
>
> Now that we no longer need to check whether the DMA address is within
> the TSO header DMA memory range for the queue, we can allocate the TSO
> header DMA memory in chunks rather than one contiguous order-6 chunk,
> which can stress the kernel's memory subsystems to allocate.
>
> Instead, use order-1 (8k) allocations, which will result in 32 order-1
> pages containing 32 TSO headers.

I guess there is no IOMMU/SMMU/IOTLB involved on platforms using this drive=
r.

(Otherwise, attempting high-order allocations, then fallback to
low-order allocations
would provide better performance if the high-order allocation at init
time succeeded)

Reviewed-by: Eric Dumazet<edumazet@google.com>

Thanks

