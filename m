Return-Path: <netdev+bounces-5146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A3070FCC6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DDD01C20D68
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0291D2BE;
	Wed, 24 May 2023 17:38:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989601B8E4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:38:35 +0000 (UTC)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EDF122;
	Wed, 24 May 2023 10:38:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-25565ffb176so241355a91.1;
        Wed, 24 May 2023 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684949913; x=1687541913;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VYn9hXv2mid7DrGFXtcteNud4Yc7nDFPsuM7azIKsJw=;
        b=o3tuLfsz6nYfPSKWmuQS4+GCuuTFvaN3NPA4t/vUta7G927SpAv6BCHR1tParpv+cY
         3l6JH8P7p3OVlR3ni1ipuOcO0ph2ENByFTFvPPPbE/c16PfWy6/dW5eACBpWYjRVP/XY
         kzjdT3wRkgQdJZ3ljAc7/cKWQDAclef6uASvq+I9vWHTKB4O9Xmemk+s9edzH4xSdIpB
         L/htxF4oBtnd1o2CADvI+OcueYDyAe/N5mAwjVHz9+Q7NN7ZNQjIPE7CM39xnjTxpI6U
         p8WINBBkXOIKUsSC5p9o0hk6vdAWl7yDthxB8uDUzapAZjzK9BgEFgxZBSkbwclLCiVW
         cflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684949913; x=1687541913;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYn9hXv2mid7DrGFXtcteNud4Yc7nDFPsuM7azIKsJw=;
        b=FGfKpoG20EMr53F8D6GjG4ihkgZ7sfBdfjWKjQInqiCyxmzJ2BJhjxIHcYFTfOLrCK
         Lf90ZVHJWskviy1du63rfW1s8AN4122VEruEHGx+QLtICzv9vM64K2JAHxQ6X0JNKYil
         c6OIMWR5jnn4Dqek0biqdVmc7tr3cYHArSZ8kBZpGCp5LfntDDUPbq9pZo8U+OX+aPqo
         XxDK7IBVUDZBNYnd1YGNWCe/lZgd9Q0ACXRAGx41OvsvxpW/le1EBeEPrNzORhYiHJ0g
         NbLsHQD08AFD4zbbj8iy7saUXZAg5WtNW5t+rE38l+O6KUTdyFS2CVwajEYmNGa0U7rP
         bz1w==
X-Gm-Message-State: AC+VfDyZPiZCrDHG00cdufuHOCfxwR+91A25T0D0VY/BTHVfZBVY4oBs
	kJU9C+yefQa/tMzQdDCdfSHbsIyv2UJXUdDuRfrlI0zCeys=
X-Google-Smtp-Source: ACHHUZ6ngw7KudJrVl8J6mySbNVoTXjH/0iiwi0pa2K1r+1nj3LZClqwxW1vVRxTGEO8qEEHFlsNGFdG/ALOjEHukoA=
X-Received: by 2002:a17:90b:1a8e:b0:252:b342:a84a with SMTP id
 ng14-20020a17090b1a8e00b00252b342a84amr19789961pjb.0.1684949913390; Wed, 24
 May 2023 10:38:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 24 May 2023 14:38:22 -0300
Message-ID: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
Subject: net: dsa: mv88e6xxx: Request for stable inclusion
To: stable <stable@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Jakub Kicinski <kuba@kernel.org>, Vladimir Oltean <olteanv@gmail.com>, 
	=?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I would like to request the commit below to be applied to the 6.1-stable tree:

91e87045a5ef ("net: dsa: mv88e6xxx: Add RGMII delay to 88E6320")

Without this commit, there is a failure to retrieve an IP address via DHCP.

Thanks,

Fabio Estevam

