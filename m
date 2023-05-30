Return-Path: <netdev+bounces-6486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A227168F4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06E3A1C20CDC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE0B27716;
	Tue, 30 May 2023 16:13:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6491B27217
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:13:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41EA135
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685463124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=elhjqE3fNBnQQxlIlFk7OLjzO9acLMNW6reIgAraQ64=;
	b=Ceh2WZ0FofG0wtkOo7eq6ZGCaIym/J6Eq5XmN+9skgjbeX2Jn4wtpbQcCzHK2xIUNbNCMk
	qX2ZqR6S4N1ZNdgyoTi0Z+mDayi2gtVETvzi5iKH392vK0vxKyfwAy+tKrrvi8FgzaR4Kq
	/2eV5iYJ0AyYpQZZtTP4papmqocPshM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-7Z0U84jqOFmgyyw7i9U1zg-1; Tue, 30 May 2023 12:12:03 -0400
X-MC-Unique: 7Z0U84jqOFmgyyw7i9U1zg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30a8f6d7bbdso1578837f8f.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685463122; x=1688055122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elhjqE3fNBnQQxlIlFk7OLjzO9acLMNW6reIgAraQ64=;
        b=k4DbE5Vfezlaa0OR+4YJLarbOPyjVZSeRIVdZk/ESdmxKNR7ucYYfGL8d4JWytiRzr
         QTwGDvmwHTFUzyQdku2AReZpSsd7YqKf/srS1DWu6S8fw2ESBnMn9z/ISxTk+U4qew2A
         iIp2wI+ZIYW0hh7Tbyr+gb13OulAFC1yp3+4iVORRIxNBh9Gi/6j/0iz1NzTyMjY40q5
         BKv0vZfL1XkiqGgSZw4jh/GfS/e53h5ui2k8pBmlW7piy5E+BpsE1PK+AiLcKh/QYEFL
         7yY4Rk9bYMvBSFQONsMoqD2Zw//68fsq7YR09UHIbdsZ9aFey3sHIKW9rYRaa5hdkgnu
         EKGQ==
X-Gm-Message-State: AC+VfDxZgFuJWORkAD1hT9XC3cXKVZPTvgh5TaZMwa6Svaz79ym7LJYR
	3bwK3agRAZRHSm2GVZVHxk7B7UVP2s8JLHNjcKS5cSyqlEIzwq8TcsR94uObRUg1ed7GZ1PeAMe
	CYhq+3tdMZ5PvCCoO
X-Received: by 2002:a5d:5909:0:b0:309:4e64:7a28 with SMTP id v9-20020a5d5909000000b003094e647a28mr2029563wrd.49.1685463122245;
        Tue, 30 May 2023 09:12:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ76yj+cHMYLKtEr2159YgsXI3xWTpZbjGYKy+isWK8mqhybl41e+higOqGxCzQ6/lC2tHLEZQ==
X-Received: by 2002:a5d:5909:0:b0:309:4e64:7a28 with SMTP id v9-20020a5d5909000000b003094e647a28mr2029549wrd.49.1685463121984;
        Tue, 30 May 2023 09:12:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id l9-20020adfe589000000b00307c8d6b4a0sm3781887wrm.26.2023.05.30.09.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 09:12:01 -0700 (PDT)
Date: Tue, 30 May 2023 18:11:58 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <4opfq7hcowqwmz2hzpfcu3icx3z6ce4vmn6pkaeeqxnclgvjd6@x7lyji2owgae>
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <85836a9b-b30a-bdb6-d058-1f7c17d8e48e@oracle.com>
 <c87f0768-027b-c192-1baf-05273aac382b@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c87f0768-027b-c192-1baf-05273aac382b@oracle.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:01:11AM -0500, Mike Christie wrote:
>On 5/30/23 10:58 AM, Mike Christie wrote:
>> On 5/30/23 8:44 AM, Stefano Garzarella wrote:
>>>
>>> From a first glance, it looks like an issue when we call vhost_work_queue().
>>> @Mike, does that ring any bells since you recently looked at that code?
>>
>> I see the bug. needed to have set the dev->worker after setting worker->vtsk

Yes, I came to the same conclusion (see my email sent at the same time
:-).

>> like below:
>>
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index a92af08e7864..7bd95984a501 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -564,7 +564,6 @@ static int vhost_worker_create(struct vhost_dev *dev)
>>  	if (!worker)
>>  		return -ENOMEM;
>>
>> -	dev->worker = worker;
>>  	worker->kcov_handle = kcov_common_handle();
>>  	init_llist_head(&worker->work_list);
>>  	snprintf(name, sizeof(name), "vhost-%d", current->pid);
>> @@ -576,6 +575,7 @@ static int vhost_worker_create(struct vhost_dev *dev)
>>  	}
>>
>>  	worker->vtsk = vtsk;
>
>Shoot, oh wait, I think I needed a smp_wmb to always make sure worker->vtask
>is set before dev->worker or vhost_work_queue could still end up seeing
>dev->worker set before worker->vtsk right?

But should we pair smp_wmb() with an smp_rmb() wherever we check 
dev->worker?

Thanks,
Stefano


