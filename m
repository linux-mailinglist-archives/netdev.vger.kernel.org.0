Return-Path: <netdev+bounces-977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E85B6FBAB3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 00:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2986C280D77
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40524125B7;
	Mon,  8 May 2023 22:01:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32177847B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 22:01:49 +0000 (UTC)
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F93F1BCE;
	Mon,  8 May 2023 15:01:47 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6a5f765d595so3335035a34.0;
        Mon, 08 May 2023 15:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683583307; x=1686175307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dss+wCN5CLASAMMxLWP2S+XJ2l+zFkt1Pl/DL2YpH2Q=;
        b=YVtY6ML8v/alSFXTnKPXgfjkjky1M0tJWUuoG5oBsWCe7MU9C0hOnVB4+VAggoc1XS
         l6dcjMkabiOaoFRPkdFqcTAnh2hAaIy4lT3G6+yURyVuHdluufjI9mnOGskXPKjyeIiC
         LUoFtNJYV69fkVPqSPM3ifKrzVOLzcU0/gNO/13nTudPW10jgLVdp8ogrHDAsD52OFRD
         0h4mBa9SQqNnsO6uRyCeDUfNnCHUWIV+g9dTG4hZNTV+tijICNpdowMVcJuHj0Ypocs8
         w0eU1M22DSAfUe2FJr7F0MDJQw43tt/cnT2hDC01jkeSdyBse7I0IfsXOvDQT5yO+LiV
         HGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683583307; x=1686175307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dss+wCN5CLASAMMxLWP2S+XJ2l+zFkt1Pl/DL2YpH2Q=;
        b=NibsEKbmTCjHvy0o9wUnM1Ec4QdS/A15mNKRnpYJgkIV57CxciO0O+7Xutj9GHQfOZ
         OKL3HleCfGxqEmgagKAYQ3m1p+NTpl0j/ZJLN5vqEtC5gmLGt4AgAzjQ0uDivh1dkIsi
         UPjLNoVaVPKDrHnn7GBRM194vMKfh70cj2PltvNka5M5rz0pKiL4llvTUhQLhFF6PnR/
         csEfFHEPnOUgZlbtrUH+gv05Vix2HqEK8XuPOwdu4FaCUt2cyFSyf1aq+SyueNZfWsr4
         o6Nd21AttN7tlntXj6tY69r+GSzwCRcmnphNaDYatIS8F6KGlSQaRWPDh9l/ksBcUjrc
         bXHQ==
X-Gm-Message-State: AC+VfDz8PhuexPhxjWUISNqWeE275y95kIeefTJ0LyrGaLkXrloJCFxT
	PUaoFkp7KYi9quIHB57nyg==
X-Google-Smtp-Source: ACHHUZ5RplRkTAVpl/PBZcQr0LaBoOeAs3QovtnYSaMM1eXj5XJzITEC8wnovgoyogFAe5Ct6uK0Rw==
X-Received: by 2002:a9d:6b17:0:b0:6a3:4e22:2bd with SMTP id g23-20020a9d6b17000000b006a34e2202bdmr358386otp.5.1683583306768;
        Mon, 08 May 2023 15:01:46 -0700 (PDT)
Received: from C02FL77VMD6R ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id e18-20020a9d5612000000b006a1287ccce6sm4557825oti.31.2023.05.08.15.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 15:01:46 -0700 (PDT)
Date: Mon, 8 May 2023 15:01:43 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZFlxRyy2nXXxEI7a@C02FL77VMD6R>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <2cef1199-98ae-32c1-0e5f-06c69a0eb843@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cef1199-98ae-32c1-0e5f-06c69a0eb843@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:12:24AM -0300, Pedro Tammela wrote:
> Thanks for chasing this!
> 
> Tested-by: Pedro Tammela <pctammela@mojatatu.com>

Thanks for testing, Pedro!

Thanks,
Peilin Ye


