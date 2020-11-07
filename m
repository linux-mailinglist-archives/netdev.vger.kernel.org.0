Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181AB2AA5FF
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 15:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgKGOeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 09:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgKGOeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 09:34:16 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66587C0613CF;
        Sat,  7 Nov 2020 06:34:16 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id x13so3347458pgp.7;
        Sat, 07 Nov 2020 06:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OvZRnx3zKUlFFbuIBaVfPQjLrLtotnEPM1zyk4sAfo=;
        b=A+Kt5URmOJouiLjmnTpmIunakfrGP5Ok/bFb/URE9mAxaDAIzMJjpFvoWJVmrdsLkE
         F7Uyo6cZURtP75VOTL7gwuSiMjK934GDKXkeQ7QWLWJtHphtxoU+pjTU7u4ojcgfFEVA
         RVsmE0qycQJEWQZOwKxScBTxF+j7dTzwgvbhhOJ1aYpH7D3QXOWjXaD6qX+fUUiBzW7z
         t5LpeT7LHe7Wb/NfWnN3HAcmy5HEf7sXb0VlbQv2+BGiLGaPP5OKwupvdfg8+C3RU7lo
         hpf5Ci5VJMveJ5V20PhsCLboZpRa0/KGrT7qAutaBwicjfV8KqlrDjEAnQyAn/ewDFJq
         dtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OvZRnx3zKUlFFbuIBaVfPQjLrLtotnEPM1zyk4sAfo=;
        b=UnD4fW0WCXiDsnIKmjoft4sPHzpFEbyAxpWERdUokYvz+xQQB7N99jx5K1Gb5HjYwZ
         OzA/uBJ1kkSm24OaURjZQBsNDOSNd4+7dcRRa7l0lysiS9DsoSYNrvtuhzXTh6EXyOuZ
         qJiYq9IXcLvWd3HYtakKo2v1q5v+jK0cZ6jmQIlOX40rfVv8K00wPTssyEAs3x+Rmaz8
         +ep45/BG8YeKFPGVffL73Jzm1bEH6Iet+odHfbOCDBiFuu1KwvjNzkp/glYlYSMLYn4s
         KCMcDqp2DL7nyp9qWwabpYxmnLl46sm0Ujy/mIn04tBIiSxSiFqFI78XHQlc2eT3e/Av
         J9GQ==
X-Gm-Message-State: AOAM530DnSJeygJxvUwBQF6ldbkgGntEym4I4HBl/6QqZBcB2BTRs9LG
        bhHOIyZnV+CSAARNxNJ6vfNoJvV7WYeQO3yqC0OGZhKB16s=
X-Google-Smtp-Source: ABdhPJzhsB1cK5mMXuPVRe5FS4R8kJy9pOpcpUEmxAwr/qRkBpDYkAvUqkabzSO+tPQNcsUsrP6KJpdIQ7i5Ta9Zfp8=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr6441940pfw.63.1604759655895; Sat, 07 Nov
 2020 06:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
 <20201103152216.36ed8495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAJht_EMOtSVSeqy93ZsDKZRi+-A7=6Fjqu1nPRVi3O4SZV8Zrw@mail.gmail.com>
In-Reply-To: <CAJht_EMOtSVSeqy93ZsDKZRi+-A7=6Fjqu1nPRVi3O4SZV8Zrw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 7 Nov 2020 06:34:05 -0800
Message-ID: <CAJht_EPvPW8tSGbhB99c_SpZ7c30yP23Z-tW-6+YjBP8aacr0w@mail.gmail.com>
Subject: Re: [PATCH net-next v7 0/5] net: hdlc_fr: Improve fr_rx and add
 support for any Ethertype
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 6:03 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Tue, Nov 3, 2020 at 3:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Applied, but going forward please limit any refactoring and extensions
> > to the HDLC code. I thought you are actually using it. If that's not
> > the case let's leave the code be, it's likely going to be removed in
> > a few years time.
>
> OK. I understand.
>
> Thanks!

The HDLC layer is still used by X.25 people (to be precise, Martin
Schiller <ms@dev.tdt.de>). Although we currently have three X.25
drivers in the kernel (lapbether, x25_asy, hdlc_x25), it seems to me
that only hdlc_x25 is used in the real world. So I guess the HDLC
layer will be there as long as the X.25 stack is still there.
