Return-Path: <netdev+bounces-5486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76222711A04
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 00:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D8F91C20EEF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAB924EBA;
	Thu, 25 May 2023 22:11:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D892FC16
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:11:17 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E815189;
	Thu, 25 May 2023 15:11:16 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d5f65a2f7so203955b3a.1;
        Thu, 25 May 2023 15:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685052676; x=1687644676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yyd5rz2tE9zPbV9ihgy7U5ezfqMC2agklna65nJbyhQ=;
        b=ZbIZV3UYlkyNfkRh4RtwaeNh3aaC22/jDi4SqOdFXFFrGPy+UIi+N14lXEdmGphfFa
         /Jd1KcV+lUkCv87ML0fkFsFIJNlwluy/ctSzQvFhHFTt/s/t3YZegTc6UanHTTI9Q7zf
         dPpK6aVpVynaDZJIjkrgWqxd5Odi2kj5Aw2B1XoSyTc64lIwxGw8izXv1xsd7iOux1ZP
         SdvKpt2mydEhlHnXXLDujLvcbExbNEMmP4YYmogQUcMUDldfrL/2tiYdfj3QJUlYBrAS
         YlTwgzmuI5fYZjwDLGAYdE6fKW2tcHZU/Vu/PAwUV6LnUOSQ5LY8M4nOUZyXreKp8696
         E1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685052676; x=1687644676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yyd5rz2tE9zPbV9ihgy7U5ezfqMC2agklna65nJbyhQ=;
        b=QxksmA43PTe03q6lTc6QgWbD+X14IY2Vp2LcmqO0A4kU7UOg/BntyDn1J2KKggdieS
         PZ/fS0s4uXd1k6AwZf2TYZZaFn3zHMiAjJJ3vEQrAa69huLkve3ei9SIFweJD5qOFNVu
         YEsD3KX2PiOoAkuL5V86izdmn7YOFCGomEbA/9wJ5oVJVi9onR0bpR99GJJSCSKTf2QO
         aqliavcl1jiw4CuZiLsmL0lIACGvMuV1uTm/LK5n481InQ66gGwanENrwGQEzWwXcUOH
         6f23rrDkEBkm5HEsYXPCL0t4CcbBbAA0MsWCs6ufSHrFARiV78vgHhXA0Lqe3PVwKHWy
         Jy5w==
X-Gm-Message-State: AC+VfDztdt6d8Z3v0p+xOL5o7SBeB3XNzjkb34DOsnC+RHTx7EjkVW3k
	pniTga35wzL9LvDjm/yhrF4=
X-Google-Smtp-Source: ACHHUZ5b/of4MhnAuCbbieJ8arImN2FEB7c9/dk3StciyXMr0tkg3bdMG1VOFDaS3mLYtQ5E9iwCyg==
X-Received: by 2002:a05:6a00:10c3:b0:63d:47ab:65ed with SMTP id d3-20020a056a0010c300b0063d47ab65edmr357057pfu.7.1685052675691;
        Thu, 25 May 2023 15:11:15 -0700 (PDT)
Received: from localhost ([2600:380:b551:e8fe:da52:61ec:2b97:ae7f])
        by smtp.gmail.com with ESMTPSA id j12-20020aa78dcc000000b0064928cb5f03sm1601746pfr.69.2023.05.25.15.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 15:11:15 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 25 May 2023 12:11:13 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Intel Corporation <linuxwwan@intel.com>,
	Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
	Liu Haijun <haijun.liu@mediatek.com>,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	Ricardo Martinez <ricardo.martinez@linux.intel.com>,
	Loic Poulain <loic.poulain@linaro.org>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 06/13] net: wwan: t7xx: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <ZG_dATVe7LvLX_oZ@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-7-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509015032.3768622-7-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 03:50:25PM -1000, Tejun Heo wrote:
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Cc: Intel Corporation <linuxwwan@intel.com>
> Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
> Cc: Liu Haijun <haijun.liu@mediatek.com>
> Cc: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Cc: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Cc: Loic Poulain <loic.poulain@linaro.org>
> Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org

Hey, I'm going to apply this to wq/for-6.5-cleanup-ordered. As it's an
identity conversion, it shouldn't break anything. Please holler if you have
any concerns.

Thanks.

-- 
tejun

