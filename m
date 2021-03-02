Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD80232B38E
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449713AbhCCECZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376858AbhCBOYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 09:24:51 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF00C06178A
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 06:23:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w9so9265983edt.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 06:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FRuUQq30ioibxh1s4bVwuehg8mtomzSVObPwas+DnIg=;
        b=IT5oSHASkikMtm5+s4mDKYrYKWItV+t92P4VfQoJ5Ou/G7Myg0EVwG+uHQpNNj6Cpm
         bPja5SqMGlNAcU+CwE3v03PJqJR6S0M57k+5OWSfEWx+HECvCSgJBNUAyqPFYgj0bgq+
         h8YhOx9ooxmr8z9nd2TvDMQ+O4BwWl0UvRJF506IVbuw3TvZ+srztEMMoKKF+mStKxVP
         uLLET1eOi2uiZKjYWcLdHKadCi9AhrOl33PsI8bBCMYhwTY+BZX3fMhJLUW/z14Qv+Z7
         5NV8czCy4ASTeDlpewvnTBX8Q5XpQiKu6Zd+w4NNbQV6cJXvpiB773YlH6y43fOxyqFy
         PsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FRuUQq30ioibxh1s4bVwuehg8mtomzSVObPwas+DnIg=;
        b=FJuhJD9NJzvD7PidFaMXX8uz8uuxd/6Ps+s7X3hNrZN6P1YzO/7H3nLVB4BA9TYxt5
         PMiGsxBK9OeRsCqdJFWojnraQ+xlpdR8YA/RE0SP6F6izGZIclQ3nSGW1D2Bw/LJF8xa
         JQYRhzQBCeI9dIUyYfNmdrF6HjvcVq4wzK972lavouG46vGmPidgMKutU1iILOkSseZJ
         SJAcLsldriQAOcIpq5zc8PFAo9kgvCRH71bZuqvHtpiXDGKRSvKYCGZEjc+5I4a7z2UI
         1Q/tlaKo0d1UO4FqOKsDNhCRCb6JzTSD5vrLuRiyhW9leHp6G7aVOg+EkmxOhKH1xR6M
         sPYg==
X-Gm-Message-State: AOAM532Di+U7ibBMhTVERZC3s879+hJe98rB2+g+C2q6N6EuS+qFE9ui
        uRtn8LGX+ifWqjaogP3X0dV4H8+0pls=
X-Google-Smtp-Source: ABdhPJw3mteegPMDsRKGbXh6fddEUQcBDDITsXRT7DkQclbrm5uBo95Lgwv1KjRNXaPARhzFTxhSEg==
X-Received: by 2002:a05:6402:b70:: with SMTP id cb16mr19522696edb.11.1614695033027;
        Tue, 02 Mar 2021 06:23:53 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x17sm18854567edq.42.2021.03.02.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 06:23:51 -0800 (PST)
Date:   Tue, 2 Mar 2021 16:23:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 1/8] ethtool: Add support for configuring
 frame preemption
Message-ID: <20210302142350.4tu3n4gay53cjnig@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122224453.4161729-2-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Fri, Jan 22, 2021 at 02:44:46PM -0800, Vinicius Costa Gomes wrote:
> Frame preemption (described in IEEE 802.3br-2016) defines the concept
> of preemptible and express queues. It allows traffic from express
> queues to "interrupt" traffic from preemptible queues, which are
> "resumed" after the express traffic has finished transmitting.
> 
> Frame preemption can only be used when both the local device and the
> link partner support it.
> 
> Only parameters for enabling/disabling frame preemption and
> configuring the minimum fragment size are included here. Expressing
> which queues are marked as preemptible is left to mqprio/taprio, as
> having that information there should be easier on the user.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

I just noticed that the aMACMergeStatusVerify variable is not exposed in
the PREEMPT_GET command, which would allow the user to inspect the state
of the MAC merge sublayer verification state machine. Also, a way in the
PREEMPT_SET command to set the disableVerify variable would be nice.

Do you still have the iproute2 patch that goes along with this? If you
don't have the time, I might try to take a stab at adding these extra
parameters and resending.
