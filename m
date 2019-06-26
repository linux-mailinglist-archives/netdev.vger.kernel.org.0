Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B5B56DEA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfFZPmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:42:45 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34920 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfFZPmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:42:44 -0400
Received: by mail-yb1-f194.google.com with SMTP id i203so1598762ybg.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUS9iOJO46+OjuXG4glfIrpLoJYM6+HsSFmIZvk7Cak=;
        b=nDcgkW4+Ew3J1MJ8qjP7nEF1t4Y5OxKPqc9M8MYsbYrjR339iXJyaC5E4gOXk3e1xK
         cF2YMlbDgZ1QIqhYX996ZbpU1VhOa23C5R74TMODX5lL5Z2m6y6Gn5H8F+EPdPiuMB3S
         HFzDug6G6OGlXG4dKNIrQa1AdMiM7r6XDCpGsNDDLjG1riBS/IR73VqAzMe+FmGJRS+i
         +rMsvVBL0Z1S1CoCgGwuDHGNIZ82GjdYM3GErlWfuLKz91wbBY36BjtbKYT4IBToK87s
         1ThDWUODbbXztcudNFMVDpFOs1OCG6rgDryQNaHLbSu6x11lIVRXM7+ixoaMAVITKb2s
         8ioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUS9iOJO46+OjuXG4glfIrpLoJYM6+HsSFmIZvk7Cak=;
        b=GD6qGe0KI9fcpDMGVfQxYq0KWm9MZu8o7xJ48ZT61BjcyGBmq1tFdgw3j4/kcTK0Cx
         Qb0U1IcGcl3bLD7adyLIeJ46tAyuJ04PJoOcm0TFIlkQexKAnOo1KsMBGn0k3pvmWLiB
         rdfIyvJpxPaZffGq0eMfq54LNXt3EsBpmAt5PGNzyEeYe5kA+bynavxXuy7T/6/YxUNQ
         EOJsyIbinqs+LL0JgYo2w1vfMJkbYmrBwOLAdEMjj0QfVDqoqyDBsfmzCJImDx42nkQr
         ECWv0lJQzTmua6ScQTShT1wbN4sMlVRk9EFNeLLY1vTHgeLehdAevCixnCZ4aHlbHB0H
         svCA==
X-Gm-Message-State: APjAAAWE28lMGCMHopRFWvI1O3A5SbLwXSf6yymmzfcS78tB82WkXVsK
        ihKHFykknNuERCwKZmqht3k4o8bh
X-Google-Smtp-Source: APXvYqxqDGT5pig7g8zXkfjxrW/HpJa6td/Jcp2H+W+hMGde0GyhxA001IKnrZuqSdeqH2O85TCimw==
X-Received: by 2002:a25:cfd1:: with SMTP id f200mr3141288ybg.295.1561563763523;
        Wed, 26 Jun 2019 08:42:43 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id x85sm4695027ywx.63.2019.06.26.08.42.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:42:42 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id p201so1293503ybg.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:42:42 -0700 (PDT)
X-Received: by 2002:a25:aa48:: with SMTP id s66mr2857109ybi.46.1561563762319;
 Wed, 26 Jun 2019 08:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190617074858.32467-1-bpoirier@suse.com> <20190617074858.32467-3-bpoirier@suse.com>
 <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113726.GB27420@f1>
In-Reply-To: <20190626113726.GB27420@f1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 11:42:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfKw6aaXk0hA0p_AUp9Oa_D+5Bwst8HUz7mJM-wO5Obow@mail.gmail.com>
Message-ID: <CA+FuTSfKw6aaXk0hA0p_AUp9Oa_D+5Bwst8HUz7mJM-wO5Obow@mail.gmail.com>
Subject: Re: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
To:     Benjamin Poirier <bpoirier@suse.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 7:37 AM Benjamin Poirier <bpoirier@suse.com> wrote:
>
> On 2019/06/26 09:24, Manish Chopra wrote:
> > > -----Original Message-----
> > > From: Benjamin Poirier <bpoirier@suse.com>
> > > Sent: Monday, June 17, 2019 1:19 PM
> > > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > > Subject: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
> > >
> > > External Email
> > >
> > > ----------------------------------------------------------------------
> > > lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_order is
> > > present once in the ql_adapter structure. All rings use the same buf size, keep
> > > only one copy of it. Also factor out the calculation of lbq_buf_size instead of
> > > having two copies.
> > >
> > > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > > ---
> [...]
> >
> > Not sure if this change is really required, I think fields relevant to rx_ring should be present in the rx_ring structure.
> > There are various other fields like "lbq_len" and "lbq_size" which would be same for all rx rings but still under the relevant rx_ring structure.

The one argument against deduplicating might be if the original fields
are in a hot cacheline and the new location adds a cacheline access to
a hot path. Not sure if that is relevant here. But maybe something to
double check.
