Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBCB228543
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgGUQ0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgGUQ0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:26:15 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF9EC0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:26:15 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 11so10449525qkn.2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBP7qP0FYUChGaa0hrCulaczX/efODgBvnjZrXBVhPI=;
        b=nUKUr55EXExbEWdGOSEgTubGim/24Vyuixpdf0xLuViukQ1HYqXJ7wLSsx+StUT43t
         K7S55wPrevvD8wkT/jrhclLmMejSUMDLw/wfvqShS0D/yhLD7MZQeo5BKdYi4rR98vdh
         A4Abp/qboL4FVZMjQwFlFG/Qg49E4D6cnF+/nV1uHLYdZC2dmvQK1VAuuU6ef+ygSSnQ
         8nE6dM9lGyZyn4qkp8Fh/bl8PGghxxHCR1zTT9HnL1uv9lfgENAOh4F46b94eDP/ywhC
         fHczpcKRfaXaS77iH+rIzwkD7Z+il6u/vAyKFt8XUshWYfbGW0VPWA07ft3AHzYXsQOH
         rEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBP7qP0FYUChGaa0hrCulaczX/efODgBvnjZrXBVhPI=;
        b=HFXVsiHrOctrln0xqKDiE1PZb0CD0J7qsPD994Lml2vNw9zRUUm0fRhjIUQmdyrYWA
         1hacJseK7FXpWYrVZjZ3XZoyB9TyV5xiPQ4pDTcz3kOescM4crgWaXdz8hNfvn4PVRE+
         DHOeRnaKIi/dmUL2AI0LWTjQd8ttTh6F7wiN07dwLhaHC1a2CFdS3apio56COGPXcM6c
         Y7YQWaCG9b4oDUrCd6fwg2EHbThQvs2PVZwI/K+Kn6cVPA+zyX1AoboSw9FUAqZYiwjj
         PfYVzqix6uPqwZMbw0CnMpEhVefb9grKQtGCNG4bxA2yvL7/Kj0w/CUqmHi5U/Y6Q6gz
         eCTw==
X-Gm-Message-State: AOAM530yvxZbGyEoOC2AQ8FwSshwXG1S9E2k6b9B8/6mR8HEhBUGhOZe
        mi89vRzeuHRLHpCfYgkcBAuSkAPz
X-Google-Smtp-Source: ABdhPJyJKBRtGN53s8A5Eb/5ScXfQ9C4ztDbmyoo8ryDPIg/qIsyMaiQln+5qYR2FKabCwxcFi916Q==
X-Received: by 2002:a37:bd06:: with SMTP id n6mr26254723qkf.344.1595348773620;
        Tue, 21 Jul 2020 09:26:13 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id c18sm553358qtb.51.2020.07.21.09.26.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 09:26:12 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id v9so10280411ybe.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:26:12 -0700 (PDT)
X-Received: by 2002:a25:6d87:: with SMTP id i129mr42670421ybc.315.1595348772036;
 Tue, 21 Jul 2020 09:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
 <20200721161710.80797-1-paolo.pisati@canonical.com>
In-Reply-To: <20200721161710.80797-1-paolo.pisati@canonical.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 21 Jul 2020 12:25:36 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe1-ZEC5xEXXbT=cbN6eAK1NXXKJ3f2Gz_v3gQyh2SkjA@mail.gmail.com>
Message-ID: <CA+FuTSe1-ZEC5xEXXbT=cbN6eAK1NXXKJ3f2Gz_v3gQyh2SkjA@mail.gmail.com>
Subject: Re: [PATCH v2] selftest: txtimestamp: fix net ns entry logic
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 12:17 PM Paolo Pisati
<paolo.pisati@canonical.com> wrote:
>
> According to 'man 8 ip-netns', if `ip netns identify` returns an empty string,
> there's no net namespace associated with current PID: fix the net ns entrance
> logic.
>
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

Fixes: cda261f421ba ("selftests: add txtimestamp kselftest")

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for the fix.
