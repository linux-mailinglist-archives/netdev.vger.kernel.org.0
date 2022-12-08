Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505B36478FA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLHWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiLHWkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:40:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13210B43
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670539159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aOy7fSBce5nodIDIVe0jCC3B4r5Wf3j3XgDgyttb5Q8=;
        b=IDYd/Z+MeDtkBBrLZ+lApyUe4vqYp9qDSgvAscG3ko1v6GtTLSfqLR2KiPRRzRzNQ2bzBU
        gfYwOZUYdHDzSMZXfhZRYHNPTQppmKOXdtxEQ1oMueQVGohd58eUy5hVv/JrbQ7j5HO6V2
        QKmuuBFhDnhMgnUbk/YJZECm+dxUdVo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-VbdfZdAlP7qDBN4gA4BLlw-1; Thu, 08 Dec 2022 17:39:18 -0500
X-MC-Unique: VbdfZdAlP7qDBN4gA4BLlw-1
Received: by mail-ed1-f70.google.com with SMTP id f17-20020a056402355100b00466481256f6so290853edd.19
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 14:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOy7fSBce5nodIDIVe0jCC3B4r5Wf3j3XgDgyttb5Q8=;
        b=4Cy0OgA9RJRhr/oKTobdTr0lJSp157F9Pnc6pCcRpycmA2lSigpbNWqWd839+JyNTi
         qjPe4nL+Bv2Rbz3Pn2Xqc6MLZExIFZ4c2QoEHoAElBVrD5Bu6ceF/WyA0WMex8cR+RcK
         FKeFtPvTYe/5sBB7cHajMxBN0mXZ/TJPGFweJkEgX57cpsXhShEZVoGFsuFZcrzru1sI
         GuI15JiAnLN3dy6MdRvzCnfwCKIopc+TcFvH2LuJK253yuYQF/DTTV5LWO01hdslK1XV
         KkNt+ZLTiOcNAyi6TuuUsjUbFMY6jB8A77G5/STyw46uFQLiTViCciQx+t33l/n7OeP7
         C0IQ==
X-Gm-Message-State: ANoB5pkF/BE8MoWxf5gwZVw9FiqrSMbShH3By+7F7pcz39fXBMrCrBl1
        vDqtqf0/V/fN+OFaE+F3RUmcsIrFsfWeaZnM1htOU/H6VMW1sRibdKGOtSKgnx/6ktmlz05o27R
        ae7aGRzmcqX2mPyVZ
X-Received: by 2002:a17:906:a0cc:b0:7ad:b791:6e37 with SMTP id bh12-20020a170906a0cc00b007adb7916e37mr4194430ejb.35.1670539157359;
        Thu, 08 Dec 2022 14:39:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6yFBSOtrmQ80Neu9IqpOzleiVZhN0g3CAz+oJheiDaOro3KDYQaLxqHHfr8ChP9Mm4xX+aqA==
X-Received: by 2002:a17:906:a0cc:b0:7ad:b791:6e37 with SMTP id bh12-20020a170906a0cc00b007adb7916e37mr4194398ejb.35.1670539156998;
        Thu, 08 Dec 2022 14:39:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ga18-20020a170906b85200b00781be3e7badsm10178470ejb.53.2022.12.08.14.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:39:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1836E82E9A4; Thu,  8 Dec 2022 23:39:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
In-Reply-To: <20221206024554.3826186-4-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Dec 2022 23:39:15 +0100
Message-ID: <878rjhldv0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> There is an ndo handler per kfunc, the verifier replaces a call to the
> generic kfunc with a call to the per-device one.
>
> For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> implements all possible metatada kfuncs. Not all devices have to
> implement them. If kfunc is not supported by the target device,
> the default implementation is called instead.

So one unfortunate consequence of this "fallback to the default
implementation" is that it's really easy to get a step wrong and end up
with something that doesn't work. Specifically, if you load an XDP
program that calls the metadata kfuncs, but don't set the ifindex and
flag on load, the kfunc resolution will work just fine, but you'll end
up calling the default kfunc implementations (and get no data). I ran
into this multiple times just now when playing around with it and
implementing the freplace support.

So I really think it would be a better user experience if we completely
block (with a nice error message!) the calling of the metadata kfuncs if
the program is not device-bound...

Another UX thing I ran into is that libbpf will bail out if it can't
find the kfunc in the kernel vmlinux, even if the code calling the
function is behind an always-false if statement (which would be
eliminated as dead code from the verifier). This makes it a bit hard to
conditionally use them. Should libbpf just allow the load without
performing the relocation (and let the verifier worry about it), or
should we have a bpf_core_kfunc_exists() macro to use for checking?
Maybe both?

> Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> we treat prog_index as target device for kfunc resolution.

[...]

> -	if (!bpf_prog_map_compatible(map, prog)) {
> -		bpf_prog_put(prog);
> -		return ERR_PTR(-EINVAL);
> -	}
> +	/* When tail-calling from a non-dev-bound program to a dev-bound one,
> +	 * XDP metadata helpers should be disabled. Until it's implemented,
> +	 * prohibit adding dev-bound programs to tail-call maps.
> +	 */
> +	if (bpf_prog_is_dev_bound(prog->aux))
> +		goto err;
> +
> +	if (!bpf_prog_map_compatible(map, prog))
> +		goto err;

I think it's better to move the new check into bpf_prog_map_compatible()
itself; that way it'll cover cpumaps and devmaps as well :)

-Toke

