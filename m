Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A85A36A20
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFFCnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:43:24 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43386 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFFCnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:43:23 -0400
Received: by mail-pg1-f182.google.com with SMTP id f25so426561pgv.10
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wtx/ay8rxT5oBiwe2uyoiL58LmPn8mBpS58ceLCxLn8=;
        b=KqBZba7thrDVTDCtnpYh6BfGTmOi2XTd0Pm7pJIngu8Kj+T1I9x6We4q9CVNten/W1
         6EFsZP0y+kgKeLaK6MlT0TzzchiqbGVZ2FTjHKsbi7QqKIDpChM9lQQnfrxkeLDfOlk/
         H9knxGbW//7pyKq0P9cYQ2lhZmJUeGUXN/GWTOIH64CweiQrI9AiaWDCocU19yzMywA8
         l9Qeg571ME9HsjwiqBll3Nod+ZBbc+xbIe5VjSBF2Xv5KtQ7T7n1Web5kipNTpEUK4/C
         d/xN7vPRXgbVDcK3BbQDcSDUjiFI1Dv4ek+PW2OMKRBskJ++nOqHWDqwQQxrIxRCNSKR
         Kbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wtx/ay8rxT5oBiwe2uyoiL58LmPn8mBpS58ceLCxLn8=;
        b=GK1TBNQu+LcJ7THmzxOnJC6Po2t/oN0hbWwDpZFgENt9lFPan+5FWwbNit00CccL9G
         eMzqCyoxNfBFgow0hb53KcQh6a/gtXTMPTeIy+hVBbAMtA4cQm4bDboRzBtfOOopcPAb
         IdUqX007StlLO+1j25N9maU3lvbqSyP2uwYt6HzBxVWhEn589bAHcuT0LHr9TP9DYJ3I
         spW4GQN4KXDrDET9KFeqr1ByGt8zbX/u3AyGxFmsFiHNrszJoGCRvuRva6zb2ITuL7FU
         oBOL3W1svV8gIr37Wy3jbjaYuZqqJC5UP7ScXkJM//pFUT+7Ea6cn2Kck/yxbguG3x/+
         HflQ==
X-Gm-Message-State: APjAAAV0uvf1kPuAp/BbN7ld0tb5EAe+/cjGCVbcTXqkLP8fzrYLhRyu
        3SNIpJysHfxzWftvnWNRmJ/xFduG
X-Google-Smtp-Source: APXvYqzstIaXWjeWoJrta1vNHr+PphvW04vA125KWSOnDfNi19IvNZG9ynTlI3MXTbWC8hDuI9MSOA==
X-Received: by 2002:a62:b40f:: with SMTP id h15mr44586742pfn.57.1559789003301;
        Wed, 05 Jun 2019 19:43:23 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id k22sm271488pfk.178.2019.06.05.19.43.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 19:43:22 -0700 (PDT)
Date:   Wed, 5 Jun 2019 19:43:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shalom Toledo <shalomt@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190606024320.6ilfk5ur3a3d6ead@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
 <20190605174025.uwy2u7z55v3c2opm@localhost>
 <be656773-93e8-2f95-ad63-bfec18c9523a@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be656773-93e8-2f95-ad63-bfec18c9523a@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 07:28:38PM +0000, Shalom Toledo wrote:
> So, there is an HW machine which responsible for adding UTC timestamp on
> R-SPAN mirror packets and there is no connection to the HW free running
> counter.

If there is no connection, then the frequency adjustments to the HW
clock will not work as expected.

Perhaps the free running counter and the HW clock share the same clock
source?

Thanks,
Richard
