Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD023C285
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgHEAMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgHEAMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:12:05 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B0CC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 17:12:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id di22so24006899edb.12
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 17:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=To2yhbXWe/noZ+COhMz78hScmYZu/wsBpod+qzeIci4=;
        b=Awk+RGmeP9g6mCrYN0f7qchQcNsb5hm7sBpV0Rv4dnlIATuDL5/Ql1unrKIuB2Ptq/
         dq0Z6TxJvxhCF6iA5vDSeDF9nu2+NrzW61+ihlYPFe68bOIe2uX8delcx0hcwNPGmI/N
         9VgfuKDLX0b0+W3Ds2XU4LNC/ILtUWJmMQzzRR+/I+LfYFGGtugyecG4/kB0alOHMPCh
         goez1SVU5q2BEft90SpCiTmeCQ6g4YMm3PHY1KBo7MhTqrWPPvDtyDrcCkFz/ayxEWAm
         GSRN77Ly5V7OBAnJJgGJzHlz6JJ0Ukr+Kuk6y3d6jQnb9EP3Q1sgCoW4by/mU0+LEAK1
         UXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=To2yhbXWe/noZ+COhMz78hScmYZu/wsBpod+qzeIci4=;
        b=iHiOlaR/18KjjUXrzx4N8pGzXOPka8cxumiQn1PcOGHv7xFpq+Aq/Lxqn4PpcbQAer
         lTR4UzTMg2gLbQWFjEAoVDnKmFwJKoXoqCzcBgZ11ZZlVeB22BUZMoqAussnedeseSpg
         iLUtphn50YUK1RmCoWvFKgwNypFtdySQgVTcnx7eoHdN1zHyEfevH4X7VBh0xJQ/vD+g
         IoXS0Fay4++oI7ueFwQdw+X2VF/S+szYs5Nxe76g2kE75Q79Y9re7SWA/uuLHy7QpHfZ
         otGhyAZN6lUFN8kn43uwtMRT2W38fakeYZ3LuBZ0Jy1aG72reOo7MHh/InQOQgGQAGuZ
         GVMQ==
X-Gm-Message-State: AOAM531Q8mTue7NbprbG656qcQNkplle3RP1Kg/ApZSNuYju3xqExfoZ
        rPbWTFCFV+fi3RIEsUgq1e8=
X-Google-Smtp-Source: ABdhPJzGmGo4hVgp4N/WY3nd7t9HzRMJ+JwJopq0ualvFPzKUXHIONHyah7lUi4K93XC24ONCR48RA==
X-Received: by 2002:a50:f10c:: with SMTP id w12mr430898edl.202.1596586323504;
        Tue, 04 Aug 2020 17:12:03 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id m6sm310349ejq.85.2020.08.04.17.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 17:12:03 -0700 (PDT)
Date:   Wed, 5 Aug 2020 03:12:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: Re: [PATCH v2 net-next] ptp: only allow phase values lower than 1
 period
Message-ID: <20200805001201.v7idope4zidyi6st@skbuf>
References: <20200804234308.1303022-1-olteanv@gmail.com>
 <cc1465fd-2696-f73b-85c2-7f6132f6623d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc1465fd-2696-f73b-85c2-7f6132f6623d@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 05:04:47PM -0700, Jacob Keller wrote:
> 
> A nit: this could read "therefore anything equal or larger than 1 period
> is invalid"? a number modulo itself is 0, right? and we use ">=" below
> as well now.
> 

Thanks, I've corrected that too, now.

-Vladimir
