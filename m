Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12D623DEC6
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgHFR3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgHFRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:00:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF738C0617A3;
        Thu,  6 Aug 2020 04:22:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m34so166033pgl.11;
        Thu, 06 Aug 2020 04:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnzzxc34cQW56LxwSyg5mi8Zc5YMYFPRJUcDt/n6b0U=;
        b=LvvBqyfgpeZFSNNkZU5lsH3pLnN3iLgCPYQiwOUywcijpSNbWn1VcotxvttMfFZZ/0
         UEooSgKnM/46tX0dlW6rODlpbd70OlBc1b6QxBwLff+/AixsDfDV/LcDJTsVHqVmWVib
         7JoeJiPKNeBlYli59nkZnoGA7CvxTwbmtgA43tH15RABrCfUbQTGKm9COuxDF2cVBXzo
         gUuxTBkMB1GUdaNl5WvzpQqYnVbhDA/LCSST/w/pdAN2Qgi/B41xGydKPVk27/AbcbSc
         HBOYygAnhNBzT5VBMtPYX0jdHiY0FqIKhNJcyJKpKVYBKZLo/LXuBD6uhx7k8DFGI9CP
         dBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnzzxc34cQW56LxwSyg5mi8Zc5YMYFPRJUcDt/n6b0U=;
        b=uaWF9Zc636jrZQmHa/el/gY2EZfBSJ/fJkzgMD9kmCTCKqKlbsbE7scSWO+OtYVo4g
         BxyjYInpyMNxLRzIrJ/qFlbf37TmAOy1C1LbeKqC1yK8msI4pP/MEdwJ6n5UxdhJObEu
         6wRn1UVGyI5GhCqS0R55U83YhIJ8DeeA5ysnJKRQ9q3iIm0j54b7OFpPuKjSz52S5eLh
         Ol1Nrvt4O+i7LLtjo1tKwk61zrulapdirN4Cx4ccIDTXnDVZuAvDucgdzHSs7m7diQcD
         ZHXio+h7FnBMckadOj8Ax9XM0IRM/sjTw9ocVRe5yXS7xjpYRLMfMEdl03IG1lMFo7zH
         Mh9A==
X-Gm-Message-State: AOAM5301TkgFAqwzZ6iTt6EOGo7bBdvGqCXtliWG3SwdiS5Ch01IY8EK
        N7+F9qbVocWeMPx9A5qbu1ZZKNzsqMPsiiYxD1TgUQ==
X-Google-Smtp-Source: ABdhPJykwbb1OjxTXVBM34rrhJ4WhW/ws9Yx3vOWBNCofm/m7DTOL6oWsFpa9T4EXhuWQhhvqc+eGGA6Z1J+4Kc+R4Q=
X-Received: by 2002:a63:e057:: with SMTP id n23mr6686076pgj.368.1596712924359;
 Thu, 06 Aug 2020 04:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200806015040.98379-1-xie.he.0141@gmail.com> <CA+FuTSeOhYOqKjHk5ZBFiY=_+pXgUKe4BKx1S+gu9T9X2c1+bQ@mail.gmail.com>
In-Reply-To: <CA+FuTSeOhYOqKjHk5ZBFiY=_+pXgUKe4BKx1S+gu9T9X2c1+bQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 6 Aug 2020 04:21:53 -0700
Message-ID: <CAJht_ENbEh1JFhk57YD+MteOafv6+PgE25hRUjyiPk9B48dEVA@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Added needed_headroom and a
 skb->len check
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 12:47 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Acked-by: Willem de Bruijn <willemb@google.com>
>
> The in-band signal byte is required, but stripped by lapbeth_xmit.
> Subsequent code will prefix additional headers, including an Ethernet
> link layer. The extra space needs to be reserved, but not pulled in
> packet_snd with skb_reserve, so has to use needed_headroom instead of
> hard_header_len.

Thank you, Willem!
