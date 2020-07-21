Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3F1227CD2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgGUKVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGUKVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:21:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492B2C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:21:36 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so20550380wrj.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=oJ7MRpiw+iTSL8WvnHtt7TFDU0lu71kFFSR8GrqMDDg=;
        b=uCFqHNtN85MUxvO4A1kcjM1McIXmvOrnRTH/YFkEekQmOIvOED9d/sDWx8UjlybZqY
         pb/srWm2LbgoRNYwHyejMYgPgt+2Z8DT3az9Z5JdgnKkGpXkOJzSc6m9ZwG57vsosfW5
         PN/+I1JVtbFm2kPXlj/tNpQw5epLiOLrMBV4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=oJ7MRpiw+iTSL8WvnHtt7TFDU0lu71kFFSR8GrqMDDg=;
        b=UMC8FIKNTIpcxInXK1xkb2pRPIC0qsfRBHOzmxF52Pt4k/ef55gs3KO+vzJlNMzeAl
         d8EH2JtqG3piRqgDtj28sTBE4jIfN3jI7Sh3UBYfsPfu5biduU/hSSyeZfzWynekngB3
         urTuIlliZ948xWnH9AVC3oTqBKydpRHWcRxn5YtmDqMx+3t60Nh6cH4Dd9rRESSE8MNF
         6t3sKtbwLegfkQOO9GDHelfJi8QsK0/jhhY0AMjG2l4Uh5bcy4PD4qRX2pO0zHMR+LKs
         nudHvx5d8kqmjpOktfbcj7rXAuOWGXS3PKS11eA0/cbIPrI/8mHlsOMjiCPgVzLrAboh
         0v5w==
X-Gm-Message-State: AOAM532sxOrzRMSm06KTfE5GY3Z/gZbaeHQKMpqLKODPAjLQUJpOluof
        chQW82nkQfFfcDszJnLlzKEzTjHbVGA=
X-Google-Smtp-Source: ABdhPJw3FKL17gc4iiyZ5KSdU0Ut/TTW6seduJPa0Kl86zVqYX2pOvCQpeORoz9Q5TU2gwEu1T1BWw==
X-Received: by 2002:adf:e6c1:: with SMTP id y1mr27943211wrm.116.1595326894988;
        Tue, 21 Jul 2020 03:21:34 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w14sm36317465wrt.55.2020.07.21.03.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:21:34 -0700 (PDT)
References: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org> <874kq2y2cy.fsf@cloudflare.com> <a77cf1a2-6dc8-0a3c-3bb8-d2d9681ccb8f@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, kuba@kernel.org
Subject: Re: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
In-reply-to: <a77cf1a2-6dc8-0a3c-3bb8-d2d9681ccb8f@gmail.com>
Date:   Tue, 21 Jul 2020 12:21:33 +0200
Message-ID: <871rl5xj6a.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 05:45 PM CEST, David Ahern wrote:
> On 7/20/20 3:14 AM, Jakub Sitnicki wrote:
>> I realize it's a code move, but fd == 0 is a valid descriptor number.
>
> this follows the decision made for devmap entries in that fd == 0 is NOT
> a valid program fd.

Surprising. Thanks for clarifying.
