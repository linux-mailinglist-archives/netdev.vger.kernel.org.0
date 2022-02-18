Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521124BC289
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 23:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240112AbiBRWUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 17:20:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240110AbiBRWUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 17:20:37 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E69F1B6BD4;
        Fri, 18 Feb 2022 14:20:20 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w37so2630321pga.7;
        Fri, 18 Feb 2022 14:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=spKeknQ9pe+LaczsQGMgqzOrOzdIo9JsxnZq6u+F2ec=;
        b=L9Fv5ju1Wux73eHYSQheruU0VK34UnKCcL698tNEUV4d1mjQSe0z7iEfwjBDOgcIxl
         h70PkScsrdK+ffrZ5V9W6CY+akredDx5gHwo6O4hAa4Sg/WMtAN4+xu/XYevdCVyFJDR
         p9Kxu8VfX3PVq8KgDUVfanzVWRSxLymuBBF5Pzb3EOVU2eJ96YJTNWef+tsgmCtzh6DX
         hsQ1aHVIwpiZ94h+sRFySJLD9e/ZlkY9iiVxMQ6Ry01krc2eRR3xF2i2iGBGCD+ERU5+
         boFzY6hjau2fFMzZmjLlxGwr5r5Qvoa8gQiFBnBEpMWSmbj1yAevUBf08+Fp13n280tn
         KFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=spKeknQ9pe+LaczsQGMgqzOrOzdIo9JsxnZq6u+F2ec=;
        b=3265sHlUc/3USwRiBIsyMVYLOyk4Y2QNycMjD+VZc2K+4+xKBKm/65s6XJVWkz3NGK
         y+5z5m2TonD8btf6IVBLP7sZoqsdXECU55tEQs7HlTA3beL4tm3NtY3HOc1C7xStbGRu
         dRgVQizhCzzTum+989Ds0rA1W91Ijn7sYIq1xBbySdjtR6svjo6LwMTDNr9uliJgDgjU
         QOh4qv1rWK/2e+2KVPnKs3xnm5MO1+LfxK2ZG9QadRqQeHwN622GQxitkVZGVkwyqjCV
         vMKlhxr/NI7fasWs9cIC3mmBnpwCu1JTc5DzrGP0XiSbD8Dse4wMkxyIzmKZagHTRu5w
         wg4g==
X-Gm-Message-State: AOAM533trDBlntgUNV4GI5t+0dEx8HYm2G6Q6v7Ex46KVL+aMIOO0uaJ
        EjkznTy92/bzPcStaxtNFBE=
X-Google-Smtp-Source: ABdhPJy318HejoB3GaLgZqXptJghFMAXyAzC/+W4/M1wtvDfj6wFyzhu+evE2knVZwCmH/hO/UM2lA==
X-Received: by 2002:aa7:8819:0:b0:4e7:8ca4:6820 with SMTP id c25-20020aa78819000000b004e78ca46820mr6224030pfo.14.1645222819955;
        Fri, 18 Feb 2022 14:20:19 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id q21sm4116146pfu.188.2022.02.18.14.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 14:20:19 -0800 (PST)
Date:   Sat, 19 Feb 2022 03:50:17 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, fw@strlen.de,
        john.fastabend@gmail.com, kafai@fb.com, maximmi@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, songliubraving@fb.com, toke@redhat.com,
        yhs@fb.com, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
Message-ID: <20220218222017.czshdolesamkqv4j@apollo.legion>
References: <20220114163953.1455836-1-memxor@gmail.com>
 <87y228q66f.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y228q66f.fsf@oc8242746057.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 01:49:04AM IST, Alexander Egorenkov wrote:
>
> Hi,
>
> we are having a problem loading nf_conntrack on linux-next:
>
> # modprobe nf_conntrack
> modprobe: ERROR: could not insert 'nf_conntrack': Unknown symbol in module, or unknown parameter (see dmesg)
> modprobe: ERROR: Error running install command '/sbin/modprobe --ignore-install nf_conntrack  && /sbin/sysctl --quiet --pattern 'net[.]netfilter[.]nf_conntrack.*' --system' for module nf_conntrack: retcode 1
> modprobe: ERROR: could not insert 'nf_conntrack': Invalid argument
>
> # dmesg
> [ 3728.188969] missing module BTF, cannot register kfuncs
> [ 3748.208674] missing module BTF, cannot register kfuncs
> [ 3748.567123] missing module BTF, cannot register kfuncs
> [ 3873.597276] missing module BTF, cannot register kfuncs
> [ 3874.017125] missing module BTF, cannot register kfuncs
> [ 3882.637097] missing module BTF, cannot register kfuncs
> [ 3883.507213] missing module BTF, cannot register kfuncs
> [ 3883.876878] missing module BTF, cannot register kfuncs
>
> # zgrep BTF /proc/config.gz
> CONFIG_DEBUG_INFO_BTF=y
> CONFIG_PAHOLE_HAS_SPLIT_BTF=y
> CONFIG_DEBUG_INFO_BTF_MODULES=y
>
> It seems that nf_conntrack.ko is missing a .BTF section
> which is present in debuginfo within
> /usr/lib/debug/lib/modules/*/kernel/net/netfilter/nf_conntrack.ko.debug instead.
>
> Am i correct in assuming that this is not supported (yet) ?
>
> We use pahole 1.22 and build linux-next on Fedora 35 as a set of custom
> packages. Architecture is s390x.
>

+Cc Ilya

Thanks for the report, Alex.

My assumption was that if DEBUG_INFO_BTF options was enabled, and BTF was not
present, it is a problem, but it seems it can happen even when the options are
enabled.

I guess if .BTF section isn't supported/emitted on s390x, we have to relax the
error and print a warning and ignore it, but I am not sure. Ilya would probably
know the current status.

We have already relaxed it once in (bpf-next):

c446fdacb10d ("bpf: fix register_btf_kfunc_id_set for !CONFIG_DEBUG_INFO_BTF")

If this doesn't work on s390x, we should probably just print a warning when
CONFIG_DEBUG_INFO_BTF is enabled and btf == NULL, and return 0.

> Thanks
> Regards
> Alex
>

--
Kartikeya
