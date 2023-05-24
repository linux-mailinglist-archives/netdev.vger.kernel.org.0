Return-Path: <netdev+bounces-4877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1A670EF24
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EFBB280DB0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B12F79D7;
	Wed, 24 May 2023 07:14:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E63FDB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:14:18 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A7E5D;
	Wed, 24 May 2023 00:14:15 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f588bc322so77666266b.1;
        Wed, 24 May 2023 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684912454; x=1687504454;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kuAIxpXL4/0BkCLB6AyWXNxzDdBtIS58SgwKdLcszIs=;
        b=qhN7DL/nTM7B3Y2grlry4MxZ9kGdjf9d7WujjJWGT4g8JetC83W5WsDN8xrkaVJMmK
         Wozn2j6bwc57957c3vOZPE+GDPOmga2vOnGPxvJAkWViSN5DaymlyuOTawPgL2aR+4Xm
         3bK4TTN1ZvatDhZ8y+NtnfbP568bH7GrQDriZQfKpngH0jGMKC6/QeK9QOlEx3ZHkDak
         jtIVl6yWh8HyEcEgmHznEAX+E8JxFoV7GF/QZNtjOkn3X58MpYGlhTu2utdxiLexYckr
         u+eswVQu8enDs92xJydi7QuJVbh2bO7+r/YwmA1qeTn8sIAI30Dcny7ZES3y7bDgpriw
         FUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684912454; x=1687504454;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuAIxpXL4/0BkCLB6AyWXNxzDdBtIS58SgwKdLcszIs=;
        b=jhhqW9tpZILN+ofi57OGrXI8qTCcNVvVpR9RHhbPK9WvRxmy3K9LoFCe83kYEm8xk2
         toC6/Ae3nIbLegt81uJwN81EQDl7INsYlbARU4qyPlS8EYQdgjtOShPg1UeEQ94JhZV7
         w0hLuttJC8F7WKfZTr4Nu2C/F7fOi2SETIB99XNKYR2ud69HBlFRPNJR7liKcHRlLZNY
         secO66In6tijrx1GMpT4tbFuuSV5Scdc66LrjKYgAFBd1SDGzbxd4qt+Fj6gYdNYtayd
         ueB+IA4XR0P3JGBWtbyiINq+Pj6ae4mM9fV1yRJuhIlmLrugDWAblUmGIDWTADkhjLyH
         J6uQ==
X-Gm-Message-State: AC+VfDzq4qaQxJ46eQCYyT7e5FGNRKnIkmBR3sYN8Jt1VSotUYKenXVa
	YMmAJnTCJmYTg0eOl7vRtvsogkjN6hk=
X-Google-Smtp-Source: ACHHUZ5HURxPxCarGVav6S5Ds04Z+aGlWkqQhWxwsnaJW3NVPAxsr+/j+lZ0KdxbocnSR51k4cfGvw==
X-Received: by 2002:a17:907:a0c9:b0:961:be96:b0e7 with SMTP id hw9-20020a170907a0c900b00961be96b0e7mr16441563ejc.48.1684912453798;
        Wed, 24 May 2023 00:14:13 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f26-20020a1709064dda00b0094f67ea6598sm5380259ejw.193.2023.05.24.00.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 00:14:13 -0700 (PDT)
Date: Wed, 24 May 2023 08:14:11 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
	corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: netdev: document the existence of the mail bot
Message-ID: <ZG25QxZ3hP5JCuqx@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
	corbet@lwn.net, linux-doc@vger.kernel.org
References: <20230522230903.1853151-1-kuba@kernel.org>
 <043df418-28f0-49e5-bff0-2ea511148bb6@lunn.ch>
 <20230522190515.2793193f@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190515.2793193f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:05:15PM -0700, Jakub Kicinski wrote:
> On Tue, 23 May 2023 03:46:46 +0200 Andrew Lunn wrote:
> > > +Instead of delegating patchwork permissions netdev uses a simple mail
> > > +bot which looks for special commands/lines within the emails sent to
> > > +the mailing list. For example to mark a series as Changes Requested
> > > +one needs to send the following line anywhere in the email thread::
> > > +
> > > +  pw-bot: changes-requested  
> > 
> > ...
> > 
> > > +  https://patchwork.hopto.org/pw-bot.html  
> > 
> > [Evil grin]
> > So your patch did not trigger the bot. Lets see if my reply does?
> > [/Evil grin]
> 
> Commands must be on separate lines, with no extra white space.
> I wonder if that proves the documentation is insufficient :)

I did wonder if the space before pw-bot was mandatory as well,
but apparently not.
Good improvement, thanks for documenting this.

Martin

