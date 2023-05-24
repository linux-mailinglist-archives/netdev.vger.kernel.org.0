Return-Path: <netdev+bounces-5049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D80BD70F8DE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A57D1C20D6B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B58C2CB;
	Wed, 24 May 2023 14:38:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BD16084A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:38:13 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C7E5A;
	Wed, 24 May 2023 07:37:40 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96fd3a658eeso146218366b.1;
        Wed, 24 May 2023 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684939049; x=1687531049;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6R/AFNwzrtunbmWPmDv87Cn95GOIDO7jB8qZhOttiKM=;
        b=GKdPZas6hWGMwdFH0maeBI+Kwjsi7y4aVQENQCq51fCfUjKVZWOwDGyPz3Si4t3Mpu
         dRUG3ROl5JV4sNnTQX46GJUngPc7q0iiohkcmIaCPeHAWPRq5LsyfRjd3GUQbyEor/GT
         cIn4nFnG/PFfaOgSZliVKZKWyzyNzz58yEr9Nk0PuYABKMILNHsxSVFjkiKaHn38qJLn
         z9cdSIeUfDdNe4yj6wcdDAOIwrMmvjfVzO0HCytMb8dZt0jbyvEqDTKE02TtTYqJm8Mo
         5Wcq07vuVX6fUJ3AL2HbIBQWOHrtftPGeOslgijIba9h4nVVv4pjoiwpQcAaILUxUf3p
         sPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939049; x=1687531049;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6R/AFNwzrtunbmWPmDv87Cn95GOIDO7jB8qZhOttiKM=;
        b=VWGGxmP3bk3WTfAHx2sBudQTnv0iOQ1zbn4bsfdH4iBxt3i4+AEXkF2UEXfIdwc+TV
         ha6MaGRZZfWQznCWUe6oV8TsPKtJ6gWzHrU0HmzaQG4L/FwigYs+8MyXG2CstpjDZ9x7
         MFDNH1/5SOBFIKTzuifI+FS06255ogkx9Irpl18tShtKIH27BhKhNast4UTKgMBMEUAS
         bEaV//T8R2nVhsBJoSMDcQssqn8+U/X0eZbyOtI4dp2amTqZmEvQAtlxLkJSR1OM6uu7
         Pak8PHPgiZe0UIUS7s2RUgMwUZQdJ6Qz7BIHchojdlGfy+J7lHaPM8JhtSCPXZ5aosJe
         S3Pg==
X-Gm-Message-State: AC+VfDyuT8RwnIwsqPA2AHx44iW7+P1uvUcQFUVHI2VPdwgIKgVwEGdv
	teQL/YLpYVjYajOgLrFMkr4=
X-Google-Smtp-Source: ACHHUZ6yOZ6KHUg2ii58wBarDl3I1nVAtSUMNdc3+YLGMASBlJhftnDAAHQZMt3bPQD+mZD6VXnWOg==
X-Received: by 2002:a17:907:16aa:b0:971:484:6391 with SMTP id hc42-20020a17090716aa00b0097104846391mr6362990ejc.20.1684939048339;
        Wed, 24 May 2023 07:37:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a17-20020a17090680d100b0094f7744d135sm5804744ejx.78.2023.05.24.07.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:37:27 -0700 (PDT)
Date: Wed, 24 May 2023 17:37:25 +0300
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
Subject: Re: [PATCH net-next 30/30] MAINTAINERS: add me as maintainer of
 MEDIATEK SWITCH DRIVER
Message-ID: <20230524143725.dupxs3t2a3ovogon@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-31-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-31-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:32PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Add me as a maintainer of the MediaTek MT7530 DSA subdriver.
> 
> List maintainers in alphabetical order by first name.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Patches on the MAINTAINERS file go to the "net" tree, because people
working on stable branches of the kernel (which you also maintain) need
to "see" you as well, to be able to ask you questions.

