Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5600C3FC077
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhHaBZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239138AbhHaBZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:25:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C300C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:24:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so778909pjc.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sp9i7FrWom3xUPTd3sKmo1cpIKlGk9aPt1bnGKVC2Og=;
        b=lClC+JgSsiTpSOPxAxOIc54t8VcjuY7IUGqyDofWGc4/62PeAL4b1qUn2rULBWXXOZ
         faaoN+U67y2YB25+SRxz9u/TyyhiCR9wWc2ykz99cScvX/BBZk1FQG1F81eUSWILDqLg
         wdpM7JNNI43ofCyBPxZ6jgsLWEGYVD0y4nwttrWcaFubhLCMATLkfRWsHA2AxURCovN9
         iTwSB9d3RJgi1p+DUxJTLi3DDWMX2nejtVMseldYEalYlGlb/DVING+RwySxn78OOWW9
         t3s9GxO2ABnj0NTXUn0apwM8WB+uAAMzJOkq1PV5UqVbt07xg/EKF6ZgWBlpCByIYl91
         UWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sp9i7FrWom3xUPTd3sKmo1cpIKlGk9aPt1bnGKVC2Og=;
        b=PpgAiaE8rd4aYwyMVSHNc43Ild6NrnST8/ZBsqqxqkXKgaPYKPkQ6G7gU7bnPezj5M
         TITCt41/e6L3vyjrGRPW8qEhy0iaGm2efD0VyaUO1P1Z/2NtR1TbVE0iv7tnhHDdVsk4
         gZK7OxDmhNOWjsqNqVdXSxLphcmHFXBgqCBocl5z7FE3F08GQU9ZIJreYYQXbiKWv/vp
         8TrdjE93XCwKeHVdFiZWag0ermb3Q2tff6FIrbbojHddc8FHpBa+nVm07tZXg5lP148C
         pwRu0YRf/+sndN+20uDbxMjJVvKke3dcyZUXkfGqJ/hM1xaC1kM1lJXOPRzfnCTFn43M
         G3BQ==
X-Gm-Message-State: AOAM5314D/ZnrpKkTR3EDaAOsrQMFbqIeo/595BZDMqmdzvMUjD9Y6L6
        exZvNKog8yyzeimtfCDsaXFzrgEpnUhL6oo/oROg2g8h
X-Google-Smtp-Source: ABdhPJwnwm1RrssUxaF1LH1vbJLtr9x6EpFWEC58mmrvERjtAZiexx23b1E9AF23a4aqENs/bSUJesEBLCXVmhAb7R0=
X-Received: by 2002:a17:90b:710:: with SMTP id s16mr2244122pjz.56.1630373057784;
 Mon, 30 Aug 2021 18:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210821155327.251284-1-yan2228598786@gmail.com>
 <CAM_iQpWY4Mmf2EUPQDp0v5dj2Ch2KVRirgJXRwLea3pRnkSJVg@mail.gmail.com> <CALcyL7jQfGPfiFZzVArn1vg3_4eHzdAqhOeQbQs4kfTH_jKR1Q@mail.gmail.com>
In-Reply-To: <CALcyL7jQfGPfiFZzVArn1vg3_4eHzdAqhOeQbQs4kfTH_jKR1Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Aug 2021 18:24:06 -0700
Message-ID: <CAM_iQpVVF1-CimWWK1E4gjjnNDYsAyHz2p+_VmRjVLqNW8+LsA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx4: tcp_drop replace of tcp_drop_new
To:     =?UTF-8?B?5bCP5Lil?= <yan2228598786@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 7:52 AM =E5=B0=8F=E4=B8=A5 <yan2228598786@gmail.com=
> wrote:
>
> The main reason is to distinguish the reason for each tcp deletion, __kfr=
ee_skb is to release the skb, and it is used in more places than just the s=
kb, so it is impossible to trace the reason for the tcp deletion.

You can filter them out by 'location', which is the second parameter of
the tracepoint. Please check out the filter syntax for tracepoint here:
https://www.kernel.org/doc/html/v4.18/trace/events.html

Thanks.
