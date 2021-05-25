Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FA1390380
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhEYOJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233799AbhEYOJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621951702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C6JWIrp1X2QWT7DZ7p/eDKEr77BtjgN6Key1F3L5mgM=;
        b=YZed9KBVS/VAiy91UJH98frlnaKnZyTgnXt4V/ezUEiKPwg/s7F41SqmGRAirZpua5MJGU
        CZDt1yzXZ/074nyZgA5eCw0klcg5tVVEGt4llnzORDSTVzy/8EkPtYQPPC3Wm0CMzlENfV
        F5hRscNObifwRqNhb979S2aVyxlqp5Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-TJpM1ahdPo-le9uzgrd9Hw-1; Tue, 25 May 2021 10:08:20 -0400
X-MC-Unique: TJpM1ahdPo-le9uzgrd9Hw-1
Received: by mail-ej1-f71.google.com with SMTP id j16-20020a1709062a10b02903ba544485d0so8857732eje.3
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C6JWIrp1X2QWT7DZ7p/eDKEr77BtjgN6Key1F3L5mgM=;
        b=ncjUTBATpHSZUVRYNXm910O00JlKErfXQjKm01xs9Utd0S0MThLYhi0CBpVTjcli5T
         a289EGYKSlCdlexDewJjWw8ILmpD7M5LMQN+so4XqcvAo8O7PLeNMUtVBvBFaRMwCINH
         UFEccSe+aIK6Of7yN3OCeJ5F8uHD1p0RratN9pJdo2JmRjuzDfqcPSsbJrvhvYZ7PzX6
         bwHnTwRoZMeRdorm5FAnV0HEDiyArmfNpJjS04PKFqd14aUOFEYsm9/NMv6NppbCBPxE
         q6gwkhaIZMoZ81qQC5d29PD4gScItfGMPw4VMmbQL4WSZptiL1Q3ZCPoIJMzkzmM/If5
         0iJQ==
X-Gm-Message-State: AOAM532lwkinO06hQeMbGlOhNBvL/8s234mdqs3G4dEC/5KXeuBzOY/f
        10pN+H1Q6MEhNRdqVg+zUjKCs/5Jlao7Rcl5ISjlVG9OpetP4W6z6q853lOKDwjLG8LxSCCnygs
        7rFRXbQ2w8rdNMMNu
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr29324484ejc.1.1621951699032;
        Tue, 25 May 2021 07:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ8NCBc55GgItfBceAaBuINHwCsxN0ByhZnfYq7Pj5KNr0oNXheshEkj931t4BMHAxbsJicQ==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr29324460ejc.1.1621951698877;
        Tue, 25 May 2021 07:08:18 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id gt12sm9078897ejb.60.2021.05.25.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:08:18 -0700 (PDT)
Date:   Tue, 25 May 2021 16:08:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 04/18] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210525140816.btiv5v6e3vguxxun@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>Add receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there are differences:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>
> include/net/af_vsock.h   |  4 +++
> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 75 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

