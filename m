Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB30306DBF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhA1GoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhA1GoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:44:09 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D74C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 22:43:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so6175293ejc.1
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 22:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o7+Pby8e2R99rOdoZOYeLtvRv3cjQ5UmuprwF9knKn8=;
        b=FFkqqprW75VlMmYs0znavBz5Q8Im1qY/XXrSman/lI4JZjc70ahX5oJMarnuCUbvIc
         yZ1PO0awLHDxRVQsekuHK0W0fjN1P3xj/vnWSCuxh+FGguxGJqHeBTamRPSsOpcLPJlz
         RElSMf4RCt6SztKZV13T4N1a/B1NIGDCa9g7OYhoP3wXWITTGmjMgPTPpXf++r+QF+mQ
         g3clKrEH/ZX0cs6Y/gtQnZk2vd3PrZnR745SG2n/AtNyKppbBvjX1cZrjRGs/4V0pYNr
         sNGo1V52kAFsMCZj5YJvLWhY6e8rkmwdDIiMFqLcaImeViBDxAD0gQNJoh5JkEEYtLLB
         6t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o7+Pby8e2R99rOdoZOYeLtvRv3cjQ5UmuprwF9knKn8=;
        b=ASeSMDOhGCpZe3AcneCcMN2jweWOqadV0WmCAxz9VeiYUeYqosmA8paJxJUdoZD5gx
         CHHQPenNKQzgDduwlAZ61UsgJJvNhyZb6fJP4Ivl2IG0yJt5OgRKeb78oiKcJmtfcLU8
         mO7ViWkky4Wf1BBuHrOrnDV+F/maEDhs8Hn4JTc1IA+TQtTCPWysW0IsEc8YpbpmMYnc
         myalRYcacUFz2OXyymPR2+xf9Bq177fxVUMMjxufFREFo4n+Cv8oxVYGIJo+s2Mre3SM
         V+20xnUKUhMrnbTvklBh8f39++HhS51PFGh2w6gIbyk8ohyaZrfTTIpjdbxg033QCU4v
         o7Sg==
X-Gm-Message-State: AOAM5315kyUTb54iXOGAs71rP4pojV3bosYSt0oEPSEAY0Ehg1gmxOfw
        p6AFzaG0Y9FB3dQFM0UWMwfxdrz47Ip4ZRD5MDtb
X-Google-Smtp-Source: ABdhPJwJNvRpomqMRznRTxiFyPthpJuctZnqW2JgzR705CTKACKbSdDjP/NBg+4Y0UDASwp10FKgqn5Bn/zS0xEdqFY=
X-Received: by 2002:a17:906:128e:: with SMTP id k14mr9414841ejb.427.1611816208026;
 Wed, 27 Jan 2021 22:43:28 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com> <1bb3af07-0ec2-109c-d6d1-83d4d1f410c3@redhat.com>
 <CACycT3uJtKqEp7CHBKhvmSL41gTrCcMrt_-tacGCbX1nabuG6w@mail.gmail.com>
 <ea170064-6fcf-133b-f3bd-d1f1862d4143@redhat.com> <CACycT3upvTrkm5Cd6KzphSk=FYDjAVCbFJ0CLmha5sP_h=5KGg@mail.gmail.com>
 <bdb57829-d4a4-eaca-d43b-70d39df96bf6@redhat.com>
In-Reply-To: <bdb57829-d4a4-eaca-d43b-70d39df96bf6@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 28 Jan 2021 14:43:17 +0800
Message-ID: <CACycT3sfd8LOS+3w1LGZe1CaUD3B-3ga2OqKBxA_vhaOL0kg2g@mail.gmail.com>
Subject: Re: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 2:14 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/28 =E4=B8=8B=E5=8D=882:03, Yongji Xie wrote:
> >>>>> +
> >>>>> +static const struct file_operations vduse_domain_fops =3D {
> >>>>> +     .mmap =3D vduse_domain_mmap,
> >>>>> +     .release =3D vduse_domain_release,
> >>>>> +};
> >>>> It's better to explain the reason for introducing a dedicated file f=
or
> >>>> mmap() here.
> >>>>
> >>> To make the implementation of iova_domain independent with vduse_dev.
> >> My understanding is that, the only usage for this is to:
> >>
> >> 1) support different type of iova mappings
> >> 2) or switch between iova domain mappings
> >>
> >> But I can't think of a need for this.
> >>
> > For example, share one iova_domain between several vduse devices.
>
>
> Interesting.
>
>
> >
> > And it will be helpful if we want to split this patch into iova domain
> > part and vduse device part. Because the page fault handler should be
> > paired with dma_map/dma_unmap.
>
>
> Ok.
>
> [...]
>
>
> >
> >>>> This looks not safe, let's use idr here.
> >>>>
> >>> Could you give more details? Looks like idr should not used in this
> >>> case which can not tolerate failure. And using a list to store the ms=
g
> >>> is better than using idr when the msg needs to be re-inserted in some
> >>> cases.
> >> My understanding is the "unique" (probably need a better name) is a
> >> token that is used to uniquely identify a message. The reply from
> >> userspace is required to write with exact the same token(unique). IDR
> >> seems better but consider we can hardly hit 64bit overflow, atomic mig=
ht
> >> be OK as well.
> >>
> >> Btw, under what case do we need to do "re-inserted"?
> >>
> > When userspace daemon receive the message but doesn't reply it before c=
rash.
>
>
> Do we have code to do this?
>

Yes, in patch 9.

>
> >
> >>>> So we had multiple types of requests/responses, is this better to
> >>>> introduce a queue based admin interface other than ioctl?
> >>>>
> >>> Sorry, I didn't get your point. What do you mean by queue-based admin
> >>> interface? Virtqueue-based?
> >> Yes, a queue(virtqueue). The commands could be passed through the queu=
e.
> >> (Just an idea, not sure it's worth)
> >>
> > I considered it before. But I found it still needs some extra works
> > (setup eventfd, set vring base and so on) to setup the admin virtqueue
> > before using it for communication. So I turn to use this simple way.
>
>
> Yes. We might consider it in the future.
>

Agree.

>
>
> >
> >>>> Any reason for such IOTLB invalidation here?
> >>>>
> >>> As I mentioned before, this is used to notify userspace to update the
> >>> IOTLB. Mainly for virtio-vdpa case.
> >> So the question is, usually, there could be several times of status
> >> setting during driver initialization. Do we really need to update IOTL=
B
> >> every time?
> >>
> > I think we can check whether there are some changes after the last
> > IOTLB updating here.
>
>
> So the question still, except reset (write 0), any other status that can
> affect IOTLB?
>

OK, I get your point. The status would not affect IOTLB. The reason
why we do IOTLB updating here is we can't do it in dma_map_ops which
might work in an atomic context. So I want to notify userspace to
update IOTLB before I/O is processed. Of course, it's not a must
because userspace can manually query it.

Thanks,
Yongji
