Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D580C1E8DDD
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgE3Esi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Esh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 00:48:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3548C08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 21:48:37 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d5so1556164ios.9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 21:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKceH09btGsJ70pI0cRAGgEBPwDnokf/z23gG8sTaoE=;
        b=GTJ/2+ZL09L4lcFK4xib8VU3DCzPt9gs9z5iUoTpb5mjJkl+BwZo86351eIb5QPfhn
         dxBvbOsEj2iBlyPECkrvIu1t4qcTAFH8S8YQmW0JRjmhCFETRRDBq8B2fHni2NDKClIa
         r/IHNzUfZ+YOfVKVmCQMej4xpn/al3CvbTYysCPBNHr/Aax+5zbhgvgi5HQdwwm5KfmO
         QhMqpaH5WSMtox/RLtAM42uz6dy8ARelWFJ0OkaB/itD9SaPjSSyt6bDpvHIt4mfVTH+
         usvU5d6EVO1qlrX1NSE8OdttmmC/ALV5iI+Nu8U7AC49LbSIbXpX7gD15xePJtl7RjVR
         cAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKceH09btGsJ70pI0cRAGgEBPwDnokf/z23gG8sTaoE=;
        b=TcNxqAkHjP+88zabRSO3dhuzL7Cq+fb+N1vjNeMTHOzTvQT/iHD0Ue12l+oiHhjry4
         XKAbikq99iKWsm3KZXuD+hnS/g8n5qaqHpvXXdsyRTJIY6VRhnVBkoR86QFfvYRL2W9P
         C0FF8mJQr16yaDIJH7tYUVw3t4YmqZsxSvPhOBK321J1b3128YnWCo13MchOfgqB9WVe
         we0F8hup3byRGBHctamPdIXfa9JCZmLmonUSkZ715pYy3ecKoXyiDuZIq8Iuiprio1LS
         b7UMh27I9vCBDme0ORxCdjLA6uSNVYqnTB0oj554uUJ+PO3EoKbX9O9Wv5SiV1KS5RdE
         Iqvw==
X-Gm-Message-State: AOAM530DXochpEg8UAIyV54QR7qBn0dD8AKLCO9Q32fRQXLBr/R7eIfm
        oMDyzMNwqiqB6lpCvBMYu5fCZ8b7KK2p9q8mV2Q=
X-Google-Smtp-Source: ABdhPJzGLzFoG4iQulwFRB1IRBl/xHsS0E7krQza803EztjOM687EE1h8hQu8qjWL6EkoJCgZgKWP78qElUBeJT2qrA=
X-Received: by 2002:a05:6602:2a52:: with SMTP id k18mr9622081iov.64.1590814116971;
 Fri, 29 May 2020 21:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <877dwxvgzk.fsf@mellanox.com> <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
 <87wo4wtmnx.fsf@mellanox.com>
In-Reply-To: <87wo4wtmnx.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 May 2020 21:48:26 -0700
Message-ID: <CAM_iQpUxNJ56o+jW=+GHQjyq-A_yLUcJYt+jJJYwRTose1LqLg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 2:48 AM Petr Machata <petrm@mellanox.com> wrote:
> So you propose to have further division within the block? To have sort
> of namespaces within blocks or chains, where depending on the context,
> only filters in the corresponding namespace are executed?

What I suggest is to let filters (or chain or block) decide where
they belong to, because I think that fit naturally.

What you suggest is to let qdisc's decide where they put filters,
which looks odd to me.

Hope it is all clear now.

Thanks.
