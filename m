Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9036805B5
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 06:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbjA3Fol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 00:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbjA3Foe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 00:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61F310A99
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 21:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675057424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Kuu0GNI+KbyBCEudDzyW7Q6jFDRoiyBH652zdvdW9k=;
        b=AACep6HtuwyOhV+MYF/Et1neDz0lLvolIfzNb08M38PAEtZUJqfulchTUaDzch9eRw8hr6
        j6hWSw9vxZTyFAXZXNIxyHKzZ4S5ob4Yjs0IKf+QPi2Kg0E+CwShJ9pW3mBaxxW3v9bVUr
        M+JlmV1q6Q6YgmFaGa11kFPuiS1/yEM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-125-rrIz-myPM_q5MdjhBHrgpg-1; Mon, 30 Jan 2023 00:43:43 -0500
X-MC-Unique: rrIz-myPM_q5MdjhBHrgpg-1
Received: by mail-ua1-f69.google.com with SMTP id l24-20020ab06cf8000000b006549d0967caso4214526uai.18
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 21:43:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Kuu0GNI+KbyBCEudDzyW7Q6jFDRoiyBH652zdvdW9k=;
        b=4X3znBxrWYPCSCfScJ5ctIY2Sm6MnmXWrxLRHJaUFPmUKa8nNzlGsH7oibuxLndyE4
         QPpYKXZH7UKn6ytSoMNldDADOxD695A8wp9GmDoIAChdjDNe3AsVnooGwec4xpiDfH+c
         sO7Nej2P/dIlpIFa+h7ksoUqWYuMOFWariPEFTaOFPXFXtWqu0kN6yEDO6RyxqHEFvhy
         w1vjr8UVR9KXOR8RrOeD75uoOZAWfE0d9QZLnIofd9zEMRxebdkTPkR2vt7adYPMldFM
         dXKV0VkyRv5dIPT1hgQiWYr4fvonr6xs0eXVCFuDEoRMCpUZNlf+ZAcDcqTFiEo1fPgw
         Oz5g==
X-Gm-Message-State: AFqh2krOW0yMiovQoujQ0zU1mraXriau6fj4bbaw8wIlm+fI6xtYYpjw
        zEbLgKpNutUrQYcxmMSlCUaHYv+JIvtBpj6mtgEReiigw0zGltG8VpxNP2GeR89cvvXok7dROa+
        i2SJ3/ZBllzzTmmf+
X-Received: by 2002:a05:6102:50a4:b0:3d0:dc9c:e82e with SMTP id bl36-20020a05610250a400b003d0dc9ce82emr30642655vsb.7.1675057420565;
        Sun, 29 Jan 2023 21:43:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXujATUMfJc8yKVf9FXdTDbjwCk2aZr0JxpMeuUR+yFC7eaGn7bjMMHIAavl0DoVTfrNkLiTBw==
X-Received: by 2002:a05:6102:50a4:b0:3d0:dc9c:e82e with SMTP id bl36-20020a05610250a400b003d0dc9ce82emr30642643vsb.7.1675057420187;
        Sun, 29 Jan 2023 21:43:40 -0800 (PST)
Received: from redhat.com ([87.249.138.139])
        by smtp.gmail.com with ESMTPSA id q9-20020a9f3409000000b004c6b53e0fadsm973239uab.25.2023.01.29.21.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 21:43:39 -0800 (PST)
Date:   Mon, 30 Jan 2023 00:43:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20230130003334-mutt-send-email-mst@kernel.org>
References: <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org>
 <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org>
 <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org>
 <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
 <20230129022809-mutt-send-email-mst@kernel.org>
 <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 10:53:54AM +0800, Jason Wang wrote:
