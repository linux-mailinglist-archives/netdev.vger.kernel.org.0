Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B8D2DE695
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgLRPbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgLRPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 10:31:25 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22ECC0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 07:30:44 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id d17so3748684ejy.9
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 07:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l3JSsaQyVs0/RK/MwxBVyzGysSPVDz4OdtdMxcbmWig=;
        b=FpUbbK5MkMGM8bp3M/3LE1seidWlhG6w2l2V3NzE8TDW8HJdXTDiUeK1v2/8zgBMAU
         /AmFPvyBCnBOASseMrzpo8gRFjARQszDw8Qp+y0tGKe89ZYZYCIbdu4kbCy0fbfGDyCN
         LimSCodH8H47VOLS+qgKN6WIUZ5SXpMacC2N4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l3JSsaQyVs0/RK/MwxBVyzGysSPVDz4OdtdMxcbmWig=;
        b=HPa9W7bcebgQJRBQO0vwwMpQsWRKcmLnB39/Hjwt75ufEQwpqHO18HP7qdtacp1e21
         DQevO8cDz6iyuZZQ5Jq+OKul7yOI3SRHOoOaExfPPpiwn9mU2FMnOMX7ME5P8WQHWSqx
         0VAmQaQYb6XWU4v4N4K6Unbjy790xIlPvxNeuYemyeNPFCKbmX2q931H7uLBzXU5ZkY4
         Bth8AItunctNp3Si2//tFtkrlvlyzKgVrXmaOEZXmTB/Zy1KFbOE7TEeus2BXpZnsa6Z
         2q97IWWGYbUHmgIXpAHdQvzhjF5SdtdmT/FCiughQ0fRZpt++DFiUBbOfQ+HKa9B7BFD
         9hiw==
X-Gm-Message-State: AOAM530QbWDth1TH+qlZBFznkhgYdUSuELkAHhYIlebYOVy/AIVYhBGc
        sJ9ka0809bH4IHhi7vd+jTBlww==
X-Google-Smtp-Source: ABdhPJx+GPUkezQ05w+OICUYKe/DAeSlz9BYEmT0z3AMKIr9sKn9J6a4apiAqU8b2LqJMrwAUDiv2g==
X-Received: by 2002:a17:906:3813:: with SMTP id v19mr4528537ejc.462.1608305443632;
        Fri, 18 Dec 2020 07:30:43 -0800 (PST)
Received: from blondie ([94.230.83.38])
        by smtp.gmail.com with ESMTPSA id j22sm5526042ejy.106.2020.12.18.07.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 07:30:42 -0800 (PST)
Date:   Fri, 18 Dec 2020 17:30:26 +0200
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH] xfrm: Fix oops in xfrm_replay_advance_bmp
Message-ID: <20201218173026.23f50b2c@blondie>
In-Reply-To: <20201218151612.GC3576117@gauss3.secunet.de>
References: <20201214133832.438945-1-shmulik.ladkani@gmail.com>
        <20201218151612.GC3576117@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020 16:16:12 +0100
Steffen Klassert <steffen.klassert@secunet.com> wrote:

> Applied, thanks a lot Shmulik!

Thanks Steffen, please make sure this hits -stable


