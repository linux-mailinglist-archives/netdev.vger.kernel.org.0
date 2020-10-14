Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4E028E451
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbgJNQYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgJNQYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:24:11 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865A3C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:24:11 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id r78so885137vke.11
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2NINvlndmdGIR5PUQW/963ohtoXETcTt0Yp28eLGZk=;
        b=Cw18tgFiwqNWNKOJ0dvWVVXuDC+7fkEjU4ipf10gmd9dk6n6eWhjk7lrDLLW5KwXul
         3aiV4mBQnhOAOTEgsRUvk15tOzDKa5JxITgzK3NDzuhe1+2QbTBjV54lqK2+E/YeWD9G
         7zlQ7UWMIqwRD90uvlARIBQrK1YhT2ga+E34WjjBlKEoI4TZ7FcE8afXDFIpO5EBxS6a
         vGFv3lAJlkt17BuXANgRusHjZewRcfyqav0aVlhl2oonXXkHH5oAeJezFHL/Mkswz7R3
         z7Se4FfxeNDdJaChGoKkToOxXznKKqWG1ztwQoGC2hKzCqCrmxo9HxFLzhoKntuSezeD
         kKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2NINvlndmdGIR5PUQW/963ohtoXETcTt0Yp28eLGZk=;
        b=mar6DSVJrmH2if9CNLG40u0wRBlSDWfnlBnLm3aEyM2toSCg1myUtNLPUOf90YQQA/
         UTef+u0xmSnnCHnz56u5hp74Z/2b1BqQy0tiWNv6eXcsToo2676syHFOmLDE9nGrQFEC
         hFALpdgUrNL/NMq+yX8Ds/PeejzBzfHu49QNzXI+uFoDJeQ9sE8RtiuIkanuWM4FUkFt
         eS6BAcFIWX8TAfokJ9KmaFomOfNTvM+W1gNOqJI3sXxG/YSPsTHCKLs9i6EU4Z2pEnG6
         TZaIdpYHM00Fmr8nUsJlScmlVpO98+20tkbs80wPIf6LHCTSEJ++eURn8ewkUFeQta2v
         yIzA==
X-Gm-Message-State: AOAM530+TeXajrgjDNKVNZlAfBJdcWuPFo9T2RWAFJvVr6S7RkLcAX6e
        +nMJps9oeG6rk7QFrxcfD3oeoBPRfWs=
X-Google-Smtp-Source: ABdhPJxuzzziOaI4JhwuED+pIaMht4ij4MvcQdqfEbiSaYpvRCYtDlFzXKiIvfSPonLUz/s+hzpbnQ==
X-Received: by 2002:a1f:eb02:: with SMTP id j2mr3639560vkh.21.1602692649905;
        Wed, 14 Oct 2020 09:24:09 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id k10sm702984vsp.23.2020.10.14.09.24.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 09:24:09 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id p25so2423711vsq.4
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:24:08 -0700 (PDT)
X-Received: by 2002:a05:6102:398:: with SMTP id m24mr4004838vsq.14.1602692648272;
 Wed, 14 Oct 2020 09:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201013232014.26044-1-dwilder@us.ibm.com> <20201013232014.26044-3-dwilder@us.ibm.com>
In-Reply-To: <20201013232014.26044-3-dwilder@us.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 14 Oct 2020 12:23:31 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfRXhJWOerKL=4OV=ku6v3XfqhBhV0=rtiAfaPgr=yq4w@mail.gmail.com>
Message-ID: <CA+FuTSfRXhJWOerKL=4OV=ku6v3XfqhBhV0=rtiAfaPgr=yq4w@mail.gmail.com>
Subject: Re: [ PATCH v2 2/2] ibmveth: Identify ingress large send packets.
To:     David Wilder <dwilder@us.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 7:21 PM David Wilder <dwilder@us.ibm.com> wrote:
>
> Ingress large send packets are identified by either:
> The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
> or with a -1 placed in the ip header checksum.
> The method used depends on firmware version. Frame
> geometry and sufficient header validation is performed by the
> hypervisor eliminating the need for further header checks here.
>
> Fixes: 7b5967389f5a ("ibmveth: set correct gso_size and gso_type")
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
> Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for clarifying the header validation. I clearly had missed that :)
