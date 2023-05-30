Return-Path: <netdev+bounces-6514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F53716BD6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 841AB281268
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0262A9E6;
	Tue, 30 May 2023 18:03:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF971EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:03:13 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DAD9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:03:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d3fbb8c1cso5323100b3a.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685469792; x=1688061792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GlDOtj3gfZd1iOVuOcSoA6GRLnED0e8zplNthvkfgdE=;
        b=EBxdLMuI04fkVxspiz6XJB/t4cUk62RJzwaeeM5t4+QXFRRHl7QzLM9yktB9adXGOr
         y4E+H6NAl0HPlr+a+wAjDjlVDN7/eKiRmdImIH+VCuHKvuqW8phLpbaTRLBbShjEuv6k
         gexZQ5/Tg1OM/3rezzhjJeSaH+Iq66fDSdLyFJnXdCy+qtXEO8tbztTNfo5wL2RWgT7O
         X7ebxX8Vx/xG644nbhBAQM8/hMecVp+nuzNcFmvDz+EeJ8RiDub5eg6Bg5yJ1408bU8S
         RYXZH/H+zYX5HjJv0XFxBMEH0u/auK0/xdJZdLdFW/K1sz4AJIWGrXL57ILuY65rNXLF
         sBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469792; x=1688061792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlDOtj3gfZd1iOVuOcSoA6GRLnED0e8zplNthvkfgdE=;
        b=jjzpux+2qj3fgmqCiuGv3OKQAzjmfrqA66FKRrhlLYtDvOGf0c5pDFxdS0YhTbLOFw
         iWGfW2xEJl/zo+xrai6buqPNBOY6cUG2G7R3Pgsy6WqlfidJbGOlmE29qcrD0yJATjEd
         g9ArxhQ3PEqn1Gx1JxHgV7BfgHUUPvzhTKkU+4UO72QosHV3ufbXT4CbuPsSxygNKGYX
         cSoogih+QBCjr666STtDnLMFO4m+AfxJE5H92HYNuZr1BHyIjibrM+NwL47gFxkBfSzh
         mCUsf10EHv5iRAzvh5jiE+Zf+JXgD1YcY5PeQiTyPpgywHtwlA2C9KH2t3jq7hWJDw/r
         OT7Q==
X-Gm-Message-State: AC+VfDxj3ZFdPMw5kabWW9uvRfCGfwSRyZGEIGdJrg8UWEk3WcImrhCD
	pY88Bupuq0IgfxMUoM2FxYU=
X-Google-Smtp-Source: ACHHUZ5JHQC1s8k+rWCTzpnuekDnwwEqa0Ec8wcpTHFLI5ela0DhVyRKxTP89rbByQFthMJzVsXpRA==
X-Received: by 2002:a17:902:ce91:b0:1aa:d545:462e with SMTP id f17-20020a170902ce9100b001aad545462emr3604932plg.13.1685469791650;
        Tue, 30 May 2023 11:03:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e3-20020a170902744300b001b02df0ddbbsm6355522plt.275.2023.05.30.11.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:03:11 -0700 (PDT)
Message-ID: <f7ea17a1-472d-cbda-49eb-69ff7c0c8e19@gmail.com>
Date: Tue, 30 May 2023 11:03:04 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 10/24] net: lan743x: Fixup EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-11-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-11-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> The enabling/disabling of EEE in the MAC should happen as a result of
> auto negotiation. So move the enable/disable into
> lan743x_phy_link_status_change() which gets called by phylib when
> there is a change in link status.
> 
> lan743x_ethtool_set_eee() now just programs the hardware with the LTI
> timer value, and passed everything else to phylib, so it can correctly
> setup the PHY.
> 
> lan743x_ethtool_get_eee() relies on phylib doing most of the work, the
> MAC driver just adds the LTI timer value.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

LGTM:

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


