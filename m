Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48C6205662
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbgFWPyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:54:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35959 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733013AbgFWPyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592927681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hkLiUukuiXYIVGoeVwJVWCpKIqIZbdauaKoo+m3/3nA=;
        b=JeSiDnv7WLMnMniySAlnnhrD6rLAYJWZnRc5Chn1Yq/5cS+9P1yCF3bXOkBOK/qPV8v8B7
        k1pSCoONhpD6Kw4+hD/7VFPN9haNkCS8sLw4wZZzC/n839km0OSBPQ0XGLMxJ/gOsAGZFS
        FL1N1+cvK1AlhV3G+RHVxp3jI8nv0Gw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-UuzjMa1CPCSTKSzxgfHKRw-1; Tue, 23 Jun 2020 11:54:37 -0400
X-MC-Unique: UuzjMa1CPCSTKSzxgfHKRw-1
Received: by mail-qk1-f198.google.com with SMTP id o63so9137514qkc.8
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hkLiUukuiXYIVGoeVwJVWCpKIqIZbdauaKoo+m3/3nA=;
        b=cxrTwHocU4Xp5cGSdHyALcEM+z2FrXFI/xLSIcT6CLhniVE5/eME0veNK9S5u/QFu2
         FT8qF0iuYcnJ3o9nJR/1wa7NK+emcmhf6XIqmIYIgJE2C/Q3fPJai6t1x1rqBUtB7nWi
         OKxYg+qpAxyu8stWe+CjWB7aU5afjSeuftFiKg1AhGTzW9pHnhr5/uJUA0r4rPmjgS6j
         VSjazfimGqleO6+YBna/OIHmGTxJX2jcDxXETBOxQ8kNwvfDAmnLIONHgE8kk2K0AdMu
         YHxqyawJ1j4//OLbP9eeZz7KQNEMZKV+6FtHijBpMhXNN9lEKBrbD9K9fmYOec+7mkqy
         iEuQ==
X-Gm-Message-State: AOAM530e76honCe0d8nCqAuBVfeuM7DLYkdr1g/GTh/w2xU0IUeEjrc1
        raNgiJugpsKl4BXtdygl5Id5BNgKaOm/i+Bd1xDgS502Rsi4SBxkYkeloJmNQ9LLXA/+uh5ZNch
        JkNDjONm0k96QDKQ+m9PT0qjvuSWWrr8Y
X-Received: by 2002:ad4:4732:: with SMTP id l18mr3784732qvz.208.1592927676569;
        Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaMrF3dl8inlInwgi9ZvOstGos06ueqsrxUIfXtsW401PD1wsBXR5y4aT0AAuSJXkN6jcwtfzXMTpt1KtoBl0=
X-Received: by 2002:ad4:4732:: with SMTP id l18mr3784714qvz.208.1592927676350;
 Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com> <20200622115946-mutt-send-email-mst@kernel.org>
 <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com> <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
 <20200623042456-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200623042456-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 23 Jun 2020 17:54:00 +0200
Message-ID: <CAJaqyWfKdOUwnG50a1ni=MBEwfM5qp-h+zj1xbT4xUbvKGP5iw@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 10:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 23, 2020 at 09:00:57AM +0200, Eugenio Perez Martin wrote:
> > On Tue, Jun 23, 2020 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > On 2020/6/23 =E4=B8=8A=E5=8D=8812:00, Michael S. Tsirkin wrote:
> > > > On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
> > > >> On 2020/6/11 =E4=B8=8B=E5=8D=887:34, Michael S. Tsirkin wrote:
> > > >>>    static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> > > >>>    {
> > > >>>     kfree(vq->descs);
> > > >>> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vho=
st_dev *dev)
> > > >>>     for (i =3D 0; i < dev->nvqs; ++i) {
> > > >>>             vq =3D dev->vqs[i];
> > > >>>             vq->max_descs =3D dev->iov_limit;
> > > >>> +           if (vhost_vq_num_batch_descs(vq) < 0) {
> > > >>> +                   return -EINVAL;
> > > >>> +           }
> > > >> This check breaks vdpa which set iov_limit to zero. Consider iov_l=
imit is
> > > >> meaningless to vDPA, I wonder we can skip the test when device doe=
sn't use
> > > >> worker.
> > > >>
> > > >> Thanks
> > > > It doesn't need iovecs at all, right?
> > > >
> > > > -- MST
> > >
> > >
> > > Yes, so we may choose to bypass the iovecs as well.
> > >
> > > Thanks
> > >
> >
> > I think that the kmalloc_array returns ZERO_SIZE_PTR for all of them
> > in that case, so I didn't bother to skip the kmalloc_array parts.
> > Would you prefer to skip them all and let them NULL? Or have I
> > misunderstood what you mean?
> >
> > Thanks!
>
> Sorry about being unclear. I just meant that it seems cleaner
> to check for iov_limit being 0 not for worker thread.

Actually yes, I also think that iov_limit =3D=3D 0 is a better check.
Changing for the next revision if everyone agrees.

Thanks!

>
> --
> MST
>

