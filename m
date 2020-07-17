Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DB2240A4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgGQQeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgGQQeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:34:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23EFC0619D2;
        Fri, 17 Jul 2020 09:34:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so18136973wmh.2;
        Fri, 17 Jul 2020 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nlNOxRU+8APNfpgYqlG415vJNutIBS3QSHzPE7f1viM=;
        b=Fy5nOkQbWtOnQSdh4jAjJaZ3m1YgqUE/QuUoitEaBlTtREZLiV6iQbm/AUIEmUM3z9
         gCpWokMyVr8GoqwhUgSLQtNRDt0H0iQvSWCIjipOU+SRlLkxESdirIlehQV73l4yDBaO
         /w4NS2egHwDgzQa2/IQEkm7WaSTmAdqLxc0Xk2/2KQiw/CA2qbOoL65Gd1i/G4qE5WsJ
         5bCg8zdu3y/KQDTFq1f7BDxzMr+Tfuzu3obyUefFIAnZy9tLmIFhKuWMJCzpHXtuPWKS
         Sy+hODAIRqhXddVkBAoymhfyKahG/nB1nKV30JdXvGFg9qJwahgtyL4fCoO2nxtg+s6b
         Gx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nlNOxRU+8APNfpgYqlG415vJNutIBS3QSHzPE7f1viM=;
        b=I3qRY3GpMYbxhB8HVqG/nW79DQdhxVBdjghEptkMK2TyZTnHLJoJ0zxwhqBWWcqmIz
         GxoAj17no6h4i/L9h4UpQQ9BurtWCN5qpQsQTs4yePZKDGJqmdPR3tvnSYOSJUgJVDfs
         /wNOLwMZDWpYDVXb8jn1oDlUpM9PLYQiGEYBPr8XowIvyJuKny/XCE1lF/tSGI43Bmzd
         tOvbW2kyv837h2QHSsX215HoOOX29nRWZro11EOmm0HawYPvROy7tgfuQljXcAZ9dTeB
         MG2akLmYxBEhGs7LzFXInaq9RtxdaGiQ0lYH8tjNDEqEAQTrRVYrsp7/9NG4SZ8hwH4L
         Bcjg==
X-Gm-Message-State: AOAM530FemAvlnVL5P8YRFbtn9djOMNLOL4ipjWIpef5LLyeDaIjymGh
        ZFXftOseqeikBUAHhyJkF5478cjk
X-Google-Smtp-Source: ABdhPJyaiZoLv8CL2HECAmgBAXLVjY+X61e6k6JmSw7eEfKTZUonGB7FwrqrYs07IfdczUaVJH73Dg==
X-Received: by 2002:a1c:cc12:: with SMTP id h18mr10790316wmb.56.1595003663044;
        Fri, 17 Jul 2020 09:34:23 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm15221914wmg.2.2020.07.17.09.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 09:34:22 -0700 (PDT)
Subject: Re: [PATCH net 3/3] net: bcmgenet: restore HFB filters on resume
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
 <1594942697-37954-4-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9706ae96-65cf-a84d-3879-497358bed73f@gmail.com>
Date:   Fri, 17 Jul 2020 09:34:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594942697-37954-4-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 4:38 PM, Doug Berger wrote:
> The Hardware Filter Block RAM may not be preserved when the GENET
> block is reset during a deep sleep, so it is not sufficient to
> only backup and restore the enables.
> 
> This commit clears out the HFB block and reprograms the rxnfc
> rules when the system resumes from a suspended state. To support
> this the bcmgenet_hfb_create_rxnfc_filter() function is modified
> to access the register space directly so that it can't fail due
> to memory allocation issues.
> 
> Fixes: f50932cca632 ("net: bcmgenet: add WAKE_FILTER support")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
