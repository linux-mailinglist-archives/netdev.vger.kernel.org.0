Return-Path: <netdev+bounces-10528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C8472EDB8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945881C2087E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC813D388;
	Tue, 13 Jun 2023 21:14:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6A91ED43
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:14:39 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E0010FE;
	Tue, 13 Jun 2023 14:14:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5187aa14e3bso1087083a12.3;
        Tue, 13 Jun 2023 14:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686690876; x=1689282876;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wCuc+FlADiTMcvu0ZKdgfUJS8/hlu9Jz0EWmI6QBs/w=;
        b=fTHPU208W9abwrG+qKSEMf7zmA/STf4r4Chc+TNY2R9fpzmKKiuT6RiBOUh30sRtnD
         hABgXXFbpIl+cUHi/WliVd2nF2u6Hg/a4DGs0jZG9wQagdZa5/2c6py6QrrVRJr7Jh6R
         lBTfdQXMMjzuZ9nVvw28sRUd6E1qYeXvXL6/X89ymfbRLXcuar6y+rkS63J9NYO02Awd
         v07khBXGtqLSB5f/nKNNrdymP+pjcwoZFEfGWDnolpeWNItMXMHyt8wJS1g+QTMcnufd
         tK0oWotaQm4nLYr6TwK/eh3Qj52joSQ1CHY80eOrDUqjwnXyY95lX5SE6DF3wtbYqahg
         tYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686690876; x=1689282876;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wCuc+FlADiTMcvu0ZKdgfUJS8/hlu9Jz0EWmI6QBs/w=;
        b=Brhgq6CkDy6OhW7SvPsE3G5D4lS1cynzOQbatIE1IzpmgGvFU2nxIwsvYLoptgmsuv
         46E0hklP1MaVcEGfX0Yol2jGxyB6MKJBrQKZtuGCZ9X8yyc6wg8xPu+9F5U0RqDdxJHU
         +m0rSN3VJ9JSkqVv2y1c3ltYeiLONpNkp9gV8KAAZEU4DTeV0sbgkzw4vUACbGndRKQ/
         5iTOrYsIUYDu9jVY8/cI07frdxmZn6HRyvwS2nsaT2nyLNySTp2+204d/VvOTAFBNqHL
         vZWPEl2jB5RHNaRPG8pmA3bhubKjhbV1wn/QbEa4eHlX0qP/GHrd6TCuHRbIYOldS622
         YPAg==
X-Gm-Message-State: AC+VfDz1qM3rkZRaX6ul7oNpIVf+YxJagUpDH3gOEiZsHXnVQek3IzrH
	vrmKHcIUcpWbCF+0uIOpURI=
X-Google-Smtp-Source: ACHHUZ7qgio6yxDds7lzF4gz6IIwexPIk056MxOhIa6BWDjQGY1a6VOdreOm3IyplH/vCjIz4uC16g==
X-Received: by 2002:a05:6402:1819:b0:514:9d3f:7a60 with SMTP id g25-20020a056402181900b005149d3f7a60mr7980046edy.14.1686690876293;
        Tue, 13 Jun 2023 14:14:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v26-20020aa7dbda000000b0050cc4461fc5sm6839752edt.92.2023.06.13.14.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 14:14:35 -0700 (PDT)
Date: Wed, 14 Jun 2023 00:14:32 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613211432.dc66py7nh34ehiv4@skbuf>
References: <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <20230613201850.5g4u3wf2kllmlk27@skbuf>
 <4a2fb3ac-ccad-f56e-4951-e5a5cb80dd1b@arinc9.com>
 <20230613205915.rmpuqq7ahmd7taeq@skbuf>
 <dd0d716e-8fdc-b6dc-3870-e7e524e8bf49@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd0d716e-8fdc-b6dc-3870-e7e524e8bf49@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 12:04:10AM +0300, Arınç ÜNAL wrote:
> Because I don't see the latter patch as a fix. It treats the symptom, not
> the cause.
> 
> Anyway, I'm fine with taking this patch from this series and put it on my
> series for net-next instead.

Right, but what seems to have been the case during the net.git
(and linux-stable.git) triage so far is that user impact matters.
A configuration that works by coincidence and not by intention, but
otherwise works reliably, still works, at the end of the day.

If you read the weekly net.git pull requests sent to Linus Torvalds,
you'll see that maintainers try to make a summary of what had to be
changed and why. There isn't really a strong reason why this patch *has*
to be in those pull requests. That's kind of the mindset of what makes
"stable" "stable".

