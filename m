Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FF3386A2
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhCLHfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhCLHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:35:20 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D566C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:35:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so4056705wmq.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWI2ifkumsHMtHtO5ppg2HtJpuKFgZtX+BsaiymIvC4=;
        b=ot/OEcyIZgPCJL/hr4PNayP7cYbzY6ItRaAYvzVLHB5Ye4Sfo+wGUqeikthnvxBawU
         j1IwRaSCOX1jzjPbo0h1qZMiO8MyRWI2OScN7AO5aGf6BFW8AO+2ZAqyk83JnfxMUXPo
         n2lxesXOJtCWPpzZbYPGvjmu1LYe+vZwVDwuzpj9EYZyEbE0lq4v0BTzGcAFYWw1tm3S
         y7+6lPlAY+aqi9ctcUmyvZaJxnCOH5Czk8gMZuVTYZIrjET/kXDxBX0JUk6fVJzeaDrx
         codZPwBX8nDPr6ZEV8ndaLa8TrWxSFK2UjVeAM741CyUhPBN0AtfypHvA7o4RiNwmdrJ
         8fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZWI2ifkumsHMtHtO5ppg2HtJpuKFgZtX+BsaiymIvC4=;
        b=o1yG6hkZ0okJhNEmk0jdJhSqxem2CInREdqp3XLRZ0jYfyx6akU/UVNkV0pDmaGpw+
         X+vtLxm+YuQVydmRIS6S23tva/T3eEF1FO0A02oXo5rbpD6rtO5SXKT857N3PQmfRqrK
         3a4CuOQ/W6wRkl80OWtlgCw+6JI+iw/Sxvac82c8pSM5SfCLJ1o8/RsMD04HdbzWWz0n
         v/qal1MNxxrMqfVbO3ER0KDHaZjhr5S1UiVZB7r55+xN1X/bdK/H6daMzKHYSgQuCPAO
         6YcjSrLp0iymnVGonJKIdvXecZ01knf8DBgLb8zTQZiJdljKdY5CVFYBn3+6CfspZfm9
         NmHQ==
X-Gm-Message-State: AOAM530TxSTaoi86+z5aVw5UF/2qS1bjaPdsshpfsniniuFfCP0FBUmt
        Afu7QW2M9mYSB5o5f+QuYE4HbpeVFGw=
X-Google-Smtp-Source: ABdhPJxWdgEYz1BrD4aUPyoXz1qQnY243gERkEOoHnEvKzU5Xgr/RRtKiC96eNi7f9qlnHSpuIMY9Q==
X-Received: by 2002:a05:600c:3650:: with SMTP id y16mr5771890wmq.182.1615534519041;
        Thu, 11 Mar 2021 23:35:19 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:d41c:67e5:a11f:43fe? ([2a00:23c5:5785:9a01:d41c:67e5:a11f:43fe])
        by smtp.gmail.com with ESMTPSA id g9sm7188316wrp.14.2021.03.11.23.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 23:35:18 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [net-next 2/2] xen-netback: add module parameter to disable
 dynamic multicast control
To:     ChiaHao Hsu <andyhsu@amazon.com>, netdev@vger.kernel.org
Cc:     wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
References: <20210311230035.24450-1-andyhsu@amazon.com>
Message-ID: <341df30d-ece4-b01c-79c0-1727493b21b3@xen.org>
Date:   Fri, 12 Mar 2021 07:35:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311230035.24450-1-andyhsu@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2021 23:00, ChiaHao Hsu wrote:
> In order to support live migration of guests between kernels
> that do and do not support 'feature-dynamic-multicast-control',
> we add a module parameter that allows the feature to be disabled
> at run time, instead of using hardcode value.
> The default value is enable.
> 
> Signed-off-by: ChiaHao Hsu <andyhsu@amazon.com>

Reviewed-by: Paul Durrant <paul@xen.org>
