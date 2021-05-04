Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8C3723E6
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEDAiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEDAiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 20:38:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4F7C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 17:37:11 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g14so8466529edy.6
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 17:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+w86KcpDJUq6CzGjKuCZlEb3setK2CdB71YXoVrHSms=;
        b=QeqzFnXIwUo8vje0cDaFDcUT2RoRkRy4DRcpzJ5ePsJvwT4AQxh/v8vgVhNP8FFkwG
         34t1bDKtjKEhOFpvfxbyONomhka/lBN/ytCSZXRyjVfwfVjrdd2KzI8BDfhXAXExef/D
         AYf8s42of0aK1Mg9YSjhRDkPZ5pRN+fKyjwXKq/6mR8IV5AxeLkOMYE+GmULXxu9sOtt
         b/ZgssVmR4zRasfjN/ncBysQvrMWtgVtoMEBrDREN1mEHjMEcJz5kacPsvsM9NEC6sgE
         ArntN6lxUVy7hdaP53r9yAgxG97mp/f8gH+6U6OKcMdkHEgwk5DTonZUL6s8hbmeGj1i
         Lkng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+w86KcpDJUq6CzGjKuCZlEb3setK2CdB71YXoVrHSms=;
        b=havuX8XEBPiSUKNNVqSkHUbv4yhPrUFXRjvv99lcvI1qjNy9XDF9Uah8uOoEBpRFCe
         EhAjgepSlfSJnQSEQg/F1W9VfEhTym8lYHllK3iPR3zaOlq0qlFoPZOuSu4yISOcZL9p
         U7coTGF6ZRFnbJ6XqpTaZXFno7Kn7F9jyb+VoaRynb5j3pSuGY8vkkY4YFZglQbJ52Tq
         pMatRa5qvZ4yWEgmQZ4LFh0xgmM4EifYwalVFfpYIfOgqN5fCmUL+gR2D+JmBNz/lrNZ
         +h4JgYUKLo6/yF6m7A7YTC3Uu44bglgUOe3lFGxiNmLgonmZIx0jP01dMhI/wmeJdBvO
         Thzw==
X-Gm-Message-State: AOAM531GRi/ZfZRzc2UnwMNebNgMFtpzoggpEjATppkAfyxIOo1THPmE
        YYvc2HF6ZCL+Z0HEQh4wNJKFu2N9kS8=
X-Google-Smtp-Source: ABdhPJyX51p8mlT93E75U0YZszL0BC5nrxHVlsa/mZLIYygOJNQb9VqIA5tl2rh0oaycWbOYfVoy1g==
X-Received: by 2002:aa7:db9a:: with SMTP id u26mr22935923edt.292.1620088629839;
        Mon, 03 May 2021 17:37:09 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id p22sm13651718edr.4.2021.05.03.17.37.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 17:37:09 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id z6so7437648wrm.4
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 17:37:09 -0700 (PDT)
X-Received: by 2002:a5d:534f:: with SMTP id t15mr27360481wrv.275.1620088628758;
 Mon, 03 May 2021 17:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
In-Reply-To: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 3 May 2021 20:36:31 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
Message-ID: <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 3, 2021 at 8:04 PM Richard Sanger <rsanger@wand.net.nz> wrote:
>
> The packetmmap tx ring should only return timestamps if requested,
> as documented. This allows compatibility with non-timestamp aware
> user-space code which checks tp_status == TP_STATUS_AVAILABLE;
> not expecting additional timestamp flags to be set.

This is an established interface.

Passing the status goes back to 2013, since commit b9c32fb27170
("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got").

Passing a timestamp itself in tp_sec/tp_usec goes back to before git,
probably to the introduction of the ring.

I don't think we can change this now. That will likely break
applications that have come to expect current behavior.

Is it documented somewhere that the ring works differently? Or are you
referring to the general SO_TIMESTAMPING behavior, which is a separate
timestamp interface.
