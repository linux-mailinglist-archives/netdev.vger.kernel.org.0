Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3E52C5971
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403877AbgKZQoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403862AbgKZQoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:44:12 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3766C061A04
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:44:11 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id t4so2778398wrr.12
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cd7iNQed0zlJwSeDfpiUl39uv1gJodD4NzCVOu8rCLs=;
        b=fAOYntqjNSrmZCwKFUIYdAFgeo+8pFj+pDznCxjxqeJdUzBJ/0eMOlnLYFOU8NqK3Y
         HlUHqRm9tqTPXXGghmEX5SORn5DSzu2nfA2JTibhv0xMElsW3qEU/uh8qLNiaeWmkxtZ
         Rb7pgkmYZj/F55O9vuMC6rivibeoTzHQwaVpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cd7iNQed0zlJwSeDfpiUl39uv1gJodD4NzCVOu8rCLs=;
        b=cdvI02FgQg8dXwurwaLj/2H+hl1VrH4ejEOHvxaO6nFe0/2Yd9QkMcueDGmcUNPqO+
         STjnoWUrvjEzL3hSZIZ5hCFmtH6YMxODvvJmkQDAgGKrxWA56naaum9n28v5JZcWvKXh
         YnDb2ue0c8au6Mbse1AExvJU+UserWaFszosuZ6EgFfTTvug7N82S7ak/zGRisJukGIq
         tOkKZXqV8BtwhLeJJJ6/5oiZsoYVjMmP2v7tajYN1OmxhZQsIuN25hLA48aYbwwbw96n
         FF+LB4FjukwVl9mX7aGvNRft9MHIcgSQKRWS0yb/ue03TGeSSQrRA2mL+FF0uu2iYZVD
         GhJw==
X-Gm-Message-State: AOAM531R2oDibjOW4ArpQiAPlUmNyPsew4KdLvXqHAYVq+iyYWuh7qgl
        nghggPt8ghVZj5BQkN3u0H75rQ==
X-Google-Smtp-Source: ABdhPJzCECSTqybxZwNMLU3z8wPPcNZPtnErYQbKZEh9rgbFgJqc+U0CS3Js0s4gt/MwduQ4oqGH3Q==
X-Received: by 2002:adf:f181:: with SMTP id h1mr4829890wro.267.1606409050689;
        Thu, 26 Nov 2020 08:44:10 -0800 (PST)
Received: from ?IPv6:2a04:ee41:4:1318:ea45:a00:4d43:48fc? ([2a04:ee41:4:1318:ea45:a00:4d43:48fc])
        by smtp.gmail.com with ESMTPSA id v7sm2871733wma.26.2020.11.26.08.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 08:44:10 -0800 (PST)
Message-ID: <7893b7adbe4a3e676b329cb0d88cf315217686b2.camel@chromium.org>
Subject: Re: [PATCH v2 5/5] bpf: Add an iterator selftest for
 bpf_sk_storage_get
From:   Florent Revest <revest@chromium.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, viro@zeniv.linux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 26 Nov 2020 17:44:09 +0100
In-Reply-To: <20201120003217.pnqu66467punkjln@kafai-mbp.dhcp.thefacebook.com>
References: <20201119162654.2410685-1-revest@chromium.org>
         <20201119162654.2410685-5-revest@chromium.org>
         <20201120003217.pnqu66467punkjln@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-19 at 16:32 -0800, Martin KaFai Lau wrote:
> Does it affect all sk(s) in the system?  Can it be limited to
> the sk that the test is testing?

Oh I just realized I haven't answered you here yet! Thanks for the
reviews. :D I'm sending a v3 addressing your comments

