Return-Path: <netdev+bounces-5469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F335711781
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A77B2815B0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BB024141;
	Thu, 25 May 2023 19:35:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D08FC05
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 19:35:47 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3D8A7
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:35:14 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96652cb7673so162746966b.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685043238; x=1687635238;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=omMTY1or9SrrKMZELZLQH6rGhEK2aJzxF2jTBqOVLSU=;
        b=c7+IBQv9F2x6/HunvO55aA13WEf5dOglIWwDousi/j+F3o3KlcwrDBaDnxr9ID0+4Z
         N4oYB1W/yf0zlxDl87DLLIU1/QWa+ER4b4D8+6DSS/pulqPGjxWAQdWzLCFRt7nzPfer
         swveGjjoconXUmqpL4vMZCG/s83sd2hqS9i+je2IAMWZp0dLV6weBTy1pYulVPi1En58
         +peQZJcW6antyQkboh6pOEQLWrckNTCVEO3p/ljrwlk9NOMqAiuj8quxDg5R3cXqahor
         wTnMwSOS8IuE1LjM/Gx+PRByyr4l8xfTMs9ZtzoJVgmmudAQFgnEXDEeKLPz2eVfvqt/
         XekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685043238; x=1687635238;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omMTY1or9SrrKMZELZLQH6rGhEK2aJzxF2jTBqOVLSU=;
        b=b1L8j26azstSb158UaLgTnxFtx/nt5rpMW1qUS+0rjnRfAOgrOsyX/jvskmVBqPeYs
         ZMO2MPMmt5AJcfMkzoZvW3As638XPfC9QQ49PyAtm3KFmZtCy9OiH4/ZLtk9bm+GrX93
         bkqfHIsGDYqAH8YG/vCi08cd6ScahQ6Ga3TFuaPvI7TrMYiNSoGt7jXeN0ot3HFMdyWV
         OhSVNiQL9+lOJoJrqJX9hrgUKr+zXZ4ymm8CqTqO43/i235JpMFTlAYh3UDG9S1JU3fz
         6LEM6ZC8xzjpa/X9pmvxX65tE4Eu/1wU8s7Ij8LD2bbb9/YTI9VoI7+r94RyDC9C7I1e
         Yl+A==
X-Gm-Message-State: AC+VfDyfV3JoUCskvghaJHq78bqbKNQoBokU/rmCR8UiIEhiw6vDhjNX
	JFODclxsw1HrIGqRUdlw9XyKngqwtNc/50r3h0c=
X-Google-Smtp-Source: ACHHUZ435jO5TrrceiQBfE9d+lBxEraCM6asT5qwo8SN1MRiOJ4KYPTcXaqdfNzdKmKkbfSdyI9fsw==
X-Received: by 2002:ac2:5923:0:b0:4f3:bb14:6bac with SMTP id v3-20020ac25923000000b004f3bb146bacmr5341050lfi.56.1685042554346;
        Thu, 25 May 2023 12:22:34 -0700 (PDT)
Received: from builder (c188-149-203-37.bredband.tele2.se. [188.149.203.37])
        by smtp.gmail.com with ESMTPSA id c6-20020ac244a6000000b004f4cae38a1dsm305824lfm.223.2023.05.25.12.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 12:22:33 -0700 (PDT)
Date: Thu, 25 May 2023 21:22:31 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <ZG+1d6m7Tum3KcVL@builder>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-7-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524144539.62618-7-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:39PM +0530, Parthiban Veerasooran wrote:
> Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
> (LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and an
> internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S networks. As
> LAN867X and LAN865X are using the same function for the read_status,
> rename the function as lan86xx_read_status.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

I spotted something that's missing, the help text for the
MICROCHIP_T1S_PHY config option in driver/net/phy/Kconfig
should be updated. Currently it says:
	  Currently supports the LAN8670, LAN8671, LAN8672

Which should be extended with the 865x phys

