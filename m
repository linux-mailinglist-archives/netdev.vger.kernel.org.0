Return-Path: <netdev+bounces-5496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7568C711E20
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD46B1C20F4C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 02:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A2E17F4;
	Fri, 26 May 2023 02:49:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C217F3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:49:55 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AC6B6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 19:49:53 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1afbc02c602so12837775ad.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 19:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685069393; x=1687661393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/OPLzWUVi7gsop6G9dajjYUDmWusRBpLPLHka0+jrUs=;
        b=Tcbs52HTQXa064gx+SofxdoO70YJsujMrNPMXXAiNSZoUcmn8vmKwcQeqxoNcM2Zga
         kbPkXNMJUnK6WboKI3EMNI5SKIi03FunsTjY1QxSSKLnOjUZZOrxnjqaiJrgM2DY4QWp
         SerxrY9mb1e+DosNbw6z4AaZKOEW6UaUC5GFn/xGhE+MHPhvwSbrj1BA6EHyxUXsiKJY
         9JsqJE+jtqdMHfIb2BV7yQz6xROsRRgQLaUS5Iez9p0Ce8TSz5OBG0txR7202/sc36eN
         aOcIfIQvK0/Hc1IHMkX6EhDeGugnuJeuDb38+WjWiHKjhwqVQS4wIflNBViwtLlJjvoU
         eUuQ==
X-Gm-Message-State: AC+VfDxjSXo+hYG707MG7KHzQyEcbwUhe9908XIop6QPH+I5spUasX9S
	x66oF1q5W9ymMYs4j9IVTRU=
X-Google-Smtp-Source: ACHHUZ5XFpzeemUD1TUof6eCOZ3HnG5K/XByXYk4BPuootwhqPjfiNQxiSFweZaNQrfTmkP0NOc3aw==
X-Received: by 2002:a17:903:1c7:b0:1ad:bccc:af77 with SMTP id e7-20020a17090301c700b001adbcccaf77mr4770197plh.18.1685069393239;
        Thu, 25 May 2023 19:49:53 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b00199203a4fa3sm2065914plk.203.2023.05.25.19.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 19:49:52 -0700 (PDT)
Date: Fri, 26 May 2023 02:49:51 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] xen/netback: Pass (void *) to virt_to_page()
Message-ID: <ZHAeT2m7297SOKfS@liuwe-devbox-debian-v2>
References: <20230523140342.2672713-1-linus.walleij@linaro.org>
 <20230524221147.5791ba3a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524221147.5791ba3a@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:11:47PM -0700, Jakub Kicinski wrote:
> On Tue, 23 May 2023 16:03:42 +0200 Linus Walleij wrote:
> > virt_to_page() takes a virtual address as argument but
> > the driver passes an unsigned long, which works because
> > the target platform(s) uses polymorphic macros to calculate
> > the page.
> > 
> > Since many architectures implement virt_to_pfn() as
> > a macro, this function becomes polymorphic and accepts both a
> > (unsigned long) and a (void *).
> > 
> > Fix this up by an explicit (void *) cast.
> 
> Paul, Wei, looks like netdev may be the usual path for this patch 
> to flow thru, although I'm never 100% sure with Xen.

Yes. Netdev is the right path.

Thanks,
Wei.

