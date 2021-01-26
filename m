Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06292303514
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387876AbhAZFew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730747AbhAZBuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:50:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBF5C061225
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:38:30 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z22so3184449edb.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MsIlAIUrbRHFPp86Lpz6wYmDwGMXWfFOQRbCym/dO1s=;
        b=RdCvAqWTwF7luiWxlR31fbMjnGU9zrj7hpsT6egvsvktpF2i7/oVUgKWwZeqZYV8kK
         MMMqv45wJES83q8vR+Tk6gEsaHn3oqzBeA6WBmjbm/A73jGOSY2Sjm8b7pC9H8uDbq/P
         mKHBPNfxMj2kwk7hBKN9Ez950HiBpKwIeZYqRZdcsP6m6nNt6/a2JpYD64QZ95Nn9RWI
         kuRRbxWV0G4puaDwk94j8BcQfRe9VD8eon1Yn4JMK1QKNzX9uW3xht2XWgyrbb9yKCQy
         KpGEcTi8E6cJ/AlvA1LCFqkYcT/40oGsJ/Gsf8MoR5BubVbJs5Cauc2JZ/78zfP4c3XC
         9CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MsIlAIUrbRHFPp86Lpz6wYmDwGMXWfFOQRbCym/dO1s=;
        b=m/nv3rg5j9PsefEZeVyqhQXrf38AlJQdLhPRmZzXAD6t+RHJxJn/QhLBCVUGPtM8YQ
         f7wjLTkkQSCOkoeAyvJx76P6xSDQiN66rhNYNnGdWgAWObaoeMexrQ3AHDUypZtC67PN
         HSHVDvHT10RDzsBtqDJf1QY/IsDEEiP4UdKgbJBPxNa9xWGqGAj25Er7DtbmaxmHpzYN
         wCdbvlaE7p/o2PlMMv622nMjYy7hQxuUamd1v4Cuc2ZGBHdmyAHzXZxhlyJ08uPSQELE
         IAEsIte8IIzMYQaP9NAmG4PAYBDfJEoqAeO6t9yNiTHMJtDj8h2TE6/53nWM9PpjA2H7
         lrSA==
X-Gm-Message-State: AOAM532PrFO+BG/yGP5WM1ol0cSXx9pQA4HANqEJz5f9uP4l/3lKmpJN
        oeiLsQqKg+msk+ZWyez/zhDtqS/QyJHK75UbPBdZd3c+
X-Google-Smtp-Source: ABdhPJwyFxsEfSckN3uix9wch1ECiNRrpuo1Q8tcd4e+kxA1DuHy9cM0DO1iLaC/AOGjCJaEDLQMD3Lm70/9cZ3zOoI=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr2803815edv.254.1611625108885;
 Mon, 25 Jan 2021 17:38:28 -0800 (PST)
MIME-Version: 1.0
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Jan 2021 20:37:52 -0500
Message-ID: <CAF=yD-KFe+QAb5JkK1xYUTzjgL32cOWUEqsX3qJrbg3ky-ZPrQ@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] bnxt_en: Error recovery improvements.
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, gospo@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 3:36 AM Michael Chan <michael.chan@broadcom.com> wrote:
>
> This series contains a number of improvements in the area of error
> recovery.  Most error recovery scenarios are tightly coordinated with
> the firmware.  A number of patches add retry logic to establish
> connection with the firmware if there are indications that the
> firmware is still alive and will likely transition back to the
> normal state.  Some patches speed up the recovery process and make
> it more reliable.  There are some cleanup patches as well.
>
> Edwin Peer (3):
>   bnxt_en: handle CRASH_NO_MASTER during bnxt_open()
>   bnxt_en: log firmware debug notifications
>   bnxt_en: attempt to reinitialize after aborted reset
>
> Michael Chan (9):
>   bnxt_en: Update firmware interface to 1.10.2.11.
>   bnxt_en: Define macros for the various health register states.
>   bnxt_en: Retry sending the first message to firmware if it is under
>     reset.
>   bnxt_en: Add bnxt_fw_reset_timeout() helper.
>   bnxt_en: Add a new BNXT_STATE_NAPI_DISABLED flag to keep track of NAPI
>     state.
>   bnxt_en: Modify bnxt_disable_int_sync() to be called more than once.
>   bnxt_en: Improve firmware fatal error shutdown sequence.
>   bnxt_en: Consolidate firmware reset event logging.
>   bnxt_en: Do not process completion entries after fatal condition
>     detected.
>
> Vasundhara Volam (3):
>   bnxt_en: Move reading VPD info after successful handshake with fw.
>   bnxt_en: Add an upper bound for all firmware command timeouts.
>   bnxt_en: Retry open if firmware is in reset.
>
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 228 ++++++++++++----
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  22 ++
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   7 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 249 ++++++++++++++----
>  4 files changed, 393 insertions(+), 113 deletions(-)

For netdrv:

Acked-by: Willem de Bruijn <willemb@google.com>
