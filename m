Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A017629FFDC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJ3I0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3I0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 04:26:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F363C0613CF;
        Fri, 30 Oct 2020 01:26:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 10so4630018pfp.5;
        Fri, 30 Oct 2020 01:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9sa1bg73D0x099X3MrEdTzCi2bBpnJdmhmD55NwNbw0=;
        b=agaDoT+v7jfXwoJOO28Cnai7r0LKY1ArBtGqfGy8y9XHN8U6Xf0tLlR1+0v3s91vfc
         Sqf9eR7tvBxw+2+L29yncSNtP5ADtA6VGLcojqBBZprmb7XeBV/psXmGQ+iW7+9rXqPp
         Bmt1x4qXQyt35GW0gCVwCmohW8/UWq/uqRtnG9DZC4ix/JWn8fUnZaTG8kA87LxeKPnV
         mAzaDkCPC+kqO39qTVn4HXIFfz/3Joqe++Mmtssn7PlyMzAwTA2HgBJXMn8TgyWIME/7
         zVUFemlAVl/OL7aida5WM/n2OmxRp2NSHG2Xzrq0TLSQ7ArlkFlM1jKFas7BSLYaJRgK
         rmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9sa1bg73D0x099X3MrEdTzCi2bBpnJdmhmD55NwNbw0=;
        b=DCVYOFyiYRuZfNgWfxP6FmGqeSAy0hdmStSBpkjN2kE72vRvCOZrTa22NXvPwu51sO
         k22ZKMU62SjzonWL9xDFMfHVMddFymXnVnilAvkQFLNoZcJwpl35eoVrYz362o9S1BMp
         0fpE/BdxHbV9M7wRJWMTKNuIF3wpMNf28vsKZWx8Z4CSGdVQz0oXq21MtiOEpCi/eltp
         Nk0Tv8xgbYb6USL98MD5IIr4sh6QmZpqGiwT+r9JfcJJHC6x02+ljK7xd6hZ64O27fq5
         rZIm2WRkflM1TScnRu30yng3Sv64LtLQ6zyS7znNHI4UqVjJGAVzTewxqXGM6iyXHbpZ
         Oryw==
X-Gm-Message-State: AOAM532qpH/7bXRBcpX8vjYoKfTVLuLhcu4aNLflBobEF7njktGBtQLj
        Sjom8UULUp4ev9n7HNsKYF6S6b5rJCuD04fl
X-Google-Smtp-Source: ABdhPJyaGbuLtcFpNv5IwLgvwDSH38a0GCWNaCdVWVMSCD+tiAJbsZLxVwXHkBw30k4eLWV7W0phEg==
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr1547383pja.36.1604046408886;
        Fri, 30 Oct 2020 01:26:48 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id t129sm5457071pfc.140.2020.10.30.01.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:26:48 -0700 (PDT)
Message-ID: <ea4f248fc656d9aa470fd0cfaae6b914cbe268ae.camel@gmail.com>
Subject: Re: [PATCH 0/3] mwifiex: disable ps_mode by default for stability
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>, verdre@v0yd.nl
Date:   Fri, 30 Oct 2020 17:26:41 +0900
In-Reply-To: <20201028152115.GT4077@smile.fi.intel.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028152115.GT4077@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 17:21 +0200, Andy Shevchenko wrote:
> On Wed, Oct 28, 2020 at 11:24:30PM +0900, Tsuchiya Yuto wrote:
> > Hello all,
> > 
> > On Microsoft Surface devices (PCIe-88W8897), we are observing stability
> > issues when ps_mode (IEEE power_save) is enabled, then eventually causes
> > firmware crash. Especially on 5GHz APs, the connection is completely
> > unstable and almost unusable.
> > 
> > I think the most desirable change is to fix the ps_mode itself. But is
> > seems to be hard work [1], I'm afraid we have to go this way.
> > 
> > Therefore, the first patch of this series disables the ps_mode by default
> > instead of enabling it on driver init. I'm not sure if explicitly
> > disabling it is really required or not. I don't have access to the details
> > of this chip. Let me know if it's enough to just remove the code that
> > enables ps_mode.
> > 
> > The Second patch adds a new module parameter named "allow_ps_mode". Since
> > other wifi drivers just disable power_save by default by module parameter
> > like this, I also added this.
> > 
> > The third patch adds a message when ps_mode will be changed. Useful when
> > diagnosing connection issues.
> 
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=109681
> 
> Can you attach this to the actual patch as BugLink: tag?
> 

Thanks! Indeed I should have added this... I wrote it in the replies.
If I send the v2 version of this series, I'll add it to them.


