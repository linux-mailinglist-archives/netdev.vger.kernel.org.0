Return-Path: <netdev+bounces-7747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBD07215D1
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17B9D1C209F9
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC384415;
	Sun,  4 Jun 2023 09:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7ED23B3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:23:11 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F61B1;
	Sun,  4 Jun 2023 02:23:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-97668583210so251980166b.1;
        Sun, 04 Jun 2023 02:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685870588; x=1688462588;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nwyWMrJ3KHae90TffxL9AnX5OQPeP2x8dmjtNZo0s6Y=;
        b=FoOeFN0fzdLZT92B3gdASJ45MYDZrDwkWeqcje+rYQVfgQyrdEynZCciTcPmX3x8Am
         YdWzbf9em1+B/GH1s2qsj5HxYLp6O72WalMOEGQ5iYLl81/YIj46d/dVzN9VtnkHnHtA
         7R39jjqgjvcRZl9Dt++GpctRv9RZqTntHkRAYcV8d8uIgsBEhbsXYjeYOPzAKkO6vqRu
         BqzpgnTMNCL2h79dZZNrNocELrF0hMGwsviQgZrY56YhzQ0p82bYkfJChZ8SrWNJbsaR
         o3Wsbs4aLiO+KfvoM/eoadriqxzGWipaFlNKtyTycb71TklavcEnXfzfj4T0AYG+Tqc3
         MpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685870588; x=1688462588;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nwyWMrJ3KHae90TffxL9AnX5OQPeP2x8dmjtNZo0s6Y=;
        b=Dy/IZJ1ZdgAR4gVX9p2ojGN5iGGkTBel6MAhvXg/L5iz/DykgS9OBspKA9pE2Qj7vb
         q1U8xp/p5lRUxIH8uPUe0B3Q7cW/Cjyb2XK+7lgSaYXXsI6Ci6n8OH5v6DIPOaJcBFId
         mQ3Cq2s0ZQKftzZlAbcFfTYVEEJzCwzctJ7wH9+V6jx4qwCNZnCN8bjqvPh69BO1eH9W
         w3noZGqLHf6FtNGtKaoJ8AUj4rajcWvylPbL9ZyHMfDnR8S+WoBfCqh1QQeiEmQGqnA+
         9UOwjt8VY4+TUo7JGjmxmWFeVlFrvIfggP65QSu5T8nWngfi05oY7FJiiOW6xw0C8AKg
         mExw==
X-Gm-Message-State: AC+VfDw89C7LYJgRp243cn78rCKTEVdieq4eaJKfcn6qYBqh1WaWY/lr
	BxDElrmBkwiyrLUFYhwKb2mdf1Jt4QA=
X-Google-Smtp-Source: ACHHUZ4wQ0kbCG+SQb8rt+ZiQjciDpG8UJ4MAaHfXXLJmol3DdQ8D5D4YeCKTfTmC7SaWnQjmvQ8/g==
X-Received: by 2002:a17:907:3189:b0:971:c931:3677 with SMTP id xe9-20020a170907318900b00971c9313677mr3281732ejb.68.1685870587648;
        Sun, 04 Jun 2023 02:23:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id dk23-20020a170906f0d700b009746394662asm2715323ejb.53.2023.06.04.02.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 02:23:07 -0700 (PDT)
Date: Sun, 4 Jun 2023 12:23:04 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 27/30] net: dsa: mt7530: introduce BPDU trapping
 for MT7530 switch
Message-ID: <20230604092304.gkcdccgfda5hjitf@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-28-arinc.unal@arinc9.com>
 <20230526170223.gjdek6ob2w2kibzr@skbuf>
 <f22d1ddd-b3a4-25da-b681-e0790913f526@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f22d1ddd-b3a4-25da-b681-e0790913f526@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 11:51:33AM +0300, Arınç ÜNAL wrote:
> > If the switch doesn't currently trap BPDUs, isn't STP broken?
> 
> No, the BPDU_PORT_FW bits are 0 after reset. The MT7620 programming guide
> states that frames with 01:80:C2:00:00:00 MAC DA (which is how the BPDU
> distinction is being made) will follow the system default which means the
> BPDUs will be treated as normal multicast frames.
> 
> Only if all 3 bits are set will the BPDUs be dropped.

Right, if you don't trap BPDUs just to the CPU but flood them, I believe
the STP protocol won't behave properly with switching loops. Worth testing.

