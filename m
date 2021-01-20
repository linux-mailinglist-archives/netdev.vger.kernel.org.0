Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6750F2FD314
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390669AbhATOnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390607AbhATOju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:39:50 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0606C061786
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:38:58 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l23so2322410pjg.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jHKl7M+vR3rHxvhhljyFY/VEVsUnD3jcioB59/dDmYA=;
        b=AAbej4pzgNdWsVySb7grrBM5fHOGx6M4t7f57P8MEQteDsZg2rV5qjWXU3jjzu+mI+
         7Pxbc5nnB0nhd/qhAVlkxKDxjzmmrpoOG37Nje8QUVWySshvyPVxu4Gl7c8Nwv0VgzBk
         qTQUmaR27webr5sUg3dkzRn+eA6E2duvzp4ns7vymUU9eX0m65EwTX+ZP4l52xxnu5VF
         VAPGSIBVJQBVaIe0KbWtv910PPnSL/HeyoelwCy8hIixE/4iOY44s3FEAZdHbrm4yXmt
         N0pTk7XUs02cA5s32WVPWbJqizM4mmfSclBV05Qymf+TGCV9Vuxr7vgxW55k0Aq5ik9W
         NgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jHKl7M+vR3rHxvhhljyFY/VEVsUnD3jcioB59/dDmYA=;
        b=ckwCLNFwxqjAUVUkQeWG0buNJmJtNOlfzW0c5Rm5htI50khbjuVuEZqEDY0V1l8NCS
         krVkiiFj0Koq2JR1VG1Q2rol5suMx1DWqL5sWzvZyYBcccTIMBhKg2pMnVykFbguNBxc
         DpKGVLI2/1eJ7CfSWV7XSo4QCyrSXZRlojghZak/Rpu4MaUC0cqld4lXk0/W2PNgEFaS
         QEO7CzRJELGPSti1uScB5uW1rW5O0fKXgMxVxH8erax7LNLbEQoXAG+5CLRcip24kD9S
         bnEqLA0uKQtwrnUyHJ9GqIphG5Furkm1xlDdgUay9fuTspXAH9tofi3fxyc0kIobWr+b
         KZtw==
X-Gm-Message-State: AOAM531F1sNo6VjPDPYo+Ai7kJ5jInPinWb2WjMtIm88i5AzPJQggqS2
        iicNKaqTWE3FpoBCNNTdc+w=
X-Google-Smtp-Source: ABdhPJzFM+SBTjkzB8jiYgwkJgGI+czkWVAqpTXKj6dY49bBQKdjR51qPswYL1XM+RegIRt5UU8plA==
X-Received: by 2002:a17:902:d909:b029:df:52b4:8147 with SMTP id c9-20020a170902d909b02900df52b48147mr5636743plz.33.1611153538344;
        Wed, 20 Jan 2021 06:38:58 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k64sm2533582pfd.75.2021.01.20.06.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:38:57 -0800 (PST)
Date:   Wed, 20 Jan 2021 22:38:47 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: set link down before enslave
Message-ID: <20210120143847.GI1421720@Leo-laptop-t470s>
References: <20210120102947.2887543-1-liuhangbin@gmail.com>
 <20210120104210.GA2602142@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120104210.GA2602142@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Wed, Jan 20, 2021 at 12:42:10PM +0200, Ido Schimmel wrote:
> > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > index c9ce3dfa42ee..a26fddc63992 100755
> > --- a/tools/testing/selftests/net/rtnetlink.sh
> > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > @@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
> >  	dev20=`ls ${sysfsnet}20/net/`
> >  
> >  	ip link add name test-bond0 type bond mode 802.3ad
> > +	ip link set dev $dev10 down
> > +	ip link set dev $dev20 down
> 
> But these netdevs are created with their administrative state set to
> 'DOWN'. Who is setting them to up?

Would you please point me where we set the state to 'DOWN'? Cause on my
host it is init as UP:

++ ls /sys/bus/netdevsim/devices/netdevsim10/net/
+ dev10=eth3
++ ls /sys/bus/netdevsim/devices/netdevsim20/net/
+ dev20=eth4
+ ip link add name test-bond0 type bond mode 802.3ad
+ ip link show eth3
66: eth3: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 1e:52:27:5f:a5:3c brd ff:ff:ff:ff:ff:ff

# uname -r
5.11.0-rc3+

Thanks
Hangbin
