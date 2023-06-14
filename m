Return-Path: <netdev+bounces-10593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C0A72F3F1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F1422812EE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3AE361;
	Wed, 14 Jun 2023 05:06:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96881843
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:06:54 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021579D;
	Tue, 13 Jun 2023 22:06:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6621a7efe18so1464636b3a.1;
        Tue, 13 Jun 2023 22:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686719212; x=1689311212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpzNem3ViuEKPlCURCYzqdRVx4wzaO6WZgBZLhFzTEo=;
        b=qGnOSzTpm3glLNaHVCKnBetHvdWS/l9S7AVtgu2hmpIIpO4+H3pp1EYwbXxJoJoyR5
         z0IvoBkTdKblSgH9uG2xgVvMuxnLmRPdyzj7fM53JtjKPpwFhzTFlqYNEKw0pFYm5SL7
         QMsaz3XLLr1ojdWiKheekIamfzx8ZOCyZnGOeGGKCdTvIZ7pyPuqhd/vQipVdb0LBeDK
         spMvgMcYuWKmrW1HHivr3qLolUOfTiARHEIBw3hU50YthCAC8kqqDmH1XXyLuFW2Y6iO
         CiZHQEpabXIjNhCY9B2clbzbTJXlXGNytMxppBWTTkri4C2ZYOgtcfhAhCEaxwxhCwxj
         +k1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686719212; x=1689311212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpzNem3ViuEKPlCURCYzqdRVx4wzaO6WZgBZLhFzTEo=;
        b=RNF6M5Q2KiCig++RnE+/9akcbEII4IkBI0VNsUt0sgjpevxdtJRCKxJtMI+9JoDg9c
         KmdMowK7GK6LSH3DqCmNl6yExhpslb7U8MnMTJcWCHSovP6uBCUR/AOHNvKszKfLXQBw
         +MgxkJKugQ5gDU5RvOHfiVo59Uew30xK9tAP5UkB1rFGY7qA2zk2yhZjXBsdXbHQsF/z
         +9Sn7/on6tfBvHCMJ01QpEgVDP4mz3JQYHBBxcYkNMOy3TL8nf6pb7ayX7bcjCkac/00
         mY7fyP1U9TbnjIqYfWFubkMzsP/zmQLnSO/ykCOBUxCR8QWz5+1dIfR/2cv+jrEL5C1d
         gNHg==
X-Gm-Message-State: AC+VfDxot8CZS4MVtLwhPX40iu4u9XpUtNFVwEoojWaSC8iqJbWGsStl
	7g4LlUlQ6ightXoM7gSnSSpIuszs8Uk=
X-Google-Smtp-Source: ACHHUZ4wE2BiesNKRgR5hGL3DhftyN0tagYEgGIPFDKkQgPy2X05clSp+AllNOqHvwzr7nQKMoE28g==
X-Received: by 2002:a05:6a20:1442:b0:116:696f:1dd4 with SMTP id a2-20020a056a20144200b00116696f1dd4mr17180626pzi.5.1686719212451;
        Tue, 13 Jun 2023 22:06:52 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z3-20020aa785c3000000b0064fe9862ec2sm9464370pfn.116.2023.06.13.22.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 22:06:52 -0700 (PDT)
Date: Tue, 13 Jun 2023 22:06:49 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/2] net: micrel: Change to receive timestamp
 in the frame for lan8841
Message-ID: <ZIlK6QXuMYWpWkOJ@hoboy.vegasvil.org>
References: <20230613094526.69532-1-horatiu.vultur@microchip.com>
 <20230613094526.69532-2-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613094526.69532-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 11:45:25AM +0200, Horatiu Vultur wrote:
> Doing these changes to start to get the received timestamp in the
> reserved field of the header, will give a great CPU usage performance.
> Running ptp4l with logSyncInterval of -9 will give a ~50% CPU
> improvment.

One Sync every 1.95 milliseconds seems a bit excessive.
Just saying.

Thanks,
Richard

