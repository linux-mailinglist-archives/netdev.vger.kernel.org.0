Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425FA44ED3C
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 20:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhKLT1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 14:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhKLT1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 14:27:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC28DC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 11:24:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so8421190pjb.1
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 11:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPC1y85UwpV3K+jGt+fYsJ6aRQz3wozSnJS4ODXw5p0=;
        b=LCuNpWvyRFpCMGE6oAVSCaqgNfi4u9PwVuhsgvgrOY+GpDcGkFqMGQsT2EWSVtb4mK
         uOi3TAsgZYFNwBrFcG2L2X+3b+wbYFkggz3n471Yy0Qvb0B+SO1r7ylRCJk5zwbcs7LI
         HzzL/ep0O7JTETOtVCXemgBcusxLaa+pqn5zaG/ykvB5A7eqMmX4pWY0xGjHzqImMWpz
         f1EjQN2F00XTtjlyUJwhY/+1m/TJQPTnixZr5SoEalbeBveUf22aWtSGHlRlcEWsLVZ3
         22pa2QO7B07N+BsEC+qAhwOm30lIYKD39HjSovBo3UU2lNsoORRw4heN8tkuA4ubi2ex
         ddNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPC1y85UwpV3K+jGt+fYsJ6aRQz3wozSnJS4ODXw5p0=;
        b=PG26qqkapSp6PCohI9pGSIKtgAOQ3jGuCxJVWaX+iDKD5EkimGaoPx7Bj0FsvfPOJP
         CexLyCDuaIBWal+KvRyEU+B+3VzXrlVsbEBr7kN3sYvzleufvj43BuAtVA7aifA9OJPW
         lnEK/xvIvABoPOc81mrTost3RUtUY1RfJXqjMKbkL2cvygU/tswIdMHz72Fh7oYJupWp
         gkuIHwwPT5lc6fumcHcUd0F8wE30+Aj9I02iD42heKB/AwGYbFg26LfrzprC1dJw1C8H
         3l/HIN+xD98ofJF/+gcYFCutCVXOVYcDz/o+TXb7+D5tfuq29WF1F1Q+3swSe8wBE3Rj
         RkHA==
X-Gm-Message-State: AOAM533gSuUWHqBZpM7cRLoDgVeUa5lUPJjwcKQS+wrKG3hQdXGrVxee
        qfDcjn98VjdiVSW5X9q0i78H/A==
X-Google-Smtp-Source: ABdhPJykGS84DZxzKGS5iqLCqWKIWICX3HvGkLJEt9jc5LLldBjIimkXY7AATfb/S7QlCFuh16JqVA==
X-Received: by 2002:a17:90a:cf85:: with SMTP id i5mr39215754pju.101.1636745086312;
        Fri, 12 Nov 2021 11:24:46 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id e11sm5740100pjl.20.2021.11.12.11.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 11:24:46 -0800 (PST)
Date:   Fri, 12 Nov 2021 11:24:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>
Subject: Re: [External] : Re: [PATCH] net: sched: sch_netem: Refactor code
 in 4-state loss generator
Message-ID: <20211112112443.729078c1@hermes.local>
In-Reply-To: <BL0PR10MB2770D3AB750A2318B983AE47C2959@BL0PR10MB2770.namprd10.prod.outlook.com>
References: <20211112071447.19498-1-harshit.m.mogalapalli@oracle.com>
        <20211112081244.52218572@hermes.local>
        <BL0PR10MB2770D3AB750A2318B983AE47C2959@BL0PR10MB2770.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 17:57:08 +0000
Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:

> Hi Stephen,
> 
> Yes, you are correct.
> 
> To match the convention mapping should be like this instead:
> 
> State 3 ---> LOST_IN_BURST_PERIOD
> State 4 ---> LOST_IN_GAP_PERIOD
> 
> 
> Thanks,
> Harshit
> ________________________________
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, November 12, 2021 9:42 PM
> To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>; Cong Wang <xiyou.wangcong@gmail.com>; Jiri Pirko <jiri@resnulli.us>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; yangyingliang@huawei.com <yangyingliang@huawei.com>
> Subject: [External] : Re: [PATCH] net: sched: sch_netem: Refactor code in 4-state loss generator
> 
> On Thu, 11 Nov 2021 23:14:47 -0800
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:
> 
> > Fixed comments to match description with variable names and
> > refactored code to match the convention as per [1].
> > [1] S. Salsano, F. Ludovici, A. Ordine, "Definition of a general
> > and intuitive loss model for packet networks and its implementation
> > in the Netem module in the Linux kernel"
> >
> > Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>  
> 
> I wonder if this was changed accidently by this commit
> Commit: a6e2fe17eba4 ("sch_netem: replace magic numbers with enumerate")
> 

Could you resend with updated commit message and Fixes tag?
