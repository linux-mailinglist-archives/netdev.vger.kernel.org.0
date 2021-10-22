Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554F3437BDB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJVR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhJVR22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:28:28 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BCAC061764;
        Fri, 22 Oct 2021 10:26:10 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h196so6377075iof.2;
        Fri, 22 Oct 2021 10:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=a+64Df8HIOf/CrsD8pa8xZ1JJyjhEuVc8/fC1OnXF38=;
        b=VrHGQbU0JPpN++Qu/+D6kJVpRi0cOHnY0XYbm3uLjNE2V76AeT2lDlxWa/D1DHNCmc
         UV+4IS304/2EkUvexjLq0Of6PTyyczZ2B0w+OwsWgH+gtodKHhW+HkMFyMkhnCuxGVQM
         ceGx8CU/F3JpZznbWQy/VW7PnAvrbUQNUECOV/okgFnQQp+b1tmpvG/QnnZFzEjFJ7wy
         dNorxiXUZuAISZ0UgeocVzOHBy9g97kz2vTSVl1xM7R4L04PHZ1c/MQQmUD32Hhy/DzM
         ShNxa4FMETz8r5saw211ybbET20+nyJquKl5waZywTHs231adWmWktN6rF3i36lrzDh1
         I7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=a+64Df8HIOf/CrsD8pa8xZ1JJyjhEuVc8/fC1OnXF38=;
        b=SyxG4FICNiXhdYbZxG9V+YJBL9fRJZnJL0dHla3MJxBc/uZn116hOXJrborJ5qlcM2
         NHClwfTXenqwGiAjRAp6y3QBVtETvpm7hkeIi7ia1P9QRBxKy+AydLYrQyzl25nqDfUk
         keTnpiAEM1yNkNJk1Zt7kpiS+YtA3GXs+aeaxqdwrAhFcCc8TOS+VoLoSUfKgXveq6kh
         QCQMsvJVn9R/upx6Rk8HugvNMKbOBEHdK6h4S8MjCJgOyMQWmslK93M/dpPZJ8DVqjan
         uynSe8WSmIBHH23dZnnm0ak+XLYBu2/ZM+o4jkw9YkxkPJ/Ut1j3UuAf9ymRL0BeUHsm
         ijUg==
X-Gm-Message-State: AOAM530QL1k+Mt/ZrzYzFieFAtlx0fooBLkUTs5JmyNoyBq4+k+eqbDS
        /gjBDglKqU//ljq+aM351sLKkprqSvvjtbds
X-Google-Smtp-Source: ABdhPJzQPE4AJ8jRq/AOrpDNBTpupaVcpkZCFxLqmCIHmhw1dWl0SAKBsXy8rl+s2cKZPjnTu21DHw==
X-Received: by 2002:a02:a409:: with SMTP id c9mr796662jal.39.1634923569771;
        Fri, 22 Oct 2021 10:26:09 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l10sm4355411ioq.8.2021.10.22.10.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:26:08 -0700 (PDT)
Date:   Fri, 22 Oct 2021 10:26:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <6172f428e4174_86bab20824@john-XPS-13-9370.notmuch>
In-Reply-To: <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch>
References: <20211011155636.2666408-1-sdf@google.com>
 <20211011155636.2666408-2-sdf@google.com>
 <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Stanislav Fomichev wrote:
> > Otherwise, attaching with bpftool doesn't work with strict section names.
> > 
> > Also, switch to libbpf strict mode to use the latest conventions
> > (note, I don't think we have any cli api guarantees?).
> > 
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/bpf/bpftool/main.c |  4 ++++
> >  tools/bpf/bpftool/prog.c | 15 +--------------
> >  2 files changed, 5 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > index 02eaaf065f65..8223bac1e401 100644
> > --- a/tools/bpf/bpftool/main.c
> > +++ b/tools/bpf/bpftool/main.c
> > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> >  	block_mount = false;
> >  	bin_name = argv[0];
> >  
> > +	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > +	if (ret)
> > +		p_err("failed to enable libbpf strict mode: %d", ret);
> > +
> 
> Would it better to just warn? Seems like this shouldn't be fatal from
> bpftool side?
> 
> Also this is a potentially breaking change correct? Programs that _did_
> work in the unstrict might suddently fail in the strict mode? If this
> is the case whats the versioning plan? We don't want to leak these
> type of changes across multiple versions, idealy we have a hard
> break and bump the version.
> 
> I didn't catch a cover letter on the series. A small
> note about versioning and upgrading bpftool would be helpful.
> 
> 
> >  	hash_init(prog_table.table);
> >  	hash_init(map_table.table);
> >  	hash_init(link_table.table);
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index 277d51c4c5d9..17505dc1243e 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >  
> >  	while (argc) {
> >  		if (is_prefix(*argv, "type")) {
> > -			char *type;
> > -
> >  			NEXT_ARG();
> >  
> >  			if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> > @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >  			if (!REQ_ARGS(1))
> >  				goto err_free_reuse_maps;
> >  
> > -			/* Put a '/' at the end of type to appease libbpf */
> > -			type = malloc(strlen(*argv) + 2);
> > -			if (!type) {
> > -				p_err("mem alloc failed");
> > -				goto err_free_reuse_maps;
> > -			}
> > -			*type = 0;
> > -			strcat(type, *argv);
> > -			strcat(type, "/");
> > -
> > -			err = get_prog_type_by_name(type, &common_prog_type,
> > +			err = get_prog_type_by_name(*argv, &common_prog_type,
> >  						    &expected_attach_type);
> > -			free(type);
> >  			if (err < 0)
> >  				goto err_free_reuse_maps;
> 
> This wont potentially break existing programs correct? It looks like
> just adding a '/' should be fine.
> 
> Thanks,
> John

Oops  wrong version of the patch. I'll reply in the more recent one.
