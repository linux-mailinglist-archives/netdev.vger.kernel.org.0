Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A0759E4B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfF1O4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 10:56:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41196 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfF1O4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 10:56:41 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so11184834eds.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 07:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTB8itc7Hdv5V/+dut2HB/mQ8drlexx0jfcMZPn/UMg=;
        b=oXEAK0d9RSmujgN3R7RFbaSXMnq8GelyuogkqcuNOi6TclZmDLp7/Wpb+D5JN5gFGk
         g/owKu3WwHJgKtJ7942+DWdyAvykLbkn+AeYpnJcx2hBwmRC3uZQxOtT148S2BHO0HaO
         CDkJBHTap2INlAJW3KBbBnqg1q+gQmeCLfAIjyQ/MTAatHyfXK/CZ105PQsNpeuhxNc7
         ogxdeb06B7YqnSM9oJhKyzOx68+VurrDkqDun5Vca7ya4GB/ScKEkwLT73g+NbuhxTll
         Atd9wUwhYQHsIbOWXmgHWt80hrSdlsbJGmGTXEfZaNVYw5dHYhmZBHRIwIrcDyYJTS29
         lLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTB8itc7Hdv5V/+dut2HB/mQ8drlexx0jfcMZPn/UMg=;
        b=FovN9duVzvOpAHHoRFvARhpRZj7J82mGjyPUH2Jehy1nXNV1glemTfH+S0zvXEQty6
         zLw9NePYHQW0QxaW8q5EzK5QjkkW201ck5qVaMP/F/ffawOfwJ5BJSa3UMPf2l/AHDuu
         mDCc7kS/kzjqWC/fi2DtH+lsRlWAT3xdelnIgSEEjXuTByP0LvpezH5cXE3JZdmSou1h
         MKZy+Vu8myW90XPqjnTG8RMRwNONt9GRpWqQYk0IJDg2JX8mYpIpRcmldQbmjHq6kfPW
         v/y0SGPE6fmlkoFsJc6Njn+wna5nJlLbVsCa077eJ0TWzYqZddo9/B4WumA3nfArsm5M
         qL9g==
X-Gm-Message-State: APjAAAWGv5iVP0PRHuULT+BtxlIFbXeji2xzyTGJE+EPyOgp0PWWu5Ny
        4c4Spm0n5eNiukQg2gCXGRk5TnfZ0j2XCHf4d0I=
X-Google-Smtp-Source: APXvYqz/Dm4hrU5Hkx7/DJDCjlbSxpOeJfCwPDq1huUAA45vQLsF87KFYvqqOcHvHKIt3YVJDxKiau2b8QJiX23AYYY=
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr8963605ejm.133.1561733799242;
 Fri, 28 Jun 2019 07:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190617074858.32467-1-bpoirier@suse.com> <20190617074858.32467-3-bpoirier@suse.com>
 <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113726.GB27420@f1> <CA+FuTSfKw6aaXk0hA0p_AUp9Oa_D+5Bwst8HUz7mJM-wO5Obow@mail.gmail.com>
 <20190628085713.GB14978@f1>
In-Reply-To: <20190628085713.GB14978@f1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 10:56:02 -0400
Message-ID: <CAF=yD-+wq4U0bwiSgHhfSiWXgE9JOefqp69Nxcwz5JsQcS7_Uw@mail.gmail.com>
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

On Fri, Jun 28, 2019 at 4:57 AM Benjamin Poirier <bpoirier@suse.com> wrote:
>
> On 2019/06/26 11:42, Willem de Bruijn wrote:
> > On Wed, Jun 26, 2019 at 7:37 AM Benjamin Poirier <bpoirier@suse.com> wrote:
> > >
> > > On 2019/06/26 09:24, Manish Chopra wrote:
> > > > > -----Original Message-----
> > > > > From: Benjamin Poirier <bpoirier@suse.com>
> > > > > Sent: Monday, June 17, 2019 1:19 PM
> > > > > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > > > > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > > > > Subject: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
> > > > >
> > > > > External Email
> > > > >
> > > > > ----------------------------------------------------------------------
> > > > > lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_order is
> > > > > present once in the ql_adapter structure. All rings use the same buf size, keep
> > > > > only one copy of it. Also factor out the calculation of lbq_buf_size instead of
> > > > > having two copies.
> > > > >
> > > > > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > > > > ---
> > > [...]
> > > >
> > > > Not sure if this change is really required, I think fields relevant to rx_ring should be present in the rx_ring structure.
> > > > There are various other fields like "lbq_len" and "lbq_size" which would be same for all rx rings but still under the relevant rx_ring structure.
> >
> > The one argument against deduplicating might be if the original fields
> > are in a hot cacheline and the new location adds a cacheline access to
> > a hot path. Not sure if that is relevant here. But maybe something to
> > double check.
> >
>
> Thanks for the hint. I didn't check before because my hunch was that
> this driver is not near that level of optimization but I checked now and
> got the following results.

Thanks for the data. I didn't mean to ask you to do a lot of extra work.
Sorry if it resulted in that.

Fully agreed on your point about optimization (see also.. that 784B
struct with holes). I support the patch and meant to argue against the
previous response: this cleanup makes sense to me, just take a second
look at struct layout. To be more crystal clear:

Acked-by: Willem de Bruijn <willemb@google.com>
