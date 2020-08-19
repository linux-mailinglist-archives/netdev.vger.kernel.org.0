Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB322491B4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHSAPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgHSAPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:15:06 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD75C061389;
        Tue, 18 Aug 2020 17:15:06 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id i19so11144060lfj.8;
        Tue, 18 Aug 2020 17:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8NF1Vjr7ZZw1NbbT4vls4Jv5o59az/jx1xp2RwD9Jxg=;
        b=n+GfgUIPK7Teyvo1wHMLsjQ16fvfQuuryJjU1ziRRNQKdCv/thQdEnHrYoijegncZI
         eYhWGjuHgox6ODLZ2nT4QpktrrtG/PkRtxQqh3EeMgbp6zIUyUp3agvtJlSjRjfWO9N2
         sCqD2i52HSQ/3kE+GvYm7Y2r43SeZPDqw3yRrPQySjHwX7kfgLB/v4q7WXH5FurQSdBY
         vDXd3zww7vR/AHymXRXVf+wM8sfW9D+qCI+UvvDsYvD37nj2qZHddAvTJdfMfunCJoAm
         J+VCrMuV5aL7ewGovxMrY91rrzmgEiICi0FUB3HL+f88L+lUPvpSAlXdhEk2q6RQPBPc
         4kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8NF1Vjr7ZZw1NbbT4vls4Jv5o59az/jx1xp2RwD9Jxg=;
        b=j2wrQvTWyG97HIIP4kGHG631Scn2WQFC1/PsW+O/mf3RP77Ag2BChqxJRuCxg1Hc0F
         3PWI5EqIN/7jvpsQhDCi4h3/vwSVj/rUSPUn91ba5kWY0UWGSldEF8BEFhyPd3hAndrZ
         umzWCAPX02fuG0puBJE6teuftemEu6PlHqXtfIeoiAEXlIFM/uZxCOzIenXWYTMMpGiW
         hIuDT7eJCNanfT8Of2rkaWiH07/1xAOfw+OJs58ob5d1tQ/aJW/kZPwR2xkLCWnazt4J
         YNemEbmouGIaJLSQhjuEvbeX381irxOsxPg588GvNmrYkuZcGsB7Qs0zf6cwgad9jITf
         CBEQ==
X-Gm-Message-State: AOAM532TSCHseR2cO3YzbsJpAQn5+9R3uDuvX5ZPT5hyOKJeD00Aiy2W
        0EoUDc3u4tFxWrzyGQtP7akqDedTo8VYFitV1rE=
X-Google-Smtp-Source: ABdhPJxzo3xuj+AHMlvFTEq8+oo1TtrpXZXF1vepNakbGPsoRJOXEAws/uLXBrj3A26IZwIwohzTqYMx+24obsjFask=
X-Received: by 2002:a19:cc3:: with SMTP id 186mr11096860lfm.134.1597796104962;
 Tue, 18 Aug 2020 17:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200818083939.3592763-1-zenczykowski@gmail.com>
In-Reply-To: <20200818083939.3592763-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 17:14:53 -0700
Message-ID: <CAADnVQLbH2zdFryjqy=U1CEXEjmj6WxTV-d2zOS1eHR=b11pTA@mail.gmail.com>
Subject: Re: [PATCH bpf] net-tun: add type safety to tun_xdp_to_ptr() and tun_ptr_to_xdp()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 1:39 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Test: builds
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

I know it's a trivial patch, but please provide a proper commit log and exp=
lain
_why_ this type safety is necessary.
Also pls use email subject with [PATCH bpf-next]
