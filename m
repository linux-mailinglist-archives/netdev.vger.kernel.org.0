Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE4347A4C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhCXOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbhCXOKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 10:10:51 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3001EC0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 07:10:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w3so33109902ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mYzeyU6rqmhwKSAVy04zEHqMaPwwbOX6WPUATJHaMsM=;
        b=oqpg8kHrLRHhj4ZqNFhGBH8Uto75vwFCbtoWOBUy12tflvT0UQg2Ky4F9z1oS1V8yA
         1toa2Ywoy6w5c1ZYty3OmZ81MF+YX9Nnu0YAj5Yb999W9HUKd+iJC3Okq7YdBF0nYstC
         dhywNhHJGPd9TCU90sHra52Sy4T5At6S/kyZsKaqZkhLy9DFBmBjy+WN16jwx6w4C4PN
         g73nzQEYWCwWP7bvTkO7PkPUX3EUckX0nNWYPyjbyvdfb5BHSevUu7HRpr0EmyKQHbgp
         3VdIIQcqbM0AvZyMY3ghahJR5BK+SzbI0N5xmX905pLcCONqqLBygdu2yD8Mo01klSVs
         8urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mYzeyU6rqmhwKSAVy04zEHqMaPwwbOX6WPUATJHaMsM=;
        b=IrXwsqAPlLq5UOzJK49DuyC70NKeyJW0s2vBddlM8qjOsjVB15UgYXy6uux2WfYBkp
         X1B3F/OzgJCasAhUJkJ2+0RGd+inmw5GayZq7hmWK92B+6Tbn9Wg0PsmqC/lLufDEr7w
         mVqdPFFPu0577OrZ+s+YcCMZnaj9prIOLgG//9Ln0BTDPMJPOzaIPtJbvAEqlttbnwbG
         W3cspA9nPmChbqNZpXAtMgfKTkZwPnrefTnJmiaJXIdMwxHOKUitrrxvIJa/M0lsd0jB
         tj+magcajG60lHYFMMISUqgTQJ6ktXDuKxcK9sHhRPQXdGU2GHk+d+LZWX6FAUcK+ZYP
         M9+w==
X-Gm-Message-State: AOAM53100zTWJEGGsnxxFsJzopPDaobq75k+J71uB6Yt6WmjTDH5ziEm
        l+rTEUtFSG5DdyJO5msm8qY=
X-Google-Smtp-Source: ABdhPJwmgfjB6+8SVV+8Nn8qztAOEWY5q/gWYWktno7XV53RSbQtJ9p6AC+79VJ44r+AtEL1K/kBIQ==
X-Received: by 2002:a17:906:51c3:: with SMTP id v3mr3912276ejk.497.1616595049416;
        Wed, 24 Mar 2021 07:10:49 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id p3sm990504ejd.7.2021.03.24.07.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 07:10:49 -0700 (PDT)
Date:   Wed, 24 Mar 2021 16:10:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210324141047.3ajoylgsysgr7j7j@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
 <20210324140317.amzmmngh5lwkcfm4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324140317.amzmmngh5lwkcfm4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 04:03:17PM +0200, Vladimir Oltean wrote:
> I think there exists an intermediate approach between processing the
> frames on the RX queue and installing a soft parser.

I meant "RX error queue", sorry for the confusion.
