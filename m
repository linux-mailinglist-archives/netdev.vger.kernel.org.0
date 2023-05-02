Return-Path: <netdev+bounces-1-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 457CA6F4AB8
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96D671C2092E
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2BA8F7D;
	Tue,  2 May 2023 20:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EFE8F6E
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:00:22 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD31A0
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:00:19 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ef3ce7085bso19025411cf.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 13:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683057618; x=1685649618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m22Whz12MOrn6qwLKIXfkU6Kg85kYB5zJc6MlSfNyn8=;
        b=aZ3LuHo8Q/0KoJ/H0jpLEKSg9ECOtTMsBI/wORH7VMAkB0lRI+pm2+yjX9Unac5mKF
         JbOFL5xvI3KlVn6lDeJwZwToS6sAi+R6IpDj4obtIzMovcUrep5Hv8/FCjqrF0vw2386
         5q0wqxU7TofJR/3Y74GQZ8Z4+7UA9/OxZJBXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683057618; x=1685649618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m22Whz12MOrn6qwLKIXfkU6Kg85kYB5zJc6MlSfNyn8=;
        b=bpqLf1UY3C2KPpup0MqNBEf8RA6q/iALlug6hBu8roOVwzN46yRUwLRqPsYjBemgTr
         uOmV8/dpNfMZYrWIFO63YU5/oyoY0bYCYUY3qXIOKgT8efkkiMWHwaiYcBjdNqCw7vDF
         X2+SjCvUiBwdeGLdDNKm0lv/jmwwxlvhMU/GOUhx4sCMru7tuL3ypKAMJHgzmdcjb/LK
         9haLhN1ZDh7Lxr5SoZl+u7jt3AJWbg9jwn5i/dgORBawDz16hYAYbS9B3HCdevNPp34V
         UV8qjc/IJSYrog0tLXIXvWzm3bax52Xl70/cr+4egc2QrEZ6qvfyV/ToC/+S3F0OpO7g
         6H2A==
X-Gm-Message-State: AC+VfDySxiU4rcqlXZrKi7MhIuLJ3I9h8UP2vuvmToKauM+I7nOQ7sd/
	SCPLJZmFPvdgcHSFeujjr/r76Q==
X-Google-Smtp-Source: ACHHUZ7YOeweLiDcykE2UF1S9ueJejhfnPi+iPKs5EgfeeKG4ff27E/p5GdBQoUsknEn3qrUk31qBg==
X-Received: by 2002:ac8:5e53:0:b0:3bf:be7d:b3e5 with SMTP id i19-20020ac85e53000000b003bfbe7db3e5mr27994084qtx.41.1683057618193;
        Tue, 02 May 2023 13:00:18 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-132.dsl.bell.ca. [209.226.106.132])
        by smtp.gmail.com with ESMTPSA id y144-20020a376496000000b0074e0dd4de87sm9913602qkb.111.2023.05.02.13.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 13:00:17 -0700 (PDT)
Date: Tue, 2 May 2023 16:00:16 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org, 
	John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [ANN] Mailing list migration - Tue, May 2nd
Message-ID: <20230502-dreamland-anthem-45dc50@meerkat>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 25, 2023 at 02:06:14PM -0700, Jakub Kicinski wrote:
> We are planning to perform a migration of email distribution for 
> the netdev@vger mailing list on Tue, May 2nd (4PM EDT / 1PM PDT).

Hi, all:

This is now. There will be a series of test messages I will send in this
thread that are safe to ignore.

Once the move is complete and everything is verified looking good, I will let
everyone know.

-K

