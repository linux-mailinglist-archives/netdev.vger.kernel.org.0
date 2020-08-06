Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062E823D6C9
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHFG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgHFG1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:27:12 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799F6C061574;
        Wed,  5 Aug 2020 23:27:11 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z17so24408362ill.6;
        Wed, 05 Aug 2020 23:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bJQv7/hIU631XncJKcKGFj2iQLvO+RwL3NF9aZWt2us=;
        b=dmNnnnPrnC8WifqflL4Tr88gqkFoL1sGIOzAbxlgPLroOpajfJf8PFb7dAKNhIa7F6
         ty1xj67oX5GEj38FxIR0OgJN+OT56Q+O0gwY4bUkZKUOSn1PB36kUncmLe3mWvL7qzDC
         6iBKi+6w/RH/sFHJsZH3FaddVUrVAEzGIHXcKVXvpkshlyjGgo1R5Ov2DwftVn+L0p9Y
         UqmC2kyoi4LEgiZIolD8Qc4of1gGF3B9gewGeIMwYPsHztLDxjY/08A1M8okmvfk0+KA
         n80CgGTTnrWvSS26Bv3CHfKF+CP4vCYcDwD6z4AaT9RQ/xIgBymBSUOgvO00V7+1gjYd
         nlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bJQv7/hIU631XncJKcKGFj2iQLvO+RwL3NF9aZWt2us=;
        b=kxUxgTJZLGdDNmuD5DZ9HIXXRsdg+1gDmK5yqEwtqTZFnUkA+iRjcU+mhCp+PilIt6
         tJ+z+eJGuboXMMIfdWaVhsDLuZNohhwoxPJa9OS7X6gaQIr6WV8l+Ugkw5E1jwnfxgyw
         piC9u+QgZw8XwrnQ+Jq6KWU960T5X9KQ2NKSDaR3EICV81c9T5K1J/IooUHNVE+q73x7
         00jhRrzqcV36y2DbT7H6pEJz+orSnWE2FAjsBzGTvBck4uDg9uWJDiFfNt63KT/LfSaH
         izXSokZblfDz9TJt2OCM1DRy6iZ9g9N/OX3p9uRGfEANQNsHolujLqFxTOBldq6gHarb
         iBkw==
X-Gm-Message-State: AOAM531CPZ8UXSP1AqzQ2R9v+pyNkZwv7hpCRqsfb/Vvpx8ila5uZb1O
        2ud8bRRJEYWvcPCdKy/5vxeVQ5rXk+o=
X-Google-Smtp-Source: ABdhPJxPQetjt8CxiY1NU1tB143K4bkYACq2WLMaiYxg0L4Zu58cQ1kXoGF+Q0kf3K3azVQ8Eh/aaQ==
X-Received: by 2002:a92:c8cd:: with SMTP id c13mr8840082ilq.162.1596695230821;
        Wed, 05 Aug 2020 23:27:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j13sm2917151ili.57.2020.08.05.23.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 23:27:09 -0700 (PDT)
Date:   Wed, 05 Aug 2020 23:27:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5f2ba2b6a22ac_291f2b27e574e5b885@john-XPS-13-9370.notmuch>
In-Reply-To: <20200805004757.2960750-1-andriin@fb.com>
References: <20200805004757.2960750-1-andriin@fb.com>
Subject: RE: [PATCH bpf] selftests/bpf: prevent runqslower from racing on
 building bpftool
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> runqslower's Makefile is building/installing bpftool into
> $(OUTPUT)/sbin/bpftool, which coincides with $(DEFAULT_BPFTOOL). In practice
> this means that often when building selftests from scratch (after `make
> clean`), selftests are racing with runqslower to simultaneously build bpftool
> and one of the two processes fail due to file being busy. Prevent this race by
> explicitly order-depending on $(BPFTOOL_DEFAULT).
> 
> Fixes: a2c9652f751e ("selftests: Refactor build to remove tools/lib/bpf from include path")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
