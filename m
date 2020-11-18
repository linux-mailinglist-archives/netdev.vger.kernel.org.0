Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF432B7A56
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgKRJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgKRJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:26:43 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1778FC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 01:26:43 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id t9so1223966edq.8
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 01:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qJZDTmGQCMRrHgGITDBSvnJ9kgXzD9M/FJ4rVuEjmck=;
        b=L/zm4azh+KpuVC1kELj+T04nSVtHuTCWbPnVfKg9mM97hpCSOrs28XHTYdr0o1D7d3
         o1FlxqO644ilGsd0vpHzjDSG+Sh+qgErbM3RYB499TtS1wI9bSTeDFy1GZK/P2aoWyyq
         SoS2WAZFNwOyRZBm3xuYJ3Z3lDeSwQgbxip89MM3g5q5kTyZqjtNvKngAqBbnMS7tqYd
         46oOwNxrXqp+R0fVd9hcy8ekap0HgIEeB+38jzawdpWcdlUlhX8gfcI4yJlpGLh1xvvU
         cChqFz6ZBACpycxFbyo7qXrKuq17b/CByaFJX2NKNhbgXQxFo/AVTXruCVa4fP7fUjz8
         yA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJZDTmGQCMRrHgGITDBSvnJ9kgXzD9M/FJ4rVuEjmck=;
        b=rdBqxdr8FUzVeSjyf3cjisM6QWLHx9R6iSoQ3S/kN3PhtCUUKiN3y0pwZN5rmr+/E1
         OfPDf1CRHh466abMllnv2ztIccU8AL1dxnGjH948/A11j0C3ExAspXi7NKwaL+s43nJA
         0vQi0Ekd8HW6jBv7nq6hl/B9TV310AACrCp+zpnfp6YtnGEKLwAUN1oyfLfYnVWFwfG3
         y7VELj4SLrNUOI92a2KNG7FumFwoHSMF3xvTI/OSE6YkdZpqevnK4F37wFDzl8a9HPiE
         wBE86Q5jWWwVaKyKVUF70u++ELFM9GNt1dhNGgBxzxBqohg0QgHhhK4u0O0IvYN5bpxN
         uk5g==
X-Gm-Message-State: AOAM5307WczBQFOGkjBR5FDVgOdUAte313IIRd7cjWSrj+9Q1Jfl2jL2
        cE5OScbYbFgEXFZqy+e6q1VotK7zsoEuiQueqi+m9w==
X-Google-Smtp-Source: ABdhPJwxLU/BF5kVXKEXzqyaTfPwvnucxLiPgj3g7d2ft6NwROtC2mysLW+buBXL/VQ4fRYDhktE03vGdsoWkwgNuMc=
X-Received: by 2002:a05:6402:8cc:: with SMTP id d12mr25215161edz.134.1605691601760;
 Wed, 18 Nov 2020 01:26:41 -0800 (PST)
MIME-Version: 1.0
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org> <1605566782-38013-2-git-send-email-hemantk@codeaurora.org>
In-Reply-To: <1605566782-38013-2-git-send-email-hemantk@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 18 Nov 2020 10:32:45 +0100
Message-ID: <CAMZdPi-qxKgs==kXXuSY3Y-GTfcGb7WjQuzn3tXMt2NZNuzriA@mail.gmail.com>
Subject: Re: [PATCH v12 1/5] bus: mhi: core: Add helper API to return number
 of free TREs
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 at 23:46, Hemant Kumar <hemantk@codeaurora.org> wrote:
>
> Introduce mhi_get_free_desc_count() API to return number
> of TREs available to queue buffer. MHI clients can use this
> API to know before hand if ring is full without calling queue
> API.
>
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

In case this series get new comments to address, I would suggest
merging that patch in mhi-next separately so that other drivers can
start benefiting this function (I would like to use it in mhi-net).

Regards,
Loic
