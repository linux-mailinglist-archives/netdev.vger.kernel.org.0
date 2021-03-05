Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBA32E02A
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEDiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCEDiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:38:00 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E88C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 19:37:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w17so793430ejc.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 19:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EWyxb7ZF0q19re3TKnDSqg2Hfk1VfihXa9QY0hUoz9E=;
        b=q6E6/P5/bLlbRqpphJ58eBSCESMSvgxSXNCtDtRBh552X89e/X9AjirV47s7IKejog
         v0nPYNio+rfkWbsdD6WDsBKTUkTRMNV1XsouZ9mtTITDFQFvL/3sMxTa6hWUL2iObq5l
         PapF7w2o+muJDMtwcS4u+V3+gMYH0jpuDPwikrc8JFM87GbI/KBiy2U7gPqXolHOSImE
         igZ8wiHwfhBi5NdtsctAfNLkgCOr6L/viDXArLVBLvmU/BNDadMsGlhyQtcCbOqqVs29
         8APP6k8ly1mdbmV6A/zPSn7OpCL8e4+Mpp6j4muJam6YVWK60LTRQtOdnsp5BdTXxcgH
         WeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EWyxb7ZF0q19re3TKnDSqg2Hfk1VfihXa9QY0hUoz9E=;
        b=QMqCO5VMFd59F3qdRyp1/byMO7ry4i+uGkhLud/bnhN8+KMxcS60CnTTtCwOoU4FOA
         edjWbJNLdT4zjP0rZIidpnDamm8ao5cO2WanrMXUn9RYw0ptpb0Od6sYtnvwYcNnrVHT
         XKTYlCDgk092UI6lS7GzFLInuo0bmj3B/ppjAMgGMwuCbee0fU1y9T/W7pUPLEdzZtNF
         dEjE3JPYX/gaY/I/Ack5c+xcpvsmc+CTrLddvQMiWsiqHkz7EvV5Pv+gnDyflxPlnIfr
         dWAHXPta9VobxYuZnH8YA8f6Q1A+qJpHLaCLIYL39QplXsyeSL6rIDuhPJSyaSeIgYGi
         mbVA==
X-Gm-Message-State: AOAM531RhNiy4p9TmKF8skx+T4FBOL4itrVXJi/iwXR0qpN1r+mFqtbq
        76DluSVuTjWym+KenPElcAGWVdcspo+ijc2KmoEE
X-Google-Smtp-Source: ABdhPJxWFC4tVSup0eWv+uEIXAYfO9dxY1nbFMC/0JFD8gj7j27meC0DHlK8QAEMC2JqjU1V79+K7Z37BKD35+Dm2mg=
X-Received: by 2002:a17:906:1b41:: with SMTP id p1mr552966ejg.174.1614915477313;
 Thu, 04 Mar 2021 19:37:57 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-12-xieyongji@bytedance.com>
 <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com> <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
 <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
In-Reply-To: <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 11:37:46 +0800
Message-ID: <CACycT3s+eO7Qi8aPayLbfNnLqOK_q1oB6+d+51hudd-zZf7n8w@mail.gmail.com>
Subject: Re: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
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

On Fri, Mar 5, 2021 at 11:11 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/4 4:19 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Thu, Mar 4, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>> Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
> >>> injecting virtqueue's interrupt to the specified cpu.
> >>
> >> How userspace know which CPU is this irq for? It looks to me we need t=
o
> >> do it at different level.
> >>
> >> E.g introduce some API in sys to allow admin to tune for that.
> >>
> >> But I think we can do that in antoher patch on top of this series.
> >>
> > OK. I will think more about it.
>
>
> It should be soemthing like
> /sys/class/vduse/$dev_name/vq/0/irq_affinity. Also need to make sure
> eventfd could not be reused.
>

Looks like we doesn't use eventfd now. Do you mean we need to use
eventfd in this case?

Thanks,
Yongji
