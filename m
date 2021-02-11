Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264E6318D2F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhBKOTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhBKORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:17:17 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D4BC0613D6;
        Thu, 11 Feb 2021 06:16:36 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y134so5914484wmd.3;
        Thu, 11 Feb 2021 06:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=Cy7wIsuzTgl3aboWz/KovEJxl9QgfW9V5yGGjiDAWYM=;
        b=ceGtK16iiqXY4tgCK1vcKqBj4841jW8joof8S5SVv23VqEhPPrve3dH08MDFnAW8gT
         eDso9WyJXR0PA6bWE6qzadYTP4IRUv2MiuarZWCROw9k+VeyhRDA9lUEiPOqTwWyHTiA
         8oFIew0jN2w50DFl/edAVtXnvBA8T6ELRsB0yHtWmRNqXdKBax/B6dt4/+sVOkYxBuJZ
         ygiiDkEQOfvXTthd+sIy5RKUovNOzFQ/jzmU/xL8cASUcfaooC4EmBjuVYOfE6UNP6ID
         gzhTYcoWpGzDsu9Fs4152wzszrgjUAZMBh9fNIHMRM4cKAO+x5jqAZUbhdbwVgvcQxl3
         ks5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=Cy7wIsuzTgl3aboWz/KovEJxl9QgfW9V5yGGjiDAWYM=;
        b=l1aeu8yDne118Q5JPQiKaxceFj72JYrdu/koeFQhSCWGz1/pUUTHpXum5aBNsqNmdi
         skTIsyiYtBtNy5KdHTgtrHl+kZyCemtb7ymPTO1sdg9NuCFte7biaNTHgATcfiKTSmO7
         GQrshDna4JUsWkcEawzX6pJwhi7QXeX2UVWQKMoJ8JqpdR/sovrwGGiqx/8XrA7ZlVWo
         ZrA/o3hxiH7BtjgPWJkSbC2KyHZH29DqUoiBiMDHfwGyRD5kwUQiCpUOJcAgOsAPClfr
         J87AmvzBuaMVzz6istjKnogzBLdtSJ8hoE0GVxE2ePR/QbGKF42ykcYqh5j9PoSqicL+
         qNuA==
X-Gm-Message-State: AOAM531rkhxwnDyzlBBHE5o0bZwg+MCirDIJ/sY7E/jAgI08Vkl7apxQ
        YDRkmZE/boeItRbkCdYKE18=
X-Google-Smtp-Source: ABdhPJxTbARAJSnDj9FS90ZX4jupockoPgBhbigpLeuBQY+mCo7W/pQ+NNyaOiH3hCn1BLn43MXmKg==
X-Received: by 2002:a05:600c:2d44:: with SMTP id a4mr5294978wmg.95.1613052994868;
        Thu, 11 Feb 2021 06:16:34 -0800 (PST)
Received: from CBGR90WXYV0 ([2a00:23c5:5785:9a01:f088:412:4748:4eb1])
        by smtp.gmail.com with ESMTPSA id z8sm5045343wrr.55.2021.02.11.06.16.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Feb 2021 06:16:34 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Juergen Gross'" <jgross@suse.com>,
        <xen-devel@lists.xenproject.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Cc:     "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        =?utf-8?Q?'Roger_Pau_Monn=C3=A9'?= <roger.pau@citrix.com>,
        "'Jens Axboe'" <axboe@kernel.dk>, "'Wei Liu'" <wei.liu@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Boris Ostrovsky'" <boris.ostrovsky@oracle.com>,
        "'Stefano Stabellini'" <sstabellini@kernel.org>
References: <20210211101616.13788-1-jgross@suse.com> <20210211101616.13788-6-jgross@suse.com>
In-Reply-To: <20210211101616.13788-6-jgross@suse.com>
Subject: RE: [PATCH v2 5/8] xen/events: link interdomain events to associated xenbus device
Date:   Thu, 11 Feb 2021 14:16:33 -0000
Message-ID: <001e01d70080$80afd5a0$820f80e0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQJuRSjpYwlLGVvLkRJGigHTv/cnpwH8bIuTqRSTGoA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Juergen Gross <jgross@suse.com>
> Sent: 11 February 2021 10:16
> To: xen-devel@lists.xenproject.org; linux-block@vger.kernel.org; =
linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; linux-scsi@vger.kernel.org
> Cc: Juergen Gross <jgross@suse.com>; Konrad Rzeszutek Wilk =
<konrad.wilk@oracle.com>; Roger Pau Monn=C3=A9
> <roger.pau@citrix.com>; Jens Axboe <axboe@kernel.dk>; Wei Liu =
<wei.liu@kernel.org>; Paul Durrant
> <paul@xen.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski =
<kuba@kernel.org>; Boris
> Ostrovsky <boris.ostrovsky@oracle.com>; Stefano Stabellini =
<sstabellini@kernel.org>
> Subject: [PATCH v2 5/8] xen/events: link interdomain events to =
associated xenbus device
>=20
> In order to support the possibility of per-device event channel
> settings (e.g. lateeoi spurious event thresholds) add a xenbus device
> pointer to struct irq_info() and modify the related event channel
> binding interfaces to take the pointer to the xenbus device as a
> parameter instead of the domain id of the other side.
>=20
> While at it remove the stale prototype of =
bind_evtchn_to_irq_lateeoi().
>=20
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>

Reviewed-by: Paul Durrant <paul@xen.org>

