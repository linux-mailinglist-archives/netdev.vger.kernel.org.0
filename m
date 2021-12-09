Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B1746E811
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbhLIMKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:10:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhLIMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639051619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VrYGybXz2DW34hGWfFgETOhknQ/BQWp9erybghjeVR0=;
        b=WkE3MXB19B9W6pRT4dnMhW1RsACgFofzbK0hFyGWeq0ZtaTMvAmthXVln0P5Ymw7iM6/HB
        vErAZAnPG4UtPUpd2ZDOfzbKu6eOaAcWutHtKjTqa8iMxkyhvoaZVxK3GjgA+r3YCJMuNE
        dYVdIquC2CxsKc63IspaN16boS4b6qI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-bWsPtCwIPnm7QVUTfilyfg-1; Thu, 09 Dec 2021 07:06:58 -0500
X-MC-Unique: bWsPtCwIPnm7QVUTfilyfg-1
Received: by mail-io1-f69.google.com with SMTP id ay10-20020a5d9d8a000000b005e238eaeaa9so6757069iob.12
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 04:06:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=VrYGybXz2DW34hGWfFgETOhknQ/BQWp9erybghjeVR0=;
        b=vnNJlYFdC3fqhn7YAN5DzKSNrS7GE8CPQT2kmdaZ+cocyEqjDlCYMT6aIT+M7+ALs6
         Fc3GLp1HOfgc5mtMmmlC5PkgB+nKVgwaGfSCOIJtgMvG1/1lh/V+eU5AiGUSF3B7uKNn
         ZVgkarhe7n8vIQZccyQIhrUrqb8uSGrAe3U2l6van+juNpoVEGzTUINJqOfZij95K4zn
         LSuFx4x7z6ivQO/lIJuV18iX/vzxfO0jHXCbyt77Zs4NcIPfIQNnZimhJJUrgc07Mxhd
         YJGTdeezFJndvODWFxVFhY46YXDanJ8r2mSIiZzVcoDvVeCfIEt1qi/3aJWP1QWreyrf
         IulA==
X-Gm-Message-State: AOAM531Bo+GhvXcRCN/dB4z2wFYPg9UDFcoZL94D1lbHpAnlG5Tfadj9
        P1b4nW+pgN/zuHzJ8EG7ClDfcUcZZmcfyrjSaDU5rHa5PaCBQ18ZFtuONgqf7SmZvGpkwHLmt22
        QFC26NXab9qvSE1XQDVHblmDFDJfpfdUv
X-Received: by 2002:a05:6e02:1528:: with SMTP id i8mr15303484ilu.312.1639051616672;
        Thu, 09 Dec 2021 04:06:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBSjv/dTRJPDmmWCa9Djh9hqJtcStw0thXIcyyfQtCQHeGlvHZXS8SragPZtGWAKpckef3Jr4gZrGdrvjVE+w=
X-Received: by 2002:a05:6e02:1528:: with SMTP id i8mr15303452ilu.312.1639051616467;
 Thu, 09 Dec 2021 04:06:56 -0800 (PST)
MIME-Version: 1.0
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
In-Reply-To: <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 9 Dec 2021 13:06:45 +0100
Message-ID: <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
Subject: Re: Bad performance in RX with sfc 40G
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Nov 20, 2021 at 9:31 AM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
> If you're testing without the IOMMU enabled I suspect the recycle ring
> size may be too small. Can your try the patch below?

Sorry for the very late reply, but I've had to be out of work for many days=
.

This patch has improved the performance a lot, reaching the same
30Gbps than in TX. However, it seems sometimes a bit erratic, still
dropping to 15Gbps sometimes, specially after module remove & probe,
or from one iperf call to another. But not being all the times, I
didn't found a clear pattern. Anyway, it clearly improves things.

Can this patch be applied as is or it's just a test?

--
=C3=8D=C3=B1igo Huguet

