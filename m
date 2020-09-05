Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A109925E6A5
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 11:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIEJPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 05:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIEJPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 05:15:48 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE17AC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 02:15:47 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id b123so4922168vsd.10
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 02:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1RoDZrCWPX9A0Bk3ax7/cbjBpHqEVKLKIuXHwkDH7VY=;
        b=jnRFSPOIWRG2Az8sol67J1hDxmLVRPM20yv2mennfOoWjr0SITUs8sjVw/xh0Me1KW
         Hl8chs6DT9V2oF1z7LooGgyWsEEDfhEFOW+/WahvIMtbrzegRR0lZbsUl0Ov44usDWj3
         vpwPKWIterWDkyKWo5gdP+OgOf41YthTPejZkD0nKoWa8Z8Vk1jJ2i98gbPFNz/+jZml
         vnrjVaZTV5omAlKp/t3O9gi0l6VrnpqlMXcDcS3yZ3WlaZOq/BCibtSf/XCN8siMeDyc
         Fjt8u+Cyf0PB4Q2wjArjU510CMelh7vqJ9HOd3oRXU1YOpy+23pqtyIuxpZgN8LDvn11
         pmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RoDZrCWPX9A0Bk3ax7/cbjBpHqEVKLKIuXHwkDH7VY=;
        b=CjpOn24m2GgZw1quYC4E53+VzVx9T9oGVS9NSAQwgujHGIgkGxxKGBZfuWEKXD+G0r
         GzZtRqPavUPZwG/ICL/m7eeh1qgZ0SGreUKev6dEXvT0OFjXxGRIEN+7CuGR3Bpl6EoG
         n2KenroFKGf74rWHK93j2SR7qDHq0q2Ewm5INEZlshAMiJjzIifhHtwooOaD8HEeTfpK
         bQybT+IT9JuYPnlrAx+df5oZfEh/Cg0+cIlmS7V5Q86Q2fe5dLoGWWxstq5DhuM0HYGB
         Y9hn6xwEnXlMypvAT0Q2D3Jdk8zcil8hEilhSjdHF3Kcq4OYYtkp305qdRMie3xJrbZw
         wWww==
X-Gm-Message-State: AOAM53169u4kbS50/D/pF9vcrAkLcac8tLHRaqGn5jG1ZHDrUhLqfADd
        Z7vRLT4J8Ncjqci2LgNg9h2XwSy9dKB6OA==
X-Google-Smtp-Source: ABdhPJwv5qldIpZuc8bVjPNxKgRlYUB+/XpDdx2BCyruOjfcM3PJJZU0MpGSjp7QXOWESvQv1SvgsQ==
X-Received: by 2002:a05:6102:80d:: with SMTP id g13mr8178334vsb.108.1599297344440;
        Sat, 05 Sep 2020 02:15:44 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id l8sm390880vsb.1.2020.09.05.02.15.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 02:15:43 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id j188so4946561vsd.2
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 02:15:43 -0700 (PDT)
X-Received: by 2002:a67:ebc4:: with SMTP id y4mr8214457vso.119.1599297342417;
 Sat, 05 Sep 2020 02:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200905085058.68312-1-wanghai38@huawei.com>
In-Reply-To: <20200905085058.68312-1-wanghai38@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 5 Sep 2020 11:15:05 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfWP+=Lm8h_PLNsrAaV5s-ACbS=YMBqjy=UpCuDEMhzKA@mail.gmail.com>
Message-ID: <CA+FuTSfWP+=Lm8h_PLNsrAaV5s-ACbS=YMBqjy=UpCuDEMhzKA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/packet: Remove unused macro BLOCK_PRIV
To:     Wang Hai <wanghai38@huawei.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Mao Wenan <maowenan@huawei.com>, jrosen@cisco.com,
        Arnd Bergmann <arnd@arndb.de>,
        Colin King <colin.king@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 10:53 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> BLOCK_PRIV is never used after it was introduced.
> So better to remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Acked-by: Willem de Bruijn <willemb@google.com>
