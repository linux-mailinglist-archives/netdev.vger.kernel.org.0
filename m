Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16755B2110
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiIHOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiIHOpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2E354C9C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662648302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1NWLsPufrv1Z1Z1oT9L72C7JiwJYlyGG1fa5hFdEoc=;
        b=PVx855HONZv7tAvBuviq6riQYwqnHmRjGiJDETDYIX0xP0eBpDXXmZYF2Kf3Ckc/o67HKq
        OM70uMNHcXlTl1DNWJPYCWTj27Osbb3wcdc22qWsxJ+inHnYXD9EuOX43ZelrNslP+PviH
        oY+phoEfKD0wzMI3LJeFm8niZj5G0gc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-BO55xZeOMQu83i6OPghQjw-1; Thu, 08 Sep 2022 10:45:01 -0400
X-MC-Unique: BO55xZeOMQu83i6OPghQjw-1
Received: by mail-wr1-f72.google.com with SMTP id m2-20020adfc582000000b0021e28acded7so4754893wrg.13
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=D1NWLsPufrv1Z1Z1oT9L72C7JiwJYlyGG1fa5hFdEoc=;
        b=iYujmrSTjV7WOzaWvHHoXETaB+dIoWabbRISqInFkocMj8+acXon+0u8SUaEwAzjcD
         PavAH0a/GXg3AseMhaWleT71yiy9XDXuxd89EAqvKXEpMmPHBTwW7a8+qBQ7e8GmkbFs
         khAfx/rCXz81F0iI87S7BC3RXTHerE8xQMoo11yf5EswXaBEh5iqMszgrTy5qAnEZ0X/
         SWi9x/cmsj49Td4fJB6Gv7dASghf6mqFwdsxKEtVghXkJb4sQdRDPUNTKimpK+FVa56m
         Zu6O6KJDlFCmVQhoDCCZCLh5sFkOBrxhkelVdRZp/s8nZ0374MPpDa3deXWPGyMBsSJp
         6rvQ==
X-Gm-Message-State: ACgBeo3b4O/JROac7u4WD7Oj6mMw9wLghy4mLtwGxQMqqKdk7staG2rE
        M/pOs3pFRMeCnZwgSqGCGEctqS5u4y8EJ9jCquTktmDXBiEybCFD1vg4D/WaUmUrDxzRsgts7Pg
        dSKlPqhoshH1l/+sX
X-Received: by 2002:a05:600c:1c23:b0:3a5:d936:e5bb with SMTP id j35-20020a05600c1c2300b003a5d936e5bbmr2387512wms.59.1662648300349;
        Thu, 08 Sep 2022 07:45:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7fJgOmrcKJ8ShbrwnUHuBpfa0K9y45SnAFXKT+MRGLC/LnSpWU83I3ibPwXZDWaCCVfMnJPw==
X-Received: by 2002:a05:600c:1c23:b0:3a5:d936:e5bb with SMTP id j35-20020a05600c1c2300b003a5d936e5bbmr2387497wms.59.1662648300076;
        Thu, 08 Sep 2022 07:45:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id z11-20020a056000110b00b00228dcf471e8sm9480472wrw.56.2022.09.08.07.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:44:59 -0700 (PDT)
Message-ID: <52fcd27efafb415baa0bc52440296306110c56d7.camel@redhat.com>
Subject: Re: [PATCH net v3] net: mptcp: fix unreleased socket in accept queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        menglong8.dong@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, fw@strlen.de,
        peter.krystad@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>
Date:   Thu, 08 Sep 2022 16:44:58 +0200
In-Reply-To: <e4b7eddc-3a73-0994-467e-6d65d6ad80c0@tessares.net>
References: <20220907111132.31722-1-imagedong@tencent.com>
         <e4b7eddc-3a73-0994-467e-6d65d6ad80c0@tessares.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-08 at 15:56 +0200, Matthieu Baerts wrote:
> Hi Menglong,
> 
> On 07/09/2022 13:11, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> > 
> > The mptcp socket and its subflow sockets in accept queue can't be
> > released after the process exit.
> > 
> > While the release of a mptcp socket in listening state, the
> > corresponding tcp socket will be released too. Meanwhile, the tcp
> > socket in the unaccept queue will be released too. However, only init
> > subflow is in the unaccept queue, and the joined subflow is not in the
> > unaccept queue, which makes the joined subflow won't be released, and
> > therefore the corresponding unaccepted mptcp socket will not be released
> > to.
> 
> Thank you for the v3.
> 
> Unfortunately, our CI found a possible recursive locking:
> 
> > - KVM Validation: debug:
> >   - Unstable: 1 failed test(s): selftest_mptcp_join - Critical: 1 Call Trace(s) ❌:
> >   - Task: https://cirrus-ci.com/task/5418283233968128
> >   - Summary: https://api.cirrus-ci.com/v1/artifact/task/5418283233968128/summary/summary.txt
> 
> https://lore.kernel.org/mptcp/4e6d3d9e-1f1a-23ae-cb56-2d4f043f17ae@gmail.com/T/#u
> 
> Do you mind looking at it please?

Ah, that is actually a false positive, but we must silence it. The main
point is that the lock_sock() in mptcp_close() rightfully lacks the
_nested annotation.

Instead of adding such annotation only for this call site, which would
be both ugly and dangerous, I suggest to factor_out from mptcp_close()
all the code the run under the socket lock, say in:
 
bool __mptcp_close(struct sock *sk, long timeout)
	// return true if the caller need to cancel the mptcp worker
	// (outside the socket lock)

and then in mptcp_subflow_queue_clean():

	sock_hold(sk);

	slow = lock_sock_fast_nested(sk);
        next = msk->dl_next;
        msk->first = NULL;
        msk->dl_next = NULL;
	do_cancel_work = __mptcp_close(sk, 0);
	unlock_sock_fast(sk, slow);

	if (do_cancel_work)
		mptcp_cancel_work(sk);
	sock_put(sk);

All the above could require 2 different patches, 1 to factor-out the
helper, and 1 to actually implement the fix.

Cheers,

Paolo

