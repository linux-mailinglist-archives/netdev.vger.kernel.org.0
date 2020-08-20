Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B41824C7C6
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgHTWbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgHTWbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:31:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78958C061385;
        Thu, 20 Aug 2020 15:31:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a79so67459pfa.8;
        Thu, 20 Aug 2020 15:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hPLWCur19YpF/bL6fBIZzA8zXqw9l/K77szjge2dn3c=;
        b=LFSlxHHjjvZXnlwMAPI9ZClwur1G4AldDPnTyaL87kUQeiI5ShSESoTwboio0S9hnh
         X5i7lhm94wuVYzO3yLZrraivH8SjejxmHsGpFF3ffvFTmrqpXJwAvLNOu++MuNoFxgDW
         hdANQBzHt/aHs+50KAFqhqQwIHyv3uTr0oA+MMgppEs668sEgeXIdWz8XQny85dJEY6S
         l7EMX2YPSBaLmH/0vvrJoWH6bFkYDAZduZtMBSU7bp8D2t5y63G4EP9r5WPbuNeLDpdO
         lNYW8TAeFwqWRE1yAf5CXnRvO/CRDYCgybmD1gfRCigE7Y7CMrTO4RaDT7cjuV+baf5b
         DQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hPLWCur19YpF/bL6fBIZzA8zXqw9l/K77szjge2dn3c=;
        b=pdzhG/8q9BkbiOD1fRVXEVrOgCX83Z6v2GV5PaJI6DupyU0iRnH/KA3qVnI+Sio0mE
         fbGkn9864UXGA/F4FFcPRSOhmuFmqWtZ+YuvweOEDiuUAzjdP1217/w8l7y1nERLQHNB
         L2wCbh9Hp1515nhUaRvYlOfOcrYV9KaBFnN4iafzQ96S6UFz0S+7t+Idf2BSxHP0kJJI
         jfYIn5GRxScUNEer5dR0dBPklkqIHiMak6bDSWOEK4r6N1Ey+Chjyk4sKLFsBjhjmbg7
         MilE4vjbIAIW0Ku5IJDz9HhnFiG0SQEPg8aSratAssi4W8IPN2OYgVs2a3Q3vkiVdYPI
         et6Q==
X-Gm-Message-State: AOAM532AkZN4lptbR1wGJXeb7x5K5eFrTo+3SJRcGc2/kOnnJlZ24auo
        cV2xpZ9kt9XQgFyYDvlysKkHfNQPmw4=
X-Google-Smtp-Source: ABdhPJzyLOAZUurTmVX10YqHafEdFPad3SF/UOyROTB2+gP/bXXq4MJeKU+QlRs+Tqhxao+jss817Q==
X-Received: by 2002:a63:5fc9:: with SMTP id t192mr170381pgb.269.1597962675018;
        Thu, 20 Aug 2020 15:31:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8791])
        by smtp.gmail.com with ESMTPSA id b15sm84908pft.116.2020.08.20.15.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 15:31:13 -0700 (PDT)
Date:   Thu, 20 Aug 2020 15:31:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: implement link_query for bpf iterators
Message-ID: <20200820223111.6dbbp53rpszht4uf@ast-mbp.dhcp.thefacebook.com>
References: <20200820001323.3740798-1-yhs@fb.com>
 <20200820001323.3740936-1-yhs@fb.com>
 <20200820080701.09f23759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3270dbc2-7f7d-b05c-7244-9fee18503a1f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3270dbc2-7f7d-b05c-7244-9fee18503a1f@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 09:15:30AM -0700, Yonghong Song wrote:
> 
> 
> On 8/20/20 8:07 AM, Jakub Kicinski wrote:
> > On Wed, 19 Aug 2020 17:13:23 -0700 Yonghong Song wrote:
> > > +	fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
> > > +	if (fill_link_info)
> > > +		return fill_link_info(&iter_link->aux, info);
> > > +
> > > +        return 0;
> > 
> > ERROR: code indent should use tabs where possible
> > #138: FILE: kernel/bpf/bpf_iter.c:433:
> > +        return 0;$
> > 
> > WARNING: please, no spaces at the start of a line
> > #138: FILE: kernel/bpf/bpf_iter.c:433:
> > +        return 0;$
> 
> 
> Thanks for reporting! Will wait a little bit for further
> comments and send v2.

all looks good to me.
