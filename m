Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6980E51A438
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352634AbiEDPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352587AbiEDPly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:41:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B6F17A85
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:38:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so1480457pga.0
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KqAJb/V6gfBBDG6bSPIb4vESmdq1P/sKe2F177CTgUM=;
        b=fQrMYNAIqMyggez1Cxk6MO5ffmDcMsHa95ZyVgeB+XLocHYSpcdXLdDMIvfhtVHebJ
         c6KLuD9O1zHpfXOArUQ9i6OPKZN0wLEdS36xK8UGnJ7GhAZoY1ZaUI/INEIjt/aYGDme
         7yPqIKR/2ePc228VdQYx3R6Gd7ox0JMkE5pTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KqAJb/V6gfBBDG6bSPIb4vESmdq1P/sKe2F177CTgUM=;
        b=NvAfelcj7OrnvlcAozG+B2yoSX1nkier5i+/e8+0jl8F9SxdPXTkNFujPXLzfAtw2N
         6/M+E9XOClsvCvIDpfLwVf31USKpaHETwoNCSjog40omgWxr5hxk4LFPqPQEDN3fE8yX
         NTLjf1/a7wWc/pa95arTNM8zEMTfAGBbFUA3wsuMQV04d/M2VYYEoYLQgsxJKWy3IwFD
         /JQ35X9oa3nOzamlEvxvsCv3QD2i117dhJBnnxcw76G58fn+evikfQzHi6Rou63uNwHC
         CrOK/+trPiTh7vGrc8MNthhruhLcoH4OumgJSIzLjOh9rtYKbTBSxVclg/UZx0OK2T6q
         vPWQ==
X-Gm-Message-State: AOAM530MRk+rZB7Uhxwe0GwN9ZjluGjr6P3KWtYdHJhwsQ4iJbq0RkF7
        TpA13MqyFUyl3Yk39qr0/M9u4Q==
X-Google-Smtp-Source: ABdhPJzzQnECj6TQ/WMnbIXyOhNDieYzy1koe+Zij9CEDYVoBr0fSGu6X0G/3k8EfFivormHMckX3w==
X-Received: by 2002:a63:6b82:0:b0:39d:a6ce:14dc with SMTP id g124-20020a636b82000000b0039da6ce14dcmr8170661pgc.476.1651678695154;
        Wed, 04 May 2022 08:38:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t4-20020a170902bc4400b0015e8d4eb1f9sm8430240plz.67.2022.05.04.08.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:38:14 -0700 (PDT)
Date:   Wed, 4 May 2022 08:38:13 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
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
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
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
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        keyrings@vger.kernel.org, kunit-dev@googlegroups.com,
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
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Message-ID: <202205040819.DEA70BD@keescook>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-3-keescook@chromium.org>
 <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 09:25:56AM +0200, Johannes Berg wrote:
> On Tue, 2022-05-03 at 18:44 -0700, Kees Cook wrote:
> > 
> > For example, using the most complicated helper, mem_to_flex_dup():
> > 
> >     /* Flexible array struct with members identified. */
> >     struct something {
> >         int mode;
> >         DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, how_many);
> >         unsigned long flags;
> >         DECLARE_FLEX_ARRAY_ELEMENTS(u32, value);
> 
> In many cases, the order of the elements doesn't really matter, so maybe
> it'd be nicer to be able to write it as something like
> 
> DECLARE_FLEX_STRUCT(something,
> 	int mode;
> 	unsigned long flags;
> 	,
> 	int, how_many,
> 	u32, value);
> 
> perhaps? OK, that doesn't seem so nice either.
> 
> Maybe
> 
> struct something {
> 	int mode;
> 	unsigned long flags;
> 	FLEX_ARRAY(
> 		int, how_many,
> 		u32, value
> 	);
> };

Yeah, I mention some of my exploration of this idea in the sibling reply:
https://lore.kernel.org/linux-hardening/202205040730.161645EC@keescook/#t

It seemed like requiring a structure be rearranged to take advantage of
the "automatic layout introspection" wasn't very friendly. On the other
hand, looking at the examples, most of them are already neighboring
members. Hmmm.

> or so? The long and duplicated DECLARE_FLEX_ARRAY_ELEMENTS_COUNT and
> DECLARE_FLEX_ARRAY_ELEMENTS seems a bit tedious to me, at least in cases
> where the struct layout is not the most important thing (or it's already
> at the end anyway).

The names aren't great, but I wanted to distinguish "elements" as the
array not the count. Yay naming.

However, perhaps the solution is to have _both_. i.e using
BOUNDED_FLEX_ARRAY(count_type, count_name, array_type, array_name) for
the "neighboring" case, and the DECLARE...{ELEMENTS,COUNT} for the
"split" case.

And DECLARE_FLEX_ARRAY_ELEMENTS could actually be expanded to include
the count_name too, so both methods could be "forward portable" to a
future where C grew the syntax for bounded flex arrays.

> 
> >     struct something *instance = NULL;
> >     int rc;
> > 
> >     rc = mem_to_flex_dup(&instance, byte_array, count, GFP_KERNEL);
> >     if (rc)
> >         return rc;
> 
> This seems rather awkward, having to set it to NULL, then checking rc
> (and possibly needing a separate variable for it), etc.

I think the errno return is completely required. I had an earlier version
of this that was much more like a drop-in replacement for memcpy that
would just truncate or panic, and when I had it all together, I could
just imagine hearing Linus telling me to start over because it was unsafe
(truncation may be just as bad as overflow) and disruptive ("never BUG"),
and that it should be recoverable. So, I rewrote it all to return a
__must_check errno.

Requiring instance to be NULL is debatable, but I feel pretty strongly
about it because it does handle a class of mistakes (resource leaks),
and it's not much of a burden to require a known-good starting state.

> But I can understand how you arrived at this:
>  - need to pass instance or &instance or such for typeof()
>    or offsetof() or such

Right.

>  - instance = mem_to_flex_dup(instance, ...)
>    looks too much like it would actually dup 'instance', rather than
>    'byte_array'

And I need an errno output to keep imaginary Linus happy. :)

>  - if you pass &instance anyway, checking for NULL is simple and adds a
>    bit of safety

Right.

> but still, honestly, I don't like it. As APIs go, it feels a bit
> cumbersome and awkward to use, and you really need everyone to use this,
> and not say "uh what, I'll memcpy() instead".

Sure, and I have tried to get it down as small as possible. The earlier
"just put all the member names in every call" version was horrid. :P I
realize it's more work to check errno, but the memcpy() API we've all
been trained to use is just plain dangerous. I don't think it's
unreasonable to ask people to retrain themselves to avoid it. All that
said, yes, I want it to be as friendly as possible.

> Maybe there should also be a realloc() version of it?

Sure! Seems reasonable. I'd like to see the code pattern for this
though. Do you have any examples? Most of what I'd been able to find for
the fragile memcpy() usage was just basic serialize/deserialize or
direct copying.

> > +/** __fas_bytes - Calculate potential size of flexible array structure
> 
> I think you forgot "\n *" in many cases here after "/**".

Oops! Yes, thank you. I'll fix these.

-Kees

-- 
Kees Cook
