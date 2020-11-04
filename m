Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5A72A5C92
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgKDCDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgKDCDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 21:03:50 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D19C061A4D;
        Tue,  3 Nov 2020 18:03:50 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id t6so9506371plq.11;
        Tue, 03 Nov 2020 18:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XPm12uoBmrKI5Nqz4WpB9fjItXYANA4SmJK3Mv2CLPU=;
        b=fRVzrqGIBLmtjRK7c+TUZDRuMh6lJExvFvBInVI15kBllbJnz7sikgEoK+oZiDGVFW
         vSwyJhsUaKxX0g8VGVcPTxndFaS4XOPTcLPTB0IVt+8eu6OOq8qDUeOkT4QntXau55nJ
         rkG6mjwZLwgBQk1R5WC6V7aUbLyn0C7svc0+3Z9VVPrPRqLV2i2aCQ8gXtWyVZd+5N61
         uEtW+y+9USMNyAZrUVpwWJzzjIM/t/dhcxCGlTcuq+m0vFDxHQXmEucwVeUwgbEHIfZS
         eK79+gcLKKl78hRSmGF6KR9vmmIAPADsd/YaFn8DEdUfF7NwM73PompljVjQqD8aEiHy
         SD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XPm12uoBmrKI5Nqz4WpB9fjItXYANA4SmJK3Mv2CLPU=;
        b=ODZS7nYgOyHLnncMR78AwJYv4JL4CWxf1ObiMc/bvTizfisI2OZctLn7KdVCQ7ONp/
         Is+Wts64P7/fbXuwWvqiyzP3qB3c/tyGz9Td+QwFdXYHCsv74Xpqct5/rUeIAM+mgbJM
         2JBtDZ975eiTueyy/cKFlh92ZV4HjBVrtJ7y9GuHvAX9eWQNWAc1rGcJapO/SsB4+fbc
         Yz7aTlEejDJP8dcdrGqDGqUg8lWm19Z+QGeMKGGwIZ6UExSUUs/wgBiNerIUY8h9kLZa
         Ye1QIaU5QCoM3OMzXdhrFy5fGN9b3oDrjUzp1TEBaaAfptSgCqBBTSFDuVl88TYNtQkX
         m5Pg==
X-Gm-Message-State: AOAM530ChHj8jLMbG816twTk3TxJylQC3xjDKdfVUbTAyDNulyoEHrhi
        blEd6hRVIiEZ5I3BJyfSv/vMqolW4vVNuViNy04=
X-Google-Smtp-Source: ABdhPJwDb0Fl3bHiLZwvC+DXp9knsgO+EHQWuJywQKnnuwNjonR6s48HCjT6t5ZSNj7W7VbNsFaR1fvRbe8l6ln7JD4=
X-Received: by 2002:a17:902:6b45:b029:d6:c43e:ad13 with SMTP id
 g5-20020a1709026b45b02900d6c43ead13mr13870568plt.77.1604455430089; Tue, 03
 Nov 2020 18:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20201031181043.805329-1-xie.he.0141@gmail.com> <20201103152216.36ed8495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103152216.36ed8495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 3 Nov 2020 18:03:39 -0800
Message-ID: <CAJht_EMOtSVSeqy93ZsDKZRi+-A7=6Fjqu1nPRVi3O4SZV8Zrw@mail.gmail.com>
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

On Tue, Nov 3, 2020 at 3:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied, but going forward please limit any refactoring and extensions
> to the HDLC code. I thought you are actually using it. If that's not
> the case let's leave the code be, it's likely going to be removed in
> a few years time.

OK. I understand.

Thanks!
