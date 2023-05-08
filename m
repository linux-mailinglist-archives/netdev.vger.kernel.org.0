Return-Path: <netdev+bounces-986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A0A6FBBB8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 411EA280E61
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E02413AE8;
	Mon,  8 May 2023 23:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305246107
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:59:33 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A676683E2;
	Mon,  8 May 2023 16:59:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ab0c697c84so39335395ad.3;
        Mon, 08 May 2023 16:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683590368; x=1686182368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YJeCVahMakSFFIeHkE0L5vaAYWzeS9qst+vBo++bi0=;
        b=slvl90ejJvhpDMuKfei9ERvwSDS95akB18grdXbOMaqtHTpIsgRO169MWKDhVO+u0N
         MiyytkrGDe1BzBeJ7OsaGMrPjgyvApqwZl182E4cd7ToHBde/EN4EgPrWiqXwu+0HXEd
         V8ZuB1s9z/CNkhLBkjQHAEhEnchbea3wasKUZexsOmyICez64PdUbBdmYzv6WppxNr0p
         KksAAPhqGoJJ8zTwX+be11upEuqmmxAPjF3hqK2fWyMlAjivNzRFKWpSVRDClqdxOAzW
         0RMq5s92qneOYGR8cSwy+fpRwEWtD7XB66ELfIRpZhNuzWL9q4dkg+aKOVhr2jH71IJa
         Igxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683590368; x=1686182368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YJeCVahMakSFFIeHkE0L5vaAYWzeS9qst+vBo++bi0=;
        b=DqkZL0JaenqKxHVMP3AsMgMwbk1lDLu8j3JVZk/dmZdt+AOCbI+C1Ea7PsWbdsEBE5
         7srtfH/5dPbde9VLBJSmQtNcVYfWcHYbRwCIwlH7zjccd7ASCCdjWeW+eJ9PHJzWTbzp
         wb63ggQ2mTBOierybVGKsthNO0DLwayNGjPTsbF3TWkq6/pODcOfiC50m5JkGuEGzTYy
         7j1YU18wbgS9O8R91q7tG934s3wdzHN7mUXCMZeXKkuby5IUVySVwFod6HRMa19gp1Oc
         iX71+AvNn5gnNVkUtwFiRYT0TDfu+qU6Y5v+jJnS/OAE4QF6ITB6VTYM06/MuLHIaaLE
         wWuQ==
X-Gm-Message-State: AC+VfDy/+QSzhWcvXk3KL+nLpBKgG42ezSVu1CCj6KWIR/O5CLH3FZX/
	HkzY06eiYvMa8VsrTojEDiw=
X-Google-Smtp-Source: ACHHUZ7fkJE1M47Pe1lvUaHuLXKJ6X2K8ZXhyVkwcgQruuVvN94s7C2qtyHrBGLLHUGGaS7OcT+A4A==
X-Received: by 2002:a17:902:6b86:b0:1a6:9f85:9437 with SMTP id p6-20020a1709026b8600b001a69f859437mr10384836plk.67.1683590367846;
        Mon, 08 May 2023 16:59:27 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902b40500b001a922d43779sm72451plr.27.2023.05.08.16.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 16:59:27 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 8 May 2023 13:59:26 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Mordechay Goodstein <mordechay.goodstein@intel.com>,
	"Haim, Dreyfuss" <haim.dreyfuss@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/22] wifi: iwlwifi: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <ZFmM3taSTiq7Mv4L@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-10-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421025046.4008499-10-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Applied to wq/for-6.5-cleanup-ordered.

Thanks.

-- 
tejun

