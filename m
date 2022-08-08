Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2E958C879
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 14:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiHHMlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 08:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiHHMlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 08:41:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F0326447
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 05:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659962472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TrFh1uBMq/fvCw2kODakluoaRrhdWrjukcnqYlihIj0=;
        b=c2Kipuoc4Wu9/lw8wXrDUreDo0odo+5Bq2EEQeRVEOslZIS4LrrDxhgwWXJbGBXUUmpqK8
        smzJKM/HJK1nSBOe/XOYni/BxCEoXDtxYpinHqNOgmlz1u/+NFsfu4Q0dX5KRuzQwzBf0y
        /if5ciSJy8ixFEsLqng4KNhYBFf+nL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-eiN6VEufMYamlUmCExinFg-1; Mon, 08 Aug 2022 08:41:09 -0400
X-MC-Unique: eiN6VEufMYamlUmCExinFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8383D957BA1;
        Mon,  8 Aug 2022 12:41:08 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.40.194.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABE6618ECC;
        Mon,  8 Aug 2022 12:41:05 +0000 (UTC)
Date:   Mon, 8 Aug 2022 14:41:02 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
Message-ID: <YvEEXsdo/fCnoEFY@samus.usersys.redhat.com>
Mail-Followup-To: Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>, Jiri Olsa <olsajiri@gmail.com>,
        Song Liu <song@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>
References: <20220808094623.387348-1-asavkov@redhat.com>
 <20220808094623.387348-2-asavkov@redhat.com>
 <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 02:14:33PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Mon, 8 Aug 2022 at 11:48, Artem Savkov <asavkov@redhat.com> wrote:
> >
> > Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> > flag set will require CAP_SYS_BOOT capabilities.
> >
> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> >  include/linux/btf.h   | 1 +
> >  kernel/bpf/verifier.c | 5 +++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index cdb376d53238..51a0961c84e3 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -49,6 +49,7 @@
> >   * for this case.
> >   */
> >  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> > +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
> >
> 
> Please also document this flag in Documentation/bpf/kfuncs.rst.

Ok, will do.

> And maybe instead of KF_DESTRUCTIVE, it might be more apt to call this
> KF_CAP_SYS_BOOT. While it is true you had a destructive flag for
> programs being loaded earlier, so there was a mapping between the two
> UAPI and kfunc flags, what it has boiled down to is that this flag
> just requires CAP_SYS_BOOT (in addition to other capabilities) during
> load. So that name might express the intent a bit better. We might
> soon have similar flags encoding requirements of other capabilities on
> load.
> 
> The flag rename is just a suggestion, up to you.

This makes sense right now, but if going forward we'll add stricter
signing requirements or other prerequisites we'll either have to rename
the flag back, or add those as separate flags. I guess the decision here
depends on whether some of non-destructive bpf programs might ever require
CAP_SYS_BOOT capabilities or not.

-- 
 Artem

