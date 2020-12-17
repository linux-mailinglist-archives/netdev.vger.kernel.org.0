Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907D62DCD14
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgLQHvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQHvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 02:51:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414ECC061794;
        Wed, 16 Dec 2020 23:51:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id hk16so3635585pjb.4;
        Wed, 16 Dec 2020 23:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nXdlH/w0rqJMvWwzhJtuxGzAMj6KbRyBWWhJY+HL26Q=;
        b=C0Xggz8VVexAoZtduHhbFOez1Mw7Duev9wa2WCENO58rQAyxsz6knEQFDbfhIqqtkS
         1vsEe3NDH+e99YvFBqW0AGDNAIq4jHjA3Tp07bwBVt9OIHZx/21OCc+90ooUnUHX4KJw
         myVGCybw1XlaZJ8CMoAK4UjmA7PG86DSAGNKZmBgjMz84+JGIWbvsRCVPSXSVz/B1J8b
         FQlHag8wK3q1Bp2Atmx33VAajrN9xawX1imqcdiqGqrN4dhV2F+ja2+YZTWF8ZSmbcE/
         zO+14y7kTXOZlEoocbWl4cmpYMdiuC80jCU3rktU2m+TvbUmjB+Tb0W3faCLmyTszBMu
         m+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nXdlH/w0rqJMvWwzhJtuxGzAMj6KbRyBWWhJY+HL26Q=;
        b=AnukvJ0pfwgPJc3XrTWo6j0yDODO/E3s+QhASLQ040TuySCyDWlhgXiSHRFaw5PUOA
         wx6+Zc9lvUZpfZBI6VXGg1ACZxb20igJyD6pFHgUpqX6Ku8HOdNVabUquYH5DhfLF3xW
         et3Jcyolyth+bapTnAQqLG2CNUSqaE6FSuuE8wLduSg/1wSkd/tnCRJUwPDrRz3VsCXC
         i2x6Lc7JOqWtJkC2V9TS5+rsr6F3VyLnE8J+13y/e3lKV9W82ckKvxmVD5t99YOD1Pnl
         60a5Ro+BUidVb/xaco4Em5W9vTvXtJ28QZGMBrYUiZx3EzCSSAccfQL+MwtqSy/7++j0
         vgDA==
X-Gm-Message-State: AOAM532HEowx4NaM3vxyw80y4CGn4+qMbh1leQShX0OuQ5Xve6EGwZJ3
        Mx9vI2GWRUCKIBVkqFElcQ==
X-Google-Smtp-Source: ABdhPJylqMaha43936xHqNHLVmCeiX7rb40fQceO0ZPVMeV/yCwUnDXXczZpa9CfcGLe9mA5Mrfw/Q==
X-Received: by 2002:a17:90b:68e:: with SMTP id m14mr6827087pjz.228.1608191465881;
        Wed, 16 Dec 2020 23:51:05 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id c6sm5151598pgl.38.2020.12.16.23.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 23:51:05 -0800 (PST)
Date:   Thu, 17 Dec 2020 02:50:42 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in xskq_create
Message-ID: <20201217075042.GA108200@PWN>
References: <0000000000002aca2e05b659af04@google.com>
 <20201216181135.GA94576@PWN>
 <0a6cb67b-c24a-07e3-819b-820f3be9e3cd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a6cb67b-c24a-07e3-819b-820f3be9e3cd@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Björn,

On Thu, Dec 17, 2020 at 08:12:26AM +0100, Björn Töpel wrote:
> On 2020-12-16 19:11, Peilin Ye wrote:
> > I have tested the following diff locally against syzbot's reproducer,
> > and sent a patch to it [1] for testing.  I will send a real patch here
> > tomorrow if syzbot is happy about it.  Please see explanation below.
> 
> Hi Peilin Ye!
> 
> Thanks for taking a look! Magnus has already addressed this problem in
> another patch [1].

No problem!  Oops, I searched for "cfa88ddd0655afa88763" on LKML and
didn't notice Magnus's patch.  I should have searched netdev too.

Thanks,
Peilin Ye

