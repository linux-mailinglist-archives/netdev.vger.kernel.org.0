Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B623572CB7
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 06:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiGMErE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 00:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGMErD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 00:47:03 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E09C7657;
        Tue, 12 Jul 2022 21:46:59 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so1666320pjl.4;
        Tue, 12 Jul 2022 21:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gBaYkCq2UOecKkI/ZcXaXDVPy+SEFxbUDpVc4bdCZmM=;
        b=h1H/+uf4FxW4bgT2t3lI+XGqdPLgtl0u4V9II5sch1nlT+lMFHYXepqKt3obshgGQr
         3HvlRGfLhGGuN/cLDAW+qlK3KCK5YFGagFcXTsXxI41AZhR0UvNjIOlpluv73F4bxF/g
         pFWma2sdbuCLVJtI9XiLV2fs42bsQjkzpvmWkN4oCL2sNl7r9G1b+YQyRp08KueMfFes
         c4o+4R1l23aSWaIKGanMB/60uX0VmGGgtKiBWNxIHEkc06LPSYVDvoQbvR1B5UwEmIHV
         dw1B4Nb9a9I4T9YxMEAxznmpehRy31heyuhIqdWkyGOAybIB3VCVbIEOmwToNh5BrTu+
         lr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gBaYkCq2UOecKkI/ZcXaXDVPy+SEFxbUDpVc4bdCZmM=;
        b=oItuH4RaAJAToFdOZg68Nl6CFB7yOzmRhia1WTM0+k1sZYzgvZ2onMK0Rt/wT7DV6e
         WkEe1az71KF8Tc2pM1PE6UVj/dFuziESIjpSTJrLnbdo2F4HyjXmjefv6xdJ8y0MJX22
         2NALsgE+cPYCwzTpvTQPpsh2r0lnruX/gg0Ex29951w43SRlC5EFoh84qgfBAZ06GLEk
         3AJSzFn210fBTuKzYpBnxsfhTEePzJQxkOEV22fZ293/iibFJ31/aeuTpjfMadkZnXV8
         NUt3f7gzO0PGyjoyXXutjYNb5nHLTBFB+k5/ddPvxcOwSvLskllQocdTdEyMipwjko3/
         w9Cg==
X-Gm-Message-State: AJIora8vIO4Rl93VFsNmuXQSKLL+MlH9+2EnW8T0Y0kWUZ5NAQJggsq+
        WXdI/56OsfqkiNwaeMvU650=
X-Google-Smtp-Source: AGRyM1t4Kvp3+MPAFYCpd5hlmg5MlCU8bpPTtIXAtIiqdQtJ+Yzx2cYW2gylT+SNs6NaoePwv/3tlQ==
X-Received: by 2002:a17:90b:1d02:b0:1f0:1c2c:cc64 with SMTP id on2-20020a17090b1d0200b001f01c2ccc64mr1836081pjb.52.1657687618757;
        Tue, 12 Jul 2022 21:46:58 -0700 (PDT)
Received: from localhost.localdomain (pcd364232.netvigator.com. [203.218.154.232])
        by smtp.gmail.com with ESMTPSA id fr14-20020a17090ae2ce00b001f0097c2fb2sm469316pjb.28.2022.07.12.21.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 21:46:58 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     hare@suse.de
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, chuck.lever@oracle.com,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, simo@redhat.com, kuba@kernel.org,
        18801353760@163.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH RFC 1/5] net: Add distinct sk_psock field
Date:   Wed, 13 Jul 2022 12:46:37 +0800
Message-Id: <20220713044637.106017-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <325938d3-bb82-730b-046c-451dde8cc14c@suse.de>
References: <325938d3-bb82-730b-046c-451dde8cc14c@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On 4/18/22 18:49, Chuck Lever wrote:
>> The sk_psock facility populates the sk_user_data field with the
>> address of an extra bit of metadata. User space sockets never
>> populate the sk_user_data field, so this has worked out fine.
>> 
>> However, kernel consumers such as the RPC client and server do
>> populate the sk_user_data field. The sk_psock() function cannot tell
>> that the content of sk_user_data does not point to psock metadata,
>> so it will happily return a pointer to something else, cast to a
>> struct sk_psock.
>> 
>> Thus kernel consumers and psock currently cannot co-exist.
>> 
>> We could educate sk_psock() to return NULL if sk_user_data does
>> not point to a struct sk_psock. However, a more general solution
>> that enables full co-existence psock and other uses of sk_user_data
>> might be more interesting.
>> 
>> Move the struct sk_psock address to its own pointer field so that
>> the contents of the sk_user_data field is preserved.
>> 
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>   include/linux/skmsg.h |    2 +-
>>   include/net/sock.h    |    4 +++-
>>   net/core/skmsg.c      |    6 +++---
>>   3 files changed, 7 insertions(+), 5 deletions(-)
>> 
>Reviewed-by: Hannes Reinecke <hare@suse.de>
>
>Cheers,
>
>Hannes

In Patchwork website, this patch fails the checks on
netdev/cc_maintainers.

So maybe you need CC folks pointed out by
scripts/get_maintainer.pl script, which is suggested
by Jakub Kicinski <kuba@kernel.org>.

What's more, Syskaller reports
refcount bug in sk_psock_get (2).

In this bug, the problem is that smc and psock, 
both use sk_user_data field to save their 
private data. So they will treat field in their own way.

> in smc_switch_to_fallback(), and set smc->clcsock->sk_user_data
> to origin smc in smc_fback_replace_callbacks().
> 
> Later, sk_psock_get() will treat the smc->clcsock->sk_user_data
> as sk_psock type, which triggers the refcnt warning.

I have tested this patch and the reproducer did not trigger any issue.
For more details, you can check the email
[PATCH] smc: fix refcount bug in sk_psock_get (2)
