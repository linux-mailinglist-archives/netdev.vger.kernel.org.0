Return-Path: <netdev+bounces-1897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8556FF6C1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DBEE1C20FA5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD56F4696;
	Thu, 11 May 2023 16:06:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2396653
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:06:19 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCAA559E
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:06:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-24ded4b33d7so6094116a91.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683821177; x=1686413177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yjcQw5qfoWhZrHShMenKyn6N6JRDwRPKfT0j3vGPb74=;
        b=O99GbI7t2R7iCSmuWqIAWRBpWiqB5S/bkuc71mZR9seDW2TcyxC4NWNMQr8lVBcHh1
         ktf8bgGWxvwJzfDEmy0q2E/gnPMr2u+QXjAEfPyXnQx5eokWsKyerUoh/nAOEzEkT1tX
         jmIyPIGMJykQ1GWWv4ZeOBG97LMOEMlqeSvz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683821177; x=1686413177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjcQw5qfoWhZrHShMenKyn6N6JRDwRPKfT0j3vGPb74=;
        b=gc4TPSZcc2LTLGV7YJGVPyZxoVMowGVMAhvOr6rxzB/2It+l7IMl5MxQki2XFCanFz
         GV2hbK1IUC1qx44fRPGFJHl6mdZBd0pQXwYOKpZJGr8u1At3YCpeAlJ4DKPZW5wFlwSw
         mmwceFijWysewkxNjh58r91TUiwh+r2iqXmG4SBE/mR0jUFx/ERAd7GYRK13XYrbh2nb
         sM+8vqritSsVCJcgmzUJdlNVRJTrCWD81T3kV5xUpDohmz6Ta2xYsvAVHxukvih8lA6v
         EXNZFVJcogLc2eBI6K8Cr6Dj+UnzW6swOzSQC4vP1pa8L/oWN1agVwGktyQWhAhXFXi6
         o40w==
X-Gm-Message-State: AC+VfDzZbgWvy4wkfNTW7KXK+usoHWV+fd+8N+Ysst8JUIhJRTE2x98B
	qdOk+ZH5oQMeGkWe258E0ZGf1zNJxPQ/K7VdH78=
X-Google-Smtp-Source: ACHHUZ4T7fGPw6RhgXB3YhPDAVdBil7K8ZjbNA7hvHIB3GIJ2h84kwHUsXVjfo+wUT2IQqmnyofUhA==
X-Received: by 2002:a17:90a:dd8d:b0:252:98ca:e7ac with SMTP id l13-20020a17090add8d00b0025298cae7acmr1639114pjv.44.1683821177052;
        Thu, 11 May 2023 09:06:17 -0700 (PDT)
Received: from nitro.local ([2001:4958:15a0:30:e305:5a3c:4c5a:1bc7])
        by smtp.gmail.com with ESMTPSA id q22-20020a656256000000b005287a0560c9sm4989386pgv.1.2023.05.11.09.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 09:06:16 -0700 (PDT)
Date: Thu, 11 May 2023 12:06:14 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	Linux regressions mailing list <regressions@lists.linux.dev>, =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>, 
	Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Stanislav Fomichev <sdf@fomichev.me>, workflows@vger.kernel.org
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and RTL8153
 Gigabit Ethernet Adapter
Message-ID: <20230511-tart-asthma-girth-11164c@meerkat>
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
 <87lei36q27.fsf@miraculix.mork.no>
 <20230505120436.6ff8cfca@kernel.org>
 <57dbce31-daa9-9674-513e-f123b94950da@leemhuis.info>
 <20230505123744.16666106@kernel.org>
 <9284a9ec-d7c9-68e8-7384-07291894937b@leemhuis.info>
 <20230508130944.30699c33@kernel.org>
 <71f119ab-24e2-6a35-2b7d-43ea2a9578b8@leemhuis.info>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <71f119ab-24e2-6a35-2b7d-43ea2a9578b8@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:25:47PM +0200, Thorsten Leemhuis wrote:
> > The bugbot can be enabled per BZ entry (AFAIU), so you can flip it
> > individually for the thread you want to report. It should flush that 
> > BZ to the list. At which point you can follow your normal ML regression
> > process.
> > 
> > Where did I go off the rails?
> 
> You missed that Konstantin (now CCed) is just a bit careful for the
> bugbot bring up and therefore for now only allows bugbot to be enabled
> for BZ entries that are filed against the product/component combination
> Linux/Kernel. I could reassigning bugs there, but that would break the
> workflow for maintainers like Kalle, which look at all bugs assigned to
> their product/component combo (Drivers/network-wireless in Kalle's case).

I hope to start opening this up to other products within the next few weeks,
as things are looking fairly stable for our initial tests.

-K

