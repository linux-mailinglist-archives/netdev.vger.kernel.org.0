Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29E15118B
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 22:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgBCVD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 16:03:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54632 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgBCVDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 16:03:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so840686wmh.4
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 13:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arangodb.com; s=google;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=Lohc8bcF1VJzdXusx5DWNSbAxMSgzzErWmmKfvOTSL8=;
        b=YBTrFXxCb5/P4Kv7Pu3P8GGqAezrwJh3Zp91ouWoN/qpJ98Z+Xv4yhMi0ORGboLv+F
         O+3aBfa7pbzOImWpxMkc/mQOvM/UygW8zrEdvtJD62AHFzKlX7WqO5kaUT5mgGQy1VJT
         ccJehhdDQaC5NwXFfyIecuHPchL7rirbVzqUmOll4VSIr8Sdbsw2EC5P6vvstHdk4Md9
         0C6e+lUz2A4vVBvQBkGan3V3FtTTVJuGLU7mFGjJad7u97J13btH9vJFxFIECexGdmAF
         WRY7x7XJx9r0cgPY1mYkJ3mPeHcAn5jrYAJEvgeZO47q//7nxcXnfO2sE+0J93WFfb0Q
         OXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=Lohc8bcF1VJzdXusx5DWNSbAxMSgzzErWmmKfvOTSL8=;
        b=pcytL4TPzAjeeEfMLgYTJYDRxXfNFdOyBbxJeWopK7hlTvZuJFd5kElmGOUxaaQ8q6
         sw0gyfAsZcMnXgkcZr+cTjjd7GfWTGcRi6jrSDXS7lYXSwsd9ywNEFIe8zbR8+ziGOt/
         7bYEvf0O2vt7zw6QNvMH+5Um86xH6LdJ/kUwJYzMoud1VSUBv18KIifgyDxqMgz+Ko9k
         3jCfEyD6XLpILvbqkzW7zywjzCY3kaDsDdFQzUAp8kJ89fapx0XaqmvgHMvjtAV2NLI9
         0FQ1H6Rtvmn6vVofdcIFwRXOv1p1otBpkQos34rx7i5Fig0fhsFsVQUqSF+1YjP3FkF8
         xb/g==
X-Gm-Message-State: APjAAAUg9mAM8gTiZ4KLS11EVdMUndnMcY2wiibTRANtntEeMCtDgS5j
        sKH4zQZW8Hfh20H2JBgkhwGR
X-Google-Smtp-Source: APXvYqxTyWbua47e+OLNT7IiNnwlsk3WBeiNdZEPmVGvgMBkWClxMhNtygcawelaeRl/cFZYVSSGwg==
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr931414wma.171.1580763831747;
        Mon, 03 Feb 2020 13:03:51 -0800 (PST)
Received: from Android.fritz.box (2a0a-a540-7e71-0-ad6a-26ba-a08d-e560.ipv6dyn.netcologne.de. [2a0a:a540:7e71:0:ad6a:26ba:a08d:e560])
        by smtp.gmail.com with ESMTPSA id s8sm25610798wrt.57.2020.02.03.13.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Feb 2020 13:03:51 -0800 (PST)
Date:   Mon, 03 Feb 2020 22:03:47 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <5a16db1f2983ab105b99121ce0737d11@suse.de>
References: <20200131135730.ezwtgxddjpuczpwy@tux> <20200201121647.62914697@cakuba.hsd1.ca.comcast.net> <20200203151536.caf6n4b2ymvtssmh@tux> <5a16db1f2983ab105b99121ce0737d11@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: epoll_wait misses edge-triggered eventfd events: bug in Linux 5.3 and 5.4
To:     Roman Penyaev <rpenyaev@suse.de>
CC:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>,
        lars@arangodb.com
From:   =?ISO-8859-1?Q?Max_Neunh=F6ffer?= <max@arangodb.com>
Message-ID: <F0CB2FAC-A6F7-4B72-BC27-413DCF35E256@arangodb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roman,

Thanks for your quick response=2E This sounds fantastic!

