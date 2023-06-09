Return-Path: <netdev+bounces-9443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7803972914A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A770D1C210DD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736998F5C;
	Fri,  9 Jun 2023 07:37:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621024C67
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:37:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D52D7E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686296238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bYfLgsVFNCZ8nRyAtdqv5Pzu6gYjvla7lXAg7Aj2Y+s=;
	b=OnhqCBymOShT6mrRhsbBNdUscX6jlm0WjT882anBdBNRFMjQaG46L+MLd+2hjnfR8yOvq7
	Up+XgvJRuh/zitui8eTOVIlp1PohX7DWtJPv/Y5ZvAIMEAFUrvQmvXFsSVX/hT2BTM8Id9
	l0AKCTmgZTmctbS/zhQAHC3q3fhlMow=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-sH4NV7FkOs6I97wQH27kDQ-1; Fri, 09 Jun 2023 03:37:17 -0400
X-MC-Unique: sH4NV7FkOs6I97wQH27kDQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5149385acd0so1695329a12.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 00:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686296236; x=1688888236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYfLgsVFNCZ8nRyAtdqv5Pzu6gYjvla7lXAg7Aj2Y+s=;
        b=i4poeLGJA0keF7Bk7tvDqAEsJiRcGdACr6I4G7VX85BYpn0dvEebTA5ahEkVw8dJp4
         njINqS6BeP7vCq2FKszWhGQzTem5taH4HtCDIn1a4+O5HAF/ra61sv2ztEpLhSkfAXv1
         wq6wIr6C3bbwsXDbNVYYX4xQ+/kjHxu6Ld2XxMytUsbB6iMFhaoCtZMTZlq5kcdCD2j4
         HrgPU4zrVzXavBlZSF/JVauRk6zlIoUex4lOOvi8CJcyDkiKlNrG+u6u6sDX5Rw1mIMA
         ZsxoVOOf9NLQ3Iw7qNqbPdBKXewM9xpb3iIC4JPXkfc9ckcMuC0umGDL+uxV/NMqIVRc
         5Emg==
X-Gm-Message-State: AC+VfDw9jQ3RzGCHcK2uSLyP/3R3uCZEXTXvvv67N00QwLBJZdBo9Z1J
	K/bidcpDlac60rW8axfRG25YGCFHVSj0TZ6FtwWTnvE13Ag59WB9FFyCOmcesi+riEH+SIp8ihE
	1XwEDH1zwi1P0laNG
X-Received: by 2002:a17:907:7ba9:b0:978:62c1:6b4b with SMTP id ne41-20020a1709077ba900b0097862c16b4bmr1270367ejc.61.1686296236529;
        Fri, 09 Jun 2023 00:37:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78zAqU5nBkhqiiGWgfNgN+8MZicyBWov8iB0bm42uQl0fbHbGsJwIj+9uJE05ls1/Y70zGGw==
X-Received: by 2002:a17:907:7ba9:b0:978:62c1:6b4b with SMTP id ne41-20020a1709077ba900b0097862c16b4bmr1270345ejc.61.1686296236130;
        Fri, 09 Jun 2023 00:37:16 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-111.business.telecomitalia.it. [87.12.25.111])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709063bc700b00965b5540ad7sm967116ejf.17.2023.06.09.00.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 00:37:15 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:37:12 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, 
	Shannon Nelson <shannon.nelson@amd.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <of6exzv2q6eculovjesz3mf4jxjxqfy27gz3jmihsnu6ummdux@k2zdfafgawla>
References: <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
 <20230608102259-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230608102259-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 10:23:21AM -0400, Michael S. Tsirkin wrote:
>On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
>> On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
>> > >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> > >>
>> > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
>> > >>
>> > >> [...]
>> > >>
>> > >> >> > > > > I have a question though, what if down the road there
>> > >> >> > > > > is a new feature that needs more changes? It will be
>> > >> >> > > > > broken too just like PACKED no?
>> > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
>> > >> >> > > > > to support?
>> > >> >> > > >
>> > >> >> > > > It looks like we had it, but we took it out (by the way, we were
>> > >> >> > > > enabling packed even though we didn't support it):
>> > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
>> > >> >> > > >
>> > >> >> > > > The only problem I see is that for each new feature we have to modify
>> > >> >> > > > the kernel.
>> > >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
>> > >> >> > > >
>> > >> >> > > > Thanks,
>> > >> >> > > > Stefano
>> > >> >> > >
>> > >> >> > > Jason what do you say to reverting this?
>> > >> >> >
>> > >> >> > I may miss something but I don't see any problem with vDPA core.
>> > >> >> >
>> > >> >> > It's the duty of the parents to advertise the features it has. For example,
>> > >> >> >
>> > >> >> > 1) If some kernel version that is packed is not supported via
>> > >> >> > set_vq_state, parents should not advertise PACKED features in this
>> > >> >> > case.
>> > >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
>> > >> >> > cvq doesn't support, parents should not advertise PACKED as well
>> > >> >> >
>> > >> >> > If a parent violates the above 2, it looks like a bug of the parents.
>> > >> >> >
>> > >> >> > Thanks
>> > >> >>
>> > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
>> > >> >
>> > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
>> > >>
>> > >> Sorry, I'm getting lost...
>> > >> We were talking about the fact that vhost-vdpa doesn't handle
>> > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
>> > >> that series [1], no?
>> > >>
>> > >> The parents seem okay, but maybe I missed a few things.
>> > >>
>> > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> > >
>> > >Yes, more below.
>> > >
>> > >>
>> > >> >
>> > >> >> Should that not have a whitelist of features
>> > >> >> since it interprets ioctls differently depending on this?
>> > >> >
>> > >> >If there's a bug, it might only matter the following setup:
>> > >> >
>> > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
>> > >> >
>> > >> >This seems to be broken since VDUSE was introduced. If we really want
>> > >> >to backport something, it could be a fix to filter out PACKED in
>> > >> >VDUSE?
>> > >>
>> > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
>> > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
>> > >> (I haven't tried), so why should we filter PACKED in VDUSE?
>> > >
>> > >I don't think we need any filtering since:
>> > >
>> > >PACKED features has been advertised to userspace via uAPI since
>> > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
>> > >would be very hard to restrict it again. For the userspace that tries
>> > >to negotiate PACKED:
>> > >
>> > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
>> > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
>> > >
>> > >If we backport the fixes to -stable, we may break the application at
>> > >least in the case 1).
>> >
>> > Okay, I see now, thanks for the details!
>> >
>> > Maybe instead of "break silently", we can return an explicit error for
>> > SET_VRING_BASE/GET_VRING_BASE in stable branches.
>> > But if there are not many cases, we can leave it like that.
>>
>> A second thought, if we need to do something for stable. is it better
>> if we just backport Shannon's series to stable?
>>
>> >
>> > I was just concerned about how does the user space understand that it
>> > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
>> > kernel or not.
>>
>> My understanding is that if packed is advertised, the application
>> should assume SET/GET_VRING_BASE work.
>>
>> Thanks
>
>
>Let me ask you this. This is a bugfix yes? What is the appropriate Fixes
>tag?

I would say:

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")

because we had an allow list and enabled PACKED explicitly.

I'm not sure if the parents at that time supported PACKED, but
maybe it doesn't matter since we are talking about the code in
vhost-vdpa.

Thanks,
Stefano


