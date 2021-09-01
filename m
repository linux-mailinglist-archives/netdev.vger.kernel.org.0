Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017D53FD504
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242952AbhIAIOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242899AbhIAIOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630484029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uyDrxtsR94VMPU5MaJ7LybPMEr60Xgeln0jH3Y/pfWo=;
        b=OnDSllUeJ4O+/gs7b0EkqiVflWVud4G+RYhNFVvjxoAcGwGThuNTMqMQno8FZZFJJkvPY/
        VeIvP8uMUW4NSM110kw4eAm+AYz+r1emCVQh1UEesOKRxib4pRZjMgaNjYCM7sNukTciI/
        aQxH3dVNGFlWOer3R+NTr2nXsR8Cp2Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-0M1VAGpEOdWjoR7nooQ8pg-1; Wed, 01 Sep 2021 04:13:48 -0400
X-MC-Unique: 0M1VAGpEOdWjoR7nooQ8pg-1
Received: by mail-wr1-f69.google.com with SMTP id z16-20020adfdf90000000b00159083b5966so501896wrl.23
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uyDrxtsR94VMPU5MaJ7LybPMEr60Xgeln0jH3Y/pfWo=;
        b=UwiAK161iNVdElRTpoLZNwU6NIbZBUgrcSaxkOQcBBxMnS/hY6+ZFIxjdws6yTkqKO
         BGd0S4gskEwmd/StfaJk8zC9a8SRVZHCmPTc7zCbhkemwVWKT+x7ZlTmZzkpk5BNbQC/
         6kRvaE+7lmPQs7pkIgyx/HTP4nBWnDiYDj2k06NB0yp5pGw27DlKZMlwdcB61x6/PL/l
         BcQjWqANyMkZw8lpPD/1pM8/poM66ASwLXRKQ3+TjWFrq1nTQm1z5f/RMo/hcVMTcXAh
         Hj/28cbKMca/YaviWEOew5pVKnFpNclQ/nNI4HOM1YExTfcLOr/Ua753s8EX3lItk+oe
         JjdQ==
X-Gm-Message-State: AOAM530jrtKjyCQbB3Z9KRHCqZvvdFf6B5P5R7nFSgwNeQqrRzPYzk8Y
        hqgqRd+iWJwh7Pg8W45yrYvKiQRbrn1db4CeBYCV5j2GvWjn4lZfqABptRESUAJrsTyzyF2GdKr
        egUMYPhn9rS2ET1bH
X-Received: by 2002:adf:c3d4:: with SMTP id d20mr36069379wrg.358.1630484026643;
        Wed, 01 Sep 2021 01:13:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrnLwgdxjrPnEWEVBAyYagEpAefLy0ZBMaW08Mk0jB8RfFU+GX3ibBFf9h6AshyJy/RQ8VRg==
X-Received: by 2002:adf:c3d4:: with SMTP id d20mr36069361wrg.358.1630484026470;
        Wed, 01 Sep 2021 01:13:46 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-233-185.dyn.eolo.it. [146.241.233.185])
        by smtp.gmail.com with ESMTPSA id u25sm4703254wmj.10.2021.09.01.01.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:13:46 -0700 (PDT)
Message-ID: <0b030119a755fb246a617f3ab30c7664d4f95323.camel@redhat.com>
Subject: Re: [PATCH] [v3] mptcp: Fix duplicated argument in protocol.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Date:   Wed, 01 Sep 2021 10:13:45 +0200
In-Reply-To: <20210901031932.7734-1-wanjiabing@vivo.com>
References: <20210901031932.7734-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2021-09-01 at 11:19 +0800, Wan Jiabing wrote:
> Fix the following coccicheck warning:
> ./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |
> 
> The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
> Here should be OPTION_MPTCP_MPJ_ACK.
> 
> Fixes: 74c7dfbee3e18 ("mptcp: consolidate in_opt sub-options fields in a bitmask")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Not sure what happen to my previous reply, most probably PEBKAC, sorry.

WRT this patch, note that the dup is harmless, as in the input path we
always use the mask and not the individual bit - vice versa in the
output path. Still the cleanup is worthy and patch LGTM.
Acked-by: Paolo Abeni <pabeni@redhat.com>

