Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0890A51CC94
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386658AbiEEXUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386631AbiEEXUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:20:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4728460070
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:16:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d5so7891065wrb.6
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 16:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNb5FwciOrnmYbDhJp90kHEHFZ0681UtkEHiY9rBD84=;
        b=Ohr3X3EP78LxuYDKhnz8KuPiuz1PhY8VlacN2n0UZF33p11lrzHmoTg5FkuLveaWWc
         B+PHWzpGocOw99rYrrwOT2j6K7yl6TZjHfwiwfQv58T2SgC8RJjpZCrBvbUHRa3tAEjw
         vBvW2uixSk3X4wocsWWICUIdWEyFIPpXBQF7km3BjP4lO/AiOmnrqBvYof/Hmrk8g3Ui
         VsyTbQQECGTWGpH9GRnc/7V1pdbEyCgAuGzq4iO4E+9FajCsxUmBzSMnYaru+xQE/MDx
         VovhSYGTu5JLsFhCQL0rb2sLJwJC/ZTQ8Ao2n8UXvDJkacdd5/9qZgjSKryNtgTW6CEs
         aKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNb5FwciOrnmYbDhJp90kHEHFZ0681UtkEHiY9rBD84=;
        b=v+Xk9O8C3AWU/iM47QI4+WhdQ2XIJWe/Kx0MwfYDyCPvglpdWCuEdj5jxlmO6YztDm
         qoHixszj1OSOB2A0m4+C5Lyn2439w70lnkBW4szn4u99ajWpi0z2BMIb1EGmzqS99LsJ
         pP++3TeMqcxI9QD3x6aG4z3hi7MJ6x7OXKJJwEtsscpt/HOLDBPCXiJFaK8a+LNxCcp7
         K53Ww9OWqmemKVD99/3RsUZdHqodI8n5IEGHmtBBo/VTMWyCGsctWyPmqxmRG1W+75eq
         D0X4XzEVpMP+E4UTOPwy7QpoBZH1O/+ET1DtzX7HOb9aCvoOoV7/baQpjzld7FKGmzzi
         z+Jw==
X-Gm-Message-State: AOAM531cJ6H2osxJ1iMt+5Bt8Yy+iMYqDL+bzbtD3o/19PI0g6Ke/1NI
        FnTgxYG2OVDjbj3KhQ22pCXgQtpI4R/oPL5+yTcZ
X-Google-Smtp-Source: ABdhPJyI6zIzqRKP45wkz/HSJ9ebgV2/QaH+Jh5XG21YfFQB+clnUfHaAanM4WnjOyZZ77zPKKT04iIWWkNblva8IBo=
X-Received: by 2002:a5d:590d:0:b0:20a:c3eb:2584 with SMTP id
 v13-20020a5d590d000000b0020ac3eb2584mr325652wrd.18.1651792589559; Thu, 05 May
 2022 16:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-29-keescook@chromium.org> <CAHC9VhT5Y=ENiSyb=S-NVbGX63sLOv4nVuR_GS-yww6tiz0wYA@mail.gmail.com>
 <20220504234324.GA12556@embeddedor> <CAHC9VhRJC4AxeDsGpdphfJD4WzgaeBsdONHnixBzft5u_cE-Dw@mail.gmail.com>
 <202205051124.6D80ABAE32@keescook>
In-Reply-To: <202205051124.6D80ABAE32@keescook>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 5 May 2022 19:16:18 -0400
Message-ID: <CAHC9VhT3EDCZEP1og3H_PGFETE6403HUHw7aQb_wDMwJnWeb3Q@mail.gmail.com>
Subject: Re: [PATCH 28/32] selinux: Use mem_to_flex_dup() with xfrm and sidtab
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 2:39 PM Kees Cook <keescook@chromium.org> wrote:
> On Wed, May 04, 2022 at 11:14:42PM -0400, Paul Moore wrote:
> > On Wed, May 4, 2022 at 7:34 PM Gustavo A. R. Silva
> > <gustavoars@kernel.org> wrote:
> > >
> > > Hi Paul,
> > >
> > > On Wed, May 04, 2022 at 06:57:28PM -0400, Paul Moore wrote:
> > > > On Tue, May 3, 2022 at 9:57 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > [..]
> > >
> > > > > +++ b/include/uapi/linux/xfrm.h
> > > > > @@ -31,9 +31,9 @@ struct xfrm_id {
> > > > >  struct xfrm_sec_ctx {
> > > > >         __u8    ctx_doi;
> > > > >         __u8    ctx_alg;
> > > > > -       __u16   ctx_len;
> > > > > +       __DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(__u16, ctx_len);
> > > > >         __u32   ctx_sid;
> > > > > -       char    ctx_str[0];
> > > > > +       __DECLARE_FLEX_ARRAY_ELEMENTS(char, ctx_str);
> > > > >  };
> > > >
> > > > While I like the idea of this in principle, I'd like to hear about the
> > > > testing you've done on these patches.  A previous flex array
> > > > conversion in the audit uapi headers ended up causing a problem with
> > >
> > > I'm curious about which commit caused those problems...?
> >
> > Commit ed98ea2128b6 ("audit: replace zero-length array with
> > flexible-array member"), however, as I said earlier, the problem was
> > actually with SWIG, it just happened to be triggered by the kernel
> > commit.  There was a brief fedora-devel mail thread about the problem,
> > see the link below:
> >
> > * https://www.spinics.net/lists/fedora-devel/msg297991.html
>
> Wow, that's pretty weird -- it looks like SWIG was scraping the headers
> to build its conversions? I assume SWIG has been fixed now?

I honestly don't know, the audit userspace was hacking around it with
some header file duplication/munging last I heard, but I try to avoid
having to touch Steve's audit userspace code.

> > To reiterate, I'm supportive of changes like this, but I would like to
> > hear how it was tested to ensure there are no unexpected problems with
> > userspace.  If there are userspace problems it doesn't mean we can't
> > make changes like this, it just means we need to ensure that the
> > userspace issues are resolved first.
>
> Well, as this is the first and only report of any problems with [0] -> []
> conversions (in UAPI or anywhere) that I remember seeing, and they've
> been underway since at least v5.9, I hadn't been doing any new testing.

... and for whatever it is worth, I wasn't expecting it to be a
problem either.  Surprise :)

> So, for this case, I guess I should ask what tests you think would be
> meaningful here? Anything using #include should be fine:
> https://codesearch.debian.net/search?q=linux%2Fxfrm.h&literal=1&perpkg=1
> Which leaves just this, which may be doing something weird:
>
> libabigail_2.0-1/tests/data/test-diff-filter/test-PR27569-v0.abi
>         </data-member>
>         <data-member access="public" layout-offset-in-bits="128">
>           <var-decl name="seq_hi" type-id="3f1a6b60" visibility="default" filepath="include/uapi/linux/xfrm.h" line="97" column="1"/>
>         </data-member>
>         <data-member access="public" layout-offset-in-bits="160">
>
> But I see that SWIG doesn't show up in a search for linux/audit.h:
> https://codesearch.debian.net/search?q=linux%2Faudit.h&literal=1&perpkg=1
>
> So this may not be a sufficient analysis...

I think from a practical perspective ensuring that the major IPsec/IKE
tools, e.g. the various *SWANs, that know about labeled IPSec still
build and can set/get the SA/SPD labels correctly would be sufficient.
I seriously doubt there would be any problems, but who knows.

-- 
paul-moore.com
