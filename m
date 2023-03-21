Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB16C37AD
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCURFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjCURFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:05:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471C28EA0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:05:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so6010641pjb.4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1679418325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICDfoO/IL51uzq7ZcGszRyxZ/UXjMum/IqrrVVdXBUI=;
        b=YCDYO2HrdqP2cgF7uSwrqoI4wPS/mr1hsf+gv+iGEH27/jQDSBVmsCDnJ28+uXP38L
         RcdEbeTzOzvBmly/jY+nXm4RuPmUwJc66xEjswkrzUK+ioDNrpX7KwRhbhYzQh0gSdfT
         G/yN91rqQWhQNidWoF1/cklkcrJpmajWQS3E23DhbjvzIie2qwCmZr50oiiZftgUrPz5
         vZX+UfEsW0rKFib2DF5pJ8LGi7DXQRgT1iIDUsTYbGBRXqiGuiefGKPwDAnIOE5LLJCI
         xU1KjpUbSLN2MD49o5SR7AN27AWVN8X3uENz0IUTM+sxcZjPXftcL5Exyg7QVxAX9mCh
         nt0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICDfoO/IL51uzq7ZcGszRyxZ/UXjMum/IqrrVVdXBUI=;
        b=YrGJWo+CE5UHXcUEW+mdKe4ioIb/oCnosPcMc0UmjbLlNfoYn6hD8njd3zDC2/x0U7
         4UoZtRzII6ZQXLXPYRVfPmPeipA/fbW/cN2AUkGBV74BduVU4m3P5iUwH95flIct9lE9
         Y/bl3mONtDF8/Xg13Hsd/edNVq9Sr2NG9nML013U5je+Gw9Y3GJ+0Kcwex57ux+MOnr0
         CeYWPGTF0ERfGKNgXQIvA3dDNIVs/ecCYxUHNC/H3grCEcgSR+L6E0Tizwvct3QBksQp
         utCPHp7D9OxXyhYSIZROYJduBogpTwCzpalM1BxvWZ2VTvKJsVZS4N6p067/9KynfJD/
         Dpyw==
X-Gm-Message-State: AO0yUKUx84DOmAHz3ou0YbPmYic5ZH0nQSvj1MCGEZsk/xLdBkapqV6t
        VUy1hdMKsbzDKjraQAEAeU5kFQ==
X-Google-Smtp-Source: AK7set/qT26XyElnHoZHdvs1Lur7jH1fwGbisRfiH1xvN2Gd552UHMDXqVAFWK/L7TZCPRiqtJ7I7g==
X-Received: by 2002:a17:903:2312:b0:1a1:a6e5:764b with SMTP id d18-20020a170903231200b001a1a6e5764bmr3583105plh.60.1679418325125;
        Tue, 21 Mar 2023 10:05:25 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id jl17-20020a170903135100b001a1d41d1b8asm3983961plb.194.2023.03.21.10.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:05:24 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:05:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        corbet@lwn.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, pisa@cmp.felk.cvut.cz,
        mkl@pengutronix.de, linux-doc@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Message-ID: <20230321100522.474c3763@hermes.local>
In-Reply-To: <20230321050334.1036870-1-kuba@kernel.org>
References: <20230321050334.1036870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 22:03:34 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Looks good overall. I used a grammar scanner to look for issues and
it found lots of little things.

Here are my suggested changes:

diff --git a/Documentation/networking/napi.rst b/Documentation/networking/n=
api.rst
index e9833f2b777a..822d0bf399af 100644
--- a/Documentation/networking/napi.rst
+++ b/Documentation/networking/napi.rst
@@ -5,19 +5,20 @@ NAPI
 =3D=3D=3D=3D
=20
 NAPI is the event handling mechanism used by the Linux networking stack.
