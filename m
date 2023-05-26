Return-Path: <netdev+bounces-5688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F81712738
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C17851C21031
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C15018B0F;
	Fri, 26 May 2023 13:09:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418DF101E8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:09:32 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7580B198;
	Fri, 26 May 2023 06:09:30 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-96f8d485ef3so112332266b.0;
        Fri, 26 May 2023 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685106569; x=1687698569;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zFJ2wzNIGZ0KOStcSuewNy9zLZfz/DVIl8h5862j09g=;
        b=SZ8Ij6ruFkxE5HmAzgORE4Zkm0chc0YtI3Dj9C86P75v1dVCrd3X+EP+Zhz1kOlJRT
         V5wpit7vQGPj+Jpm6jO4zNROI/iJ3ukfhNByE8Oc1Qpj5SyevKXEmwCzLlGHR5FQ3R8P
         a3wuY6rXAtU7RtdzSUpZGwmktFmiIbevWlP5JunqIMuoaGA2dDldcliaVYH6NMCdXHte
         BnF80tXTSHKKwK6Of5k6kM7pThauCgTn9nkotu6PGjrHemlmR8MysFYpDTh8SrNQwBHL
         CY2yGWrUzSz20HHqBa3w8dM2Cj7y7Nb8AvPgvRBDb1UAvQJ1NfOuNXHgXPGAgUB0wwnM
         7Mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685106569; x=1687698569;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFJ2wzNIGZ0KOStcSuewNy9zLZfz/DVIl8h5862j09g=;
        b=fbe6HL3fke5QDryiUWJfW7JZI7Q879LkmpFy7Pzcq+ry/JJARpKcjBeur6tp5XxWAN
         nJFexeIHZQVlFNnK4qf56/0HiL4YxsMhLsjgpf4I7za7l+pkRdvQRwfwFKXsXTgvkxcM
         40IQAvsqhPx1dg004GtbMzNEGeaGlCw/8W/6tvWOEdZgNbm+qjNXP8eTCScEpBXCJVZ4
         ONM6K2x4VwLwZ/mQRFgTUS9lVj55fFQif1UDMaM9bgznEh+9hmVlUWGHXADaIut5zDo5
         /hXgXhX1yhb4n171XYpQh0LnYMkoT3ZoSU/yF2VlxTqlQjt+VpjAx93SZEnkwjaPfZc0
         kYJw==
X-Gm-Message-State: AC+VfDy9hi8B/b5/yaJ2mepxWoxcx393dLVC000wHj6ltT8qDqwdZQDG
	zbun7Bi9USDhlesmY7A8gLg=
X-Google-Smtp-Source: ACHHUZ5Na1tqMh44XsGjWcNaXiLrMmEVPuZshBdTgVvbPjvRA8qYslkhuP9hKJli3isZlAlI28LZFg==
X-Received: by 2002:a17:907:1621:b0:96f:b9c9:c8b7 with SMTP id hb33-20020a170907162100b0096fb9c9c8b7mr1999316ejc.46.1685106568533;
        Fri, 26 May 2023 06:09:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id le8-20020a170907170800b0096f803afbe3sm2164022ejc.66.2023.05.26.06.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:09:28 -0700 (PDT)
Date: Fri, 26 May 2023 16:09:25 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
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
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 15/30] net: dsa: mt7530: set TRGMII RD TAP if
 trgmii is being used
Message-ID: <20230526130925.g6w3tbxunoamfmha@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-16-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-16-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:17PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> This code sets the Read Data (RD) TAP value to 16 for all TRGMII control
> registers.
> 
> The for loop iterates over all the TRGMII control registers, and
> mt7530_rmw() function is used to perform a read-modify-write operation on
> each register's RD_TAP field to set its value to 16.
> 
> This operation is used to tune the timing of the read data signal in
> TRGMII to match the TX signal of the link partner.
> 
> Run this if trgmii is being used. Since this code doesn't lower the
> driving, there's no apparent benefit to run this if trgmii is not being
> used.
> 
> Add a comment to explain the code.
> 
> Thanks to 趙皎宏 (Landen Chao) for pointing out what the code does.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

