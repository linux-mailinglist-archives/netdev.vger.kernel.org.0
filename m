Return-Path: <netdev+bounces-6522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFE7716C1E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B66E2812B6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0652D261;
	Tue, 30 May 2023 18:18:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDE41EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:18:53 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A171B2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:18:52 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75b0b2d0341so500558885a.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685470731; x=1688062731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W1soLVypdkwr/VJnLpnpkZKVPZ6jMCynJZ5VOy+qMCc=;
        b=snfNV0x1jTUc+8og1xKZ47P7VnE1eMjmks1s4dAJdDsOclqYnnR01U6IlosNienrLu
         5fi08W82C9FT0xmCW78O59L7axLBfA8lCf/E1ZNER28zQTyPG+n2bb9y1Ba4gIXj0JRe
         20cn/XtHTzR7DYprxeSW3rSrphOhKbkzsjxuSU04R8KU1xzXtTixFGa5TQmqNhu+AeA2
         Nl44gMODMEvXL4V1p7IwxsyuKYAYF5c+BUL7GupSHFHY2adiNSBM4p2fBZgQejvJhyLP
         vNeO7/d79GgiXowAvosDguPlV7y0xboNGEhQRracfbyJyBkl2NoQrcMaClFXQTrAM7u3
         jGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685470731; x=1688062731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1soLVypdkwr/VJnLpnpkZKVPZ6jMCynJZ5VOy+qMCc=;
        b=YhHU1tuMm2TcYWPX/SjHyMG4dnS5xo4OmVScgmdmg+JxHDNTZVK7UagUwjo3p/4E3j
         aiXjHjnZtcqcTEmKJFlSLZxQmFGUZyRghjbb7tTfvcFNCnF7qMDNGwpBtygQUu3I4H+h
         yRINIyeInw+kCY7e+N3v1olCReS/g8SMhNbWFikJjSoDKFZz0YVnA1BeHJ4osDVB44TA
         Cg49Tb8z4ZxgahnvHTkE/tI0I5gtnJKUT6Cf+BpeFpDZ2Bhk93vg4JMs8PohT1wdlXyh
         +glbiQQcAbIAUIEansZkcH/VdmbjItvCnAkrcYcYvHaGbp/cMqQk57VAzJmbpHKO4P8V
         XozA==
X-Gm-Message-State: AC+VfDxXFAC1LpNbPt/l11FhW2WiH4pbEsVSFYzXRKEWiTUIqnDGA3Sj
	FYy69hX0P20oqy6Tmqkz5gU=
X-Google-Smtp-Source: ACHHUZ5EGEplNae8OkMkO99emf3k/cDZwACBYYmQ+bKdagnDsvoYuf2uLgPe/58TbhLjbnl/dR1yUA==
X-Received: by 2002:a05:620a:47a7:b0:75b:23a1:47b with SMTP id dt39-20020a05620a47a700b0075b23a1047bmr3089509qkb.65.1685470731304;
        Tue, 30 May 2023 11:18:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u7-20020ae9c007000000b0075784a8f13csm3806598qkk.96.2023.05.30.11.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:18:50 -0700 (PDT)
Message-ID: <9457990f-4d5b-09d1-46f5-0f2bcf189b77@gmail.com>
Date: Tue, 30 May 2023 11:18:43 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 21/24] net: phylink: Add MAC_EEE to mac_capabilites
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-22-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-22-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> If the MAC supports Energy Efficient Ethernet, it should indicate this
> by setting the MAC_EEE bit in the config.mac_capabilities
> bitmap. phylink will then enable EEE in the PHY, if it supports it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