-The name NAPI does not stand for anything in particular [#]_.
+The name NAPI no longer stands for anything in particular [#]_.
=20
-In basic operation device notifies the host about new events via an interr=
upt.
-The host then schedules a NAPI instance to process the events.
-Device may also be polled for events via NAPI without receiving
+The basic concept of NAPI is that the device notifies
+the kernel about new events via interrupts; then
+the kernel then schedules a NAPI instance to process the events.
+The device may also be polled for events via NAPI without receiving
 interrupts first (:ref:`busy polling<poll>`).
=20
 NAPI processing usually happens in the software interrupt context,
-but user may choose to use :ref:`separate kernel threads<threaded>`
+but there is an option to use :ref:`separate kernel threads<threaded>`
 for NAPI processing.
=20
-All in all NAPI abstracts away from the drivers the context and configurat=
ion
-of event (packet Rx and Tx) processing.
+The goal of NAPI is to abstract the context and configuration of
+event handling.
=20
 Driver API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -25,7 +26,7 @@ Driver API
 The two most important elements of NAPI are the struct napi_struct
 and the associated poll method. struct napi_struct holds the state
 of the NAPI instance while the method is the driver-specific event
-handler. The method will typically free Tx packets which had been
+handler. The method will typically free Tx packets that have been
 transmitted and process newly received packets.
=20
 .. _drv_ctrl:
@@ -44,8 +45,8 @@ to not be invoked. napi_disable() waits for ownership of =
the NAPI
 instance to be released.
=20
 The control APIs are not idempotent. Control API calls are safe against
-concurrent use of datapath APIs but incorrect sequence of control API
-calls may result in crashes, deadlocks, or race conditions. For example
+concurrent use of datapath APIs but an incorrect sequence of control API
+calls may result in crashes, deadlocks, or race conditions. For example,
 calling napi_disable() multiple times in a row will deadlock.
=20
 Datapath API
@@ -53,28 +54,30 @@ Datapath API
=20
 napi_schedule() is the basic method of scheduling a NAPI poll.
 Drivers should call this function in their interrupt handler
-(see :ref:`drv_sched` for more info). Successful call to napi_schedule()
+(see :ref:`drv_sched` for more info). A successful call to napi_schedule()
 will take ownership of the NAPI instance.
=20
-Some time after NAPI is scheduled driver's poll method will be
+Later, after NAPI is scheduled, the driver's poll method will be
 called to process the events/packets. The method takes a ``budget``
 argument - drivers can process completions for any number of Tx
-packets but should only process up to ``budget`` number of
-Rx packets. Rx processing is usually much more expensive.
+packets but should only process up to the ``budget`` number of
+Rx packets. This is ``budget`` argument is used to limit the
+time spent in the poll method when a server is under heavy network
+load.
=20
-In other words, it is recommended to ignore the budget argument when
+For most drivers, it is recommended to ignore the budget argument when
 performing TX buffer reclamation to ensure that the reclamation is not
-arbitrarily bounded, however, it is required to honor the budget argument
+arbitrarily bounded; the budget should be honored
 for RX processing.
=20
-.. warning::
+.. note::
=20
-   ``budget`` may be 0 if core tries to only process Tx completions
+   The ``budget`` argument may be 0 if core tries to only process Tx compl=
etions
    and no Rx packets.
=20
-The poll method returns amount of work done. If the driver still
+The poll method returns the amount of work done. If the driver still
 has outstanding work to do (e.g. ``budget`` was exhausted)
-the poll method should return exactly ``budget``. In that case
+the poll method should return exactly ``budget``. In that case,
 the NAPI instance will be serviced/polled again (without the
 need to be scheduled).
=20
@@ -83,22 +86,21 @@ processed) the poll method should call napi_complete_do=
ne()
 before returning. napi_complete_done() releases the ownership
 of the instance.
=20
-.. warning::
+.. note::
=20
-   The case of finishing all events and using exactly ``budget``
-   must be handled carefully. There is no way to report this
-   (rare) condition to the stack, so the driver must either
-   not call napi_complete_done() and wait to be called again,
+   The case of finishing all events and processing the full ``budget``
+   of packets requires special consideration. The driver must
+   either call napi_complete_done() (and wait to be called again)
    or return ``budget - 1``.
=20
-   If ``budget`` is 0 napi_complete_done() should never be called.
+   If the ``budget`` is 0 napi_complete_done() should never be called.
=20
 Call sequence
 -------------
=20
 Drivers should not make assumptions about the exact sequencing
-of calls. The poll method may be called without driver scheduling
-the instance (unless the instance is disabled). Similarly
+of calls. The poll method may be called without the driver scheduling
+the instance (unless the instance is disabled). Similarly,
 it's not guaranteed that the poll method will be called, even
 if napi_schedule() succeeded (e.g. if the instance gets disabled).
=20
@@ -129,7 +131,7 @@ and __napi_schedule() calls:
       __napi_schedule(&v->napi);
   }
