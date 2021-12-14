Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1885A474CCF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhLNUxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhLNUxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:53:44 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F7C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:53:43 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so66466336eda.12
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rr8OSPKunaOkmz+G2k8li4PocXhNhxSsNAGwjtmlMok=;
        b=ks1EKiELTeCfmOfJ71I+sJArl0f5zBBBaox9E9vySnhSD0pzznT1XjILzRDAhT22mm
         KTX6HMP4GeiF3WwfNyinKhQ+9b7m3nJyRyslJszJm0Zj/2GobDhQbgANhGmE7p56hZ/W
         N0vpPFWvA5Mh34v2AeKWwQCBB8tqQ1FhX8veCkxLkdUoVYp4mIbkeC/Or6IN8oJxjp5I
         ZByp+B3lwEJ0kkhrCYu4u80iiVn3HMbY+1BNXzSCB1iZwFKT5cMBetrTMcL1WjY2Ggy7
         WrNbDGJ0YqAOAIJtjZZQcGacgz7UNcJ+djLDyIB8qOqBtZspi4qFUUJ1lTiSbtvcr4Ur
         wQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rr8OSPKunaOkmz+G2k8li4PocXhNhxSsNAGwjtmlMok=;
        b=wMRy6JmXHRQPu1tiG1e6VVqCCea6QZRTa3pVOqyOmGe/1DFUbPOK7SNZLCWwm8Xypo
         nVA/KufzARojB/BX2k3DDuOyAb+A+OI+VZb24XYZ029sBxNeYGSTWij876hxNUIGgfX8
         LQTxUG3xHmmgNRJPCfPGQ+0gUPvXmplbVPYvt8CHC/AEfHrzBBdp4y+KHS1R+BeLeANT
         P6VCxPRNsMkvGTU4YSeLP9j+HcUEM24S67JExj5zIuTGaoDvLSWlipJBfBXB6nihrDhS
         lIYVX1Ju2eVqWBeeSSxjX3EHduFCPRR29KkQtpv4hsDnUtUwuRUpdKCOXP5wr6Udc7y3
         uRHw==
X-Gm-Message-State: AOAM533jIImhXL9I5w/uNDMaScMx0ky6u1NSkgrrLKlu7tkgZwDIey7I
        XeDX9ooEMzzeQfew7i2pHCY=
X-Google-Smtp-Source: ABdhPJzCKt2XaPF3QT1srafm080TJRMdn/RQ3J7kWm4dSo6UYHFHbYHHQ7yBRDmOPav4S2ET9IQqJw==
X-Received: by 2002:a50:fe8e:: with SMTP id d14mr11419969edt.51.1639515222399;
        Tue, 14 Dec 2021 12:53:42 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id c18sm356519edw.2.2021.12.14.12.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 12:53:41 -0800 (PST)
Date:   Tue, 14 Dec 2021 22:53:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] net: dsa: hellcreek: Fix insertion of
 static FDB entries
Message-ID: <20211214205340.mm5xgvkphk4m3y4e@skbuf>
References: <20211214134508.57806-1-kurt@linutronix.de>
 <20211214134508.57806-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214134508.57806-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 02:45:05PM +0100, Kurt Kanzenbach wrote:
> The insertion of static FDB entries ignores the pass_blocked bit. That bit is
> evaluated with regards to STP. Add the missing functionality.
> 
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
