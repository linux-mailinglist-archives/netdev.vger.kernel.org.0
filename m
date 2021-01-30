Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81533095F8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 15:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhA3Obs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 09:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhA3O2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:28:22 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE2FC061574;
        Sat, 30 Jan 2021 06:27:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ox12so17338703ejb.2;
        Sat, 30 Jan 2021 06:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a93E2O15Uo/PM5QU4zf/YJmlKP/wGdTx1BVTlyYBgBM=;
        b=FPBZ+jMaZIGtX6VIGr4EB4f5JCDSLjuWVV36rJ+StQp/VrBH3d1L2xaJU9Jo7XyzVj
         94bEynWJGe7yOvsRx+6Ok4YkYDXsYGn3xM61ykq+LyAxlaVwAx1S7OMPmPYZDuFUXh5J
         oRhHR9lHNDhHWleA01LtY0fxGPF68/pCnF8tyehdOc6eZcXxdQeaD3pXhfEv30qq9gZ7
         x84RQiZ0g/cCtYDyc8+u9IO6Tzxs4Y8LTjA6RVeCUXh00rtMO1NQPdlzfjTRjuxczmPI
         RZ2/5RWrKYSoPJxbk4xCg7uYy4t+W50teqN97qhS/q7LUQjOolc3xYAnA3+sWCPDTbwb
         6+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a93E2O15Uo/PM5QU4zf/YJmlKP/wGdTx1BVTlyYBgBM=;
        b=bZ/zANy3a4W5GkzoNV5PQMlLUPlTTR1pFwhQcDw255WZg+Yvj0bbR+fd0zmrAxv3+g
         qY+6to0qMQ1+OaXKBLH4Pf1pjK0psR+hADA8Kq+xuZ5rs04R7FGd6t9s1YlDUD9a9/+7
         BVhtaVbYR0vWBo4eGkQ3i7LGVZCkpPzd/r2H5KsraC+xoe1JwJ1NUuqgFi+DGEVT8WR7
         fGNW1B4TrIb9y3hK5rHEH9pYcJGH/bcKQCwvwPWLM33t6OfZjnXjGyoyxUD2JwDbhhmf
         wYUSVtXo1UbFObzfIpAcXww37oKpbiqE5oVQ/BlvhaMkU5VTBvrSSKFjE8tQesK3Zl7l
         yO4A==
X-Gm-Message-State: AOAM5322QLPnH20rRSOAnwcjKXlAn1ROp+4jsbmyJZaQpinNYfhSCyfd
        Q9RMyGWbm816B+9qTbMvKKrxXbTtVWcUaBWIio0jhjXE
X-Google-Smtp-Source: ABdhPJxdPL6J7nhcVvIQgfbexzaYAja8asJTjSF8hWKmd858wKG37HqxCuxHDUGGQ48phXmex0Kls7wYEvBla1s/ILo=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr9062724ejj.464.1612016826821;
 Sat, 30 Jan 2021 06:27:06 -0800 (PST)
MIME-Version: 1.0
References: <MWHPR18MB1421B580CF911A13D1369D98DEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
In-Reply-To: <MWHPR18MB1421B580CF911A13D1369D98DEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 30 Jan 2021 09:26:30 -0500
Message-ID: <CAF=yD-+WHAmkXKGa9gSysoA1fUZr-tcEiiTcZ_fODTBB6pghnw@mail.gmail.com>
Subject: Re: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 4:53 AM Hariprasad Kelam <hkelam@marvell.com> wrote=
:
>
> Hi Willem,
>
> > -----Original Message-----
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Sent: Thursday, January 28, 2021 1:50 AM
> > To: Hariprasad Kelam <hkelam@marvell.com>
> > Cc: Network Development <netdev@vger.kernel.org>; LKML <linux-
> > kernel@vger.kernel.org>; David Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; Sunil Kovvuri Goutham
> > <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> > Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> > <jerinj@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>;
> > Felix Manlunas <fmanlunas@marvell.com>; Christina Jacob
> > <cjacob@marvell.com>; Sunil Kovvuri Goutham
> > <Sunil.Goutham@cavium.com>
> > Subject: [EXT] Re: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CM=
D
> > to get PHY FEC statistics
> >
> > On Wed, Jan 27, 2021 at 4:04 AM Hariprasad Kelam <hkelam@marvell.com>
> > wrote:
> > >
> > > From: Felix Manlunas <fmanlunas@marvell.com>
> > >
> > > This patch adds support to fetch fec stats from PHY. The stats are pu=
t
> > > in the shared data struct fwdata.  A PHY driver indicates that it has
> > > FEC stats by setting the flag fwdata.phy.misc.has_fec_stats
> > >
> > > Besides CGX_CMD_GET_PHY_FEC_STATS, also add CGX_CMD_PRBS and
> > > CGX_CMD_DISPLAY_EYE to enum cgx_cmd_id so that Linux's enum list is i=
n
> > > sync with firmware's enum list.
> > >
> > > Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
> > > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > > Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
> > > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> >
> >
> > > +struct phy_s {
> > > +       struct {
> > > +               u64 can_change_mod_type : 1;
> > > +               u64 mod_type            : 1;
> > > +               u64 has_fec_stats       : 1;
> >
> > this style is not customary
>
> These structures are shared with firmware and stored in a shared memory. =
Any change in size of structures will break compatibility. To avoid frequen=
t compatible issues with new vs old firmware we have put spaces where ever =
we see that there could be more fields added in future.
> So changing this to u8 can have an impact in future.

My comment was intended much simpler: don't add whitespace between the
bit-field variable name and its size expression.

  u64 mod_type:1;

not

  u64 mod_type     : 1;

At least, I have not seen that style anywhere else in the kernel.
