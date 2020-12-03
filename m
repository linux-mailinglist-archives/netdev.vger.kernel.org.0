Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDB22CCE18
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgLCEwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgLCEwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:52:19 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF4DC061A4D;
        Wed,  2 Dec 2020 20:51:39 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id y24so650964otk.3;
        Wed, 02 Dec 2020 20:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+3vG37t4H4id7G0zM27/WGVWYWCjdjaPOKX2kSDfr3U=;
        b=clM75I0WcYBubM8uIKYMKwBBVokaFxFt0BTw+dbubJ+4l7aZnQuXocU6LaqTosFOTr
         w91CwmPIcyfiNFl3TsivpkH1AdiXpFnzr+z+GlEL5ve/hGi4Hln4CP8ZZK1/LkcLQUaI
         t8mxUXLeSJwce4rNey2Bz2YVoHm1KsT7hnEdvKz0IJqMhJPb0CaFhxxuFdxn+nd+WeFP
         CgZAYSqqtEl7UJLLKFOsDXrP8+ghKd6bAvM8rKu52YGeIc3pcPnim2sP/SIg6AG0wMhm
         w6xv8fzhZoVVjKf+ChR43r9uZr6uC68wzQKTRalJGai83DXCsk8/iAkF8zYRjDBuVVpC
         2UUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+3vG37t4H4id7G0zM27/WGVWYWCjdjaPOKX2kSDfr3U=;
        b=YNjWRqMFdL4edRuLb4zumRdaoDKTjyC3lClls132l+4omhXGR52WqDbBtrXIQ3HPb9
         GwNZgrnjZcomKHCmPVOKuYZR4ByVIYcsrPGokuURQ3I1bf+j6RoaHs7YuVreZiIOKUnh
         oL800i9GJHNfjJlWTE5Npk7vwgHKrjitHPPLaaIbWIlGrYHAqwf7OxM0jpYWdLOqbg/q
         WfXwOasBX9U3z+RcUiVhq2+l8ZI9VAXV7FX4rYqfU+Bh35DK+Vk+qH6oGmiJcZMvZok/
         18UIaeGlgf3DRP3c121xjpOIGe1/GMin9NV3x8afc7ajiOkbUn3ws67eSBdIhXhoYKzH
         Bn5A==
X-Gm-Message-State: AOAM5325cdflg+uIUMsCQBfA7nnavnik4i6uGddtQoJwfpMl8fdV2ay6
        4QBBkyyb+lLB7Vhe7fkLMrQ=
X-Google-Smtp-Source: ABdhPJxxaFtBrwJlHxh8AKNGzX7gyFG0vygVE5Zz9iPGQIH/yWajmbeiIldAGorKqfgr0st71aXStA==
X-Received: by 2002:a9d:4804:: with SMTP id c4mr929720otf.97.1606971098629;
        Wed, 02 Dec 2020 20:51:38 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id y8sm251943ota.64.2020.12.02.20.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 20:51:38 -0800 (PST)
Date:   Wed, 02 Dec 2020 20:51:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com
Message-ID: <5fc86ed1c3cfb_1123e208ab@john-XPS-13-9370.notmuch>
In-Reply-To: <20201203035204.1411380-4-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
 <20201203035204.1411380-4-andrii@kernel.org>
Subject: RE: [PATCH v5 bpf-next 03/14] libbpf: add internal helper to load BTF
 data by FD
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add a btf_get_from_fd() helper, which constructs struct btf from in-kernel BTF
> data by FD. This is used for loading module BTFs.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