> On Sun, Jan 29, 2023 at 3:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> > > On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > 在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> > > > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > > > > > >> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > > > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > > > > > > >>>>> But device is still going and will later use the buffers.
> > > > > > > > > > >>>>>
> > > > > > > > > > >>>>> Same for timeout really.
> > > > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > > > > > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > > > > > > >>>>
> > > > > > > > > > >>>> Thanks
> > > > > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> > > > > > > > > > >>> that sounds more reasonable. E.g. someone is turning on promisc,
> > > > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > > > >>
> > > > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > > > >>
> > > > > > > > > > >>
> > > > > > > > > > >>> things we should be careful to address then:
> > > > > > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> > > > > > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > > > > > >>>      We need to integrate with kernel/watchdog.c for good results
> > > > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > > > >>
> > > > > > > > > > >> That's fine, will consider this.
> > > > > > > > >
> > > > > > > > > So after some investigation, it seems the watchdog.c doesn't help. The
> > > > > > > > > only export helper is touch_softlockup_watchdog() which tries to avoid
> > > > > > > > > triggering the lockups warning for the known slow path.
> > > > > > > >
> > > > > > > > I never said you can just use existing exporting APIs. You'll have to
> > > > > > > > write new ones :)
> > > > > > >
> > > > > > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > > > > > >
> > > > > > > Btw, I wonder what kind of logic you want here. If we switch to using
> > > > > > > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > > > > > > warning seems sufficient?
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > I'd like to avoid need to teach users new APIs. So watchdog setup to apply
> > > > > > to this driver. The warning can be different.
> > > > >
> > > > > Right, so it looks to me the only possible setup is the
> > > > > watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> > > > > second (as softlockup did).
> > > > >
> > > > > And I think it would still make sense to fail, we can start with a
> > > > > very long timeout like 1 minutes and break the device. Does this make
> > > > > sense?
> > > > >
> > > > > Thanks
> > > >
> > > > I'd say we need to make this manageable then.
> > >
> > > Did you mean something like sysfs or module parameters?
> >
> > No I'd say pass it with an ioctl.
> >
> > > > Can't we do it normally
> > > > e.g. react to an interrupt to return to userspace?
> > >
> > > I didn't get the meaning of this. Sorry.
> > >
> > > Thanks
> >
> > Standard way to handle things that can timeout and where userspace
> > did not supply the time is to block until an interrupt
> > then return EINTR.
> 
> Well this seems to be a huge change, ioctl(2) doesn't say it can
> return EINTR now.

the one on fedora 37 does not but it says:
       No single standard.  Arguments, returns, and semantics of ioctl() vary according to the device driver in question (the call  is
       used as a catch-all for operations that don't cleanly fit the UNIX stream I/O model).

so it depends on the device e.g. for a streams device it does:
https://pubs.opengroup.org/onlinepubs/9699919799/functions/ioctl.html
has EINTR.



> Actually, a driver timeout is used by other drivers when using
> controlq/adminq (e.g i40e). Starting from a sane value (e.g 1 minutes
> to avoid false negatives) seems to be a good first step.

Well because it's specific hardware so timeout matches what it can
promise.  virtio spec does not give guarantees.  One issue is with
software implementations. At the moment I can set a breakpoint in qemu
or vhost user backend and nothing bad happens in just continues.


> > Userspace controls the timeout by
> > using e.g. alarm(2).
> 
> Not used in iproute2 after a git grep.
> 
> Thanks

No need for iproute2 to do it user can just do it from shell. Or user can just press CTRL-C.

> >
> >
> > > >
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > > And before the patch, we end up with a real infinite loop which could
> > > > > > > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > Only with a bad device.
> > > > > > > >
> > > > > > > > > > >>
> > > > > > > > > > >>
> > > > > > > > > > >>> 2- overhead. In a very common scenario when device is in hypervisor,
> > > > > > > > > > >>>      programming timers etc has a very high overhead, at bootup
> > > > > > > > > > >>>      lots of CVQ commands are run and slowing boot down is not nice.
> > > > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > > > >>
> > > > > > > > > > >> Then we go back to the question of choosing a good timeout for poll. And
> > > > > > > > > > >> poll seems problematic in the case of UP, scheduler might not have the
> > > > > > > > > > >> chance to run.
> > > > > > > > > > > Poll just a bit :) Seriously I don't know, but at least check once
> > > > > > > > > > > after kick.
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I think it is what the current code did where the condition will be
> > > > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >>> 3- suprise removal. need to wake up thread in some way. what about
> > > > > > > > > > >>>      other cases of device breakage - is there a chance this
> > > > > > > > > > >>>      introduces new bugs around that? at least enumerate them please.
> > > > > > > > > > >>
> > > > > > > > > > >> The current code did:
> > > > > > > > > > >>
> > > > > > > > > > >> 1) check for vq->broken
> > > > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > > > >>
> > > > > > > > > > >> So we won't end up with a never woke up process which should be fine.
> > > > > > > > > > >>
> > > > > > > > > > >> Thanks
> > > > > > > > > > >
> > > > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > > > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > > > >
> > > > > > > > > > But consider we will start from a wait first, I will limit the changes
> > > > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >>>
> > > > > > > >
> > > > > >
> > > >
> >

