Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7037C3CE854
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355897AbhGSQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351183AbhGSQg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:56 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305E0C078822
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:51:33 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id q190so17408147qkd.2
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J7n4O5wFGVI4J/P1va91lXDXOLVaQMe6Ho2hTxrfqfo=;
        b=QmpUd98wahK+lVBLyaS6dSuMTQ1i/PEGMxqqFBhruuAIjF04UajuOeF7SCxgl/CVLY
         IkDbxr5Vqc1q4V2uKPlLGsEt3mn8rdOWpzXZUNcJo7TDScObP+bohD//TTOOr0v4z7yY
         dt3xTxDggdyb3yPZLWcQOhrbhrjNAd+IpdkPviW5k8jYbr+EQt/tzXEtqCNfudZgdcuQ
         0F477yWiES3rLfApLjifNWfLqLi5z8MDiV77PpxmSb2ajdfXUq/j4s+hyVtvFxQjwRAh
         Cdd/yENOs2OziI8ZIfYoX5UAaUx+N2XaXsT8CfShcvwH6JzjqsP/DhvO39EUGIjlvUmT
         bc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J7n4O5wFGVI4J/P1va91lXDXOLVaQMe6Ho2hTxrfqfo=;
        b=EVuqB7wvWa4q/XZT4lz6/iEX21AT40O4NLAKuk656Cqif6Wtpf1SpTVxse45tJFDEq
         IN44P2J8xUeWDk0e11IZokYKOZB3vcgCSDnHI/GnOlzT3n/S1wjLMvnY1KNCtrTTvlDI
         zV6Is+PUgapwGo1CVwWYNRJU74tFRxHzv+Ef3d3P9BYhcgfHf8yQF5s1RatSm9jEJpm+
         Mgw2iePbf8IRhTUe8oAhwLSBLFjqH9Xt2wTv0BaSr9AVzFdp5QJ98lkDDxBsaRdmb2Al
         4gKOGmrZYMXHN2BDAuRtkgHq3OMQUVW7Cv2tVw2Sh2QmgKhgzkAUPPvzhBQNiyIWBEpP
         15tw==
X-Gm-Message-State: AOAM531pCNp2L5tBLXJiB+qCM0FMC/6iHVCT2O3KkfcYGVYCbFAoKVmc
        vICk/82AH0utC4FKx60YO8E=
X-Google-Smtp-Source: ABdhPJxrqnxkd9/M+8WbxOkPQ4yyN3dxf5boOg52XkHLLSgWgw4NI1OoL6XvPl+vhxdRzOaa3SuQEg==
X-Received: by 2002:a37:660b:: with SMTP id a11mr25004484qkc.395.1626714698516;
        Mon, 19 Jul 2021 10:11:38 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:194:8382:2ab0:871:9ac6:c7bd:f923])
        by smtp.gmail.com with ESMTPSA id n124sm754055qkf.119.2021.07.19.10.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:11:38 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:11:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Message-ID: <20210719171135.GD5568@hoboy.vegasvil.org>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
 <YPWMHagXlVCgpYqN@lunn.ch>
 <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
 <20210719171006.GC5568@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719171006.GC5568@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 10:10:06AM -0700, Richard Cochran wrote:
> On Mon, Jul 19, 2021 at 02:45:06PM +0000, Ruud Bos wrote:
> > Do I need to resend again?
> 
> No need, this time I saw it.

Actually, on second thought, please resend.

I have the cover letter, but not the patches.

Thanks,
Richard
