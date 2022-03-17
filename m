Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4B4DC1D6
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiCQIu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiCQIu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FFFCBF97A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647506948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gz/W/pn91Pd0cp+FBSUWrFfqAy7FqwqHAAG9hudoc3k=;
        b=eISSKLK8qX9wW9FtaYNMLuj6nnnMb/4AEkKTzPb8Qg6sShy7zaL4LLm0EcEroZkdgT3QVH
        f9hxztUtpO3GoWSvK9matt6QrbpxHysLN7ZFzb9g1pViJMjq2omd78LJWr4jCGtUb/ys6a
        +MKEGZzmbL5GZ720KhxnhPIqY2QSQ/M=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-0g-oFr2QMoOvoTVm4Uda6w-1; Thu, 17 Mar 2022 04:49:07 -0400
X-MC-Unique: 0g-oFr2QMoOvoTVm4Uda6w-1
Received: by mail-qv1-f69.google.com with SMTP id o1-20020a0c9001000000b00440e415a3a2so1198368qvo.13
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gz/W/pn91Pd0cp+FBSUWrFfqAy7FqwqHAAG9hudoc3k=;
        b=uEd5m4Zkl+vkVKR24vVk8MSfCgREesgybTIxuDNUQ1c4NuWBNCq8ttehUlWzf4+2VP
         AK/4WHX9hb5wKVIkZKqhMkyQ0kiB/81p0a6wnKC2ChyfojmAsDNiUhVAkMWexyL4vVYw
         i2zT0ZWMIdKLDXgTmB+9pFbQyuFb0OgCry4quAKS45hrtzvFcdBldv7KPTySURIzHDwA
         gzYIrBFpyiLzMG7UZPzsLpAXidnxaV1I1T8nsmoryBBa5ppgrFvc61RQaUTX6SiSUJEN
         rtRcQiJHaaRD2GiO1wUs8lVH0rkTM6eNMy0YmR7kaZwTcD7Ww8W4zCBFFHKwMRgR22gk
         EIIA==
X-Gm-Message-State: AOAM530g2PJm52h8L9r33dLQ6Wbpp6Mg5+u9foW+qwwlwRVbiIxltHef
        DE99Luv8suw7SQwI960GvquTKBEZxWw3vz6I5jkM37vtXay6a/a/8ig7pq4gd12f3KQrNYH7qUp
        s3CJl4zTsdPsa/8Zl
X-Received: by 2002:a05:6214:20ac:b0:435:bc08:3fee with SMTP id 12-20020a05621420ac00b00435bc083feemr2637719qvd.62.1647506946709;
        Thu, 17 Mar 2022 01:49:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfxE61qldB187jrMNs+6ZiPIrvfd4dvExZrtE1N5vj69apnHkdN+sVPDMzutJ+kVJuhUJMSA==
X-Received: by 2002:a05:6214:20ac:b0:435:bc08:3fee with SMTP id 12-20020a05621420ac00b00435bc083feemr2637709qvd.62.1647506946520;
        Thu, 17 Mar 2022 01:49:06 -0700 (PDT)
Received: from sgarzare-redhat (host-79-42-202-12.retail.telecomitalia.it. [79.42.202.12])
        by smtp.gmail.com with ESMTPSA id s64-20020a375e43000000b0067b0e68092csm2249499qkb.91.2022.03.17.01.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:49:05 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:49:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Message-ID: <20220317084900.e5nxahx4ize2wfcj@sgarzare-redhat>
References: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
 <3cf108a3-e57f-abf8-e82f-6d6e80c4a37a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3cf108a3-e57f-abf8-e82f-6d6e80c4a37a@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 08:31:49AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Test for receive timeout check: connection is established,
>receiver sets timeout, but sender does nothing. Receiver's
>'read()' call must return EAGAIN.
>
>Signed-off-by: Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
>---
> v3 -> v4:
> 1) Fix stupid bug about invalid 'if()' line.
>
> tools/testing/vsock/vsock_test.c | 84 ++++++++++++++++++++++++++++++++
> 1 file changed, 84 insertions(+)

Everything is okay now, tests pass and the patch looks good to me:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

