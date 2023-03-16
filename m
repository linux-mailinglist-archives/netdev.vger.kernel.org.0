Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986DA6BCB5E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCPJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCPJuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:50:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784614BE87;
        Thu, 16 Mar 2023 02:50:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d13so1120277pjh.0;
        Thu, 16 Mar 2023 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678960206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0uZJre1YGe7dWYNotBSl53Vma10u37aIFtB+45gsSc=;
        b=qS691XL4syPnKeg8RgoFAbMp3Ln61vIPSjptyEOce3Ad7uzseCF7CrUiXScMxmCuWD
         3FhzwQj1WTYExqFrU/f+yiarDigAh5GpsncoCgrJFPlmX7c+mgkbpHr5C/wOwVmc57QL
         529ta/in7PICB8OS2kttVGTqt05QmsOqQQinXHdlFXIMwbn8mP5ZCQDqfWXNKqdkiv17
         Qv2zLf3SWk2kQmcOBEE23DLHzfB+gI3ilBmz7fJLwQK7RN5ZxkVnJ4QBNmlT1OWyGyW2
         FS2yvVG1SIJW/cc24JXRMOdR/Z7rTjS+sihsDm9NX+IcWc/ZWwmcCy9/XXOkpXO1iXHA
         YpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678960206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0uZJre1YGe7dWYNotBSl53Vma10u37aIFtB+45gsSc=;
        b=xaMkXJ/yN419lfcCJ1skxnJb7WSFTXu0/bXY76v1ZtCXZOgeJvKjsxAyIb8RwgXQiv
         ZupWZgvRHxCikQdrtShyBoz1v3sr6KWRkhqPJHyEQFOX+TEB5ufiBXvvP7pDa4QLe2EB
         bM6ZSvoJP9X0djlUQVXG25/XzLFvkuTrQgqIOnu+pN0ID4TFtG3CO3/GlQM8sx70b/VU
         1Ki2b+Mtlt7rnuiKfvpbEBOORSZeUgn7yeF0FQRv97Sldi2xAxFAJWoIl+VNODcjNuwR
         1mCGyllpj2NQRj+/qcHL4BawAYtv2vrV11lg3VnYuRX+QMjCtUdJy5PM+FIyCDuuUYJn
         vixQ==
X-Gm-Message-State: AO0yUKX/7HGJ4N7NuuDl8yZxYowK1/lIkEZl3qbCtuletUC/45x7cYec
        Deibp/xNYXAWaovDLhQLUFGmqy9o0EyO0w==
X-Google-Smtp-Source: AK7set9PCP0kCmwiBsp2P2Za5SeN6N1C8MejZ5fZjCbuNku5N97CkTc8xBD1od0Ziq+wlaVZB70h0w==
X-Received: by 2002:a05:6a20:1e47:b0:d7:3c1a:6cd5 with SMTP id cy7-20020a056a201e4700b000d73c1a6cd5mr212214pzb.47.1678960205716;
        Thu, 16 Mar 2023 02:50:05 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-4.three.co.id. [180.214.232.4])
        by smtp.gmail.com with ESMTPSA id y3-20020a62b503000000b0059085684b54sm5185864pfe.140.2023.03.16.02.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:50:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id D85D2106628; Thu, 16 Mar 2023 16:50:01 +0700 (WIB)
Date:   Thu, 16 Mar 2023 16:50:01 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <ZBLmSdvhUcfFxAp2@debian.me>
References: <20230315223044.471002-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1Uo30uTjRlQljcU"
Content-Disposition: inline
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X1Uo30uTjRlQljcU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 03:30:44PM -0700, Jakub Kicinski wrote:
> -See https://wiki.linuxfoundation.org/networking/napi for more
> -information on NAPI.
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.
> <snipped>...
> -For more information on NAPI, see
> -https://wiki.linuxfoundation.org/networking/napi
> +
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.
> =20
> <snipped>...
> -See https://wiki.linuxfoundation.org/networking/napi for more informatio=
n on
> -NAPI.
> -
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.

I prefer not to use :ref:, but simply write out the full document path
to achieve the same internal link.

