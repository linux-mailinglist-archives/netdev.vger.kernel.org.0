Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6C4E8A43
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiC0Vml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 17:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0Vmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 17:42:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E55F33A13;
        Sun, 27 Mar 2022 14:41:01 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y10so14897041edv.7;
        Sun, 27 Mar 2022 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKrk7yyVSBJyq5gcy9y0VCTef/2oQsNrO3DCzTW9su0=;
        b=flLawCsCu7mGwfCSJ/9OK4RPnqnjPyBA1j/kUx6d9OzQsP6SwZdIzQpJ/8oBm/N7ZA
         F/+9afnveATUPMKLk7o2V4kj4RAyAg7dKhWF5YxF80pzgpbozT0+vg4FO57qOq70LYmv
         dgUkaB3NNIUQXYkibvxlnsGH3WXqWugpIHhWEwd/zMLnnA0+Ue1b6c6dMf0cpVcPlNyC
         MT1BVGUNPbzC13tlyE433L6yxImX4gC9NVk+r7sBOoZgM6tlb3HTOyqkesgEnGjFiP5H
         X7qoWtBx2I4Do+9lFQls3TsGWA53L9wbGx2P+iztcv0xnq6lZPrrZ3zkfIYyi8P/aYtB
         grLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKrk7yyVSBJyq5gcy9y0VCTef/2oQsNrO3DCzTW9su0=;
        b=eVJ0sWaWqd61ZAScC9rKAQlhx83BcjiayvKp9YO68L71/Z1+3fzifAzSlqGAvbZPdf
         Wn6VFBVhTN3DrIFWeo+Ulq4rmUmrO9DVzElu+ccm9bFRkGTbYNekcYfo6pXf1etgW8Xh
         aP7sbA9ahdEOw0+Cl6HQz3mc51xgYsBwP0OsSUkBCXBEQw3yh1RgBWutLeu3uVdin6Kz
         Vftn9VYopVJL3S7zAd66WpLZ15Q8t6nkLP63eY04UqHDIduySXMW8uj3Lzt62sIwi+FX
         kv05pbuAj4OApy9Ry9ZbbVTY1hv5JOkvkhTr5IlbFte40UixLlGaSgtgu8716TlIo3Fa
         /iAg==
X-Gm-Message-State: AOAM533/M/xjTeWtuwXHC+qWouSErkvhKHckjSmfvyoaz3E4y/PuFk+R
        8PMjJHVuekvfcY8DC7CKWULl6T9TRR5RHUlmtP8=
X-Google-Smtp-Source: ABdhPJyK+1TOg4gSrDqHjQKlR4kxFvuIVc48DoCew7fPd3Zjaxbx1PuTQ6DwxKqu0KK/RHZaE8qrflwYPQp5cCkw1tI=
X-Received: by 2002:a05:6402:1e90:b0:419:4cdc:8b05 with SMTP id
 f16-20020a0564021e9000b004194cdc8b05mr12494544edf.211.1648417259540; Sun, 27
 Mar 2022 14:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220327072947.10744-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327072947.10744-1-xiam0nd.tong@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Sun, 27 Mar 2022 23:40:46 +0200
Message-ID: <CAAd0S9CR=PjEskWAi132qWB5WL1yZwzOBfV-y5m2ERzc3L_qcA@mail.gmail.com>
Subject: Re: [PATCH] carl9170: tx: fix an incorrect use of list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Mar 27, 2022 at 8:10 PM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> If the previous list_for_each_entry_continue_rcu() don't exit early
> (no goto hit inside the loop), the iterator 'cvif' after the loop
> will be a bogus pointer to an invalid structure object containing
> the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
> will lead to a invalid memory access (i.e., 'cvif->id': the invalid
> pointer dereference when return back to/after the callsite in the
> carl9170_update_beacon()).
>
> The original intention should have been to return the valid 'cvif'
> when found in list, NULL otherwise. So just make 'cvif' NULL when
> no entry found, to fix this bug.
>
> Cc: stable@vger.kernel.org
> Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/net/wireless/ath/carl9170/tx.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
> index 1b76f4434c06..2b8084121001 100644
> --- a/drivers/net/wireless/ath/carl9170/tx.c
> +++ b/drivers/net/wireless/ath/carl9170/tx.c
> @@ -1558,6 +1558,9 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
>                                         goto out;
>                         }
>                 } while (ar->beacon_enabled && i--);
> +
> +               /* no entry found in list */
> +               cvif = NULL;
>         }
>
>  out:

hmm, It's really not easy test this.  There are multiple locks, device
states and flags to consider.
the state of the protecting ar->vifs > 0 (I guess this could be > 1.
There's no point in being choosy
about "picky choices", if there's only one), the main virtual
interface as well as cvif->enable_beacon
and ar->beacon_enable don't change on a whim.

But it it is true that this function gets called by the firmware as a
callback to the TBTT,
so it would warrant any protection that is possible. Whenever a bug
can happen or be
forced in this case: I don't know, I can't do experiments until much
later (easter :( ).
But it's better and easy to err on the side of caution.

Note: That "cvif = NULL;" will certainly break the beaconing for good
(for the remaining
lifetime of the main interface). The driver would need to be stopped
and restarted before
beaconing would work again. A safer choice would be to return NULL;
That said, if the
bug can happen, the driver/firmware would be in a bad state at that
point anyway.
So a call to carl9170_restart(ar, ...there's no code for a
driver/firmware mismatch yet) will
be necessary in the hope that this was just a temporary glitch.

Cheers,
Christian
