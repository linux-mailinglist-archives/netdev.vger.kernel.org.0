Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9337231EAA5
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 15:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhBRN60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhBRNPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 08:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4285264E92;
        Thu, 18 Feb 2021 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613654052;
        bh=DICMxhSu9qIwJkZC3lVGDCORd7AqBmihED5o+uDFsVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pulXCgMOy3JXpT4Cz56rgdtZWEARwMUh6EKE96xVim6pBzIfpeulZCcjfqiPWiHwU
         /f5I/SPW/NGNfMDN5zDMXPRqyUwMY20p4+8hRT5nzjd35o+D5mCQJzLfTbiZToc0TB
         k4kIzZwz54WyLmpu6Z4z8sBGkxNDFCHdLl6SSup5i7hiWE0vkzwhd/poAYPpIcGGX3
         1jWqKjrbij5Ojh7mZuVOXIuX0vd5jV2J/yqNIyBBlVGOdrMeMgISYKYj+1MabyoU8F
         kqxCf71C1t/x/39BwCmN8F1Rqxqs4oy1citP4TA32iuX5AHolOZCT0jv8Gbpf164QW
         1vHXL2COSxS7A==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0DCBF40CD9; Thu, 18 Feb 2021 10:14:10 -0300 (-03)
Date:   Thu, 18 Feb 2021 10:14:10 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        peterz@infradead.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf tools: Simplify the calculation of variables
Message-ID: <YC5oIkXjJSj/GJpX@kernel.org>
References: <1612497255-87189-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <YB0Um9N4rW8fd+oD@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YB0Um9N4rW8fd+oD@krava>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Feb 05, 2021 at 10:49:15AM +0100, Jiri Olsa escreveu:
> On Fri, Feb 05, 2021 at 11:54:15AM +0800, Jiapeng Chong wrote:
> > Fix the following coccicheck warnings:
> > 
> > ./tools/perf/util/header.c:3809:18-20: WARNING !A || A && B is
> > equivalent to !A || B.
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > ---
> >  tools/perf/util/header.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index c4ed3dc..4fe9e2a 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -3806,7 +3806,7 @@ int perf_session__read_header(struct perf_session *session)
> >  	 * check for the pipe header regardless of source.
> >  	 */
> >  	err = perf_header__read_pipe(session);
> > -	if (!err || (err && perf_data__is_pipe(data))) {
> > +	if (!err || perf_data__is_pipe(data)) {
> 
> mama mia, thanks
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Thanks, applied.

- Arnaldo

 
> jirka
> 
> >  		data->is_pipe = true;
> >  		return err;
> >  	}
> > -- 
> > 1.8.3.1
> > 
> 

-- 

- Arnaldo
