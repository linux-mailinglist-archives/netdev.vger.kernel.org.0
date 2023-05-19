Return-Path: <netdev+bounces-3775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1731708CF8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69D11C211BF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 00:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D81364;
	Fri, 19 May 2023 00:37:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E1362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:37:02 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673EE5A;
	Thu, 18 May 2023 17:36:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae4be0b1f3so20041025ad.0;
        Thu, 18 May 2023 17:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456617; x=1687048617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJgSzGtgikyMjdsd1BSJ/7i+WEAYOWc3x+UR966c4LU=;
        b=Y+UAGCe7cLK92GhY6jl+kEGjDFxbxZ/KfX3qZTCxudL6DxuVvRm4s5XSZ1vXJuR7B2
         Yqt3GULH3mZ2NY7RNidCre5jRZnpnxFj/+pqGKeBMdZZiTaLSHtZFnCzTC2T7ndZialz
         FAL0AbL18+a2/1x7DKzmm2fWDfjaDaQBmWVCqAL7cLwIyayVcS9Nu5q4bMJAeE2F6oib
         bLVpZCHmRxxJW/25zA3k3uvDRfJ0Z2WBzGvLY4Mo4XsvqQJP1AEtvYVvzaW7E4b/OR6d
         RvNVq9cZDbQ09G+Hx6jeMbou0HzpE1i93tKWvQSp/2Lyl4clrJnDwv2zOKtQgUrbnOtD
         sANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456617; x=1687048617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJgSzGtgikyMjdsd1BSJ/7i+WEAYOWc3x+UR966c4LU=;
        b=iwNRtLoLPYTJjiWQT5mq6IwD4o15z4xWvmhbfmO6QMTMnuBY6svVtzd21D30K+lbdY
         VfDtH1Q5FN+DW45kkfhsamz9EdsbK2ED26hc0dr14cuQGWkc+1LwUvlsbwxo4W7Sditd
         BWn2ZuB+330/o4nbd8f6A+pSYSkh9zhulb23xXYkKJvZTVX8KBWOJZGkS9FnUiYYKPIs
         G/ZebW1cm7Txb2goFDzeFZznvrSQS40R45iatqdpgmMmoL2p0tLv60VjkXkzL7oAj+Fm
         Hv4IKZjRAlAa0qsCnyS7qQZHu2024VyjDd2C0+Vm+WC94Jo4mOkWDK6JxQBMZR2oVGA4
         fz4A==
X-Gm-Message-State: AC+VfDxZlXTHuFNCYtg/Vjs81XsnJ7yHS+aY9L8ror2KijiWt2VS+Wkg
	FmMCo+deSW17XFSAHCHf0UIfgSdIa8M=
X-Google-Smtp-Source: ACHHUZ4+/TArAWN3BndzVZerlnFGVtVemG6aevDvPcQBvkAKGW8/QfS9QeeM+QywIFyBmBcjpcL5EA==
X-Received: by 2002:a17:902:7448:b0:1a6:dd9a:62c5 with SMTP id e8-20020a170902744800b001a6dd9a62c5mr964259plt.10.1684456617383;
        Thu, 18 May 2023 17:36:57 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902b28200b001ac7c6fd12asm2066109plr.104.2023.05.18.17.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 17:36:56 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 18 May 2023 14:36:55 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Amitkumar Karwar <amitkarwar@gmail.com>,
	Ganapathi Bhat <ganapathi017@gmail.com>,
	Sharvari Harisangam <sharvari.harisangam@nxp.com>,
	Xinming Hu <huxinming820@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 02/13] wifi: mwifiex: Use default @max_active for
 workqueues
Message-ID: <ZGbEp3CTOgg8HxlV@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-3-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509015032.3768622-3-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 03:50:21PM -1000, Tejun Heo wrote:
> These workqueues only host a single work item and thus doen't need explicit
> concurrency limit. Let's use the default @max_active. This doesn't cost
> anything and clearly expresses that @max_active doesn't matter.

Applied to wq/for-6.5-cleanup-ordered.

Thanks.

-- 
tejun

