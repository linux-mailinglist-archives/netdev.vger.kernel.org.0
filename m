Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14589526670
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382187AbiEMPop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382189AbiEMPol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:44:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FE73A735
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:44:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso8108383pjb.5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptf+f5eGDE5JGEu9b++jcke6m+bu7vV+b5hUvmlYQQo=;
        b=SjhK1c9Qotr1qDOqwKlBj3Rw1mlIdcXMiMnONLsDWXIlWQego7JtnDd+2u8lNhcb5o
         VntS/+cGhwP5NiXqFa0xo4Eurcd+QW1c6ntV0GvlsEyq5axRcQY1ctFnycyCWVGns4We
         RoLfLtxqMSNKYzeck8DbrFFmqTXggtzGcj49k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptf+f5eGDE5JGEu9b++jcke6m+bu7vV+b5hUvmlYQQo=;
        b=4RPR8/biVOolojE5FLM2M85T9yy8E7O3PAuazoNmgGv39bDgzaCKIE88QWZjZR8xLI
         qOFLStmYoGzygBhEebcUqoj3r6PA7tzpGvMDcguUHGH8YnNBE90FHT6jDgZbqa9kyoAp
         Bzh0U5HRMBJ7lt4aoQoqg+1OwIbZralyXYWJkQ5R/ZT0lGC9je1jHL1O9VRoCudNp2ms
         aPUN/yehTEDp/Mm3hg5WAqYb6bQIUH4cPf1aiNI1oqhFGabMF35EYIHaqYVaJ2SOmFy6
         JUinlT1uLsTmJ+h8rmaxsuCa8gD8erLghEy5rIO/SlfL2XeSih8KQJEuGHMpvS2dfRJz
         9obQ==
X-Gm-Message-State: AOAM532rzVwjTYjwO1ul0hUBM4D+TsndJ6/VZTIY1eXHLOaoBxNzuoxy
        k6WH0OZSkUbZmY7X3wUeG21jtA==
X-Google-Smtp-Source: ABdhPJxasBICZO798rz+17+y+t9nZitCCqENVQI5RwTabPKWbsVJ7C2OmZDJ+yTA2ILgpXFaCw37jw==
X-Received: by 2002:a17:902:ecc8:b0:15e:9e46:cb7e with SMTP id a8-20020a170902ecc800b0015e9e46cb7emr5389423plh.111.1652456677896;
        Fri, 13 May 2022 08:44:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b0015e8d4eb1c9sm2059662plb.19.2022.05.13.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:44:37 -0700 (PDT)
Date:   Fri, 13 May 2022 08:44:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Howells <dhowells@redhat.com>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
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
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
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
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 19/32] afs: Use mem_to_flex_dup() with struct afs_acl
Message-ID: <202205130841.686F21B64@keescook>
References: <20220504014440.3697851-20-keescook@chromium.org>
 <20220504014440.3697851-1-keescook@chromium.org>
 <898803.1652391665@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <898803.1652391665@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:41:05PM +0100, David Howells wrote:
> 
> Kees Cook <keescook@chromium.org> wrote:
> 
> >  struct afs_acl {
> > -	u32	size;
> > -	u8	data[];
> > +	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u32, size);
> > +	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
> >  };
> 
> Oof...  That's really quite unpleasant syntax.  Is it not possible to have
> mem_to_flex_dup() and friends work without that?  You are telling them the
> fields they have to fill in.

Other threads discussed this too. I'm hoping to have something more
flexible (pardon the pun) in v2.

> [...]
> or:
> 
> 	ret = mem_to_flex_dup(&acl, buffer, size, GFP_KERNEL);
> 	if (ret < 0)
> 
> (or use != 0 rather than < 0)

Sure, I can make the tests more explicit. The kerndoc, etc all shows it's
using < 0 for errors.

-- 
Kees Cook
