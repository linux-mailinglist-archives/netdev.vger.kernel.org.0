Return-Path: <netdev+bounces-1694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C33D86FED6E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3192F28160E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A771B90A;
	Thu, 11 May 2023 08:05:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723421B8E0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:05:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F6B2703
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683792325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDguPfFBQ1A5HBLbGPkFIstEpZuKohqgknZXXQa2m5U=;
	b=dgMY0l/yq1e4nB+fAzaM9QmdyJrL/RcsTlaWevIsxtmjYw7ctdk4bdPqO08/K3DAedWpFf
	xykUOjQEdOAeF4RvNQqV1/ob7lUjgLnlA5IrQ+N/iHgWAaUY/2vjjU6mA2NVDKmyQ3MIZI
	79C/VQAaWz/Gnd9MYhor+tJzdbnY6XQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-B2qLghNiO4-fvwvxeGAdqw-1; Thu, 11 May 2023 04:05:21 -0400
X-MC-Unique: B2qLghNiO4-fvwvxeGAdqw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f422150893so32450845e9.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683792320; x=1686384320;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDguPfFBQ1A5HBLbGPkFIstEpZuKohqgknZXXQa2m5U=;
        b=Og5p5UzA0SBWmrPgQ63ygrglohlxy3N/wvCzsQ5BXeAcOC8mrKtVUFw6PTZebU5FAw
         5pCaHPuxVeBFCULTJICqC6fgk3NLnCf+PTLOrac+EmTDJNFvhPyDqn1cBCDCjFRPrPWt
         Uae8NiuS08l9Za2eXHBi2J88nPtBgbpiJqR3K1IeVaCNwI7VbGlHkAVp21vp9FXvJya6
         7nsfWbt/SqgEK1UW0GW6eUcuV3eZyICrPvc+YsNxvFWvCKTwk2B3amE32zQAgrgez9cs
         +eZyVwLUFboBdNBOV2heniUHP+9trATpBsCXWuDXNlM4B4Ld0YlSRrqUraVBKxToO2OY
         9+3Q==
X-Gm-Message-State: AC+VfDyoEJ/UDrMdY39/hbp+YpIkL2UKed+IkTbQSq+GxjEE7dOp7br0
	INz1Kl033JXtRE56tTTWkl9g99PFq3WRRc1C36k94YlyiqUP49+SWUS3f1uhyldXFtHQIjaEA5+
	JAo5rhyUxtN/X/MRs
X-Received: by 2002:adf:dbd0:0:b0:306:39e3:8409 with SMTP id e16-20020adfdbd0000000b0030639e38409mr14427166wrj.49.1683792320330;
        Thu, 11 May 2023 01:05:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7l+BpAdb0iCMyJ1RUUM102Pj/7Li/+Avs0LqpRU6YbPaKu+/sEc+cIjTbpYXL8YuEmB9Vy/Q==
X-Received: by 2002:adf:dbd0:0:b0:306:39e3:8409 with SMTP id e16-20020adfdbd0000000b0030639e38409mr14427142wrj.49.1683792320001;
        Thu, 11 May 2023 01:05:20 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.69.175])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d65cd000000b0030789698eebsm15980169wrw.89.2023.05.11.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 01:05:19 -0700 (PDT)
Date: Thu, 11 May 2023 10:05:16 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Zhuang Shengen <zhuangshengen@huawei.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, arei.gonglei@huawei.com, 
	longpeng2@huawei.com, jianjay.zhou@huawei.com
Subject: Re: [PATCH] vsock: bugfix port residue in server
Message-ID: <oavxfpkinrpj7n24myvgmyq34aymvjm5lx3lqwhwxw6nbumam3@vwg76jsvjdaj>
References: <20230510142502.2293109-1-zhuangshengen@huawei.com>
 <ftuh7vhoxdxbymg6u3wlkfhlfoufupeqampqxc2ktqrpxndow3@dkpufdnuwlln>
 <f7ab6d78-1815-bd3e-c365-1bf054138366@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7ab6d78-1815-bd3e-c365-1bf054138366@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:03:24PM +0800, Zhuang Shengen wrote:
>Hi Stefano:
>
>在 2023/5/10 23:23, Stefano Garzarella 写道:
>>Hi,
>>thanks for the patch, the change LGTM, but I have the following
>>suggestions:
>>
>>Please avoid "bugfix" in the subject, "fix" should be enough:
>>https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#describe-your-changes
>>
>>
>>Anyway, I suggest to change the subject in
>>"vsock: avoid to close connected socket after the timeout"
>>
>thanks for your suggestion, I will change the subject
>>On Wed, May 10, 2023 at 10:25:02PM +0800, Zhuang Shengen wrote:
>>>When client and server establish a connection through vsock,
>>>the client send a request to the server to initiate the connection,
>>>then start a timer to wait for the server's response. When the server's
>>>RESPONSE message arrives, the timer also times out and exits. The
>>>server's RESPONSE message is processed first, and the connection is
>>>established. However, the client's timer also times out, the original
>>>processing logic of the client is to directly set the state of 
>>>this vsock
>>>to CLOSE and return ETIMEDOUT, User will release the port. It will not
>>
>>What to you mean with "User" here?
>>
>The User means Client, I will delete the statement "User will release 
>the por", it indeed difficult to understand
>>>notify the server when the port is released, causing the server 
>>>port remain
>>>
>>
>>Can we remove this blank line?
>>
>OK
>>>when client's vsock_conqnect timeout，it should check sk state is
>>
>>The remote peer can't trust the other peer, indeed it will receive an
>>error after sending the first message and it will remove the connection,
>>right?
>>
>If this situation happend, the server will response a RST? Anyway the 
>connection will not established before timeout, The sk state wont be 
>ESTABLISHED.
>>>ESTABLISHED or not. if sk state is ESTABLISHED, it means the connection
>>>is established, the client should not set the sk state to CLOSE
>>>
>>>Note: I encountered this issue on kernel-4.18, which can be fixed by
>>>this patch. Then I checked the latest code in the community
>>>and found similar issue.
>>>
>>
>>In order to backport it to the stable kernels, we should add a Fixes tag:
>>https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#describe-your-changes
>>
>>
>OK, I add a Fixes: d021c344051a ("VSOCK: Introduce VM Sockets") in the 
>new patch.
>
>I put the new patch with v2 title in the attachment, please check.

LGTM (great to have added the net tag!), but please post as plain text 
like v1.

Thanks,
Stefano


