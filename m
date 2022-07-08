Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D1A56C2F8
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbiGHTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 15:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiGHTQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 15:16:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C304E4507A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 12:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657307810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+E5Uxc1L6lY8x0Xu20nKw3rP9x1iQMo5WfF11E2oEw=;
        b=asVp6543y2DeotKkJtVE9ugvnf8GkNsTXY7lxehgEWNL/INtsUgC15pjAeUa+trVUQl6bg
        UAKXZXGOSJ1VRIuK7hPsfVp61lEh3OEzzytf97cnqYl2AG52WB170EscZLfxhP6j0wVArW
        dROcTMYhlK4/9Iy/IzrhR3BMvUX+pM0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-6z8ZS1kRMgyg5Nv1TFNQ9g-1; Fri, 08 Jul 2022 15:16:49 -0400
X-MC-Unique: 6z8ZS1kRMgyg5Nv1TFNQ9g-1
Received: by mail-qt1-f198.google.com with SMTP id bs7-20020ac86f07000000b0031d3efbb91aso18314902qtb.21
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 12:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=q+E5Uxc1L6lY8x0Xu20nKw3rP9x1iQMo5WfF11E2oEw=;
        b=Jk5tN6qzOY2jCE9skGDfn4737Iqwb0CiXNLcVTvozuO2KaViDuPJ+NyDe65xj0l6Qh
         itvguhPoPAJU8qXeDUleQ9EHghM9pMdnFGNUXRP7M33tL27HKVCbvSzI935Vv9GyFQHH
         Wn6HPki93grqDJtfStsgqdAKFzCcIZgMXrSsJsWFIE/5t5HWXBsNT/Fqc//rmLJasJOA
         pW/Yfgynm7Fm15i9T5ZomgxNz7E0VkTQHhPdvYInT8ba9KlqDWYrXubBB9m/d2NegYdH
         iehtSXiGRjui5Q3mN/HfFF2+khR9OhxJHipeOnXyB14KQghVRAt8auH1d9sqj3cGW6hD
         vvUA==
X-Gm-Message-State: AJIora+FZ2/5lG7XLNXBDV4/Ehj5UfDQdMcn4iBUw1JC1ujUFbZCom8y
        TKiC9U8OS+hU4e2BbAFABTe+XSVhoqn6l7/RznbOaH0qTEm1tWCdNlJr5EeqlCkan4uV6tCbWFL
        6YeC92PYtaUZGN6DQ
X-Received: by 2002:a05:620a:d54:b0:6b2:5a9b:ef2e with SMTP id o20-20020a05620a0d5400b006b25a9bef2emr3503360qkl.715.1657307809129;
        Fri, 08 Jul 2022 12:16:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vlPO7bIup7NI64TA0vi+uk6M4ZJZb5w0BEQ0gp7V0aT/fIJeYl2XMp80DsYKvhK90F7DLtHg==
X-Received: by 2002:a05:620a:d54:b0:6b2:5a9b:ef2e with SMTP id o20-20020a05620a0d5400b006b25a9bef2emr3503336qkl.715.1657307808806;
        Fri, 08 Jul 2022 12:16:48 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id u19-20020a37ab13000000b006b56a4400f6sm1101878qke.16.2022.07.08.12.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:16:48 -0700 (PDT)
Message-ID: <60ee503b9cd5c0d2963070184eb246df22aa716b.camel@redhat.com>
Subject: Re: [PATCH v3 12/32] NFSD: Hook up the filecache stat file
From:   Jeff Layton <jlayton@redhat.com>
To:     Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 15:16:47 -0400
In-Reply-To: <165730469820.28142.10369457240055089259.stgit@klimt.1015granger.net>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
         <165730469820.28142.10369457240055089259.stgit@klimt.1015granger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-08 at 14:24 -0400, Chuck Lever wrote:
> There has always been the capability of exporting filecache metrics
> via /proc, but it was never hooked up. Let's surface these metrics
> to enable better observability of the filecache.
>=20
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/nfsd/nfsctl.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index 66c352bf61b1..ecc08cf97a86 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -25,6 +25,7 @@
>  #include "state.h"
>  #include "netns.h"
>  #include "pnfs.h"
> +#include "filecache.h"
> =20
>  /*
>   *	We have a single directory with several nodes in it.
> @@ -46,6 +47,7 @@ enum {
>  	NFSD_MaxBlkSize,
>  	NFSD_MaxConnections,
>  	NFSD_SupportedEnctypes,
> +	NFSD_Filecache,
>  	/*
>  	 * The below MUST come last.  Otherwise we leave a hole in nfsd_files[]
>  	 * with !CONFIG_NFSD_V4 and simple_fill_super() goes oops
> @@ -229,6 +231,13 @@ static const struct file_operations reply_cache_stat=
s_operations =3D {
>  	.release	=3D single_release,
>  };
> =20
> +static const struct file_operations filecache_ops =3D {
> +	.open		=3D nfsd_file_cache_stats_open,
> +	.read		=3D seq_read,
> +	.llseek		=3D seq_lseek,
> +	.release	=3D single_release,
> +};
> +
>  /*----------------------------------------------------------------------=
------*/
>  /*
>   * payload - write methods
> @@ -1370,6 +1379,7 @@ static int nfsd_fill_super(struct super_block *sb, =
struct fs_context *fc)
>  		[NFSD_Ports] =3D {"portlist", &transaction_ops, S_IWUSR|S_IRUGO},
>  		[NFSD_MaxBlkSize] =3D {"max_block_size", &transaction_ops, S_IWUSR|S_I=
RUGO},
>  		[NFSD_MaxConnections] =3D {"max_connections", &transaction_ops, S_IWUS=
R|S_IRUGO},
> +		[NFSD_Filecache] =3D {"filecache", &filecache_ops, S_IRUGO},
>  #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
>  		[NFSD_SupportedEnctypes] =3D {"supported_krb5_enctypes", &supported_en=
ctypes_ops, S_IRUGO},
>  #endif /* CONFIG_SUNRPC_GSS or CONFIG_SUNRPC_GSS_MODULE */
>=20
>=20

<facepalm>
Ouch, that's quite an oversight.
</facepalm>

--=20
Jeff Layton <jlayton@redhat.com>

