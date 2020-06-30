Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71CA20FCE4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgF3Tml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbgF3Tmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:42:40 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870E5C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:42:40 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e11so19862048qkm.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r5n7pL7VM0Y1jkZSxrLT4x8SIzFlroDFfeH9QkRPXGw=;
        b=elzHcaxlxQVF9fzr6kOluOzZ5TQnbm0IQmYCYriI8xy/Am97hlFvHbFBGYmlxbjDpF
         DKajG+B5X1I4faKbqwXhAkYRI6RcsbJt6yHgMH2t6bdo299owNMWwmM9W5tI0QMwXn81
         DK41L78w2Dwx4e4r2EhViqz3Wi/1WEUOmJxRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r5n7pL7VM0Y1jkZSxrLT4x8SIzFlroDFfeH9QkRPXGw=;
        b=olil5gOcgpLUse2kklhhvaEsZY/DybY36Phv9GI4SeWW5QIpxzIxris7UdpcwJug8S
         U0jtSx52mGqZ0ZW7fY88DgHZ0/MC97+n7aqDGCEdxNxmk/XK8Qso9zS/Th7wbdHjEKfr
         IwIvjUjWgl5++o/mGUuGj6owfrmoDIFFFtrMBtwiNNxJkvuAuc6fNYUynIEtXtlBQS+u
         /UvEWS4ZbXh7gMWYdVW3gQjNXz8kPtfH8z3JByW+wNNBRzNkUQ9yf7cCwlHFH/gtgh3E
         haWWLBWKjbmc4rtQB0pfuf5omlNjt6ynB50uARk3NLRelUzP65I2BBnws9YE2Nri+T/n
         GlZg==
X-Gm-Message-State: AOAM530BWMghJMWktpdvNeZKlpVIkHp0ymCsbWzx15jLE3/SxMvaLocN
        gyBf/CzGJ2YrS3zI09UkSsx2y6X4RWL/lad284wUVp2a
X-Google-Smtp-Source: ABdhPJz5wzIVRfu80lNyQBbxeqdAmHPHLB9Z155Uviy//9Sp3O2sx/cTGx3JjuCg0dkuUqKvDMsjnUWhLCf9r5GVy+A=
X-Received: by 2002:a37:2c41:: with SMTP id s62mr15308765qkh.165.1593546159506;
 Tue, 30 Jun 2020 12:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
 <1593412464-503-7-git-send-email-michael.chan@broadcom.com>
 <20200629170618.2b265417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLin7DSADqfm8BjQxtM2sYZZV6Ycq_oHPT0+e53xpCoi1xA@mail.gmail.com> <20200630120517.2237bb87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200630120517.2237bb87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 30 Jun 2020 12:42:28 -0700
Message-ID: <CACKFLi=062ODBJ5yoR5Pe6hvCuOXyJ-reoUp7HhrbdB0nvstPQ@mail.gmail.com>
Subject: Re: [PATCH net-next 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 29 Jun 2020 17:38:33 -0700 Michael Chan wrote:
> > On Mon, Jun 29, 2020 at 5:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 29 Jun 2020 02:34:22 -0400 Michael Chan wrote:
> > > > With the new infrastructure in place, we can now support the setting of
> > > > the indirection table from ethtool.
> > > >
> > > > The user-configured indirection table will need to be reset to default
> > > > if we are unable to reserve the requested number of RX rings or if the
> > > > RSS table size changes.
> > > >
> > > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > >
> > > Hm. Clearing IFF_RXFH_CONFIGURED seems wrong. The user has clearly
> > > requested a RSS mapping, if it can't be maintained driver should
> > > return an error from the operation which attempts to change the ring
> > > count.
> >
> > Right.  In this case the user has requested non default RSS map and is
> > now attempting to change rings.  We have a first level check by
> > calling bnxt_check_rings().  Firmware will tell us if the requested
> > rings are available or not.  If not, we will return error and the
> > existing rings and RSS map will be kept.  This should be the expected
> > outcome in most cases.
> >
> > In rare cases, firmware can return success during bnxt_check_rings()
> > but during the actual ring reservation, it fails to reserve all the
> > rings it promised were available earlier.  In this case, we fall back
> > and accept the fewer rings and set the RSS map to default.  I have
> > never seen this scenario but we need to put the code in just in case
> > it happens.  It should be rare.
>
> What's the expected application flow? Every time the application
> makes a change to NIC settings it has to re-validate that some of
> the previous configuration didn't get lost? I don't see the driver
> returning the error if FW gave it less rings than requested. There
> isn't even a warning printed..

In bnxt_set_channels(), if bnxt_check_rings() returns error, we will
print a warning and return error.  This applies whether we have a user
defined RSS map or not.

If the RSS table size changes (only newer chips will change the RSS
table size when the rings cross some thresholds), the current code
always goes back to default RSS map.  But I think you prefer to keep
the user-defined RSS map and the rings and return error from
bnxt_set_channels().  This I can easily change.

I think I misunderstood your original question.  There is another code
path that will change the RSS map to default if we cannot reserve the
number of rings from firmware that were promised earlier from
bnxt_check_rings().  I was referring to this code path earlier.

>
> I'd prefer if the driver wrapped the rss indexes, and printed a
> warning, but left the config intact. And IMO set_channels should
> return an error.

Right.  I think it is clear now.  I will make this change in v2 plus
the other feedback you provided.  Thanks.
