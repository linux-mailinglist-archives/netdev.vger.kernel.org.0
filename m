Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A2203504
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgFVKpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:45:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgFVKo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592822698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bd6LBfF9XDzhgzHssZPSe+Lg08kndjqNduL115ZBJfw=;
        b=XFlsqSpPxKZlzuZgZErDpwdZ2hAAQSr3jclfChLSOG1IyzoYl6sPlsTOEh50NgcAnzoG7w
        Wq2zRioRKUYLczQztWA/HvbXXFj6rvZ4MGaV2Il8H9f0ti/2MHNBmme22tQzL0pXcnLLDp
        XsaRhdj9RBcw+YVIifvgIjmkaiLtBBo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-CHNRd72rP4yE-b_raS26yg-1; Mon, 22 Jun 2020 06:44:54 -0400
X-MC-Unique: CHNRd72rP4yE-b_raS26yg-1
Received: by mail-qt1-f198.google.com with SMTP id k23so12967485qtb.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bd6LBfF9XDzhgzHssZPSe+Lg08kndjqNduL115ZBJfw=;
        b=L9KoERKPY65H0WFJJ4K+UzvVlZhqZlmGZ3FFU59QQqxvmAG1cL3sbY0RknYWvrmWUp
         cSujn3yJ05IbmNT+rLoPtEEJ3ZGHEgOaOwPW+rYp99jw72TdvqU/mx7q8mQeyph8JJ2G
         03hroRN0r5rx0kV0N45Y2VYUXHVLcxMmCtjGm80S+31+nO/WY3m5TK/IJKkWQ+KX4gYp
         KFMH3wDgPoWrMzgMAx9IKQUxlHW7CBDXa0Ipg2ZdKYdmZoEjalDzvLIeICXDiDT934mn
         4NgLDc5e9fyO1N8n9bP7PDSDTWj2SlwFuva35EIOnzf0nlHMDLk7FY9euoOHbQQF7ZNF
         pLYA==
X-Gm-Message-State: AOAM533sCHIGkhzAQafXhp9KWHejXbzvQBHxdPAYw87Ye/BEVU78FsRc
        5b8RFL9gC46KTVVZFDqRQuN8pESX8QKSgbwh2bKKpdm/wSgK9M7fu0OlmNJWF6RmeBCcvKae1bV
        JSZ/4q7ybo3dpKCRUrLqBnErzcbLwSxWl
X-Received: by 2002:a37:65cc:: with SMTP id z195mr3486057qkb.89.1592822694167;
        Mon, 22 Jun 2020 03:44:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvnEcVAiDygOEo8OJvdbTYJXbYK5OuvbLC8XhYldjJDXeH7okBCt6wSTRbluvWc7hxWfBdRNbg+6gCp7JsIUc=
X-Received: by 2002:a37:65cc:: with SMTP id z195mr3486036qkb.89.1592822693924;
 Mon, 22 Jun 2020 03:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com> <b6347dad-89e8-61f6-6394-65c301f91dd7@redhat.com>
In-Reply-To: <b6347dad-89e8-61f6-6394-65c301f91dd7@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 22 Jun 2020 12:44:17 +0200
Message-ID: <CAJaqyWdo1J-EoGUj3e2jM6USo0SEOM3xydoaYMhta0Y_YPyS_g@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:07 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/6/20 =E4=B8=8A=E5=8D=882:07, Eugenio Perez Martin wrote:
> > On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> >> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> >> <konrad.wilk@oracle.com> wrote:
> >>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> >>>> As testing shows no performance change, switch to that now.
> >>> What kind of testing? 100GiB? Low latency?
> >>>
> >> Hi Konrad.
> >>
> >> I tested this version of the patch:
> >> https://lkml.org/lkml/2019/10/13/42
> >>
> >> It was tested for throughput with DPDK's testpmd (as described in
> >> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> >> and kernel pktgen. No latency tests were performed by me. Maybe it is
> >> interesting to perform a latency test or just a different set of tests
> >> over a recent version.
> >>
> >> Thanks!
> > I have repeated the tests with v9, and results are a little bit differe=
nt:
> > * If I test opening it with testpmd, I see no change between versions
> > * If I forward packets between two vhost-net interfaces in the guest
> > using a linux bridge in the host:
> >    - netperf UDP_STREAM shows a performance increase of 1.8, almost
> > doubling performance. This gets lower as frame size increase.
> >    - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> > transactions/sec to 5830
> >    - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
>
>
> Which direction did you mean here? Guest TX or RX?

Hi Jason.

For both I created a linux bridge in the host, attach two guest
interfaces with vhost-net, and make the netperf run on them.

>
>
> >    - TCP_RR from 6223.64 transactions/sec to 5739.44
>
>
> Perf diff might help. I think we can start from the RR result which
> should be easier. Maybe you can test it for each patch then you may see
> which patch is the source of the regression.
>

Ok, I will look for differences.

Thanks!

> Thanks
>

