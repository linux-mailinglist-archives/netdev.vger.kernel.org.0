Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C39F31B8D2
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 13:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBOMO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 07:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhBOMO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 07:14:26 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC05C061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 04:13:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y10so2876659edt.12
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 04:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YXcvh66TB5pNy67FbYGBA3NH3GGZg4IBtY2ttm/3N40=;
        b=pxlad2LSKKDgYxFJie3h5diKfoO7MPVuEo4X4maoyNY6OFAvOW18fF3Tmz9f8m7i5C
         R6eYOcIAacoKWOBgR5VrEBYxb2dkj1m3iKjcXVGB4JAr+Y/eEI/fm69Sv/ZXTtlSi4yq
         p4FtDC1Sxu2LoR39Z244s/lBh4p/7eFmczkyfVaJZFYqx0kz/s2/5SbuVFRHRenszdlF
         Owfh/F5dCyMHpaDBh99WCFG9lolq2lUoMkMPXGxL3BxdDsWZ9LEzFp7kGTPMKj5OJWa5
         9y5Mek7ISj8olTucdCUdvGg038A3yaJ617g0YaZVOPE0jCdqWrOcK4wCvNJXOctFTpLJ
         M+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YXcvh66TB5pNy67FbYGBA3NH3GGZg4IBtY2ttm/3N40=;
        b=soA3n3zJ/gebR5jzpE29P4902Q2M0RGNIEuh30f4jGq1jQnny09xQcQEtx5R/7wKRA
         sOdHsONcjd60VGvLOD0InHcolmwE5hVDU0cdca7BbC/QtHsKvytMMuQfva/2UuEpmtcw
         YXeplF4Ruyo3gG3KTTFcx6rn3m7G9v7CDP+9fBTxlLOhRFSNdF8D5rcJ5loSXkPEq95r
         xbY4XYrCjKTRa2a2gBmh3Bzpb8/rTvnBGucNgnF/J8MSVMKEXpxi0dhUsXVh8vIb+C/B
         KSiqF2d2+ipALP5UrCvak0ovEiOQCeKhpc4mz+vk1VL2VKpxhf1iRRPJF3olw8oJqv/W
         oX9g==
X-Gm-Message-State: AOAM530o7S8DfM15kE6qnUXxma+7fUzv0z2jzixIRHD0978oTNQu1Z8Q
        N1HXvyAPi+3/3fh0n3TSIZI=
X-Google-Smtp-Source: ABdhPJxAw0Xpzny0ouYTvjgurUHIL+Q8TZr1QQMTLj3lFssXw9uPOHcU8KUZJHF4NV8ftadYEQqvFg==
X-Received: by 2002:aa7:c555:: with SMTP id s21mr32759edr.43.1613391224304;
        Mon, 15 Feb 2021 04:13:44 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x42sm10256486ede.64.2021.02.15.04.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 04:13:43 -0800 (PST)
Date:   Mon, 15 Feb 2021 14:13:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 5/6] man8/bridge.8: explain self vs master for
 "bridge fdb add"
Message-ID: <20210215121342.driolhmaow7ads5g@skbuf>
References: <20210211104502.2081443-1-olteanv@gmail.com>
 <20210211104502.2081443-6-olteanv@gmail.com>
 <65b9d8b6-0b04-9ddc-1719-b3417cd6fb89@linux.ibm.com>
 <20210215103224.zpjhi5tiokov2gvy@skbuf>
 <5530c6b8-4824-64da-f5a9-f8a790c46c3b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5530c6b8-4824-64da-f5a9-f8a790c46c3b@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 11:53:42AM +0100, Alexandra Winter wrote:
> Actually, I found your first (more verbose) proposal more helpful.

Sorry, I don't understand. Do you want me to copy the whole explanation
from bridge fdb add to bridge link set?

> >> Maybe I misunderstand this sentence, but I can do a 'bridge fdb add' without 'self'
> >> on the bridge device. And the address shows up under 'bridge fdb show'.
> >> So what does mandatory mean here?
> >
> > It's right in the next sentence:
> >
> >> The flag is set by default if "master" is not specified.
> >
> > It's mandatory and implicit if "master" is not specified, ergo 'bridge
> > fdb add dev br0' will work because 'master' is not specified (it is
> > implicitly 'bridge fdb add dev br0 self'. But 'bridge fdb add dev br0
> > master' will fail, because the 'self' flag is no longer implicit (since
> > 'master' was specified) but mandatory and absent.
> >
> > I'm not sure what I can do to improve this.
> >
> Maybe the sentence under 'master':
> " If the specified
> +device is a master itself, such as a bridge, this flag is invalid."
> is sufficient to defien this situation. And no need to explain mandatory implicit defaults
> in the first paragraph?

I don't understand this either. Could you paste here how you think this
paragraph should read?
