Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664AE33E927
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhCQFel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCQFek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:34:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A00CC06174A;
        Tue, 16 Mar 2021 22:34:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l2so24127328pgb.1;
        Tue, 16 Mar 2021 22:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UsMvJPG09AId4Uqxcy+OBpTMhL25j5K8gnZ/yyUXTYY=;
        b=h3w8Yw/xiLjO8Wg5K6RPIX012PdKVaauagxXTkdmnJQt/Qd/5AhvZkmsbCYEsO/CX6
         K6YFBcASl/mhYOmNg6F9G5wKjdmbWjivEs1diLTvDUCAMD0SRyNnPttd3Vphf+HnqBB5
         ZJQJ/rncCF0v9oUcItEFT9gXS7Y9v1zSmeUCj50eMiaqTqeqHrfRrXL7xfb9L+QnsCrO
         wrgFUsYYFeURQ72M1lhqrlssYxrUJPtLTEezZxDdmPrlrcOueP178OE3A/lvhnQZlJzT
         t2QcllX+ttjbWkeV3cB36MWwzNd0o8JT7JusfRd2psNQPjfgnYcEKsoDAOxh9ao0Hm0K
         7TeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UsMvJPG09AId4Uqxcy+OBpTMhL25j5K8gnZ/yyUXTYY=;
        b=twl/JRNbHkSFO+NvZIoyv8qsVsm+6FZI7UR4Evu+zJ0pAIvgLja7BQen2mOzOvacL7
         9ueCCB5fliX17CIKVTtriLQJb1KEj3kYuZVgjjPu0chA7HeSxWTNgTgIj7PuTLiIN15h
         dN7QhoZ72w/PTtTs42q9Ta4nhZceagu2NUcqjv+nkocLZ6OCHU/9DLICmIwGa6zRJ6lQ
         zJyqhEsVK9fVEWZoszomtOb3ilf9gUiSdB+UoBoRIZo2EHBLzFviKiWpOBKuups9uUiZ
         3mMKkzDe6FRGZNSx9AI33iM4vXDAxfQJnO3AHi35xePRF42Fjc3NoSStWIXn5HmETT+L
         VBqg==
X-Gm-Message-State: AOAM5334OyymcIAqDqLI9kWYVHOv7fpSZ7v2ZBMrz5BRECyw0DazJcOf
        XyGrbLbfDKMAOA2KzjinCT4=
X-Google-Smtp-Source: ABdhPJxEsG8nIuxr7xT3i13WAW4y+6yv3yE3OSPF3Zg4aw5gsUvoS8hUeYUmzI4IqTnunawx7uFcEg==
X-Received: by 2002:a63:1f05:: with SMTP id f5mr1212443pgf.84.1615959279663;
        Tue, 16 Mar 2021 22:34:39 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4c29])
        by smtp.gmail.com with ESMTPSA id j27sm17744072pgn.61.2021.03.16.22.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 22:34:39 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:34:37 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 10/11] selftests/bpf: pass all BPF .o's
 through BPF static linker
Message-ID: <20210317053437.r5zsoksdqrxtt22r@ast-mbp>
References: <20210313193537.1548766-1-andrii@kernel.org>
 <20210313193537.1548766-11-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313193537.1548766-11-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 11:35:36AM -0800, Andrii Nakryiko wrote:
>  
> -$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
> -		      $(TRUNNER_OUTPUT)/%.o				\
> -		      $(BPFTOOL)					\
> -		      | $(TRUNNER_OUTPUT)
> +$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
>  	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> -	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
> +	$(Q)$$(BPFTOOL) gen object $$(<:.o=.bpfo) $$<
> +	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@

Do we really need this .bpfo extension?
bpftool in the previous patch doesn't really care about the extension.
It's still a valid object file with the same ELF format.
I think if we keep the same .o extension for linked .o-s it will be easier.
Otherwise all loaders would need to support both .o and .bpfo,
but the later is no different than the former in terms of contents of the file
and ways to parse it.

For testing of the linker this linked .o can be a temp file or better yet a unix pipe ?
bpftool gen object - one.o second.o|bpftool gen skeleton -
