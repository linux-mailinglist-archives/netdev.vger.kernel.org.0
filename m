Return-Path: <netdev+bounces-5687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFBF712734
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DD551C21012
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BF418B0C;
	Fri, 26 May 2023 13:08:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32CD15497
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:08:23 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1072D12F;
	Fri, 26 May 2023 06:08:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96fffe11714so125554566b.0;
        Fri, 26 May 2023 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685106500; x=1687698500;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ySmRc53vKROoV0PWm3ZQ6WwdfwBbVdA+rwOuG37JzZw=;
        b=ZWX0QrcpW5rWQ8p4KBmcTFHIzFOzfgnezwVXPG5rXkBt9/iCaSoF+Tt8pkc3eMSCH2
         3rVCNwT6b/ksKMFKIXXUlSLc+2YqfbsJ0p17Li8YJ1LZkRrlhUYMFKJT+sD2AiSvBhWY
         rCC1YfMg0G8oQYiKXKqNvoMNoC4gxR6eyCHD++UqE7bErXC5TGuDnwj9CuPce1gSPR3X
         4otRb1gYbB5EH+12gj0Sp2Stp5cTsIb6sdL9e0yxO3b3CS72FsJ0lD1dqrgc52yk7AtC
         6XA354eBLzXZlXX02Z7U/wKis3vmVXlmY+r1CjI3TRlq1euNUOF7MKkabwaQfbTAGsAT
         Z+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685106500; x=1687698500;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySmRc53vKROoV0PWm3ZQ6WwdfwBbVdA+rwOuG37JzZw=;
        b=bMqUMbk3AcJyd6R/b2f4+f2bBPC07XstRDExhXSaLD+WkcXcxMZKwV+o742oJP7h7H
         Zl6a6AL7aqzm+g9DYOT4dAoHtZoMS89vzMVmwnuhMkK7QvFLz7oQNllYRDP9uiM5Evi1
         kxj5VArhKISXGiklyU59aHL/0s88SyRMJrjbqpoNzNtWIItyFDl1Fe7mU7ziMvmyLp/b
         TBnFsckLbaTuXD3OkmtRnYneuuQTpu8U/v6dW+wXmvnljJUlAeNPJmAKmsLnV5aI7oDb
         9kAVa+XhtrRavJ5hKGvfhiI8OWZkr17ter8QKnQEKq2M54S1o3j+/+XyCd8Cr9DJsR3s
         5luQ==
X-Gm-Message-State: AC+VfDyldOXzPBUJ81+2bGpvg1+t41XPvpQytFl6HcLnCm/VwS/UCTUl
	xBFkSmYROA2p86vPOwECk8M=
X-Google-Smtp-Source: ACHHUZ5IP7XtAUQ7qtAUErDZxK4RiTHj9xBIsKmfmWAwOCCjD4jBlU4hvp4FtroBOvALb7tr+oUMJg==
X-Received: by 2002:a17:907:3d92:b0:973:8c47:2a02 with SMTP id he18-20020a1709073d9200b009738c472a02mr2178906ejc.38.1685106500249;
        Fri, 26 May 2023 06:08:20 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709065e0c00b009659ad1072fsm2151667eju.113.2023.05.26.06.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:08:19 -0700 (PDT)
Date: Fri, 26 May 2023 16:08:16 +0300
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
Subject: Re: [PATCH net-next 14/30] net: dsa: mt7530: switch to if/else
 statements on mt7530_setup_port6()
Message-ID: <20230526130816.wr63736dn5jmaem7@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-15-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-15-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:16PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> This code is from before this driver was converted to phylink API. Phylink
> deals with the unsupported interface cases before mt7530_setup_port6() is
> run. Therefore, the default case would never run. However, it must be
> defined nonetheless to handle all the remaining enumeration values, the
> phy-modes.
> 
> Switch to if/else statements which simplifies the code.
> 
> Change mt7530_setup_port6() to void now that there're no error cases left.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

