Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F11C2D43F2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbgLIOID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgLIOID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:08:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5ECC061794;
        Wed,  9 Dec 2020 06:07:23 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so1246299pga.7;
        Wed, 09 Dec 2020 06:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=voDP8dxcDHaPiF6NSRrUoAxbijn+6Z5KRATnlS6RdeA=;
        b=dGLNn+yrcuG7NDMjXp5BPfelH0/QtLmash5LQDc4JDciPxFwJI3nCGqjXFagUG5yhN
         oW3UzbfY9KJ4YFNtmAC1OWkIEgIeNMJjyIUoGXzwIT/bv+se6IEfmZ9qkTrhrxUIzyO6
         nLyj0LkYoWNiUNgjBbdDNcAQrDtDDsGQk+Rc6XmQesGRfsJM/TbQF+NQtEmkhHKBLrOE
         IDKTedVR+J1kHqObFHowFOs1thCbS4yIwqBf4bBPd+hUYBVwwN06BMQHXVQ5w5MAcHA4
         7p2hgntS4ECEb8V3l3a8jyOvwmhV8nOy1b1jgWb48XNy/8kOioCmEAOQbg57j9D/M7zy
         BPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=voDP8dxcDHaPiF6NSRrUoAxbijn+6Z5KRATnlS6RdeA=;
        b=hb62c8++L/l1W1+s/6UlagenafqKkKRWF6Pyn32oqP85pMYzXwh8TuQpRiMrpcYzew
         nzBbmDA6yKQWTBp3VMIk0F+Sq1R/glJBgO+fldSG+hXRoSjXzfdCEmEXWw87PG6MF40E
         tmS1rvVFFvQTRyRhCU+aOlsiktfKizjPDazw1b4wl6tjNJy6g12IvJaAlimGNeUlRPsI
         HrQkdeDlpldHgODZwXS7DgC9ejccc/+UjiBMCHIl6+1wsZvxRm5ihvANelE5NpKNz1pr
         UyekTf3uL4h6CCu19Gj/NJERdzm/UQ4w5KGc3gXXOgJR+1YNaSu+jmJp3ycd9jbpTADA
         8IpA==
X-Gm-Message-State: AOAM533B/hE1jHeJytxJtNG17Z6HSiDkkfl78bdROWCHyi4uijdK2LpX
        YDXazHhTcNi0UN1ppc2B4zU=
X-Google-Smtp-Source: ABdhPJwb+SlbZJyOUbDx64c4IuzJG3qD+zBbcDUbVQtyKHD5TIVKuiqAbMGgzESLwM1xQziw7c83Fw==
X-Received: by 2002:a62:6346:0:b029:198:3d33:feb with SMTP id x67-20020a6263460000b02901983d330febmr2489224pfb.8.1607522842665;
        Wed, 09 Dec 2020 06:07:22 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k2sm2785519pgi.47.2020.12.09.06.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:07:21 -0800 (PST)
Date:   Wed, 9 Dec 2020 06:07:19 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] ptp: clockmatrix: reset device and check
 BOOT_STATUS
Message-ID: <20201209140719.GA19883@hoboy.vegasvil.org>
References: <1607442117-13661-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607442117-13661-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:41:54AM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> SM_RESET device only when loading full configuration and check
> for BOOT_STATUS. Also remove polling for write trigger done in
> _idtcm_settime().
> 
> Changes since v1:
> -Correct warnings from strict checkpatch

Next time, please put "v2" in the Subject line.  That helps reviewers
keep track.

> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

