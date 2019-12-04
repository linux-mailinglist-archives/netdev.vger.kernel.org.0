Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB71135CE
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfLDThd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:37:33 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43529 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfLDThd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:37:33 -0500
Received: by mail-pl1-f196.google.com with SMTP id q16so134754plr.10
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ui8e3AszIvSDCTj6jGH+9JPc+W4B8chEXx2R5guyhUQ=;
        b=jhhdRWM2AE6EhY+oFzRcucC0tT/YDodGPpgFowTVQc7hzvx6W9jdBOrZBWIsarfg7e
         0FoU+5XPrVtWjPlm3iiUxWpWftkS3Xzm90bc2i2iny06liECmEkC6O+dVS860KCL7tJq
         cRfX7xADjbAH+ue+PNENqKpm5i4MkbZj6HuxhAeNkbaT1SlqUATgcgkKnkBT/QKn85vK
         Nkm394347QwDdoVfN3jmJYcAGuZvlDNQUEIlnTsiHPryZcnj+YTd2VeMFXyhWSrwmUoW
         Z+JDsa/GoUvTa4Yiuff4upF0BxKGIhIHYJJHTcO0ROf09+yoWFlXJXR2LLL+BX8FFORL
         j6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ui8e3AszIvSDCTj6jGH+9JPc+W4B8chEXx2R5guyhUQ=;
        b=MYDCfHvIanja1x48Y4uOb0lf2fY18kV0kHE8voiqYQnTAFQpU1BqzLXZmQv1Fe9J/f
         4F5Bppx9QM/WUX2T+aPyBQtDOl6pU1ofLwwS2b07dHfIboSh/snyG+K5GufXdM8LzxOt
         xTtiKHRKUpOk6UHbC7iX3LHK6exwGet3aRTyhus5qyHc1Z/vnurlg+59s0iuf2v2CWT8
         8o5ha/LDnOCfkEqFIShBxnpB29UAik1WO9zD0wHBibhWg5m0JWaCW6i+WGZ2zGzzrUHD
         Ao+uMDGupd+NiGrwf4Cc8dJgRPyo8KiByZ8iZKtMcbgQCSXfG4n+eKzs6R3cfCdGHtwU
         V9CA==
X-Gm-Message-State: APjAAAXnPD507b/uotQLz53BoJjGvh0T/4dQwOUvwbto752VqJA32FxQ
        UTn19QusB7t5HVzHcCrgxxijgA==
X-Google-Smtp-Source: APXvYqy8RAFYVgfxHB9a9MXhjBJb/DjoxTcpi2QqQY2s97yhrWKL8b9+qDiTnxPotX8rM1dtTOTTdA==
X-Received: by 2002:a17:902:a98b:: with SMTP id bh11mr5177918plb.281.1575488252853;
        Wed, 04 Dec 2019 11:37:32 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r10sm8035661pgn.68.2019.12.04.11.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:37:32 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:37:29 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [PATCH iproute2] tc: fix warning in tc/m_ct.c
Message-ID: <20191204113729.52ac5f8a@hermes.lan>
In-Reply-To: <20191127051934.158900-1-brianvv@google.com>
References: <20191127051934.158900-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 21:19:34 -0800
Brian Vazquez <brianvv@google.com> wrote:

> Warning was:
> m_ct.c:370:13: warning: variable 'nat' is used uninitialized whenever
> 'if' condition is false
> 
> Cc: Paul Blakey <paulb@mellanox.com>
> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---

Applied
