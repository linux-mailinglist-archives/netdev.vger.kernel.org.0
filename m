Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059147E407
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348617AbhLWNSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:18:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348613AbhLWNSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640265496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWXug9XOKWSU/12+6kVzArJmbV7ilOvZ5ITUhG4ThUA=;
        b=Eiu5bUl8YS6DB2cg1AACd9+J3EHUI6I81mGJItxMjQX7P71SWn9Q21DCRFXHMPZKgtHWs3
        gGCt973uxLe5wIvKxphlLXicAyiwVqXUV6e+chioO729uybsAuL935TXFkAhuXMta8ikmY
        zJDHbPfYCWJRIOb5ljC4ud5F2h6bYiU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-vDYflINROvmt2AfOSlqiKA-1; Thu, 23 Dec 2021 08:18:15 -0500
X-MC-Unique: vDYflINROvmt2AfOSlqiKA-1
Received: by mail-io1-f69.google.com with SMTP id ay10-20020a5d9d8a000000b005e238eaeaa9so3130045iob.12
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 05:18:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oWXug9XOKWSU/12+6kVzArJmbV7ilOvZ5ITUhG4ThUA=;
        b=D6G42/szHWMWK88RhncS9Fp8FEbQgY0W43Xvotwx34T17vVWr3bprCXs+wu00+qUEc
         rxB3Yi8S94zdU8y5aUUrf8meamJivASH3TRLq4AvdsAnUuQcIEP/3i2gxGqb3UJIqUpL
         hqnTPprlGb9gHH5cMMz0MCkz/0cxKaE0esHIcbGmTaKwOe8I7fC4E63phQ3gv18fCgwg
         R7/sEgz64au8wochoyip4VtLmKdhVPLpr/DU49pwSwa5GPDZTYx0BbkWMlx/t6IdBV8V
         1t2r4Xorb+4JtOYQrSExw3oca+8PJE8on2QltwzYUQ2zh997yathZBxW18WKJAwozx7G
         eZtw==
X-Gm-Message-State: AOAM530Bk8NFd9gBUmYWQDRB9KuCxWQK24Ug9himti38M5wnY+nTbucg
        q3IbOYQ/OE0FJrp3xfi9zwt2BujCj6gii2aPs2lo9Zj3PWBgktrlURWEq6SFMPIkvMpXdDi3EIE
        yXYZbUwJeGnCY01wpMttVFFWZ1EVUZzx1
X-Received: by 2002:a05:6e02:1528:: with SMTP id i8mr1012856ilu.312.1640265494562;
        Thu, 23 Dec 2021 05:18:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2ieHLybgJ35RhS/0meW79Aq5j6+U2Jp3pvSTNJuZMvmVzRiI+0xzHxuu82D4vjtQlJoNaVukfMMs22n5JIkw=
X-Received: by 2002:a05:6e02:1528:: with SMTP id i8mr1012837ilu.312.1640265494344;
 Thu, 23 Dec 2021 05:18:14 -0800 (PST)
MIME-Version: 1.0
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com> <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
In-Reply-To: <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 23 Dec 2021 14:18:03 +0100
Message-ID: <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
Subject: Re: Bad performance in RX with sfc 40G
To:     habetsm.xilinx@gmail.com
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

I replied this a few weeks ago, but it seems that, for some reason, I
didn't CCd you.

On Thu, Dec 9, 2021 at 1:06 PM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com> =
wrote:
>
> Hi,
>
> On Sat, Nov 20, 2021 at 9:31 AM Martin Habets <habetsm.xilinx@gmail.com> =
wrote:
> > If you're testing without the IOMMU enabled I suspect the recycle ring
> > size may be too small. Can your try the patch below?
>
> Sorry for the very late reply, but I've had to be out of work for many da=
ys.
>
> This patch has improved the performance a lot, reaching the same
> 30Gbps than in TX. However, it seems sometimes a bit erratic, still
> dropping to 15Gbps sometimes, specially after module remove & probe,
> or from one iperf call to another. But not being all the times, I
> didn't found a clear pattern. Anyway, it clearly improves things.
>
> Can this patch be applied as is or it's just a test?
>
> --
> =C3=8D=C3=B1igo Huguet



--=20
=C3=8D=C3=B1igo Huguet

