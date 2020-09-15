Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E174269B45
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIOBhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgIOBhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:37:22 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2C3C06174A;
        Mon, 14 Sep 2020 18:37:21 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x77so1375385lfa.0;
        Mon, 14 Sep 2020 18:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2zibnz+4BF41T35GCog95RFmBqfcDRt8MAolUkK7eDM=;
        b=Gky0uXPqWwb9IZjcr7YMbXi2thMLDdkBq6Vg4Jmp21DMOMH8W6yP/5h5ybDXU28tWb
         PwXBGcKempHasUflDTqrIuMYAfNwsgO/RPeNdPNvD2U92EdukG/LILCIas39UJ8CNNQX
         eH99e7wlF9eqjcVb3RWlI0HQzWsX3uIkjKN6yWveVhTycykZGZgPyU9HsLKkdnm8Ngpr
         25G9T4mLNWlkkWiw6kILEBL5UGrPjhGSB24WFBgugvIVhJVHMWJDGp+vn4NmMP+IzbqL
         CNkZYkzlGOnpYj4oGanrq5Ln88X/FfGuw2EDIj0q9MBI+omZrQtM0rYqu/Hnp8YPGAdU
         s1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2zibnz+4BF41T35GCog95RFmBqfcDRt8MAolUkK7eDM=;
        b=icYoNL5nNO20ctathh4OLIHqvRpIO5fYs4dW1QtBFjaj3STjUgD9JPGHK3QCXtK/Yd
         rvtmFiHqIlKn3hnZmywe7OtGVNK5eh/1sajdB1E7Y/mj7Z6s0oOHuGzFfWar34K7Rcp8
         wfVeWSTO/oiVLdCSPrTPvPOsZ2oYLIy5RPZAMM4ElK8Nqqf/eisd5+SU8seIyDxcYlVI
         nRlTtd1wrmjp1zDA+qPDVaxxJ3/bLKKDIREP3t4nRuYi8/zDkFvgiSiWONswG1Zj7i7F
         DlIC+ey4f3L2P4QKJCEQz+Ks6ClFI7Hr89PLi03NCi7ogODUYzfjAGT0I+aXix/emmRJ
         Vccg==
X-Gm-Message-State: AOAM532jPct8F3nfAT0mXS6Rsfw75NxTK61t2jRiRcgL4adxdIn+Cdqr
        EUWC3gllbLdosxARxUTcSugqoX/Wo9OvCD088Nk=
X-Google-Smtp-Source: ABdhPJx/Xdc3G4hn1Wg9+WckWkkoKQPmudGiMQXsIuQkLaGjD9Cd1qPrMwAQN/XVe33GWcPul8/MD1e22W8g+7rwEv0=
X-Received: by 2002:a19:8703:: with SMTP id j3mr5728530lfd.477.1600133840104;
 Mon, 14 Sep 2020 18:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200910075609.7904-1-bjorn.topel@gmail.com>
In-Reply-To: <20200910075609.7904-1-bjorn.topel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:37:08 -0700
Message-ID: <CAADnVQJ_n642Rb8vNwSBn=S8g1LVY791WmEsY_pLXfLZ=a2AUQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix number of pinned pages/umem size discrepancy
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maximmi@nvidia.com, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:56 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> For AF_XDP sockets, there was a discrepancy between the number of of
> pinned pages and the size of the umem region.
>
> The size of the umem region is used to validate the AF_XDP descriptor
> addresses. The logic that pinned the pages covered by the region only
> took whole pages into consideration, creating a mismatch between the
> size and pinned pages. A user could then pass AF_XDP addresses outside
> the range of pinned pages, but still within the size of the region,
> crashing the kernel.
>
> This change correctly calculates the number of pages to be
> pinned. Further, the size check for the aligned mode is
> simplified. Now the code simply checks if the size is divisible by the
> chunk size.
>
> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
> Reported-by: Ciara Loftus <ciara.loftus@intel.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Applied. Thanks
