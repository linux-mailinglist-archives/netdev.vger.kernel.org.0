Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813EF28BB93
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbgJLPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389498AbgJLPK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:10:26 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A246DC0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:10:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id i2so14548380pgh.7
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NHSXhk9dTshCx5DF5zP7p5vePvVsv6vjq91VyVfW34=;
        b=XU5qClnLrrvis7/VaXXFMXOqxMuXDJA6Ng4PIVpt/YCtg8zv8NXVawjexhd95Xvwbi
         YSHXjllkMb+88/H+gJ7e2db7GlGE9obA4iAtfFyNv0oEessUuNUrd87vl/Bf5L4YXDSm
         VUPX7a2ow5SwQziYC6e8KJSk5rlGSYkE4Pudno8dVgJdZy5JKd8Kmse5BBt3FWurfrN5
         3Dm/QbzU6dzvXU7m1FRkYu8TcmEYyK1Gwti+pxX/olsSVoCjInYXOvLSd/hjGa+QsEVG
         u0NUNn41DaPU9LZwaz71qvU6X5f1kQa8qvNbrg9QUFgSKVFvtai2ij2aLiYgiRBPUC/1
         yNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NHSXhk9dTshCx5DF5zP7p5vePvVsv6vjq91VyVfW34=;
        b=f81g6sLrIT2V77Wtp8b8VcdHFuz778ux8cDKSS1UL17RSYUJUFOXw1nuPSWnXZSUJL
         2iAYknoEXRl2hBBVedhLGhv1VGilC416g8Zt6gZq9DFAc8JH3dnyn5VxPYQFMn/W3gFy
         eUbie00zwmq8cZZkNSdLSLKuZBSTV6hWXsIQhhIBoPLMZzWdYlOBc/TcxP3OqZCzNd/O
         7TnAmsMsEpRIYpyym7bVP7YP7XL+AaNlYbwmz6I7NXMBQN5BGo3oifol8I/y9aiPpKXX
         sZqmRc/X3jrgtgg3aYpxZECM4iYyHk4MaokOSVNfF2VrsWa4/YKZuSWiEKYa6Fxym4iZ
         ezAg==
X-Gm-Message-State: AOAM532uyOfyyp0fVBcTAD8xYr0FAWi1Tc63xJq9oktYEXHqNEaQ1mUz
        4HVkanG1YaISBUThZnRbonR2Egth67/cQQ==
X-Google-Smtp-Source: ABdhPJz7Ju2L2j8c1iH1DjCcCq7CIR/GE9QCVl40sQIbYRxamB3VXKQV744QZ/3p/wUsqDie4mo/pg==
X-Received: by 2002:a63:a55d:: with SMTP id r29mr13318760pgu.368.1602515424028;
        Mon, 12 Oct 2020 08:10:24 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b5sm20113655pfo.64.2020.10.12.08.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 08:10:23 -0700 (PDT)
Date:   Mon, 12 Oct 2020 08:10:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH] ip: add error reporting when RTM_GETNSID failed
Message-ID: <20201012081016.702db023@hermes.local>
In-Reply-To: <20201012135555.6071-1-jengelh@inai.de>
References: <20201012135555.6071-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 15:55:55 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> +			fprintf(stderr, "/proc/self/ns/net: %s. "
> +				"Continuing anyway.\n", strerror(errno))


WARNING: quoted string split across lines
#95: FILE: ip/ipnetns.c:82:
+			fprintf(stderr, "/proc/self/ns/net: %s. "
+				"Continuing anyway.\n", strerror(errno));




I applied this but fixed the two checkpatch warnings about breaking single line
in message.
