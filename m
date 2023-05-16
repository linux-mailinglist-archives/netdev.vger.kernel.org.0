Return-Path: <netdev+bounces-3091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 339AD705697
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8E01C20BAB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F53129101;
	Tue, 16 May 2023 19:01:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C2E24E9D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:01:51 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFF083D8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:01:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ae4be0b1f3so208455ad.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684263696; x=1686855696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kUkmmpx1M4MtXHMNNv8IRyExX8PTEgvpMh/addFkD4o=;
        b=YTcgXElpvGt3LVfiNgl5PSEl/rBXxtslgzs1wn0AulV9NHy7s3dRPgUgymNAKMd4u5
         dobM79MDBBTmVDF8lrKoENPSGJIbzl032aZ+Ie0w8hNTx80kVCt54FdiVcZ6LR+4YxjA
         L6PuoiBV9Q/FJUVAooL5QT+66KDs7lg3YwX/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684263696; x=1686855696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUkmmpx1M4MtXHMNNv8IRyExX8PTEgvpMh/addFkD4o=;
        b=FZPIo/kUsqgJCwXvrCJPLOk8ROINcSjoKjQvsoyn5JtAOcZUlJrALEeBl8uCjPi1U3
         Am4FSnTmRh//WQDkjkd49NFiP+Ma1eV151lNhhZjV2CxWihuWAJjk3BBcVDbjW6gOFRJ
         r+toMuTDgHAmmpBzylSzIATZ8wKc2y+O/5vAcXhUCiZgRFKAly1tq6T5s6Ps3EnxgKyt
         SzkPUy/DB+rADMSSzC/UabdXX6exNR6RiOLm5dmHfZjBKJ9bC+Ksx/8XNIRJg3p1S3WV
         WEYrdZ4TGhRO+FCxUNu8ApKBy5x+N8EgEQ7qS/lMVYWpKdC9+jha3xirPc3EcYYjTGOz
         W+5Q==
X-Gm-Message-State: AC+VfDxvZ9C7FvMcoJCu4rdVXtYLuy2yF8H4ZllAycRRKSgQ2oKrMwyy
	t/PJzU+TCy68QOfQdLdhbAOPlw==
X-Google-Smtp-Source: ACHHUZ5ZLD7j3APDOySoMJHuE3aU18Lrbi+vh403ZC/xZCJwhn9YLHMEtvqEWZXDOHofmDlW+yYTpA==
X-Received: by 2002:a17:903:2452:b0:1ad:bc86:851 with SMTP id l18-20020a170903245200b001adbc860851mr29197280pls.45.1684263695791;
        Tue, 16 May 2023 12:01:35 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902728f00b001a69c1c78e7sm15783248pll.71.2023.05.16.12.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 12:01:35 -0700 (PDT)
Date: Tue, 16 May 2023 12:01:34 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iavf: Replace one-element array with
 flexible-array member
Message-ID: <202305161201.4AF77552@keescook>
References: <ZGLR3H1OTgJfOdFP@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGLR3H1OTgJfOdFP@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 06:44:12PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct iavf_qvlist_info, and refactor the rest of the code,
> accordingly.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/289
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

