Return-Path: <netdev+bounces-1573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1A86FE547
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41524281540
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2EA21CD1;
	Wed, 10 May 2023 20:39:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324C221CC4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:39:55 +0000 (UTC)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E772B7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:39:43 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5304913530fso1799401a12.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683751183; x=1686343183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOshnWeHxoi/XvJfRqWI9shEi97MfR/czKTST8c5ogE=;
        b=YLdRnQ5DGxbDCHvNkDPmsUx+C9ccHtGHr/Ct4OpQ0EOfi7huTKc+BxGAAJtAxCm2rf
         CPOJpigbgkBmCdXPu9zE54MlUejMYsU2VCuyuZLPatW+HWY5ysSHdtgMjc4ufIM1wVod
         /IREzMyOnbfO8L7/JTPCh16S1xVS6ZFH15LJZbtOtxBTO+Pc6VOmqqqDyYRfsav+UTko
         8s3GT3uD2dZuu0jzjmgmQybf6HUQGdWF4ZjwDx/GhmkRReFnbkC444msWbakweR0nRY2
         To8Aa5h6hOYnf5FLRBuWqKGP6VJRKsJhuvl0anxKeHc5OkIhihOYkkL4L34HXgS3ZcQl
         OE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683751183; x=1686343183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOshnWeHxoi/XvJfRqWI9shEi97MfR/czKTST8c5ogE=;
        b=e6lhJoOtkF6GuA8HPGmtOVgET5rt6UOzlZJwc4mRHHr/u9hQwie+ZgbOb6yFVEcMym
         wyd5a6xvY0WIJHHGo/MrPoJmSmx8IZWiMI/oKA3tz7qtqZhbrmSm/b4zEc1+BAR782RR
         VwKM15SbVwR+9cR2fCoXC91/Z20Sa6Slc19vWvJLeWha5qZkZDrmjLZ7HcJ3xd7YV3WI
         16AXiJJXzsECRiX6LHApIfcL1A4BbZYZNtMNS9ul2GOAGMfbPX53/gIFMvZZKtpqKxJJ
         UsxnQLuqXLteG1Cfs6HayVZUfikqsbCUQZf3ybUa8ZAoXtojEX9iccnGNypeNhLwbKAd
         UECw==
X-Gm-Message-State: AC+VfDx/pprEO/ZXFBQWTG/KHhlB7iW83nirjfgknXNpUTf9dHRZxxFP
	DAEMtMSsZgbS+pVxZ7pTHn9mCg==
X-Google-Smtp-Source: ACHHUZ4EdyJ2fodWoKF/sejvoOqzsRikHa8jgv8eZmDJeWMTXKHVM1eVJohNt9dkKNk62poimoHqIQ==
X-Received: by 2002:a17:902:f690:b0:1aa:d971:4623 with SMTP id l16-20020a170902f69000b001aad9714623mr21711551plg.38.1683751183357;
        Wed, 10 May 2023 13:39:43 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902690600b001a072aedec7sm4226516plk.75.2023.05.10.13.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 13:39:43 -0700 (PDT)
Date: Wed, 10 May 2023 13:39:41 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: zhaoshuang <izhaoshuang@163.com>
Cc: pawel.chmielewski@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2: optimize code and fix some mem-leak risk
Message-ID: <20230510133941.721c77e5@hermes.local>
In-Reply-To: <20230510154747.26835-2-izhaoshuang@163.com>
References: <20230510133616.7717-1-izhaoshuang@163.com>
	<20230510154747.26835-2-izhaoshuang@163.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 10 May 2023 23:47:47 +0800
zhaoshuang <izhaoshuang@163.com> wrote:

> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <zhaoshuang@uniontech.com>
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>

Best to have a single signoff? I assume these are just two
mail accounts for the same person.

