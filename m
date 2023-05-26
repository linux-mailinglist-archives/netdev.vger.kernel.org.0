Return-Path: <netdev+bounces-5647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEA37124F7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C7B61C20A3E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0D4742D2;
	Fri, 26 May 2023 10:41:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E32742C1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:56 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F25F7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:41:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso107867066b.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685097713; x=1687689713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hysKvq7DbhMVFZsocweWj6VdrlfWBl8+cDhU5kuSF80=;
        b=0hc00AMXfJO+thpQeXkeQenwekOiYG+gQdUEvYPr3DnNHoWxqnNPCFjZTVxcb22kf/
         kRhp0KuTl8lJvg0v/nq3hz3uHo1hTU1018ekV1EgO/ODdvjxl9I1uQm3rIVlzr3UQ6XA
         ANfwvB6w4TXyYAC7B8ZA0PqDnluIXcWSVIEa99YfvfzVv7dk1iv5cWzt6/qt8Y4zS2Rz
         l8vJiSDpiR/o4c2j2qNUFUO5nJcWvjTEfKatftqM/ToEAlaKBdjGpeiPYc5DoXe4hnrX
         q0JB5Mweam7vxrRML074vrF+9FnsmW/7+qsiX+/i5oSlBreyX8zpMmDMbeNw4BTMjy9g
         VHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685097713; x=1687689713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hysKvq7DbhMVFZsocweWj6VdrlfWBl8+cDhU5kuSF80=;
        b=NNxXtFUfY3f7PxRboBC8t7OQRSyqFLTv/Cd+32Gc3v165V7V90UYmLkTCfHmGPxdHZ
         cGT/HpD7hKvkbar2qcVb2KGkC4uMtMe1E3lfaGRCarErEn5JxCBKWbjMEaoCXzqcc9RW
         Y0DxFnXDiORYdHoGoKPHpJFoWGo4XQ2BL+4T47Ni8loiAy0HUOSAtt3I1pkWlHW9D7+R
         VF6mM8QEAhxiHKLdBO2j/XIqebhIflBHvXGi+rILiKkbpIe9aJfq717EtX1jj0wOGBMl
         uU7aInjBfLIfVN1tbVg2RF7qXqZNASrjZBJnP42OJChPr0rZoLCIG7JDJ27j5cJZ2OCJ
         oMHA==
X-Gm-Message-State: AC+VfDw1Qkgx7Q5oAQpKc7sch82gelzo/aHVJw3+GwcntSCkJcKxeEep
	5jCUpz4ffQ2697UNIbR/xtE61g==
X-Google-Smtp-Source: ACHHUZ6zXqRsvaX+ucQroEJ/4lEkbfHNQ/3jtWNti/1MfZXOKTMNMCdPMK4rgOsTh2dJoyG/wjrt8g==
X-Received: by 2002:a17:907:7b95:b0:96b:6fb:38d6 with SMTP id ne21-20020a1709077b9500b0096b06fb38d6mr1699870ejc.65.1685097713532;
        Fri, 26 May 2023 03:41:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id pg27-20020a170907205b00b009662d0e637esm1960288ejb.155.2023.05.26.03.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:41:53 -0700 (PDT)
Date: Fri, 26 May 2023 12:41:52 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Raju Rangoju <Raju.Rangoju@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, Shyam-sundar.S-k@amd.com,
	Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: Re: [PATCH net] amd-xgbe: fix the false linkup in xgbe_phy_status
Message-ID: <ZHCM8PinlpaA8RaO@nanopsycho>
References: <20230524174902.369921-1-Raju.Rangoju@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524174902.369921-1-Raju.Rangoju@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 24, 2023 at 07:49:02PM CEST, Raju.Rangoju@amd.com wrote:
>In the event of a change in XGBE mode, the current auto-negotiation
>needs to be reset and the AN cycle needs to be re-triggerred. However,
>the current code ignores the return value of xgbe_set_mode(), leading to
>false information as the link is declared without checking the status
>register.
>
>Fix this by propogating the mode switch status information to
>xgbe_phy_status().
>
>Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
>Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
>Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
>Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

