Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0748F24819A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRJO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRJOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:14:24 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7844C061389;
        Tue, 18 Aug 2020 02:14:24 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id x24so15748518otp.3;
        Tue, 18 Aug 2020 02:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92Ib8mqnWdcCybpCnhffmUEYTmpg4Jq4jg1RQZX0S4A=;
        b=bvFGk3lrrpct2cWUZxj+prtZpM+oGTkbdgMnN2Ip95daB8W+N/BLavePbfFJn0lHHc
         7aMSCshxSM/kbdjfDNCPhdW/L1BhLVemPX1X+WeisFQ7VDuYl1GgJq8oTX8V/kB2swfc
         hJmVVssUtRknVjKLHWEQz5nakfcEY8Mc3dWqKtzZH7YRPLgh01ZfCNpZBvVigq5lPsE9
         AtRueEvWq5zMYspK1ZO3bw0cZHzyRf/TidoiO3A0qZr5LZBQ6DOf8eynFpPiq/8Pp98H
         OEvCdI9rI5tBFe01nhhZ66f4659Vj7pr2m7jYm6Tjhga7mJbtD8mXSAACzPjIxNjZXlZ
         6eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92Ib8mqnWdcCybpCnhffmUEYTmpg4Jq4jg1RQZX0S4A=;
        b=WLFX60zOJG0ikBcBG3WqG6Zx4VDC4MpY6zqzXcYtknCFg+4WOZepw/ZlhBObuNhy3p
         MQ43pl6o+OCgar8Ks7ZfMAC3H+/A59UTMNEggG69dkcyiwP9hxJH4G+A1l1GizfNtLrL
         yO4mU22ZJtPdCLxJ0YzQ0/cpzW9iLn5kTCch1KwYP80jnQ7Z+tqsVYpbZ/nxUjkBsfZL
         szDSaNTqkOiJfiPNSPGT2qAoQERaDjYKm+aIi6AgfW1U9xcu9KlzaEYfiTBsIhnnAAvm
         HkkrYmEbJhBns6A2OWVsHdIb8d5QdQlRYx6nBu90cUFDXVYtvQYFVoHSmQcUFxj5Zkwe
         0Edw==
X-Gm-Message-State: AOAM531e53PH+asN1AKFgHNIhUCOrWtjLvZy3fKaKhlcUDo0H0fBBSSa
        v3i45o/0mOiqy28wz4Mf+z5inUH1kdSmnSOPYgE=
X-Google-Smtp-Source: ABdhPJw5Yg1ZJ/hk9vv2l9CTB62GQWVvgdd0gIFQVRhUFKJQuHEcJzlRnt3ebxQ137Agq9mvj8gvS5P7+aShkn1RxqQ=
X-Received: by 2002:a05:6830:1c65:: with SMTP id s5mr14047314otg.264.1597742064104;
 Tue, 18 Aug 2020 02:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200817090637.26887-1-allen.cryptic@gmail.com> <9cbb824a-5769-dd24-dcec-d9522d93e9b2@kernel.org>
In-Reply-To: <9cbb824a-5769-dd24-dcec-d9522d93e9b2@kernel.org>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 18 Aug 2020 14:44:12 +0530
Message-ID: <CAOMdWSKLPuXsQRoVKr5zOLoh1RZ1Z0VTcxvW=++CfoS0s7azSQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] wirless: convert tasklets to use new tasklet_setup()
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Allen Pais <allen.cryptic@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, kuba@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> General question for the whole series: have you considered the long-term
> aim instead? That is: convert away from tasklets completely? I.e. use
> threaded irqs or workqueues?
>

 Yes, since changing tasklets to workqueues or threaded irqs
becomes a little trivial when it comes to tree-wide change, this
approach was considered. I am open to both.

-- 
       - Allen
