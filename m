Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387DE12006
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfEBQWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:22:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39173 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBQWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:22:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id e92so1259813plb.6;
        Thu, 02 May 2019 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zn8yfJGYS08KppxEtG2xWjDfTf/WXjwvvw1EeDqj28g=;
        b=RNS6PHS7ucN6F9SkJdAWHHj+5V97+gr0foD0Q80WnV31Wof5/V5Hp+fPLM2l2r0lrF
         kA5+CxY3MFhetfkrU+DSY2+TBtdkgd9p35c5Tbx+PiVrXL7wOONeLE4VlgQq/UyuyQMD
         1zM7v/PFk08XI2QtJd/DcW4xFUG2htZ0rA2AYZ0tZT0zPg86LhX7nnXx/Uyi4AYmVT7F
         XpCVQ6QJatiI87+LD6dqnMMRqH48p6oFBdD5pC5678jHFuVD7cozdOhNDtDqzhndVArH
         UB75RkUDalroOz6FiTQU6+zv5/1pYX5qyDg+1YRVqUNPNTiQOmZRmAbwf7KZ3RsKLrZQ
         npIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zn8yfJGYS08KppxEtG2xWjDfTf/WXjwvvw1EeDqj28g=;
        b=F38rSS3810RRnEABECMQWWuyTQ3DPz0Des1kUjDyEhNic9Ri8LuOiiVf/gSRLDJJ0g
         IQM+3bji4FWK4lYtB43e2FNWJWSio1Sgdi2MxL7qoFBESITPGhxs4Ec+tADfOW6jlr2s
         bHQaINzY7YoMjQc/tjAqZh7qc7yVWB2z0FSVaIlhomEhdYjw8cFAhOZELu9jZm1HW1V4
         Qz3dS37q+007YiGvSJP52UpogNn1TPYg+cqnRWrSRmbXE1O+gPM6DqO/sEwf1xc37o8g
         hoa4HtJrDaMNm2HMtd33vV0ZbeXkCE5msAJ6FZrIKOufnHUHtOeplHtvOH9Hxh9Q7BmY
         pWiA==
X-Gm-Message-State: APjAAAVa9b9AB+HiHZm0qOp0TiKRPHCABpgbmP7BwGtdo8fEzw2HBj6y
        xYMcM6ay/UeDsSWGYqWvWrrI3PhxtkTTCB41cbo=
X-Google-Smtp-Source: APXvYqzwL5UmlQcYlE7GRSLphSa7A1IINLApmkSPtNF3HVJbu1kriWw32hLTlgbCrNkTVhrjbzBuferb1Nzfr/j4acM=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr4675914plp.165.1556814129261;
 Thu, 02 May 2019 09:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190502085105.2967-1-mcroce@redhat.com> <CAGnkfhwWnST_uMOOpBtz4scN50T_9X+bJnVYaHeFvLzPHgRGtA@mail.gmail.com>
In-Reply-To: <CAGnkfhwWnST_uMOOpBtz4scN50T_9X+bJnVYaHeFvLzPHgRGtA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 May 2019 09:21:57 -0700
Message-ID: <CAM_iQpVqyPiEeL8b1n9+3xzT22-m8cArwJL1nwYBAo+1JHB0QA@mail.gmail.com>
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 1:55 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Thu, May 2, 2019 at 10:51 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > When a matchall classifier is added, there is a small time interval in
> > which tp->root is NULL. If we receive a packet in this small time slice
> > a NULL pointer dereference will happen, leading to a kernel panic:
> >
>
> Hi,
>
> I forgot to mark it as v2. Will someone handle it, or I have to
> resubmit a v2 or v3?

As long as David doesn't get confused on which one he should apply,
it is okay.

Thanks.
