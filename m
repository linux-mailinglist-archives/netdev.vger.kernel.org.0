Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1DC6A8C1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 14:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfGPM2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 08:28:43 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41131 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfGPM2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 08:28:42 -0400
Received: by mail-oi1-f196.google.com with SMTP id g7so15381612oia.8
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 05:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jOAHGmFafxc/GqaT96NZZD0R21ykNhIQMgNL2jNFuVg=;
        b=CjXI0/3q/eNsVg2vohFMOchh9r/4+5McjWWNP9oqhER9Ui+eoYr0kKbu+ICBrb4l3W
         mUBrDqty/OxZO6lLzlT82yT+JO8HucH7cVIcf/AR26U8P2wsKd+B1o9MjbQaCYDS+OHU
         kDSKE6J+2gYkY2Xt05J76M0bC/8VYfiBvqTIgsGN9sFM/Or73GMOFxlf1FRNYxqH9K44
         ojws1Ejw+Qlo/CuuMz5eTd8RTCyayCbCRFBijTnjMRi39Pq2leVaGeubXTeLlobcbLrq
         BTb3GqeB88OG5C8xuioqKvYfmyAwHxupVFFzW2yltzrcuHVl6FtMFSQ+DcQNvrL6J9EJ
         +9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jOAHGmFafxc/GqaT96NZZD0R21ykNhIQMgNL2jNFuVg=;
        b=UqbOPj26wrfO8/qEDg9Pa1m+EB7xPXEAwG8b+9Zn1tetbQpGtJhl/Cuq9+rw5vy1H0
         ulr4XspNr51d04b2gpSobQ92ZQRkPHSkaC3bPgNU+NHlMbBzJJ8I875oI0VGzEDfdcMB
         uFBj9rxSZPBxYJkDRDAgeOLDHqzoTL8wBqdDUKeJMYtr8KPF4PDuUhqR2h+0yP1vpd0t
         vRsgXztPvD+ICwu4VgAORqufF5Rh5ikmSG0GFVw2GsQwexIjENTTKelhlAUJPXiuZ+m8
         36/BaJQSMlbC/JbjxJ878KFMd/LQe1LZ4M9jt7tdTPWE2Z8XiIcW7BTNL0VMb81SI4lS
         b/tw==
X-Gm-Message-State: APjAAAUGeYqNF2zmwPm0UsyKtezYq6jXYtcfdq/Z25e0ehnCWOcIdMuz
        abyBg8eppP1le/sIGDQioSYnPN050LzrHXnHfNw=
X-Google-Smtp-Source: APXvYqzTWM19WLWeIpsXoy+TBQ458LJzOYdA6Wp7ltf6dwrQdaK/teUyMaCAdcn26hOzQWJlwtN26W2AJLsFwddBbvc=
X-Received: by 2002:aca:5015:: with SMTP id e21mr17410401oib.159.1563280121751;
 Tue, 16 Jul 2019 05:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190705160809.5202-1-ap420073@gmail.com> <CAOrHB_DXSo37ZttVcW3fEuvB9_-2VtzZgf0JNq1ZhSfJJHSa7Q@mail.gmail.com>
In-Reply-To: <CAOrHB_DXSo37ZttVcW3fEuvB9_-2VtzZgf0JNq1ZhSfJJHSa7Q@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 16 Jul 2019 21:28:30 +0900
Message-ID: <CAMArcTVFYYZy2XWZCTFQvZBzpSYf7_-e1Mu27-yhhTPeoeiBfw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: do not update max_headroom if
 new headroom is equal to old headroom
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 at 03:15, Pravin Shelar <pshelar@ovn.org> wrote:
>

Hi Pravin,

> On Fri, Jul 5, 2019 at 9:08 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > When a vport is deleted, the maximum headroom size would be changed.
> > If the vport which has the largest headroom is deleted,
> > the new max_headroom would be set.
> > But, if the new headroom size is equal to the old headroom size,
> > updating routine is unnecessary.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Sorry for late reply. This patch looks good to me too.
>
> I am curious about reason to avoid adjustment to headroom. why are you
> trying to avoid unnecessary changes to headroom.
>

Thank you for the review!
The intention of this patch is to remove unnecessary overhead.
There is no other reason.

Thanks!

> Thanks,
> Pravin.
