Return-Path: <netdev+bounces-93-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A04A6F51DA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:39:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 703A8280FBB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522684A0E;
	Wed,  3 May 2023 07:39:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D6EA3
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:39:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF931731
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683099537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pAxcZhu4o2HVjJymB9Go0qnCuRBV6q3xEK19fZLvIig=;
	b=T2VgQdYoYNmdh1F0ck2OEOIvIY70qm9x1Xell678xpxKXgFfJZ/gTtz5/ykPOKCiFyfVQi
	TGRmxNxeCJvYtfT+ZnMz/pSzLgQNcMtQ/5/mDuXkBrSNhnbQRs15Bk0hhovD6i3/kKq77k
	tNgU/f7YWkoXSd18SIzHUPFQABVccuk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-Edr72m1xPFerG0CLEsbGtA-1; Wed, 03 May 2023 03:38:56 -0400
X-MC-Unique: Edr72m1xPFerG0CLEsbGtA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f336ecf58cso12683725e9.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 00:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683099535; x=1685691535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAxcZhu4o2HVjJymB9Go0qnCuRBV6q3xEK19fZLvIig=;
        b=MsI7pwqOPUPeQ4tBJRY69zYa5nblZIpf4ck8IlG321BK2fJIPu7VpgIgCAI8WDwoVn
         417Lp5MBWuFdGyO/daFNhYij76D5Mb2IqGmwJnvR8tYz4snNSbtSeFP+KSFeeJwxzg9E
         oGcrqSaGBGagwO/7ttTRDKNwcZvKGBamPRzCsHrkPwzGMJayxI0hfe/0Jhi8zLmMHpq/
         M9eyh+BPKHkWJOYNVtMGdZLTRmAzNdba7kG1HnTxner30/Yz2M5d8psJQN4LZjyjgNby
         1vEp7SnsG2WL3YL9Y63E6O0VWnHdLRltbzbrUYNmPjOpo+SY64KtOmpG3anc8/M++3wm
         etMg==
X-Gm-Message-State: AC+VfDzZ6znQx1LobkuNUPDgY1Vog7K92ioul94hr7Fumq7yOelJW6Ed
	0/Rv0xtLcRbjmmekCL5EQU/9lcIy15OmpFC/eYuMCd9aHL75Po4/aZEpSrRmTFgdNmAadHDQdBM
	0tYyxNhWkO2+2BI2v
X-Received: by 2002:a5d:6446:0:b0:306:401d:8ce1 with SMTP id d6-20020a5d6446000000b00306401d8ce1mr1039278wrw.11.1683099535215;
        Wed, 03 May 2023 00:38:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4jS0rZK7zlXJSzh5byjzY89SiMYSDdqr7AlXInY7R+ycQXbuLMQVtQxwRIla52w9LsJ/EcZA==
X-Received: by 2002:a5d:6446:0:b0:306:401d:8ce1 with SMTP id d6-20020a5d6446000000b00306401d8ce1mr1039260wrw.11.1683099534906;
        Wed, 03 May 2023 00:38:54 -0700 (PDT)
Received: from sgarzare-redhat ([185.29.96.107])
        by smtp.gmail.com with ESMTPSA id r16-20020a5d4e50000000b002c7066a6f77sm32959330wrt.31.2023.05.03.00.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 00:38:53 -0700 (PDT)
Date: Wed, 3 May 2023 09:38:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Cong Wang <cong.wang@bytedance.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <occeblxotmpsq4gqjjued62ar5ngqxehmmrj7jg3ynzsz2vfcy@4jzl7slmqkft>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
 <ZDt+PDtKlxrwUPnc@bullseye>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZDt+PDtKlxrwUPnc@bullseye>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Apr 16, 2023 at 04:49:00AM +0000, Bobby Eshleman wrote:
>On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
>> On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
>> > From: Cong Wang <cong.wang@bytedance.com>
>> >
>> > When virtqueue_add_sgs() fails, the skb is put back to send queue,
>> > we should not deliver the copy to tap device in this case. So we
>> > need to move virtio_transport_deliver_tap_pkt() down after all
>> > possible failures.
>> >
>> > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
>> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> > Cc: Stefano Garzarella <sgarzare@redhat.com>
>> > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> > ---
>> >  net/vmw_vsock/virtio_transport.c | 5 ++---
>> >  1 file changed, 2 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index e95df847176b..055678628c07 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>> >  		if (!skb)
>> >  			break;
>> >
>> > -		virtio_transport_deliver_tap_pkt(skb);
>> > -		reply = virtio_vsock_skb_reply(skb);
>> > -
>> >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>> >  		sgs[out_sg++] = &hdr;
>> >  		if (skb->len > 0) {
>> > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>> >  			break;
>> >  		}
>> >
>> > +		virtio_transport_deliver_tap_pkt(skb);

I would move only the virtio_transport_deliver_tap_pkt(), 
virtio_vsock_skb_reply() is not related.

>> > +		reply = virtio_vsock_skb_reply(skb);
>>
>> I don't remember the reason for the ordering, but I'm pretty sure it was
>> deliberate. Probably because the payload buffers could be freed as soon
>> as virtqueue_add_sgs() is called.
>>
>> If that's no longer true with Bobby's skbuff code, then maybe it's safe
>> to monitor packets after they have been sent.
>>
>> Stefan
>
>Hey Stefan,
>
>Unfortunately, skbuff doesn't change that behavior.
>
>If I understand correctly, the problem flow you are describing
>would be something like this:
>
>Thread 0 			Thread 1
>guest:virtqueue_add_sgs()[@send_pkt_work]
>
>				host:vhost_vq_get_desc()[@handle_tx_kick]
>				host:vhost_add_used()
>				host:vhost_signal()
>				guest:virtqueue_get_buf()[@tx_work]
>				guest:consume_skb()
>
>guest:deliver_tap_pkt()[@send_pkt_work]
>^ use-after-free
>
>Which I guess is possible because the receiver can consume the new
>scatterlist during the processing kicked off for a previous batch?
>(doesn't have to wait for the subsequent kick)

This is true, but both `send_pkt_work` and `tx_work` hold `tx_lock`, so 
can they really go in parallel?

Thanks,
Stefano


