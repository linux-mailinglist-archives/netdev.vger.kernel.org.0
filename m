Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFA718A266
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCRSdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:33:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54544 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgCRSdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584556386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ilj6BwGd/FajjDOWHuUE6UL+lwbbPzdfmxLEJ0YlHSI=;
        b=BpytcobAxGQ/BdxtrpHiDrS1N4+PxOTMZV3762MoT4k+W8GdDBLCcZ7LiU80cf2C2RXVo3
        AfVFYKA3Ssc4vNxNppm8jycb3zlsBwfEo//ksBwbfKKzaCf8ED0Mhm5EsCtp1aBHi6fltW
        J7P1mD2lMx+G3YwBi1KnpWiVmAppjcM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-wtAQz7DkOQW4lUf4Jv28-A-1; Wed, 18 Mar 2020 14:33:03 -0400
X-MC-Unique: wtAQz7DkOQW4lUf4Jv28-A-1
Received: by mail-io1-f70.google.com with SMTP id e21so4904105ios.19
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 11:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ilj6BwGd/FajjDOWHuUE6UL+lwbbPzdfmxLEJ0YlHSI=;
        b=datd/myteZdczFVqmiSDWCMXKyNKkHhjFk8aJHykvW5qwj7ZFcI1ayQFVLftjEW2DD
         ud89ZEOjykhWXkyhF4HgSBOXH2QMumvJdfb58MDAWkd6OOXjN0h8ctJ98InH5fKN+xct
         yzF3ALmZGw2KAIyuBPpj8nFBCAsOHnyfJIJN0LYb2xDmlUXHi83yipgDKPv9UkF5KK+4
         TFyI2to3rR4/6BO7XoVlCYiVKfqC8tnK08gnz/9/4awdN6gr9rr16rwd3abVkKmG4aGt
         p50g7RmZffddW+adqIQid5PXSGezyPNZTdPqIA3mMBsWyUR4biQN9YFGOotpNfDe7Kfa
         ZOLg==
X-Gm-Message-State: ANhLgQ0LQpz3QsdVmS6uMZPWapsq3/9OJ1Sl9k7EwjLjZCRV8bOmxUxI
        3+TUwvOdI7cHvs7RQieKlyvKt5qJoGe6gUxrAFGpSCPNNEk0OxkVQ4QkOMRaX0v0abaNR+Gvakd
        UvxZ3EG5Ic18sU+msd0C4GHZBHBq5PTA5
X-Received: by 2002:a92:1310:: with SMTP id 16mr5626332ilt.45.1584556383306;
        Wed, 18 Mar 2020 11:33:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu3QMUwdfwhL40iC91mfRLcdXxpcYtuvk362A2+gEvygxz40xZnFroJLFfVNRXMxpk6CmDDAHkI3ym5o5KCFgE=
X-Received: by 2002:a92:1310:: with SMTP id 16mr5626309ilt.45.1584556383031;
 Wed, 18 Mar 2020 11:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200318140605.45273-1-jarod@redhat.com> <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
In-Reply-To: <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 18 Mar 2020 14:32:52 -0400
Message-ID: <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 2:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 3/18/20 7:06 AM, Jarod Wilson wrote:
> > Bonding slave and team port devices should not have link-local addresses
> > automatically added to them, as it can interfere with openvswitch being
> > able to properly add tc ingress.
> >
> > Reported-by: Moshe Levi <moshele@mellanox.com>
> > CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
> > CC: netdev@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
>
> This does not look a net candidate to me, unless the bug has been added recently ?
>
> The absence of Fixes: tag is a red flag for a net submission.
>
> By adding a Fixes: tag, you are doing us a favor, please.

Yeah, wasn't entirely sure on this one. It fixes a problem, but it's
not exactly a new one. A quick look at git history suggests this might
actually be something that technically pre-dates the move to git in
2005, but only really became a problem with some additional far more
recent infrastructure (tc and friends). I can resubmit it as net-next
if that's preferred.

-- 
Jarod Wilson
jarod@redhat.com

