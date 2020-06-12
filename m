Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD51F7FCE
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 01:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgFLXwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 19:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgFLXwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 19:52:10 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEF9C08C5C2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:52:09 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so12974794ljc.8
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5ngALuwgd2UZp15ZYB2LhrDQynYsE132uhUeXOpEus=;
        b=ci92my1ZAUe4UyS0wP9gpUITvBjosTAhuGtf9IxMXi1eY2r/xuLb2p+Qvo+UCOXgvk
         Zstx17w5x487Vl9jajqvZlnrqSRg7Az/eH8km2aMCoilixtUYE+alqukimUB7QOcY6eR
         Jls33PaT5jVnckx47c0nQwOvup15kWdja40zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5ngALuwgd2UZp15ZYB2LhrDQynYsE132uhUeXOpEus=;
        b=q+LEleZnvatU2YU6GapPgU1dtOvWq2nfBWLXoBnpsJYqCdn8gsq78CGVrXpp06SxhJ
         MqfNIhs4XzSu+++fdDBTL1jYWp9vShnNqFgs7bEmvEWekwXTFD4GfDQ9mPQHQsd3cWJx
         mYW1Y1wuneP4LVayuUGyb9YXSldRRu/Aj6qdaryzDTViidnEcJWDN7wuW271tqJQTvJR
         w2jmHnPANaLzAlRN5AXE2guraOZDQ/6AQuSXDz3F4vVInAefN2dGm78UR2nZF1ms0L4o
         VoKv6FKTk4CGrLAxzW/C3KSZmwnUTwQgHiOJIVOLvxmC8wnagZaBqSgcVCM1UfbGRESh
         TE/g==
X-Gm-Message-State: AOAM533VrYnh13mRL+b9xOjKEhplQyMODsuuP88G+todbZffYU85hJ0Q
        jNX3jQjvsLNyz7Om8+xxshG4y1r/QRSQY9kCQEezDQ==
X-Google-Smtp-Source: ABdhPJz2Mdm0Z7Fl1At0M2nCNbzBCJBpo+fZ879WiaZQKbv5YiEXypRoNYnkQLC3gigJDLewRFNFFS+qryDgCKFP1jg=
X-Received: by 2002:a2e:92cf:: with SMTP id k15mr8109767ljh.333.1592005928015;
 Fri, 12 Jun 2020 16:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
 <20200611231459.v3.4.Ib4effd5813fb2f8585e2c7394735050c16a765eb@changeid> <20200612104952.0955d965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200612104952.0955d965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Fri, 12 Jun 2020 16:51:57 -0700
Message-ID: <CABmPvSHphwBuWy-pr4rro1MxS_NO5OLYsq56Fd=oed8gx7hYkg@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] Bluetooth: Add handler of MGMT_OP_REMOVE_ADV_MONITOR
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I uploaded v4 to address these. Thanks for the reminder.

Regards,
Miao

On Fri, Jun 12, 2020 at 10:49 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Jun 2020 23:15:26 -0700 Miao-chen Chou wrote:
> > This adds the request handler of MGMT_OP_REMOVE_ADV_MONITOR command.
> > Note that the controller-based monitoring is not yet in place. This
> > removes the internal monitor(s) without sending HCI traffic, so the
> > request returns immediately.
> >
> > The following test was performed.
> > - Issue btmgmt advmon-remove with valid and invalid handles.
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
>
> Still doesn't build cleanly with W=1 C=1
>
> net/bluetooth/mgmt.c:4009:46: warning: incorrect type in argument 2 (different base types)
> net/bluetooth/mgmt.c:4009:46:    expected unsigned short [usertype] handle
> net/bluetooth/mgmt.c:4009:46:    got restricted __le16 [usertype] monitor_handle
> net/bluetooth/mgmt.c:4018:29: warning: cast from restricted __le16
