Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D134C49D9E3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiA0FPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiA0FPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:15:13 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5131C06161C;
        Wed, 26 Jan 2022 21:15:12 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id v67so3816380oie.9;
        Wed, 26 Jan 2022 21:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K6hzzmXUzUr1wVMcX2AK5jYtmErlnqVu/E2ciSn75Yo=;
        b=Y+InPXkk6HpwP7r0lz6XyunAwwXbJxITYQ0mE7PHoYggN3Ut/bY3+7YLJaZeAzT+hI
         9sM1gIPq74T32P7HYG7HS61zr7FGeV8VTcaxidkwM6jKXZkhYK/Bl2tBfsJoAW9CtRQY
         FhP3ODtM0CkjmSAlNB+q5Z9Zoqz5t8eVwcDlWOiKHlmUrlv+ZIxZFp/UDvWpulUwmMR1
         g8HUQNSoTfHWwaOtq5Bfbc3SJaQAo5O0yNB/0PvwuJxH60jUH07JuiikAqJMur68v50e
         +qTIo0fBtb/sQS+4qHVVY1GSK4fyywmnBdidRqMarJ1XN7jGqpkmdyMJ57Mgw8GadJ1P
         xMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K6hzzmXUzUr1wVMcX2AK5jYtmErlnqVu/E2ciSn75Yo=;
        b=W3pnIFOdWrkBAVtYEoVxT9L8Tpj1+vOJzwX6LoNHIKWis9wvFVhalU+aESFo5bITjI
         kKEabs0kuwVw6UXEQ9rZH3VJ2YOoJoK3O2FpJx+gsXVDQifkfRJOvNP2uFjMSjJWcxTl
         oB1/TQfKhAdq5HP7Asd8jwnvy8SMxIBWkwLCyBLHlnpQiDH+NPDxCL1qu64x++49EQAE
         /MfPaEvPvnWBsMByaaVhNZxmslcdMRHLMDiytVPIJeovtN+xc6pnCqSs2vzCNYxb+JMu
         uBhZlXMow8V/+KMUlhpkml/Tjvr9qXFSXKPN49i21YyjyMfH9gHXuRUWzsiVs990vaV+
         wDrw==
X-Gm-Message-State: AOAM533EcMxVp94T2pzNvcoIKENGfdBwjyRaBZJQ9+JO7qssh1UJfVZV
        djblqDMViSJ6Z4QA7adJgb8=
X-Google-Smtp-Source: ABdhPJzptyip54yYdxEOuHG7xIRj5yiQ+98I0VHFgiXS155p9hiRjZa39DlreaAAJZiXXeTb28C+Yg==
X-Received: by 2002:aca:c056:: with SMTP id q83mr6028471oif.294.1643260512276;
        Wed, 26 Jan 2022 21:15:12 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id n66sm8720783oif.35.2022.01.26.21.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 21:15:11 -0800 (PST)
Date:   Wed, 26 Jan 2022 21:15:04 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, hawk@kernel.org, bpf@vger.kernel.org
Message-ID: <61f22a5863695_57f03208a8@john.notmuch>
In-Reply-To: <20220126185412.2776254-1-kuba@kernel.org>
References: <20220126185412.2776254-1-kuba@kernel.org>
Subject: RE: [PATCH bpf-next] bpf: remove unused static inlines
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Remove two dead stubs, sk_msg_clear_meta() was never
> used, use of xskq_cons_is_full() got replaced by
> xsk_tx_writeable() in v5.10.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
