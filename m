Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4194C6C8CC9
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjCYItY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCYItX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:49:23 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600E5EC62
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 01:49:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eh3so16504716edb.11
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679734154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XcJ3UdhzJKY8rYGLf8LRBiDFii9QiAWqi/dsRAsZXmY=;
        b=ESBaJf3SkXu9qU4+QqcJcurlq3ptGcjbiOQi8Hk3GrOOn3ZEnd8vAn5V+c0+pWNbSH
         mqT2FGD2yxzOhvmFEzQVDVUo9oAEJW4Yoz5VsWn/uL6vAmO7P4ir7T0jTVwk8hgbMUL5
         o4qAqh+nPSsylR9c+xI+bihjpogp7cmURKdpIjYA1FCSWVjmcQk5RoXOyiNiqadeBZVO
         UN1cn7PofgTtNf/PBvvk9e9SJZ6c/rTPY9K3DuCWDSxfWHsBUFFegnsyURaqUfc1dSGV
         MlhkUEcLbvt6u67/vAp9TJBb9rRhBtqUFSV+YRG3YC9cHNno3C38NNVHW3PtGgvsVa0Y
         5BQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679734154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XcJ3UdhzJKY8rYGLf8LRBiDFii9QiAWqi/dsRAsZXmY=;
        b=cQTstJEWOicZ8fvdiqjf8XtXVLUiJTAsYfVSaAFLSxtGsFJoPGPvCaox3P9e9Z950j
         vY69Yyfr6Fhm2AMkoAuJvZ05qT/Nz7At7zt4lvP2wUjw6YQRKMApFxyvFg7Sb22mdv9q
         GFmJtB8jeKgfbEtog+QPoW1tyr7NIFrpqjmDG+XIHVzPtYrRm1o/3o+zd5Z7IgxFMk2t
         l8LO2xeuqWYLrfZ9eKXuvivsUdKzORLm3rvMLZ8HAf+wHBasXU5+Ca0/Wf8aWRlNEJhv
         gmqXkpfY2Icy8X+d7AG0XTIU0D1pkif08mm6WW5ZLY4kIXjVHMOIyZVoDnq3KSzluzDM
         uqdw==
X-Gm-Message-State: AAQBX9ePCvfSx2i8ksB5clFdWIWNV3nmXlsF+Bhr4VAPTyKAXA6cJwLx
        ClCB9F4+wXj5uaMSpMLF+dZsg57cdr4=
X-Google-Smtp-Source: AKy350aJvXNROv0nGaFdJyBWtnpELygjVItrejhe5BswYYVXgT+drDYenGxkUFBqL4Cwo5aN6f+slA==
X-Received: by 2002:a05:6402:1019:b0:4fb:b09e:4c8b with SMTP id c25-20020a056402101900b004fbb09e4c8bmr5914847edu.37.1679734153652;
        Sat, 25 Mar 2023 01:49:13 -0700 (PDT)
Received: from ?IPV6:2a01:c22:73a5:2800:e59a:ffcb:c722:70cf? (dynamic-2a01-0c22-73a5-2800-e59a-ffcb-c722-70cf.c22.pool.telefonica.de. [2a01:c22:73a5:2800:e59a:ffcb:c722:70cf])
        by smtp.googlemail.com with ESMTPSA id y70-20020a50bb4c000000b004fa380a14e7sm11983640ede.77.2023.03.25.01.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 01:49:13 -0700 (PDT)
Message-ID: <4a11e5b7-3896-df37-38dc-bdf38a4c43db@gmail.com>
Date:   Sat, 25 Mar 2023 09:49:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net v2] r8169: fix RTL8168H and RTL8107E rx crc error
To:     ChunHao Lin <hau@realtek.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20230323143309.9356-1-hau@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230323143309.9356-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.03.2023 15:33, ChunHao Lin wrote:
> When link speed is 10 Mbps and temperature is under -20°C, RTL8168H and
> RTL8107E may have rx crc error. Disable phy 10 Mbps pll off to fix this
> issue.
> 
> Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
> Signed-off-by: ChunHao Lin <hau@realtek.com>
> ---
> V1 -> V2:
> - add Fixes tag
> - change title and description
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>


