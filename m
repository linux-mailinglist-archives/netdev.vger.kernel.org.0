Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56DA32B3E2
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840265AbhCCEHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbhCCAwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 19:52:32 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E87C061756
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 16:51:16 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id w1so38925614ejf.11
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 16:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ryLp0YPsBnAjcUWFGCHtjNE59ss5r/1p8ASYvWpfQbE=;
        b=q/PMxxGGIJU1SSObQGps6XB0QpdxXOz6MkmI7DuoA5viKHgaRSN1qmyfq0Pg/xNEdW
         cjsMY6gfrZP4xu7t6Sikg6Nkvy2VtrtDTVQCvEQR3zypRJrT+J9VhhijcSwkZDq4VSIK
         8Kw2C1jttgbOZDPxmhJ51+weFFTW93Dg7sunJPe36QenVjVclJVQdiNdq08+Tg9Z8kZA
         Si3PqmT8P0kHU1erknBd+UgJ14vAbjLuwYdt7cK198RGvJ1Fgm5909GCjkaU2/t/E32R
         0P9myucsS7GU0M6drb42uuqvfPG/cdSdmECYuECEk27np3pBMGxsiooKI/zOezMTTt7l
         MUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ryLp0YPsBnAjcUWFGCHtjNE59ss5r/1p8ASYvWpfQbE=;
        b=AT9dB1Xi0f2nbwvhJQf4f3kI+sGAF9esTsgti0O0J85DN5uk1AJW33fyFqqW1A8C6s
         8DsNuoE3vh9C6Gkrpf1rvyXm6pBLcdGToHbj4WO8ldjP6NGs5b+xykehntAT+sbfaWcp
         7lLRtcm8rcYwUcFCtT5e7dSiynnsa1AQgBANBaQzVOTIyy/xM1kew3yCPOTEc26butDe
         u01vLq+P0SsEYAotibx1zw4bPPYzpOTvojyi4rb8/SK9ljWU8ifgW3gZ9SGC7nXhBf2R
         6gKUIKpD08+l4O1WYKpcqtEMvyp0oZ19U1z31Z83KRhUJflCyQwFZqR8Q0+L+uw9Mro1
         Usjw==
X-Gm-Message-State: AOAM533SK4a3NYfJySiqRc/zqa6Xri4niYCxe++bzHN8amVeZ3vPy3Dt
        sHUkeRUc6V/oe+XGTEw/uCw=
X-Google-Smtp-Source: ABdhPJxjLzCYznig/RiqovOx/qEpCOywElvrIFfbtyC5YrFhnTMwdwqzp09o3As41boFO/glNXNaow==
X-Received: by 2002:a17:907:3e8a:: with SMTP id hs10mr14608835ejc.267.1614732673738;
        Tue, 02 Mar 2021 16:51:13 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id b21sm13292564ejv.13.2021.03.02.16.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 16:51:13 -0800 (PST)
Date:   Wed, 3 Mar 2021 02:51:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 1/8] ethtool: Add support for configuring
 frame preemption
Message-ID: <20210303005112.im2zur47553uv2ld@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-2-vinicius.gomes@intel.com>
 <20210302142350.4tu3n4gay53cjnig@skbuf>
 <87o8g1nk6g.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8g1nk6g.fsf@vcostago-mobl2.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 04:40:55PM -0800, Vinicius Costa Gomes wrote:
> Hi Vladimir,
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > Hi Vinicius,
> >
> > On Fri, Jan 22, 2021 at 02:44:46PM -0800, Vinicius Costa Gomes wrote:
> >> Frame preemption (described in IEEE 802.3br-2016) defines the concept
> >> of preemptible and express queues. It allows traffic from express
> >> queues to "interrupt" traffic from preemptible queues, which are
> >> "resumed" after the express traffic has finished transmitting.
> >>
> >> Frame preemption can only be used when both the local device and the
> >> link partner support it.
> >>
> >> Only parameters for enabling/disabling frame preemption and
> >> configuring the minimum fragment size are included here. Expressing
> >> which queues are marked as preemptible is left to mqprio/taprio, as
> >> having that information there should be easier on the user.
> >>
> >> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >> ---
> >
> > I just noticed that the aMACMergeStatusVerify variable is not exposed in
> > the PREEMPT_GET command, which would allow the user to inspect the state
> > of the MAC merge sublayer verification state machine. Also, a way in the
> > PREEMPT_SET command to set the disableVerify variable would be nice.
> >
>
> The hardware I have won't have support for this.

What exactly is not supported, FP verification or the disabling of it?
Does your hardware at least respond to verification frames?

> I am going to send the next version of this series soon. Care to send
> the support for verifyStatus/disableVerify as follow up series?
