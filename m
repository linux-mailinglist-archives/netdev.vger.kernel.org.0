Return-Path: <netdev+bounces-1966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 202296FFBE4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D90D2817A7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F66D174E7;
	Thu, 11 May 2023 21:35:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6209E20691
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:35:18 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4E25BA6;
	Thu, 11 May 2023 14:35:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3078cc99232so6073346f8f.3;
        Thu, 11 May 2023 14:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683840913; x=1686432913;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K5gez4trhN47bLnS5W9sj8CmKovqhNPW+LkbL9c6i6w=;
        b=MB52x6G3crxSmz8AqmoSpzhJ3pHvztb5EKJA/NlbRcNunnzBPPtziH5X37dQBbYPem
         SBPP5TDxS6rR+5tCRUVc0qLuwiJSEGYGj0i9uuDemFK5HVDBBEJ9XQQGh+LHKAmH4Wl/
         dlvCDbzDVjwAfGcic5MBfq+s6b1vyqIwOvplhhLR0/yskJBTSa5i2d8gy2r8BvayATzM
         gdBsUZFgMrkWnHfw/usyYQMW6x8y8/Cev9potAAANmBYlLKYGKVXvSk25peOqNhkmMKi
         ApGNq0my/MdtbNAo6aoWAj1wFqCV6+0sDnseBWc8/s/9SZDH6O5SHYswYJltHCfUo7DS
         m0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683840913; x=1686432913;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5gez4trhN47bLnS5W9sj8CmKovqhNPW+LkbL9c6i6w=;
        b=JfQXMzECem685lpHnQbzEp3PvZ+2aHHX9qQbQgij+SJE8f3onRqcBL+d0RNdZJmTr4
         QStcb5IXfIxxl+RdeLnZ7Mnw8Zfa356FhthDWz2YuAInVRz2kh8Uh2Flu15dFGrzwR9d
         qj8Fm1mYr0sgDBsgO1LhasbmI9VA+HqYeEDW/DESk8ThRXIVWYEO/19fWXRkiUeLU7O0
         ku84LJ1PrJG1M25IXgbtq4kRgVhk0BIFRGe6gmA+hCzqOOKJrLPyBKotrliSksFzgOIt
         0eh5ExqffBmoaJpmsRo1DPKp0/AoJDDmQbKVbZootqZ2rKdEy5sDOm3DmglGJ4CYfqOj
         4v/A==
X-Gm-Message-State: AC+VfDxyJHkqoBBmtB7gJconkCAIrcay/2uKSkSwVeqMiK9LEtw3S6RF
	UPnL8hQec+Aa9tU0l56UXksGFLVavMzeoA==
X-Google-Smtp-Source: ACHHUZ4TlFFMOmoEpYPHYtfUH6OsqWuPEJi0l97YBZwnxIW5DzBvlcN6RkUWVxgsiUJho/HJHsP26g==
X-Received: by 2002:adf:dd02:0:b0:2f9:9911:93d1 with SMTP id a2-20020adfdd02000000b002f9991193d1mr17469315wrm.24.1683840913373;
        Thu, 11 May 2023 14:35:13 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b003064600cff9sm21440858wrt.38.2023.05.11.14.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 14:35:13 -0700 (PDT)
Date: Fri, 12 May 2023 00:35:10 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: alexis.lothore@bootlin.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com, miquel.raynal@bootlin.com,
	milan.stevanovic@se.com, jimmy.lalande@se.com,
	pascal.eberhard@se.com,
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Subject: Re: [PATCH net v2 1/3] net: dsa: rzn1-a5psw: enable management
 frames for CPU port
Message-ID: <20230511213510.anpb6cj6d2zdyotz@skbuf>
References: <20230511170202.742087-1-alexis.lothore@bootlin.com>
 <20230511170202.742087-2-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511170202.742087-2-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:02:00PM +0200, alexis.lothore@bootlin.com wrote:
> From: Clément Léger <clement.leger@bootlin.com>
> 
> Currently, management frame were discarded before reaching the CPU port due
> to a misconfiguration of the MGMT_CONFIG register. Enable them by setting
> the correct value in this register in order to correctly receive management
> frame and handle STP.
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