> +=3D=3D=3D=3D
> +NAPI
> +=3D=3D=3D=3D
> +
> +NAPI is the event handling mechanism used by the Linux networking stack.
> +The name NAPI does not stand for anything in particular.
> +
> +In basic operation device notifies the host about new events via an inte=
rrupt.
> +The host then schedules a NAPI instance to process the events.
> +Device may also be polled for events via NAPI without receiving
> +an interrupts first (busy polling).
> +
> +NAPI processing usually happens in the software interrupt context,
> +but user may choose to use separate kernel threads for NAPI processing.
> +
> +All in all NAPI abstracts away from the drivers the context and configur=
ation
> +of event (packet Rx and Tx) processing.
> +
> +Driver API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The two most important elements of NAPI are the struct napi_struct
> +and the associated poll method. struct napi_struct holds the state
> +of the NAPI instance while the method is the driver-specific event
> +handler. The method will typically free Tx packets which had been
> +transmitted and process newly received packets.
> +
> +.. _drv_ctrl:
> +
> +Control API
> +-----------
> +
> +netif_napi_add() and netif_napi_del() add/remove a NAPI instance
> +from the system. The instances are attached to the netdevice passed
> +as argument (and will be deleted automatically when netdevice is
> +unregistered). Instances are added in a disabled state.
> +
> +napi_enable() and napi_disable() manage the disabled state.
> +A disabled NAPI can't be scheduled and its poll method is guaranteed
> +to not be invoked. napi_disable() waits for ownership of the NAPI
> +instance to be released.
> +
> +Datapath API
> +------------
> +
> +napi_schedule() is the basic method of scheduling a NAPI poll.
> +Drivers should call this function in their interrupt handler
> +(see :ref:`drv_sched` for more info). Successful call to napi_schedule()
> +will take ownership of the NAPI instance.
> +
> +Some time after NAPI is scheduled driver's poll method will be
> +called to process the events/packets. The method takes a ``budget``
> +argument - drivers can process completions for any number of Tx
> +packets but should only process up to ``budget`` number of
> +Rx packets. Rx processing is usually much more expensive.
> +
> +.. warning::
> +
> +   ``budget`` may be 0 if core tries to only process Tx completions
> +   and no Rx packets.
> +
> +The poll method returns amount of work performed. If driver still
> +has outstanding work to do (e.g. ``budget`` was exhausted)
> +the poll method should return exactly ``budget``. In that case
> +the NAPI instance will be serviced/polled again (without the
> +need to be scheduled).
> +
> +If event processing has been completed (all outstanding packets
> +processed) the poll method should call napi_complete_done()
> +before returning. napi_complete_done() releases the ownership
> +of the instance.
> +
> +.. warning::
> +
> +   The case of finishing all events and using exactly ``budget``
> +   must be handled carefully. There is no way to report this
> +   (rare) condition to the stack, so the driver must either
> +   not call napi_complete_done() and wait to be called again,
> +   or return ``budget - 1``.
> +
> +   If ``budget`` is 0 napi_complete_done() should never be called.
> +
> +Call sequence
> +-------------
> +
> +Drivers should not make assumptions about the exact sequencing
> +of calls. The poll method may be called without driver scheduling
> +the instance (unless the instance is disabled). Similarly if
> +it's not guaranteed that the poll method will be called, even
> +if napi_schedule() succeeded (e.g. if the instance gets disabled).
> +
> +As mentioned in the :ref:`drv_ctrl` section - napi_disable() and subsequ=
ent
> +calls to the poll method only wait for the ownership of the instance
> +to be released, not for the poll method to exit. This means that
> +drivers should avoid accessing any data structures after calling
> +napi_complete_done().
> +
> +.. _drv_sched:
> +
> +Scheduling and IRQ masking
> +--------------------------
> +
> +Drivers should keep the interrupts masked after scheduling
> +the NAPI instance - until NAPI polling finishes any further
> +interrupts are unnecessary.
> +
> +Drivers which have to mask the interrupts explicitly (as opposed
> +to IRQ being auto-masked by the device) should use the napi_schedule_pre=
p()
> +and __napi_schedule() calls:
> +
> +.. code-block:: c
> +
> +  if (napi_schedule_prep(&v->napi)) {
> +      mydrv_mask_rxtx_irq(v->idx);
> +      /* schedule after masking to avoid races */
> +      __napi_schedule(&v->napi);
> +  }
> +
> +IRQ should only be unmasked after successful call to napi_complete_done(=
):
> +
> +.. code-block:: c
> +
> +  if (budget && napi_complete_done(&v->napi, work_done)) {
> +    mydrv_unmask_rxtx_irq(v->idx);
> +    return min(work_done, budget - 1);
> +  }
> +
> +napi_schedule_irqoff() is a variant of napi_schedule() which takes advan=
tage
> +of guarantees given by being invoked in IRQ context (no need to
> +mask interrupts). Note that PREEMPT_RT forces all interrupts
> +to be threaded so the interrupt may need to be marked ``IRQF_NO_THREAD``
> +to avoid issues on real-time kernel configurations.
> +
> +Instance to queue mapping
> +-------------------------
> +
> +Modern devices have multiple NAPI instances (struct napi_struct) per
> +interface. There is no strong requirement on how the instances are
> +mapped to queues and interrupts. NAPI is primarily a polling/processing
> +abstraction without many user-facing semantics. That said, most networki=
ng
> +devices end up using NAPI is fairly similar ways.
> +
> +NAPI instances most often correspond 1:1:1 to interrupts and queue pairs
> +(queue pair is a set of a single Rx and single Tx queue).
> +
> +In less common cases a NAPI instance may be used for multiple queues
> +or Rx and Tx queues can be serviced by separate NAPI instances on a sing=
le
> +core. Regardless of the queue assignment, however, there is usually still
> +a 1:1 mapping between NAPI instances and interrupts.
> +
> +It's worth noting that the ethtool API uses a "channel" terminology where
> +each channel can be either ``rx``, ``tx`` or ``combined``. It's not clear
> +what constitutes a channel, the recommended interpretation is to underst=
and
> +a channel as an IRQ/NAPI which services queues of a given type. For exam=
ple
> +a configuration of 1 ``rx``, 1 ``tx`` and 1 ``combined`` channel is expe=
cted
> +to utilize 3 interrupts, 2 Rx and 2 Tx queues.
> +
> +User API
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +User interactions with NAPI depend on NAPI instance ID. The instance IDs
> +are only visible to the user thru the ``SO_INCOMING_NAPI_ID`` socket opt=
ion.
> +It's not currently possible to query IDs used by a given device.
> +
> +Software IRQ coalescing
> +-----------------------
> +
> +NAPI does not perform any explicit event coalescing by default.
> +In most scenarios batching happens due to IRQ coalescing which is done
> +by the device. There are cases where software coalescing is helpful.
> +
> +NAPI can be configured to arm a repoll timer instead of unmasking
> +the hardware interrupts as soon as all packets are processed.
> +The ``gro_flush_timeout`` sysfs configuration of the netdevice
> +is reused to control the delay of the timer, while
> +``napi_defer_hard_irqs`` controls the number of consecutive empty polls
> +before NAPI gives up and goes back to using hardware IRQs.
> +
> +Busy polling
> +------------
> +
> +Busy polling allows user process to check for incoming packets before
> +device interrupt fires. As is the case with any busy polling it trades
> +off CPU cycles for lower latency (in fact production uses of NAPI busy
> +polling are not well known).
> +
> +User can enable busy polling by either setting ``SO_BUSY_POLL`` on
> +selected sockets or using the global ``net.core.busy_poll`` and
> +``net.core.busy_read`` sysctls. An io_uring API for NAPI busy polling
> +also exists.
> +
> +IRQ mitigation
> +---------------
> +
> +While busy polling is supposed to be used by low latency applications,
> +a similar mechanism can be used for IRQ mitigation.
> +
> +Very high request-per-second applications (especially routing/forwarding
> +applications and especially applications using AF_XDP sockets) may not
> +want to be interrupted until they finish processing a request or a batch
> +of packets.
> +
> +Such applications can pledge to the kernel that they will perform a busy
> +polling operation periodically, and the driver should keep the device IR=
Qs
> +permanently masked. This mode is enabled by using the ``SO_PREFER_BUSY_P=
OLL``
> +socket option. To avoid the system misbehavior the pledge is revoked
> +if ``gro_flush_timeout`` passes without any busy poll call.
> +
> +The NAPI budget for busy polling is lower than the default (which makes
> +sense given the low latency intention of normal busy polling). This is
> +not the case with IRQ mitigation, however, so the budget can be adjusted
> +with the ``SO_BUSY_POLL_BUDGET`` socket option.
> +
> +Threaded NAPI
> +-------------
> +
> +Use dedicated kernel threads rather than software IRQ context for NAPI
> +processing. The configuration is per netdevice and will affect all
> +NAPI instances of that device. Each NAPI instance will spawn a separate
> +thread (called ``napi/${ifc-name}-${napi-id}``).
> +
> +It is recommended to pin each kernel thread to a single CPU, the same
> +CPU as services the interrupt. Note that the mapping between IRQs and
> +NAPI instances may not be trivial (and is driver dependent).
> +The NAPI instance IDs will be assigned in the opposite order
> +than the process IDs of the kernel threads.
> +
> +Threaded NAPI is controlled by writing 0/1 to the ``threaded`` file in
> +netdev's sysfs directory.
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 470085b121d3..b439f877bc3a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -508,15 +508,18 @@ static inline bool napi_reschedule(struct napi_stru=
ct *napi)
>  	return false;
>  }
> =20
> -bool napi_complete_done(struct napi_struct *n, int work_done);
>  /**
> - *	napi_complete - NAPI processing complete
> - *	@n: NAPI context
> + * napi_complete_done - NAPI processing complete
> + * @n: NAPI context
> + * @work_done: number of packets processed
>   *
> - * Mark NAPI processing as complete.
> - * Consider using napi_complete_done() instead.
> + * Mark NAPI processing as complete. Should only be called if poll budget
> + * has not been completely consumed.
> + * Prefer over napi_complete().
>   * Return false if device should avoid rearming interrupts.
>   */
> +bool napi_complete_done(struct napi_struct *n, int work_done);
> +
>  static inline bool napi_complete(struct napi_struct *n)
>  {
>  	return napi_complete_done(n, 0);

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--X1Uo30uTjRlQljcU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBLmRgAKCRD2uYlJVVFO
o/NXAP4wShTG+omuZcC8nuLEekTFfuLZY6qpkfxznJ9pPtC4oAEAsXgfK7vU3Uzh
YynZsh2jEFyKS9x1i8A3lja5bitG1gQ=
=eDn9
-----END PGP SIGNATURE-----

--X1Uo30uTjRlQljcU--
