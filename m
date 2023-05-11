Return-Path: <netdev+bounces-1741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0DD6FF087
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22957281325
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8A319BB2;
	Thu, 11 May 2023 11:29:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3833D2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:29:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC120659C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683804596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Wcs1wf3Y5KyjaPCBk51DyDTPjlvzj+Pis0kXtdTq9Q=;
	b=TUz/c6t4yliUNOiF4SLjjlET4yMDpybTi230Ds8/Y4b4Fl0qD+1FAoeqPbJ3rzSlcSHI6D
	PZvilG9B0eVytysHJT0/AkG+nQsdX7ZrIaipONIFpdQpEGzp5CCJAgqC4qa0i4d789MrIv
	CdjMziSxtHZ+5BMZNePRHLdWI4dqcE0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-6BICZoZFOFev3v_q2R7gSg-1; Thu, 11 May 2023 07:29:54 -0400
X-MC-Unique: 6BICZoZFOFev3v_q2R7gSg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-61b636b5f90so8169366d6.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683804594; x=1686396594;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Wcs1wf3Y5KyjaPCBk51DyDTPjlvzj+Pis0kXtdTq9Q=;
        b=UjeW5brV9xmfHZlAfwyty4KR/q7eq4foh0Tq8/0HffXqjXjqJ5yqlpBu437YxnQ9jL
         7zwFii4h4VczBNEOBjcYA0B5hquRUbElFb4mf8SJ6Qlpx8DZGeyBX1JJmfQtEV1Vy9GD
         9kDDWILex1vwVOdpgZI4k7lTF8tat7lJeIlQ+aoiEumpDZKa68ey1k8YULrDoUBNvzpF
         L6ZGnbtavHPF3clziIEODdif+V5XVGbjpCzDdyzyUYNCFoHVe9L7dKwrdviSu4JHqhI5
         7475Jlmdy5wraVkA1k4i0Zs4pMN+Ujx7XRX/KTJqMYq9hUObQbW+V3ApDgI5R5F5jFpf
         RUsA==
X-Gm-Message-State: AC+VfDwgPHiBRXaIpJSXMSfcqX48ugp2wHWfe1BVoLJIri0NESe6Sm0r
	sj9OycydX2gBe7bcIKqp8veqGwR1uo7IkmUILyHSl9ONsPB3y/vSPQ+QY5kn0QXhWE/QSWFcAT6
	nCux+AA0tfOq5+s6C
X-Received: by 2002:a05:6214:4118:b0:5ad:cd4b:3765 with SMTP id kc24-20020a056214411800b005adcd4b3765mr28400782qvb.1.1683804593939;
        Thu, 11 May 2023 04:29:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4K9f80xem3Y7ncislBbCo36D3PLyDCvN/Ie4SLMidO11xUItPAXOnC4UEZd/KahsitYGlRNA==
X-Received: by 2002:a05:6214:4118:b0:5ad:cd4b:3765 with SMTP id kc24-20020a056214411800b005adcd4b3765mr28400761qvb.1.1683804593677;
        Thu, 11 May 2023 04:29:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-149.dyn.eolo.it. [146.241.243.149])
        by smtp.gmail.com with ESMTPSA id h7-20020a37de07000000b0074e13ed6ee9sm4510031qkj.132.2023.05.11.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:29:53 -0700 (PDT)
Message-ID: <75dd5f74abe1d168e9bb679d1e47947f4900a1f9.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
From: Paolo Abeni <pabeni@redhat.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>, Andrew Lunn
	 <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, netdev@vger.kernel.org
Date: Thu, 11 May 2023 13:29:50 +0200
In-Reply-To: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-10 at 12:03 +0100, Russell King (Oracle) wrote:
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 71755c66c162..02c777ad18f2 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -568,7 +568,8 @@ void phylink_generic_validate(struct phylink_config *=
config,
>  			      unsigned long *supported,
>  			      struct phylink_link_state *state);
> =20
> -struct phylink *phylink_create(struct phylink_config *, struct fwnode_ha=
ndle *,
> +struct phylink *phylink_create(struct phylink_config *,
> +			       const struct fwnode_handle *,

While touching the above, could you please also add the missing params
name, to keep checkpatch happy and be consistent with the others
arguments?

Thanks!

Paolo


