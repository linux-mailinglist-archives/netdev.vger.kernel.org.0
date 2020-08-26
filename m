Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7030C253A31
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHZWR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:17:56 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0449DC061574;
        Wed, 26 Aug 2020 15:17:55 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id j15so1835235lfg.7;
        Wed, 26 Aug 2020 15:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K7Hecs4aHpf0EzIwFooIRvYeF1W2QFfvxqRllaJSvCM=;
        b=mwbrZQtRCAevkVfZNMT28nEAX1ZJFnhD/wCtG+cWvDjdkE+J3o7x2izUClQP3p6UCE
         8iVq479vM2LWkYVBGFCKe+e/MuBjRW3nrkvM5KHtFNAahIh+d5qS2Ijn2nsiLBXNHRPH
         poFZ8dmFPgyoPtlnENTobh1J2J/v53u/U/Pxwf/BEg2Kr3PoA1ZTwimFI8LngUuQTwiw
         cslvYE4aILqVVOmPIeCdZPn/vdIcSL2RUzvxxZY1zT0RGYMBXkuk1cZDgYUvMoUXI6Wc
         IqDniZIzWr7gLaKFVB1mW67v0swIkjoXIPiWWKOckOx3i7TKPnQSCBhTsOWX8iWgdAbz
         brxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K7Hecs4aHpf0EzIwFooIRvYeF1W2QFfvxqRllaJSvCM=;
        b=ctrxJoP4KPDghdI6fRuqHpJukPRNKDVk+mo50SluzQhnGEV9Aw1rAz3jQWcguJQeg+
         zJcZXfXLuid9ezG1Nf6fX+Jjl5XQ9M42nkJxoSWHJA/pyz/4isxnjZpLOAMNsdw+gwPJ
         XmtSh3uYmxxuGdKvJ7rwMRkNFdx3lYJW0qEf53OvKtEliyJrCBZsiHFW7hTo0MoSe8kz
         4mUxbNgTc7aP507OqUmKDQxaym0blvG6jsTgwVcit69EtkM7psXHtSEk93MNHDycY6ex
         IlGi7gbqjJgLilDJzbWy8Am33opu6i58eBqU3o87OIj0n6KtFAKkKpFFEQfyl6z9x+aM
         ULRw==
X-Gm-Message-State: AOAM532AP9S1+4WSFZgSos21HYHQmkU2PYeeEzxVc+y+mK9LeUcQQQqX
        wXnICiJ2mQeOmgNgqumRRh1yz+sLVeI6DTFtEGw=
X-Google-Smtp-Source: ABdhPJxJUcmgEj0cxGOxg1Y6+mFkRH8Rcd22L8A2NuXlIbXCGLOlx0ypWlV55n1I23vLpWCRfzXy26Z6GlKKyas0aRQ=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr8261805lfs.8.1598480271930;
 Wed, 26 Aug 2020 15:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200826075549.1858580-1-alexgartrell@gmail.com>
In-Reply-To: <20200826075549.1858580-1-alexgartrell@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Aug 2020 15:17:40 -0700
Message-ID: <CAADnVQJ11XYCRpx23Oq8WZ18KqCde786J1Zk_KuywyMx1hzQKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix unintentional success return code in bpf_object__load
To:     Alex Gartrell <alexgartrell@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 12:56 AM Alex Gartrell <alexgartrell@gmail.com> wrote:
>
> There are code paths where EINVAL is returned directly without setting
> errno. In that case, errno could be 0, which would mask the
> failure. For example, if a careless programmer set log_level to 10000
> out of laziness, they would have to spend a long time trying to figure
> out why.
>
> Fixes: 4f33ddb4e3e2 ("libbpf: Propagate EPERM to caller on program load")
> Signed-off-by: Alex Gartrell <alexgartrell@gmail.com>

Applied. Thanks
