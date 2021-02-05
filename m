Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE13731085E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBEJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:52:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhBEJux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612518564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xjgv6TBlt1h4VM26o37et2OrO2gHmNIuStDR6rITBLU=;
        b=czeE848EgRVHG8DfWOOpov1NTpRHZcZiyVEo3pYO3KDPT8zS8k2tx+sx46lYHS87AOgJVZ
        1gyc59LPXKR9w3+b55e+//xOjh3Zemwalok9qSG4ZIpEuQnGW8qrP1VZw9br0xBNRuZ46q
        0QvXRQO0ip5RY3nhckFuIKglAxusyN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-jTsZft2DNzmCkYcDQddbkQ-1; Fri, 05 Feb 2021 04:49:23 -0500
X-MC-Unique: jTsZft2DNzmCkYcDQddbkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D6D193410E;
        Fri,  5 Feb 2021 09:49:20 +0000 (UTC)
Received: from krava (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9167160937;
        Fri,  5 Feb 2021 09:49:15 +0000 (UTC)
Date:   Fri, 5 Feb 2021 10:49:15 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf tools: Simplify the calculation of variables
Message-ID: <YB0Um9N4rW8fd+oD@krava>
References: <1612497255-87189-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612497255-87189-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 11:54:15AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/perf/util/header.c:3809:18-20: WARNING !A || A && B is
> equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/perf/util/header.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index c4ed3dc..4fe9e2a 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -3806,7 +3806,7 @@ int perf_session__read_header(struct perf_session *session)
>  	 * check for the pipe header regardless of source.
>  	 */
>  	err = perf_header__read_pipe(session);
> -	if (!err || (err && perf_data__is_pipe(data))) {
> +	if (!err || perf_data__is_pipe(data)) {

mama mia, thanks

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

>  		data->is_pipe = true;
>  		return err;
>  	}
> -- 
> 1.8.3.1
> 

