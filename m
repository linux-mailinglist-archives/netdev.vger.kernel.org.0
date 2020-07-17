Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA8224425
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgGQTVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:21:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728183AbgGQTVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595013707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2I9O+xuUTOEcKzc5eYOtMc3MxBcbVZkckTnyrsuEPg=;
        b=hyFWYAnrktMNotwtsJeqRAUklW4HnmdQWzDMF5UJOIQSFRcs1GGWNX87d+s/zYtCj98UGj
        aQiwDRYCobyuHXqTsXZhojmPc7wg+Sn3xbHBUtTc18glP75zrSGd+yf4yWwgpwflp6PmeZ
        mnyuObru0FnQxHlboWXDFGpnHMwGXbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-Em5kLwL2OCyR27pSDxkrIA-1; Fri, 17 Jul 2020 15:21:45 -0400
X-MC-Unique: Em5kLwL2OCyR27pSDxkrIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EF88107B7EF;
        Fri, 17 Jul 2020 19:21:44 +0000 (UTC)
Received: from krava (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4B7005C57D;
        Fri, 17 Jul 2020 19:21:42 +0000 (UTC)
Date:   Fri, 17 Jul 2020 21:21:41 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/2] bpf: change var type of BTF_ID_LIST to
 static
Message-ID: <20200717192141.GF528602@krava>
References: <20200717184706.3476992-1-yhs@fb.com>
 <20200717184706.3477154-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717184706.3477154-1-yhs@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 11:47:06AM -0700, Yonghong Song wrote:
> The BTF_ID_LIST macro definition in btf_ids.h:
>    #define BTF_ID_LIST(name)                \
>    __BTF_ID_LIST(name)                      \
>    extern u32 name[];
> 
> The variable defined in __BTF_ID_LIST has
> ".local" directive, which means the variable
> is only available in the current file.
> So change the scope of "name" in the declaration
> from "extern" to "static".
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  include/linux/btf_ids.h       | 2 +-
>  tools/include/linux/btf_ids.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 1cdb56950ffe..cebc9a655959 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -66,7 +66,7 @@ asm(							\
>  
>  #define BTF_ID_LIST(name)				\
>  __BTF_ID_LIST(name)					\
> -extern u32 name[];
> +static u32 name[];
>  
>  /*
>   * The BTF_ID_UNUSED macro defines 4 zero bytes.
> diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> index fe019774f8a7..b870776201e5 100644
> --- a/tools/include/linux/btf_ids.h
> +++ b/tools/include/linux/btf_ids.h
> @@ -64,7 +64,7 @@ asm(							\
>  
>  #define BTF_ID_LIST(name)				\
>  __BTF_ID_LIST(name)					\
> -extern u32 name[];
> +static u32 name[];
>  
>  /*
>   * The BTF_ID_UNUSED macro defines 4 zero bytes.
> -- 
> 2.24.1
> 

