Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB3A2E1FAE
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgLWRCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 12:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgLWRCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 12:02:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AD8C061794;
        Wed, 23 Dec 2020 09:01:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c12so10679912pfo.10;
        Wed, 23 Dec 2020 09:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7z156e/uKkv/pjjwPftIVvO966IjR1f5aiNFEZCH6Gw=;
        b=HY/yRb15PFKPXR0Iat2RACxzNCOVAMTaTi9CrstMyv/ItxD4KWO1sMmz+C8l0KWTIk
         rgEMxpRYvPXSBgWKMoZ4GdWafzxIN8J7Kgn7cqqCqDo7r/1lq9uNesBZRNRTp8Aqezne
         CpW7q2YMmRLoeUPLzZBryTx1h0OlLdI/wPz084BUykVMIy78KFmzbGZePNmY8jws1C2n
         mu+n7cVsYJgLqMtHATXCz94dhNoE+26pFabzfykwUDuNDYG/Qe6avhOirxQXMko02V1F
         6bgxBokSKG8uf7XsDQPsZ9LI8xDiBv3uzm6liiZy7fLZHbMND/ubMp6MTp4SMfCX+WTy
         CzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7z156e/uKkv/pjjwPftIVvO966IjR1f5aiNFEZCH6Gw=;
        b=nPZ2kTvj3/JaLpai8QQSdT3qYkqWqz1lUzZxa+lJtG5UDUXB25yfeclZIkB007lJzp
         RBf4cM+cEOMpVf5z/vPqmszFpJDqW4Nt3fXNVUpJgZ1Nc4n8P2mDtKEvMVNNWHz9KnEV
         +pZGqKdYwi5pemD93XspbkPd48Lb1zahzJNWulHu9fY03LRVFnhgWZct3G+NcwtWwbEf
         Yiia5VoOQAWHi/DItR5/wOj+MF1YT0fHPtU0/Dr4QMdAq4knCQvbogNu2yc0yIQ0GWL0
         77rHkpKBZ2zmaLZzAi2e+UPlBPIANi7YHKJEuakQ9JW1qMHlsljTh3/a8FntDCJkNYPy
         w/Ew==
X-Gm-Message-State: AOAM532JPV+O/36WBZWCkdF0fvrxfGVirU8MlTomseqUzrxTq5TAP3kG
        NATn8vbEuH5a3uAiS2Jp1DEkGn/qTKA=
X-Google-Smtp-Source: ABdhPJyHwj0dwxGvjw/XH0Fj5rL0D6+CoIBHGo7R58lSyueswryIpY3BQGgAMjri5Wj4kEb2SaleaA==
X-Received: by 2002:a63:e5e:: with SMTP id 30mr956059pgo.181.1608742894791;
        Wed, 23 Dec 2020 09:01:34 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:46ec:f978:4298:de79])
        by smtp.gmail.com with ESMTPSA id er23sm238645pjb.12.2020.12.23.09.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 09:01:33 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 075/130] net/lapb: fix t1 timer handling for LAPB_STATE_0
Date:   Wed, 23 Dec 2020 09:01:24 -0800
Message-Id: <20201223170124.5963-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-75-sashal@kernel.org>
References: <20201223021813.2791612-75-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Martin Schiller <ms@dev.tdt.de>
>
> [ Upstream commit 62480b992ba3fb1d7260b11293aed9d6557831c7 ]
>
> 1. DTE interface changes immediately to LAPB_STATE_1 and start sending
>    SABM(E).
>
> 2. DCE interface sends N2-times DM and changes to LAPB_STATE_1
>    afterwards if there is no response in the meantime.

I don't think this patch is suitable for stable branches. This patch is
part of a patch series that changes the lapb module from "establishing the
L2 connection only when needed by L3", to "establishing the L2 connection
automatically whenever we are able to". This is a behavioral change. It
should be seen as a new feature. It is not a bug fix.

