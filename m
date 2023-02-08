Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BF168E5C1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBHCD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBHCD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:03:58 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E430A26858;
        Tue,  7 Feb 2023 18:03:56 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ee13so12015559edb.5;
        Tue, 07 Feb 2023 18:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TPQ2rAVVzlry8MPoszFMtQmu5p8pbG1Xujz8m2bINEo=;
        b=EUYewLlJNgNQAL8t48+KfKzLWoFHj2VZknMfGdTJpSKqiwksiOHMkct1HiYq8GXxvL
         mmNnjaQ0L02odSByPxIE9p9MBTxP4uf718kC0w6UIXcXZcj45MHUyQg2+H/fGxuPB+OW
         MsvhpF4Sns9pl8r9KFJJ9hPma8KXO7m0n+KJh9K2NUkfofi3E48qWskTTnhKFyIaMocU
         I8UNHJjRFbiSUlQJv3Vog4bhBDpMqnOXUQN+jJ7zAKRN9J3xFh0lbQYFkOogn1R+Hem7
         GGg7KFKC4TLVzDrv+hJorMIcL5gWTuy2hcfNeHznFwXKtsuNn70381N7bMz5TT1ydzb0
         lY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPQ2rAVVzlry8MPoszFMtQmu5p8pbG1Xujz8m2bINEo=;
        b=gR6YPCcQ0B6PBcU+BltG3qMvLVwn5jugqDXMYp/uC8PYQLtD3JXc7YP21Sl5/E4o2K
         g8r5L1u4rM/OEwqFOIxjXN8yvYStUAoNaYXArxbZHeFmD6ZmyQOWQ/9Mo3W6k7kSR5JU
         05vu92365rKXQHoDKdO1j8izRfDqsnFaSrTYIIBibKVdzgOFGNaHATLVgLzzR7GrP1Vl
         eBDw6BFnDTJRlzcaqhtM3IIucJ+TcDS6jfInOu5p1xx1qJyhXX+GkevQCf4rrG1nkI6s
         himxv3xm+FX2diEm7IJdjPyK+os/tDjKADGs/aqViDGTXwOM6/Pk5HPL6xzOhdtwPlO3
         uRqg==
X-Gm-Message-State: AO0yUKXZ59D7NsoWgyKU+hXebaH755YXhIiJWMpszRJ2KJVkaM/9EPt0
        pVQWq+itSB0+fQ5E2JPCjpgnlQmrfmvfy1ro2Zg=
X-Google-Smtp-Source: AK7set9W2V9ktPtG3r0UIx51DnAKvJG+uK0+1wgT4IvBtzNWoUwsQ268T6e8azJDpQS7YdjV0XLjrTz91jGEy1PG3QU=
X-Received: by 2002:a05:6402:3805:b0:4a3:43a2:f409 with SMTP id
 es5-20020a056402380500b004a343a2f409mr368249edb.2.1675821835353; Tue, 07 Feb
 2023 18:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
 <20230204133535.99921-3-kerneljasonxing@gmail.com> <a8677175-0d4f-af01-23d4-ad014697bee7@intel.com>
In-Reply-To: <a8677175-0d4f-af01-23d4-ad014697bee7@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 8 Feb 2023 10:03:19 +0800
Message-ID: <CAL+tcoBZD7M04svcbadQSdWupQCHvt3i0q21YgVjZ6azkrwFLg@mail.gmail.com>
Subject: Re: [PATCH net 2/3] i40e: add double of VLAN header when computing
 the max MTU
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 3:03 AM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
>
>
> On 2/4/2023 5:35 AM, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Include the second VLAN HLEN into account when computing the maximum
> > MTU size as other drivers do.
> >
> > Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
> >   drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> > index 60e351665c70..e03853d3c706 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> > @@ -107,6 +107,8 @@
> >   #define I40E_BW_MBPS_DIVISOR                125000 /* rate / (1000000 / 8) Mbps */
> >   #define I40E_MAX_BW_INACTIVE_ACCUM  4 /* accumulate 4 credits max */
> >
> > +#define I40E_PACKET_HDR_PAD (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
>

> This already exists:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/i40e/i40e_txrx.h#L112

Thanks for pointing out the duplication definition. I'll drop this in
the i40e.h file.
