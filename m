Return-Path: <netdev+bounces-641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D911E6F8C8F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1480428110A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F99D52C;
	Fri,  5 May 2023 22:52:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E1C8DF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 22:52:24 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505855FCE;
	Fri,  5 May 2023 15:52:23 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-528cdc9576cso1604817a12.0;
        Fri, 05 May 2023 15:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683327143; x=1685919143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5W7ONEaecFCyy7lrplAP+3KFnzflWj5NN/RehO1dv4=;
        b=VBhfDcqR+GseQEA9QUC5uoW//EJhnr7AiRARG6B4tKlyE1YOk9SSLjiHvf3wjpW3x1
         +GWBh+/53EHzuJoLEeu81uOEuVN6BhwgZNwVLW8jlXdmb4TDsD439QR+SV7erzNNzkxU
         XVSNqyc9oNokV86HUUOKaC1gNuS+PfpkkWMslL4HTIwqNg/aW2k5LE/17qx781d2i6qc
         2ytdO9L4aa1iQBHCGx5iU56sxXg2xA1AE23+2LFcDZ3RBNfpQqJNDNKQsrP4AL4Oqzdb
         eCdbNbhWv9T718BBsodZXMdbImyBuOXqb49bnWlYUBXyjLUkGPnZWU6ZMH948pce7or2
         YRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683327143; x=1685919143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5W7ONEaecFCyy7lrplAP+3KFnzflWj5NN/RehO1dv4=;
        b=EwWH5ibyp2FGCLzZ0Ajiv9evhEzoml5J/cjxgljFCvAcsAHhnPSpd/Y06JjDIAuxQQ
         xvx5QoXReg2FUge/XOa7Ly0iVpCa8VtBfwHWo7c7YP/jvSZM8b7blUoE+omsmRIs6fvn
         STUuBEyHNDfDOGNx/M0B70SqsWQN29Xgjhs9Z+ri5EAE5DKC2iKUEY2jeRAOeAP3kxz2
         Byszb3SxfgmVrYXugnsRTgr6AXjUfu0wqb/dJY8Hlao8TgS5rRsFY6Zjp3hKIxUW1Way
         wAne9Qk8kfB0ySfjMXbVOcfXwCmDssTMUIGtjre1omwuq9wehLzNnLjD0tXB70C5lmuB
         wkkg==
X-Gm-Message-State: AC+VfDzvjdK42FKiX3NY+P6IRX4i0VGhj02QUX8aKbi62ViyBHfhjKTV
	kRh0GCqSHL/gkzPr9cdh018=
X-Google-Smtp-Source: ACHHUZ51M1KF2vfaJz++Zbjp83+hLK2P6j8fzQBli4ttuv1kNVJR9OeS+q8nt90FiO6Nm1oBowYCow==
X-Received: by 2002:a17:902:bb87:b0:19e:dc0e:1269 with SMTP id m7-20020a170902bb8700b0019edc0e1269mr2631305pls.7.1683327142499;
        Fri, 05 May 2023 15:52:22 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b001a9b7584824sm2296739plb.159.2023.05.05.15.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 15:52:22 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 5 May 2023 12:52:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Mordechay Goodstein <mordechay.goodstein@intel.com>,
	"Haim, Dreyfuss" <haim.dreyfuss@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wifi: iwlwifi: Use default @max_active for
 trans_pcie->rba.alloc_wq
Message-ID: <ZFWIpN7HN431MVSI@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-10-tj@kernel.org>
 <fffb3e6ad76a26a9633728501b5d606864235e65.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fffb3e6ad76a26a9633728501b5d606864235e65.camel@sipsolutions.net>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

trans_pcie->rba.alloc_wq only hosts a single work item and thus doesn't need
explicit concurrency limit. Let's use the default @max_active. This doesn't
cost anything and clearly expresses that @max_active doesn't matter.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Avraham Stern <avraham.stern@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mordechay Goodstein <mordechay.goodstein@intel.com>
Cc: "Haim, Dreyfuss" <haim.dreyfuss@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
Hello,

Johannes, do you mind acking this patch instead?

Thanks.

 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3577,7 +3577,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 	init_waitqueue_head(&trans_pcie->imr_waitq);
 
 	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
-						   WQ_HIGHPRI | WQ_UNBOUND, 1);
+						   WQ_HIGHPRI | WQ_UNBOUND, 0);
 	if (!trans_pcie->rba.alloc_wq) {
 		ret = -ENOMEM;
 		goto out_free_trans;