=20
-IRQ should only be unmasked after successful call to napi_complete_done():
+IRQ should only be unmasked after a successful call to napi_complete_done(=
):
=20
 .. code-block:: c
=20
@@ -150,7 +152,7 @@ Instance to queue mapping
 Modern devices have multiple NAPI instances (struct napi_struct) per
 interface. There is no strong requirement on how the instances are
 mapped to queues and interrupts. NAPI is primarily a polling/processing
-abstraction without many user-facing semantics. That said, most networking
+abstraction without specific user-facing semantics. That said, most networ=
king
 devices end up using NAPI in fairly similar ways.
=20
 NAPI instances most often correspond 1:1:1 to interrupts and queue pairs
@@ -164,7 +166,7 @@ a 1:1 mapping between NAPI instances and interrupts.
 It's worth noting that the ethtool API uses a "channel" terminology where
 each channel can be either ``rx``, ``tx`` or ``combined``. It's not clear
 what constitutes a channel, the recommended interpretation is to understand
-a channel as an IRQ/NAPI which services queues of a given type. For example
+a channel as an IRQ/NAPI which services queues of a given type. For exampl=
e,
 a configuration of 1 ``rx``, 1 ``tx`` and 1 ``combined`` channel is expect=
ed
 to utilize 3 interrupts, 2 Rx and 2 Tx queues.
=20
@@ -194,12 +196,12 @@ before NAPI gives up and goes back to using hardware =
IRQs.
 Busy polling
 ------------
=20
-Busy polling allows user process to check for incoming packets before
-the device interrupt fires. As is the case with any busy polling it trades
-off CPU cycles for lower latency (in fact production uses of NAPI busy
+Busy polling allows a user process to check for incoming packets before
+the device interrupt fires. This mode trades off CPU cycles
+for lower latency (in fact production uses of NAPI busy
 polling are not well known).
=20
-User can enable busy polling by either setting ``SO_BUSY_POLL`` on
+Busy polling is enabled by either setting ``SO_BUSY_POLL`` on
 selected sockets or using the global ``net.core.busy_poll`` and
 ``net.core.busy_read`` sysctls. An io_uring API for NAPI busy polling
 also exists.
@@ -218,7 +220,7 @@ of packets.
 Such applications can pledge to the kernel that they will perform a busy
 polling operation periodically, and the driver should keep the device IRQs
 permanently masked. This mode is enabled by using the ``SO_PREFER_BUSY_POL=
L``
-socket option. To avoid the system misbehavior the pledge is revoked
+socket option. To avoid system misbehavior the pledge is revoked
 if ``gro_flush_timeout`` passes without any busy poll call.
=20
 The NAPI budget for busy polling is lower than the default (which makes
@@ -231,7 +233,7 @@ with the ``SO_BUSY_POLL_BUDGET`` socket option.
 Threaded NAPI
 -------------
=20
-Threaded NAPI is an operating mode which uses dedicated kernel
+Threaded NAPI is an operating mode that uses dedicated kernel
 threads rather than software IRQ context for NAPI processing.
 The configuration is per netdevice and will affect all
 NAPI instances of that device. Each NAPI instance will spawn a separate


