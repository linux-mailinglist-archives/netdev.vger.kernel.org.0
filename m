Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9D51B373
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 01:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiEDXWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 19:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383971AbiEDXHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:07:31 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0944E5FF05
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:59:29 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id ay11-20020a05600c1e0b00b0038eb92fa965so4079699wmb.4
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 15:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qfWwXZWPvxEE3w1uLnkzPlrx6nJaZSmQ1gbsC3kCZlI=;
        b=fMehx6+pldeupaypGl5lGMLh8Blc5Pb964suvnwujkOTfmhEds0USznV5iIpAmDMiQ
         3bX5ovLiBcm+P+Qjkm7S30sNoAIneyphU/3HUmg8FgNya3x4Ys+vGWu+B9CwMsbZwixV
         5hhw5d61RXfF0ZuA9a19yWLWnmsownsAlvxGOq/bh+zf+KCchfsYUSjN3DbkCogRNiil
         4sZMBBy0wN3DJWJ3HV3y9RTPrsOy6eZO4wbIVzlw9cfeY3DYzhWrMs9JJuoIK2/rWVPl
         SzHF6XACCrgzPRUtq8fL5afcNflV6Vriy9o5VdAvBNuxRLNvKxX70jkd0hURqNp4X2R8
         1xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qfWwXZWPvxEE3w1uLnkzPlrx6nJaZSmQ1gbsC3kCZlI=;
        b=sRmSIHzahAYW/ArfBm9t36/TfTl68klCOZOWd27L7PzujtUNvLHYo5cNyezTvOmFBz
         mgRTFAQYfXV2rtbKRYQxS7P3I8mHIH80VhRzEN3Q9VLk4gUxvu/ntVUlAsbMSROF4Tuk
         5TpRhRuDbODXKOENBcQY5hn76at1HpbLuvYlHbNu9hNMOdPo7HQmgbG6IpRbC2k3PmLc
         aXowzCec8mMhn8H+6eJlHPR2qpAI7zHW/vzzEwZp9kWCjJPr4syF1/AnCMDctsWqydiA
         UKnC/QP2ft82KqkXlfPb1jYkmBJTG0iXAaFSTpn8xcbei6jMXQjZ3Uu2W0X0gZC6ZYll
         lhfA==
X-Gm-Message-State: AOAM533rW7sFgddECvpYWIquaEja4pOM8jVPv7JaGJQiGr+c+tb+mVAb
        AXj2+xvA3g4HSRPO/g3UfcXn5Exgdb2QX3FSkGiV
X-Google-Smtp-Source: ABdhPJzn8kCki7g2xrksVPCE2X0dMoSQ5GNrlnQWJqU+8a/RnZE5ShgkUyQvDBvdRa4kG7oifCsX28YouBnWU5DkxR0=
X-Received: by 2002:a05:600c:4fc9:b0:394:4317:1aa4 with SMTP id
 o9-20020a05600c4fc900b0039443171aa4mr1477643wmq.179.1651705059031; Wed, 04
 May 2022 15:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014440.3697851-1-keescook@chromium.org> <20220504014440.3697851-29-keescook@chromium.org>
In-Reply-To: <20220504014440.3697851-29-keescook@chromium.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 4 May 2022 18:57:28 -0400
Message-ID: <CAHC9VhT5Y=ENiSyb=S-NVbGX63sLOv4nVuR_GS-yww6tiz0wYA@mail.gmail.com>
Subject: Re: [PATCH 28/32] selinux: Use mem_to_flex_dup() with xfrm and sidtab
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>,
        netdev@vger.kernel.org, selinux@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 9:57 PM Kees Cook <keescook@chromium.org> wrote:
>
> As part of the work to perform bounds checking on all memcpy() uses,
> replace the open-coded a deserialization of bytes out of memory into a
> trailing flexible array by using a flex_array.h helper to perform the
> allocation, bounds checking, and copying:
>
>     struct xfrm_sec_ctx
>     struct sidtab_str_cache
>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Xiu Jianfeng <xiujianfeng@huawei.com>
> Cc: "Christian G=C3=B6ttsche" <cgzones@googlemail.com>
> Cc: netdev@vger.kernel.org
> Cc: selinux@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/uapi/linux/xfrm.h    | 4 ++--
>  security/selinux/ss/sidtab.c | 9 +++------
>  security/selinux/xfrm.c      | 7 ++-----
>  3 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index 65e13a099b1a..4a6fa2beff6a 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -31,9 +31,9 @@ struct xfrm_id {
>  struct xfrm_sec_ctx {
>         __u8    ctx_doi;
>         __u8    ctx_alg;
> -       __u16   ctx_len;
> +       __DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(__u16, ctx_len);
>         __u32   ctx_sid;
> -       char    ctx_str[0];
> +       __DECLARE_FLEX_ARRAY_ELEMENTS(char, ctx_str);
>  };

While I like the idea of this in principle, I'd like to hear about the
testing you've done on these patches.  A previous flex array
conversion in the audit uapi headers ended up causing a problem with
GCC12 and SWIG; while it was a SWIG problem and not a kernel header
problem that was thin consolation for those with broken builds.

> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index a54b8652bfb5..a9d434e8cff7 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -23,8 +23,8 @@ struct sidtab_str_cache {
>         struct rcu_head rcu_member;
>         struct list_head lru_member;
>         struct sidtab_entry *parent;
> -       u32 len;
> -       char str[];
> +       DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u32, len);
> +       DECLARE_FLEX_ARRAY_ELEMENTS(char, str);
>  };
>
>  #define index_to_sid(index) ((index) + SECINITSID_NUM + 1)

--=20
paul-moore.com
