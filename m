Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30E8BEA04
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733105AbfIZBWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:22:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42274 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbfIZBWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 21:22:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id z12so441810pgp.9
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 18:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MD8PqFTIrfqVg/nPcicHnw4G60xSlz72XwRSvmNFqHw=;
        b=aUJRjKjbUWWfnryhWekM6eT0R9Q0ZW8mYa4Hv/Vl1RsCZoR9N4HMkn2a3DXvpQBJG8
         JaqoOYt5rDFbdhT/QQBUy3GVB9Ag8fwg5OIDAXmZyNeRooRRzAn7zql0WfeYI9Cyy1c3
         v7I1Z69Js3DmPjvPg39AaNy27dxsEJp6ip/UJaxXpYlsbn70A5TkcaecCErWZwk4kWk1
         CtW8N6Apt44DkzwWEKHw4LyPGsJbC9/y5I95zV26bB/mbshREVLcN4PcbT5Qqiiu6Loa
         9oXDdyjXZzjkmYC3hz5CVtrp7pI83WxAXigVW1bBp8LY25eBbYfCjhAQsN5Y7R8P+ouj
         B7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MD8PqFTIrfqVg/nPcicHnw4G60xSlz72XwRSvmNFqHw=;
        b=WoX/tKdXVX/6vvc97EdyrTFOtdexu/ym3hWT0t2W/6XgDdiCWf11FWDDfW7Dx+Lal5
         Iq5ibBLhd4p2GzYfOTO/vTlkDUaAc4ZoZ3epnRPhS0fIuFRM6Ux9Hq74muJBWV5NOH8o
         Mtjq0Q+j/dcDJq4WGqZZaFBhXSeeUB3A8gYkaF+VB+MT+/F0+kiLeHf7XWj+xTQ+TGx9
         4cfrp8id4pbfuK2b6oDgRtw6lTgvTNqECQR0IlS4+sBZILWWKcawZxMHSro+N/d/z2lW
         S3eHSRzB2R3CXhlqDXpzCb4cvtYkV+3teuS4dxS8i5hqkqgCq7PV/enbX0hDpIJg+k0G
         vAMA==
X-Gm-Message-State: APjAAAWCfU9OBW2X/pA2Jy0PMl7NAU6p+7jpr8qD78DSvlwpDIAHBMTa
        7hIyLscwZKLW8J+6h4Anp7VQyA==
X-Google-Smtp-Source: APXvYqwR/3RSURcXKUfDfobDH/x9KWfYdawkfjKylyVeNquiinjS2lN6UzCD3oNi1JQcv37aof7a1A==
X-Received: by 2002:a63:120a:: with SMTP id h10mr769341pgl.29.1569460931530;
        Wed, 25 Sep 2019 18:22:11 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d5sm272418pjw.31.2019.09.25.18.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 18:22:11 -0700 (PDT)
Date:   Wed, 25 Sep 2019 18:22:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Fred Lotter <frederik.lotter@netronome.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: fix memory leak in
 nfp_flower_spawn_vnic_reprs
Message-ID: <20190925182208.6b8be6bd@cakuba.netronome.com>
In-Reply-To: <20190925190512.3404-1-navid.emamdoost@gmail.com>
References: <20190925190512.3404-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Sep 2019 14:05:09 -0500, Navid Emamdoost wrote:
> In nfp_flower_spawn_vnic_reprs in the loop if initialization or the
> allocations fail memory is leaked. Appropriate releases are added.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Fixes: b94524529741 ("nfp: flower: add per repr private data for LAG offload")

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
