Return-Path: <netdev+bounces-10309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E0A72DC7A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A0E281103
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6021C2B;
	Tue, 13 Jun 2023 08:30:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF58C22D4C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:30:09 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7DBD2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:30:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-97460240863so848977866b.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686645006; x=1689237006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BEOvgjmcH3FesNY8tbRvETC8Tib/95dr/lQjlUtMIZA=;
        b=nD+l/ant7kwFbFnVfDNKFCAndsNRvJAsL/rdSrTAMTPTGk9QPpgnVDKB1h2iSOkl5L
         yUUfYCj0jdLM7SAqH3uY3RdA54A1mUpL7JGiAH8vx/L42aHZ0dLD+k9dT4cUs0RhJ/NS
         Jd8RWy0y1sATxE2k34CYyiMGq3VhpaQBcaiNSWJvIXm7s1q1TTj1cnnpwuNSwQme7CAG
         AtPM2+hPGaMjIlLbcNsF4QFALmQPVg9hQGWGgPH39vXwopE6/HNGV6CWm+IXdrAcO5aO
         XmG+9asppRnIF3UYPdKmWsC9aTK2gZ5QTT+nKahFGeRXuZz1/KhsB6S1aDzv9fbeR2Px
         Or5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686645006; x=1689237006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEOvgjmcH3FesNY8tbRvETC8Tib/95dr/lQjlUtMIZA=;
        b=S5fhkmFNu1UPhGLR3RPPVasrWBGiTs4RkQjViG+qOd2oFKhf3WvfjIkrpOxWW13qXb
         o4ne8GuSSM642QWgkwX1v9wZ0NZYfIN/I/Bxz9RTRsFYFRGe4uoYurVGQ19bIalXckji
         ElGejIxzUTIUZg87Vu0T+B95C/hIZhg/cKo5osTnuEZvR0AdxlwHIBPkmdSUnjP+JbcX
         R62F3/INlsgy3bt1KmGXDmvEvi2o6d5Hly473ClS5qU7j+bzFtWbeqdm4062Nr2Buk3/
         Ni+X/Yk1q6XnprvB3VgvWyNe3EI1Tkxyg4QQmdZJVVoU/YOcK8efFYfss66d9LGYBVDJ
         a+Ig==
X-Gm-Message-State: AC+VfDw9CJ/uMgUBOQQMeYh5lPo3w66d/yA5O4b0pux1lr1B70orffLq
	iGk3hbPcJahN2Dx+V10NgA4=
X-Google-Smtp-Source: ACHHUZ6njLXaeoEWNOCsFfk/4QBMk1BUYENi/6kbRVv77AzipIucpEKyX5OdGW4Zw3MH1WDcRoVOzA==
X-Received: by 2002:a17:907:741:b0:958:801b:9945 with SMTP id xc1-20020a170907074100b00958801b9945mr11693045ejb.31.1686645005430;
        Tue, 13 Jun 2023 01:30:05 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bi9-20020a170906a24900b009745417ca38sm6296609ejb.21.2023.06.13.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 01:30:04 -0700 (PDT)
Date: Tue, 13 Jun 2023 11:30:02 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613083002.pjzsno2tzbewej7o@skbuf>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613071959.GU12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 10:19:59AM +0300, Leon Romanovsky wrote:
> But once child finishes device_shutdown(), it will be removed from devices_kset
> list and dev->driver should be NULL at that point for the child.

What piece of code would make dev->driver be NULL for devices that have
been shut down by device_shutdown()?

