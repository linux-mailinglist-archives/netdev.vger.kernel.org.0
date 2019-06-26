Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DF656DD0
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfFZPgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:36:39 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35072 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfFZPgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:36:38 -0400
Received: by mail-yw1-f65.google.com with SMTP id k128so1397740ywf.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nB2SlIBqZ7G1UjtTzO1Yn/x7hThan4DYNNuCoZrdMGc=;
        b=IaGM59eH59k6bwEWOreYpMBhZBij5GVXZtYQfz4HtOADv00s2mss3VXMaVkNWAAQ/t
         mn4vrvrpfDjxewcC1tonypR2ZNcCM7OtveCyjNOR/atT0DkA+vBURZgZU2g+bNlPoDNa
         sxoI2/1ubQZY8ziyyTwMYejLpSOGvhu4Kw3MFZglfssraqux6YMQHkfj+Bst58dvBNZA
         u/ztiL+y7xAYFT19tVcwp7GT6Psdjo1IqgvZdlDFrxhnt27DkVeE72d3xc1NI6T9dxyG
         MpOshn4sTw1PZ82LnEBFhYnK375ukdOVgidZpEOssL7/CQ4C3jEm5yMHtu2sKR3MDUj2
         9JVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nB2SlIBqZ7G1UjtTzO1Yn/x7hThan4DYNNuCoZrdMGc=;
        b=LC7Fz2HCOMn4bA546nZVyzWO9waBugKRK77GlCoEDrwjt6hDt0fJuj4gZt1+jrcRHd
         yBdYpD++9xxYIwnlM/EKcnmv72PfwWGuCGa0GAzBqXCuOCq/a4SZpdZWljr+hYQKv0Te
         LCRDCMGyMHZo9UWD1ZhaxAeHeeHai+lrkIFPL6QVSNLI9+XONqc8F8KZpWPcbgTh3rRV
         rqM7yFqhv+qVesey28//LGLEIeyxMelrh41HpqdjgAGdbj1eLSpA0ByGd28yc494u+1h
         sTiC2PVYVKmFA5D6JppnINDsz2drnsB2qbGXnNzph2QZuWxOLBAM+lbSc0fcJvoTSRZe
         k0Uw==
X-Gm-Message-State: APjAAAVgIAGRektLHbF3iGUIdTNLfB3pnWkrKoRNQPzLgyJ1/OTAe49T
        01OYVdYmdp68fGB6zD31l+2It/d3
X-Google-Smtp-Source: APXvYqwb/GM31RlVsoX57M2XcitbnBIDsaYRDBLzYiDJkK1viz+5nTVu7SbVHOMS8ECASOcyD7vJzw==
X-Received: by 2002:a81:ee05:: with SMTP id l5mr3302178ywm.245.1561563396689;
        Wed, 26 Jun 2019 08:36:36 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id i84sm1381937ywi.0.2019.06.26.08.36.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:36:35 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id w9so1565591ybe.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:36:35 -0700 (PDT)
X-Received: by 2002:a25:908b:: with SMTP id t11mr3363414ybl.473.1561563395120;
 Wed, 26 Jun 2019 08:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190617074858.32467-1-bpoirier@suse.com> <20190617074858.32467-5-bpoirier@suse.com>
 <DM6PR18MB269776CBA6B979855AD215A8ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113959.GC27420@f1>
In-Reply-To: <20190626113959.GC27420@f1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 11:35:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc7Gt0v8_KGEibC_8LKAe-yvL10KuJeoiAdYFDiED-5cQ@mail.gmail.com>
Message-ID: <CA+FuTSc7Gt0v8_KGEibC_8LKAe-yvL10KuJeoiAdYFDiED-5cQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
To:     Benjamin Poirier <bpoirier@suse.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 7:40 AM Benjamin Poirier <bpoirier@suse.com> wrote:
>
> On 2019/06/26 09:36, Manish Chopra wrote:
> > > -----Original Message-----
> > > From: Benjamin Poirier <bpoirier@suse.com>
> > > Sent: Monday, June 17, 2019 1:19 PM
> > > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > > Subject: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
> > >
> > > External Email
> > >
> > > ----------------------------------------------------------------------
> > > Tx rings have sbq_buf_size = 0 but there's no case where the code actually
> > > tests on that value. We can remove sbq_buf_size and use a constant instead.
> > >
> >
> > Seems relevant to RX ring, not the TX ring ?
>
> qlge uses "struct rx_ring" for rx and for tx completion rings.
>
> The driver's author is probably laughing now at the success of his plan
> to confuse those who would follow in his footsteps.

:-)

Reviewed-by: Willem de Bruijn <willemb@google.com>
