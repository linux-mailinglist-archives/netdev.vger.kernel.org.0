Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBBA33F27B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhCQOWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhCQOWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:22:38 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A33FC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:22:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y6so2513268eds.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yOpIqEAfSRZrLABrNDeiUveEabxy9xI1ANrOWhtkVNg=;
        b=b5AeDm9ryrWVuQTFIE3GGAcVUc76YKlHgQOWEZglMHj6Lon5a85FzxZHk7bEQ25+4Y
         e66EBgurPNquioIOwvbn5CUkAfVorqfySRFrAudL2nHj9hO+n3CdBPTlpa4NM6sAUUFp
         k1woQsydPjcjTl1klky4hhEecgJLuZ4d7bXePF8y4y1dx5AMwv+j0kyipfFd5Ptk/K/9
         a7xrt4TStc/L91cJ7B3JLqQtC2vcLDUOK9Xi3XFjwefJdZclPOugCorAlhQdspEIBjL9
         SCAPXVk2lJKD1Sl8q4YTa9EstIP9zYvyN/5muejBqyZgItkNoDcTNN/JdOGDg9tXEGpv
         yiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yOpIqEAfSRZrLABrNDeiUveEabxy9xI1ANrOWhtkVNg=;
        b=oCEkb6zvTl6crir301uvtLq2NLA94XiTG2MgDqqqmMW+Ral/RyLlxmWEZ5/Im7uyST
         6mJiFHr7/yGUSvEM7+/tFBV5n71j3KW5cJZiPJf+uskT+sPPRyw9RMkHJ3Ift6pCFgOY
         U5EB3cHgPD3t8ojmDokINhQM8ZtJBOGuzw5F0o5XwIbTpGYW2poOhPK+PIcTfRGOaIVi
         x/sXoKSvj1l8U+G/WynILRVbGoHy6xkT0QfnHi3GMOoG82Dp2SaAKY2Mbl0QDYg9FyGT
         vJ8CF1ynK0BitItk5xTRns8PMje95Eljq7Y56UnggAOpgtG2tx31d53XrQGo9v90J5A5
         z4bw==
X-Gm-Message-State: AOAM533cO2KqERTl751HG+sie3GrYArrPC5pb5PFZf63P7mm3ntMh0Ml
        8PsZVWDMvteS/ygLfvR4c1vUoWNHwe4=
X-Google-Smtp-Source: ABdhPJyWvtNpnogjGyU8OxKSZsKpW5zwt4olc3vEVOyehHJEXo5jzpc9HAm6Gq6QfqA4pcjDK8cPpA==
X-Received: by 2002:a50:ed90:: with SMTP id h16mr42580090edr.101.1615990957062;
        Wed, 17 Mar 2021 07:22:37 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m7sm12488283edp.81.2021.03.17.07.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:22:36 -0700 (PDT)
Date:   Wed, 17 Mar 2021 16:22:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net-next v17 2/4] net: dsa: mv88e6xxx: wrap
 .set_egress_port method
Message-ID: <20210317142235.jgkv2q3743wb47wt@skbuf>
References: <20210317134643.24463-1-kabel@kernel.org>
 <20210317134643.24463-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317134643.24463-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 02:46:41PM +0100, Marek Behún wrote:
> There are two implementations of the .set_egress_port method, and both
> of them, if successful, set chip->*gress_dest_port variable.
> 
> To avoid code repetition, wrap this method into
> mv88e6xxx_set_egress_port.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
> ---

Separately from this series, do you think you can rename the
"egress_port" into "monitor_port" across the driver? Seeing an
EGRESS_DIR_INGRESS is pretty strange.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
