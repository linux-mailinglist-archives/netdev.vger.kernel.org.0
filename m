Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAFF3CB013
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhGPAbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhGPAbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:31:34 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C230AC06175F;
        Thu, 15 Jul 2021 17:28:38 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u13so13034957lfs.11;
        Thu, 15 Jul 2021 17:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yD77dnn4651Xnc0nAi85W2uxy3EOP0ioN8sLJWpXNq0=;
        b=a70Qpv8uQlHDs3GuHqIccJSx3dQeS4f4wJ/pnCaM+PVtxqT+WTSZJxA7vL6y6JdJ3s
         HbwQ/WNWMO1mVJSzjvyP8XHeBBMhZfsIxSu4TvrOO/TyQ9ov0fG4sSSb1q3wJ7K+qVQT
         EXYWsJp5ZoFgXGhOFtmO7GQ9zsZGoee7goiNu8jM+mntaS9frXG0sBIJCx7IifeQ+89c
         URXb0Vuxnq2vUj4YQozDE70WmBYPT58eJMSGeWXEE1eKRHhjuao804AAiGyY1DfsPOdj
         ryE6EEGIufy3afeG1oJD+i2o8cB+9AwbgfY22VGOgX1skEYnFy1Hy5BdGvEspIxH34cf
         fVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yD77dnn4651Xnc0nAi85W2uxy3EOP0ioN8sLJWpXNq0=;
        b=bXAu/OkVPbCXxqCGcmKqg6wQbeJzPYjpWYVqel1fU4QqlwAEAEKjOHZsfmaLO9vlvV
         AKIejI9WnfK9wVqAwHMIhdZyly1D3EY0AhmTMGKiSa5ek8d5qMPnlhhSDcRVyWPlJlLy
         f8esz8FCeib7LbrHHc5eAgqf43Fz33T7sjN9W4f5+ErX/Mys4N6jfPuQm+19zuieNI+G
         076eiua1jRTUPPBgm5fzBNazVVhwtTzHd1jiGos4h74mUJb4uBNgnhP7Ae6UQbScubA2
         JeSQw10CxzylwLkUFeEtcsxlZR5GOjJAK0RW3W7LEKbIrMGbQG0Z5f4yuGJ4PGwvfug8
         W2tg==
X-Gm-Message-State: AOAM531H3d3ujFle8JMNX5RnlbrZBSMf4Aj4tBIgwmKDnjNsTGBnGaon
        dhS0hY/TpEBdphT+/lnW75qYgkQPspQas4+02AQ=
X-Google-Smtp-Source: ABdhPJyEfGr277L08TnzJByi1W+0tKNHjFnFQLHbNBLZw/jk/ppClB1ud+hVVGkcC4D4mBTRbRm3mUYrSo+pZgTJNHM=
X-Received: by 2002:ac2:5ddb:: with SMTP id x27mr5440716lfq.539.1626395317195;
 Thu, 15 Jul 2021 17:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <CABX6iNp=u+QNRGjHFMBFosTJ4a8xkDUnSD9G35EqKCW2JvFc_w@mail.gmail.com>
In-Reply-To: <CABX6iNp=u+QNRGjHFMBFosTJ4a8xkDUnSD9G35EqKCW2JvFc_w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Jul 2021 17:28:26 -0700
Message-ID: <CAADnVQLu3HkAVgJRmjgU1XFbCS+GOhsyTJdGcDU2iJnzAOiwKw@mail.gmail.com>
Subject: Re: Appending the INT meta data and header in end host
To:     Sandesh Dhawaskar Sathyanarayana 
        <Sandesh.DhawaskarSathyanarayana@colorado.edu>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Lapukhov <petr@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 5:27 PM Sandesh Dhawaskar Sathyanarayana
<Sandesh.DhawaskarSathyanarayana@colorado.edu> wrote:
>
> Hi Alexei,
>
> Sorry I should have been more clear.

please do NOT top post.
