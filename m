Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1338A4A2A7A
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 01:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346201AbiA2AOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 19:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344659AbiA2AOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 19:14:45 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28566C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 16:14:45 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c6so23286154ybk.3
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 16:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlX1DFysl5yN+QKlRU9bEi86sJNl5gNacm9fEWk0J24=;
        b=lzq3466kIPq2aR927eiKxclCahE3IXthSrSrgYqRznEHTqS8gBIpwyR1K2OlRY2olK
         No3gnJ3qcbWi7QmhLVzhlfBS7M1hlnv0JiuEmEYuP2pUug38EIHpOXyzl9BVAI0TbwXz
         hK2NARefoo2rcM7jSDpXVnuZCOOF2dLFm7l/MpWefimML7tH0+HmdZZfbi+tJRQUKtm+
         IZOIuG2KabpQRg2siMGnULl87WXLUeUojmB7dYz1ODG4Vkp854VijTtzHoaSCFMDvnhG
         1o3K0yyMvmTF+xL715MRcvmQaKUfQlX3w0CRp99LiLzt2DL2Kryy0WWL6wpcI6UDAHH2
         Ni4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlX1DFysl5yN+QKlRU9bEi86sJNl5gNacm9fEWk0J24=;
        b=DXkMDQMZ4vKsO0CvtVyBPB9uy7HuEXLxmSuAarYlsZVBZE6j9Gqjd0QQNvzEI0eGev
         e9xKGFf+mOmIaqViULtonWYbREPwvWFxBzBUCOAkDwfHKxw2JfWNDfVjAvFu1nSeMSjM
         X33fQ0ydqQ8DRxpzjM7TyDcXQbeFjTuCCk/PmX3xihFB3l1kSBskEn1GhhxWobX3iSza
         FFRAOCZDSUCv4nL7raRSl0HcYpwjPvPH3H3QYdzyi6H/tLhl9muuL+POFhryAhJCk4fb
         2tMOucWeOTU1zIA+4aTte7A8aQe4/ZGNIvxvTAXl8PMJHbllijX9tvWXWQNlFP7fdZKo
         egNA==
X-Gm-Message-State: AOAM530WzWsWQdCcn/GKgAZo1rGO3dLRRQQMnkSGzLDS+yTLKHBnfhwe
        KbCJBCoR6dvAdv1NfC7GFOa/a1XA5YhonJrd/qZotPpy93QsblDJ
X-Google-Smtp-Source: ABdhPJwcQuSG88CE9GvvOxG4cOBWY8MV2KaGgATRd/NvywlkfXA8ztMM8x3SfnE8d81xCZn3K2iNu8uzCRhJwIDIqZo=
X-Received: by 2002:a25:d988:: with SMTP id q130mr16064071ybg.711.1643415283884;
 Fri, 28 Jan 2022 16:14:43 -0800 (PST)
MIME-Version: 1.0
References: <20220128235347.40666-1-dsahern@kernel.org>
In-Reply-To: <20220128235347.40666-1-dsahern@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Jan 2022 16:14:32 -0800
Message-ID: <CANn89iJi7nhw0qXmF1D9=gqRW27NezPUQ_neC2nvfuYnnFycyg@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv4: Make ip_idents_reserve static
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 3:53 PM David Ahern <dsahern@kernel.org> wrote:
>
> ip_idents_reserve is only used in net/ipv4/route.c. Make it static
> and remove the export.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> ---

Thanks, this came after

commit 62f20e068ccc ipv6: use prandom_u32() for ID generation

Reviewed-by: Eric Dumazet <edumazet@google.com>
