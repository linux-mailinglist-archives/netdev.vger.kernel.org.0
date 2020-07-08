Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131FE2186F8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgGHMLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbgGHMLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:11:52 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B370DC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:11:51 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id h18so20313894qvl.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8wDv+bWblZ3h9/74Zhd+5yTvEfHXSGMBXEjaVTCeSc=;
        b=fAyUS/S9SA+NftMAPxRUDaPe4snyUJrrE2w0DPFEkxt30reYkRUZb1OHABecjwaF92
         jSE+b0wfwg/qDu0B+L4RAr+TnwwtUgI/LDPWdNdKrE1ZU02d8o0RGtQeqC8fsVWV5ClE
         zqhdTf3pCUJKM8QZauvmAe312K0i5G9vH0sqfEHU2xUizCc0h0ZnK6jySdJ4t9W0tQZT
         28OubqC8zqFFYJ/sWhBo4ndChWVsvzXVQQI1cPrBgD7jZ1S8fcil1B901/Kg1sWJBaNd
         HgKtlCEDx1UI7vR3U5HVE/AWv9o0IW9VG5PGkuvwUB9suxJv1AluIw4uT9X/It5Oa+J9
         wrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8wDv+bWblZ3h9/74Zhd+5yTvEfHXSGMBXEjaVTCeSc=;
        b=QvmZNcXQH0PetC/bTjWuvhJZKRV8a1K2QQaajFyYFpkFO8jc3nBt6Z18AP/rXnmDaW
         INAdo0QJ+sHqpsdU85OWqBGeKNxeb4hVuPI2KhMmCyjewjucL7g3Olgk7TBKe6A+Ck1N
         iCaecqvYOHrWZDscG3/QRY2rkkn4GidE8qolFRzKxIAnUvU8Q7glqrOsQug3g/eBzOZi
         UmE2/OCrsqLSeuyeOv0egTzmMjNMgBnDMvfiwwn4WbHZZ110KIeJbWWKYiQzVTVdtccA
         RLR9SezeJHGiV04w8A8ij8hz4PSlTvBrzmYae17UEOxA3YBC6ECIztq537dfS05iiv5n
         +5eg==
X-Gm-Message-State: AOAM533VY4GRGL0Nu4CH6MMuN+1VycU2SlKaz7L10l4Sp8iGWTpog0zE
        6xjhTO1C62tihnI3U+P4oJclmLL/
X-Google-Smtp-Source: ABdhPJwcqeg12Qij9YZduQddVvpVhpodA7uSNT7GE6+Tc3VE/951ml7jvxJY7bWSIcIlq+4QNfs2xg==
X-Received: by 2002:a0c:f109:: with SMTP id i9mr54008562qvl.154.1594210309794;
        Wed, 08 Jul 2020 05:11:49 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id e129sm27164262qkf.132.2020.07.08.05.11.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:11:48 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id a15so7323384ybs.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:11:48 -0700 (PDT)
X-Received: by 2002:a25:cc4e:: with SMTP id l75mr47249785ybf.165.1594210307842;
 Wed, 08 Jul 2020 05:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com> <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 8 Jul 2020 08:11:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTScYPDhP0NigDgcu+Gpz5GUxttX2htS1NT__pqQOvtsKqw@mail.gmail.com>
Message-ID: <CA+FuTScYPDhP0NigDgcu+Gpz5GUxttX2htS1NT__pqQOvtsKqw@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to NETIF_F_SOFTWARE_GSO
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linuxarm@huawei.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 11:50 PM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>
> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
> a software fallback.  This allows UDP GSO to be used even if
> the hardware does not support it,

That is already the case if just calling UDP_SEGMENT.

It seems the specific goal here is to postpone segmentation when
going through a vxlan device?

> and for virtual device such
> as VxLAN device, this UDP segmentation will be postponed to
> physical device.

See previous commits

commit 83aa025f535f76733e334e3d2a4d8577c8441a7e
Author: Willem de Bruijn <willemb@google.com>
Date:   Thu Apr 26 13:42:21 2018 -0400

    udp: add gso support to virtual devices

    Virtual devices such as tunnels and bonding can handle large packets.
    Only segment packets when reaching a physical or loopback device.

    Signed-off-by: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

and

commit 8eea1ca82be90a7e7a4624ab9cb323574a5f71df
Author: Willem de Bruijn <willemb@google.com>
Date:   Tue May 22 11:34:40 2018 -0400

    gso: limit udp gso to egress-only virtual devices

    Until the udp receive stack supports large packets (UDP GRO), GSO
    packets must not loop from the egress to the ingress path.

    Revert the change that added NETIF_F_GSO_UDP_L4 to various virtual
    devices through NETIF_F_GSO_ENCAP_ALL as this included devices that
    may loop packets, such as veth and macvlan.

    Instead add it to specific devices that forward to another device's
    egress path, bonding and team.

    Fixes: 83aa025f535f ("udp: add gso support to virtual devices")
    CC: Alexander Duyck <alexander.duyck@gmail.com>
    Signed-off-by: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Though with UDP_GRO this specific loop concern is addressed.



> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  include/linux/netdev_features.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 2cc3cf8..c7eef16 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -207,7 +207,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>                                  NETIF_F_FSO)
>
>  /* List of features with software fallbacks. */
> -#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | \
> +#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | NETIF_F_GSO_UDP_L4 | \
>                                  NETIF_F_GSO_SCTP)
>
>  /*
> --
> 2.7.4
>