The epollbug=2Ec program was originally written by my colleague Lars Maier=
 and then modified by me and subsequently by Chris Kohlhoff=2E Note that th=
e bugzilla bug report contains altogether three variants which test epoll_w=
ait/epoll_ctl in three different ways=2E It might be sensible to take all t=
hree variants for the test suite=2E
I cannot imagine that any of the three authors would object to this, I def=
initely do not, the other two are on Cc in this email and can speak for the=
mselves=2E

Best regards,
  Max

Am 3=2E Februar 2020 18:33:27 MEZ schrieb Roman Penyaev <rpenyaev@suse=2Ed=
e>:
>Hi Max and all,
>
>I can reproduce the issue=2E  My epoll optimization which you referenced
>did not consider the case of wakeups on epoll_ctl() path, only the fd
>update path=2E
>
>I will send the fix upstream today/tomorrow (already tested on the
>epollbug=2Ec), the exemplary patch at the bottom of the current
>email=2E
>
>Also I would like to  submit the epollbug=2Ec as a test case for
>the epoll test suite=2E Does the author of epollbug have any
>objections?
>
>Thanks=2E
>
>--
>Roman
>
>diff --git a/fs/eventpoll=2Ec b/fs/eventpoll=2Ec
>index c4159bcc05d9=2E=2Ea90f8b8a5def 100644
>--- a/fs/eventpoll=2Ec
>+++ b/fs/eventpoll=2Ec
>@@ -745,7 +745,7 @@ static __poll_t ep_scan_ready_list(struct eventpoll
>
>*ep,
>                * the ->poll() wait list (delayed after we release the=20
>lock)=2E
>                  */
>                 if (waitqueue_active(&ep->wq))
>-                       wake_up(&ep->wq);
>+                       wake_up_locked(&ep->wq);
>                 if (waitqueue_active(&ep->poll_wait))
>                         pwake++;
>         }
>@@ -1200,7 +1200,7 @@ static inline bool chain_epi_lockless(struct=20
>epitem *epi)
>   * Another thing worth to mention is that ep_poll_callback() can be=20
>called
>* concurrently for the same @epi from different CPUs if poll table was=20
>inited
>* with several wait queues entries=2E  Plural wakeup from different CPUs=
=20
>of a
>- * single wait queue is serialized by wq=2Elock, but the case when=20
>multiple wait
>+ * single wait queue is serialized by ep->lock, but the case when=20
>multiple wait
>   * queues are used should be detected accordingly=2E  This is detected=
=20
>using
>   * cmpxchg() operation=2E
>   */
>@@ -1275,6 +1275,13 @@ static int ep_poll_callback(wait_queue_entry_t=20
>*wait, unsigned mode, int sync, v
>                                 break;
>                         }
>                 }
>+               /*
>+                * Since here we have the read lock (ep->lock) taken,=20
>plural
>+                * wakeup from different CPUs can occur, thus we call=20
>wake_up()
>+                * variant which implies its own lock on wqueue=2E All=20
>other paths
>+                * take write lock, thus modifications on ep->wq are=20
>serialized
>+                * by rw lock=2E
>+                */
>                 wake_up(&ep->wq);
>         }
>         if (waitqueue_active(&ep->poll_wait))
>@@ -1578,7 +1585,7 @@ static int ep_insert(struct eventpoll *ep, const=20
>struct epoll_event *event,
>
>                 /* Notify waiting tasks that events are available */
>                 if (waitqueue_active(&ep->wq))
>-                       wake_up(&ep->wq);
>+                       wake_up_locked(&ep->wq);
>                 if (waitqueue_active(&ep->poll_wait))
>                         pwake++;
>         }
>@@ -1684,7 +1691,7 @@ static int ep_modify(struct eventpoll *ep, struct
>
>epitem *epi,
>
>                         /* Notify waiting tasks that events are=20
>available */
>                         if (waitqueue_active(&ep->wq))
>-                               wake_up(&ep->wq);
>+                               wake_up_locked(&ep->wq);
>                         if (waitqueue_active(&ep->poll_wait))
>                                 pwake++;
>                 }
>@@ -1881,9 +1888,9 @@ static int ep_poll(struct eventpoll *ep, struct=20
>epoll_event __user *events,
>                 waiter =3D true;
>                 init_waitqueue_entry(&wait, current);
>
>-               spin_lock_irq(&ep->wq=2Elock);
>+               write_lock_irq(&ep->lock);
>                 __add_wait_queue_exclusive(&ep->wq, &wait);
>-               spin_unlock_irq(&ep->wq=2Elock);
>+               write_unlock_irq(&ep->lock);
>         }
>
>         for (;;) {
>@@ -1931,9 +1938,9 @@ static int ep_poll(struct eventpoll *ep, struct=20
>epoll_event __user *events,
>                 goto fetch_events;
>
>         if (waiter) {
>-               spin_lock_irq(&ep->wq=2Elock);
>+               write_lock_irq(&ep->lock);
>                 __remove_wait_queue(&ep->wq, &wait);
>-               spin_unlock_irq(&ep->wq=2Elock);
>+               write_unlock_irq(&ep->lock);
>         }
>
>         return res;
>
>
>
>
>On 2020-02-03 16:15, Max Neunhoeffer wrote:
>> Dear Jakub and all,
>>=20
>> I have done a git bisect and found that this commit introduced the=20
>> epoll
>> bug:
>>=20
>>
>https://github=2Ecom/torvalds/linux/commit/a218cc4914209ac14476cb32769b31=
a556355b22
>>=20
>> I Cc the author of the commit=2E
>>=20
>> This makes sense, since the commit introduces a new rwlock to reduce
>> contention in ep_poll_callback=2E I do not fully understand the details
>> but this sounds all very close to this bug=2E
>>=20
>> I have also verified that the bug is still present in the latest
>master
>> branch in Linus' repository=2E
>>=20
>> Furthermore, Chris Kohlhoff has provided yet another reproducing=20
>> program
>> which is no longer using edge-triggered but standard level-triggered
>> events and epoll_wait=2E This makes the bug all the more urgent, since
>> potentially more programs could run into this problem and could end
>up
>> with sleeping barbers=2E
>>=20
>> I have added all the details to the bugzilla bugreport:
>>=20
>>   https://bugzilla=2Ekernel=2Eorg/show_bug=2Ecgi?id=3D205933
>>=20
>> Hopefully, we can resolve this now equipped with this amount of=20
>> information=2E
>>=20
>> Best regards,
>>   Max=2E
>>=20
>> On 20/02/01 12:16, Jakub Kicinski wrote:
>>> On Fri, 31 Jan 2020 14:57:30 +0100, Max Neunhoeffer wrote:
>>> > Dear All,
>>> >
>>> > I believe I have found a bug in Linux 5=2E3 and 5=2E4 in
>epoll_wait/epoll_ctl
>>> > when an eventfd together with edge-triggered or the EPOLLONESHOT
>policy
>>> > is used=2E If an epoll_ctl call to rearm the eventfd happens
>approximately
>>> > at the same time as the epoll_wait goes to sleep, the event can be
>lost,
>>> > even though proper protection through a mutex is employed=2E
>>> >
>>> > The details together with two programs showing the problem can be
>found
>>> > here:
>>> >
>>> >   https://bugzilla=2Ekernel=2Eorg/show_bug=2Ecgi?id=3D205933
>>> >
>>> > Older kernels seem not to have this problem, although I did not
>test all
>>> > versions=2E I know that 4=2E15 and 5=2E0 do not show the problem=2E
>>> >
>>> > Note that this method of using epoll_wait/eventfd is used by
>>> > boost::asio to wake up event loops in case a new completion
>handler
>>> > is posted to an io_service, so this is probably relevant for many
>>> > applications=2E
>>> >
>>> > Any help with this would be appreciated=2E
>>>=20
>>> Could be networking related but let's CC FS folks just in case=2E
>>>=20
>>> Would you be able to perform bisection to narrow down the search
>>> for a buggy change?
