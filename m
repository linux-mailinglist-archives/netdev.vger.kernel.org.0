Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019BD3651A3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhDTEyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhDTEyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 00:54:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A3C06174A;
        Mon, 19 Apr 2021 21:53:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v13so5401529ple.9;
        Mon, 19 Apr 2021 21:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=80f/iB31iHFj3JMe7YWLAFAu3yiai8iBvlOjNXOsjk0=;
        b=AcdWNKrQ1R36sK8EdObUXzbup/WaCjWhvaBYfEdi3s5Dzm0ShIr+MvxfzTYkAqG8+z
         waIOeiFME01HE+MLgM9ksupUO+OfVYRQl5dPAcAOX5OmAnz4ZNtEuVz0gsgDBrNPPiP+
         dzQdazMQBSK05+AH/065mySnewwnx1Z5gWxH2lIvzj/4pq+xFvO+apir0a/tG15LLunQ
         QsIvwc8Kt+Mnoqnx9K0OH1hzoGsXU7PV6z1s5Z8bpNtxp+dL4Gf9V9olbUFrAdZBGSqz
         ZHPTqbBM89bMPB0W26IspNGz9YArHz7nJ68W9XmV8WM8IraL6hIlLlNRczPX5NYnqcov
         yDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=80f/iB31iHFj3JMe7YWLAFAu3yiai8iBvlOjNXOsjk0=;
        b=nNlTgk03s3Gp7KCUWNUQumTiQDVni2yoUeYAgZ3u8W/+pfcRuHPG6DQercqpgYi/ty
         e25JRofxBtK65vP+dkz4kr1FAfzn37QnZkdDH7/sH0FvYyglQgSj5C2h8h2wJPNW9PtM
         0HLXumwyIz20ed6HCe2apqUIBF8vWz9nxh7slExlyDG4SlnY9203w4b3/YbW478PB1Cw
         uokxPs3ysJhtjPAqTh/2zRZgIzXKY9mtjTH11zArxuK5mgtiDsJkOb4JnF+yNNUjjN5x
         JgN4Dz+8zxUEq+mS+0JVLC+9ZCFTs3eodpayyHMXbq4ulFnKjJoqyIJmWY+dvskW7u/U
         pbQg==
X-Gm-Message-State: AOAM5326AMst7zZzcCywB5prjWuPooJr5jNMXpjR7nznqYgQf24i3m7P
        2KdmcVhCbwsUFix8gbTZhJA=
X-Google-Smtp-Source: ABdhPJymGcRMTwiJF8Dxqv9mtzC4tHS1squKA6novLwIEj9wwGw+6+0FVBRwQykVLMlqilwfxDw41Q==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr2897846pjq.67.1618894421389;
        Mon, 19 Apr 2021 21:53:41 -0700 (PDT)
Received: from localhost (121-45-173-48.tpgi.com.au. [121.45.173.48])
        by smtp.gmail.com with ESMTPSA id o9sm15082251pfh.217.2021.04.19.21.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 21:53:40 -0700 (PDT)
Date:   Tue, 20 Apr 2021 14:53:37 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH] bpf: Fix backport of "bpf: restrict unknown scalars of
 mixed signed bounds for unprivileged"
Message-ID: <20210420045337.GF8178@balbir-desktop>
References: <20210419235641.5442-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419235641.5442-1-samjonas@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 04:56:41PM -0700, Samuel Mendoza-Jonas wrote:
> The 4.14 backport of 9d7eceede ("bpf: restrict unknown scalars of mixed
> signed bounds for unprivileged") adds the PTR_TO_MAP_VALUE check to the
> wrong location in adjust_ptr_min_max_vals(), most likely because 4.14
> doesn't include the commit that updates the if-statement to a
> switch-statement (aad2eeaf4 "bpf: Simplify ptr_min_max_vals adjustment").
> 
> Move the check to the proper location in adjust_ptr_min_max_vals().
> 
> Fixes: 17efa65350c5a ("bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> Reviewed-by: Ethan Chen <yishache@amazon.com>
> ---

Thanks for catching it :)

Reviewed-by: Balbir Singh <bsingharora@gmail.com>
