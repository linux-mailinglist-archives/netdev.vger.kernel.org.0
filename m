Return-Path: <netdev+bounces-5487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F37CD711A11
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 00:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B00B21C20F4E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D35261C4;
	Thu, 25 May 2023 22:14:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADA524EAF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:14:27 +0000 (UTC)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96481187;
	Thu, 25 May 2023 15:14:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5346d150972so56247a12.3;
        Thu, 25 May 2023 15:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685052865; x=1687644865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRzQd1qe5MLh2bSwZ+H/kpZLAtMFe/TSXHLZ9t8ww2M=;
        b=Q8r8MfQY2OxdCoyzFZ36ZEDhZZfb9BTR2d/DkpIbCc10YqNN96Wtre+EEsKgjV8jC0
         Pl0m7QnKUPMZ4R3/xMus05bqhnSEZUCT3URn4mfF8cmougzOjPIXzE22mWLfAjKtygry
         D27NWVTiU0X5G3R59q35z/mv6ACGTxvewMiPf7+ajjRkxGR4CUrPsvz1qg5fb7xEb5us
         pVvn8Cym5JxaSxcae9nlSiNijCixhHtM+WLRH6zwBBK4uGqBjQ46u5lG0uURyXCNalHS
         rU+2Mk6J8KH6VQLuYgcJQs6aXvzD/XhH2Zo1o/7v9WS/XWD8/dhbhmFZrcb+i117nA6y
         zUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685052865; x=1687644865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRzQd1qe5MLh2bSwZ+H/kpZLAtMFe/TSXHLZ9t8ww2M=;
        b=M2EFyAJ54NteM10UBFGplewuOKbxxVDLdo6+uHn2KEzRMcwPuZRSyJt/bzzD/11lSK
         FQ8g69JIx8VGFcRBcdZ9weIBEh9P5sarr1K1yMS9QvW/jEccwEfAfKegkB0niOLGNjcg
         WiIugnNruB0IO5W9tze4pOJYhKz6SYYamcVaaTDYhIQL3eiKNANO6LLRmqvvkMGtkKST
         nqqIMLy7hSNWsggstOPsUT9dkoysrK4m9+4qP26ufGPPzfvmaDtBPYpUuHgDrwPi9l0U
         bW42F/OdBLlITUEsVvyN5QmXNOx3zASEdEIC4oCIv9jFC+K+ToHMihQASkfoiSpOm1U7
         Om4A==
X-Gm-Message-State: AC+VfDw8DJE+7O+S/Cxa3Y8R0UfnsLRtSNYDJTzXuiFCNwMvnibIg0aO
	G1LPcgdNfY72c4nk5f85Mok=
X-Google-Smtp-Source: ACHHUZ6H+U5iEflYehbZr2S7MipIQ5wIfWZiCHwyOQ+yoF3ncxQdN58J3VQy7fQINr++Ou2zete+KA==
X-Received: by 2002:a17:902:ecd2:b0:1ac:5717:fd5 with SMTP id a18-20020a170902ecd200b001ac57170fd5mr78312plh.60.1685052864859;
        Thu, 25 May 2023 15:14:24 -0700 (PDT)
Received: from localhost ([2600:380:b551:e8fe:da52:61ec:2b97:ae7f])
        by smtp.gmail.com with ESMTPSA id 20-20020a170902ee5400b001a64a2b790fsm1864616plo.164.2023.05.25.15.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 15:14:24 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 25 May 2023 12:14:22 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Manivannan Sadhasivam <mani@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/13] net: qrtr: Use alloc_ordered_workqueue() to create
 ordered workqueues
Message-ID: <ZG_dvveucD8T9nwO@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-10-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509015032.3768622-10-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 03:50:28PM -1000, Tejun Heo wrote:
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Manivannan Sadhasivam <mani@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-arm-msm@vger.kernel.org
> Cc: netdev@vger.kernel.org

Hey, I'm going to apply this to wq/for-6.5-cleanup-ordered. As it's an
identity conversion, it shouldn't break anything. Please holler if you have
any concerns.

Thanks.

-- 
tejun

