Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9A5306827
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhA0Xlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhA0Xjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:39:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD4FC06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:38:56 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id by1so5168325ejc.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbsGS+8fSk9oKpv5eQrzR/bxp/lKeYvZ0uW8xPdzn2I=;
        b=BLtm+kejR5QiRbCNzeVyb6Lf+3sfQoq0DHy888g8L0nQ2gIgBWlAVx3d2KAiRgAz2+
         YnTBs5BVLDA+k/KBr2q3u14BFqmiEtCgHyjY4S9ycR98LtWk5fvQRi6718oYDetRUP54
         /d/0ymnxj84PZKbsZXkZy+zq9wIs9lwcXadsNV2k+lyBDRhC9pIIqFu/ruDCuZ8Hc413
         WbcmDT80Zpt8mXiXU8le7I4R2HURu/EZBvkKYm/rLEzpoZ33pMWQBXCa0e+MunaFv9oc
         5T5nnbrOcojDJPzKCXAvOsq/5F+9xOgugS+q5IN2YD8ZTQ9eeE9/9aZ2qwJelxyTF00z
         Zucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbsGS+8fSk9oKpv5eQrzR/bxp/lKeYvZ0uW8xPdzn2I=;
        b=dsdxW+Hi3FDN7g1KyOehyeFP1MhvyWVOPQp5AtnL5ilZFbvSp6lO6r0V7OrNl0e3+Q
         tZcxO2Dc1ePzPHZ+lI/Lqk6wdjlJP8r6YqTelSt4TD2AIG6P7thEDfTtwNpKzKEm8Syk
         g0o0qtUS8A11T4LHZwNUo2A6PTv22jhivuC/oHG1vfr45ktwn4TLGhCSTWDLi01NP+zA
         sLWFzw7qwYn73BPUHpn9SUU4yCDribZGA8Y7RIUjPsra/J5aWK6luer2qdvUcb7386d5
         Drm7TEQnN55D1hrQg1XwCRt6RzEJA8xCdkFbpsO3L5nfPLY1iciwamJS3etnVqnFcCYu
         zs3A==
X-Gm-Message-State: AOAM530YLn5NLXxINsT+LuPuu4+G3KDquKxY3IVg2UgiyZ7pyHZA3m/M
        DBvm6ZLnzTLPu/Byv9vYIR8=
X-Google-Smtp-Source: ABdhPJyLU+pK+OwjwKb+ucabp1xgbMFMLqp7Aqcs/Q24D0hj2kW9RpODFo/O1qHp/QDl6N6uarxvJQ==
X-Received: by 2002:a17:906:6d94:: with SMTP id h20mr3703387ejt.231.1611790734898;
        Wed, 27 Jan 2021 15:38:54 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bm9sm1519190ejb.14.2021.01.27.15.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 15:38:54 -0800 (PST)
Date:   Thu, 28 Jan 2021 01:38:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>, tobias@waldekranz.com,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [patch net-next v2] net: dsa: mv88e6xxx: Make global2 support
 mandatory
Message-ID: <20210127233853.xsjj2hfhzviigpmn@skbuf>
References: <20210127003210.663173-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127003210.663173-1-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 01:32:10AM +0100, Andrew Lunn wrote:
> Early generations of the mv88e6xxx did not have the global 2
> registers. In order to keep the driver slim, it was decided to make
> the code for these registers optional. Over time, more generations of
> switches have been added, always supporting global 2 and adding more
> and more registers. No effort has been made to keep these additional
> registers also optional to slim the driver down when used for older
> generations. Optional global 2 now just gives additional development
> and maintenance burden for no real gain.
> 
> Make global 2 support always compiled in.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
