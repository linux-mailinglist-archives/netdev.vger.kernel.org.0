Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6201A2DE394
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgLRN7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgLRN73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:59:29 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DE8C0617A7;
        Fri, 18 Dec 2020 05:58:49 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id 2so2191102ilg.9;
        Fri, 18 Dec 2020 05:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDAU6nY9p4JViJ1ZtWWUnNfwjvP6XwdpVGYZtIrcXWQ=;
        b=PL8VyLbUwqFXlBwLOPUUfJ1KfTBRCO5Tozs9ZKhu6CHYATSFIEhmxWudavUSP5FdY8
         kzBoek/oX7T0d5EXtCng6zZV4U9lt+bWBIaDovMCBL/UQmjWj8F+3t0BUKo3FpB+LcoT
         m/VquDR/zEVE5Al88oUileGSIyrY1v6IUvSJ8nLMktp7TPm2ArM6cJRkzIicpOdft1tP
         TJY8WNwXrZd/JYLpy59vBi5OXtkQmbo9Et9rTo4L1BequnVN2csq9Fc2nI4GiNKKZPtW
         6qphDDUI4D7dgw6spkxeNaicBMMaDnQCsAxM1Q/CGl3Cmx0fdqMq0RNDFi+FVPhMf4oQ
         U84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDAU6nY9p4JViJ1ZtWWUnNfwjvP6XwdpVGYZtIrcXWQ=;
        b=Uq9znm2WWMPnwNs7ciwJQ2uN8KNvY7T3RT0PDXENcMYCeqUK9Pgs+IEezpP03Mu2lO
         JZwjCTlEVVySUuSp733lfoRfo+WRn1nq3z3xOCp0Qlo6LZrcoV2/IWLU6kmfPMmrer4l
         goa5tOksZFZ4MB+5FQI8OtQmoQV1Igcc7C8gpjomcZwfoYlIqekXqLrrXcbfMHduS7jj
         vYup0Lcz6HEf2PTYpcSqi0Ovz0zXSFsvp5cZENcnz9AJZX+hjJa2e4DzNGmtQ9ILId0M
         C2kd5fBYvWlR0Hv0AdAD0Wr7O8hbhhWzlGQy4+7lgn2w9MhxAhqc0jEtzHd6M12KFNNT
         3I5A==
X-Gm-Message-State: AOAM531Ec6k3Fxpshl1fY5YZxEYRzmSb4eNTqmULn45Albym7r9YDmjc
        6nINupst7qmSd94cT/iZDUIRWzqpvkmL2grDeaE=
X-Google-Smtp-Source: ABdhPJx0+8chZmRyFSFyB+5va1/s+Y2azdW2Sodly9Pzsl2yNzxcuNvlJ4EWcp9eR7qZ19JE/aLMAILIVW/GDMTP8vg=
X-Received: by 2002:a92:d641:: with SMTP id x1mr3923332ilp.19.1608299928779;
 Fri, 18 Dec 2020 05:58:48 -0800 (PST)
MIME-Version: 1.0
References: <20201216130239.13759-1-zhengyongjun3@huawei.com> <20201216172031.16ef7195@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216172031.16ef7195@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 18 Dec 2020 14:58:35 +0100
Message-ID: <CAOi1vP9FCeP_+7KDcTCr-st5bMUi-jJeJ9WCxD9bAPSKAki9yg@mail.gmail.com>
Subject: Re: [PATCH net-next] ceph: Delete useless kfree code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 16 Dec 2020 21:02:39 +0800 Zheng Yongjun wrote:
> > The parameter of kfree function is NULL, so kfree code is useless, delete it.
> >
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
>
> To be clear the subject tags is misleading we're not taking this
> into the networking tree, ceph folk please go ahead :)

I still didn't get the original patch for some reason, but looking at

  https://lists.openwall.net/netdev/2020/12/16/163

the kfree is not useless.  If ceph_decode_need() fails, the array needs
to be freed, so we are not taking this into the ceph tree either ;)

Thanks,

                Ilya
