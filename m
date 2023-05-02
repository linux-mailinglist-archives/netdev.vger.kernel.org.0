Return-Path: <netdev+bounces-22-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD3B66F4BE1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73946280CA4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631B4A92B;
	Tue,  2 May 2023 21:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E47491
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:08:54 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D24210F9
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 14:08:49 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-61b5de68cd5so10279146d6.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 14:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683061728; x=1685653728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tiBWOshlUl2g37P6au0QunGTm8Ovn60MBgwCXOe6Rfg=;
        b=Pf3K+TnNrE+q+vtdlDwzyPQqrMknvy/9J5K0occ8kLdCAJRf144AlJGUq5zJ2OIEDZ
         ZdKnuMdyi5sWRgFnbzZBq5I4yPEbBSZ2/uRNr91G5SbUG2Q5l0RsQVJlbuKX+VZPKXok
         2d1t+nEzymAEbS0P1kVKK7ez8CZAhZf7rJZ9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683061728; x=1685653728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiBWOshlUl2g37P6au0QunGTm8Ovn60MBgwCXOe6Rfg=;
        b=cqwfccgFxWTlWuJeqqaZsLqUzVq1s1jTc6iGgbluIt2rGs51VF+P7GETPt+8OTOZj0
         SLvBpSiYvEmhmZdx+CC0+fTRmxB+re+djMiq58lQUY91hnAQCMcGDCLfJ4KJyekWMAKI
         DofePYPwFPJN7U8VT8MBQ+let7KYuLTvF7ArUAlXdiEGo1Sewrxu8iZs4MZUHyjeXLCN
         S2pzL3GLYdFTj2sckRtthxYBF7aGmufu1/SZac5lkU4eVMC7h/shf6WleIY3f8+Dtw82
         YYABLLqaQkI5G39VVdp2ku8YtLHtDobTnueI7aFKCoChycj5b7Fu1GkakyjTAtWogqxa
         uqZw==
X-Gm-Message-State: AC+VfDzdn+IYmfNOHAdYzwX30O7Ac+WBJ+wmobr/dJS5vw475JRsKB06
	VukB5WB0BT4MMPrG+OIB40MTgWNrPRprWZsV8eU=
X-Google-Smtp-Source: ACHHUZ6hwUiI5TFy6po8SUvqRBvdOkR9aiCZ09BjEv4BJdlsgEvxw+y0A/ceTvau9v3ePDOKtxCdqQ==
X-Received: by 2002:ad4:5cae:0:b0:5ed:ddf0:7c2d with SMTP id q14-20020ad45cae000000b005edddf07c2dmr7012313qvh.25.1683061728693;
        Tue, 02 May 2023 14:08:48 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-132.dsl.bell.ca. [209.226.106.132])
        by smtp.gmail.com with ESMTPSA id z2-20020a0c8f02000000b005ef524ea9f1sm9759400qvd.141.2023.05.02.14.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 14:08:48 -0700 (PDT)
Date: Tue, 2 May 2023 17:08:46 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org, 
	John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [ANN] Mailing list migration - Tue, May 2nd
Message-ID: <20230502-greeter-swiftness-facc2c@meerkat>
References: <20230425140614.7cfe3854@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230425140614.7cfe3854@kernel.org>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 25, 2023 at 02:06:14PM -0700, Jakub Kicinski wrote:
> Hi all!
> 
> We are planning to perform a migration of email distribution for 
> the netdev@vger mailing list on Tue, May 2nd (4PM EDT / 1PM PDT).

Hi, all:

This should be the final message to test archive propagation. The move has
been complete -- if you notice that something isn't working right or not
looking right, or not archiving right, please alert me.

Everything regarding the list should work exactly as before, just the
Received: headers will be a bit different.

Best regards,
Konstantin

