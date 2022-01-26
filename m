Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1306049D301
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiAZUDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiAZUDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:03:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D5FC06161C;
        Wed, 26 Jan 2022 12:03:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id o12so817405eju.13;
        Wed, 26 Jan 2022 12:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Ap44T3gzeLnBc2W93QxgqqOtTPNbnta0JPR/fRa20w=;
        b=F9tYDnwitAXYyusHn1281wqhD3o4m47idK/gEE5H0GS819xAk7XEZINKmoB0qcTis9
         +Fqke822U35Dy6upDbbsf+T2dDxuwHwcOM8GXVFvccPkjN5ibrGYsQca6CcuhBj4DzP4
         LAJ5qKWzxm3EBy8vNLUSA8vhFwLt8voncYkpTfNA8TBCCZ2d4mBPUgDWutAJFDETTv6z
         1QdxRr7aPUK99zQ2zy+F0VuZ1Dwu7ccl39cMaNhYwOjPBYuKy9Lp5/Y6cSo2+pS4iE9c
         +eykLspJm8b9Fkz3PAy9dtaYVjSSqKKNssWL24YcIKhJo/hxrMMWkBH3H2291VIvDXGj
         cPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Ap44T3gzeLnBc2W93QxgqqOtTPNbnta0JPR/fRa20w=;
        b=aBP5+C8M/aIGthypAokAg3DFSeYYMSXg+gN0e7cnC2yp3ni7zw24g5TfBbL4vFAliQ
         x8/KPssd0acag4JvqsLa3QAkfOChHwn1yF+30GANwO0u74JvZ4DPdaFicOAv/FsF5vW+
         FkC0D+No3Vc8XOEmq5HC4FTrXxUfspOgHF/BTI5nRF0NnmDXNTurY6VyjH7ZkbUH2GBZ
         BLZUWt4rIP7uwmYMyhVgRfBSPetQD3jaBd2RCqx8P1qOq7NKhSQ5/zJRME2pBO2BDpOm
         7cxHjUu0DH2awhbLd97rUGYgasAzqR4FHzftTBhbAKMa8ONvbqu+Q5GEe/1V+4jrWhnc
         aqcg==
X-Gm-Message-State: AOAM532YfREoIZo6OxTbECt5GFiH+GsfumOrvhah48HBSbv6uMxZPpkg
        FIIQaTVLgwx5roceRKQ8zaA=
X-Google-Smtp-Source: ABdhPJzAjpdqPpVS5B73DZzBG2UpBYYpT+V8MEO/N+15mPlMGYSJC4z9bBQ4LxhQk4lCyHYhSvAejw==
X-Received: by 2002:a17:907:3e1d:: with SMTP id hp29mr200487ejc.701.1643227416399;
        Wed, 26 Jan 2022 12:03:36 -0800 (PST)
Received: from debian64.daheim (p5b0d7d67.dip0.t-ipconnect.de. [91.13.125.103])
        by smtp.gmail.com with ESMTPSA id i18sm7818519ejr.117.2022.01.26.12.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:03:34 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nCoVx-0003v5-LR;
        Wed, 26 Jan 2022 21:03:33 +0100
Message-ID: <f8721c22-03f2-6845-fe08-a552069eb55d@gmail.com>
Date:   Wed, 26 Jan 2022 21:03:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] carl9170: fix missing bit-wise or operator for tx_params
Content-Language: de-DE
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stable@vger.kernel.org
References: <20220125004406.344422-1-colin.i.king@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220125004406.344422-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 01:44, Colin Ian King wrote:
> Currently tx_params is being re-assigned with a new value and the
> previous setting IEEE80211_HT_MCS_TX_RX_DIFF is being overwritten.
> The assignment operator is incorrect, the original intent was to
> bit-wise or the value in. Fix this by replacing the = operator
> with |= instead.
> 
> Kudos to Christian Lamparter for suggesting the correct fix.
> 
> Fixes: fe8ee9ad80b2 ("carl9170: mac80211 glue and command interface")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Cc: <Stable@vger.kernel.org>
Of course:

Acked-by: Christian Lamparter <chunkeey@gmail.com>
