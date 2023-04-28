Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C63C6F1A0F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346248AbjD1N4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 09:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346244AbjD1N4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 09:56:46 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DCE2D49;
        Fri, 28 Apr 2023 06:56:45 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-5f95cedb135so19156d6.1;
        Fri, 28 Apr 2023 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682690204; x=1685282204;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lZNOvuxZAzbjpYfchXeKaB+I7zPF9dkZAdqgkYv8Ho=;
        b=lgHWYmqQiDhDj11Lqd4DHHsZ4s8tQii9QwdSJf9Mm0ETXBwwGu99pR+740afudCkZi
         VVlJ6WYsnq9YXogiw4AKu3hP5+e0E8K+QKe1u8GOL5rPcTSmxLEzJRi/U7eK2SXeBpe/
         CcdSN/lLEbkxU2xzYYGiBSRuBZG4mJP0FxDcQV8iJap4nCHkoUHUNlOCAdlUAwkXuov9
         aC2gqjSjY8BijoQCjUvwPFbUmJqdrhmvZQoveb8Fc5kMIEZGrf332OItmHkV+8nFswMY
         +yq4CnfFEvJ0dFl36FR1WdqAzIR3mNG7QCEc3qpeON3iNmN/97CMrXJub8kmX+WDtlyo
         ETew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682690204; x=1685282204;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/lZNOvuxZAzbjpYfchXeKaB+I7zPF9dkZAdqgkYv8Ho=;
        b=JiB2LdyP1POGugAE8Tvxa0VJwoyOI7KU2uy65w2sDiHcJwFoZ9DZ1K+nxyeOgGyYjH
         mlWlkpEg8tlyxsYuDgdFhrvh3VBSeVqqh0c3s49ZUyEibBQUxIxhow9a6CDWRK31E0AZ
         e9l6/dQzqfwtuWJxfOEugI1F7l7+68Sp7N5FmT2C0kQdy2ZZar40Axz7wlhetDxNxIEy
         JXbfvw/BkQLXUUbt6dSnzHuj12biLuuZvx0bwXzMs2YDNlEz0m/jA8mFhHrN0A8qmejD
         EZzTC9fzBRaI9smRmtUvzv+LB1pubPady7w1wpwlY8tdzHnSpnO/O2VIsafl/dfDbkoq
         f/eA==
X-Gm-Message-State: AC+VfDwC8/WcPjDgk5wWfq3JJGsMytYnBBBS7sDM9+yIUkBU8+9hwZuT
        FhAt47TS0JBC1DAoptxO6LPEwXUteJg=
X-Google-Smtp-Source: ACHHUZ6QPJNVSm7jJadTHqMP+cKkemRtJOCp+cou04qzwfFy0MgdI7ZsI9Ut9x1fI+DHsxjLb2ZM0g==
X-Received: by 2002:a05:6214:2244:b0:5ef:5e1b:a369 with SMTP id c4-20020a056214224400b005ef5e1ba369mr10143325qvc.13.1682690204526;
        Fri, 28 Apr 2023 06:56:44 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id m14-20020a0c9d0e000000b0061665028dc2sm1843262qvf.28.2023.04.28.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 06:56:44 -0700 (PDT)
Date:   Fri, 28 Apr 2023 09:56:43 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Message-ID: <644bd09bca7e5_29e48c29469@willemb.c.googlers.com.notmuch>
In-Reply-To: <32eb2826-6322-2f3e-9c48-7fd9afc33615@bytedance.com>
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
 <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
 <252ee222-f918-426e-68ef-b3710a60662e@bytedance.com>
 <1682579624.5395834-1-xuanzhuo@linux.alibaba.com>
 <20230427041206-mutt-send-email-mst@kernel.org>
 <1682583225.3180113-2-xuanzhuo@linux.alibaba.com>
 <20230427042259-mutt-send-email-mst@kernel.org>
 <32eb2826-6322-2f3e-9c48-7fd9afc33615@bytedance.com>
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qi Zheng wrote:
> 
> 
> On 2023/4/27 16:23, Michael S. Tsirkin wrote:
> > On Thu, Apr 27, 2023 at 04:13:45PM +0800, Xuan Zhuo wrote:
> >> On Thu, 27 Apr 2023 04:12:44 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>> On Thu, Apr 27, 2023 at 03:13:44PM +0800, Xuan Zhuo wrote:
> >>>> On Thu, 27 Apr 2023 15:02:26 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> >>>>>
> >>>>>
> >>>>> On 4/27/23 2:20 PM, Xuan Zhuo wrote:
> >>>>>> On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> >>>>>>> For multi-queue and large rx-ring-size use case, the following error
> >>>>>>
> >>>>>> Cound you give we one number for example?
> >>>>>
> >>>>> 128 queues and 16K queue_size is typical.
> >>>>>
> >>>>>>
> >>>>>>> occurred when free_unused_bufs:
> >>>>>>> rcu: INFO: rcu_sched self-detected stall on CPU.
> >>>>>>>
> >>>>>>> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> >>>>>>> ---
> >>>>>>>    drivers/net/virtio_net.c | 1 +
> >>>>>>>    1 file changed, 1 insertion(+)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>>>>> index ea1bd4bb326d..21d8382fd2c7 100644
> >>>>>>> --- a/drivers/net/virtio_net.c
> >>>>>>> +++ b/drivers/net/virtio_net.c
> >>>>>>> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
> >>>>>>>    		struct virtqueue *vq = vi->rq[i].vq;
> >>>>>>>    		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> >>>>>>>    			virtnet_rq_free_unused_buf(vq, buf);
> >>>>>>> +		schedule();
> >>>>>>
> >>>>>> Just for rq?
> >>>>>>
> >>>>>> Do we need to do the same thing for sq?
> >>>>> Rq buffers are pre-allocated, take seconds to free rq unused buffers.
> >>>>>
> >>>>> Sq unused buffers are much less, so do the same for sq is optional.
> >>>>
> >>>> I got.
> >>>>
> >>>> I think we should look for a way, compatible with the less queues or the smaller
> >>>> rings. Calling schedule() directly may be not a good way.
> >>>>
> >>>> Thanks.
> >>>
> >>> Why isn't it a good way?
> >>
> >> For the small ring, I don't think it is a good way, maybe we only deal with one
> >> buf, then call schedule().
> >>
> >> We can call the schedule() after processing a certain number of buffers,
> >> or check need_resched () first.
> >>
> >> Thanks.
> > 
> > 
> > Wenliang, does
> >              if (need_resched())
> >                      schedule();
> 
> Can we just use cond_resched()?

I believe that is preferred. But v2 still calls schedule directly.

