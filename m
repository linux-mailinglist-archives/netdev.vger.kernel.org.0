Return-Path: <netdev+bounces-12200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 684D2736AD7
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9519A1C20B4A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1DA11C87;
	Tue, 20 Jun 2023 11:21:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E747E566
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:21:54 +0000 (UTC)
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D454130
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:21:53 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5702116762fso51349347b3.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1687260112; x=1689852112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dfQ3niVaGcWe3CQjn+06HwWkagYAmvQ0PFrIW9MH5sY=;
        b=dkZagKoNk7qH5HItxayVJ/GdY8MxAM1NWs2uOqaIEU0KBEA4ZvG02Iyzb4jdgA1Ymh
         tRvjCK5fN8vMVJreaWUK+oUanOhNaeJWvZQQJ/E1JG9mJCT64BX936ZXD3JmQnh26UI9
         fSad1kK7noc1ZRymZ6XGpRFZVB9wgdSsG4jLocnQ8AAlkgTvKGI/cVk/Ur4A0ARCJGXY
         /RR/EDpz6f3ESTHM/vH/FGVC89W65hHxFC8i37WAkxpKDaEMViAmrrxPdtw2hpote2uj
         wjJ2/gBzCFFZZJvDTcaEQBhavPfAuElJA8+oaUN81Qdkkh6RasH6aFadI2b3CymoqXIh
         9cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260112; x=1689852112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dfQ3niVaGcWe3CQjn+06HwWkagYAmvQ0PFrIW9MH5sY=;
        b=Jazn2eG9hZY2xgB+gqC/6fQJfefArlNFuJieHd6wcRdj2pfCt7on8B2FoQKAXgBPFG
         k3sAUofBR7GC9hGM7+x7roRc28O6LuXEwGcty4xYU3f7HqXXkXbLyhcjZxzkvJo/EgO4
         2xpHtmqrqYWHIdUQ5NLXjYzzDZlMVY2/r0tvqbpDaDg/yHm12s7DZlzXuC2MDFW0vcVW
         p6+/74Vi1RcSN0XouaCv5Dy+bak9RPgl8hzPexHDKAaL5gmZTG3Cxfp4O2edp1ECteTB
         1Dqj6anUhUSmUkz+0CdXJA3BBqgpiGhuZK11NEQg+5bOSmuijCiMVh+VoB5chyeTg9k2
         Uvaw==
X-Gm-Message-State: AC+VfDzhaMexdllxuH1P3ejqy7eSQVgNLfusUYWWUD+CxWsikMA2kf5h
	+dc7a3IS+ygmIchE5qE6R9bwmCCDT0dXm1qBS7I7CpDZw0eprm2mVrI=
X-Google-Smtp-Source: ACHHUZ6TCTiLciePb3TWcbuXpNxVdq9lpTes2TguKKkhNfh9aJZUMfKfX2271vdu+AWYQFS5WibYMmGGFZ3+CKKmj3Q=
X-Received: by 2002:a81:c201:0:b0:569:e7cb:cd4e with SMTP id
 z1-20020a81c201000000b00569e7cbcd4emr12722225ywc.48.1687260112492; Tue, 20
 Jun 2023 04:21:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 20 Jun 2023 07:21:41 -0400
Message-ID: <CAM0EoMkRZE2XQcgzxt63jke1q4RVqrHBuw5rc5Pu0rGtW+Vz3A@mail.gmail.com>
Subject: CFS for Netdev 0x17 open!    
To: people <people@netdevconf.info>
Cc: "board@netdevconf.org" <board@netdevconf.info>, Christie Geldart <christie@ambedia.com>, 
	Kimberley Jeffries <kimberleyjeffries@gmail.com>, Jeremy Carter <jeremy@jeremycarter.ca>, 
	Linux Kernel Network Developers <netdev@vger.kernel.org>, lwn@lwn.net, netfilter-devel@vger.kernel.org, 
	Lael Santos <lael.santos@expertisesolutions.com.br>, 
	Felipe Magno de Almeida <felipe@expertise.dev>, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We are pleased to announce the opening of Call For Submissions(CFS)
for Netdev 0x17.
This session will happen in beautiful Vancouver, British Columbia

For overview of topics, submissions and requirements please visit:
https://netdevconf.info/0x17/pages/submit-proposal.html

For all submitted sessions, we employ a blind review process carried
out by the Program Committee. Please refer to:
https://netdevconf.info/0x17/pages/about-us.html#committees

Important dates:
Closing of CFS Sunday, August 27, 2023
Notification by Friday, Sept. 15, 2023
Conference dates Oct 30th - Nov, 2023

cheers,
jamal (on behalf of the Netdev Society)

