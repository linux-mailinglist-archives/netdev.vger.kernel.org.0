Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839731BB348
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgD1BOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1BOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:14:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8FAC03C1A8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:14:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h12so485456pjz.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGTF0eU/mMGJFNkzJrZdppxQ9XCi/gi7wO93e4NFYBs=;
        b=msVDJX54/e4zbdBNDrbX4k0ra7AjreBM7q2mE+1FNMDJdQJCFFaqSLsgvIrpmn8QHF
         Q04f2ccHxc2YPwXx4OUBYjfi6EVI1cZiMYEh/jPCwwfW3EtzHNO0GXFL/vAhIvdaUCwE
         WceApzAy/suvdMTlBnUoFFRno8vvIexk8YpCMdAb/AK8jOnqysG2XF3SttqP2uAm2i6q
         IZ32l0yJxNBq+//y2IVw7w1XNJFxS1gL3t3AafNVoGNgZQYgzRzomhhxHh81T0RQZV0V
         KVLTpeyBplNkqDWixVReFSwukypkKtdCjL6rsLrLvnrFTL9DqZzbmXZr0Db6U5zpksmZ
         64yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGTF0eU/mMGJFNkzJrZdppxQ9XCi/gi7wO93e4NFYBs=;
        b=SJ+pxc3FY+Y2sJWtbLSHr2Uvzhuxyoi8ZaRqbBGDMgLE6wt96WyRNyqB8fJygkKoOb
         gHaszFEvsYvWsD+lJM81B7Rawhi1fRrXzErW3C1CHUmopRQr6jg/lAuesK19Uaqsl07C
         POH72Iky4njv7poGKNS9XuJBhLKYpVouJW2fxfmiqmyssaJr/RUZ1vEFEfWFFf7kxaIt
         OUCwDaR25stZohJc3ooZ/sCbdlJLNeqFqFTc23p2fnYfSAW40i9npKE+cJ0sz3pwwKZN
         EVPm3Q6U/CkyhBZX+L3hzbYoSzJK58hNkT9ZFGbWLBerJ/tHcz+Z6C8aZXR6apTm7hxb
         gy7g==
X-Gm-Message-State: AGi0PuaLE3kDiROrvACEPQFjtfkQRQr+Po5/W+Vi+4t6ivWjY5fOIeR1
        1brU3rYPYgHPGm+EPFF4jQlJN/c+a7Q=
X-Google-Smtp-Source: APiQypKEKOPZlmtjKYhOnyXA/tQ6azMkqaB9VU3G431J2ZUKMkb4Hkl+UkqQXh0+xZR69530YyrPhQ==
X-Received: by 2002:a17:90a:2751:: with SMTP id o75mr1940597pje.26.1588036488394;
        Mon, 27 Apr 2020 18:14:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x10sm11643315pgq.79.2020.04.27.18.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:14:48 -0700 (PDT)
Date:   Mon, 27 Apr 2020 18:14:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2] tc: m_action: check cookie hex string len
Message-ID: <20200427181439.4393aef5@hermes.lan>
In-Reply-To: <20200427061055.4058-1-jiri@resnulli.us>
References: <20200427061055.4058-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 08:10:55 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Check the cookie hex string len is dividable by 2 as the valid hex
> string always should be.
> 
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---

Applied
