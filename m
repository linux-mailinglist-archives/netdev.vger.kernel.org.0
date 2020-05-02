Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899FD1C236E
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 07:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgEBF6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 01:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726468AbgEBF6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 01:58:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7791AC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 22:58:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o27so9011502wra.12
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 22:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bCfLkCNhN2DbSrrnF7aqzGzYRxHe/z2O6zUH9lIxRQ0=;
        b=gyIBD2oKGCcTT/F/plffhnnL6eFrnyNVJijP2exT3ZEqkFHeqFqb+rhzc+5qjbP1RR
         t3wHNb8hC6mPd0FwDD6o8UfGWJt6LxNO2VFXarO1jru6KBY/Llnsi9jmvDJe7utN9QiB
         g7C5afIEWt5VmLNBTjB/jWKwjJe2iNLVSp3EykcaNjwof2axmMudluvf8mF6+wm8fvUL
         egtHHe8oqsoQBxnBkZZn305ws41/FxUhnDtkp4PGqmQdSPcBMsExuGOcL9aLmI7f07jy
         7ZHApQN+pvspXAxwOExIrJqK8WIgrZLgvNDkO3ISyYuXtkD9SiiscJ+vfDI/ZhfhvJvt
         7jmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bCfLkCNhN2DbSrrnF7aqzGzYRxHe/z2O6zUH9lIxRQ0=;
        b=ebO33w0aOnrM0/8jwmBE2BnLliiGVPoqKxv44UlyxoVBY9PBMbmWPnJrIuWUALbf32
         gst6+QGCoe567wOkyG9cQrCwmM10s7bt2JtjPDvXWSz6IPE5xO5lYPdyzCGCfq/1Bypy
         lXTWrRqmJQN+1Wq05+3DXcRyHKYCmVVBHD+qob+REsQZRD1Hjj/4yWqvuYi40/yCGW62
         EED+XyoLrHdexQpmk8oPdYJy++s07BLJBnvV5s/2QUHf2SffcsDqRxP+j/IMumhuwZPh
         d2A/9NbSa6Qv/7kbNTkk+GdViCiqxAM7/iWV753B5Vr+EZKTt3bV0oBum88J3iiDosdP
         6MvQ==
X-Gm-Message-State: AGi0Puau9k4OME7LG/An4LbZvATHRVESTQioEq3+NSK7az56soiDYAOK
        75b6gmufSEqaybwvPq1EV8t78w==
X-Google-Smtp-Source: APiQypKBH5VK8AdJPjlVC+ImwwmMwwgIxYVaQ0qjvuU9B/FRDY/XrhCjfInO8LxDE369HZstUadyxw==
X-Received: by 2002:adf:ce02:: with SMTP id p2mr7624227wrn.173.1588399122189;
        Fri, 01 May 2020 22:58:42 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h1sm2721071wme.42.2020.05.01.22.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 22:58:41 -0700 (PDT)
Date:   Sat, 2 May 2020 07:58:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot
 id allocation
Message-ID: <20200502055840.GB25211@nanopsycho.orion>
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430175759.1301789-5-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 30, 2020 at 07:57:59PM CEST, kuba@kernel.org wrote:
>Make ID argument optional and read the snapshot info
>that kernel sends us.
>
>$ devlink region new netdevsim/netdevsim1/dummy
>netdevsim/netdevsim1/dummy: snapshot 0
>$ devlink -jp region new netdevsim/netdevsim1/dummy
>{
>    "regions": {
>        "netdevsim/netdevsim1/dummy": {
>            "snapshot": [ 1 ]
>        }
>    }
>}
>$ devlink region show netdevsim/netdevsim1/dummy
>netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]
>
>v3: back to v1..
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
