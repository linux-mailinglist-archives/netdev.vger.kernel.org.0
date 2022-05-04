Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE3851A36E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352036AbiEDPQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352028AbiEDPQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:16:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3124E43ECC
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:13:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j70so1404775pge.1
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 08:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K5o0mxzRhIj/1qVaf+Qsisfgid2WQLM66dSEL7WW688=;
        b=XkqjtCLvOAHdMweJpAE7OFgXj0jWG7id7d0Hhskj9BPIqKJFUoqoOWLf2YUT5xAOL1
         wZmhUNtZAmbQT4d6fpbwfM2QOncu2zNn3djMX16s2PmGSDIstIDxugPIALaO8utyKIj7
         sKwWZedxfPJh4WLIB65ege/77jViBz9SzZ4sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K5o0mxzRhIj/1qVaf+Qsisfgid2WQLM66dSEL7WW688=;
        b=5IJrUnC4HclwBiZTTIqw5AgZmbENx+8PWn3zrBlW7QvKh8FJyOGTZ2n5nat6m6Z5J/
         wvqC1WckEMqaZCpdtwX4DBDzUjIPIXE+L0ZzUK3lwGQN2dhJ42JyKqsxGz5V1bdD9DSp
         AcIKtUI1fwEVgx8QtCTMxk1o74NcrVpBUhYLAVDDMSJSF9pWSHwAkKIJQxBeH0LDmCcG
         J1k+0jINPFWZHQNuqriCGxSkw52mxwJWR5/YyLjJV8J+w5NtROZ+sw9BilcEYeChsgB6
         2H/pY1EViuoIwb/dpfPxChylhBM5ode3sH/ZQz83B1le87lNL0T2G4+1QC44LGrPwncB
         4eLQ==
X-Gm-Message-State: AOAM532VeoM0whcNuGmms+Jn3gb1Vevktt2yhuHqBjsKVQzVx4TUUXDN
        XxEj1eE/co60p1aycqQSDO/R2Q==
X-Google-Smtp-Source: ABdhPJz90TOpMyff1PtQa6IsHmC44gl1STwuqZnossp54kBJNr59JnE6SQEpdVpiz10qBB7q+ENACA==
X-Received: by 2002:a63:9d46:0:b0:3ab:573b:d7ca with SMTP id i67-20020a639d46000000b003ab573bd7camr18269533pgd.349.1651677193254;
        Wed, 04 May 2022 08:13:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902b20100b0015e8d4eb20bsm8443013plr.85.2022.05.04.08.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:13:12 -0700 (PDT)
Date:   Wed, 4 May 2022 08:13:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
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
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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
        linux-usb@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
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
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
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
Subject: Re: [PATCH 12/32] cfg80211: Use mem_to_flex_dup() with struct
 cfg80211_bss_ies
Message-ID: <202205040811.05D7E61@keescook>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-13-keescook@chromium.org>
 <c31c1752cf6393319f5c7abd178ef43e0fbec5c1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c31c1752cf6393319f5c7abd178ef43e0fbec5c1.camel@sipsolutions.net>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 09:28:46AM +0200, Johannes Berg wrote:
> On Tue, 2022-05-03 at 18:44 -0700, Kees Cook wrote:
> > 
> > @@ -2277,7 +2274,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	size_t ielen = len - offsetof(struct ieee80211_mgmt,
> >  				      u.probe_resp.variable);
> >  	size_t new_ie_len;
> > -	struct cfg80211_bss_ies *new_ies;
> > +	struct cfg80211_bss_ies *new_ies = NULL;
> >  	const struct cfg80211_bss_ies *old;
> >  	u8 cpy_len;
> >  
> > @@ -2314,8 +2311,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	if (!new_ie)
> >  		return;
> >  
> > -	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, GFP_ATOMIC);
> > -	if (!new_ies)
> > +	if (mem_to_flex_dup(&new_ies, new_ie, new_ie_len, GFP_ATOMIC))
> >  		goto out_free;
> >  
> >  	pos = new_ie;
> > @@ -2333,10 +2329,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	memcpy(pos, mbssid + cpy_len, ((ie + ielen) - (mbssid + cpy_len)));
> >  
> >  	/* update ie */
> > -	new_ies->len = new_ie_len;
> >  	new_ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
> >  	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
> > -	memcpy(new_ies->data, new_ie, new_ie_len);
> 
> This introduces a bug, "new_ie" is modified between the kzalloc() and
> the memcpy(), but you've moved the memcpy() into the allocation. In
> fact, new_ie is completely freshly kzalloc()'ed at this point. So you
> need to change the ordering here, but since new_ie is freed pretty much
> immediately, we can probably just build the stuff directly inside
> new_ies->data, though then of course we cannot use your helper anymore?

Eek, yes, thanks. My attempt to locate the alloc/memcpy pattern failed
to take into account anything touch the source between alloc and memcpy.
I'll double check the other examples.

-Kees

-- 
Kees Cook
