Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA86D2FC362
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbhASW0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbhASWZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:25:47 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4015DC061573;
        Tue, 19 Jan 2021 14:25:07 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e22so19260988iog.6;
        Tue, 19 Jan 2021 14:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ndPJv3Dw3hEVsrNkrtY/IVB4dfqRQo8AR2YeLgGSV8Q=;
        b=uSxmwspGjZr3sg7ZtZX+R62Cz+izxPpOKr/8+TOLpQK8Qm+dBd3/jZ+7CSfCkUKBxH
         BiUzDMC8nBbwp8BdE4pEr5dXctv75CaWerpeawQ3cS1SnyZI/bPNeGKDT6a1LWO32quC
         HOlRiRKgNcnhDRIkF24PAF49Ii6YIhlGhfbOgaywMoYyS6x7KCN0xbDQwS0y7skmqNRS
         7chM4l+Tb193l11F6Qp40l1A4YOdS6aJ89hULgO24GEQ8JvjvVCyMryhUxYnKlKXaj8n
         2hUZnbGdUteWybqUtaNIDkr3ZHGe0l76etk9zBxIezthScy35M7lMW3i7PTLbOfZObzw
         7C7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndPJv3Dw3hEVsrNkrtY/IVB4dfqRQo8AR2YeLgGSV8Q=;
        b=CDHHvigJ5ZXuvIamv/THcROPmdLLt0xrvNlUIop568QoVIqs6Y0DhjlmQirhwVU2eL
         odwwpyt31JEarWI4bB/bPMqG7g7viJLZbT92BR/L4tmLJV6DEwqI0AaWIGtgNjN/RTCK
         BdPk+yq9BmJS1xk0DSE5fPQ5Ra6JVlJ4qvWIzoDYbmOfuadHuq/6yzExsTejbHDKkwnQ
         kOqqjtr6n4X7B+ZUxBVOe9w6qN5ezUaL6AmJr4V9ero+G0Fyb4aTNhxNHs7CCG48dHh4
         fxk7+9MYnfGaYeQh4zYoQWa4FZdMLXQLc7V9RTGXW8E/ZIb6QBYeY9ZcABf73+ZMDWDa
         0tKw==
X-Gm-Message-State: AOAM530KsiSi1x7nsDWPfI6Qqba7rIV3Hbg99G+mYOeXQnjisPaHrP50
        6aIA7ldVZTHpBCwO1jAPlWW/zWOjKvQK7tJ6V8U=
X-Google-Smtp-Source: ABdhPJxK3WlkOvjAsX/EJ3DIYudw0vPbWcTMp69mqLZxo+grxUhO2VsmDET9jhsG2bO7BoZcM8bS9Yj32Of6/nul0Xk=
X-Received: by 2002:a05:6e02:c6:: with SMTP id r6mr5165205ilq.95.1611095106618;
 Tue, 19 Jan 2021 14:25:06 -0800 (PST)
MIME-Version: 1.0
References: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <cover.1610777159.git.lucien.xin@gmail.com> <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
 <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:24:55 -0800
Message-ID: <CAKgT0UeKRDNX_GHsGUh4fLCDni80Ysxms+P2ac1HeZwcG5zkdA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: igc: use skb_csum_is_sctp instead of
 protocol check
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
> checksum offload packet, and yet it also makes igc support SCTP
> CRC checksum offload for UDP and GRE encapped packets, just as it
> does in igb driver.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
