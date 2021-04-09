Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100DE35921F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 04:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhDICp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 22:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhDICp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 22:45:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89E4C061760;
        Thu,  8 Apr 2021 19:45:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l76so2782051pga.6;
        Thu, 08 Apr 2021 19:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j1Bj0rvoy+oFNKx+EoumArjPjh1aRsIQYcLQ6zUAxI4=;
        b=G81O/B89oL2N1gRawcKLyRZhoNbwsCRc579s0/bSN0wh3U2MrrWjruFbr0q3cMA7Pa
         J+ucntcdq4xL+h4V0Y3N1idtH4iCIWmWWc11EL8ZE7Vm6GLn7sqhAApp9dD0Mpyt7c9t
         kgWrHtOKHzZftfEACi9Is4jy5OuMDzsosxu5BTZPNF/hdOYjtDZlCsAsi077/XvY0aMM
         CE+M3E2w8eRj8YWzMCiss0b09zM7tW2iBLvQfE0PllOjpf0sYLAGb6n9lUS9Dbdn4Mkr
         dbmCoLu6QDRoNBaxZ2FAUz7qustsh809CKYBm7LwAgCBvhk6zMfpFA1jCWEi0YA1jWb8
         3azA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j1Bj0rvoy+oFNKx+EoumArjPjh1aRsIQYcLQ6zUAxI4=;
        b=ENS75F/KWNTLPe6iK78yuyC6e4EeYMBqA8mPxJZyuBUrXpX9LJGilTZVzR0xLsLL4i
         uR7uv/u1xlTNYcHnxeY2ijlV1/PL+u2Jf4w9WJnrmTkz8ylxrVwauzBxQPmDKpe4jNXk
         FGMaMyPmWPGJ8cQrPo6nm+5h4/k3G50wviCce07QYR4C48EQsjhKo9mYVxtG3nOqTkWm
         WWPuCT3CH41CwwtbAcE/jsBTsVvXoKKlUDugS77NAZ+cesYp2FiUZ+BaqFujpK98hEP5
         iHaXrCpI4q9FlAFU5R1pCB9ZonrNpE+Yllxk8+QyRTvjQsxTnsTCJNYHwU6vTID9AMxH
         TnHA==
X-Gm-Message-State: AOAM5334BH/CWf6jvdbi/jHNSxFSKJVNyNf839heJPthJT5X67/ZqKo5
        q205K12EARrkr+ETnP/xWVc=
X-Google-Smtp-Source: ABdhPJzxiGwUKdUoVkg0jKHoGD4KfWPlDLyBj1pQ7pf5fXE4ElRZAfSEfIFek3GSp1UJilQs4xQyhA==
X-Received: by 2002:a65:40c7:: with SMTP id u7mr10909516pgp.29.1617936313292;
        Thu, 08 Apr 2021 19:45:13 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s9sm624802pfc.192.2021.04.08.19.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 19:45:12 -0700 (PDT)
Date:   Fri, 9 Apr 2021 10:45:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210409024500.GM2900@Leo-laptop-t470s>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
 <20210406063819.GF2900@Leo-laptop-t470s>
 <878s5v4swp.fsf@toke.dk>
 <606cd787d64da_22ba520855@john-XPS-13-9370.notmuch>
 <87k0pf2gz6.fsf@toke.dk>
 <606ce0db7cd40_2865920845@john-XPS-13-9370.notmuch>
 <87h7kj2enn.fsf@toke.dk>
 <606f922584d89_c8b92089a@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <606f922584d89_c8b92089a@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 04:30:45PM -0700, John Fastabend wrote:
> Hangbin,
> 
> If possible please try to capture some of the design discussion in
> the commit message on the next rev along with the tradeoffs we are making
> so we don't lose these important details. Some of these points are fairly
> subtle calling them out will surely save (for me at least) some thinking
> when I pick this up when it lands in a released kernel.

OK, I will try. There are too many rounds discussion. Please forgive me
if I missed something.

Thanks
Hangbin
